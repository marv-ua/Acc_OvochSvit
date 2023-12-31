﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

#Область Проведение

// Записать суммы документа в соответствующие реквизиты шапки для показа в журналах
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Нет.
//
Процедура РасчетСуммДокумента()

	СуммаДокумента = Комплектующие.Итог("Сумма");

КонецПроцедуры // РасчетСуммДокумента


// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоКомплектующим - результат запроса по табличной части "Комплектующие",
//  СтруктураШапкиДокумента         - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуКомплектующих(РезультатЗапросаПоКомплектующим, СтруктураШапкиДокумента)

	ТаблицаКомплектующих = РезультатЗапросаПоКомплектующим.Выгрузить();
	
	ТаблицаКомплектующих.Колонки.Добавить("ДоговорКонтрагента");
	ТаблицаКомплектующих.Колонки.Добавить("Регистратор");
	ТаблицаКомплектующих.Колонки.Добавить("Склад");
	ТаблицаКомплектующих.Колонки.Добавить("Организация");
	ТаблицаКомплектующих.Колонки.Добавить("ДокументОприходования");
	ТаблицаКомплектующих.Колонки.Добавить("НалоговоеНазначение");
	ТаблицаКомплектующих.Колонки.Добавить("НалоговоеНазначениеНовое");

	ТаблицаКомплектующих.ЗаполнитьЗначения(Неопределено, "ДоговорКонтрагента");
	ТаблицаКомплектующих.ЗаполнитьЗначения(ЭтотОбъект,   "Регистратор");
	ТаблицаКомплектующих.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, "Склад");
	ТаблицаКомплектующих.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация,   "Организация");
	ТаблицаКомплектующих.ЗаполнитьЗначения(СтруктураШапкиДокумента.НалоговоеНазначение,   "НалоговоеНазначение");
	ТаблицаКомплектующих.ЗаполнитьЗначения(СтруктураШапкиДокумента.НалоговоеНазначение,   "НалоговоеНазначениеНовое");
	
	Возврат ТаблицаКомплектующих;

КонецФункции // ПодготовитьТаблицуКомплектующих()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоКомплектующим - результат запроса по табличной части "Комплектующие",
//  СтруктураШапкиДокумента         - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений по комплектам.
//
Функция ПодготовитьТаблицуКомплектов(РезультатЗапросаПоКомплектам, СтруктураШапкиДокумента)

	// подготовим структуру таблицы
	ТаблицаКомплектов = РезультатЗапросаПоКомплектам.СкопироватьКолонки();

	НоваяСтрока = ТаблицаКомплектов.Добавить();
	НоваяСтрока.Номенклатура                 = СтруктураШапкиДокумента.Номенклатура;
	НоваяСтрока.Услуга                       = СтруктураШапкиДокумента.Услуга;
	НоваяСтрока.Количество                   = СтруктураШапкиДокумента.Количество * СтруктураШапкиДокумента.Коэффициент;
	НоваяСтрока.СчетУчетаБУ                  = СтруктураШапкиДокумента.СчетУчетаБУ;

	НоваяСтрока.НалоговоеНазначение			 = СтруктураШапкиДокумента.НалоговоеНазначение;
	
	НоваяСтрока.НомерСтроки                  = 0;
	
	Возврат ТаблицаКомплектов;

КонецФункции // ПодготовитьТаблицуКомплектов()


Процедура ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл(СтруктураПолей, СтруктураШапкиДокумента)

	СтруктураПолей.Вставить("СчетУчетаБУ"               , "СчетУчетаБУ");
	
КонецПроцедуры // ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоКомплектующим    - таблица значений, содержащая данные для проведения и проверки ТЧ ТаблицаПоКомплектующим
//  ТаблицаПоКомплектам       - таблица значений, содержащая данные для проведения и проверки по комплектам,
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоКомплектующим, ТаблицаПоКомплектам, Отказ, Заголовок);

	// Движения по документу
	
	// Проведение по партиям остановим в том случае, если не хватит хоть одного комплектующего.
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Комплектация Тогда
		
		УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(ТаблицаПоКомплектующим, Отказ, , НСтр("ru='Комплектация';uk='Комплектація'",Локализация.КодЯзыкаИнформационнойБазы()));
		
	Иначе
		
		УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(ТаблицаПоКомплектующим, Отказ, , НСтр("ru='Разукомплектация';uk='Розукомплектація'",Локализация.КодЯзыкаИнформационнойБазы()));
		
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()



// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015", УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС", 			УчетнаяПолитика.ПлательщикНДС(Организация, Дата));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт
	

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = НСтр("ru='Проведение документа ""';uk='Проведення документа ""'") + СокрЛП(Ссылка) + """: ";
	
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	СтруктураШапкиДокумента.Вставить("ТипСклада",ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад,"ТипСклада"));
	СтруктураШапкиДокумента.Вставить("Услуга",ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"Услуга"));
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоКомплектующим, ТаблицаПоКомплектам, Отказ, Заголовок) Экспорт
	
	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"                 , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"                       , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Количество"                   , "Количество * Коэффициент");
	СтруктураПолей.Вставить("НомерСтроки"                  , "НомерСтроки");
	СтруктураПолей.Вставить("ДоляСтоимости"                , "ДоляСтоимости");
	
	ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл(СтруктураПолей, СтруктураШапкиДокумента);

	РезультатЗапросаПоКомплектующим = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Комплектующие", СтруктураПолей);

	// Подготовим таблицы для проведения.
	ТаблицаПоКомплектующим = ПодготовитьТаблицуКомплектующих(РезультатЗапросаПоКомплектующим, СтруктураШапкиДокумента);
	ТаблицаПоКомплектам    = ПодготовитьТаблицуКомплектов(ТаблицаПоКомплектующим, СтруктураШапкиДокумента);;
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Движения по документу
	СпособОценкиМПЗ = УчетнаяПолитика.СпособОценкиМПЗ(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата);
	ПартионныйУчетБУ = (СпособОценкиМПЗ = Перечисления.СпособыОценки.ФИФО) ИЛИ (СпособОценкиМПЗ = Перечисления.СпособыОценки.ЛИФО);
	
	ТаблицаПоКомплектующим.Колонки.Добавить("НоменклатураНовая");
	
	ТаблицаПоКомплектующим.Колонки.Добавить("КоличествоПоступление", ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15,3));
	// Проведение по партиям остановим в том случае, если не хватит хоть одного комплектующего.
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Комплектация Тогда
		
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСчетСписанияБУ");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ1");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ2");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ3");
		
		ТаблицаПоКомплектующим.Колонки.Добавить("КоличествоДт");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(?(ТаблицаПоКомплектующим.Количество() = 0, 0, Окр(ТаблицаПоКомплектам[0].Количество/ТаблицаПоКомплектующим.Количество(),3, 1)), "КоличествоДт");
		Если ТаблицаПоКомплектам[0].Количество <> ТаблицаПоКомплектующим.Итог("КоличествоДт") Тогда
			ТаблицаПоКомплектующим[0].КоличествоДт = ТаблицаПоКомплектующим[0].КоличествоДт + (ТаблицаПоКомплектам[0].Количество - ТаблицаПоКомплектующим.Итог("КоличествоДт"));
		КонецЕсли;
		
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].СчетУчетаБУ, 	"КорСчетСписанияБУ");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].Номенклатура, 	"КорСубконтоСписанияБУ1");
		
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].Номенклатура, 	"НоменклатураНовая");
		
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, 		"КорСубконтоСписанияБУ2");
		Если ПартионныйУчетБУ Тогда
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, 	"КорСубконтоСписанияБУ3");
		КонецЕсли;
		
	Иначе
		
		ТаблицаПоКомплектующим.ЗагрузитьКолонку(ТаблицаПоКомплектующим.ВыгрузитьКолонку("Номенклатура"),"НоменклатураНовая");
		
		ТаблицаПоКомплектующим.Колонки.СчетУчетаБУ.Имя = 	"КорСчетСписанияБУ";
		ТаблицаПоКомплектующим.Колонки.Номенклатура.Имя = 	"КорСубконтоСписанияБУ1";
		ТаблицаПоКомплектующим.Колонки.Количество.Имя = 	"КоличествоДт";
		
		ТаблицаПоКомплектующим.Колонки.Добавить("СчетУчетаБУ");
		ТаблицаПоКомплектующим.Колонки.Добавить("Номенклатура");
		
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ2");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ3");
		
		ТаблицаПоКомплектующим.Колонки.Добавить("Количество");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(0, "Количество");
		
		Если ТаблицаПоКомплектующим.Итог("ДоляСтоимости") = 0 Тогда
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(1, "ДоляСтоимости");
		КонецЕсли;
		
		КоэффДоли = ?(ТаблицаПоКомплектующим.Итог("ДоляСтоимости") = 0, 0, ТаблицаПоКомплектам[0].Количество / (ТаблицаПоКомплектующим.Итог("ДоляСтоимости")));
		
		Для Каждого Строка Из ТаблицаПоКомплектующим Цикл
			Строка.Количество = Окр(КоэффДоли * Строка.ДоляСтоимости, 3, 1);
		КонецЦикла;
		
		Если ТаблицаПоКомплектам[0].Количество <> ТаблицаПоКомплектующим.Итог("Количество") Тогда
			ТаблицаПоКомплектующим[0].Количество = ТаблицаПоКомплектующим[0].Количество + (ТаблицаПоКомплектам[0].Количество - ТаблицаПоКомплектующим.Итог("Количество"));
		КонецЕсли;
				
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].СчетУчетаБУ, 	"СчетУчетаБУ");
		
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].Номенклатура, 	"Номенклатура");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, 		"КорСубконтоСписанияБУ2");
		Если ПартионныйУчетБУ Тогда
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, 	"КорСубконтоСписанияБУ3");
		КонецЕсли;
		
	КонецЕсли;
	
	ТаблицаПоКомплектующим.ЗагрузитьКолонку(ТаблицаПоКомплектующим.ВыгрузитьКолонку("КоличествоДт"),"КоличествоПоступление");
	
	
КонецПроцедуры // СформироватьТаблицыДокумента()

#КонецОбласти 


#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоКомплектующим, ТаблицаПоКомплектам;
	
	// Проверка ручной корректировки
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
		
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоКомплектующим, ТаблицаПоКомплектам, Отказ, Заголовок);
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоКомплектующим, ТаблицаПоКомплектам, Отказ, Заголовок);
	КонецЕсли;

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
КонецПроцедуры	// ОбработкаПроведения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	Если НЕ УчетнаяПолитика.ПлательщикНДС(Организация, НачалоМесяца(Дата)) Тогда
		// организация - не плательщик НДС. Установим во всех ТЧ признак соответствующего учета НДС
		НеОБлНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		
		НалоговоеНазначение = НеОБлНДСДеятельность;

	КонецЕсли;
	
	// Посчитать суммы документа 
	РасчетСуммДокумента();

КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
			
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Заголовок, СтруктураШапкиДокумента;

	МассивНепроверяемыхРеквизитов = Новый Массив();
		
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);

	Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалоговоеНазначение");
	КонецЕсли;
	
	// Комплектуемая номенклатура не может быть услугой или набором
	Если СтруктураШапкиДокумента.Услуга Тогда
		СообщенияОбОшибке = НСтр("ru='Комплектуемая номенклатура не может быть услугой!';uk='Номенклатура, що комплектуэться, не може бути послугою!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщенияОбОшибке, ЭтотОбъект, "Номенклатура", "Объект", Отказ);
	КонецЕсли;

	// Вид склада
	Если СтруктураШапкиДокумента.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
		СообщенияОбОшибке = НСтр("ru='Комплектация номенклатуры не может проводится на НТТ!';uk='Комплектація номенклатури не може проводитися на НТТ!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщенияОбОшибке, ЭтотОбъект, "Склад", "Объект", Отказ);
	КонецЕсли;

	// Укажем, что надо проверить:
	Если ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Комплектация Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Комплектующие.ДоляСтоимости");
	КонецЕсли;

	Если Комплектующие.Количество() = 0 Тогда
		СообщенияОбОшибке = НСтр("ru='Не заполнена табличная часть ""Комплектующие"".';uk='Не заповнена таблична частина ""Комплектуючі"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщенияОбОшибке, ЭтотОбъект, "Комплектующие", "Объект", Отказ);
	Иначе 	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТЗ_Комплектующие",Комплектующие.Выгрузить(,"НомерСтроки,Номенклатура"));
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Комплектующие.НомерСтроки,
		|	Комплектующие.Номенклатура
		|ПОМЕСТИТЬ ВТ_Комплектущие
		|ИЗ
		|	&ТЗ_Комплектующие КАК Комплектующие"+ 
		";"+
		"ВЫБРАТЬ
		|	ВТ_Комплектущие.Номенклатура.Услуга КАК Услуга,
		|	ВТ_Комплектущие.НомерСтроки,
		|	ВТ_Комплектущие.Номенклатура
		|ИЗ
		|	ВТ_Комплектущие КАК ВТ_Комплектущие";
		
		ТаблицаПоКомплектующим = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецОбласти 

#КонецЕсли

