﻿
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ЗАПОЛНЕНИЯ ДОКУМЕНТОВ И ПРОВЕРКИ ПРАВИЛЬНОСТИ ЗАПОЛНЕНИЯ 

// Возвращает таблицу значений со счетами, используемыми для учета взаиморсчетов
//
// Параметры
//  <ВключатьГруппыСчетов>  	- <Булево> - нужно ли в таблицу включать группы счетов?
//  <РаскрыватьГруппыСчетов>  	- <Булево> - нужно ли в таблицу включать субсчета групп счетов?
//								Если первый параметр установлен в ЛОЖЬ, второй параметр не учитывается (всегда ИСТИНА)
//
// Возвращаемое значение:
//   <ТаблицаЗначений>   - таблица значений с единственной колонкой "СчетУчета"
//
Функция ПолучитьТаблицуСчетовУчетаВзаиморасчетов(ВключатьГруппыСчетов = Ложь, РаскрыватьГруппыСчетов = Истина) Экспорт

	СписокСчетов = Новый Массив;
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоВыданнымАвансам);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСДругимиДебиторами);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученным);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСДругимиКредиторами);

	СписокСчетовИсключить = Новый Массив;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСчетов", 	СписокСчетов);
	Запрос.УстановитьПараметр("СписокСчетовИсключить", СписокСчетовИсключить);
	Запрос.УстановитьПараметр("Контрагенты", 	ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	Запрос.УстановитьПараметр("Договоры", 	  	ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Если ВключатьГруппыСчетов=Истина Тогда
		Если РаскрыватьГруппыСчетов=Истина Тогда
			ТекстУсловия = "";	// и группы счетов и субсчета
		Иначе
			ТекстУсловия = "И Хозрасчетный.ЗапретитьИспользоватьВПроводках=Истина"; // только группы счетов
		КонецЕсли;
	Иначе
		ТекстУсловия = "И Хозрасчетный.ЗапретитьИспользоватьВПроводках=Ложь"; // только счета
	КонецЕсли;

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК СчетРасчетов
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&СписокСчетов)
	|	И (НЕ Хозрасчетный.Ссылка В (&СписокСчетовИсключить))
	|	И Хозрасчетный.ВидыСубконто.ВидСубконто = &Контрагенты
	|	И Хозрасчетный.ВидыСубконто.ВидСубконто = &Договоры
	|	И (НЕ Хозрасчетный.Забалансовый)
	|	" + ТекстУсловия + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Хозрасчетный.Порядок";
						 
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // ПолучитьСчетаВзаиморасчетовПоУмолчанию()

 
// Проверяет возможность проведения в регламентированном учете в зависимости от договора взаиморасчетов.
//
Функция ПроверитьВозможностьПроведенияВРеглУчете(ДокументОбъект, ДоговорКонтрагента, ТекстСообщения = "") Экспорт
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		
	Если ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВидОперации", ДокументОбъект.Ссылка.Метаданные()) Тогда
		ВидОперации = ДокументОбъект.ВидОперации;
	Иначе
		ВидОперации = Неопределено;
	КонецЕсли;
	
	Если ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВалютаДокумента", ДокументОбъект.Ссылка.Метаданные()) Тогда
		ВалютаДокумента = ДокументОбъект.ВалютаДокумента;
	Иначе
		ВалютаДокумента = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ДоговорКонтрагента) тогда
		Возврат Ложь;
	КонецЕсли;
	
	
	ВалютаВзаиморасчетов     = ДоговорКонтрагента.ВалютаВзаиморасчетов;
	
	Если ВалютаВзаиморасчетов <> ВалютаДокумента 
		И ВалютаРегламентированногоУчета <> ВалютаДокумента Тогда
		//Документ выписан в валюте отличной от валюты регламентированного учета и валюты расчетов. Возможно только в документах оплаты.
		ТекстСообщения = НСтр("ru='Валюта документа (%1) отличается 
|от валюты регламентированного учета (%2) 
|и валюты расчетов по договору ""%3"" (%4).';uk='Валюта документа (%1) відрізняється 
|від валюти регламентованого обліку (%2) 
|та валюти розрахунків за договором ""%3"" (%4).'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВалютаДокумента, 
		                                                                         ВалютаРегламентированногоУчета,
		                                                                         ДоговорКонтрагента, ВалютаВзаиморасчетов);
		Возврат Ложь;
	ИначеЕсли ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
		Если ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета Тогда
			//Документ выписан в валюте регламентированного учета. Валюта расчетов иная. 
			ТекстСообщения = НСтр("ru='Валюта расчетов по договору ""%1"" (%2) отличается 
|от валюты регламентированного учета (%3).
|В этом случае документы могут быть выписаны только в валюте расчетов по договору';uk='Валюта розрахунків за договором ""%1"" (%2) відрізняється 
|від валюти регламентованого обліку (%3).
|У цьому випадку документи можуть бути виписані тільки у валюті розрахунків за договором'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДоговорКонтрагента, 
			                                                                         ВалютаВзаиморасчетов,
			                                                                         ВалютаРегламентированногоУчета);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции // ПроверитьВозможностьПроведенияВРеглУчете()



// ОБЩИЕ ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ВидыСубконтоРасчетов()

	ВидыСубконтоРасчетов = Новый Массив;
	ВидыСубконтоРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	ВидыСубконтоРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);

	Возврат ВидыСубконтоРасчетов;

КонецФункции

Функция ВидыСубконтоКонтрагентыДоговоры()

	ВидыСубконтоКонтрагентыДоговоры = Новый Массив;
	ВидыСубконтоКонтрагентыДоговоры.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКонтрагентыДоговоры.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);

	Возврат ВидыСубконтоКонтрагентыДоговоры;

КонецФункции

Функция РазличныеЗначенияКолонкиТаблицы(ТаблицаЗначений, ИмяКолонки)

	ВсеЗначенияКолонки = ТаблицаЗначений.ВыгрузитьКолонку(ИмяКолонки);
	РазличныеЗначения  = ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(ВсеЗначенияКолонки);
	Возврат РазличныеЗначения;

КонецФункции

// Возвращает договор контрагента, если организация, указанная в данном договоре, доступна пользователю
//
Функция ДоступныйДоговорКонтрагента(ДоговорСсылка) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДоговорСсылка", ДоговорСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорыКонтрагентов.Ссылка КАК Договор,
	|	ДоговорыКонтрагентов.Организация
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка = &ДоговорСсылка";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДоговорКонтрагента = Выборка.Договор;

	Иначе
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;

	Возврат ДоговорКонтрагента;

КонецФункции // ДоступныйДоговорКонтрагента()
