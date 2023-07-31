﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	Если Параметры.Свойство("ИзменитьВидОперации") Тогда
		ИзменитьВидОперации = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЗначениеКопирования = Параметры.ЗначениеКопирования;
	ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	Основание           = Параметры.Основание;
	
	Параметры.ЗначениеКопирования = Неопределено;
	Параметры.ЗначенияЗаполнения  = Неопределено;
	Параметры.Основание           = Неопределено;
	
	ФормыДокумента = Новый ФиксированноеСоответствие(
		Документы.ПередачаТоваров.ПолучитьСоответствиеВидовОперацийФормам());
	
	ДоступныеЗначенияВидовОпераций = Перечисления.ВидыОперацийПередачаТоваров.ПолучитьСписокДоступныхЗначений(Неопределено);
	Для Каждого ВидОперации Из ДоступныеЗначенияВидовОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(Объект.ВидОперации);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидОперации)
	
	ЗначенияЗаполнения.Вставить("ВидОперации", ВыбранныйВидОперации);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Параметры.Ключ);
	СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	СтруктураПараметров.Вставить("Основание",           Основание);
	Если ИзменитьВидОперации И ВыбранныйВидОперации <> Объект.ВидОперации Тогда
		СтруктураПараметров.Вставить("ИзменитьВидОперации", ИзменитьВидОперации);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	Если ЗначениеЗаполнено(Параметры.Ключ) Тогда
		КлючеваяОперация = "ОткрытиеФормыПередачаТоваров";
	Иначе
		КлючеваяОперация = "СозданиеФормыПередачаТоваров";
	КонецЕсли;
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
	ОткрытьФорму("Документ.ПередачаТоваров.Форма.ФормаДокументаОбщая", СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры
