﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ МОДУЛЯ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ВалютаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВалютаВзаиморасчетов");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата              = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	ДокументОснование = Неопределено;
	
КонецПроцедуры


#КонецЕсли