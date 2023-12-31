﻿////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ


// Проверяет остаток денежных средств
//
Процедура ПроверитьОстатокДенежныхСредств(Сумма, Организация, Валюта=Неопределено, МоментВремени,  Счет, СубконтоФильтр=Неопределено, Заголовок) Экспорт
	
	РеестрОстатков = РегистрыБухгалтерии.Хозрасчетный;
	СтруктураОтбора = Новый Структура("Счет",Счет);
	СтруктураОтбора.Вставить("Организация", Организация);
	Если Валюта <> Неопределено Тогда
		СтруктураОтбора.Вставить("Валюта", Валюта);
	КонецЕсли;	
	
	Реквизиты = "Счет, Валюта";
	
	Для каждого ВидСубконто из Счет.ВидыСубконто Цикл
		Если ВидСубконто.ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбособленныеПодразделенияБезОбразованияЮрЛица Тогда
			НомерСубконто = Строка(Счет.ВидыСубконто.Индекс(ВидСубконто)+1);
			Реквизиты=Реквизиты+",Субконто"+НомерСубконто;
			СтруктураОтбора.Вставить("Субконто"+НомерСубконто,?( СубконтоФильтр = Неопределено, Справочники.ОбособленныеПодразделенияОрганизаций.ПустаяСсылка(), СубконтоФильтр));
		ИначеЕсли ВидСубконто.ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.БанковскиеСчета Тогда
			НомерСубконто = Строка(Счет.ВидыСубконто.Индекс(ВидСубконто)+1);
			Реквизиты=Реквизиты+",Субконто"+НомерСубконто;
			СтруктураОтбора.Вставить("Субконто"+НомерСубконто,?( СубконтоФильтр = Неопределено, Справочники.БанковскиеСчета.ПустаяСсылка(), СубконтоФильтр));
		КонецЕсли;
	КонецЦикла;
	
	РеестрОстатков=РеестрОстатков.Остатки(МоментВремени,,СтруктураОтбора,Реквизиты,"Сумма,ВалютнаяСумма");
	
	Остаток = 0;
	Для каждого Стр из РеестрОстатков цикл
		Если Валюта = Неопределено Тогда
			Остаток = Остаток + Стр.СуммаОстатокДт-Стр.СуммаОстатокКт;
		Иначе	
			Остаток = Остаток + Стр.ВалютнаяСуммаОстатокДт-Стр.ВалютнаяСуммаОстатокКт;
		КонецЕсли;
	КонецЦикла;
	
	Если Остаток < Сумма Тогда 
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Сумма документа (%1) превышает остаток денежных средств (%2)!';uk='Сума документа (%1) перевищує залишок коштів (%2)!'"),Формат(Сумма,"ЧЦ=15; ЧДЦ=2; ЧН=0.00"),Формат(Остаток,"ЧЦ=15; ЧДЦ=2; ЧН=0.00"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		Возврат;
	Иначе
		Возврат;
	КонецЕсли;
	
Конецпроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОПЛАТЫ


// Возвращает признак ведения в информационной базе учета по статьям ДДС
//
Функция ЕстьУчетПоСтатьямДДС() Экспорт
	
	Возврат НЕ (ПланыСчетов.Хозрасчетный.Касса.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиДвиженияДенежныхСредств, "ВидСубконто") = Неопределено);
	
КонецФункции //ЕстьУчетПоСтатьямДДС()

Функция ПодготовитьТаблицуОплат(СтруктураШапкиДокумента) Экспорт

	Перем ВидОперации;

	СтруктураШапкиДокумента.Свойство("ВидОперации",ВидОперации);
                                      
	Ссылка       = СтруктураШапкиДокумента.Ссылка;
	ВидДокумента = СтруктураШапкиДокумента.ВидДокумента;
	
	ЭтоВозврат   = (БухгалтерскийУчетРасчетовСКонтрагентами.ОпределениеНаправленияДвиженияДляДокументаДвиженияДенежныхСредств(ВидДокумента,ВидОперации).РасчетыВозврат = Перечисления.РасчетыВозврат.Возврат);

	//Зафиксируем расчеты-возврат в структуре шапки документа 
	СтруктураШапкиДокумента.Вставить("ЭтоВозврат",ЭтоВозврат);

	ИмяТабличнойЧасти =?(ВидДокумента="АвансовыйОтчет","ОплатаПоставщикам","РасшифровкаПлатежа");
	
	Если ВидДокумента="ПоступлениеНаРасчетныйСчет" 
	 	Или ВидДокумента="ПлатежныйОрдерПоступлениеДенежныхСредств" 
	 	Или ВидДокумента="ПриходныйКассовыйОрдер" Тогда
		
		ТекстОС = ", ТаблицаПлатежей.ОстаточнаяСтоимостьОС КАК СтоимостьОС";
		
 	Иначе
		
		ТекстОС = ", 0 КАК СтоимостьОС";
		
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",     Ссылка);
	Запрос.УстановитьПараметр("ЭтоВозврат", ЭтоВозврат);
	Запрос.УстановитьПараметр("ПоРасчетнымДокументам",  Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам);
	
	РассчитатьСуммуВВалютеРеглУчета = не (СтруктураШапкиДокумента.ВалютаДокумента = СтруктураШапкиДокумента.ВалютаРегламентированногоУчета);

	Запрос.УстановитьПараметр("РассчитатьСуммуВВалютеРеглУчета",РассчитатьСуммуВВалютеРеглУчета);
	
	ВалютнаяСуммаВКолонкеВзаиморасчетов = Истина;
	Запрос.УстановитьПараметр("ВалютнаяСуммаВКолонкеВзаиморасчетов",ВалютнаяСуммаВКолонкеВзаиморасчетов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПлатежей.ДоговорКонтрагента.Владелец КАК Контрагент,
	|	ТаблицаПлатежей.ДоговорКонтрагента,
	|	ТаблицаПлатежей.ДоговорКонтрагента.ВедениеВзаиморасчетов КАК ВедениеВзаиморасчетов,
	|	ТаблицаПлатежей.ДоговорКонтрагента.ВидДоговора КАК ВидДоговора,
	|	ТаблицаПлатежей.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ТаблицаПлатежей.ДоговорКонтрагента.НеОтноситьНаЗатратыПоНУ КАК НеОтноситьНаЗатратыПоНУ,	
	|	ТаблицаПлатежей.КурсВзаиморасчетов,
	|	ТаблицаПлатежей.КратностьВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА ТаблицаПлатежей.ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоРасчетнымДокументам
	|				ИЛИ &ЭтоВозврат = ИСТИНА
	|			ТОГДА ТаблицаПлатежей.Сделка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Сделка,
	|	ВЫБОР
	|		КОГДА &ЭтоВозврат = ИСТИНА
	|			ТОГДА ТаблицаПлатежей.СчетУчетаРасчетовПоАвансам
	|		ИНАЧЕ ТаблицаПлатежей.СчетУчетаРасчетовСКонтрагентом
	|	КОНЕЦ КАК СчетОплаты,
	|	ВЫБОР
	|		КОГДА &ЭтоВозврат = ИСТИНА
	|			ТОГДА ТаблицаПлатежей.СчетУчетаРасчетовСКонтрагентом
	|		ИНАЧЕ ТаблицаПлатежей.СчетУчетаРасчетовПоАвансам
	|	КОНЕЦ КАК СчетАванса,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА &РассчитатьСуммуВВалютеРеглУчета = ИСТИНА
	|				ТОГДА ВЫБОР
	|						КОГДА &ВалютнаяСуммаВКолонкеВзаиморасчетов = ИСТИНА
	|							ТОГДА ТаблицаПлатежей.СуммаВзаиморасчетов
	|						ИНАЧЕ ТаблицаПлатежей.СуммаПлатежа
	|					КОНЕЦ * ТаблицаПлатежей.КурсВзаиморасчетов / ТаблицаПлатежей.КратностьВзаиморасчетов
	|			ИНАЧЕ ВЫБОР
	|					КОГДА &ВалютнаяСуммаВКолонкеВзаиморасчетов = ИСТИНА
	|						ТОГДА ТаблицаПлатежей.СуммаПлатежа
	|					ИНАЧЕ ТаблицаПлатежей.СуммаВзаиморасчетов
	|				КОНЕЦ
	|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ГривневаяСумма,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА &РассчитатьСуммуВВалютеРеглУчета = ИСТИНА
	|				ТОГДА ТаблицаПлатежей.СуммаНДС * ТаблицаПлатежей.КурсВзаиморасчетов / ТаблицаПлатежей.КратностьВзаиморасчетов
	|			ИНАЧЕ ТаблицаПлатежей.СуммаНДС
	|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА &ВалютнаяСуммаВКолонкеВзаиморасчетов = ИСТИНА
	|				ТОГДА ТаблицаПлатежей.СуммаВзаиморасчетов
	|			ИНАЧЕ ТаблицаПлатежей.СуммаПлатежа
	|		КОНЕЦ КАК ЧИСЛО) КАК ВалютнаяСумма,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.СуммаВзаиморасчетов КАК ЧИСЛО) КАК СуммаВзаиморасчетов,
	|	ТаблицаПлатежей.СтатьяДвиженияДенежныхСредств КАК СтатьяДДС,
	|	ТаблицаПлатежей.ЗаТару КАК ВозвратнаяТара,
	|	ТаблицаПлатежей.Амортизируется КАК Амортизируется,
	|	ТаблицаПлатежей.СтатьяДекларацииПоЕдиномуНалогу КАК СтатьяДекларацииПоЕдиномуНалогу"+ТекстОС+"
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета.РасшифровкаПлатежа КАК ТаблицаПлатежей
	|ГДЕ
	|	ТаблицаПлатежей.Ссылка = &Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"СписаниеСРасчетногоСчета.РасшифровкаПлатежа",Строка(ВидДокумента+"."+ИмяТабличнойЧасти));
	Если ВидДокумента="АвансовыйОтчет" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"СуммаПлатежа","Сумма");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"ТаблицаПлатежей.СтатьяДвиженияДенежныхСредств","Неопределено");
	КонецЕсли; 
	
	РеестрПлатежей = Запрос.Выполнить().Выгрузить();
	
	//Дополнение информацией о корр. счете
	РеестрПлатежей.Колонки.Добавить("КоррСчет",Новый описаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	РеестрПлатежей.ЗаполнитьЗначения(СтруктураШапкиДокумента.КоррСчет,"КоррСчет");
	
	Если СтруктураШапкиДокумента.Дата >= '20120101' Тогда
		РеестрПлатежей.ЗаполнитьЗначения(Ложь,"НеОтноситьНаЗатратыПоНУ");	
	КонецЕсли;
	
	Для НомерСубконто = 1 По 3 Цикл
		РеестрПлатежей.Колонки.Добавить("КоррСубконто"+НомерСубконто);
	КонецЦикла; 

	Для каждого Субконто из СтруктураШапкиДокумента.КоррСчет.ВидыСубконто Цикл

		Если Субконто.ВидСубконто =  ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиДвиженияДенежныхСредств тогда
			РеестрПлатежей.ЗагрузитьКолонку(РеестрПлатежей.ВыгрузитьКолонку("СтатьяДДС"),"КоррСубконто"+Субконто.НомерСтроки);
		ИначеЕсли Субконто.ВидСубконто =  ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.БанковскиеСчета тогда
			РеестрПлатежей.ЗаполнитьЗначения(СтруктураШапкиДокумента.СчетОрганизации,"КоррСубконто"+Субконто.НомерСтроки);
		ИначеЕсли Субконто.ВидСубконто =  ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбособленныеПодразделенияБезОбразованияЮрЛица тогда
			РеестрПлатежей.ЗаполнитьЗначения(СтруктураШапкиДокумента.ОбособленноеПодразделениеОрганизации,"КоррСубконто"+Субконто.НомерСтроки);
		ИначеЕсли Субконто.ВидСубконто =  ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций тогда
			РеестрПлатежей.ЗаполнитьЗначения(СтруктураШапкиДокумента.ФизЛицо,"КоррСубконто"+Субконто.НомерСтроки);
		Иначе
		КонецЕсли;

	КонецЦикла;

	Для каждого СтрокаПлатежа из РеестрПлатежей Цикл

		Если НЕ ЗначениеЗаполнено(СтрокаПлатежа.Сделка) тогда
			СтрокаПлатежа.Сделка = Неопределено;
		КонецЕсли;

	КонецЦикла;

	Возврат РеестрПлатежей;

КонецФункции

Функция НомерБанковскогоСчетаСоответствуетСтандартуIBAN(НомерСчета) Экспорт
	
	Результат = Ложь;
	
	ДлинаНомера = СтрДлина(НомерСчета);
	КодСтраны = Лев(НомерСчета, 2);
	
	Если КодСтраны = "UA" И ДлинаНомера = 29 Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьБанкПоНомеруСчетаIBAN(НомерСчета) Экспорт
	
	БанкПоСчету = Неопределено;
	
	КодБанка = ПолучитьКодБанкаПоНомеруСчетаIBAN(НомерСчета);
	
	Если ЗначениеЗаполнено(КодБанка) Тогда
		
		БанкПоСчету = Справочники.Банки.НайтиПоКоду(КодБанка);
		Если БанкПоСчету.Пустая() или БанкПоСчету.ЭтоГруппа Тогда
			БанкПоСчету = "";			
		КонецЕсли;		
	КонецЕсли;
	
	Возврат БанкПоСчету;
	
КонецФункции

Функция ПолучитьКодБанкаПоНомеруСчетаIBAN(НомерСчета) Экспорт
	
	КодБанка = "";
	
	Если НомерБанковскогоСчетаСоответствуетСтандартуIBAN(НомерСчета) Тогда
		КодБанка = Сред(НомерСчета, 5, 6);
	КонецЕсли;
	
	Возврат КодБанка;
	
КонецФункции


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ НУМЕРАЦИИ

// Формирует числовой номер
Процедура СформироватьЧисловойНомерДокумента(СтруктураПараметров, СформированныйНомер) 
	
	ПодготовитьСтруктуруПараметров(СтруктураПараметров);
	
	// автоматическая нумерация
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.Нумерация");
		ЭлементБлокировки.УстановитьЗначение("Нумератор", 		СтруктураПараметров.Нумератор);
		ЭлементБлокировки.УстановитьЗначение("ПериодНумерации", СтруктураПараметров.ПериодНумерации);
		ЭлементБлокировки.УстановитьЗначение("Организация", 	СтруктураПараметров.Организация);
		ЭлементБлокировки.УстановитьЗначение("БанковскийСчет", 	СтруктураПараметров.БанковскийСчет);
		ЭлементБлокировки.УстановитьЗначение("Валюта", 	        СтруктураПараметров.Валюта);
		ЭлементБлокировки.УстановитьЗначение("ОбособленноеПодразделение", 	СтруктураПараметров.ОбособленноеПодразделение);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекущийНомер = РегистрыСведений.Нумерация.Получить(СтруктураПараметров).ТекущийНомер;
		СформированныйНомер = ТекущийНомер + 1;
		
		ЗафиксироватьТранзакцию();	
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Формирует строковый номер
Процедура СформироватьСтроковыйНомерДокумента(СтруктураПараметров, СформированныйНомер) Экспорт
	
	Если СформированныйНомер = "" Тогда
		ЧисловойНомер = 0;
	Иначе
		ЧисловойНомер = Число(СформированныйНомер);
	КонецЕсли;
	
	СформироватьЧисловойНомерДокумента(СтруктураПараметров, ЧисловойНомер);
	
	СформированныйНомер = Формат(ЧисловойНомер, "ЧГ=0");
	
КонецПроцедуры

// Увеличивает очередной номер (при записи документа)
Процедура ЗаписатьОчереднойНомер(СтруктураПараметров, СформированныйНомер) Экспорт
	
	ПодготовитьСтруктуруПараметров(СтруктураПараметров);
	
	ЧисловойНомер = Число(СформированныйНомер);
	
	ТекущийНомер = РегистрыСведений.Нумерация.Получить(СтруктураПараметров).ТекущийНомер;
	
	Если ЧисловойНомер > ТекущийНомер Тогда
		МенеджерЗаписи = РегистрыСведений.Нумерация.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Нумератор 		= СтруктураПараметров.Нумератор;
		МенеджерЗаписи.ПериодНумерации 	= СтруктураПараметров.ПериодНумерации;
		МенеджерЗаписи.Организация	 	= СтруктураПараметров.Организация;
		МенеджерЗаписи.БанковскийСчет   = СтруктураПараметров.БанковскийСчет;
		МенеджерЗаписи.Валюта	 	    = СтруктураПараметров.Валюта;
		МенеджерЗаписи.ОбособленноеПодразделение = СтруктураПараметров.ОбособленноеПодразделение;
		МенеджерЗаписи.ТекущийНомер 	= ЧисловойНомер;
		МенеджерЗаписи.Записать();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПодготовитьСтруктуруПараметров(СтруктураПараметров)
	
	Если НЕ СтруктураПараметров.Свойство("БанковскийСчет") Тогда
		СтруктураПараметров.Вставить("БанковскийСчет", Справочники.БанковскиеСчета.ПустаяСсылка());
	КонецЕсли;
	Если НЕ СтруктураПараметров.Свойство("Валюта") Тогда
		СтруктураПараметров.Вставить("Валюта", Справочники.Валюты.ПустаяСсылка());
	КонецЕсли;
	Если НЕ СтруктураПараметров.Свойство("ОбособленноеПодразделение") Тогда
		СтруктураПараметров.Вставить("ОбособленноеПодразделение", Справочники.ОбособленныеПодразделенияОрганизаций.ПустаяСсылка());
	КонецЕсли;
	Если НЕ СтруктураПараметров.Свойство("ПериодНумерации") Тогда
		ПериодНумерации = НачалоПериодаНумерации(СтруктураПараметров.Дата);
		СтруктураПараметров.Вставить("ПериодНумерации", ПериодНумерации);
		СтруктураПараметров.Удалить("Дата");
	КонецЕсли;
	
КонецПроцедуры

// Вычисляет начало периода нумерации
Функция НачалоПериодаНумерации(Дата) Экспорт
	
	ПериодНумерации = НачалоГода(Дата);
		
	Возврат ПериодНумерации;
	
КонецФункции
