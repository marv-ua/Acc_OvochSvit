﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	СрокОплатыПокупателей = Константы.СрокОплатыПокупателей.Получить();
	СрокОплатыПоставщикам = Константы.СрокОплатыПоставщикам.Получить();

	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	Если Параметры.Свойство("ОткрытИзПлатежки") Тогда
		Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
	КонецЕсли;
	
	// Ограничение списка выбора поля "Вид договора"
	
	Если Параметры.Свойство("ВидДоговораДоступныеЗначения") Тогда
		Элементы.ВидДоговора.РежимВыбораИзСписка = Истина;
		Элементы.ВидДоговора.СписокВыбора.ЗагрузитьЗначения(Параметры.ВидДоговораДоступныеЗначения);
	КонецЕсли;

	ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(ЭтаФорма);

	РеквизитыДоговора = ПолучитьСтрокуРеквизитовДоговора(Объект.Номер, Объект.Дата);
	
	УправлениеФормой(ЭтаФорма);

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);

	Если Не Отказ И Объект.Ссылка.Пустая() Тогда
		
		СохраняемыеЗначенияРеквизитов = Новый Структура(
			"ВедениеВзаиморасчетов,ВедениеВзаиморасчетовНУ,ВалютаВзаиморасчетов,СложныйНалоговыйУчет,
			|ВидДеятельностиДляДДС,СхемаНалоговогоУчета,СхемаНалоговогоУчетаПоТаре,МногостороннееСоглашениеОРазделеПродукции");	
		ЗаполнитьЗначенияСвойств(СохраняемыеЗначенияРеквизитов, Объект);
		
		ХранилищеОбщихНастроек.Сохранить("ДоговорыКонтрагентов_СохраняемыеЗначенияРеквизитов",, СохраняемыеЗначенияРеквизитов);	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура("Ссылка, Владелец", Объект.Ссылка, Объект.Владелец);
	
	Оповестить("ИзмененДоговорКонтрагента", ПараметрОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// Подсистема "Свойства"
	Если ИмяСобытия = "ЗаписанаНоваяСхемаУчета" Тогда
		Объект.СхемаНалоговогоУчета = Параметр
	ИначеЕсли УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.НаименованиеДляПечати) Тогда
		Объект.НаименованиеДляПечати = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	СформироватьНаименованиеДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	СформироватьНаименованиеДоговора();
	
	// Test{20230918
	Объект.а_ДатаОкончания = Объект.Дата + 24*60*60*180;
	// Test}
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)

	Если НЕ ЗначениеЗаполнено(Объект.ВидДоговора)
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее")) Тогда
		Объект.ТипЦен = Неопределено;
		Объект.СпособРасчетаКомиссионногоВознаграждения = Неопределено;
		Объект.ПроцентКомиссионногоВознаграждения = 0;
		Объект.УстановленСрокОплаты = Ложь;
		Объект.СрокОплаты = 0;
		Объект.СложныйНалоговыйУчет = Истина;
		УстановитьВедениеВзаиморасчетовНУ();
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ВидДоговора)
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"))
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Бартерный")) Тогда
		Если Объект.ВедениеВзаиморасчетов = ПредопределенноеЗначение("Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам") Тогда
			Объект.ВедениеВзаиморасчетов = ПредопределенноеЗначение("Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом");
			УстановитьВедениеВзаиморасчетовНУ();
		КонецЕсли;
	КонецЕсли;

	ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(ЭтаФорма);
	Если ЗначениеЗаполнено(Объект.СпособРасчетаКомиссионногоВознаграждения) Тогда
		Если Элементы.СпособРасчетаКомиссионногоВознаграждения.СписокВыбора.НайтиПоЗначению(Объект.СпособРасчетаКомиссионногоВознаграждения) = Неопределено Тогда
			Объект.СпособРасчетаКомиссионногоВознаграждения = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
    УстановитьСхемуНалогообложения();
	
	УстановитьРеквизитыНалоговыхДокументов();
	
	УправлениеФормой(ЭтаФорма);

	//Возможна ситуация, когда, например, ВедениеВзаиморасчетовНУ = ПоРасчетнымДокументам, а при изменении на вид договора СКомиссионером или СКомитентом
	//он должен измениться на ПоДоговоруВЦелом (в целом не относится в этому ООП, но создавать другой смысла не вижу)
	УстановитьВедениеВзаиморасчетовНУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УстановленСрокОплатыПриИзменении(Элемент)

	Если Объект.УстановленСрокОплаты Тогда
		Если (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером")) Тогда
			Объект.СрокОплаты = СрокОплатыПокупателей;
		ИначеЕсли (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом")) Тогда
			Объект.СрокОплаты = СрокОплатыПоставщикам;
		КонецЕсли;
	Иначе
		СрокОплаты = 0;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);

КонецПроцедуры

&НаКлиенте
Процедура ВедениеВзаиморасчетовПриИзменении(Элемент)
	
	УстановитьВедениеВзаиморасчетовНУ();
		
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СложныйНалоговыйУчетПриИзменении(Элемент)
	
	УстановитьВедениеВзаиморасчетовНУ();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеСхемыУчета(Команда)
	
	ПараметрыФормы	= Новый Структура(
		"ТекущаяСтрока, ПараметрВыборГруппИЭлементов",
		Объект.СхемаНалоговогоУчета, ИспользованиеГруппИЭлементов.Элементы);
		
	ОткрытьФорму("Справочник.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ФормаВыбора", ПараметрыФормы, Элементы.СхемаНалоговогоУчета)	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	ВалютаРегламентированногоУчета = Форма.ВалютаРегламентированногоУчета;

	ЭтоДоговорКомиссии     = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));
		
	ЭтоДоговорПриобретения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));
		
	ЭтоДоговорРеализации   = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"));
	
	ДоступностьКомиссионногоВознаграждения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));
		
	//Группа "Ведение взаиморасчетов"

	Элементы.УстановленСрокОплаты.Доступность = (Объект.ВидДоговора <> ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));

	Если Объект.УстановленСрокОплаты Тогда
		Элементы.ГруппаСтраницыСрокОплаты.ТекущаяСтраница = Элементы.ГруппаСрокОплатыУстановлен;
	Иначе
		Элементы.ГруппаСтраницыСрокОплаты.ТекущаяСтраница = Элементы.ГруппаСрокОплатыНеУстановлен;
	КонецЕсли;
	
	Если (ЭтоДоговорРеализации Или ЭтоДоговорПриобретения) Тогда
		Элементы.ВедениеВзаиморасчетов.Доступность = Истина;
	Иначе
		Элементы.ВедениеВзаиморасчетов.Доступность	= Ложь;
	КонецЕсли;
	
	Элементы.ВедениеВзаиморасчетовНУ.Доступность = НЕ Объект.СложныйНалоговыйУчет И Объект.ВедениеВзаиморасчетов = ПредопределенноеЗначение("Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам");
	
	//Группа "Комиссионное вознаграждение"

	Элементы.ГруппаКомиссионноеВознаграждение.Доступность = ДоступностьКомиссионногоВознаграждения;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста                                       
Процедура ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;


	СписокСпособов = ОбщегоНазначенияБПКлиентСервер.СформироватьСписокСпособовРасчетаКомиссионногоВознаграждения();
	СписокВыбора = Элементы.СпособРасчетаКомиссионногоВознаграждения.СписокВыбора;
	СписокВыбора.Очистить();
	Для Каждого ЭлементСписка Из СписокСпособов Цикл
		СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСтрокуРеквизитовДоговора(Номер, Дата)
	
	НомерДоговора = ?(ЗначениеЗаполнено(Номер), Номер, "");
	
	ДатаДоговора = ?(ЗначениеЗаполнено(Дата), НСтр("ru='от ';uk='від '",Локализация.КодЯзыкаИнформационнойБазы()) + Формат(Дата, "ДФ=dd.MM.yyyy"), "");
	
	Возврат НомерДоговора + ?(ПустаяСтрока(НомерДоговора), "", " ") + ДатаДоговора;
	
КонецФункции

&НаКлиенте
Процедура СформироватьНаименованиеДоговора()
	
	ТекстНаименования = Объект.Наименование;
	
	НовыеРеквизитыДоговора = ПолучитьСтрокуРеквизитовДоговора(Объект.Номер, Объект.Дата); 
	
	Если ПустаяСтрока(ТекстНаименования) Тогда
		ТекстНаименования = НовыеРеквизитыДоговора;
	ИначеЕсли Найти(ТекстНаименования, РеквизитыДоговора) > 0 Тогда
		ТекстНаименования = СтрЗаменить(ТекстНаименования, РеквизитыДоговора, НовыеРеквизитыДоговора);
	КонецЕсли;
	
	РеквизитыДоговора = НовыеРеквизитыДоговора;
	
	Если (Не ЗначениеЗаполнено(Объект.НаименованиеДляПечати)) ИЛИ (Объект.НаименованиеДляПечати = Объект.Наименование) Тогда
		Объект.НаименованиеДляПечати = ТекстНаименования;
	КонецЕсли;
	
	Объект.Наименование = ТекстНаименования;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВедениеВзаиморасчетовНУ()

	Если Объект.СложныйНалоговыйУчет  Тогда
		
		Объект.ВедениеВзаиморасчетовНУ = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом
		
	Иначе
		
		Объект.ВедениеВзаиморасчетовНУ = Объект.ВедениеВзаиморасчетов;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСхемуНалогообложения()
	
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
		//СхемаНалоговогоУчета = Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомиссионером;
		Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомиссионером_НК;
		Объект.СложныйНалоговыйУчет = Истина;
	ИначеЕсли Объект.ВидДоговора =  Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
		//СхемаНалоговогоУчета = Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомитентом;
		Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомитентом_НК;
		Объект.СложныйНалоговыйУчет = Истина;
	ИначеЕсли Объект.ВидДоговора =  Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.Бартер;
	Иначе
		Если Не Объект.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
			Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ВЭД;		
		Иначе	
			Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ПоПервомуСобытию;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРеквизитыНалоговыхДокументов()
	
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Бартер;
	ИначеЕсли Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером
		  ИЛИ Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
	    Объект.ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Комиссия;
	Иначе
		Объект.ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Поставка;
	КонецЕсли;	
	
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.ФормаРасчетов = "Бартер";  	
	Иначе		
		Объект.ФормаРасчетов = "Оплата з поточного рахунка";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПодсистемыСвойств

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

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