﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСчетаУчетаРасчетов(Объект, СчетаУчета = Неопределено) Экспорт

	Если СчетаУчета = Неопределено Тогда
		СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента);
	КонецЕсли;
	
	Если Объект.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателяПриБартере;
		Объект.СчетУчетаРасчетовПоАвансам = СчетаУчета.СчетАвансовПокупателяПриБартере;
	Иначе
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателя;
		Объект.СчетУчетаРасчетовПоАвансам = СчетаУчета.СчетАвансовПокупателя;
	КонецЕсли;
	
	Если УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата) Тогда
		Объект.СчетУчетаНДС = СчетаУчета.СчетУчетаНДСПродаж;
		Если НЕ Объект.ДоговорКонтрагента.СложныйНалоговыйУчет Тогда
			Объект.СчетУчетаНДСПодтвержденный = СчетаУчета.СчетУчетаНДСПродажПодтвержденный;
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

// Заполняет счета учета номенклатуры в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре);
	КонецЦикла;

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
	
	// Акт об оказании услуг
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Акт";
	КомандаПечати.Представление = НСтр("ru='Акт об оказании услуг';uk='Акт про надання послуг'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	// Возвратная накладная для FREDO ДокМен
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ДляВыгрузкиВ1СЗвит";
	КомандаПечати.Представление = НСтр("ru='Акт об оказании услуг (для обмена через ""FREDO ДокМен"")';uk= 'Акт про надання послуг (для обміну через ""FREDO ДокМен"")'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ОткрытьПечатнуюФормуПредварительногоПросмотраЭДО";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Акт об оказании производственных услуг""';uk='Реєстр документів ""Акт про надання виробничих послуг""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Устанавливаем признак доступности печати покомплектно
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета формировать табличный документ
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Акт",
			НСтр("ru='Акт об оказании производственных услуг';uk='Акт про надання виробничих послуг'"),
			ПечатьАктаОбОказанииУслуг(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),
			,
			"Документ.АктОбОказанииПроизводственныхУслуг.ПФ_MXL_Акт",
			, Истина);
	КонецЕсли;

КонецПроцедуры

// Функция формирует табличный документ с печатной формой акта об оказании услуг
//
// Возвращаемое значение:
//  Табличный документ - печатная форма акта
//
Функция ПечатьАктаОбОказанииУслуг(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
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
	ЗапросШапка.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	ДоговорКонтрагента.Дата  		КАК ДоговорДата,
	|	ДоговорКонтрагента.Номер 		КАК ДоговорНомер,
	|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,
	|	ПредставительОрганизации КАК ПредставительПоставщика,
	|   Получил КАК ПредставительПокупателя,
	|	Контрагент  КАК Покупатель,
	|	Контрагент.ЮридическоеФизическоеЛицо КАК ПокупательЮрФизЛицо,
	|	Организация КАК Поставщик,
	|	Организация,
	|	Сделка,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	Истина КАК УчитыватьНДС,
	|	СуммаВключаетНДС,
	|	ВЫРАЗИТЬ(МестоСоставленияДокумента КАК СТРОКА(1000)) КАК МестоСоставленияДокумента
	|ИЗ
	|	Документ.АктОбОказанииПроизводственныхУслуг КАК АктОбОказанииПроизводственныхУслуг
	|
	|ГДЕ
	|	АктОбОказанииПроизводственныхУслуг.Ссылка = &ТекущийДокумент";

	ЗапросУслуги = Новый Запрос;
	ЧастьЗапросаДляВыбораСодержанияУслуг = ОбщегоНазначенияБПВызовСервера.ПолучитьЧастьЗапросаДляВыбораСодержанияУслуг("АктОбОказанииПроизводственныхУслуг");
	ЗапросУслуги.Текст = "
	|ВЫБРАТЬ
	|	НомерСтроки  КАК НомерСтрокиТЧ,
	|	Номенклатура КАК Номенклатура,
	|	" + ЧастьЗапросаДляВыбораСодержанияУслуг + " КАК Товар,
	|	Количество,
	|	Номенклатура.БазоваяЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|	Цена,
	|	Сумма,
	|	СтавкаНДС,
	|	СуммаНДС,
	|	АктОбОказанииПроизводственныхУслуг.Номенклатура." + ТекстКодАртикул + " КАК КодАртикул
	|ИЗ
	|	Документ.АктОбОказанииПроизводственныхУслуг.Услуги КАК АктОбОказанииПроизводственныхУслуг
	|
	|ГДЕ
	|	АктОбОказанииПроизводственныхУслуг.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиТЧ
	|";
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктОбОказанииПроизводственныхУслуг_Акт";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.АктОбОказанииПроизводственныхУслуг.ПФ_MXL_Акт");
	// печать производится на языке, указанном в настройках пользователя
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
		
		ЗапросУслуги.УстановитьПараметр("ТекущийДокумент", Ссылка);
		ТаблицаУслуги = ЗапросУслуги.Выполнить().Выгрузить();

		СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПокупателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
		РуководителиОрганизации = ОтветственныеЛицаБП.ОтветственныеЛица(Шапка.Организация, Шапка.Дата);
		РуководителиКонтрагента = ОтветственныеЛицаБП.ОтветственныеЛицаКонтрагента(Шапка.Покупатель, Шапка.Дата);
		
		// шапка акта "УТВЕРЖДАЮ"
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ДолжностьРуководителяПоставщика = РуководителиОрганизации.РуководительДолжность;
		ОбластьМакета.Параметры.ПредставлениеПоставщика 		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РуководительПоставщика 			= РуководителиОрганизации.РуководительПредставление;
		
		ОбластьМакета.Параметры.ДолжностьРуководителяПокупателя = ?(ПустаяСтрока(РуководителиКонтрагента.РуководительДолжность) И Шапка.ПокупательЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, "Директор", РуководителиКонтрагента.РуководительДолжность);
		ОбластьМакета.Параметры.ПредставлениеПокупателя 		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РуководительПокупателя 			= РуководителиКонтрагента.РуководительПредставление;
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='АКТ сдачи-приемки работ (оказания услуг)';uk='АКТ здачі-приймання робіт (надання послуг)'",КодЯзыкаПечать) + Символы.ПС,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		ДанныеПредставителя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Шапка.Организация,Шапка.ПредставительПоставщика, Шапка.Дата);
		ДолжностьПредставителя = СокрЛП(ДанныеПредставителя.Должность);
		
		ДолжностьФИОПредставителя = ?(ЗначениеЗаполнено(ДолжностьПредставителя),ДолжностьПредставителя + " ","") + 
									?(ДанныеПредставителя.Фамилия = Неопределено,"",ДанныеПредставителя.Фамилия + " ") + 
									?(ДанныеПредставителя.Имя = Неопределено,"",ДанныеПредставителя.Имя + " ") +
									?(ДанныеПредставителя.Отчество = Неопределено,"",ДанныеПредставителя.Отчество);
									
		// Начинаем формировать собственно текст акта
		ОбластьМакета = Макет.ПолучитьОбласть("ТекстАктаНачало");
		ОбластьМакета.Параметры.Заполнить(Шапка);
									
		ОбластьМакета.Параметры.ПредставительПоставщика = ДолжностьФИОПредставителя;
		ОбластьМакета.Параметры.ПредставительПокупателя = Шапка.ПредставительПокупателя;

		ОбластьМакета.Параметры.ПредставлениеПоставщика 		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.ПредставлениеПокупателя 		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		// выводим сведения о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,Сделка,";
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров, КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
		Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		

	 	// Заканчиваем формировать текст акта
		ОбластьМакета = Макет.ПолучитьОбласть("ТекстАктаКонец");
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.ИмяКодАртикул = ТекстКодАртикул;
		КонецЕсли;
		Суффикс = "";
		Если Шапка.УчитыватьНДС Тогда
			Если Шапка.СуммаВключаетНДС Тогда
				Суффикс  = Суффикс  + НСтр("ru=' с ';uk=' з '",КодЯзыкаПечать);
			Иначе	
				Суффикс  = Суффикс  + НСтр("ru=' без ';uk=' без '",КодЯзыкаПечать);
			КонецЕсли;
			Суффикс = Суффикс  + НСтр("ru='НДС';uk='ПДВ'",КодЯзыкаПечать);
		КонецЕсли;
		ОбластьМакета.Параметры.Цена  = НСтр("ru='Цена';uk='Ціна'",КодЯзыкаПечать) + Суффикс;
		ОбластьМакета.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		
		НомерСтроки = 0;

		Для Каждого СтрокаТабличнойЧасти Из ТаблицаУслуги Цикл	

			НомерСтроки = НомерСтроки + 1;
			
			ОбластьМакета.Параметры.Заполнить(СтрокаТабличнойЧасти);
			ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
			ОбластьМакета.Параметры.Товар = СокрЛП(Строка(СтрокаТабличнойЧасти.Товар));
			ТабДокумент.Вывести(ОбластьМакета);

		КонецЦикла;

		Если ТаблицаУслуги <> Неопределено Тогда

			СуммаВсего  = ТаблицаУслуги.Итог("Сумма");
			ВсегоНДС 	= ТаблицаУслуги.Итог("СуммаНДС");

		Иначе

			СуммаВсего  = 0;
			ВсегоНДС 	= 0;

		КонецЕсли;

		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаВсего);
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести ИтогоНДС
		Если Шапка.УчитыватьНДС Тогда
			// НДС
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");                     
			ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ВсегоНДС,,"""");
			ОбластьМакета.Параметры.НДС      = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
			ТабДокумент.Вывести(ОбластьМакета);
			
			// всего с НДС (если сумма не включает НДС)
			Если НЕ Шапка.СуммаВключаетНДС Тогда
				ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
				ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаВсего + ВсегоНДС);
				ОбластьМакета.Параметры.НДС      = НСтр("ru='Всего с НДС:';uk='Всього із ПДВ:'",КодЯзыкаПечать);
				ТабДокумент.Вывести(ОбластьМакета);
			КонецЕсли;
		КонецЕсли;

		// Выводим Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");	
		СуммаКПрописиСНДС 	= СуммаВсего + ?(Шапка.СуммаВключаетНДС, 	   0, ВсегоНДС);
		СуммаКПрописиБезНДС = СуммаВсего - ?(Шапка.СуммаВключаетНДС, ВсегоНДС, 		 0);
		Если Шапка.УчитыватьНДС Тогда
			ОбластьМакета.Параметры.СуммаПрописью  = НСтр("ru='Общая стоимость работ (услуг) составила без НДС ';uk='Загальна вартість робіт (послуг) склала без ПДВ '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописиБезНДС, Шапка.ВалютаДокумента,КодЯзыкаПечать) +
													 НСтр("ru=', НДС ';uk=', ПДВ '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(ВсегоНДС, Шапка.ВалютаДокумента,КодЯзыкаПечать) +
													 НСтр("ru=', общая стоимость работ (услуг) с НДС ';uk=', загальна вартість робіт (послуг) із ПДВ '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописиСНДС, Шапка.ВалютаДокумента,КодЯзыкаПечать) +
													 ".";
	 	Иначе
			ОбластьМакета.Параметры.СуммаПрописью  = НСтр("ru='Общая стоимость работ (услуг) составила ';uk='Загальна вартість робіт (послуг) склала '",КодЯзыкаПечать)	+ ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописиБезНДС, Шапка.ВалютаДокумента,КодЯзыкаПечать) + ".";
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьМакета);

		Если ЗначениеЗаполнено(Шапка.МестоСоставленияДокумента) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("МестоСоставления");
			ОбластьМакета.Параметры.МестоСоставления = СокрЛП(Шапка.МестоСоставленияДокумента);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли; 

		// выводим подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		ОбластьМакета.Параметры.ПредставительПоставщика = ДолжностьФИОПредставителя;
		ОбластьМакета.Параметры.ПредставительПокупателя = Шапка.ПредставительПокупателя;
		
		ОбластьМакета.Параметры.РеквизитыПоставщика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,/,КодПоЕДРПОУ,КодПоДРФО,Телефоны,/,ИНН,НомерСвидетельства,/,НомерСчета,Банк,МФО,/,ЮридическийАдрес,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РеквизитыПокупателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,/,КодПоЕДРПОУ,КодПоДРФО,Телефоны,/,ИНН,НомерСвидетельства,/,НомерСчета,Банк,МФО,/,ЮридическийАдрес,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;

	Возврат ТабДокумент;

КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

Функция ПечатьДокументаДляЭДО(ДокументСсылка) Экспорт
	
	СтруктураПоказателей = Новый Структура();
	СтруктураПоказателей.Вставить("ПервичныйДокумент",	 Новый Структура());	   // данные шапки
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("R", Новый ТаблицаЗначений()); // данные табличной части
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("Наименование");
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("Количество");
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("ЕдиницаИзмерения");
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("ЕдиницаИзмеренияКод");
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("Цена");
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("Сумма");
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("СуммаНДС");
	СтруктураПоказателей.ПервичныйДокумент.R.Колонки.Добавить("СтавкаНДС");
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ДокументСсылка.Ссылка);
	Запрос.УстановитьПараметр("НДС20", Перечисления.СтавкиНДС.НДС20);
	Запрос.УстановитьПараметр("НДС7",  Перечисления.СтавкиНДС.НДС7);
	
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	СУММА(ТЧ.СуммаНДС)    КАК СуммаНДСУслуги,
	|	КОЛИЧЕСТВО(*) 		  КАК КоличествоУслуги
	|ПОМЕСТИТЬ Услуги
	|ИЗ
	|	Документ.АктОбОказанииПроизводственныхУслуг.Услуги КАК ТЧ
	|
	|ГДЕ
	|	ТЧ.Ссылка = &ТекущийДокумент
	|;
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	ДоговорКонтрагента.Дата  		КАК ДоговорДата,
	|	ДоговорКонтрагента.Номер 		КАК ДоговорНомер,
	|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,
	|	ПредставительОрганизации КАК ПредставительПоставщика,
	|   Получил КАК ПредставительПокупателя,
	|	Контрагент  КАК Покупатель,
	|	Контрагент.ЮридическоеФизическоеЛицо КАК ПокупательЮрФизЛицо,
	|	Контрагент.КодФилиала  КАК ПокупательКодФилиала,
	|	Организация КАК Поставщик,
	|	Организация,
	|	Сделка,
	|	СуммаДокумента,
	|	ЕстьNULL(СуммаНДСУслуги, 0) КАК СуммаНДСУслуги,
	|	ЕстьNULL(КоличествоУслуги, 0) 	  КАК КоличествоУслуги,
	|	ВалютаДокумента,
	|	Истина КАК УчитыватьНДС,
	|	СуммаВключаетНДС, 
	|	ВЫРАЗИТЬ(МестоСоставленияДокумента КАК СТРОКА(1000)) КАК МестоСоставленияДокумента
	|ИЗ
	|	Документ.АктОбОказанииПроизводственныхУслуг КАК АктОбОказанииПроизводственныхУслуг
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Услуги КАК Услуги ПО Истина
	|ГДЕ
	|	АктОбОказанииПроизводственныхУслуг.Ссылка = &ТекущийДокумент";
	
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	КодЯзыкаПечать = "uk";	
	
	СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
	СведенияОПокупателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
	
	НазваниеОрганизации = СведенияОПоставщике.ПолноеНаименование;
	Банк		= СведенияОПоставщике.Банк;
	МФО	 		= СведенияОПоставщике.МФО;
	НомерСчета 	= СведенияОПоставщике.НомерСчета;
			
	СтруктураПоказателей.ПервичныйДокумент.Вставить("НазваниеДокумента", "АКТ надання виробничих послуг"); 
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("НомерДок", ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Шапка.Номер,Истина,Истина));
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ДатаДок",  Шапка.Дата);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикНаименование",  СведенияОПоставщике.ПолноеНаименование);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикКод",   	  	  ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "КодПоЕДРПОУ,КодПоДРФО,",,КодЯзыкаПечать));
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикКодЧисло",	  "" + СведенияОПоставщике.КодПоЕДРПОУ + СведенияОПоставщике.КодПоДРФО);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикИНН",   	  	  СведенияОПоставщике.ИНН);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикНомерСвидетельства", СведенияОПоставщике.НомерСвидетельства);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикБанк",  		Банк);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикМФО",  		МФО);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикНомерСчета",  НомерСчета);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикЮридическийАдрес", 		СведенияОПоставщике.ЮридическийАдрес);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикТелефоны",   				СведенияОПоставщике.Телефоны);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПоставщикСистемаНалогообложения", СведенияОПоставщике.ИнформацияОСтатусеПлательщикаНалогов);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательНаименование", 		СведенияОПокупателе.ПолноеНаименование);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательИНН",   	  	  		СведенияОПокупателе.ИНН);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательНомерСвидетельства", СведенияОПокупателе.НомерСвидетельства);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательБанк",  				СведенияОПокупателе.Банк);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательМФО",  				СведенияОПокупателе.МФО);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательНомерСчета",  		СведенияОПокупателе.НомерСчета);

	ПокупательКод = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "КодПоЕДРПОУ,КодПоДРФО,",,КодЯзыкаПечать);
	ПокупательНаименованиеКода = ?(СтрДлина(ПокупательКод) = 24,  Лев(ПокупательКод, 12), Лев(ПокупательКод, 14));  
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательКод",              ПокупательКод);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательНаименованиеКода", ПокупательНаименованиеКода);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательТелефоны", 	      СведенияОПокупателе.Телефоны);

	ПокупательКодФилиала = СокрЛП(Шапка.ПокупательКодФилиала); 
	Если Найти(ПокупательКодФилиала, "@") > 0 Тогда
		ПокупательКодФилиала = Лев(ПокупательКодФилиала, Найти(ПокупательКодФилиала, "@") - 1);
	КонецЕсли;
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательКодФилиала",     ПокупательКодФилиала);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПокупательЮридическийАдрес",     СведенияОПокупателе.ЮридическийАдрес);
	
	Если ЗначениеЗаполнено(Шапка.ДоговорКонтрагента) Тогда

		СтруктураПоказателей.ПервичныйДокумент.Вставить("ДоговорНом", 		"№");
		СтруктураПоказателей.ПервичныйДокумент.Вставить("ДоговорНомер",  	Шапка.ДоговорНомер);
		СтруктураПоказателей.ПервичныйДокумент.Вставить("ДоговорОт", 		"від");
		СтруктураПоказателей.ПервичныйДокумент.Вставить("ДоговорДата",   	Шапка.ДоговорДата);
		
	КонецЕсли;

	Если ЗначениеЗаполнено(Шапка.Сделка) Тогда
		Сделка = Шапка.Сделка;
		МетаданныеДокумента = Сделка.Метаданные();	
		ЗначениеПараметра = Локализация.ПолучитьЛокализованныйСинонимОбъекта(Сделка, КодЯзыкаПечать);
		НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Сделка.Номер,Истина,Истина);
		Если ОбщегоНазначенияБП.ЕстьРеквизитДокумента("НомерВходящегоДокумента", МетаданныеДокумента) И ЗначениеЗаполнено(Сделка.НомерВходящегоДокумента) Тогда
			НомерДокумента = Сделка.НомерВходящегоДокумента;
		КонецЕсли;
		ДатаДокумента = Сделка.Дата;
		Если ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ДатаВходящегоДокумента", МетаданныеДокумента) И ЗначениеЗаполнено(Сделка.ДатаВходящегоДокумента) Тогда
			ДатаДокумента = Сделка.ДатаВходящегоДокумента;
		КонецЕсли;
		СтруктураПоказателей.ПервичныйДокумент.Вставить("ТипСделка", 	"Розр. док.:");
		СтруктураПоказателей.ПервичныйДокумент.Вставить("ТипДокумента", ЗначениеПараметра);
		СтруктураПоказателей.ПервичныйДокумент.Вставить("СчетНом", 		"№");
		СтруктураПоказателей.ПервичныйДокумент.Вставить("СчетНомер", 	НомерДокумента);
		СтруктураПоказателей.ПервичныйДокумент.Вставить("СчетОт", 		"від");
		СтруктураПоказателей.ПервичныйДокумент.Вставить("СчетДата", 	ДатаДокумента);
	КонецЕсли;
	
	СуммаДокБезНДС = Шапка.СуммаДокумента - Шапка.СуммаНДСУслуги;
	СтруктураПоказателей.ПервичныйДокумент.Вставить("СуммаДокБезНДС", СуммаДокБезНДС);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("СуммаДокБезНДСПрописью", ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаДокБезНДС, Шапка.ВалютаДокумента, КодЯзыкаПечать));

	СтруктураПоказателей.ПервичныйДокумент.Вставить("СуммаДок", Шапка.СуммаДокумента);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("СуммаДокПрописью", ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента, КодЯзыкаПечать));
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("СуммаНДСДок", Шапка.СуммаНДСУслуги);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("СуммаНДСДокПрописью", ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.СуммаНДСУслуги, Шапка.ВалютаДокумента, КодЯзыкаПечать));
	
		
	СтруктураПоказателей.ПервичныйДокумент.Вставить("КоличествоНаименований", Шапка.КоличествоУслуги);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ВыписалДок", Шапка.ПредставительПокупателя);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("МестоСоставления", Шапка.МестоСоставленияДокумента);
	
	РуководителиОрганизации = ОтветственныеЛицаБП.ОтветственныеЛица(Шапка.Организация, Шапка.Дата);
	РуководителиКонтрагента = ОтветственныеЛицаБП.ОтветственныеЛицаКонтрагента(Шапка.Покупатель, Шапка.Дата);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ДолжностьРуководителяПоставщика", 	РуководителиОрганизации.РуководительДолжность);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПредставлениеПоставщика",			ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать));
	СтруктураПоказателей.ПервичныйДокумент.Вставить("РуководительПоставщика",			РуководителиОрганизации.РуководительПредставление);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ДолжностьРуководителяПокупателя",	?(ПустаяСтрока(РуководителиКонтрагента.РуководительДолжность) И Шапка.ПокупательЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, "Директор", РуководителиКонтрагента.РуководительДолжность));
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПредставлениеПокупателя",			ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать));
	СтруктураПоказателей.ПервичныйДокумент.Вставить("РуководительПокупателя",			РуководителиКонтрагента.РуководительПредставление);
	
	ДанныеПредставителя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Шапка.Организация,Шапка.ПредставительПоставщика, Шапка.Дата);
	ДолжностьПредставителя = СокрЛП(ДанныеПредставителя.Должность);
	
	ДолжностьФИОПредставителя = ?(ЗначениеЗаполнено(ДолжностьПредставителя),ДолжностьПредставителя + " ","") + 
								?(ДанныеПредставителя.Фамилия = Неопределено,"",ДанныеПредставителя.Фамилия + " ") + 
								?(ДанныеПредставителя.Имя = Неопределено,"",ДанныеПредставителя.Имя + " ") +
								?(ДанныеПредставителя.Отчество = Неопределено,"",ДанныеПредставителя.Отчество);
	
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПредставительПоставщика", 			ДолжностьФИОПредставителя);
	СтруктураПоказателей.ПервичныйДокумент.Вставить("ПредставительПокупателя",			Шапка.ПредставительПокупателя);
		
	ЧастьЗапросаДляВыбораСодержанияУслуг = ОбщегоНазначенияБПВызовСервера.ПолучитьЧастьЗапросаДляВыбораСодержанияУслуг("ПервичныйДокумент");
	
	Запрос.Текст = "ВЫБРАТЬ
	|	" + ЧастьЗапросаДляВыбораСодержанияУслуг + " КАК Наименование,
	|	Номенклатура.Артикул КАК Артикул,
	|	Номенклатура.Код КАК Код,
	
	|	Количество,
	|	Номенклатура.БазоваяЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Номенклатура.БазоваяЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	
	|	Цена 			КАК Цена,
	|	Сумма 			КАК Сумма,
	|	СуммаНДС 		КАК СуммаНДС,
	
	|	СтавкаНДС КАК СтавкаНДС,	
	|	НомерСтроки КАК НомерСтроки,
	|    1 КАК ID
	|ИЗ
	|	Документ.АктОбОказанииПроизводственныхУслуг.Услуги КАК ПервичныйДокумент
	|
	|ГДЕ
	|	ПервичныйДокумент.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|    ID,
	|	НомерСтроки";
	
	ВыборкаУслуги = Запрос.Выполнить().Выбрать();
		
	Пока ВыборкаУслуги.Следующий() Цикл
		СтрокаДок = СтруктураПоказателей.ПервичныйДокумент.R.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДок, ВыборкаУслуги);
		
		СтрокаДок.СтавкаНДС = УчетНДС.ПолучитьСтавкуНДС(ВыборкаУслуги.СтавкаНДС);
		Если ВыборкаУслуги.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС Тогда
			СтрокаДок.СтавкаНДС = "Б";
		ИначеЕсли ВыборкаУслуги.СтавкаНДС = Перечисления.СтавкиНДС.НеНДС Тогда	
			СтрокаДок.СтавкаНДС = "Н";
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураПоказателей;
	
	
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
		Если ТипЗнч(ДанныеОбъекта) <> Тип("Структура") Тогда
		    СтруктураДанныхОбъекта = ДанныеОбъекта = Новый Структура("Дата, Организация, Реализация");
			ЗаполнитьЗначенияСвойств(СтруктураДанныхОбъекта, ДанныеОбъекта);
			СтруктураДанныхОбъекта.Реализация = Истина;
		Иначе 	
			СтруктураДанныхОбъекта = ДанныеОбъекта;
		КонецЕсли; 
		СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(СтрокаТабличнойЧасти.Номенклатура, СтруктураДанныхОбъекта);
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		// СведенияОНоменклатуре - структура сведений номенклатуры
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчета") Тогда
		// СведенияОНоменклатуре - структура счетов учета номенклатуры
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ИмяТабличнойЧасти = "Услуги" Тогда
		
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначениеДоходовИЗатрат) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначениеДоходовИЗатрат = СчетаУчета.НалоговоеНазначениеДоходовИЗатрат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.СхемаРеализации) Тогда
			СтрокаТабличнойЧасти.СхемаРеализации = СчетаУчета.СхемаРеализации;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
