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
	
	Возврат НСтр("ru='Доходы и расходы';uk='Доходи та витрати'") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ИсключенныеСчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(3);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИсключенныеСчета", ИсключенныеСчета);

	СчетаРасходов = ПолучитьСписокСчетовРасходов(ПараметрыОтчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаРасходов", СчетаРасходов);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	ВыводитьДиаграмму = Неопределено;
	
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Таблица   = Неопределено;
	Диаграмма = Неопределено;
	
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл		
		Если ЭлементСтруктуры.Имя = "Таблица" Тогда
			Таблица = ЭлементСтруктуры;
		ИначеЕсли ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			Диаграмма = ЭлементСтруктуры;
		КонецЕсли;		
	КонецЦикла;
	
	Если Диаграмма <> Неопределено Тогда
		Диаграмма.Использование = ВыводитьДиаграмму;
	КонецЕсли;
	
	Если Таблица <> Неопределено Тогда
		Таблица.Колонки.Очистить();
		ГруппировкаПериод = Таблица.Колонки.Добавить();
		ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
		ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
		ПолеГруппировки.НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
		ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
		
		ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
		// Группировка
		Таблица.Строки.Очистить();
		Группировка = Таблица.Строки;
		Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
			Если ПолеВыбраннойГруппировки.Использование Тогда
				Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
					Группировка = Группировка.Добавить();
				Иначе
					Группировка = Группировка.Структура.Добавить();
				КонецЕсли;
				БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);				
			КонецЕсли;
		КонецЦикла;
		
		// В конце всегда добавляем группировку по Виду
		Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
			Группировка = Группировка.Добавить();
		Иначе
			Группировка = Группировка.Структура.Добавить();
		КонецЕсли;
		БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(Новый Структура("Поле, ТипГруппировки", "Вид", 3), Группировка);				
		
	КонецЕсли;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Для Каждого Рисунок Из Результат.Рисунки Цикл
		Попытка
			Если ТипЗнч(Рисунок.Объект) = Тип("Диаграмма") Тогда
				
				// немного расширим легенду влево
				Рисунок.Объект.ОбластьЛегенды.Лево = Рисунок.Объект.ОбластьЛегенды.Лево - 0.01;
				Рисунок.Объект.ОбластьПостроения.Право = Рисунок.Объект.ОбластьПостроения.Право - 0.01;
				
				Для Каждого Серия Из Рисунок.Объект.Серии Цикл
					Если Серия.Текст = "Доходы без НДС"
						ИЛИ Серия.Текст = "Расходы" Тогда
							Серия.Индикатор = Истина;
					КонецЕсли;
				КонецЦикла;
				
				
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ДоходыРасходы").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.ОбщиеПоказатели, "");
	
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
	
	Массив.Добавить(Новый Структура("Имя, Представление","ДоходыРасходы", "Доходы и расходы"));
	
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
	КоллекцияНастроек.Вставить("Периодичность"                    , 0);
	КоллекцияНастроек.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьДиаграмму"                , Ложь);
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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьСписокСчетовРасходов(ПараметрыОтчета)

	СчетаРасходов = Новый СписокЗначений;
	ИспользуемыеКлассыСчетовРасходов = Новый СписокЗначений;
	Если ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ИспользуемыеКлассыСчетовРасходов.Добавить(УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода)));
	Иначе
		// Берем по всем организациям
		ЗапросОрганизации = Новый Запрос;
		ЗапросОрганизации.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                          |	Организации.Ссылка,
		                          |	Организации.ЮридическоеФизическоеЛицо
		                          |ИЗ
		                          |	Справочник.Организации КАК Организации";
		Выборка = ЗапросОрганизации.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ИспользуемыеКлассыСчетовРасходов.Добавить(УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(Выборка.Ссылка, КонецДня(ПараметрыОтчета.КонецПериода)));
		КонецЦикла;
	КонецЕсли;
	
	Если (НЕ ИспользуемыеКлассыСчетовРасходов.НайтиПоЗначению(Перечисления.КлассыСчетовРасходов.Класс8) = Неопределено) И 
		(ИспользуемыеКлассыСчетовРасходов.НайтиПоЗначению(Перечисления.КлассыСчетовРасходов.Класс9) = Неопределено) Тогда
		
		// Есть "только 8" , но нет "только 9" - используем 8 класс
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.МатериальныеЗатраты);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ЗатратыНаОплатуТруда);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОтчисленияНаСоциальныеМероприятия);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.Амортизация);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам);
		
	ИначеЕсли ((НЕ ИспользуемыеКлассыСчетовРасходов.НайтиПоЗначению(Перечисления.КлассыСчетовРасходов.Класс8и9) = Неопределено) ИЛИ
		(НЕ ИспользуемыеКлассыСчетовРасходов.НайтиПоЗначению(Перечисления.КлассыСчетовРасходов.Класс9) = Неопределено)) И
		(НЕ ИспользуемыеКлассыСчетовРасходов.НайтиПоЗначению(Перечисления.КлассыСчетовРасходов.Класс8) = Неопределено) Тогда
		
		// Есть "8 и 9" или "только 9", но нет "только 8" - используем 9 класс
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.СебестоимостьРеализации);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеЗатраты);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ПотериОтУчастияВКапитале);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыДеятельности);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.НалогНаПрибыль);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ЧрезвычайныеЗатраты);
		
	Иначе
		
		// Есть "только 9" и "только 8" одновременно!
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.СебестоимостьРеализации);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеЗатраты);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ПотериОтУчастияВКапитале);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыДеятельности);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.НалогНаПрибыль);
		СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ЧрезвычайныеЗатраты);
		
	КонецЕсли;

	Возврат СчетаРасходов;
	
КонецФункции // ПолучитьСписокСчетовРасходов()

#КонецЕсли