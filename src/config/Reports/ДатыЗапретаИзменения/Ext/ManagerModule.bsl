﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиОтчета.Включен = Ложь;
	
	ПервыйВариант = ПервыйВариант();
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ПервыйВариант.Имя);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ПервыйВариант.Описание;
	
	ВторойВариант = ВторойВариант();
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ВторойВариант.Имя);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ВторойВариант.Описание;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "Форма" Тогда
		Возврат;
	КонецЕсли;
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
#Иначе
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
#КонецЕсли
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "ФормаОтчета";
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Вызывается из форма отчета.
Процедура УстановитьВариант(Форма, Вариант) Экспорт
	
	ПервыйВариант = ПервыйВариант();
	ВторойВариант = ВторойВариант();
	
	НастроитьФорму(Форма, ПервыйВариант, ВторойВариант, Вариант);
	
КонецПроцедуры

// Вызывается процедур УстановитьВариант.
Процедура НастроитьФорму(Форма, ПервыйВариант, ВторойВариант, Вариант) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если Вариант = 0 Тогда
		Форма.Параметры.СформироватьПриОткрытии = Истина;
		Элементы.ФормаПервыйВариант.Заголовок = ПервыйВариант.Заголовок;
		Элементы.ФормаВторойВариант.Заголовок = ВторойВариант.Заголовок;
	Иначе
		ПолноеИмяОтчета = "Отчет." + СтрРазделить(Форма.ИмяФормы, ".", Ложь)[1];
		
		// Сохранение текущих пользовательских настроек.
		ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(
			ПолноеИмяОтчета + "/" + Форма.КлючТекущегоВарианта + "/ТекущиеПользовательскиеНастройки",
			"",
			Форма.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
	КонецЕсли;
	
	Если Вариант = 0 Тогда
		Если Форма.КлючТекущегоВарианта = ПервыйВариант.Имя Тогда
			Вариант = 1;
		ИначеЕсли Форма.КлючТекущегоВарианта = ВторойВариант.Имя Тогда
			Вариант = 2;
		КонецЕсли;
	КонецЕсли;
	
	Если Вариант = 0 Тогда
		Вариант = 1;
	КонецЕсли;
	
	Если Вариант = 1 Тогда
		Элементы.ФормаПервыйВариант.Пометка = Истина;
		Элементы.ФормаВторойВариант.Пометка = Ложь;
		Форма.Заголовок = ПервыйВариант.Заголовок;
		КлючТекущегоВарианта = ПервыйВариант.Имя;
	Иначе
		Элементы.ФормаПервыйВариант.Пометка = Ложь;
		Элементы.ФормаВторойВариант.Пометка = Истина;
		Форма.Заголовок = ВторойВариант.Заголовок;
		КлючТекущегоВарианта = ВторойВариант.Имя;
	КонецЕсли;
	
	// Загрузка нового варианта.
	Форма.УстановитьТекущийВариант(КлючТекущегоВарианта);
	
	// Переформирование отчета.
	Форма.СкомпоноватьРезультат(РежимКомпоновкиРезультата.Авто);
	
КонецПроцедуры

Функция ПервыйВариант()
	
	Попытка
		Свойства = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	Исключение
		Свойства = Новый Структура("ПоказыватьРазделы, ВсеРазделыБезОбъектов", Ложь, Истина);
	КонецПопытки;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоПользователям";
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоПользователямБезОбъектов";
	Иначе
		ИмяВарианта = "ДатыЗапретаИзмененияПоПользователямБезРазделов";
	КонецЕсли;
	
	СвойстваВарианта = Новый Структура;
	СвойстваВарианта.Вставить("Имя", ИмяВарианта);
	
	СвойстваВарианта.Вставить("Заголовок",
		НСтр("ru='Даты запрета изменения данных по пользователям';uk='Дати заборони зміни даних по користувачах'"));
	
	СвойстваВарианта.Вставить("Описание",
		НСтр("ru='Выводит даты запрета изменения, сгруппированные по пользователям.';uk='Виводить дати заборони зміни, згруповані за користувачам.'"));
	
	Возврат СвойстваВарианта;
	
КонецФункции

Функция ВторойВариант()
	
	Попытка
		Свойства = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	Исключение
		Свойства = Новый Структура("ПоказыватьРазделы, ВсеРазделыБезОбъектов", Ложь, Истина);
	КонецПопытки;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоРазделамОбъектамДляПользователей";
		Заголовок = НСтр("ru='Даты запрета изменения данных по разделам и объектам';uk='Дати заборони зміни даних по розділах і об''єктах'");
		ОписаниеВарианта =
			НСтр("ru='Выводит даты запрета изменения, сгруппированные по разделам с объектами.';uk='Виводить дати заборони зміни, згруповані за розділами з об''єктами.'");
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоРазделамДляПользователей";
		Заголовок = НСтр("ru='Даты запрета изменения данных по разделам';uk='Дати заборони зміни даних по розділах'");
		ОписаниеВарианта =
			НСтр("ru='Выводит даты запрета изменения, сгруппированные по разделам.';uk='Виводить дати заборони зміни, згруповані за розділами.'");
	Иначе
		ИмяВарианта = "ДатыЗапретаИзмененияПоОбъектамДляПользователей";
		Заголовок = НСтр("ru='Даты запрета изменения данных по объектам';uk='Дати заборони зміни даних по об''єктах'");
		ОписаниеВарианта =
			НСтр("ru='Выводит даты запрета изменения, сгруппированные по объектам.';uk='Виводить дати заборони зміни, згруповані по об''єктах.'");
	КонецЕсли;
	
	СвойстваВарианта = Новый Структура;
	СвойстваВарианта.Вставить("Имя",       ИмяВарианта);
	СвойстваВарианта.Вставить("Заголовок", Заголовок);
	СвойстваВарианта.Вставить("Описание",  ОписаниеВарианта);
	
	Возврат СвойстваВарианта;
	
КонецФункции

#КонецОбласти

#КонецЕсли
