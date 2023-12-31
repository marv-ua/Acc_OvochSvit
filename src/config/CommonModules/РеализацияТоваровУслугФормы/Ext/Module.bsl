﻿////////////////////////////////////////////////////////////////////////////////
// РеализацияТоваровУслугФормы: серверные процедуры и функции, вызываемые из форм
// документа "Реализация товаров и услуг".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	Элементы 	= Форма.Элементы;

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(Форма);
	// Конец СтандартныеПодсистемы.Печать

	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(Форма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыОбъекта());
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
		Форма.ПодготовитьФормуНаСервере();
	КонецЕсли;

	
	// Уведомим о появлении функционала рабочей даты
	Форма.НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДатаИзДокумента");
	
	// Показываем, если это новый документ и сама рабочая дата еще не установлена.
	Форма.НастройкиПредупреждений.РабочаяДатаИзДокумента = Форма.НастройкиПредупреждений.РабочаяДатаИзДокумента
		И Форма.Параметры.Ключ.Пустая()
		И НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));
	
	// Если форма вызвана в режиме смена вида операции - модифицируем сразу при открытии, 
	// чтобы можно было подтвердить или отказаться от изменения путем сохранения или 
	// отказа от сохранения документа.
	Если Форма.Параметры.Свойство("ИзменитьВидОперации")
		И Форма.Параметры.ИзменитьВидОперации Тогда
		
		// Не кэшируем переменную Объект, т.к. может вызываться Форма.ИзменитьРеквизиты(),
		// которая меняет Объект.
		Форма.Объект.ВидОперации = Форма.Параметры.ЗначенияЗаполнения.ВидОперации;
		ВидОперацииОбработатьИзменение(Форма);
		УстановитьЗаголовокФормы(Форма);
		Форма.ОбновитьИтогиНаСервере();
		Форма.УправлениеФормойНаСервере();
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(Форма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	Форма.ПодготовитьФормуНаСервере();

КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

Процедура ДатаПриИзменении(Форма) Экспорт
	
	ДатаОбработатьИзменение(Форма);
	Форма.УстановитьЗаголовкиКолонок();
	Форма.УправлениеФормойНаСервере();
	
КонецПроцедуры

Процедура ОрганизацияПриИзменении(Форма) Экспорт

	ОрганизацияОбработатьИзменение(Форма);
	Форма.УстановитьЗаголовкиКолонок();
	Форма.УправлениеФормойНаСервере();
	
КонецПроцедуры

Процедура КонтрагентПриИзменении(Форма) Экспорт
	
	КонтрагентОбработатьИзменение(Форма);
	Форма.УправлениеФормойНаСервере();
	
КонецПроцедуры

Процедура ДоговорКонтрагентаПриИзменении(Форма) Экспорт
	
	ДоговорКонтрагентаОбработатьИзменение(Форма);
	
	ЗаполнитьСчетаУчетаВТабличнойЧасти(Форма);
	
	
	Форма.УправлениеФормойНаСервере();
	
КонецПроцедуры

Процедура СкладПриИзменении(Форма) Экспорт

	Объект = Форма.Объект;

	
	ЗаполнитьСчетаУчетаВТабличнойЧасти(Форма);

КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Товары

Процедура ТоварыНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта) Экспорт

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения		= СведенияОНоменклатуре.БазоваяЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Коэффициент			= СведенияОНоменклатуре.Коэффициент;
	СтрокаТабличнойЧасти.Цена					= СведенияОНоменклатуре.Цена;
	СтрокаТабличнойЧасти.СтавкаНДС				= СведенияОНоменклатуре.СтавкаНДС;
	
	Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Товары", СведенияОНоменклатуре);
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ДанныеОбъекта.СуммаВключаетНДС);

КонецПроцедуры

Процедура ТоварыЕдиницаИзмеренияПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта) Экспорт
	
	ОбработкаТабличныхЧастей.ЗаполнитьКоэффициентТабЧасти(СтрокаТабличнойЧасти, ДанныеОбъекта, "Товары", Метаданные.Документы.РеализацияТоваровУслуг);
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ДанныеОбъекта.СуммаВключаетНДС);

КонецПроцедуры

Процедура ОбработкаОповещенияОбработкиТабличнойЧастиТовары(Форма, Параметры) Экспорт
	
	Объект 		= Форма.Объект;
	ЭтоКомиссия = Форма.ЭтоКомиссия;

	ТаблицаОбработки = ПолучитьИзВременногоХранилища(Параметры.АдресОбработаннойТабличнойЧастиТоварыВХранилище);
	
	Отбор = Новый Структура("НомерСтрокиДокумента", 0);
	ТаблицаОбработки.Индексы.Добавить("НомерСтрокиДокумента");
	ДобавленныеСтроки = ТаблицаОбработки.НайтиСтроки(Отбор);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, ЭтоКомиссия, Реализация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ЭтоКомиссия = ЭтоКомиссия;
	ДанныеОбъекта.Реализация  = Истина;
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ДобавленныеСтроки, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для каждого СтрокаТабличнойЧасти Из ДобавленныеСтроки Цикл
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТабличнойЧасти.Номенклатура);
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
			ДанныеОбъекта, СтрокаТабличнойЧасти, "Товары", СведенияОНоменклатуре);
		
	КонецЦикла;
	
	Объект.Товары.Загрузить(ТаблицаОбработки);
	
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Услуги

Процедура УслугиНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта) Экспорт

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.Содержание	= СведенияОНоменклатуре.НаименованиеПолное;
	СтрокаТабличнойЧасти.Цена			= СведенияОНоменклатуре.Цена;
	СтрокаТабличнойЧасти.СтавкаНДС		= СведенияОНоменклатуре.СтавкаНДС;
	
	Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Услуги", СведенияОНоменклатуре);
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ДанныеОбъекта.СуммаВключаетНДС);

КонецПроцедуры

// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМ ДОКУМЕНТА РеализацияТоваровУслуг

Процедура ЗаполнитьСписокАдресовДоставки(Форма, Контрагент, Грузополучатель) Экспорт

	Элементы = Форма.Элементы;

	Элементы.АдресДоставки.СписокВыбора.Очистить();
	СписокАдресов = СписокАдресовДоставки(Контрагент, Грузополучатель);
	
	Для каждого Адрес Из СписокАдресов Цикл
		Элементы.АдресДоставки.СписокВыбора.Добавить(Адрес.Значение, Адрес.Представление);
	КонецЦикла;

КонецПроцедуры 

Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Форма, ИмяТабличнойЧасти = "") Экспорт

    Объект = Форма.Объект;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Товары" Тогда
		Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Товары");
		Форма.ЗаполнитьДобавленныеКолонкиТаблиц("Товары");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Услуги" Тогда
		Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Услуги");
		Форма.ЗаполнитьДобавленныеКолонкиТаблиц("Услуги");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "ВозвратнаяТара");
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьРассчитатьСуммы(Форма, 
			Знач ВалютаДоИзменения, 
			КурсДоИзменения, 
			КратностьДоИзменения, 
			ПерезаполнитьЦены = Ложь, 
			ПересчитатьЦены = Ложь, 
			ПересчитатьНДС = Ложь) Экспорт
	
	Объект = Форма.Объект;
	
	Если ПерезаполнитьЦены Тогда
		
		СписокНоменклатуры	= ОбщегоНазначения.ВыгрузитьКолонку(Объект.Товары, "Номенклатура", Истина);
		ОбщегоНазначения.ЗаполнитьМассивУникальнымиЗначениями(СписокНоменклатуры,
			ОбщегоНазначения.ВыгрузитьКолонку(Объект.Услуги, "Номенклатура"));
		ОбщегоНазначения.ЗаполнитьМассивУникальнымиЗначениями(СписокНоменклатуры,
			ОбщегоНазначения.ВыгрузитьКолонку(Объект.ВозвратнаяТара, "Номенклатура"));
		
		ТаблицаЦенНоменклатуры	= Ценообразование.ПолучитьТаблицуЦенНоменклатуры(
			СписокНоменклатуры,
			Объект.ТипЦен,
			Объект.Дата);
		
	ИначеЕсли ПересчитатьЦены Тогда
		Если КурсДоИзменения <> 0 И КратностьДоИзменения <> 0 Тогда
			СтруктураКурса = Новый Структура("Курс, Кратность", КурсДоИзменения, КратностьДоИзменения);
		Иначе
			СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДоИзменения, Объект.Дата);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Строка Из Объект.Товары Цикл
		ЗаполнитьРассчитатьСуммыВСтроке(
			Форма, Строка, ТаблицаЦенНоменклатуры, ВалютаДоИзменения, СтруктураКурса, ПерезаполнитьЦены, ПересчитатьЦены, ПересчитатьНДС, Истина, 0, Истина);
	КонецЦикла;
	Для Каждого Строка Из Объект.ВозвратнаяТара Цикл
		ЗаполнитьРассчитатьСуммыВСтроке(
			Форма, Строка, ТаблицаЦенНоменклатуры, ВалютаДоИзменения, СтруктураКурса, ПерезаполнитьЦены, ПересчитатьЦены, ПересчитатьНДС, Ложь, 0, Ложь);
	КонецЦикла;
	Для Каждого Строка Из Объект.Услуги Цикл
		ЗаполнитьРассчитатьСуммыВСтроке(
			Форма, Строка, ТаблицаЦенНоменклатуры, ВалютаДоИзменения, СтруктураКурса, ПерезаполнитьЦены, ПересчитатьЦены, ПересчитатьНДС, Истина, 1, Истина);
	КонецЦикла;
	
	Форма.ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

Функция ОбработкаВыбораПодборВставкаИзБуфера(Форма, ВыбранноеЗначение, ИмяТаблицы) Экспорт

	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");

	Объект = Форма.Объект;
	ЭтоКомиссия = Форма.ЭтоКомиссия;

	ДобавленныеИзмененныеСтроки = Новый Структура;
	ДобавленныеИзмененныеСтроки.Вставить("Товары", 		Новый Массив());
	ДобавленныеИзмененныеСтроки.Вставить("Услуги", 		Новый Массив());
	ДобавленныеИзмененныеСтроки.Вставить("ВозвратнаяТара",Новый Массив());

	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		
		ТаблицаТоваров = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
		
	Иначе
		
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
		
	КонецЕсли;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, ЭтоКомиссия, Реализация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ЭтоКомиссия = ЭтоКомиссия;
	ДанныеОбъекта.Реализация  = Истина;
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта);
	
	Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		ЦенаВключаетНДС	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ТипЦен, "ЦенаВключаетНДС");
	Иначе
		ЦенаВключаетНДС	= Объект.СуммаВключаетНДС;
	КонецЕсли;
	
	КоличествоДобавленныхСтрок = 0;
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтрокаТабличнойЧасти = Неопределено;
		Если Не ЭтоВставкаИзБуфера Тогда
		
			СтруктураОтбора = Новый Структура("Номенклатура, Цена", СтрокаТовара.Номенклатура, СтрокаТовара.Цена);
			Если ИмяТаблицы = "Товары" Тогда
				СтруктураОтбора.Вставить("ЕдиницаИзмерения",СтрокаТовара.ЕдиницаИзмерения);
			КонецЕсли;
			 
			СтрокаТабличнойЧасти = НайтиСтрокуТабличнойЧасти(Форма, ИмяТаблицы, СтруктураОтбора);
			
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли - увеличиваем количество.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТовара.Количество;
			
			Если ИмяТаблицы = "Товары" Тогда
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, Объект.СуммаВключаетНДС);
				
			ИначеЕсли ИмяТаблицы = "Услуги" Тогда
				// Рассчитываем реквизиты табличной части
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, Объект.СуммаВключаетНДС);
				
			ИначеЕсли ИмяТаблицы = "ВозвратнаяТара" Тогда
				// Рассчитываем реквизиты табличной части
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
			КонецЕсли;
			
		Иначе
			
			СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТовара.Номенклатура);
			Если ЭтоВставкаИзБуфера 
				И СведенияОНоменклатуре <> Неопределено
				И ЗначениеЗаполнено(СведенияОНоменклатуре.Услуга) Тогда
				
				Если СведенияОНоменклатуре.Услуга Тогда
					
					Если ИмяТаблицы = "Товары" Тогда
						Продолжить;
					КонецЕсли;
					
				Иначе
					
					Если ИмяТаблицы = "Услуги" Тогда
						Продолжить;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
			КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок + 1;
			
			Если СведенияОНоменклатуре = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
				ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТаблицы, СведенияОНоменклатуре);
				
			Если ЭтоВставкаИзБуфера
				И Найти(СписокСвойств, "СчетУчетаБУ") <> 0 
				И ЗначениеЗаполнено(СтрокаТовара["СчетУчетаБУ"]) Тогда
				
				СтрокаТабличнойЧасти.СчетУчетаБУ = СтрокаТовара.СчетУчетаБУ;
			КонецЕсли;
				
			Если ИмяТаблицы = "Товары" Тогда
				
				// Заполняем реквизиты табличной части
				СтрокаТабличнойЧасти.СтавкаНДС           = СведенияОНоменклатуре.СтавкаНДС;
				
				СтрокаТабличнойЧасти.Цена = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
					СтрокаТабличнойЧасти.Цена, ЦенаВключаетНДС, Объект.СуммаВключаетНДС,
					УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
				
				// Рассчитываем реквизиты табличной части
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, Объект.СуммаВключаетНДС);
				
			ИначеЕсли ИмяТаблицы = "Услуги" Тогда
				
				// Заполняем реквизиты табличной части
				СтрокаТабличнойЧасти.Содержание	= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.Содержание), 
					СтрокаТабличнойЧасти.Содержание, СведенияОНоменклатуре.НаименованиеПолное);
				СтрокаТабличнойЧасти.СтавкаНДС	= СведенияОНоменклатуре.СтавкаНДС;
				
				СтрокаТабличнойЧасти.Цена = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
					СтрокаТабличнойЧасти.Цена, ЦенаВключаетНДС, Объект.СуммаВключаетНДС,
					УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
				
				// Рассчитываем реквизиты табличной части
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, Объект.СуммаВключаетНДС);
				
			ИначеЕсли ИмяТаблицы = "ВозвратнаяТара" Тогда
				
				СтрокаТабличнойЧасти.Цена = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
				СтрокаТабличнойЧасти.Цена, ЦенаВключаетНДС, Истина,
				УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СведенияОНоменклатуре.СтавкаНДС));
				
				// Рассчитываем реквизиты табличной части
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
				
			КонецЕсли;
		КонецЕсли;
		
		ДобавленныеИзмененныеСтроки[ИмяТаблицы].Добавить(СтрокаТабличнойЧасти);
		
	КонецЦикла;
	
	Если ЭтоВставкаИзБуфера Тогда
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок;
	КонецЕсли;	
	
	Возврат ДобавленныеИзмененныеСтроки;
	
КонецФункции

Процедура ОбработкаВыбораПорядокУчетаРасчетов(Форма, ВыбранноеЗначение) Экспорт

	Объект = Форма.Объект;

	Объект.СчетУчетаРасчетовСКонтрагентом 	= ВыбранноеЗначение.СчетУчетаРасчетовСКонтрагентом;
	Объект.СчетУчетаРасчетовПоАвансам 		= ВыбранноеЗначение.СчетУчетаРасчетовПоАвансам;
	
	Форма.Модифицированность = Истина;


КонецПроцедуры

Процедура ОбработкаЗаполненияПоСчету(Форма, ВыбранноеЗначение, ТабличнаяЧасть) Экспорт

	Объект = Форма.Объект;

	// Заполняем полностью весь документ по счету на оплату
	РеквизитыСчетаНаОплату = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ВыбранноеЗначение, "Контрагент, ДоговорКонтрагента");

	Объект.СчетНаОплатуПокупателю 	= ВыбранноеЗначение;
	Объект.Контрагент 				= РеквизитыСчетаНаОплату.Контрагент;
	Объект.ДоговорКонтрагента 		= РеквизитыСчетаНаОплату.ДоговорКонтрагента;
	
	КонтрагентОбработатьИзменение(Форма);
	ДоговорКонтрагентаОбработатьИзменение(Форма);

	ДокументОбъект = Форма.РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьПоСчету(ТабличнаяЧасть, ВыбранноеЗначение);
	Форма.ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");

КонецПроцедуры

Процедура УстановитьПараметрыВыбора(Форма) Экспорт

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	МассивВидовДоговоров = Новый ФиксированныйМассив(Форма.ПолучитьМассивВидовДоговоров());
	НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидДоговора", МассивВидовДоговоров);
	НовыйМассивПараметров = Новый Массив();
	НовыйМассивПараметров.Добавить(НовыйПараметр);

	НовыеПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	Элементы.ДоговорКонтрагента.ПараметрыВыбора = НовыеПараметрыВыбора;

КонецПроцедуры

Процедура УстановитьЗаголовокФормы(Форма) Экспорт
	
	Объект = Форма.Объект;

	ТекстЗаголовка	= НСтр("ru='Реализация товаров и услуг';uk='Реалізація товарів і послуг'");
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2';uk=' %1 від %2'"), Объект.Номер, Объект.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru=' (создание)';uk=' (створення)'");
	КонецЕсли;
	
	Форма.Заголовок = ТекстЗаголовка + " (" + Строка(Объект.ВидОперации) + ")";

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ВидОперацииОбработатьИзменение(Форма)
	
	Объект = Форма.Объект;

	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Возврат;
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент) Тогда
		БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(Объект.ДоговорКонтрагента,
			Объект.Контрагент, Объект.Организация, Форма.ПолучитьМассивВидовДоговоров());
	КонецЕсли;
	
	ДоговорУказан = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	
	
	Если ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		ДоговорКонтрагентаОбработатьИзменение(Форма);
	КонецЕсли;
	
	УстановитьПараметрыВыбора(Форма);
	
	
КонецПроцедуры

Процедура ДатаОбработатьИзменение(Форма)

	Объект 		= Форма.Объект;
	Элементы 	= Форма.Элементы;

	ПредыдущаяОрганизацияПлательщикНДС = Форма.ПлательщикНДС;

	Форма.УстановитьФункциональныеОпцииФормы();

	// Если изменился статус плательщика НДС необходимо перезаполнить ставки НДС
	Если ПредыдущаяОрганизацияПлательщикНДС <> Форма.ПлательщикНДС Тогда
		ПересчитатьСуммыПриИзмененииПризнакаПлательщикНДС(Форма);
	КонецЕсли;
	
	Если (Объект.ВалютаДокумента <> Форма.ВалютаРегламентированногоУчета) Тогда
		СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
		Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОрганизацияОбработатьИзменение(Форма)

	Объект = Форма.Объект;

	ПредыдущаяОрганизацияПлательщикНДС = Форма.ПлательщикНДС;

	Форма.УстановитьФункциональныеОпцииФормы();
	
	// Если изменился статус плательщика НДС необходимо перезаполнить ставки НДС
	Если ПредыдущаяОрганизацияПлательщикНДС <> Форма.ПлательщикНДС Тогда
		ПересчитатьСуммыПриИзмененииПризнакаПлательщикНДС(Форма);
	КонецЕсли;
	
	Объект.Сделка = Неопределено;
	
	КонтрагентОбработатьИзменение(Форма);
	
	
	ЗаполнитьСчетаУчетаВТабличнойЧасти(Форма);
	
КонецПроцедуры

Процедура КонтрагентОбработатьИзменение(Форма)
	
	Объект 		= Форма.Объект;
	Элементы 	= Форма.Элементы;

	Если НЕ ЗначениеЗаполнено(Объект.Грузополучатель) Тогда
		Если Форма.Элементы.Найти("АдресДоставки") <> Неопределено Тогда
			ЗаполнитьСписокАдресовДоставки(Форма, Объект.Контрагент, Объект.Грузополучатель);
			СписокАдресов = Элементы.АдресДоставки.СписокВыбора;
		Иначе
			СписокАдресов = СписокАдресовДоставки(Объект.Контрагент, Объект.Грузополучатель);
		КонецЕсли;
		
		Если СписокАдресов.Количество() > 0 Тогда
			Объект.АдресДоставки = СписокАдресов[0].Значение;
		Иначе
			Объект.АдресДоставки = "";
		КонецЕсли;
	КонецЕсли;
	
	Объект.Сделка = Неопределено;

	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(
		Объект.ДоговорКонтрагента, Объект.Контрагент, Объект.Организация, 
		Форма.ПолучитьМассивВидовДоговоров());
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаОбработатьИзменение(Форма);
	Иначе
		Форма.ЭтоКомиссия                                = Ложь;
		Форма.ВедениеВзаиморасчетовПоРасчетнымДокументам = Ложь;
		Форма.Внешнеэкономический                        = Ложь;
		Форма.СложныйНалоговыйУчет                       = Ложь;	
	КонецЕсли;
	
	ЗаполнитьСчетаУчетаВТабличнойЧасти(Форма);
	
КонецПроцедуры

Процедура ДоговорКонтрагентаОбработатьИзменение(Форма)
	
	Объект = Форма.Объект;

	ВалютаДоИзменения = Объект.ВалютаДокумента;
	КурсДоИзменения   = Объект.КурсВзаиморасчетов;
	КратностьДоИзменения = Объект.КратностьВзаиморасчетов;
	ТипЦенДоИзменения = Объект.ТипЦен;
	СуммаВключаетНДСДоИзменения = Объект.СуммаВключаетНДС;
	
	ДоговорУказан     = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.ДоговорКонтрагента, "ВалютаВзаиморасчетов, Владелец, ТипЦен, ВидДоговора, ВедениеВзаиморасчетов, СложныйНалоговыйУчет");
	
	Если ДоговорУказан Тогда
		Форма.ВалютаВзаиморасчетов = РеквизитыДоговора.ВалютаВзаиморасчетов;
		Объект.ВалютаДокумента     = Форма.ВалютаВзаиморасчетов;
		Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
			Объект.Контрагент = РеквизитыДоговора.Владелец;
		КонецЕсли;
	Иначе
		Объект.ВалютаДокумента     = Форма.ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Если ВалютаДоИзменения <> Объект.ВалютаДокумента Тогда
		СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
		Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
	Если ДоговорУказан И ЗначениеЗаполнено(РеквизитыДоговора.ТипЦен) Тогда
		Объект.ТипЦен           = РеквизитыДоговора.ТипЦен;
		Объект.СуммаВключаетНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыДоговора.ТипЦен, "ЦенаВключаетНДС");
	КонецЕсли;
	
	ПересчитатьЦены = Объект.ВалютаДокумента <> ВалютаДоИзменения
		ИЛИ Объект.КурсВзаиморасчетов <> КурсДоИзменения
		ИЛИ Объект.ТипЦен <> ТипЦенДоИзменения;
	ПересчитатьНДС = Объект.СуммаВключаетНДС <> СуммаВключаетНДСДоИзменения;
	Если ЕстьСтрокиВТабличныхЧастях(Форма) И (ПересчитатьЦены ИЛИ ПересчитатьНДС) Тогда
		ЗаполнитьРассчитатьСуммы(Форма, ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, Ложь, ПересчитатьЦены, ПересчитатьНДС);
	ИначеЕсли ПересчитатьНДС Тогда
		Форма.УстановитьЗаголовкиКолонок();
	КонецЕсли;
	
	ЭтоКомиссия = ДоговорУказан И РеквизитыДоговора.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером;
	ВедениеВзаиморасчетовПоРасчетнымДокументам = ДоговорУказан И РеквизитыДоговора.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам;
	Внешнеэкономический = ДоговорУказан И РеквизитыДоговора.ВалютаВзаиморасчетов <> Форма.ВалютаРегламентированногоУчета;
	СложныйНалоговыйУчет = ДоговорУказан И РеквизитыДоговора.СложныйНалоговыйУчет;
	
	Форма.ЭтоКомиссия                                = ЭтоКомиссия;
	Форма.ВедениеВзаиморасчетовПоРасчетнымДокументам = ВедениеВзаиморасчетовПоРасчетнымДокументам;
	Форма.Внешнеэкономический                        = Внешнеэкономический;
	Форма.СложныйНалоговыйУчет                       = СложныйНалоговыйУчет;
	
	Если Не ВедениеВзаиморасчетовПоРасчетнымДокументам Тогда
		Если ЗначениеЗаполнено(Объект.Сделка) Тогда
			Объект.Сделка = Неопределено;
		КонецЕсли;	
	КонецЕсли;
	
	Если ЭтоКомиссия Тогда
		
		Если Объект.Услуги.Количество() > 0 Тогда
			Объект.Услуги.Очистить(); // На комиссию передать услуги нельзя
		КонецЕсли;
		
		
	КонецЕсли;
	
	Если Внешнеэкономический Тогда
		Если Объект.ВозвратнаяТара.Количество() > 0 Тогда
			Объект.ВозвратнаяТара.Очистить();
		КонецЕсли;	
	КонецЕсли;
	
	Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаРасчетов(Объект);
	
	
КонецПроцедуры

Процедура ЗаполнитьРассчитатьСуммыВСтроке(Форма, Строка, ТаблицаЦенНоменклатуры, ВалютаПередИзменением, СтруктураКурса,
										ПерезаполнитьЦены, ПересчитатьЦены, ПересчитатьНДС, ЕстьНДС,
										ЗначениеПустогоКоличества, ЕстьСкидки)

	Объект = Форма.Объект;

	СуммаСкидки = 0;
	
	Если ПерезаполнитьЦены Тогда
		
		НайденнаяСтрока	= ТаблицаЦенНоменклатуры.Найти(Строка.Номенклатура, "Номенклатура");
		Если НайденнаяСтрока <> Неопределено Тогда
			Цена = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
				НайденнаяСтрока.Цена, НайденнаяСтрока.Валюта, Объект.ВалютаДокумента, НайденнаяСтрока.Курс,
				Объект.КурсВзаиморасчетов, НайденнаяСтрока.Кратность, Объект.КратностьВзаиморасчетов);
			Если ЕстьСкидки Тогда
				СуммаСкидки = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
					Строка.СуммаСкидки, НайденнаяСтрока.Валюта, Объект.ВалютаДокумента, НайденнаяСтрока.Курс,
					Объект.КурсВзаиморасчетов, НайденнаяСтрока.Кратность, Объект.КратностьВзаиморасчетов);
			КонецЕсли;
		Иначе
			Цена = 0;
			Если ЕстьСкидки Тогда
 				СуммаСкидки = 0;
			КонецЕсли;
		КонецЕсли;
		
		// Признак того, что цена включает НДС, хранится в реквизите ЦенаВключаетНДС типа цен
		ЦенаВключаетНДС = ?(ЗначениеЗаполнено(Объект.ТипЦен), Объект.ТипЦен.ЦенаВключаетНДС, Ложь);
		
	Иначе
		Если ПересчитатьЦены Тогда

			Цена = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
				Строка.Цена, ВалютаПередИзменением, Объект.ВалютаДокумента, СтруктураКурса.Курс,
				Объект.КурсВзаиморасчетов, СтруктураКурса.Кратность, Объект.КратностьВзаиморасчетов);
			Если ЕстьСкидки Тогда
				СуммаСкидки = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
					Строка.СуммаСкидки, ВалютаПередИзменением, Объект.ВалютаДокумента, СтруктураКурса.Курс,
					Объект.КурсВзаиморасчетов, СтруктураКурса.Кратность, Объект.КратностьВзаиморасчетов);
			КонецЕсли;

		Иначе
			Цена = Строка.Цена;
			Если ЕстьСкидки Тогда
				СуммаСкидки = Строка.СуммаСкидки;
			КонецЕсли;
		КонецЕсли;
		// Признак того, что цена включает НДС, хранится в реквизите СуммаВключаетНДС документа
		ЦенаВключаетНДС = ?(ПересчитатьНДС, НЕ Объект.СуммаВключаетНДС, Объект.СуммаВключаетНДС);
	КонецЕсли;

	Если ЕстьНДС Тогда

		Строка.Цена = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
			Цена, ЦенаВключаетНДС, Объект.СуммаВключаетНДС, УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Строка.СтавкаНДС));

		СуммаБезСкидки = Строка.Цена * ?(Строка.Количество = 0, ЗначениеПустогоКоличества, Строка.Количество);
		Если ЕстьСкидки Тогда
			Строка.СуммаБезСкидки = СуммаБезСкидки;
			Если (СуммаСкидки <> 0) И (Цена <> Строка.Цена) И (Цена <> 0) Тогда
				СуммаСкидки = Окр(СуммаСкидки * Строка.Цена / Цена, 2, 1);
			КонецЕсли;
			Строка.СуммаСкидки = СуммаСкидки;
		КонецЕсли;
		Строка.Сумма = СуммаБезСкидки - СуммаСкидки;
		Строка.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(Строка.Сумма, Объект.СуммаВключаетНДС, УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Строка.СтавкаНДС));

	Иначе
		Строка.Цена = Цена;
		СуммаБезСкидки = Строка.Цена * ?(Строка.Количество = 0, ЗначениеПустогоКоличества, Строка.Количество);
		Если ЕстьСкидки Тогда
			Строка.СуммаБезСкидки = СуммаБезСкидки;
			Строка.СуммаСкидки = СуммаСкидки;
		КонецЕсли;
		Строка.Сумма = СуммаБезСкидки - СуммаСкидки;
	КонецЕсли;

КонецПроцедуры

Функция ЕстьСтрокиВТабличныхЧастях(Форма)
	
	Объект = Форма.Объект;
	

	ЕстьСтроки = Объект.Товары.Количество() > 0 
		ИЛИ Объект.ВозвратнаяТара.Количество() > 0
		ИЛИ Объект.Услуги.Количество() > 0;
		
	Возврат ЕстьСтроки;

КонецФункции

Функция СписокАдресовДоставки(Контрагент, Грузополучатель)

	СписокАдресов = Новый СписокЗначений;

	КонтрагентДоставки = ?(ЗначениеЗаполнено(Грузополучатель), Грузополучатель, Контрагент);
	Если НЕ ЗначениеЗаполнено(КонтрагентДоставки) Тогда
		Возврат СписокАдресов;
	КонецЕсли;
	
	Адреса = УправлениеКонтактнойИнформацией.ЗначенияКонтактнойИнформацииОбъекта(
		КонтрагентДоставки, Перечисления.ТипыКонтактнойИнформации.Адрес);
	Для каждого Адрес Из Адреса Цикл
		СписокАдресов.Добавить(Адрес.Значение, "" + Адрес.Вид + ": " + Адрес.Значение);
	КонецЦикла;

	Возврат СписокАдресов;

КонецФункции

Функция НайтиСтрокуТабличнойЧасти(Форма, ИмяТабличнойЧасти, СтруктураОтбора)

	Объект = Форма.Объект;

	СтрокаТабличнойЧасти = Неопределено;

	МассивНайденныхСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

Процедура ПересчитатьСуммыПриИзмененииПризнакаПлательщикНДС(Форма)
	
	Объект = Форма.Объект;
	
	МетаданныеДокумента = Объект.Ссылка.Метаданные();
	ПараметрыОбъекта = Новый Структура("Организация, Дата, ПлательщикНДС", Объект.Организация, Объект.Дата, Форма.ПлательщикНДС);

	Если Не Форма.ПлательщикНДС Тогда
		//организацию-плательщика поменяли на неплательщика, сумма не включала НДС - надо пересчитать;
		ПересчитатьНДС = Не Объект.СуммаВключаетНДС;			
		
		Объект.СуммаВключаетНДС = Истина;
	Иначе
		//организацию-неплательщика поменяли на плательщика;
		ПересчитатьНДС = Ложь;
		
		//заполним ставки до пересчета цены
		Для Каждого Строка Из Объект.Товары Цикл
			ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(Строка, ПараметрыОбъекта, "Товары", МетаданныеДокумента);
		КонецЦикла;
		Для Каждого Строка Из Объект.Услуги Цикл
			ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(Строка, ПараметрыОбъекта, "Услуги", МетаданныеДокумента);
		КонецЦикла;

	КонецЕсли;
			
	ЗаполнитьРассчитатьСуммы(
		Форма, 
		Объект.ВалютаДокумента, 
		Объект.КурсВзаиморасчетов, 
		Объект.КратностьВзаиморасчетов,
		Ложь, // ПерезаполнитьЦены
		Ложь, // ПересчитатьЦены
		ПересчитатьНДС
	);
	
	Если Не Форма.ПлательщикНДС Тогда
		//организацию-плательщика поменяли на неплательщика 
		
		//заполним ставки после пересчета цены
		// и пересчитаем зависимые от ставки колонки СуммаНДС, Всего
		Для Каждого Строка Из Объект.Товары Цикл
			ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(Строка, ПараметрыОбъекта, "Товары", МетаданныеДокумента);
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(Строка, Объект.СуммаВключаетНДС);
		КонецЦикла;
		Для Каждого Строка Из Объект.Услуги Цикл
			ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(Строка, ПараметрыОбъекта, "Услуги", МетаданныеДокумента);
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(Строка, Объект.СуммаВключаетНДС);
		КонецЦикла;
	
		Форма.ЗаполнитьДобавленныеКолонкиТаблиц();
	
	КонецЕсли;
	
КонецПроцедуры
