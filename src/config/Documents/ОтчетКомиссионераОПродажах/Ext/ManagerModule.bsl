﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСчетаУчетаРасчетов(СчетаУчета = Неопределено, Перезаполнять = Истина, Объект) Экспорт

	Если СчетаУчета = неопределено Тогда
		СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента);
	КонецЕсли;
	Объект.СчетУчетаРасчетовСКонтрагентом          = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаРасчетовСКонтрагентом),
													СчетаУчета.СчетРасчетовПокупателя, Объект.СчетУчетаРасчетовСКонтрагентом);
	Объект.СчетУчетаРасчетовПоАвансамПолученным	= ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаРасчетовПоАвансамПолученным),
													СчетаУчета.СчетАвансовПокупателя, Объект.СчетУчетаРасчетовПоАвансамПолученным);
	Объект.СчетУчетаРасчетовЗаПосредническиеУслуги = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаРасчетовЗаПосредническиеУслуги),
													СчетаУчета.СчетРасчетов, Объект.СчетУчетаРасчетовЗаПосредническиеУслуги);
	Объект.СчетУчетаРасчетовПоАвансамВыданным      = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаРасчетовПоАвансамВыданным),
													 ?(Объект.УдержатьВознаграждение, Объект.СчетУчетаРасчетовСКонтрагентом, СчетаУчета.СчетАвансов), Объект.СчетУчетаРасчетовПоАвансамВыданным);
	Объект.НалоговоеНазначение                     = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.НалоговоеНазначение),
													СчетаУчета.НалоговоеНазначениеПриобретений, Объект.НалоговоеНазначение);

	Объект.СчетУчетаНДСПродаж                      = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаНДСПродаж),
													СчетаУчета.СчетУчетаНДСПродаж, Объект.СчетУчетаНДСПродаж);
	Объект.СчетУчетаНДСПродажПодтвержденный        = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаНДСПродажПодтвержденный),
													СчетаУчета.СчетУчетаНДСПродажПодтвержденный, Объект.СчетУчетаНДСПродажПодтвержденный);
	Объект.СчетУчетаНДСПриобретений                = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаНДСПриобретений),
													СчетаУчета.СчетУчетаНДСПриобретений, Объект.СчетУчетаНДСПриобретений);
	Объект.СчетУчетаНДСПриобретенийПодтвержденный  = ?(Перезаполнять ИЛИ НЕ ЗначениеЗаполнено(Объект.СчетУчетаНДСПриобретенийПодтвержденный),
													СчетаУчета.СчетУчетаНДСПриобретенийПодтвержденный, Объект.СчетУчетаНДСПриобретенийПодтвержденный);

КонецПроцедуры

// Заполняет счета учета номенклатуры в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Реализация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.Реализация = Истина;
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре);
	КонецЦикла;

КонецПроцедуры

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - структура сведений о номенклатуре, либо стуктура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре) Экспорт

	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		// СведенияОНоменклатуре - структура сведений номенклатуры
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчетаБУ") Тогда
		// СведенияОНоменклатуре - структура счетов учета номенклатуры
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ИмяТабличнойЧасти = "Товары" Тогда
		Если ЗначениеЗаполнено(СчетаУчета.СчетПередачиБУ) Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетПередачиБУ;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.СхемаРеализации) Тогда
			СтрокаТабличнойЧасти.СхемаРеализации = СчетаУчета.СхемаРеализации;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначениеДоходовИЗатрат) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначениеДоходовИЗатрат = СчетаУчета.НалоговоеНазначениеДоходовИЗатрат;
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Отчет комиссионера
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru='Отчет комиссионера';uk='Звіт комісіонера'");
	КомандаПечати.Картинка = БиблиотекаКартинок.Печать;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Отчет комиссионера о продажах""';uk='Реєстр документів ""Звіт комісіонера про продажі""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры

Функция ПечатьОтчетаКомиссионера(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)

	УстановитьПривилегированныйРежим(Истина);
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Артикул";
		ТекстКодАртикул = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Код";
		ТекстКодАртикул = "Код";
	Иначе
		ВыводитьКоды    = Ложь;
		Колонка         = "";
		ТекстКодАртикул = "Код";
	КонецЕсли;

	Если ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	КонецЕсли;
	
	ЗапросШапка = Новый Запрос;
	ЗапросШапка.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	ДоговорКонтрагента.Дата  		КАК ДоговорДата,
	|	ДоговорКонтрагента.Номер 		КАК ДоговорНомер,
	|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,
	|	Ответственный.ФизическоеЛицо.Наименование КАК Отпустил,
	|	Организация,
	|	Контрагент КАК Покупатель,
	|	Организация КАК Поставщик,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	СуммаВключаетНДС,
	|	СделкаПоРеализации КАК Сделка
	|ИЗ
	|	Документ.ОтчетКомиссионераОПродажах КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент";


	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОтчетКомиссионераОПродажах_Накладная";

	ЗапросТЧТовары = Новый Запрос;
	ЗапросТЧТовары.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
				   |	ВложенныйЗапрос.Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	               |	ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК Товар,
	               |	ВложенныйЗапрос.Количество,
	               |	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
				   |	ВложенныйЗапрос.Цена,
	               |	ВложенныйЗапрос.Сумма,
	               |	ВложенныйЗапрос.СуммаНДС,
				   |	ВложенныйЗапрос.Вознаграждение,
	               |	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ЗаказПокупателя.Номенклатура КАК Номенклатура,
	               |		ЗаказПокупателя.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
				   |		ЗаказПокупателя.Цена КАК Цена,
				   |		СУММА(ЗаказПокупателя.Количество) КАК Количество,
				   |		СУММА(ЗаказПокупателя.Сумма) КАК Сумма,
	               |		СУММА(ЗаказПокупателя.СуммаНДС) КАК СуммаНДС,
				   |		СУММА(СуммаВознаграждения) КАК Вознаграждение,
				   |		МИНИМУМ(ЗаказПокупателя.НомерСтроки) КАК НомерСтроки
	               |	ИЗ
	               |		Документ.ОтчетКомиссионераОПродажах.Товары КАК ЗаказПокупателя
	               |	
	               |	ГДЕ
	               |		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ЗаказПокупателя.Номенклатура,
				   |		ЗаказПокупателя.ЕдиницаИзмерения,
	               |		ЗаказПокупателя.Цена,
				   |		ЗаказПокупателя.СтавкаНДС) КАК ВложенныйЗапрос
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки";
    
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетКомиссионераОПродажах.ПФ_MXL_Накладная");
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ЗапросШапка.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Шапка = ЗапросШапка.Выполнить().Выбрать();
		Шапка.Следующий();

		ЗапросТЧТовары.УстановитьПараметр("ТекущийДокумент", Ссылка);
		ЗапросТовары = ЗапросТЧТовары.Выполнить().Выгрузить();
		
		УчитыватьНДС = УчетнаяПолитика.ПлательщикНДС(Шапка.Организация, Шапка.Дата);

		// Выводим шапку накладной
		СведенияОПокупателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Отчет комиссионера о продажах';uk='Звіт комісіонера про продажі'",КодЯзыкаПечать),КодЯзыкаПечать);

		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
		ОбластьМакета.Параметры.РеквизитыПоставщика =     ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "НомерСчета,Банк,МФО,/,ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
		
	    ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(Шапка);
	 	ОбластьМакета.Параметры.ПредставлениеПокупателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РеквизитыПокупателя		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "Телефоны,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим дополнительно информацию о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,Сделка,";
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
	    Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Суффикс = "";
		Если УчитыватьНДС Тогда
			Если Шапка.СуммаВключаетНДС Тогда
				Суффикс  = Суффикс  + НСтр("ru=' с ';uk=' з '",КодЯзыкаПечать);
			Иначе	
				Суффикс  = Суффикс  + НСтр("ru=' без ';uk=' без '",КодЯзыкаПечать);
			КонецЕсли;
			Суффикс = Суффикс  + НСтр("ru='НДС';uk='ПДВ'",КодЯзыкаПечать);
		КонецЕсли;
		ОбластьМакета.Параметры.Цена  = НСтр("ru='Цена';uk='Ціна'",КодЯзыкаПечать) + Суффикс;
		ОбластьМакета.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.ИмяКодАртикул = ТекстКодАртикул;
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		
		Сумма    = 0;
		СуммаНДС = 0;
		
		Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Сообщить(НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.';uk='В одному з рядків не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
				Продолжить;
			КонецЕсли;

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.Товар 		= СокрЛП(ВыборкаСтрокТовары.Товар);
			ОбластьМакета.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
			ТабДокумент.Вывести(ОбластьМакета);

			Сумма          = Сумма       + ВыборкаСтрокТовары.Сумма;
			СуммаНДС       = СуммаНДС    + ВыборкаСтрокТовары.СуммаНДС;

		КонецЦикла;

		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма);
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести ИтогоНДС
		Если УчитыватьНДС Тогда
			// НДС
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
			ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаНДС,,"""");
			ОбластьМакета.Параметры.НДС      = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
			ТабДокумент.Вывести(ОбластьМакета);
			
			// всего с НДС (если сумма не включает НДС)
			Если НЕ Шапка.СуммаВключаетНДС Тогда
				ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
				ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма + СуммаНДС);
				ОбластьМакета.Параметры.НДС      = НСтр("ru='Всего с НДС:';uk='Всього із ПДВ:'",КодЯзыкаПечать);
				ТабДокумент.Вывести(ОбластьМакета);
			КонецЕсли;
		КонецЕсли;

		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
		ОбластьМакета.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований ';uk='Всього найменувань '",КодЯзыкаПечать) + ЗапросТовары.Количество() + "," +
												 НСтр("ru=' на сумму ';uk=' на суму '",КодЯзыкаПечать)  + ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента) + ".";
												 
		ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента,КодЯзыкаПечать)
		 										 + ?(НЕ УчитыватьНДС, "", Символы.ПС + НСтр("ru='В т.ч. НДС: ';uk='У т.ч. ПДВ: '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаНДС, Шапка.ВалютаДокумента, КодЯзыкаПечать));

		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);

	КонецЦикла;

	Возврат ТабДокумент;	
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,ОбъектыПечати, ПараметрыВывода) Экспорт

	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета ОтчетККМ формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", НСтр("ru='Отчет комиссионера';uk='Звіт комісіонера'"),
			ПечатьОтчетаКомиссионера(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ОтчетКомиссионераОПродажах.ПФ_MXL_Накладная", , Истина);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация, НомерВходящегоДокумента, ДатаВходящегоДокумента",
		"Контрагент", "НомерВходящегоДокумента", "ДатаВходящегоДокумента");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли