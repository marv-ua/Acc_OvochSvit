﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Физические лица"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует фамилию и инициалы либо по наименованию элемента справочника ФизическиеЛица,
// либо по переданным строкам.
// Если передан Объект, то извлеченная из него строка считается совокупностью 
// Фамилия + Имя + Отчество, разделенными пробелами.
//
// Параметры
//  ОбъектИлиСтрока - строка, ссылка или объект элемента справочника ФизическиеЛица.
//  Фамилия		    - фамилия физического лица.
//  Имя		        - имя физического лица.
//  Отчество	    - отчество физического лица.
//
// Возвращаемое значение 
//  Строка - фамилия и инициалы одной строкой. 
//  В параметрах Фамилия, Имя и Отчество записываются вычисленные части.
//
// Пример:
//  Результат = ФамилияИнициалыФизЛица("Иванов Иван Иванович"); // Результат = "Иванов И. И."
//
Функция ФамилияИнициалыФизЛица(ОбъектИлиСтрока = "", Фамилия = " ", Имя = " ", Отчество = " ") Экспорт

	ТипОбъекта = ТипЗнч(ОбъектИлиСтрока);
	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока), " ");
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ФизическиеЛица") Или ТипОбъекта = Тип("СправочникОбъект.ФизическиеЛица") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока.Наименование), " ");
	Иначе
		// используем возможно переданные отдельные строки
		Возврат ?(Не ПустаяСтрока(Фамилия), 
		          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество,1) + ".", ""), ""),
		          "")
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0, ФИО[0], "");
	Имя                = ?(КоличествоПодстрок > 1, ФИО[1], "");
	Отчество           = ?(КоличествоПодстрок > 2, ФИО[2], "");
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
	          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), ""),
	          "");
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ФизическиеЛица");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииИсключенийПоискаСсылок"].Добавить(
		"ФизическиеЛица");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Заполняет массив списком имен объектов метаданных, данные которых могут содержать ссылки на различные объекты метаданных,
// но при этом эти ссылки не должны учитываться в бизнес-логике приложения.
//
// Параметры:
//  Массив       - массив строк, например, "РегистрСведений.ВерсииОбъектов".
//
Процедура ПриДобавленииИсключенийПоискаСсылок(Массив) Экспорт
	
	Массив.Добавить(Метаданные.РегистрыСведений.ДокументыФизическихЛиц.ПолноеИмя());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.6.8";
	Обработчик.Процедура = "ФизическиеЛицаБП.ПреобразоватьУдостоверенияЛичностиВДокументы";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.5";
	Обработчик.Процедура = "ФизическиеЛицаБП.ЗаменитьВидыДокументовНаПредопределенные";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.31";
	Обработчик.Процедура = "ФизическиеЛицаБП.УстановитьРеквизитДопУпорядочиванияВидовДокументов";
	
КонецПроцедуры

// Заполняет измерение ВидДокумента по ресурсу УдалитьВидДокумента,
// а также заполняет реквизит ЯвляетсяДокументомУдостоверяющимЛичность для существующих записей
//
Процедура ПреобразоватьУдостоверенияЛичностиВДокументы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПаспортныеДанныеФизлиц.Физлицо КАК Физлицо
	|ПОМЕСТИТЬ ВТ_Физлица
	|ИЗ
	|	РегистрСведений.УдалитьПаспортныеДанныеФизлиц КАК ПаспортныеДанныеФизлиц
	|ГДЕ
	|	(НЕ ПаспортныеДанныеФизлиц.ДокументВид = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПаспортныеДанныеФизлиц.Период КАК Период,
	|	ПаспортныеДанныеФизлиц.Физлицо КАК Физлицо,
	|	ПаспортныеДанныеФизлиц.ДокументВид КАК ВидДокумента,
	|	ПаспортныеДанныеФизлиц.ДокументСерия КАК Серия,
	|	ПаспортныеДанныеФизлиц.ДокументНомер КАК Номер,
	|	ПаспортныеДанныеФизлиц.ДокументДатаВыдачи КАК ДатаВыдачи,
	|	ПаспортныеДанныеФизлиц.ДокументКемВыдан КАК КемВыдан,
	|	ВЫБОР
	|		КОГДА ПаспортныеДанныеФизлиц.ДокументВид = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЯвляетсяДокументомУдостоверяющимЛичность
	|ИЗ
	|	РегистрСведений.УдалитьПаспортныеДанныеФизлиц КАК ПаспортныеДанныеФизлиц
	|ГДЕ
	|	ПаспортныеДанныеФизлиц.Физлицо В
	|			(ВЫБРАТЬ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТ_Физлица КАК Физлица)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Физлицо,
	|	Период";
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ДокументыФизическихЛиц.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	
	ТекстСерия				= НСтр("ru=', серия: %1';uk=', серія: %1'");
	ТекстНомер				= НСтр("ru=', № %1';uk=', № %1'");
	ТекстДатаВыдачи			= НСтр("ru=', выдан: %1 года';uk=', видано: %1 року'");
	
	Пока Выборка.СледующийПоЗначениюПоля("Физлицо") Цикл
		НаборЗаписей.Отбор.Физлицо.Установить(Выборка.Физлицо);
		
		Пока Выборка.Следующий() Цикл
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			
			Если ПустаяСтрока(Запись.Представление) И Не Запись.ВидДокумента.Пустая() Тогда
				Запись.Представление = ""
				+ Запись.ВидДокумента
				+ ?(ЗначениеЗаполнено(Запись.Серия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСерия, Запись.Серия), "")
				+ ?(ЗначениеЗаполнено(Запись.Номер), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНомер, Запись.Номер), "")
				+ ?(ЗначениеЗаполнено(Запись.ДатаВыдачи), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДатаВыдачи, Формат(Запись.ДатаВыдачи,"ДФ='дд ММММ гггг'")), "")
				+ ?(ЗначениеЗаполнено(Запись.КемВыдан), ", " + Запись.КемВыдан, "")
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		НаборЗаписей.Очистить();
	КонецЦикла;
	
КонецПроцедуры

// Заменяет ссылку на виды документов физических лиц в регистре сведений ДокументыФизическихЛиц
// на добавленные предопределенные документы
//
Процедура ЗаменитьВидыДокументовНаПредопределенные() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|ПОМЕСТИТЬ ВТФизлица
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.ВидДокумента.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.Период КАК Период,
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо,
	|	ВЫБОР
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Военный билет""
	|			ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Військовий квиток""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ВоенныйБилет)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Дипломатический паспорт гражданина Украины""
	|		ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Дипломатичний паспорт громадянина України""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ДипломатическийПаспорт)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Загранпаспорт гражданина Украины""
	|			ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Загранпаспорт громадянина України""
	|			ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Загранпаспорт""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.Загранпаспорт)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт гражданина Украины""
	|			ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт громадянина України""
	|			ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.Паспорт)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт моряка""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПаспортМоряка)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Свидетельство о рождении""
	|			ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Свідоцтво про народження""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.СвидетельствоОРождении)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Водительское удостоверение""
	|			ИЛИ ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Посвідчення водія""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ВодительскоеУдостоверение)
	|		ИНАЧЕ ДокументыФизическихЛиц.ВидДокумента
	|	КОНЕЦ КАК ВидДокумента,
	|	ДокументыФизическихЛиц.Серия,
	|	ДокументыФизическихЛиц.Номер,
	|	ДокументыФизическихЛиц.ДатаВыдачи,
	|	ДокументыФизическихЛиц.КемВыдан,
	|	ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.Физлицо В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТФизлица КАК Физлица)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Физлицо,
	|	Период";
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ДокументыФизическихЛиц.СоздатьНаборЗаписей();
	
	Пока Выборка.СледующийПоЗначениюПоля("Физлицо") Цикл
		НаборЗаписей.Отбор.Физлицо.Установить(Выборка.Физлицо);
		
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		НаборЗаписей.Очистить();
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДокументовФизическихЛиц.Ссылка
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|ГДЕ
	|	(НЕ ВидыДокументовФизическихЛиц.Предопределенный)
	|	И (ВидыДокументовФизическихЛиц.Наименование = ""Военный билет"" ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Військовий квиток""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Дипломатический паспорт гражданина Украины""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Дипломатичний паспорт громадянина України""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Загранпаспорт гражданина Украины""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Загранпаспорт громадянина України""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Загранпаспорт""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт гражданина Украины""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт громадянина України""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт моряка""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Свидетельство о рождении""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Свідоцтво про народження""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Водительское удостоверение""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Посвідчення водія"")";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбновлениеИнформационнойБазы.УдалитьДанные(Выборка.Ссылка.ПолучитьОбъект());
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает РеквизитДопУпорядочивания для элементов справочника ВидыДокументовФизическихЛиц
//
Процедура УстановитьРеквизитДопУпорядочиванияВидовДокументов() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Паспорт",				Справочники.ВидыДокументовФизическихЛиц.Паспорт);
	Запрос.УстановитьПараметр("СвидетельствоОРождении", Справочники.ВидыДокументовФизическихЛиц.СвидетельствоОРождении);
	Запрос.УстановитьПараметр("ПаспортМоряка",			Справочники.ВидыДокументовФизическихЛиц.ПаспортМоряка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДокументовФизическихЛиц.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВидыДокументовФизическихЛиц.Ссылка = &Паспорт
	|			ТОГДА 1
	|		КОГДА ВидыДокументовФизическихЛиц.Ссылка = &СвидетельствоОРождении
	|			ТОГДА 2
	|		КОГДА ВидыДокументовФизическихЛиц.Ссылка = &ПаспортМоряка
	|			ТОГДА 3
	|		ИНАЧЕ 4
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ВидыДокументовФизическихЛиц.Наименование";
	
	Порядок = 1;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
		Объект.РеквизитДопУпорядочивания = Порядок;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
		Порядок = Порядок + 1;
		
	КонецЦикла;
	
КонецПроцедуры
