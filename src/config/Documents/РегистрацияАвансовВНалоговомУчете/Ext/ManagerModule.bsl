﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет счета в строке табличной части
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧасти(СтрокаТЧ, ДанныеОбъекта, ИмяТабЧасти) Экспорт

	СчетаУчета = БухгалтерскийУчетРасчетовСКонтрагентами.ПолучитьСчетаРасчетовСКонтрагентом(ДанныеОбъекта.Организация, СтрокаТЧ.Контрагент, СтрокаТЧ.ДоговорКонтрагента);
	
	Если ИмяТабЧасти = "Приобретения" Тогда
		
		Если СтрокаТЧ.ВозвратнаяТара Тогда
			СтрокаТЧ.СтавкаНДС					  	= Перечисления.СтавкиНДС.НеНДС;
			СтрокаТЧ.СчетУчетаНДСНеподтвержденный	= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
			СтрокаТЧ.СчетУчетаНДС				  	= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
			СтрокаТЧ.НалоговоеНазначение 			= СчетаУчета.НалоговоеНазначениеПриобретенийПоТаре;
		Иначе	
			СтрокаТЧ.СтавкаНДС				  		= СчетаУчета.СтавкаНДСПриобретений;
			СтрокаТЧ.СчетУчетаНДСНеподтвержденный 	= СчетаУчета.СчетУчетаНДСПриобретений;
			СтрокаТЧ.СчетУчетаНДС				  	= СчетаУчета.СчетУчетаНДСПриобретенийПодтвержденный;
			СтрокаТЧ.НалоговоеНазначение 			= СчетаУчета.НалоговоеНазначениеПриобретений;
		КонецЕсли;
		
		Если НЕ СтрокаТЧ.ВалютаВзаиморасчетов = ДанныеОбъекта.ВалютаРегламентированногоУчета Тогда
			
			СтрокаТЧ.СтавкаНДС = Перечисления.СтавкиНДС.НеНДС;
		
		КонецЕсли;		
		
	ИначеЕсли ИмяТабЧасти = "Продажи" Тогда
		
		Если СтрокаТЧ.ВозвратнаяТара Тогда
			СтрокаТЧ.СтавкаНДС					  	= Перечисления.СтавкиНДС.НеНДС;
			СтрокаТЧ.СчетУчетаНДСНеподтвержденный	= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
			СтрокаТЧ.СчетУчетаНДС				  	= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		Иначе	
			СтрокаТЧ.СтавкаНДС				  		= СчетаУчета.СтавкаНДСПродаж;
			СтрокаТЧ.СчетУчетаНДСНеподтвержденный 	= СчетаУчета.СчетУчетаНДСПродаж;
			СтрокаТЧ.СчетУчетаНДС				  	= СчетаУчета.СчетУчетаНДСПродажПодтвержденный;
		КонецЕсли;
		
		Если НЕ СтрокаТЧ.ВалютаВзаиморасчетов = ДанныеОбъекта.ВалютаРегламентированногоУчета Тогда
			
			СтрокаТЧ.СтавкаНДС = Перечисления.СтавкиНДС.НДС0;
		
		КонецЕсли;		

	КонецЕсли;

КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧасти()

Процедура РассчитатьКурсВСтрокеТабЧасти(СтрокаТЧ) Экспорт
	
	Если СтрокаТЧ.СуммаВзаиморасчетов <> 0 Тогда
	
		СтрокаТЧ.КурсВзаиморасчетов = СтрокаТЧ.СуммаВзаиморасчетовРегл / СтрокаТЧ.СуммаВзаиморасчетов;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьСуммуВзаиморасчетовРеглВСтрокеТабЧасти(СтрокаТЧ) Экспорт
	
	СтрокаТЧ.СуммаВзаиморасчетовРегл = СтрокаТЧ.СуммаВзаиморасчетов * СтрокаТЧ.КурсВзаиморасчетов / ?(СтрокаТЧ.КратностьВзаиморасчетов = 0, 1, СтрокаТЧ.КратностьВзаиморасчетов);
	
КонецПроцедуры

Процедура УстановитьКурсВзаиморасчетов(СтрокаТЧ, ДанныеОбъекта) Экспорт
	
	Если НЕ СтрокаТЧ.ВалютаВзаиморасчетов = ДанныеОбъекта.ВалютаРегламентированногоУчета Тогда
		
		ДанныеОВалюте = МодульВалютногоУчета.ПолучитьКурсВалюты(СтрокаТЧ.ВалютаВзаиморасчетов, ДанныеОбъекта.Дата);
		Курс = ДанныеОВалюте.Курс;
		Кратность = ДанныеОВалюте.Кратность;
		
	Иначе
		
		Курс 	  = 1;
		Кратность = 1;
		
	КонецЕсли;
	
	СтрокаТЧ.КурсВзаиморасчетов = Курс;
	СтрокаТЧ.КратностьВзаиморасчетов = Кратность;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Регистрация авансов (неоперативный НДС)""';uk='Реєстр документів ""Реєстрація авансів (неоперативний ПДВ)""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли