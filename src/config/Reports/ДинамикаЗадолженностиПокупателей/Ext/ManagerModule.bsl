﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьВнешниеНаборыДанных,
							|ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки,
							|ИспользоватьРасширенныеПараметрыРасшифровки",
							Истина, Истина, Ложь, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Динамика задолженности покупателей';uk='Динаміка заборгованості покупців'") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ПросроченнаяЗадолженность = Новый ТаблицаЗначений;
	ПросроченнаяЗадолженность.Колонки.Добавить("Период");
	ПросроченнаяЗадолженность.Колонки.Добавить("Организация");
	ПросроченнаяЗадолженность.Колонки.Добавить("Контрагент");
	ПросроченнаяЗадолженность.Колонки.Добавить("Договор");
	ПросроченнаяЗадолженность.Колонки.Добавить("ПросроченнаяЗадолженность");
	ПросроченнаяЗадолженность.Колонки.Добавить("ПросроченнаяЗадолженностьНачальныйОстаток");
	
	Если ПараметрыОтчета.ПоказательПросроченнаяЗадолженность Тогда
		НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
		КонецПериода  = КонецДня(?(ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода), ПараметрыОтчета.КонецПериода, Дата(3999, 1, 1)));
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МИНИМУМ(Хозрасчетный.Период) КАК НачалоПериода,
		|	МАКСИМУМ(Хозрасчетный.Период) КАК КонецПериода
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный";
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			НачалоПериода = Макс(НачалоПериода, Выборка.НачалоПериода);
			КонецПериода  = Мин(КонецПериода, Выборка.КонецПериода);
		КонецЕсли;
		
		ТаблицаПериоды = Новый ТаблицаЗначений;
		ТаблицаПериоды.Колонки.Добавить("ПериодНачало");
		ТаблицаПериоды.Колонки.Добавить("ПериодКонец");
		Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
		
		КонецПериода  = БухгалтерскиеОтчетыКлиентСервер.КонецПериода(КонецПериода, Периодичность);
		
		Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода)
			И КонецПериода < ПараметрыОтчета.КонецПериода Тогда
			КонецПериода = ПараметрыОтчета.КонецПериода;
		КонецЕсли;
		
		ТекущаяДата = НачалоПериода;
		
		Пока ТекущаяДата <= КонецПериода Цикл
			НоваяСтрока = ТаблицаПериоды.Добавить();
			Если Периодичность = 6 Тогда // День
				НоваяСтрока.ПериодНачало = НачалоДня(ТекущаяДата);
				НоваяСтрока.ПериодКонец  = КонецДня(ТекущаяДата);
				
				ТекущаяДата = ТекущаяДата + 86400;
			ИначеЕсли Периодичность = 7 Тогда // Неделя
				НоваяСтрока.ПериодНачало = НачалоНедели(ТекущаяДата);
				НоваяСтрока.ПериодКонец  = КонецНедели(ТекущаяДата);
				
				ТекущаяДата = КонецНедели(ТекущаяДата) + 86400 * 7;
			ИначеЕсли Периодичность = 9 Тогда // Месяц
				НоваяСтрока.ПериодНачало = НачалоМесяца(ТекущаяДата);
				НоваяСтрока.ПериодКонец  = КонецМесяца(ТекущаяДата);
				
				ТекущаяДата = ДобавитьМесяц(НачалоМесяца(ТекущаяДата), 1);
			ИначеЕсли Периодичность = 10 Тогда // Квартал
				НоваяСтрока.ПериодНачало = НачалоКвартала(ТекущаяДата);
				НоваяСтрока.ПериодКонец  = КонецКвартала(ТекущаяДата);
				
				ТекущаяДата = ДобавитьМесяц(НачалоКвартала(ТекущаяДата), 3);
			ИначеЕсли Периодичность = 11 Тогда // Полугодие
				Если Месяц(ТекущаяДата) > 6 Тогда
					НоваяСтрока.ПериодНачало = НачалоДня(Дата(Год(ТекущаяДата), 7, 1));
					НоваяСтрока.ПериодКонец  = КонецГода(ТекущаяДата);
				Иначе
					НоваяСтрока.ПериодНачало = НачалоДня(Дата(Год(ТекущаяДата), 1, 1));
					НоваяСтрока.ПериодКонец  = КонецМесяца(Дата(Год(ТекущаяДата), 6, 1));
				КонецЕсли;
				
				ТекущаяДата = ДобавитьМесяц(ТекущаяДата, 6);
			ИначеЕсли Периодичность = 12 Тогда // Год
				НоваяСтрока.ПериодНачало = НачалоГода(ТекущаяДата);
				НоваяСтрока.ПериодКонец  = КонецГода(ТекущаяДата);
				
				ТекущаяДата = ДобавитьМесяц(НачалоГода(ТекущаяДата), 12);
			КонецЕсли;			
		КонецЦикла;
		
		
		
		Для Каждого Период Из ТаблицаПериоды Цикл
			ВременнаяТаблица = ПолучитьПросроченнуюЗадолженность(ПараметрыОтчета, Период.ПериодКонец);			
			Для Каждого СтрокаТаблицы Из ВременнаяТаблица Цикл
				НоваяСтрока = ПросроченнаяЗадолженность.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
				НоваяСтрока.Период = Период.ПериодНачало;
				НоваяСтрока.ПросроченнаяЗадолженностьНачальныйОстаток = НоваяСтрока.ПросроченнаяЗадолженность;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ВнешниеНаборыДанных = Новый Структура("ПросроченнаяЗадолженность", ПросроченнаяЗадолженность);
	
	Возврат ВнешниеНаборыДанных;
		                                
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	ИсключенныеСчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(2);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИсключенныеСчета", ИсключенныеСчета);
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		НачалоПериода = БухгалтерскиеОтчетыКлиентСервер.НачалоПериода(ПараметрыОтчета.НачалоПериода, Периодичность);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
		ПараметрыОтчета.НачалоПериода = НачалоПериода;
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		КонецПериода = БухгалтерскиеОтчетыКлиентСервер.КонецПериода(ПараметрыОтчета.КонецПериода, Периодичность);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецПериода);
		ПараметрыОтчета.КонецПериода = КонецПериода;
	КонецЕсли;
	
	Период   = Неопределено;
	Диаграмма = Неопределено;
	
	ВыводитьДиаграмму = Неопределено;
	
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл		
		Если ЭлементСтруктуры.Имя = "Период" Тогда
			Период = ЭлементСтруктуры;
		ИначеЕсли ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			Диаграмма = ЭлементСтруктуры;
		КонецЕсли;		
	КонецЦикла;
	
	Если Диаграмма <> Неопределено Тогда
		
		Если ВыводитьДиаграмму Тогда
			
			Диаграмма.Точки.Очистить();
			ГруппировкаПериод = Диаграмма.Точки.Добавить();
			ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
			ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
			ПолеГруппировки.НачалоПериода =	НачалоДня(ПараметрыОтчета.НачалоПериода);
			ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
			
			ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
		Иначе
			
			Диаграмма.Использование = ВыводитьДиаграмму;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Период <> Неопределено Тогда
		Период.ПоляГруппировки.Элементы.Очистить();
		ПолеГруппировки = Период.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
		ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
		ПолеГруппировки.НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
		ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
		
		Период.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Период.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	Если ПараметрыОтчета.ПоказательЗадолженность Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "Задолженность");
	КонецЕсли;
	Если ПараметрыОтчета.ПоказательПросроченнаяЗадолженность Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "ПросроченнаяЗадолженность");
	КонецЕсли;
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ДинамикаЗадолженностиПокупателей").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПокупателями, "");
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;

КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
		
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
   	
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("Организация", ОтчетОбъект.Организация);
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
		
	Раздел        = Неопределено;
	Период        = Неопределено;
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ОтчетОбъект.Периодичность, ОтчетОбъект.НачалоПериода, ОтчетОбъект.КонецПериода);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);

 	Для Каждого Отбор Из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") тогда
			Если Отбор.Значение = NULL тогда
				Продолжить;
			КонецЕсли;
			
			Если Отбор.Поле = "Организация" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.Значение);
			ИначеЕсли Отбор.Поле = "Период" Тогда
				Период = Отбор.Значение;
			ИначеЕсли  Отбор.Поле = "Раздел" Тогда
				Раздел = Отбор.Значение;
			Иначе
				Если Отбор.Иерархия Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			КонецЕсли;	
		ИначеЕсли ТипЗнч(Отбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизацииСОП###" Тогда
				Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
					Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
						ДополнительныеСвойства.Вставить("Организация"                      , ЭлементОтбора.ПравоеЗначение);
						ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Истина);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
				ДополнительныеСвойства.Вставить("Организация"                      , Отбор.ПравоеЗначение);
				ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Ложь);
 			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.ЛевоеЗначение, Отбор.ПравоеЗначение, Отбор.ВидСравнения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
 	Если Период <> Неопределено Тогда
		ДополнительныеСвойства.Вставить("Период", БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, Периодичность));
	Иначе
		ДополнительныеСвойства.Вставить("Период", ОтчетОбъект.КонецПериода);
	КонецЕсли;
	ДополнительныеСвойства.Вставить("КлючВарианта", "ЗадолженностьПокупателейПоСрокамДолга");
	
	СписокПунктовМеню = Новый СписокЗначений;
	СписокПунктовМеню.Добавить("ЗадолженностьПокупателейПоСрокамДолга", "Задолженность покупателей по срокам долга");
	
	НастройкиРасшифровки = Новый Структура("ЗадолженностьПокупателейПоСрокамДолга", ПользовательскиеНастройки);
	
	ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	Адрес = ПоместитьВоВременноеХранилище(ДанныеОбъекта, Адрес);
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Задолженность");
	НаборПоказателей.Добавить("ПросроченнаяЗадолженность");

	Возврат НаборПоказателей;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	Для Каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Вставить("Показатель" + Показатель, Ложь);
	КонецЦикла;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("Периодичность"                    , 0);
	КоллекцияНастроек.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	КоллекцияНастроек.Вставить("ВыводитьДиаграмму"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПримечания"               , Ложь);
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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьПросроченнуюЗадолженность(ПараметрыОтчета, КонДата)
		
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидыСубконтоКД", ВидыСубконтоКД);
	Запрос.УстановитьПараметр("ГраницаОстатков", Новый Граница(КонецДня(КонДата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("СтандартныйСрокОплатыПокупателей", Константы.СрокОплатыПокупателей.Получить());
	Запрос.УстановитьПараметр("КонецИнтервала", КонецДня(КонДата));
	Запрос.УстановитьПараметр("ИсключенныеСчета", БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(1));
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТекстЗапросаПоОстаткам = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СчетаКонтрагентов.Ссылка КАК Счет
	|ПОМЕСТИТЬ СчетаКД
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК СчетаКонтрагентов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			ХозрасчетныйВидыСубконто.Ссылка КАК Ссылка
	|		ИЗ
	|			ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|		ГДЕ
	|			ХозрасчетныйВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры)) КАК СчетаДоговоров
	|		ПО СчетаКонтрагентов.Ссылка = СчетаДоговоров.Ссылка
	|ГДЕ
	|	СчетаКонтрагентов.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты)
	|	И НЕ СчетаКонтрагентов.Ссылка.Забалансовый
	|	И НЕ СчетаКонтрагентов.Ссылка В ИЕРАРХИИ (&ИсключенныеСчета)
    |   И НЕ СчетаКонтрагентов.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНалогамИПлатежам))
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.Контрагент КАК Контрагент,
	|	ВложенныйЗапрос.Договор КАК Договор,
 	|	ВложенныйЗапрос.СрокОплаты КАК СрокОплаты,
	|	ВложенныйЗапрос.СуммаОстаток КАК ОстатокДолга
	|ПОМЕСТИТЬ ОстаткиДолга
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВзаиморасчетыОстатки.Организация КАК Организация,
	|		ВзаиморасчетыОстатки.Субконто1 КАК Контрагент,
	|		ВзаиморасчетыОстатки.Субконто2 КАК Договор,
	|		ВЫБОР
	|			КОГДА ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
	|				ТОГДА ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
	|			ИНАЧЕ &СтандартныйСрокОплатыПокупателей
	|		КОНЕЦ КАК СрокОплаты,
	|		ВзаиморасчетыОстатки.Счет КАК Счет,
	|		ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокДт КАК СуммаОстаток
	|	ИЗ
	|		РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&ГраницаОстатков,
	|				Счет В
	|					(ВЫБРАТЬ
	|						СчетаКД.Счет
	|					ИЗ
	|						СчетаКД КАК СчетаКД),
	|				&ВидыСубконтоКД,
	|				ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))
	|					И Организация = &Организация) КАК ВзаиморасчетыОстатки) КАК ВложенныйЗапрос
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Контрагент,
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ОстаткиДолга.СрокОплаты КАК СрокОплаты
	|ИЗ
	|	ОстаткиДолга КАК ОстаткиДолга
	|
	|УПОРЯДОЧИТЬ ПО
	|	СрокОплаты";
	
	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ТекстЗапросаПоОстаткам = СтрЗаменить(ТекстЗапросаПоОстаткам, "И Организация = &Организация", "");
	КонецЕсли;
	Запрос.Текст = ТекстЗапросаПоОстаткам;
	
	МассивСроковОплаты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СрокОплаты");
	
	Если МассивСроковОплаты.Количество() = 0 Тогда
		МассивСроковОплаты.Добавить(0);
	КонецЕсли;
	
	ТекстОстатки = 
	"ВЫБРАТЬ
	|	ОстаткиДолга.Организация,
	|	ОстаткиДолга.Контрагент,
	|	ОстаткиДолга.Договор,
	|	ОстаткиДолга.СрокОплаты,
	|	ОстаткиДолга.ОстатокДолга,
	|	СУММА(ЕСТЬNULL(Обороты.УвеличениеДолга, 0)) КАК УвеличениеДолга
	|ИЗ
	|	ОстаткиДолга КАК ОстаткиДолга";
	
	ТекстОборотыПоСроку = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыОбороты.Организация КАК Организация,
	|	ВзаиморасчетыОбороты.Субконто1 КАК Контрагент,
	|	ВзаиморасчетыОбороты.Субконто2 КАК Договор,
	|	ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотДт > 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
	|		ИНАЧЕ 0
	|	КОНЕЦ - ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт < 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК УвеличениеДолга
	|ПОМЕСТИТЬ Обороты1
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоИнтервала1,
	|			&КонецИнтервала,
	|			,
	|				Счет В
	|					(ВЫБРАТЬ
	|						СчетаКД.Счет
	|					ИЗ
	|						СчетаКД КАК СчетаКД),
	|			&ВидыСубконтоКД,
	|			(Субконто1, Субконто2) В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ОстаткиДолга.Контрагент,
	|						ОстаткиДолга.Договор
	|					ИЗ
	|						ОстаткиДолга КАК ОстаткиДолга
	|					ГДЕ
	|						ОстаткиДолга.СрокОплаты = &СрокОплаты1)
	|				И Организация = &Организация,
	|			,
	|			) КАК ВзаиморасчетыОбороты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВзаиморасчетыОбороты.Организация,
	|	ВзаиморасчетыОбороты.Субконто1,
	|	ВзаиморасчетыОбороты.Субконто2,
	|	-(ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотДт > 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
	|		ИНАЧЕ 0
	|	КОНЕЦ - ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт < 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
	|		ИНАЧЕ 0
	|	КОНЕЦ)
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоИнтервала1,
	|			&КонецИнтервала,
	|			,
	|				Счет В
	|					(ВЫБРАТЬ
	|						СчетаКД.Счет
	|					ИЗ
	|						СчетаКД КАК СчетаКД),
	|			&ВидыСубконтоКД,
	|			(Субконто1, Субконто2) В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ОстаткиДолга.Контрагент,
	|						ОстаткиДолга.Договор
	|					ИЗ
	|						ОстаткиДолга КАК ОстаткиДолга
	|					ГДЕ
	|						ОстаткиДолга.СрокОплаты = &СрокОплаты1)
	|				И Организация = &Организация,
	|			,
	|			&ВидыСубконтоКД) КАК ВзаиморасчетыОбороты
	|ГДЕ
	|	ВзаиморасчетыОбороты.Субконто1 = ВзаиморасчетыОбороты.КорСубконто1
	|	И ВзаиморасчетыОбороты.Субконто2 = ВзаиморасчетыОбороты.КорСубконто2";
	
	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ТекстОборотыПоСроку = СтрЗаменить(ТекстОборотыПоСроку, "И Организация = &Организация", "");
	КонецЕсли;
	
	МаксКоличествоЧастей = 10;
	КоличествоСроковОплаты = МассивСроковОплаты.Количество();
	ОстатокОтДеления = КоличествоСроковОплаты % МаксКоличествоЧастей;
	
	КоличествоЧастей = (КоличествоСроковОплаты - ОстатокОтДеления) / МаксКоличествоЧастей + ?(ОстатокОтДеления > 0, 1, 0);
	ТекстОборотыПоВсемСрокам = "";
	ТекстВсеОбороты = "";
	Для ИндексЧасти = 1 По КоличествоЧастей Цикл
		НачальныйИндекс = МаксКоличествоЧастей * (ИндексЧасти - 1) + 1;
		КонечныйИндекс  = Мин(КоличествоСроковОплаты, МаксКоличествоЧастей * ИндексЧасти);
		ТекстОбороты = "";
		
		Для ИндексЗапроса = НачальныйИндекс По КонечныйИндекс Цикл
			СрокОплаты = МассивСроковОплаты[ИндексЗапроса - 1];
			Запрос.УстановитьПараметр("НачалоИнтервала" + ИндексЗапроса, НачалоДня(КонДата - (СрокОплаты - 1)* 60*60*24));
			Запрос.УстановитьПараметр("СрокОплаты" + ИндексЗапроса, СрокОплаты);
			
			ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСроку, "&НачалоИнтервала1", "&НачалоИнтервала" + ИндексЗапроса);
			ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСрокуНом, "&СрокОплаты1", "&СрокОплаты" + ИндексЗапроса);
			Если ИндексЗапроса = НачальныйИндекс Тогда
				ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСрокуНом, "ПОМЕСТИТЬ Обороты1", "ПОМЕСТИТЬ Обороты" + ИндексЧасти);
			Иначе
				ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСрокуНом, "ПОМЕСТИТЬ Обороты1", "");
			КонецЕсли;
			
			ТекстОбороты = ТекстОбороты
			+ ?(ПустаяСтрока(ТекстОбороты), "", "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|") 
			+ ТекстОборотыПоСрокуНом;
			
		КонецЦикла;
		
		ТекстВсеОбороты = ТекстВсеОбороты + ТекстОбороты + " 
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	Контрагент,
		|	Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		
		ТекстОборотыПоВсемСрокам = ТекстОборотыПоВсемСрокам
		+ ?(ПустаяСтрока(ТекстОборотыПоВсемСрокам), "", "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|") 
		+ "
		|ВЫБРАТЬ 
		|	Обороты" + ИндексЧасти + ".Организация,
		|	Обороты" + ИндексЧасти + ".Контрагент,
		|	Обороты" + ИндексЧасти + ".Договор,
		|	Обороты" + ИндексЧасти + ".УвеличениеДолга
		|ИЗ
		|	Обороты" + ИндексЧасти + " КАК Обороты" + ИндексЧасти;
	КонецЦикла;
	
	ТекстОстаткиИОбороты = ТекстОстатки + "
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(" + ТекстОборотыПоВсемСрокам + ") КАК Обороты
	|	ПО ОстаткиДолга.Организация = Обороты.Организация
	|		И ОстаткиДолга.Контрагент = Обороты.Контрагент
	|		И ОстаткиДолга.Договор = Обороты.Договор
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиДолга.Организация,
	|	ОстаткиДолга.Контрагент,
	|	ОстаткиДолга.Договор,
	|	ОстаткиДолга.ОстатокДолга,
	|	ОстаткиДолга.СрокОплаты";
	
	ТекстПросрочено =
	"ВЫБРАТЬ
	|	ОстаткиИОбороты.Организация,
	|	ОстаткиИОбороты.Контрагент,
	|	ОстаткиИОбороты.Договор,
	|	ОстаткиИОбороты.СрокОплаты,
	|	ОстаткиИОбороты.ОстатокДолга,
	|	ОстаткиИОбороты.ОстатокДолга - 
	|		ВЫБОР
	|			КОГДА ОстаткиИОбороты.ОстатокДолга < ОстаткиИОбороты.УвеличениеДолга
	|				ТОГДА ОстаткиИОбороты.ОстатокДолга
	|			ИНАЧЕ ОстаткиИОбороты.УвеличениеДолга
	|		КОНЕЦ КАК ПросроченнаяЗадолженность
	|ИЗ
	|	(" + ТекстОстаткиИОбороты + ") КАК ОстаткиИОбороты
	|ГДЕ
	|	ОстаткиИОбороты.ОстатокДолга - 
	|		ВЫБОР
	|			КОГДА ОстаткиИОбороты.ОстатокДолга < ОстаткиИОбороты.УвеличениеДолга
	|				ТОГДА ОстаткиИОбороты.ОстатокДолга
	|			ИНАЧЕ ОстаткиИОбороты.УвеличениеДолга
	|		КОНЕЦ > 0";
	
	Запрос.Текст = ТекстВсеОбороты + ТекстПросрочено;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
#КонецЕсли