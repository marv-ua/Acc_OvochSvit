﻿////////////////////////////////////////////////////////////////////////////////
// ПоступлениеТоваровУслугФормыКлиент: клиентские процедуры и функции, вызываемые 
// из форм документа "Поступление товаров и услуг".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


Процедура ПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт

		
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

Процедура НомерВходящегоДокументаПриИзменении(Форма, Элемент) Экспорт
	
	Объект = Форма.Объект;

	Если ЗначениеЗаполнено(Форма.ЗначениеРабочейДаты) Тогда
		Если ЗначениеЗаполнено(Объект.НомерВходящегоДокумента) 
			И НЕ ЗначениеЗаполнено(Объект.ДатаВходящегоДокумента) Тогда
			Объект.ДатаВходящегоДокумента = Форма.ЗначениеРабочейДаты;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
         
Процедура ЦеныИВалютаНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	ОбработатьИзмененияПоКнопкеЦеныИВалюты(Форма);
	
КонецПроцедуры

Процедура ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Объект = Форма.Объект;

	СтруктураЦеныИВалюта = РезультатЗакрытия;
	
	Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") И СтруктураЦеныИВалюта.БылиВнесеныИзменения Тогда
		
		ВалютаДоИзменения    = Объект.ВалютаДокумента;
		КурсДоИзменения      = Объект.КурсВзаиморасчетов;
		КратностьДоИзменения = Объект.КратностьВзаиморасчетов;
		
		Объект.ТипЦен                  = СтруктураЦеныИВалюта.ТипЦен;
		Объект.ВалютаДокумента         = СтруктураЦеныИВалюта.ВалютаДокумента;
		Объект.КурсВзаиморасчетов      = СтруктураЦеныИВалюта.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураЦеныИВалюта.Кратность;
		Объект.СуммаВключаетНДС        = СтруктураЦеныИВалюта.СуммаВключаетНДС;
		
		Форма.Модифицированность = Истина;
		
		ПересчитатьНДС = СтруктураЦеныИВалюта.СуммаВключаетНДС <> СтруктураЦеныИВалюта.ПредСуммаВключаетНДС;
		
		Форма.ПриИзмененииЦеныИВалюты(
			ВалютаДоИзменения, 
			КурсДоИзменения,
			КратностьДоИзменения,
			СтруктураЦеныИВалюта.ПерезаполнитьЦены, 
			СтруктураЦеныИВалюта.ПересчитатьЦены, 
			ПересчитатьНДС,
			?(СтруктураЦеныИВалюта.Свойство("РассчитатьНДССУчетомОшибокОкругления"), СтруктураЦеныИВалюта.РассчитатьНДССУчетомОшибокОкругления, Ложь));
	
	КонецЕсли;
	
КонецПроцедуры

// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


Процедура ПровестиИЗакрыть(Форма, Команда) Экспорт
	
	КлючеваяОперация = "ПроведениеПоступлениеТоваровИУслуг";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Форма.Записать(ПараметрыЗаписи);
	Форма.Закрыть();
	
КонецПроцедуры

Процедура ПодборНоменклатуры(Форма, ИмяТаблицы, Команда) Экспорт
	
	Если Форма.ТоварыСвернуты И Форма.НТТ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПодбора = ПолучитьПараметрыПодбора(Форма, ИмяТаблицы);
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			Форма, Форма.УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

Процедура ИзменитьТовары(Форма, Команда, АдресХранилищаТовары) Экспорт

	ПараметрыФормы = ПолучитьПараметрыОбработкиТабличнойЧастиТовары(Форма, АдресХранилищаТовары);
	
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму("Обработка.ИзменениеТаблицыТоваров.Форма.Форма", ПараметрыФормы,
			Форма, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМ ДОКУМЕНТА ПоступлениеТоваровУслуг


Функция ПодготовитьПараметрыОбработкиТоварыНоменклатураПриИзменении(Форма, СтрокаТабличнойЧасти) Экспорт
	
	Объект = Форма.Объект;
	
	РассчитыватьСуммаВРознице 	= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "РассчитыватьСуммаВРознице");
	НТТ 						= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "НТТ");
	УчетВПродажныхЦенах 		= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "УчетВПродажныхЦенах");
	РазделениеПоСтавкамВРознице = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "РазделениеПоСтавкамВРознице");	
	ЭтоКомиссия					= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ЭтоКомиссия");

	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, ЕдиницаИзмерения, Коэффициент, Количество,
		|Цена, Сумма, СтавкаНДС, СуммаНДС,
		|СчетУчетаБУ,
		//| СчетУчетаНДС,
		|НаименованиеПоставщика, 
		|НалоговоеНазначение, 
		|ЦенаВРознице, СуммаВРознице, СтавкаНДСВРознице
		|");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
	
	ДанныеОбъекта = Новый Структура(                                      
		"Дата, ВидОперации, Организация, Склад, ТипЦен, СуммаВключаетНДС, Ссылка,
		|ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов,
		|Контрагент, Звит1С_DOC_ID, 
		|РассчитыватьСуммаВРознице, ЗаполнятьСтавкуНДСВРознице, ЭтоКомиссия");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.РассчитыватьСуммаВРознице  = РассчитыватьСуммаВРознице;
	ДанныеОбъекта.ЗаполнятьСтавкуНДСВРознице = НТТ И УчетВПродажныхЦенах И РазделениеПоСтавкамВРознице;
	ДанныеОбъекта.ЭтоКомиссия                = ЭтоКомиссия;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку") Тогда
		ДанныеОбъекта.Вставить("СтавкаНДС", ПредопределенноеЗначение("Перечисление.СтавкиНДС.НеНДС"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.ВалютаВзаиморасчетов) И НЕ (Форма.ВалютаВзаиморасчетов = Форма.ВалютаРегламентированногоУчета) Тогда
		ДанныеОбъекта.Вставить("СтавкаНДС", ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС"));
	КонецЕсли;
	
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("ДанныеСтрокиТаблицы", 	ДанныеСтрокиТаблицы);
	ПараметрыОбработки.Вставить("ДанныеОбъекта", 		ДанныеОбъекта);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

Функция ПодготовитьПараметрыОбработкиУслугиНоменклатураПриИзменении(Форма, СтрокаТабличнойЧасти) Экспорт
	
	Объект = Форма.Объект;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, Содержание, Количество, Цена, Сумма, СтавкаНДС, СуммаНДС,
		|СчетЗатрат, Субконто1, Субконто2, Субконто3,
		|СчетУчетаНДС,
		|НалоговоеНазначение, НалоговоеНазначениеДоходовИЗатрат
		|,ПоставкаОсновныхФондов,ХарактерЗатрат,ЦелевоеНалоговоеНазначение");

	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, ВидОперации, Склад, ТипЦен, СуммаВключаетНДС,
		|Контрагент, Звит1С_DOC_ID, 
		|ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов, ЭтоКомиссия");
	ДанныеОбъекта.ЭтоКомиссия = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ЭтоКомиссия");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	Если ЗначениеЗаполнено(Форма.ВалютаВзаиморасчетов) И НЕ (Форма.ВалютаВзаиморасчетов = Форма.ВалютаРегламентированногоУчета) Тогда
		ДанныеОбъекта.Вставить("СтавкаНДС", ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС"));
	КонецЕсли;
	
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("ДанныеСтрокиТаблицы", 	ДанныеСтрокиТаблицы);
	ПараметрыОбработки.Вставить("ДанныеОбъекта", 		ДанныеОбъекта);
	
	Возврат ПараметрыОбработки;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ОбработатьИзмененияПоКнопкеЦеныИВалюты(
		Форма,
		ПересчитатьЦены = Ложь,
		ПерезаполнитьЦены = Ложь,
		КурсВзаиморасчетов = Неопределено,
		КратностьВзаиморасчетов = Неопределено,
		ТипЦен = Неопределено)

	Объект = Форма.Объект;
	ЭтоКомиссия = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ЭтоКомиссия");

	// Формирование структуры параметров для заполнения формы "Цены и Валюта".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента"     , Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Курс"                , ?(КурсВзаиморасчетов = Неопределено, Объект.КурсВзаиморасчетов, КурсВзаиморасчетов));
	СтруктураПараметров.Вставить("Кратность"           , ?(КратностьВзаиморасчетов = Неопределено, Объект.КратностьВзаиморасчетов, КратностьВзаиморасчетов));
	СтруктураПараметров.Вставить("Контрагент"          , Объект.Контрагент);
	СтруктураПараметров.Вставить("Договор"             , Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Организация"         , Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента"       , Объект.Дата);
	СтруктураПараметров.Вставить("ПерезаполнитьЦены"   , ПерезаполнитьЦены);
	СтруктураПараметров.Вставить("ПересчитатьЦены"     , ПересчитатьЦены);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения", Ложь);
	СтруктураПараметров.Вставить("ТипЦен"              , ?(ТипЦен = Неопределено, Объект.ТипЦен, ТипЦен));
	СтруктураПараметров.Вставить("ПлательщикНДС",		 Форма.ПлательщикНДС);	
	
	Если  Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку")
		И Форма.ВалютаВзаиморасчетов = Форма.ВалютаРегламентированногоУчета Тогда
		СтруктураПараметров.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);
	КонецЕсли;
	
	Если Форма.ПлательщикНДС И НЕ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку") Тогда
		СтруктураПараметров.Вставить("РазрешитьПересчетНДС");	
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаЦеныИВалюта", СтруктураПараметров,,,,, ОповещениеОЗакрытии);

КонецПроцедуры

Функция ПолучитьПараметрыПодбора(Форма, ИмяТаблицы)
	
	Объект = Форма.Объект;

	ПараметрыФормы = Новый Структура;
	
	ДатаРасчетов     = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	ЗаголовокПодбора = НСтр("ru='Подбор номенклатуры в %1 (%2)';uk='Підбір номенклатури %1 (%2)'");
	
	Валюта = Объект.ВалютаДокумента;
	
	Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		Параметрыформы.Вставить("ПоказыватьЦены", Истина);
	КонецЕсли;
	
	Если ИмяТаблицы = "Оборудование" Тогда
		ПредставлениеТаблицы = НСтр("ru='Оборудование';uk='Устаткування'");
		ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
		ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
		
	ИначеЕсли ИмяТаблицы = "Товары" Тогда
		ПредставлениеТаблицы = НСтр("ru='Товары';uk='Товари'");
		ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
		ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
		
	ИначеЕсли ИмяТаблицы = "БланкиСтрогогоУчета" Тогда
		ПредставлениеТаблицы = НСтр("ru='Бланки строгого учета';uk='Бланки суворого обліку'");
		ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
		ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
		
	ИначеЕсли ИмяТаблицы = "ВозвратнаяТара" Тогда
		ПредставлениеТаблицы = НСтр("ru='Возвратная тара';uk='Зворотна тара'");
		
		Отказ = Ложь;
		ОчиститьСообщения();
		Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			Валюта = Форма.ВалютаВзаиморасчетов;
			Если НЕ ЗначениеЗаполнено(Валюта) Тогда
				ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,, НСтр("ru='Валюта расчетов';uk='Валюта розрахунків'"));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ДоговорКонтрагента", "Объект", Отказ);
			КонецЕсли;
		Иначе
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,, НСтр("ru='Договор';uk='Договір'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ДоговорКонтрагента", "Объект", Отказ);
		КонецЕсли;
		Если Отказ Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
		ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
	ИначеЕсли ИмяТаблицы = "Услуги" Тогда
		ПредставлениеТаблицы = НСтр("ru='Услуги';uk='Послуги'");
	КонецЕсли;
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы.Вставить("ЕстьЦена"          , Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество"    , Истина);
	ПараметрыФормы.Вставить("ДатаРасчетов"      , ДатаРасчетов);
	ПараметрыФормы.Вставить("ТипЦен"            , Объект.ТипЦен);
	ПараметрыФормы.Вставить("Валюта"            , Валюта);
	ПараметрыФормы.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	ПараметрыФормы.Вставить("Контрагент"        , Объект.Контрагент);
	ПараметрыФормы.Вставить("Организация"       , Объект.Организация);
	ПараметрыФормы.Вставить("Склад"             , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"         , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"        , "");
	ПараметрыФормы.Вставить("ИмяТаблицы"        , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"            , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("БланкиСтрогогоУчета", ИмяТаблицы = "БланкиСтрогогоУчета");
	
	Возврат ПараметрыФормы;
	
КонецФункции

Функция ПолучитьПараметрыОбработкиТабличнойЧастиТовары(Форма, АдресХранилищаТовары)

	Объект = Форма.Объект;

	ПараметрыОбработки = Новый Структура;
	
	ПараметрыОбработки.Вставить("АдресХранилищаТовары", 		АдресХранилищаТовары);
	ПараметрыОбработки.Вставить("ЗаполнятьЦеныПоПокупке", 		Истина);
	
	ПараметрыОбработки.Вставить("ДокументСсылка", 				Объект.Ссылка);
	ПараметрыОбработки.Вставить("ДокументДата", 				Объект.Дата);
	ПараметрыОбработки.Вставить("ДокументОрганизация", 			Объект.Организация);
	ПараметрыОбработки.Вставить("ДокументВалюта", 				Объект.ВалютаДокумента);
	ПараметрыОбработки.Вставить("ДокументКурс", 				Объект.КурсВзаиморасчетов);
	ПараметрыОбработки.Вставить("ДокументКратность", 			Объект.КратностьВзаиморасчетов);
	ПараметрыОбработки.Вставить("ДокументСуммаВключаетНДС", 	Объект.СуммаВключаетНДС);
	ПараметрыОбработки.Вставить("ДокументТипЦен", 				Объект.ТипЦен);
	ПараметрыОбработки.Вставить("ДокументСклад", 				Объект.Склад);

	Возврат ПараметрыОбработки;
	
КонецФункции 
