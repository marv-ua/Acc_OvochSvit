﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ВводВЭксплуатациюОС") Тогда
		Дата				= Основание.Дата;
		Организация			= Основание.Организация;
		ДокументОснование	= Основание;
		МОЛБУ				= Основание.МОЛБУ;
		СрокПолезногоИспользованияБУ = Основание.СрокПолезногоИспользованияБУ;
		ПодразделениеОрганизации = Основание.ПодразделениеОрганизации;
		
		Для Каждого СтрОснования Из Основание.ОС Цикл
			НовСтр			= ОС.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, СтрОснования);
		КонецЦикла;
		
		Ответственный = Пользователи.ТекущийПользователь();
		
	КонецЕсли;

КонецПроцедуры
