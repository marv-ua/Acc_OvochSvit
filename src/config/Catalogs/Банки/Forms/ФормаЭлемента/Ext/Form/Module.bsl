﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповестим форму банковского счета об изменении реквизитов банка
	Оповестить("ЗаписанЭлементБанк", Объект.Ссылка, ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Параметры.Код <> "" Тогда
			Объект.Код = Параметры.Код;
		КонецЕсли;
		
		Если Параметры.КоррСчет <> "" Тогда
			Объект.КоррСчет = Параметры.КоррСчет;
		КонецЕсли;

	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры
