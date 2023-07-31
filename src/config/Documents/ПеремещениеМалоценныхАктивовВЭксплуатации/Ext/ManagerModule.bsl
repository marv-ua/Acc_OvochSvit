﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	
	// Ведомость МШ-7 (сдача)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "МШ7с";
	КомандаПечати.Представление = НСтр("ru='Ведомость МШ-7 (сдача)';uk='Відомість МШ-7 (здача)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Ведомость МШ-7 (выдача)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "МШ7в";
	КомандаПечати.Представление = НСтр("ru='Ведомость МШ-7 (выдача)';uk='Відомість МШ-7 (видача)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Накладная M-11
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "М11";
	КомандаПечати.Представление = НСтр("ru='Накладная M-11';uk='Накладна M-11'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Форма ОЗ-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОЗ1";
	КомандаПечати.Представление = НСтр("ru='Форма ОЗ-1';uk='Форма ОЗ-1'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Перемещение малоценных активов в эксплуатации""';uk='Реєстр документів ""Переміщення малоцінних активів в експлуатації""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Функция формирует табличный документ с типовой печатной формой ОЗ-1
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьОЗ1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент   = Новый ТабличныйДокумент();
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВводВЭксплуатациюОС_ОЗ1";
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_ОЗ1");
	
    ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка"           , Ссылка);
		Запрос.УстановитьПараметр("НаДату"           , Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("Организация"      , Ссылка.Организация);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Док.Дата                           КАК ДатаАкта,
		|	Док.Номер                          КАК НомерАкта,
		|	Док.Организация.НаименованиеПолное КАК Организация,
		|	Док.ПодразделениеОрганизации       КАК ПринялоПодразделение,
		|	Док.ПодразделениеОрганизации       КАК СдалоПодразделение,
		|	Док.Организация.КодПоЕДРПОУ        КАК ЕДРПОУ
		|ИЗ
		|	Документ.ПеремещениеМалоценныхАктивовВЭксплуатации КАК Док
		|ГДЕ 
		|	Док.Ссылка = &Ссылка
		|	";
		ВыборкаПоШапке = Запрос.Выполнить().Выбрать();
		ВыборкаПоШапке.Следующий();

														
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка"         , Ссылка);
		Запрос.УстановитьПараметр("НаДату"         , Ссылка.Дата);
		Запрос.УстановитьПараметр("МоментДокумента", Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("Организация"    , Ссылка.Организация);
		Запрос.УстановитьПараметр("Подразделение"  , Ссылка.ПодразделениеОрганизации);
		Запрос.УстановитьПараметр("СчетМЦ"         , ПланыСчетов.Хозрасчетный.МалоценныеАктивыВЭксплуатации);
		
		МассивСубконто = Новый Массив;
		МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций);
		МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НазначенияИспользования);
		МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПартииМалоценныхАктивовВЭксплуатации);
		Запрос.УстановитьПараметр("Субконто", МассивСубконто);
		
		ВидМалоценногоАктива = Новый Массив;
		ВидМалоценногоАктива.Добавить(Перечисления.ВидыМалоценныхАктивов.МалоценныйНеоборотныйАктив);
		ВидМалоценногоАктива.Добавить(Перечисления.ВидыМалоценныхАктивов.БиблиотечныеФонды);
		Запрос.УстановитьПараметр("ВидМалоценногоАктива", ВидМалоценногоАктива);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Док.ФизЛицо.Код                                     КАК КодМОЛа,
		|	Док.ФизЛицо 									    КАК Сдал, 
		|	Док.НазначениеИспользования.СчетБУДляПечати         КАК СчетДт,
		|	Док.НазначениеИспользования.СчетБУДляПечати         КАК СчетКт,
		|	Док.Номенклатура.НаименованиеПолное                 КАК НаименованиеОС" + ?(Ссылка.Проведен, ",
		|	Хозрасчетный.СубконтоКт3.Дата                       КАК ДатаВвода,
		|	ВЫБОР
		|		КОГДА Хозрасчетный.КоличествоОборотКт = 0
		|			ТОГДА Хозрасчетный.СуммаОборот
		|		ИНАЧЕ Хозрасчетный.СуммаОборот / Хозрасчетный.КоличествоОборотКт
		|	КОНЕЦ                                              КАК ПервоначальнаяСтоимость", "") + "
		|ИЗ
		|	Документ.ПеремещениеМалоценныхАктивовВЭксплуатации.МалоценныеАктивы КАК Док
		|		" + ?(Ссылка.Проведен, "
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
		|			                   &МоментДокумента,
		|			                   &МоментДокумента, , , ,
		|			                   СчетКт = &СчетМЦ,
		|			                   &Субконто, ) КАК Хозрасчетный
		|		ПО Док.ФизЛицо = Хозрасчетный.СубконтоКт1
		|			И Док.НазначениеИспользования = Хозрасчетный.СубконтоКт2", "") + "
		|ГДЕ
		|	Док.Ссылка = &Ссылка
		|	И Док.НазначениеИспользования.ВидМалоценногоАктива В(&ВидМалоценногоАктива)";
			
		
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			
			ОбластьМакета = Макет.ПолучитьОбласть("НетДанных");
			ТабДокумент.Вывести(ОбластьМакета);
			
			Возврат ТабДокумент;
			
		КонецЕсли;
		
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);
		ВыборкаПоОС = Результат.Выбрать();
		
		ДанныеФизЛицаПолучил = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Ссылка.Организация, Ссылка.ФизЛицоКуда, Ссылка.Дата);
		ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Ссылка.Организация, Ссылка.Дата);
		
		Пока ВыборкаПоОС.Следующий() Цикл

			ОбластьМакета = Макет.ПолучитьОбласть("ОЗ1");
			Параметры     = ОбластьМакета.Параметры;
			Параметры.Заполнить(ВыборкаПоШапке);
			Параметры.Заполнить(ВыборкаПоКомиссии);
			Параметры.Заполнить(ВыборкаПоОС);
			Параметры.ВидОперации = "Переміщення";
			Параметры.Валюта      = ВалютаРегламентированногоУчета;
			
			ДанныеФизЛицаСдал = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Ссылка.Организация, ВыборкаПоОС.Сдал, Ссылка.Дата);
			ОбластьМакета.Параметры.СдалДолжность 	= ДанныеФизЛицаСдал.Должность;
			ОбластьМакета.Параметры.СдалФИО 		= ДанныеФизЛицаСдал.Представление;
			
			ОбластьМакета.Параметры.ПолучилДолжность 	= ДанныеФизЛицаПолучил.Должность;
			ОбластьМакета.Параметры.ПолучилФИО 			= ДанныеФизЛицаПолучил.Представление;
			
			ОбластьМакета.Параметры.ГлавныйБухгалтер 	= ОтветственныеЛица.ГлавныйБухгалтерПредставление;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции // ПечатьОЗ1()

// Функция формирует печатную форму М-11
//
Функция ПечатьМ11(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПеремещениеМалоценныхАктивовВЭксплуатации_М11";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_М11");
	
    ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент"  , Ссылка);
		Запрос.УстановитьПараметр("НаДату"           , Ссылка.Дата);
		Запрос.УстановитьПараметр("Организация"      , Ссылка.Организация);
		Запрос.УстановитьПараметр("ЧерезКого"        , Ссылка.ЧерезКого);
		Запрос.УстановитьПараметр("ОтпускРазрешил"   , Ссылка.ОтпускРазрешил);
		Запрос.УстановитьПараметр("Получил"          , Ссылка.ФизЛицоКуда);
		Запрос.УстановитьПараметр("ГлавныйБухгалтер" , Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Док.Номер                                                   КАК НомерДокумента,
		|	Док.Дата                                                    КАК ДатаДокумента,
		|	Док.Организация                                             КАК Организация,
		|	Док.Организация.НаименованиеПолное                          КАК ПредставлениеОрганизации,
		|	ПРЕДСТАВЛЕНИЕ(Док.ПодразделениеОрганизации)                 КАК Подразделение,
		|	Док.Основание                                               КАК Основание,
		|	Док.Организация.КодПоЕДРПОУ                                 КАК КодПоЕДРПОУ,
		|	ФИОЧерезКого.Фамилия + "" ""
		|		+ ФИОЧерезКого.Имя + "" ""
		|		+ ФИОЧерезКого.Отчество                                 КАК ЧерезКого,
		|	ФИОЧерезКого.Фамилия + "" ""
		|		+ ПОДСТРОКА(ФИОЧерезКого.Имя, 1, 1) + "". ""
		|		+ ПОДСТРОКА(ФИОЧерезКого.Отчество, 1, 1) + "".""        КАК ЧерезКогоФИО,
		|	ФИООтпускРазрешил.Фамилия + "" ""
		|		+ ПОДСТРОКА(ФИООтпускРазрешил.Имя, 1, 1) + "". ""
		|		+ ПОДСТРОКА(ФИООтпускРазрешил.Отчество, 1, 1) + "".""   КАК ОтпускРазрешил,
		|	ФИОКому.Фамилия + "" ""
		|		+ ФИОКому.Имя + "" ""
		|		+ ФИОКому.Отчество                                              КАК Кому,
		|	ФИОКому.Фамилия + "" ""
		|		+ ПОДСТРОКА(ФИОКому.Имя, 1, 1) + "". ""
		|		+ ПОДСТРОКА(ФИОКому.Отчество, 1, 1) + "".""                     КАК КомуФИО,
		|	ФИОГлавныйБухгалтер.Фамилия + "" ""
		|		+ ПОДСТРОКА(ФИОГлавныйБухгалтер.Имя, 1, 1) + "". ""
		|		+ ПОДСТРОКА(ФИОГлавныйБухгалтер.Отчество, 1, 1) + ""."" КАК ГлавныйБухгалтер
		|ИЗ
		|	Документ.ПеремещениеМалоценныхАктивовВЭксплуатации КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
		|			                &НаДату,
		|			                ФизическоеЛицо = &ЧерезКого) КАК ФИОЧерезКого
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ
		|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
		|			                &НаДату,
		|			                ФизическоеЛицо = &ОтпускРазрешил) КАК ФИООтпускРазрешил
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
		|			                &НаДату,
		|			                ФизическоеЛицо = &Получил) КАК ФИОКому
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
		|		                    &НаДату,
		|		                    ФизическоеЛицо В
		|		                        (ВЫБРАТЬ
		|		                            ОтветственныеЛица.ФизическоеЛицо
		|		                        ИЗ
		|		                            РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
		|		                                            &НаДату,
		|		                                            СтруктурнаяЕдиница = &Организация
		|		                                            И ОтветственноеЛицо = &ГлавныйБухгалтер) КАК ОтветственныеЛица)
		|		                    ) КАК ФИОГлавныйБухгалтер
		|		ПО (ИСТИНА)
		|ГДЕ
		|	Док.Ссылка = &ТекущийДокумент";

		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		                            
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("НаДату"         , Ссылка.Дата);
		Запрос.УстановитьПараметр("ВидМалоценногоАктива"   , Перечисления.ВидыМалоценныхАктивов.МалоценныйБыстроизнашивающийсяПредмет);
		
		СписокРаботников = Ссылка.МалоценныеАктивы.ВыгрузитьКолонку("ФизЛицо");
		ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(СписокРаботников);
		Запрос.УстановитьПараметр("СписокРаботников", СписокРаботников);
		
		Если Ссылка.Проведен Тогда
			
			Запрос.УстановитьПараметр("МоментДокумента", Ссылка.МоментВремени());
			Запрос.УстановитьПараметр("СчетМЦ"         , ПланыСчетов.Хозрасчетный.МалоценныеАктивыВЭксплуатации);
			
			МассивСубконто = Новый Массив;
			МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций);
			МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НазначенияИспользования);
			Запрос.УстановитьПараметр("Субконто", МассивСубконто);
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ФИООтпустил.Фамилия + "" ""
			|		+ ПОДСТРОКА(ФИООтпустил.Имя, 1, 1) + "". ""
			|		+ ПОДСТРОКА(ФИООтпустил.Отчество, 1, 1) + "".""                 КАК Отпустил,
			|	ВложенныйЗапрос.Номенклатура.НаименованиеПолное                     КАК МатериалНаименование,
			|	ВложенныйЗапрос.Номенклатура.Код                                    КАК НоменклатурныйНомер,
			|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Номенклатура.БазоваяЕдиницаИзмерения) КАК ЕдиницаИзмеренияНаименование,
			|	ВложенныйЗапрос.Номенклатура.БазоваяЕдиницаИзмерения.Код            КАК ЕдиницаИзмеренияКод,
			|	ВложенныйЗапрос.СчетПередачиБУ                                      КАК СчетПередачи,
			|	ЕСТЬNULL(ВложенныйЗапрос.Количество, 0)                             КАК Количество,
			|	ВложенныйЗапрос.Цена                                                КАК Цена,
			|	ЕСТЬNULL(ВложенныйЗапрос.Стоимость, 0)                              КАК Стоимость
			|ИЗ
			|	(ВЫБРАТЬ
			|		ВЫРАЗИТЬ(Хозрасчетный.СубконтоКт1 КАК Справочник.ФизическиеЛица)                          КАК Сдал,
			|		ВЫРАЗИТЬ(Хозрасчетный.СубконтоКт2 КАК Справочник.НазначенияИспользования).Владелец        КАК Номенклатура,
			|		ВЫРАЗИТЬ(Хозрасчетный.СубконтоКт2 КАК Справочник.НазначенияИспользования).СчетБУДляПечати КАК СчетПередачиБУ,
			|		СУММА(Хозрасчетный.КоличествоОборотКт)                                                    КАК Количество,
			|		ВЫБОР
			|			КОГДА Хозрасчетный.КоличествоОборотКт = 0
			|				ТОГДА Хозрасчетный.СуммаОборот
			|			ИНАЧЕ ВЫРАЗИТЬ(Хозрасчетный.СуммаОборот / Хозрасчетный.КоличествоОборотКт КАК ЧИСЛО(15, 2))
			|		КОНЕЦ КАК Цена,
			|		СУММА(Хозрасчетный.СуммаОборот) КАК Стоимость
			|	ИЗ
			|		РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
			|		                   &МоментДокумента,
			|		                   &МоментДокумента, , , ,
			|		                   СчетКт = &СчетМЦ,
			|		                   &Субконто, ) КАК Хозрасчетный
			|	ГДЕ
			|		ВЫРАЗИТЬ(Хозрасчетный.СубконтоКт2 КАК Справочник.НазначенияИспользования).ВидМалоценногоАктива = &ВидМалоценногоАктива
			|	
			|	СГРУППИРОВАТЬ ПО
			|		ВЫРАЗИТЬ(Хозрасчетный.СубконтоКт1 КАК Справочник.ФизическиеЛица),
			|		ВЫРАЗИТЬ(Хозрасчетный.СубконтоКт2 КАК Справочник.НазначенияИспользования).Владелец,
			|		ВЫРАЗИТЬ(Хозрасчетный.СубконтоКт2 КАК Справочник.НазначенияИспользования).СчетБУДляПечати,
			|		ВЫБОР
			|			КОГДА Хозрасчетный.КоличествоОборотКт = 0
			|				ТОГДА Хозрасчетный.СуммаОборот
			|			ИНАЧЕ ВЫРАЗИТЬ(Хозрасчетный.СуммаОборот / Хозрасчетный.КоличествоОборотКт КАК ЧИСЛО(15, 2))
			|		КОНЕЦ) КАК ВложенныйЗапрос
			|		ЛЕВОЕ СОЕДИНЕНИЕ 
			|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
			|			                &НаДату,
			|			                ФизическоеЛицо В (&СписокРаботников)) КАК ФИООтпустил
			|		ПО ВложенныйЗапрос.Сдал = ФИООтпустил.ФизическоеЛицо
			|ИТОГИ
			|	СУММА(Количество),
			|	СУММА(Стоимость)
			|ПО
			|	Сдал";
			
		Иначе
			
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ФИООтпустил.Фамилия + "" ""
			|		+ ПОДСТРОКА(ФИООтпустил.Имя, 1, 1) + "". ""
			|		+ ПОДСТРОКА(ФИООтпустил.Отчество, 1, 1) + "".""                 КАК Отпустил,
			|	ВложенныйЗапрос.Номенклатура.НаименованиеПолное                     КАК МатериалНаименование,
			|	ВложенныйЗапрос.Номенклатура.Код                                    КАК НоменклатурныйНомер,
			|	ПРЕДСТАВЛЕНИЕ(ЕдиницаИзмерения) КАК ЕдиницаИзмеренияНаименование,
			|	ЕдиницаИзмерения.Код            КАК ЕдиницаИзмеренияКод,
			|	ВложенныйЗапрос.СчетПередачиБУ                                      КАК СчетПередачи,
			|	ЕСТЬNULL(ВложенныйЗапрос.Количество, 0)                             КАК Количество
			|ИЗ
			|	(ВЫБРАТЬ
			|		Док.ФизЛицо                                 КАК Сдал,
			|		Док.Номенклатура                            КАК Номенклатура,
			|		Док.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
			|		Док.НазначениеИспользования.СчетБУДляПечати КАК СчетПередачиБУ,
			|		СУММА(Док.Количество)                       КАК Количество
			|	ИЗ
			|		Документ.ПеремещениеМалоценныхАктивовВЭксплуатации.МалоценныеАктивы КАК Док
			|	ГДЕ
			|		Док.Ссылка = &ТекущийДокумент
			|		И Док.НазначениеИспользования.ВидМалоценногоАктива = &ВидМалоценногоАктива
			|	
			|	СГРУППИРОВАТЬ ПО
			|		Док.ФизЛицо,
			|		Док.Номенклатура,
			|		Док.ЕдиницаИзмерения,
			|		Док.НазначениеИспользования.СчетБУДляПечати) КАК ВложенныйЗапрос
			|		ЛЕВОЕ СОЕДИНЕНИЕ 
			|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
			|			                &НаДату,
			|			                ФизическоеЛицо В (&СписокРаботников)) КАК ФИООтпустил
			|		ПО ВложенныйЗапрос.Сдал = ФИООтпустил.ФизическоеЛицо
			|ИТОГИ
			|	СУММА(Количество)
			|ПО
			|	Сдал";
			
		КонецЕсли;

		ЗапросПоНоменклатуре = Запрос.Выполнить();
		
		Если ЗапросПоНоменклатуре.Пустой() Тогда
			
			ОбластьМакета = Макет.ПолучитьОбласть("НетДанных");
			ТабДокумент.Вывести(ОбластьМакета);
			
			Возврат ТабДокумент;
			
		КонецЕсли;
		
		ВыборкаКому   = ЗапросПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		НеПервый      = Ложь;
		ЕстьЧерезКого = ЗначениеЗаполнено(Ссылка.ЧерезКого);
		ОбластьНомера = Макет.ПолучитьОбласть("Номера");
		
		Пока ВыборкаКому.Следующий()Цикл
			
			Если НеПервый Тогда
				
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
			КонецЕсли;
			
			НеПервый = Истина;
			
			Область = Макет.ПолучитьОбласть("Шапка");
			Область.Параметры.Заполнить(Шапка);
			Область.Параметры.КодОперации    = "Переміщення";	
			Область.Параметры.Валюта         = ВалютаРегламентированногоУчета;
			
			ТабДокумент.Вывести(Область);
			ТабДокумент.Вывести(ОбластьНомера);
			
			ОбластьПодвал   = Макет.ПолучитьОбласть("Подвал");
			ПараметрыПодвал = ОбластьПодвал.Параметры;
			ПараметрыПодвал.Заполнить(Шапка);
			
			Если Ссылка.Проведен Тогда
				
				ПрописьВалюты = ВалютаРегламентированногоУчета.ПараметрыПрописиНаУкраинском;
				ПараметрыПодвал.ИтогоСуммаПрописью = ЧислоПрописью(ВыборкаКому.Стоимость,
				"Л=uk_UA;ДП=Истина;", ПрописьВалюты);
				
			КонецЕсли;
			
			ВыборкаПоСтрокам = ВыборкаКому.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			КоличествоВВыборке     = ВыборкаПоСтрокам.Количество();
			КоличествоОбработанных = 1;
			// В форме сказано "Кількість найменувань". Будет выводится количество позиций.
			ПараметрыПодвал.ИтогоКоличествоПрописью = ЧислоПрописью(КоличествоВВыборке, 
			"Л=uk_UA;НП=Ложь;НД=Ложь;", ",,,,,,,,0");
			
			Пока ВыборкаПоСтрокам.Следующий() Цикл
				
				Область = Макет.ПолучитьОбласть("Строка");
				Область.Параметры.Заполнить(ВыборкаПоСтрокам);
				
				Если КоличествоОбработанных = КоличествоВВыборке Тогда
					// Последняя запись. Ее не следует отрывать от подписей.
					
					МассивТаблиц = Новый Массив(2);
					МассивТаблиц[0] = Область;
					МассивТаблиц[1] = ОбластьПодвал;
					
					Если НЕ ТабДокумент.ПроверитьВывод(МассивТаблиц) Тогда
						
						ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						ТабДокумент.Вывести(ОбластьНомера);
						
					КонецЕсли;
					
				КонецЕсли;
				
				ТабДокумент.Вывести(Область);
				КоличествоОбработанных = КоличествоОбработанных + 1;
				Отпустил               = ВыборкаПоСтрокам.Отпустил;
				
			КонецЦикла;
			
			ПараметрыПодвал.Получил  = ?(ЕстьЧерезКого, Шапка.ЧерезКогоФИО, Шапка.КомуФИО);
			ПараметрыПодвал.Отпустил = Отпустил;
			
			ТабДокумент.Вывести(ОбластьПодвал);
		
		КонецЦикла;
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
		
	Возврат ТабДокумент;
	
КонецФункции // ПечатьМ11()

// Функция формирует печатную форму документа
//
Функция ПечатьМШ7(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета, Сдача)
	УстановитьПривилегированныйРежим(Истина);

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПеремещениеМалоценныхАктивовВЭксплуатации_МШ7";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_МШ7");
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент"  , Ссылка);
		Запрос.УстановитьПараметр("НаДату"           , Ссылка.Дата);
		Запрос.УстановитьПараметр("Организация"      , Ссылка.Организация);
		Запрос.УстановитьПараметр("МОЛ"              , Ссылка.ЧерезКого);
		Запрос.УстановитьПараметр("ГлавныйБухгалтер" , Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Док.Номер                                                   КАК НомерДокумента,
		|	Док.Дата                                                    КАК ДатаДокумента,
		|	Док.Организация                                             КАК Организация,
		|	Док.Организация.НаименованиеПолное                          КАК ПредставлениеОрганизации,
		|	ПРЕДСТАВЛЕНИЕ(Док.ПодразделениеОрганизации)                 КАК Подразделение,
		|	Док.Организация.КодПоЕДРПОУ                                 КАК КодПоЕДРПОУ,
		|	ФИОМОЛ.Фамилия + "" ""
		|		+ ПОДСТРОКА(ФИОМОЛ.Имя, 1, 1) + "". ""
		|		+ ПОДСТРОКА(ФИОМОЛ.Отчество, 1, 1) + "".""              КАК МОЛ,
		|	ФИОГлавныйБухгалтер.Фамилия + "" ""
		|		+ ПОДСТРОКА(ФИОГлавныйБухгалтер.Имя, 1, 1) + "". ""
		|		+ ПОДСТРОКА(ФИОГлавныйБухгалтер.Отчество, 1, 1) + ""."" КАК ГлавныйБухгалтер
		|ИЗ
		|	Документ.ПеремещениеМалоценныхАктивовВЭксплуатации КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
		|			                &НаДату,
		|			                ФизическоеЛицо = &МОЛ) КАК ФИОМОЛ
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
		|		                    &НаДату,
		|		                    ФизическоеЛицо В
		|		                        (ВЫБРАТЬ
		|		                            ОтветственныеЛица.ФизическоеЛицо
		|		                        ИЗ
		|		                            РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
		|		                                            &НаДату,
		|		                                            СтруктурнаяЕдиница = &Организация
		|		                                И ОтветственноеЛицо = &ГлавныйБухгалтер) КАК ОтветственныеЛица)
		|		                    ) КАК ФИОГлавныйБухгалтер
		|		ПО (ИСТИНА)
		|ГДЕ
		|	Док.Ссылка = &ТекущийДокумент";

		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	  	Запрос.УстановитьПараметр("ВидМалоценногоАктива"   , Перечисления.ВидыМалоценныхАктивов.МалоценныйБыстроизнашивающийсяПредмет);

		Запрос.Текст =
		"ВЫБРАТЬ
		|	Док.Номенклатура.Код                                    КАК НоменклатурныйНомер,
		|	Док.Номенклатура.НаименованиеПолное                     КАК МатериалНаименование,
		|	ПРЕДСТАВЛЕНИЕ(Док.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияНаименование,
		|	Док.ЕдиницаИзмерения.Код            КАК ЕдиницаИзмеренияКод,
		|	Док.Количество                                          КАК Количество,
		|	Док.ФизЛицо                                             КАК Сотрудник,
		|	Док.ДатаПоступления                                     КАК ДатаПоступления,
		|	Док.ДатаДокумента                                       КАК ДатаДокумента,
		|	Док.СрокСлужбы                                          КАК СрокСлужбы
		|ИЗ
		|	(ВЫБРАТЬ
		|		Док.Номенклатура                           КАК Номенклатура,
		|		Док.ЕдиницаИзмерения                       КАК ЕдиницаИзмерения,
		|		СУММА(Док.Количество)                      КАК Количество,
		|		МИНИМУМ(Док.НомерСтроки) 		           КАК НомерСтроки,
		|		Док.ПартияМалоценныхАктивовВЭксплуатации.Дата          КАК ДатаПоступления,
		|		Док.Ссылка.Дата                            КАК ДатаДокумента," + ?(Сдача, "
		|		Док.ФизЛицо                                КАК ФизЛицо,
		|		Док.НазначениеИспользования.СрокПолезногоИспользования КАК СрокСлужбы", "
		|		Док.Ссылка.ФизЛицоКуда                                 КАК ФизЛицо,
		|		Док.НазначениеИспользованияНовое.СрокПолезногоИспользования КАК СрокСлужбы") + "
		|	ИЗ
		|		Документ.ПеремещениеМалоценныхАктивовВЭксплуатации.МалоценныеАктивы КАК Док
		|	ГДЕ
		|		Док.Ссылка = &ТекущийДокумент
		|		И Док.НазначениеИспользования.ВидМалоценногоАктива = &ВидМалоценногоАктива
		|
		|	СГРУППИРОВАТЬ ПО
		|		Док.Номенклатура,
		|		Док.ЕдиницаИзмерения,
		|		Док.ПартияМалоценныхАктивовВЭксплуатации.Дата,
		|		Док.Ссылка.Дата," + ?(Сдача, "
		|		Док.ФизЛицо,
		|		Док.НазначениеИспользования.СрокПолезногоИспользования", "
		|		Док.Ссылка.ФизЛицоКуда,
		|		Док.НазначениеИспользованияНовое.СрокПолезногоИспользования") + "
		|	) КАК Док
		|
		|УПОРЯДОЧИТЬ ПО НомерСтроки ВОЗР";

		ЗапросПоНоменклатуре = Запрос.Выполнить();

		Если ЗапросПоНоменклатуре.Пустой() Тогда
			
			ОбластьМакета = Макет.ПолучитьОбласть("НетДанных");
			ТабДокумент.Вывести(ОбластьМакета);
			
			Возврат ТабДокумент;
			
		КонецЕсли;
		
		Область = Макет.ПолучитьОбласть("Шапка");
		Область.Параметры.Заполнить(Шапка);
		Область.Параметры.КодОперации    = ?(Сдача, "Переміщення (сдача)", "Переміщення (видача)");	
		
		ОбластьПодвал   = Макет.ПолучитьОбласть("Подвал");
		ОбластьПодвал.Параметры.Заполнить(Шапка);
		
		ТабДокумент.Вывести(Область);

		ВысотаШапки   = ТабДокумент.ВысотаТаблицы;
		ШиринаТаблицы = ТабДокумент.ШиринаТаблицы;
		ТабДокумент.ПовторятьПриПечатиСтроки = ТабДокумент.Область("R" + ВысотаШапки);
		ТабДокумент.ОбластьПечати            = ТабДокумент.Область("C2:C" + ШиринаТаблицы);
		
		ВыборкаПоСтрокам = ЗапросПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КоличествоВВыборке     = ВыборкаПоСтрокам.Количество();
		КоличествоОбработанных = 1;
		
		СписокФизическихЛиц = Новый Массив;
		Пока ВыборкаПоСтрокам.Следующий() Цикл
			СписокФизическихЛиц.Добавить(ВыборкаПоСтрокам.Сотрудник);
		КонецЦикла;	
		
		ОсновныеСотрудникиФизическихЛиц = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(СписокФизическихЛиц, Истина, Шапка.Организация, Шапка.ДатаДокумента);
		СписокСотрудников = ОсновныеСотрудникиФизическихЛиц.ВыгрузитьКолонку("Сотрудник");
		Если ЗначениеЗаполнено(СписокСотрудников) Тогда
			ДанныеФизЛица = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СписокСотрудников, "ФизическоеЛицо, ТабельныйНомер", Ссылка.Дата);
		КонецЕсли;
		
		ВыборкаПоСтрокам.Сбросить();
		
		Пока ВыборкаПоСтрокам.Следующий() Цикл

			Область = Макет.ПолучитьОбласть("Строка");
			Область.Параметры.Заполнить(ВыборкаПоСтрокам);
			Область.Параметры.НомерПП = КоличествоОбработанных;
			Область.Параметры.ТабельныйНомер	= "";
			Если ДанныеФизЛица <> Неопределено Тогда
				СтрокаТЗ = ДанныеФизЛица.Найти(ВыборкаПоСтрокам.Сотрудник, "ФизическоеЛицо");
			КонецЕсли;
			
			Если СтрокаТЗ <> Неопределено Тогда
				Область.Параметры.ТабельныйНомер	= СтрокаТЗ.ТабельныйНомер;
			Иначе
				Сообщить(НСтр("ru='Проверте корректность ввода данных. Не является сотрудником компании - ';uk='Перевірте правильність введення даних. Не є співробітником компанії - '") 
							+ ВыборкаПоСтрокам.Сотрудник + "!", СтатусСообщения.Информация);
			КонецЕсли;
			
			Если КоличествоОбработанных = КоличествоВВыборке Тогда
				// Последняя запись. Ее не следует отрывать от подписей.
				
				МассивТаблиц = Новый Массив(2);
				МассивТаблиц[0] = Область;
				МассивТаблиц[1] = ОбластьПодвал;
				
				Если НЕ ТабДокумент.ПроверитьВывод(МассивТаблиц) Тогда
					
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					
				КонецЕсли;
				
			КонецЕсли;
			
			ТабДокумент.Вывести(Область);
	        КоличествоОбработанных = КоличествоОбработанных + 1;

		КонецЦикла;

		// Вывод подвала
		ТабДокумент.Вывести(ОбластьПодвал);

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции // ПечатьМШ7()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета формировать табличный документ.
	// Формируем табличный документ и добавляем его в коллекцию печатных форм.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МШ7с") Тогда
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "МШ7с", НСтр("ru='Ведомость МШ-7 (сдача)';uk='Відомість МШ-7 (здача)'"),
			ПечатьМШ7(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета, Истина), , ИмяМакета);
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МШ7в") Тогда
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "МШ7в", НСтр("ru='Ведомость МШ-7 (выдача)';uk='Відомість МШ-7 (видача)'"),
			ПечатьМШ7(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета, Ложь), , ИмяМакета);
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М11") Тогда
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М11", НСтр("ru='Накладная M-11';uk='Накладна M-11'"),
			ПечатьМ11(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета), , ИмяМакета);
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОЗ1") Тогда
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОЗ1", НСтр("ru='Форма ОЗ-1';uk='Форма ОЗ-1'"),
			ПечатьОЗ1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета), , ИмяМакета);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "ФизЛицоКуда");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли