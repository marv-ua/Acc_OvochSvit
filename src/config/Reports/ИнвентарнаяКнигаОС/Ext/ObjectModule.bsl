﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НачалоПериода > КонецПериода Тогда
		
		ТекстСообщения = НСтр("ru='Неправильно задан период формирования отчета!
|Дата начала больше даты окончания периода.';uk='Неправильно заданий період формування звіту!
|Дата початку більша дати закінчення періоду.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ДатаНач",, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли