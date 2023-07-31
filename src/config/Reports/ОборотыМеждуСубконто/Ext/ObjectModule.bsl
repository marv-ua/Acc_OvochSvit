﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	
	Для Каждого ВидСубконто Из СписокВидовСубконто Цикл
		Если НЕ ЗначениеЗаполнено(ВидСубконто.Значение) Тогда
			ТекстСообщения = НСтр("ru='Список видов субконто не заполнен';uk='Список видів субконто не заповнений'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Отчет.СписокВидовСубконто",, Отказ);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ВидСубконто Из СписокВидовКорСубконто Цикл
		Если НЕ ЗначениеЗаполнено(ВидСубконто.Значение) Тогда
			ТекстСообщения = НСтр("ru='Список видов кор. субконто не заполнен';uk='Список видів кор. субконто не заповнений'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Отчет.СписокВидовКорСубконто",, Отказ);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
#КонецЕсли