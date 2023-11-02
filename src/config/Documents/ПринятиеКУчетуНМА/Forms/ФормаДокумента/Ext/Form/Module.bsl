﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.СоставКомиссий.Форма.ФормаВыбора" Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
		УстановитьСостояниеДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		ВидОперацииПриИзмененииСервер();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	УстановитьВидНалоговойДеятельностиНМА();
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
	
КонецПроцедуры

// Закладка "Учетные данные"

&НаКлиенте
Процедура НачислятьАмортизациюБУПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУПриИзменении(Элемент)
	
	Если Объект.Дата >= Дата('20200401') Тогда
		Объект.СпособНачисленияАмортизацииНУ = Объект.СпособНачисленияАмортизацииБУ;
	ИначеЕсли Объект.СпособНачисленияАмортизацииБУ <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Производственный") Тогда
		Объект.СпособНачисленияАмортизацииНУ = Объект.СпособНачисленияАмортизацииБУ;
	Иначе	
		Объект.СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Прямолинейный");
	КонецЕсли;	
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СписокБУ = ПолучитьСписокСпособовАмортизацииБУ();
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокБУ.ВыгрузитьЗначения());
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииНУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СписокНУ = ПолучитьСписокСпособовАмортизацииНУ();
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокНУ.ВыгрузитьЗначения());
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииНУПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПолезногоИспользованияБУПриИзменении(Элемент)
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(ЭтаФорма);
	
	Объект.СрокПолезногоИспользованияНУ = Объект.СрокПолезногоИспользованияБУ;
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПолезногоИспользованияНУПриИзменении(Элемент)
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	УправлениеНеоборотнымиАктивами.УстановитьНалоговуюГруппуНМА(Объект.СчетУчетаБУ, Объект.НалоговаяГруппаОС);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РассчитатьСтоимостьБУ(Команда)
	
	Если Объект.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Заполнение возможно только в непроведенном документе';uk='Заповнення можливе тільки в непроведеному документі'"), 60); 
		Возврат;
	КонецЕсли;

	Если Не Объект.СтоимостьБУ = 0 ИЛИ Не Объект.СтоимостьНУ = 0 Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("РассчитатьСтоимостьБУЗавершение", ЭтотОбъект), НСтр("ru='Пересчитать стоимость нематериального актива?';uk='Перерахувати вартість нематеріального активу?'"), 
		               РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, );
        Возврат;
	
	КонецЕсли;
	
	РассчитатьСтоимостьБУФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСтоимостьБУЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    РассчитатьСтоимостьБУФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСтоимостьБУФрагмент()
    
    ОчиститьСообщения();
    
    РассчитатьСтоимостьБУНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСоставКомиссии(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Объект.Организация));
	ОткрытьФорму("РегистрСведений.СоставКомиссий.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСписокСпособовНачисленияАмортизации()
	
	Список = ПолучитьСписокСпособовАмортизацииБУ();
	Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора.ЗагрузитьЗначения(Список.ВыгрузитьЗначения());
	
	СписокНУ = ПолучитьСписокСпособовАмортизацииНУ();
	Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора.ЗагрузитьЗначения(СписокНУ.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
// Функция возвращает список значений доступных способов амортизации для бух. учета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   СписокЗначений
//
Функция ПолучитьСписокСпособовАмортизацииБУ() 
                                                                                                        
	СписокПеречисления = Новый СписокЗначений;
	
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Прямолинейный);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Производственный);
    СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УменьшенияОстатка);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УскоренногоУменьшенияОстатка);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Кумулятивный);
	
	Возврат СписокПеречисления;

КонецФункции // ПолучитьСписокСпособовАмортизацииБУ()

&НаСервере
// Функция возвращает список значений доступных способов амортизации для бух. учета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   СписокЗначений
//
Функция ПолучитьСписокСпособовАмортизацииНУ()
                                                                                                        
	СписокПеречисления = Новый СписокЗначений;
	
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Прямолинейный);
	
	Если Объект.Дата >= Дата('20200401') 
			И Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Производственный Тогда
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Производственный);	
	КонецЕсли; 
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УменьшенияОстатка);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УскоренногоУменьшенияОстатка);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Кумулятивный);
		
	Возврат СписокПеречисления;

КонецФункции // ПолучитьСписокСпособовАмортизацииБУ()

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьСчетаУчета();
	КонецЕсли;
	
	УстановитьВидНалоговойДеятельностиНМА();
	
	УстановитьСписокСпособовНачисленияАмортизации();
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
КонецПроцедуры

&НаСервере
Процедура УстановитьВидНалоговойДеятельностиНМА()

	ВидНалоговойДеятельностиНМА = Объект.НематериальныйАктив.НалоговоеНазначение.ВидНалоговойДеятельности;

КонецПроцедуры 

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПлательщикНалогаНаПрибыль 	= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ПлательщикНДС 				= УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	// Зависимость видимости полей от НачислятьАмортизациюБУ
	Если Объект.НачислятьАмортизациюБУ Тогда
		Элементы.СтраницыБУНачислениеАмортизации.ТекущаяСтраница = Элементы.СтраницаБУНачислениеАмортизации;
	Иначе
		Элементы.СтраницыБУНачислениеАмортизации.ТекущаяСтраница = Элементы.СтраницаБУНачислениеАмортизацииЧистая;
	КонецЕсли;
	
	ДатаНКУ2015 = '2015 01 01';
	ЭтоДокументДо2015 = (Объект.Дата < ДатаНКУ2015);
	
	НачислятьАмортизациюБУ = Объект.НачислятьАмортизациюБУ; 
	
	Элементы.ОбъектСтроительства.Видимость = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуНМА.ОбъектыСтроительства"));
	
	ЭтоВводНачальныхОстатков = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуНМА.ВводНачальныхОстатков"));
	
	Элементы.СчетУчетаБУВнеоборотногоАктива.Видимость = (Не ЭтоВводНачальныхОстатков);
	
	// Бухгалтерский учет
	ПроизводственныйСпособНачисления 	= (Объект.СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Производственный"))
	                                    	И НачислятьАмортизациюБУ;
	ПроизводственныйСпособНачисленияНУ	= (Объект.СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Производственный"))
	                                    	И НачислятьАмортизациюБУ;
										
	Элементы.СрокПолезногоИспользованияБУ.Видимость = НачислятьАмортизациюБУ И (НЕ ПроизводственныйСпособНачисления);
	Элементы.РасшифровкаСрокаПолезногоИспользованияБУ.Видимость = НачислятьАмортизациюБУ И (НЕ ПроизводственныйСпособНачисления);
	Элементы.ЛиквидационнаяСтоимостьБУ.Видимость = НачислятьАмортизациюБУ И (НЕ ПроизводственныйСпособНачисления);
	
	Элементы.ЛиквидационнаяСтоимостьБУ.ОтметкаНезаполненного = НачислятьАмортизациюБУ и (Объект.ЛиквидационнаяСтоимостьБУ = 0)
	                                                                    и (Объект.СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.УменьшенияОстатка"));
																		
	Элементы.СчетНачисленияАмортизацииБУ.Видимость               	= НачислятьАмортизациюБУ;
	Элементы.СпособНачисленияАмортизацииБУ.Видимость             	= НачислятьАмортизациюБУ;
	Элементы.ОбъемПродукцииРаботДляВычисленияАмортизации.Видимость 	= ПроизводственныйСпособНачисления;
																		
	// Налоговый учет
	ВидНалоговойДеятельностиНеОблагаемая = ПредопределенноеЗначение("Справочник.ВидыНалоговойДеятельности.НеОблагаемая");
	
	ВидимостьНалоговыхРеквизитов = Форма.ПлательщикНалогаНаПрибыль;
	ПроизводственныйАктив        = Форма.ВидНалоговойДеятельностиНМА <> ВидНалоговойДеятельностиНеОблагаемая;
	
	Элементы.СпособНачисленияАмортизацииНУ.Видимость 			= НачислятьАмортизациюБУ И НЕ ЭтоДокументДо2015;
	
	Элементы.СтоимостьНУ.Видимость                         		= ВидимостьНалоговыхРеквизитов И (ЭтоДокументДо2015 ИЛИ ЭтоВводНачальныхОстатков);
	
	Если ЭтоДокументДо2015 ИЛИ ЭтоВводНачальныхОстатков Тогда
		Элементы.СтоимостьБУ.Заголовок = НСтр("ru='Первоначальная стоимость (БУ):';uk='Первісна вартість (БО):'");
		Элементы.СпособНачисленияАмортизацииБУ.Заголовок = НСтр("ru='Способ начисления:';uk='Спосіб нарахування:'");
	Иначе
		Элементы.СтоимостьБУ.Заголовок = НСтр("ru='Первоначальная стоимость:';uk='Первісна вартість:'");
		Элементы.СпособНачисленияАмортизацииБУ.Заголовок = НСтр("ru='Способ начисления (БУ):';uk='Спосіб нарахування (БО):'");
	КонецЕсли;	
	
	Элементы.СрокПолезногоИспользованияНУ.Видимость        		= ВидимостьНалоговыхРеквизитов И (НЕ ПроизводственныйСпособНачисленияНУ);
	Элементы.РасшифровкаСрокаПолезногоИспользованияНУ.Видимость = ВидимостьНалоговыхРеквизитов И (НЕ ПроизводственныйСпособНачисленияНУ);
	
	Элементы.НалоговаяГруппаОС.Видимость                   		= НачислятьАмортизациюБУ;
	
	// Ввод начальных остатков
	Элементы.РассчитатьСтоимостьБУ.Видимость 	= НЕ ЭтоВводНачальныхОстатков;
	Элементы.НакопленнаяАмортизацияБУ.Видимость = ЭтоВводНачальныхОстатков;
	Элементы.НакопленнаяАмортизацияНУ.Видимость = ВидимостьНалоговыхРеквизитов и ЭтоВводНачальныхОстатков 
	                                                          и ПроизводственныйАктив;
	
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(Форма);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчета()
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуНМА.ОбъектыСтроительства Тогда
		Объект.СчетУчетаБУВнеоборотногоАктива = ПланыСчетов.Хозрасчетный.ИзготовлениеНематериальныхАктивов;
	Иначе
		Объект.СчетУчетаБУВнеоборотногоАктива = ПланыСчетов.Хозрасчетный.ПриобретениеНематериальныхАктивов;
	КонецЕсли;
	
	Объект.СчетУчетаБУ                    = ПланыСчетов.Хозрасчетный.ДругиеНематериальныеАктивы;
	Объект.СчетНачисленияАмортизацииБУ    = ПланыСчетов.Хозрасчетный.НакопленнаяАмортизацияНематериальныхАктивов;
	
	УправлениеНеоборотнымиАктивами.УстановитьНалоговуюГруппуНМА(Объект.СчетУчетаБУ, Объект.НалоговаяГруппаОС);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСтоимостьБУНаСервере();
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация", Отказ);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.СчетУчетаБУВнеоборотногоАктива) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Счет учета внеоборотного актива';uk='Рахунок обліку внеоборотного активу'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.СчетУчетаБУВнеоборотногоАктива", , Отказ);
	КонецЕсли;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуНМА.ОбъектыСтроительства И НЕ ЗначениеЗаполнено(Объект.ОбъектСтроительства) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Объект строительства';uk=""Об'єкт будівництва"""));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОбъектСтроительства", , Отказ);
	КонецЕсли;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуНМА.НематериальныеАктивы И НЕ ЗначениеЗаполнено(Объект.НематериальныйАктив) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Нематериальный актив';uk='Нематеріальний актив'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.НематериальныйАктив", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НаДату = ?(Параметры.Ключ.Пустая(), КонецДня(Объект.Дата), Объект.Дата);
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуНМА.НематериальныеАктивы Тогда
		
		МассивСубконто = Новый Массив(1);
		МассивСубконто[0] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НематериальныеАктивы;
				
		СтруктураОтбора = Новый Структура("Счет, Субконто1, Организация");
		СтруктураОтбора.Счет 		= Объект.СчетУчетаБУВнеоборотногоАктива;
		
		СтруктураОтбора.Субконто1 	= Объект.НематериальныйАктив;
		
		СтруктураОтбора.Организация	= Объект.Организация;
				
		ТаблицаОстатков	= РегистрыБухгалтерии.Хозрасчетный.Остатки(НаДату, МассивСубконто, СтруктураОтбора);
				
		Объект.СтоимостьБУ = ТаблицаОстатков.Итог("СуммаОстатокДт");
		Объект.СтоимостьНУ = ТаблицаОстатков.Итог("СуммаНУОстатокДт");
		
	Иначе	
	
		СтруктураСтоимости = УправлениеНеоборотнымиАктивами.РасчитатьСтоимостьОбъектаСтроительства(Объект.СчетУчетаБУВнеоборотногоАктива, 
																	Объект.ОбъектСтроительства, 
																	Объект.Организация,  
																	НаДату);

		Объект.СтоимостьБУ    = СтруктураСтоимости.СтоимостьБУ;
		Объект.СтоимостьНУ    = СтруктураСтоимости.СтоимостьНУ;
		
	КонецЕсли;	
	
	ДатаНКУ2015 = '2015 01 01';
	
	Если Объект.Дата >= ДатаНКУ2015 Тогда
		// для документов 2015 года СтоимостьНУ = СтоимостьБУ  
		Объект.СтоимостьНУ = Объект.СтоимостьБУ;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()

	УстановитьФункциональныеОпцииФормы();
   	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	УстановитьФункциональныеОпцииФормы();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииСервер()
	
	ЗаполнитьСчетаУчета();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(Форма)
	
	Форма.РасшифровкаСрокаПолезногоИспользованияБУ = 
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(
		Форма.Объект.СрокПолезногоИспользованияБУ);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(Форма)
	
	Форма.РасшифровкаСрокаПолезногоИспользованияНУ = 
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(
		Форма.Объект.СрокПолезногоИспользованияНУ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти