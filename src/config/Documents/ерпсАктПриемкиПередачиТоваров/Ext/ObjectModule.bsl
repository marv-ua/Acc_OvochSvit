﻿

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ерпсАктПриемкиПередачиСервер.УстановитьКлючВСтрокахТабличнойЧасти(ЭтотОбъект,"Товары");
	
	Если Ответственный.Пустая() тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ПустаяСтрока(АдрессДоставки) 
		и НЕ ПунктРазгрузки.Пустая() тогда
		АдрессДоставки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПунктРазгрузки,"Наименование");
	КонецЕсли;
	
	Если Статус.Пустая() тогда
		Статус		  = Перечисления.ерпсСтатусыАктовПриемкиПередачи.Создан;
	КонецЕсли;
	
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Дата 		  = ТекущаяДата();
	Статус		  = Перечисления.ерпсСтатусыАктовПриемкиПередачи.Создан;
КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Дата 		  = ТекущаяДата();
	Авто		  = Справочники.Авто.ПустаяСсылка();
	
	МаксимальныйКодСтроки = 0;
	
	Товары.Очистить();
	
КонецПроцедуры

