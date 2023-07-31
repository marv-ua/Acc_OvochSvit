﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Ложь, Истина, Ложь);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Задолженность покупателей';uk='Заборгованість покупців'") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	ИсключенныеСчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(1);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИсключенныеСчета", ИсключенныеСчета);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", НачалоДня(ПараметрыОтчета.НачалоПериода) + 1);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", Дата(1, 1, 1) + 1);	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", КонецДня(ПараметрыОтчета.КонецПериода) + 1);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", Дата(3999, 1, 1) + 1);	
	КонецЕсли;
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	ОбластьЯчеек = Результат.НайтиТекст("<ДолгНаНачало>");
	Если ОбластьЯчеек <> Неопределено Тогда
		ОбластьЯчеек.Текст = НСтр("ru='Долг на ';uk='Борг на '") + Формат(ПараметрыОтчета.НачалоПериода, "ДФ=dd.MM.yy; ДП=...");
		ОбластьЯчеек = Результат.Область(ОбластьЯчеек.Верх, ОбластьЯчеек.Лево, ОбластьЯчеек.Верх + 1, ОбластьЯчеек.Лево + 5);
		ОбластьЯчеек.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	КонецЕсли;
		
	ОбластьЯчеек = Результат.НайтиТекст("<ДолгНаКонец>");
	Если ОбластьЯчеек <> Неопределено Тогда
		ОбластьЯчеек.Текст = НСтр("ru='Долг на ';uk='Борг на '") + Формат(ПараметрыОтчета.КонецПериода, "ДФ=dd.MM.yy; ДП=...");
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПокупателей").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПокупателями,"");
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПокупателейПоДоговорам").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПокупателями, "");
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;

КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","ЗадолженностьПокупателей", "Задолженность покупателей"));
	Массив.Добавить(Новый Структура("Имя, Представление","ЗадолженностьПокупателейПоДоговорам", "Задолженность покупателей по договорам"));
	
	Возврат Массив;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;

КонецФункции

// Формирует таблицу данных для монитора руководителя по организации на дату
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаЗадолженности - Дата - дата на которую нужны остатки
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПолучитьЗадолженностьПокупателейДляМонитораРуководителя(Организация, ДатаЗадолженности) Экспорт
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	
	Если СписокДоступныхОрганизаций.Найти(Организация) <> Неопределено Тогда
		
		СписокОрганизаций = Новый Массив;
		СписокОрганизаций.Добавить(Организация);
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("Период", Новый Граница(КонецДня(ДатаЗадолженности), ВидГраницы.Включая));
	
	СубконтоКонтрагентДоговор = Новый СписокЗначений;
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос.УстановитьПараметр("СубконтоКонтрагентДоговор", СубконтоКонтрагентДоговор);
	
	СписокСчетов = МониторРуководителя.СчетаРасчетовСКонтрагентами(1);
	Запрос.УстановитьПараметр("СписокСчетов", СписокСчетов);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокДт КАК Сумма,
	               |	ХозрасчетныйОстатки.Счет,
	               |	ХозрасчетныйОстатки.Субконто2 КАК Договор
	               |ПОМЕСТИТЬ Остатки
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	               |			&Период,
	               |			Счет В (&СписокСчетов),
	               |			&СубконтоКонтрагентДоговор,
	               |			Организация В (&Организация)
	               |				И ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))) КАК ХозрасчетныйОстатки
	               |ГДЕ
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокДт > 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Остатки.Контрагент,
	               |	СУММА(Остатки.Сумма) КАК Сумма
	               |ИЗ
	               |	Остатки КАК Остатки
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Остатки.Контрагент
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Сумма УБЫВ";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	
	Для ИндексСтроки = 0 По Мин(2, Результат.Количество() - 1) Цикл
		
		СтрокаРезультата = Результат[ИндексСтроки];
		Контрагент = СтрокаРезультата.Контрагент;
		
		СтрокаДанных = ТаблицаДанных.Добавить();
		СтрокаДанных.Представление 		= Контрагент;
		СтрокаДанных.ДанныеРасшифровки	= Контрагент;
		СтрокаДанных.Порядок 			= 1;
		СтрокаДанных.Сумма 				= СтрокаРезультата.Сумма;
		
	КонецЦикла;   
	
	// Добавляем итог по разделу
	СтрокаДанных = ТаблицаДанных.Добавить();
	СтрокаДанных.Представление 	= НСтр("ru='Итого';uk='Разом'");
	СтрокаДанных.Сумма 			= Результат.Итог("Сумма");
	
	Возврат ТаблицаДанных;			   
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#КонецЕсли