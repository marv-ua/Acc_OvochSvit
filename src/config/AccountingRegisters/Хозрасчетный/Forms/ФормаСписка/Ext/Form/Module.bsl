﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ

&НаКлиенте
Функция ПолучитьДокумент()
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не выбран документ';uk='Не вибраний документ'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ТекДокумент = ТекДанные.Регистратор;
	Если НЕ ЗначениеЗаполнено(ТекДокумент) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не выбран документ';uk='Не вибраний документ'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ТекДокумент;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаСервере
Процедура ПереключитьАктивностьПроводокСервер(Документ)
	
	БухгалтерскийУчет.ПереключитьАктивностьПроводокБУ(Документ);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьАктивностьПроводок(Команда)
	
	ТекДокумент = ПолучитьДокумент();
	
	Если ТекДокумент <> Неопределено Тогда
		
		ПереключитьАктивностьПроводокСервер(ТекДокумент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.ТекущиеДанные.Регистратор) = Тип("ДокументСсылка.ОперацияБух") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы       = Новый Структура("ПараметрТекущаяСтрока,Ключ", 
			Элемент.ТекущиеДанные.НомерСтроки, Элемент.ТекущиеДанные.Регистратор);
		ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	Список.Параметры.УстановитьЗначениеПараметра("НадписьНУ", НСтр("ru='НУ:';uk='ПО:'"));
	Список.Параметры.УстановитьЗначениеПараметра("НадписьКоличество", НСтр("ru='Кол:';uk='Кіл:'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, , Параметр);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

