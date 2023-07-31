﻿// Возвращает признак расчетов с контрагентами
//
Функция ЕстьРасчетыСКонтрагентами(ВидОперации = Неопределено) Экспорт

	ЕстьРасчеты = (
		    ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ОплатаПоставщику")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ОплатаПокупателя")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ПрочиеРасчетыСКонтрагентами")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ВозвратДенежныхСредствПокупателю")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ОплатаПоставщику")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ВозвратДенежныхСредствПоставщиком")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ПрочиеРасчетыСКонтрагентами"));
		

	Возврат ЕстьРасчеты;

КонецФункции 

// Возвращает признак расчетов с контрагентами
//
Функция ЕстьРасчетыПоКредитам(ВидОперации = Неопределено) Экспорт

	ЕстьРасчеты = 
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.РасчетыПоКредитамИЗаймамСКонтрагентами")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.РасчетыПоКредитамИЗаймамСКонтрагентами")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймамСКонтрагентами")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.РасчетыПоКредитамИЗаймам");

	Возврат ЕстьРасчеты;

КонецФункции 

// Возвращает признак расчетов с контрагентами
//
Функция ЕстьРасчетыПоПлатежнымКартам(ВидОперации = Неопределено) Экспорт

	ЕстьРасчеты = 
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажПоПлатежнымКартамИБанковскимКредитам");

	Возврат ЕстьРасчеты;

КонецФункции 

// Возвращает вид договора с контрагентом по виду операции
//
Функция ОпределитьВидДоговораСКонтрагентом(ВидОперации = Неопределено) Экспорт

	СПоставщиком = Новый Массив;
	СПоставщиком.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"));
	СПоставщиком.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));
	СПоставщиком.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"));

	СПокупателем = Новый Массив;
	СПокупателем.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"));
	СПокупателем.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"));
	СПокупателем.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));

	Прочее = Новый Массив;
	Прочее.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));

	Если ЗначениеЗаполнено(ВидОперации) тогда

		//Определение вида операции

		ВидДоговораПоВидуОпераций = Новый Соответствие();

		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ОплатаПоставщику"), СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.РасчетыПоКредитамИЗаймамСКонтрагентами"), Прочее);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю"), СПокупателем);

		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ОплатаПокупателя"), СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.РасчетыПоКредитамИЗаймамСКонтрагентами"), Прочее);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком"), СПоставщиком);

		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику"), СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймамСКонтрагентами"), Прочее);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ВозвратДенежныхСредствПокупателю"), СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ПрочиеРасчетыСКонтрагентами"), Прочее);

		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя"), СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ВозвратДенежныхСредствПоставщиком"), СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.РасчетыПоКредитамИЗаймам"), Прочее);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ПокупкаПродажаВалюты"), Прочее);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажПоПлатежнымКартамИБанковскимКредитам"), Прочее);
		ВидДоговораПоВидуОпераций.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ПрочиеРасчетыСКонтрагентами"), Прочее);

		ВидДоговора = ВидДоговораПоВидуОпераций[ВидОперации];

		Если НЕ ВидДоговора = Неопределено Тогда
			Возврат ВидДоговора;
		Иначе
			Возврат Новый Массив;

		КонецЕсли;

	Иначе

		Возврат Новый Массив;

	Конецесли;

КонецФункции 

