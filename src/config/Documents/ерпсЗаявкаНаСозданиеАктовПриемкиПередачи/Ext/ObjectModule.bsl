﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ДополнительныеСвойства.Свойство("ПроверятьБлокировку") Тогда 
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Ссылка);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Документ %1 заблокирован", Ссылка));
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;
	
	ерпсАктПриемкиПередачиСервер.УстановитьКлючВСтрокахТабличнойЧасти(ЭтотОбъект,"Товары");
	
	Если Ответственный.Пустая() тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	тз = ПунктыРазгрузки.Выгрузить();
	тз.Свернуть("ПунктРазгрузки,ДатаОтгрузки");
	ОписаниеДокумента = "";
	Для Каждого Стр Из тз Цикл
		ОписаниеДокумента = ОписаниеДокумента + Формат(Стр.ДатаОтгрузки, "ДФ=dd.MM.yyyy") + ", "+Стр.ПунктРазгрузки;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Дата 		  = ТекущаяДата();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	//Ответственный = Пользователи.ТекущийПользователь();
	//Дата 		  = ТекущаяДата();
	//Авто		  = Справочники.Авто.ПустаяСсылка();
	//МаксимальныйКодСтроки = 0;
	//Товары.Очистить();
	//ПунктыРазгрузки.Очистить();
	
КонецПроцедуры


