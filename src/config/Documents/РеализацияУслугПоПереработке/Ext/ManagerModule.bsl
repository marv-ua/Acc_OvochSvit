﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСчетаУчетаРасчетов(Объект, СчетаУчета = Неопределено) Экспорт
	
	Если СчетаУчета = Неопределено Тогда
		СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
			Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента);
	КонецЕсли;
	
	Если Объект.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателяПриБартере;
		Объект.СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансовПокупателяПриБартере;
	Иначе
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателя;
		Объект.СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансовПокупателя;
	КонецЕсли;

	Объект.СчетУчетаНДС 					 = СчетаУчета.СчетУчетаНДСПродаж;
	Объект.СчетУчетаНДСПодтвержденный  	 = СчетаУчета.СчетУчетаНДСПродажПодтвержденный;
	
КонецПроцедуры

// Заполняет счета учета номенклатуры в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, Реализация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.Реализация	= Истина;

	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре);
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре) Экспорт

	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчетаБУ") Тогда
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ИмяТабличнойЧасти = "МатериалыЗаказчика" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетПередачиЗабБУ;
		КонецЕсли;
		
	ИначеЕсли ИмяТабличнойЧасти = "Услуги" Тогда
		
		СтрокаТабличнойЧасти.СчетУчетаБУ = ПланыСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья;
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

Функция УслугиПоДаннымОВыпускеПродукции(ДокументРеализацииУслуг, ДокументыВыпуска) Экспорт
	
	Услуги = Новый ТаблицаЗначений;
	Для Каждого ОписаниеКолонки Из Метаданные.Документы.РеализацияУслугПоПереработке.ТабличныеЧасти.Услуги.Реквизиты Цикл
		Услуги.Колонки.Добавить(ОписаниеКолонки.Имя, ОписаниеКолонки.Тип);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументыВыпуска", ДокументыВыпуска);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Выпуск.Номенклатура,
	|	Выпуск.Спецификация,
	|	Выпуск.Номенклатура.НаименованиеПолное КАК Содержание,
	|	Выпуск.Количество КАК Количество,
	|	Выпуск.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Выпуск.Коэффициент КАК Коэффициент,
	|	Выпуск.Номенклатура.СтавкаНДС КАК СтавкаНДС,
	|	Выпуск.ПлановаяСтоимость,
	|	Выпуск.СуммаПлановая КАК СуммаПлановая,
	|	Выпуск.Счет КАК СчетУчета,
	|	Выпуск.НоменклатурнаяГруппа КАК Субконто,
	|	Выпуск.НомерСтроки КАК НомерСтроки,
	|	Выпуск.Ссылка.Дата КАК Дата,
	|	Выпуск.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтчетПроизводстваЗаСмену.Продукция КАК Выпуск
	|ГДЕ
	|	Выпуск.Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья)
	|	И Выпуск.Ссылка В(&ДокументыВыпуска)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка,
	|	НомерСтроки";
	
	НовыеСтрокиТабличнойЧасти = Запрос.Выполнить().Выгрузить();
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("Дата");
	ДанныеОбъекта.Вставить("Организация");
	ДанныеОбъекта.Вставить("СуммаВключаетНДС");
	ДанныеОбъекта.Вставить("ТипЦен");
	ДанныеОбъекта.Вставить("ВалютаДокумента");
	ДанныеОбъекта.Вставить("КурсВзаиморасчетов");
	ДанныеОбъекта.Вставить("КратностьВзаиморасчетов");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ДокументРеализацииУслуг);
	ДанныеОбъекта.Вставить("Реализация", Истина);
	
	ПереченьНоменклатуры        = ОбщегоНазначения.ВыгрузитьКолонку(НовыеСтрокиТабличнойЧасти, "Номенклатура", Истина);
	СведенияОСпискеНоменклатуры = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(ПереченьНоменклатуры, ДанныеОбъекта);
		
	Для Каждого СтрокаОснование Из НовыеСтрокиТабличнойЧасти Цикл
		
		НоваяСтрока = Услуги.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОснование);
		
		СведенияОНоменклатуре = СведенияОСпискеНоменклатуры[НоваяСтрока.Номенклатура];
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока.Цена = СведенияОНоменклатуре.Цена;
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(НоваяСтрока);
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, ДокументРеализацииУслуг.СуммаВключаетНДС);
		
		Документы.РеализацияУслугПоПереработке.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
			ДанныеОбъекта,
			НоваяСтрока,
			"Услуги",
			СведенияОНоменклатуре);
		
	КонецЦикла;
	
	Возврат Услуги;
	
КонецФункции

// Заполняет табличную часть МатериалыЗаказчика на основании данных табличной части Услуги.
// Процедура добавляет строки, не очищая табличную часть перед заполнением.
//
// Параметры:
//  МатериалыЗаказчика - ДокументТабличнаяЧасть.РеализацияУслугПоПереработке.МатериалыЗаказчика - заполняемая табличная часть.
//              Допускается передавать соответствующие данные формы 
//              или таблицу значений со совпадающей структурой.
//  Услуги - ТаблицаЗначений - структура таблицы совпадает со структурой одноименной табличной части
// 
Процедура ЗаполнитьМатериалыПоПродукции(МатериалыЗаказчика, Услуги, Организация = Неопределено, Дата = Неопределено) Экспорт
	
	// Получим данные о сырье для заполнения табличной части
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Услуги", Услуги);
	
	Запрос.Текст = 
	// Исходные данные
	"ВЫБРАТЬ
	|	Услуги.Спецификация,
	|	Услуги.Количество КАК КоличествоПродукции,
	|	Услуги.ЕдиницаИзмерения,
	|	Услуги.Коэффициент
	|ПОМЕСТИТЬ Выпуск
	|ИЗ
	|	&Услуги КАК Услуги
	|;"
	// Данные о расходе сырья
	+ УправлениеПроизводством.ТекстЗапросаВременнаяТаблицаЗатратыСырья()
	// Преобразуем в формат получателя
	+ 
	"ВЫБРАТЬ
	|	ЗатратыСырья.Номенклатура,
	|	ЗатратыСырья.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ЗатратыСырья.ЕдиницаИзмерения,
	|	ЗатратыСырья.Коэффициент,
	|	СУММА(ЗатратыСырья.Количество) КАК Количество
	|ИЗ
	|	ЗатратыСырья КАК ЗатратыСырья
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗатратыСырья.Номенклатура,
	|	ЗатратыСырья.Номенклатура.Представление,
	|	ЗатратыСырья.ЕдиницаИзмерения,
	|	ЗатратыСырья.Коэффициент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НоменклатураПредставление";
	
	ТаблицаМатериалов = Запрос.Выполнить().Выгрузить();
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Реализация");
	ДанныеОбъекта.Дата			= ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	ДанныеОбъекта.Организация	= Организация;
	ДанныеОбъекта.Реализация	= Истина;
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаМатериалов, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для Каждого СтрокаМатериала Из ТаблицаМатериалов Цикл
		
		СтрокаТабличнойЧасти = МатериалыЗаказчика.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаМатериала);
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаМатериала.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
			ДанныеОбъекта, СтрокаТабличнойЧасти, "МатериалыЗаказчика", СведенияОНоменклатуре);
		
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

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Акт об оказании услуг
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Акт";
	КомандаПечати.Представление = НСтр("ru='Акт об оказании услуг';uk='Акт про надання послуг'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	// Отчет о продукции
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Продукция";
	КомандаПечати.Представление = НСтр("ru='Отчет о продукции';uk='Звіт про продукцію'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	// Отчет о материалах
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Материалы";
	КомандаПечати.Представление = НСтр("ru='Отчет о материалах';uk='Звіт про матеріали'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Реализация услуг по переработке""';uk='Реєстр документів ""Реалізація послуг з переробки""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Акт", НСтр("ru='Акт об оказании услуг';uk='Акт про надання послуг'"), 
			ПечатьАктаОбОказанииУслуг(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.РеализацияУслугПоПереработке.ПФ_MXL_Акт", , Истина);
			
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Продукция") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Продукция", НСтр("ru='Отчет о продукции';uk='Звіт про продукцію'"), 
			ПечатьОтчета(МассивОбъектов, ОбъектыПечати, ПараметрыВывода, "Услуги"),,"Документ.РеализацияУслугПоПереработке.ПФ_MXL_Накладная", , Истина);
			
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Материалы") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Материалы", НСтр("ru='Отчет о материалах';uk='Звіт про матеріали'"), 
			ПечатьОтчета(МассивОбъектов, ОбъектыПечати, ПараметрыВывода, "МатериалыЗаказчика"),,"Документ.РеализацияУслугПоПереработке.ПФ_MXL_Накладная", , Истина);
			
	КонецЕсли;
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой акта об обказании услуг
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
		ОбластьСтрокиМакет = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтрокиМакет = "Строка";
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
	|	ВЫРАЗИТЬ(МестоСоставленияДокумента КАК СТРОКА(1000)) КАК МестоСоставленияДокумента,
	|	ПредставительОрганизации КАК ПредставительПоставщика,
	|   ПредставительКонтрагента КАК ПредставительПокупателя,
	|	Контрагент  КАК Покупатель,
	|	Контрагент.ЮридическоеФизическоеЛицо КАК ПокупательЮрФизЛицо,
	|	Организация КАК Поставщик,
	|	Организация,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	Истина КАК УчитыватьНДС,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ.РеализацияУслугПоПереработке КАК РеализацияУслугПоПереработке
	|
	|ГДЕ
	|	РеализацияУслугПоПереработке.Ссылка = &ТекущийДокумент";

	ЗапросУслуги = Новый Запрос;
	ЗапросУслуги.Текст = "
	|ВЫБРАТЬ
	|	НомерСтроки  КАК НомерСтрокиТЧ,
	|	Номенклатура КАК Номенклатура,
	|	Содержание КАК Товар,
	|	Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|	Количество,
	|	ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Цена,
	|	Сумма,
	|	СтавкаНДС,
	|	СуммаНДС
	|ИЗ
	|	Документ.РеализацияУслугПоПереработке.Услуги КАК РеализацияУслугПоПереработке
	|
	|ГДЕ
	|	РеализацияУслугПоПереработке.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиТЧ
	|";
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеализацияУслугПоПереработке_Акт";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияУслугПоПереработке.ПФ_MXL_Акт");
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
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Акт оказания услуг по переработке';uk='Акт надання послуг з переробки'",КодЯзыкаПечать) + Символы.ПС,КодЯзыкаПечать);
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

		ОбластьМакета.Параметры.ПредставлениеПоставщика 		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,");
		ОбластьМакета.Параметры.ПредставлениеПокупателя 		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,");
		ТабДокумент.Вывести(ОбластьМакета);

		// выводим сведения о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,";	
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
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
		
		ОбластьСтроки = Макет.ПолучитьОбласть(ОбластьСтрокиМакет);

		НомерСтроки = 0;

		Для Каждого СтрокаТабличнойЧасти Из ТаблицаУслуги Цикл	

			НомерСтроки = НомерСтроки + 1;
			
			ОбластьСтроки.Параметры.Заполнить(СтрокаТабличнойЧасти);
			ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;
			ОбластьСтроки.Параметры.Товар = СокрЛП(СтрокаТабличнойЧасти.Товар);

			ТабДокумент.Вывести(ОбластьСтроки);

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

КонецФункции // ПечатьАктаОбОказанииУслуг()

// Функция формирует табличный документ с печатной формой акта об обказании услуг
//
// Возвращаемое значение:
//  Табличный документ - печатная форма акта
//
Функция ПечатьОтчета(МассивОбъектов, ОбъектыПечати, ПараметрыВывода, ТабЧасть)

	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросШапка = Новый Запрос;
	ЗапросШапка.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	ДоговорКонтрагента.Дата  		КАК ДоговорДата,
	|	ДоговорКонтрагента.Номер 		КАК ДоговорНомер,
	|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,
	|	ВЫРАЗИТЬ(МестоСоставленияДокумента КАК СТРОКА(1000)) КАК МестоСоставленияДокумента,
	|	ПредставительОрганизации КАК ПредставительПоставщика,
	|   ПредставительКонтрагента КАК ПредставительПокупателя,
	|	Контрагент  КАК Покупатель,
	|	Контрагент.ЮридическоеФизическоеЛицо КАК ПокупательЮрФизЛицо,
	|	Организация КАК Поставщик,
	|	Организация,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	Истина КАК УчитыватьНДС,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ.РеализацияУслугПоПереработке КАК РеализацияУслугПоПереработке
	|
	|ГДЕ
	|	РеализацияУслугПоПереработке.Ссылка = &ТекущийДокумент";

	ЗапросПродукция = Новый Запрос;
	ЗапросПродукция.Текст = "
	|ВЫБРАТЬ
	|	Номенклатура КАК Номенклатура,
	|	Номенклатура КАК Товар,
	|	Количество,
	|   ЕдиницаИзмерения КАК ЕдиницаИзмерения";
	Если ТабЧасть = "Услуги" Тогда
		ЗапросПродукция.Текст = ЗапросПродукция.Текст + "
		|	,
		|	Цена,
		|	СуммаНДС,
		|	Сумма";
	КонецЕсли;
	ЗапросПродукция.Текст = ЗапросПродукция.Текст + "
	
	|ИЗ
	|	Документ.РеализацияУслугПоПереработке." + ТабЧасть + " КАК РеализацияУслугПоПереработке
	|
	|ГДЕ
	|	РеализацияУслугПоПереработке.Ссылка = &ТекущийДокумент
	|";
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеализацияУслугПоПереработке_Акт";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияУслугПоПереработке.ПФ_MXL_Накладная");
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
		
		ЗапросПродукция.УстановитьПараметр("ТекущийДокумент", Ссылка);
		ТаблицаПродукция = ЗапросПродукция.Выполнить().Выгрузить();

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		НазваниеДокумента = НСтр("ru='Отчет о';uk= 'Звіт про'", КодЯзыкаПечать) + " " + 
			?(ТабЧасть = "Услуги", НСтр("ru='продукции, произведенной из сырья заказчика';uk= 'продукцію, що вироблена з сировини замовника'", КодЯзыкаПечать), НСтр("ru='переработанном сырье';uk= 'перероблену сировину'", КодЯзыкаПечать));
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НазваниеДокумента ,КодЯзыкаПечать);	
		ТабДокумент.Вывести(ОбластьМакета);
		
		СведенияОПокупателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
		ОбластьМакета.Параметры.РеквизитыПоставщика =     ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "НомерСчета,Банк,МФО,/,ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
	    ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(Шапка);
	 	ОбластьМакета.Параметры.ПредставлениеПокупателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РеквизитыПокупателя		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе,"Телефоны,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим дополнительно информацию о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,";
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
	    Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы" + ТабЧасть);
		Если ТабЧасть = "Услуги" Тогда
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
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьСтроки = Макет.ПолучитьОбласть("Строка" + ТабЧасть);
		НомерСтроки = 0;

		Для Каждого СтрокаТабличнойЧасти Из ТаблицаПродукция Цикл	

			НомерСтроки = НомерСтроки + 1;
			
			ОбластьСтроки.Параметры.Заполнить(СтрокаТабличнойЧасти);
			ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;


			ТабДокумент.Вывести(ОбластьСтроки);

		КонецЦикла;

		Сумма    = 0;
		Если ТабЧасть = "Услуги" Тогда
			Если ТаблицаПродукция <> Неопределено Тогда
				Сумма    = ТаблицаПродукция.Итог("Сумма");
				СуммаНДС = ТаблицаПродукция.Итог("СуммаНДС");
			КонецЕсли;

			// Вывести Итого
			ОбластьМакета = Макет.ПолучитьОбласть("Итого");
			ОбластьМакета.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма);
			ТабДокумент.Вывести(ОбластьМакета);

			// Вывести ИтогоНДС
			Если Шапка.УчитыватьНДС Тогда
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
			ОбластьМакета.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований ';uk='Всього найменувань '",КодЯзыкаПечать) + ТаблицаПродукция.Количество() + "," +
													 НСтр("ru=' на сумму ';uk=' на суму '",КодЯзыкаПечать)  + ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента)
													 +".";
													 
			ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента,КодЯзыкаПечать)
			 										 + ?(НЕ Шапка.УчитыватьНДС, "", Символы.ПС + НСтр("ru='В т.ч. НДС: ';uk='У т.ч. ПДВ: '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаНДС, Шапка.ВалютаДокумента, КодЯзыкаПечать));

			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		Если ТабЧасть = "МатериалыЗаказчика" Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоМатериалы");
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;

		Если ЗначениеЗаполнено(Шапка.МестоСоставленияДокумента) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("МестоСоставления");
			ОбластьМакета.Параметры.МестоСоставления = СокрЛП(Шапка.МестоСоставленияДокумента);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли; 
		
		ДанныеПредставителя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Шапка.Организация,Шапка.ПредставительПоставщика, Шапка.Дата);
		ДолжностьПредставителя = СокрЛП(ДанныеПредставителя.Должность);
		
		ДолжностьФИОПредставителя = ?(ЗначениеЗаполнено(ДолжностьПредставителя),ДолжностьПредставителя + " ","") + 
									?(ДанныеПредставителя.Фамилия = Неопределено,"",ДанныеПредставителя.Фамилия + " ") + 
									?(ДанныеПредставителя.Имя = Неопределено,"",ДанныеПредставителя.Имя + " ") +
									?(ДанныеПредставителя.Отчество = Неопределено,"",ДанныеПредставителя.Отчество);
									
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи" + ТабЧасть);
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		ОбластьМакета.Параметры.Ответственный = ДолжностьФИОПредставителя;
		ОбластьМакета.Параметры.Получил = Шапка.ПредставительПокупателя;
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
	
	КонецЦикла;

	Возврат ТабДокумент;

КонецФункции // ПечатьАктаОбОказанииУслуг()

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли