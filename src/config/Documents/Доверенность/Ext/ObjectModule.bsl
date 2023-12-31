﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	ДатаДействия = Дата + 10 * (24 * 60 * 60);
	ВидОперации = Перечисления.ВидыОперацийДоверенность.Доверенность;	
	УчетДенежныхСредствБП.УстановитьБанковскийСчет(СтруктурнаяЕдиница, Организация, 
		ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());







	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата          = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	ДатаДействия  = Дата + 10 * (24 * 60 * 60);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	

	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПоставщика") Тогда

		Организация        = Основание.Организация;
		ДоговорКонтрагента = Основание.ДоговорКонтрагента;
		Контрагент         = Основание.Контрагент;
		Сделка 			   = Основание;
		ВидОперации		   = Перечисления.ВидыОперацийДоверенность.Доверенность;
		
		НаПолучениеОт = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "НаименованиеПолное");
		ПоДокументу = Документы.Доверенность.ПолучитьТекстПоДокументу(Сделка);
		
		ЗаполнитьТоварыПоСчету(Основание);

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда

		Организация        = Основание.Организация;
		ДоговорКонтрагента = Основание.ДоговорКонтрагента;
		Контрагент         = Основание.Контрагент;
		Сделка 			   = Основание;
		ВидОперации		   = Перечисления.ВидыОперацийДоверенность.Доверенность;
		
		НаПолучениеОт = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "НаименованиеПолное");
		ПоДокументу = Документы.Доверенность.ПолучитьТекстПоДокументу(Сделка);
		
		ЗаполнитьТоварыПоВозврату(Основание);

	КонецЕсли;
	
КонецПроцедуры

Функция НайтиСоздатьЕдиницу(Код, Наименование, НаименованиеПолное) Экспорт

	ЕдиницаСсылка = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду(Код);

	Если ЕдиницаСсылка.Пустая() Тогда
		СправочникОбъект = Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент();

		СправочникОбъект.Код                       = Код;
		СправочникОбъект.Наименование              = Наименование;
		СправочникОбъект.НаименованиеПолное        = НаименованиеПолное;

		СправочникОбъект.Записать();

		ЕдиницаСсылка = СправочникОбъект.Ссылка;
	КонецЕсли;

	Возврат ЕдиницаСсылка;

КонецФункции

// Процедура выполняет заполниение табличной части по счету на оплату поставщику.
//
Процедура ЗаполнитьТоварыПоСчету(Основание)

	Товары.Очистить();

	// Оборудование
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Основание", Основание);
    Запрос.УстановитьПараметр("ПустаяЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Номенклатура                         КАК Номенклатура,
	|	ВЫБОР КОГДА Док.ЕдиницаИзмерения = &ПустаяЕдиницаИзмерения ТОГДА Номенклатура.БазоваяЕдиницаИзмерения ИНАЧЕ ЕдиницаИзмерения КОНЕЦ  КАК Единица,
	|	Док.Количество                           КАК Количество
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.Оборудование КАК Док
	|ГДЕ
	|	Док.Ссылка = &Основание И Док.Количество > 0
	|";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка          = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		НаименованиеТовара = Выборка.Номенклатура.НаименованиеПолное;
		НаименованиеТовара = ?(НЕ ЗначениеЗаполнено(НаименованиеТовара), Выборка.Номенклатура.Наименование, НаименованиеТовара);

		СтрокаТабличнойЧасти                         = Товары.Добавить();
		СтрокаТабличнойЧасти.НаименованиеТовара      = НаименованиеТовара;
		СтрокаТабличнойЧасти.Количество              = Выборка.Количество;
		СтрокаТабличнойЧасти.ЕдиницаПоКлассификатору = Выборка.Единица;

	КонецЦикла;

	// Товар
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Основание", Основание);
    Запрос.УстановитьПараметр("ПустаяЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Номенклатура                         КАК Номенклатура,
	|	ВЫБОР КОГДА Док.ЕдиницаИзмерения = &ПустаяЕдиницаИзмерения ТОГДА Номенклатура.БазоваяЕдиницаИзмерения ИНАЧЕ ЕдиницаИзмерения КОНЕЦ  КАК Единица,
	|	Док.Количество                           КАК Количество
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка = &Основание И Док.Количество > 0
	|";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка          = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		НаименованиеТовара = Выборка.Номенклатура.НаименованиеПолное;
		НаименованиеТовара = ?(НЕ ЗначениеЗаполнено(НаименованиеТовара), Выборка.Номенклатура.Наименование, НаименованиеТовара);

		СтрокаТабличнойЧасти                         = Товары.Добавить();
		СтрокаТабличнойЧасти.НаименованиеТовара      = НаименованиеТовара;
		СтрокаТабличнойЧасти.Количество              = Выборка.Количество;
		СтрокаТабличнойЧасти.ЕдиницаПоКлассификатору = Выборка.Единица;

	КонецЦикла;

	// Возвратная тара
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Основание", Основание);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Номенклатура                         КАК Номенклатура,
	|	Док.Номенклатура.БазоваяЕдиницаИзмерения КАК Единица,
	|	Док.Количество                           КАК Количество
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.ВозвратнаяТара КАК Док
	|ГДЕ
	|	Док.Ссылка = &Основание И Док.Количество > 0
	|";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка          = РезультатЗапроса.Выбрать();

	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = Локализация.КодЯзыкаИнформационнойБазы();
	Пока Выборка.Следующий() Цикл

		НаименованиеТовара = Выборка.Номенклатура.НаименованиеПолное;
		НаименованиеТовара = ?(НЕ ЗначениеЗаполнено(НаименованиеТовара), Выборка.Номенклатура.Наименование, НаименованиеТовара);

		СтрокаТабличнойЧасти                         = Товары.Добавить();
		СтрокаТабличнойЧасти.НаименованиеТовара      = НаименованиеТовара + НСтр("ru=' (возвратная тара)';uk=' (зворотна тара)'",КодЯзыкаПечать);
		СтрокаТабличнойЧасти.Количество              = Выборка.Количество;
		СтрокаТабличнойЧасти.ЕдиницаПоКлассификатору = Выборка.Единица;

	КонецЦикла;

	// НМА
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("Штука", 	   НайтиСоздатьЕдиницу("2009", "шт", "Штука"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.НематериальныйАктив КАК Номенклатура,
	|	1 						КАК Количество,
	|	&Штука 					КАК Единица
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.НематериальныеАктивы КАК Док
	|ГДЕ
	|	Док.Ссылка = &Основание
	|";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка          = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		НаименованиеТовара = Выборка.Номенклатура.НаименованиеПолное;
		НаименованиеТовара = ?(НЕ ЗначениеЗаполнено(НаименованиеТовара), Выборка.Номенклатура.Наименование, НаименованиеТовара);

		СтрокаТабличнойЧасти                         = Товары.Добавить();
		СтрокаТабличнойЧасти.НаименованиеТовара      = НаименованиеТовара;
		СтрокаТабличнойЧасти.Количество              = Выборка.Количество;
		СтрокаТабличнойЧасти.ЕдиницаПоКлассификатору = Выборка.Единица;

	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТоварыПоОстаткам()

// Процедура выполняет заполниение табличной части по возврату товаров от покупателя.
//
Процедура ЗаполнитьТоварыПоВозврату(Основание)

	Товары.Очистить();

	// Товар
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Основание", Основание);
    Запрос.УстановитьПараметр("ПустаяЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Номенклатура                         КАК Номенклатура,
	|	ВЫБОР КОГДА Док.ЕдиницаИзмерения = &ПустаяЕдиницаИзмерения ТОГДА Номенклатура.БазоваяЕдиницаИзмерения ИНАЧЕ ЕдиницаИзмерения КОНЕЦ  КАК Единица,
	|	Док.Количество                           КАК Количество
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка = &Основание И Док.Количество > 0
	|";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка          = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		НаименованиеТовара = Выборка.Номенклатура.НаименованиеПолное;
		НаименованиеТовара = ?(НЕ ЗначениеЗаполнено(НаименованиеТовара), Выборка.Номенклатура.Наименование, НаименованиеТовара);

		СтрокаТабличнойЧасти                         = Товары.Добавить();
		СтрокаТабличнойЧасти.НаименованиеТовара      = НаименованиеТовара;
		СтрокаТабличнойЧасти.Количество              = Выборка.Количество;
		СтрокаТабличнойЧасти.ЕдиницаПоКлассификатору = Выборка.Единица;

	КонецЦикла;

	// Возвратная тара
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Основание", Основание);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Номенклатура                         КАК Номенклатура,
	|	Док.Номенклатура.БазоваяЕдиницаИзмерения КАК Единица,
	|	Док.Количество                           КАК Количество
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя.ВозвратнаяТара КАК Док
	|ГДЕ
	|	Док.Ссылка = &Основание И Док.Количество > 0
	|";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка          = РезультатЗапроса.Выбрать();

	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = Локализация.КодЯзыкаИнформационнойБазы();
	Пока Выборка.Следующий() Цикл

		НаименованиеТовара = Выборка.Номенклатура.НаименованиеПолное;
		НаименованиеТовара = ?(НЕ ЗначениеЗаполнено(НаименованиеТовара), Выборка.Номенклатура.Наименование, НаименованиеТовара);

		СтрокаТабличнойЧасти                         = Товары.Добавить();
		СтрокаТабличнойЧасти.НаименованиеТовара      = НаименованиеТовара + НСтр("ru=' (возвратная тара)';uk=' (зворотна тара)'",КодЯзыкаПечать);
		СтрокаТабличнойЧасти.Количество              = Выборка.Количество;
		СтрокаТабличнойЧасти.ЕдиницаПоКлассификатору = Выборка.Единица;

	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТоварыПоОстаткам()


#КонецЕсли

