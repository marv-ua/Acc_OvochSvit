﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Список.Параметры.УстановитьЗначениеПараметра("КонецТекущегоГода",  КонецГода(ТекущаяДатаСеанса()));
	
	Если Параметры.Отбор.Свойство("Организация")
		И ТипЗнч(Параметры.Отбор.Организация) = Тип("СправочникСсылка.Организации") Тогда
		
		ОтборОрганизация = Параметры.Отбор.Организация;
		
	Иначе
		
		ОтборОрганизация = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОтборОрганизация = ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, , Параметр);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОсновнаяОрганизацияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры
