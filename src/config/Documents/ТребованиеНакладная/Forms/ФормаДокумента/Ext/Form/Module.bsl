﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		УстановитьСостояниеДокумента();
	КонецЕсли;
	
	// Активизировать первую непустую табличную часть
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокТабличныхЧастей.Добавить("Материалы",				"Материалы");
	СписокТабличныхЧастей.Добавить("МатериалыЗаказчика",	"МатериалыЗаказчика");
	
	АктивизироватьТабличнуюЧасть = ОбщегоНазначенияБПВызовСервера.ПолучитьПервуюНепустуюВидимуюТабличнуюЧасть(
		ЭтаФорма, СписокТабличныхЧастей);
	ОбщегоНазначенияБПВызовСервера.АктивизироватьЭлементФормы(ЭтаФорма, АктивизироватьТабличнуюЧасть);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ДанныеСкопированыВБуферОбмена" Тогда
		
		УстановитьДоступностьКомандыВставки(ЭтотОбъект, Истина);

	Иначе	
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;

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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	УстановитьСостояниеДокумента();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьДобавленныеКолонкиТаблиц();
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
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СчетаУчетаЗатратВТаблицеПриИзменении(Элемент)

	Если Объект.Материалы.Количество() > 0 Тогда
		ТекстВопроса	= НСтр("ru='Заполнить статьи затрат в списке ""Материалы"" значениями по умолчанию?';uk='Заповнити статті витрат у списку ""Матеріали"" значеннями по умовчанню?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗаполнениемТабличнойЧастиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Заголовок);
	Иначе
		СчетаУчетаЗатратВТаблицеПриИзмененииНаСервере(Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратПриИзменении(Элемент)

	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетЗатрат, "", Истина);
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1", "Субконто2", "Субконто3");
	ПоляОбъекта.Вставить("Подразделение", Объект.ПодразделениеОрганизации);
	ПоляОбъекта.Вставить("Организация", Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатрат, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "", "СчетЗатрат");
	
	ПроверитьНалоговоеНазначениеДоходовИЗатрат();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоПриИзменении(Элемент)

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "", "СчетЗатрат");
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СписокПараметров = СписокПараметровВыбораСубконто(ЭтаФорма, Объект, "Субконто%Индекс%", "СчетЗатрат");
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, СписокПараметров);

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыОборудованиеМатериалы

&НаКлиенте
Процедура МатериалыПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, ЕдиницаИзмерения, Коэффициент, Количество,
		|Счет, НалоговоеНазначение,
		|НоменклатурнаяГруппа, СчетЗатрат, СтатьяЗатрат, НалоговоеНазначениеДоходовИЗатратТекст, НалоговоеНазначениеДоходовИЗатратТолькоПросмотр, НоменклатурнаяГруппаВыделятьНезаполненное");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, ПодразделениеОрганизации, СчетаУчетаЗатратВТаблице, ПлательщикНДС");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ПлательщикНДС = ПараметрыОбъекта.ПлательщикНДС;
	
	МатериалПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыЕдиницаИзмеренияПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, ЕдиницаИзмерения, Коэффициент");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	ЕдиницаИзмеренияПриИзмененииНаСервере(ДанныеСтрокиТаблицы, "Материалы");
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыДокументОприходованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Перем ПараметрыОбъекта;
	
	СтандартнаяОбработка	= Ложь;
	
	ТекущиеДанные	= Элементы.Материалы.ТекущиеДанные;
	
	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("КонецПериода",	Объект.Дата);
	ПараметрыОбъекта.Вставить("Организация",	Объект.Организация);
	ПараметрыОбъекта.Вставить("Номенклатура",	ТекущиеДанные.Номенклатура);
	ПараметрыОбъекта.Вставить("СчетУчета",		ТекущиеДанные.Счет);
	ПараметрыОбъекта.Вставить("Склад",			Объект.Склад);
	ПараметрыОбъекта.Вставить("ТипыДокументов",	"Метаданные.Документы.ТребованиеНакладная.ТабличныеЧасти.Материалы.Реквизиты.ДокументОприходования.Тип");
	
	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	ОткрытьФорму("Документ.Партия.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыДокументОприходованияПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ДокументОприходования) Тогда
		ТекущиеДанные.Себестоимость = 0;
		ТекущиеДанные.СебестоимостьНУ = 0;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура МатериалыСчетЗатратПриИзменении(Элемент)

	ТекущиеДанные	= Элементы.Материалы.ТекущиеДанные;
	
	ДанныеСтроки = Новый Структура("СчетЗатрат, НоменклатурнаяГруппа, НалоговоеНазначение, НалоговоеНазначениеДоходовИЗатратТекст, НалоговоеНазначениеДоходовИЗатратТолькоПросмотр,
		|ПодразделениеЗатратДоступность, НоменклатурнаяГруппаВыделятьНезаполненное");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущиеДанные);
	
	ЗаполнитьДобавленныеКолонкиСтрокиМатериалы(ДанныеСтроки, ПараметрыОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтроки);
	
	ДанныеСтроки = Новый Структура("СчетЗатрат, НалоговоеНазначениеДоходовИЗатрат");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущиеДанные);
	
	ПроверитьНалоговоеНазначениеДоходовИЗатратВСтроке(ДанныеСтроки, ПараметрыОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтроки);
	
	ПоляОбъекта = Новый Структура("Подразделение, ПодразделениеПоУмолчанию, Организация",
		"ПодразделениеЗатрат", Объект.ПодразделениеОрганизации, Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(ТекущиеДанные.СчетЗатрат, ТекущиеДанные, ПоляОбъекта, Истина);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатурнаяГруппаПриИзменении(Элемент)
	
	ТекущиеДанные	= Элементы.Материалы.ТекущиеДанные;
	
	ДанныеСтроки = Новый Структура("СчетЗатрат, НоменклатурнаяГруппа, НалоговоеНазначение, НалоговоеНазначениеДоходовИЗатратТекст, НалоговоеНазначениеДоходовИЗатратТолькоПросмотр, 
		|ПодразделениеЗатратДоступность, НоменклатурнаяГруппаВыделятьНезаполненное");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущиеДанные);
	
	ЗаполнитьДобавленныеКолонкиСтрокиМатериалы(ДанныеСтроки, ПараметрыОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтроки);

	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыМатериалыЗаказчика

&НаКлиенте
Процедура МатериалыЗаказчикаПриИзменении(Элемент)

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыЗаказчикаНоменклатураПриИзменении(Элемент)

	ТекущиеДанные	= Элементы.МатериалыЗаказчика.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, ЕдиницаИзмерения, Коэффициент, Количество,
		|Счет, СчетПередачи");
		
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, ПодразделениеОрганизации, СчетаУчетаЗатратВТаблице");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	МатериалЗаказчикаПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыЗаказчикаЕдиницаИзмеренияПриИзменении(Элемент)

	ТекущиеДанные = Элементы.МатериалыЗаказчика.ТекущиеДанные;
	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, ЕдиницаИзмерения, Коэффициент");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	ЕдиницаИзмеренияПриИзмененииНаСервере(ДанныеСтрокиТаблицы, "МатериалыЗаказчика");
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработкаПодбораМатериалы(Команда)

	ПараметрыПодбора = ПолучитьПараметрыПодбора("Материалы");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПодбораМатериалыЗаказчика(Команда)

	ПараметрыПодбора = ПолучитьПараметрыПодбора("МатериалыЗаказчика");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	ИмяТаблицы = ПолучитьИмяТекущейТабличнойЧасти();
	Если ПустаяСтрока(ИмяТаблицы) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	КоличествоСтрок = Элементы[ИмяТаблицы].ВыделенныеСтроки.Количество();
	Если КоличествоСтрок = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	СкопироватьСтрокиНаСервере(ИмяТаблицы);
	ОбработкаТабличныхЧастейКлиент.ОповеститьОКопированииСтрокВБуферОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	ИмяТаблицы = ПолучитьИмяТекущейТабличнойЧасти();
	Если ПустаяСтрока(ИмяТаблицы) Тогда
		
		Возврат;
		
	КонецЕсли;
	КоличествоСтрок = ВставитьСтрокиНаСервере(ИмяТаблицы);
	ОбработкаТабличныхЧастейКлиент.ОповеститьОВставкеСтрокИзБуфераОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ТекущаяДатаДокумента	= Объект.Дата;
	
	ВалютаРегламентированногоУчета	= Константы.ВалютаРегламентированногоУчета.Получить();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УправлениеВидимостью();
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетЗатрат, "", Истина);
	
	УправлениеФормой(ЭтаФорма);

	// Проверка буфера обмена на наличие скопированных строк
	УстановитьДоступностьКомандыВставки(ЭтотОбъект, Не ОбщегоНазначения.ПустойБуферОбмена());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;
	
	Форма.ОтмечатьПустойСчетЗатрат		= Объект.Материалы.Количество() > 0;
	Форма.ОтмечатьПустогоКонтрагента	= Объект.МатериалыЗаказчика.Количество() > 0;
	
	Элементы.ЗаголовокНалоговоеНазначениеЗатрат.Видимость = Форма.ПлательщикНалогаНаПрибыльДо2015;
	Элементы.ГруппаНалоговоеНазначениеДоходовИЗатрат.Видимость = Форма.ПлательщикНалогаНаПрибыльДо2015;
	Если Форма.ПлательщикНалогаНаПрибыльДо2015 Тогда
		ПоказатьНалоговоеНазначениеПроводки(Объект, Элементы, Форма.ПлательщикНДС);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()

	Элементы.СтраницаСчетЗатрат.Видимость = НЕ Объект.СчетаУчетаЗатратВТаблице;
	Элементы.ПодразделениеОрганизации.Видимость = Объект.СчетаУчетаЗатратВТаблице;

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПоказыватьСебестоимость	= (УчетнаяПолитика.СпособОценкиМПЗ(Объект.Организация, Объект.Дата) <>
		Перечисления.СпособыОценки.ПоСредней);
		
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);
	ПлательщикНалогаНаПрибыльДо2015 = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);
	ПараметрыОбъекта = Новый Структура("Дата, ПлательщикНДС", Объект.Дата, ПлательщикНДС);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	Для Каждого СтрокаТабЧасти Из Объект.Материалы Цикл
		ЗаполнитьДобавленныеКолонкиСтрокиМатериалы(СтрокаТабЧасти, ПараметрыОбъекта);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиМатериалы(СтрокаТабЧасти, ПараметрыОбъекта)

	СтрокаТабЧасти.НоменклатурнаяГруппаВыделятьНезаполненное	=
		БухгалтерскийУчетВызовСервераПовтИсп.НаСчетеВедетсяУчетПоНоменклатурнымГруппам(СтрокаТабЧасти.СчетЗатрат);
		
	ХарактерЗатрат = Неопределено;
	НалоговоеНазначениеАналитика = Неопределено;
	СтруктураСубконто = Новый Структура("Субконто1,Субконто2,Субконто3",СтрокаТабЧасти.НоменклатурнаяГруппа, Неопределено, Неопределено);
	НалоговыйУчет.ОпределениеАналитикиНалоговогоУчетаВПроводкахДляЗатрат(СтруктураСубконто, СтрокаТабЧасти.СчетЗатрат, ХарактерЗатрат,
													       	НалоговоеНазначениеАналитика, ,СтрокаТабЧасти.НалоговоеНазначение,,,ПараметрыОбъекта.Дата
															,,ПараметрыОбъекта.ПлательщикНДС
															);
	Если (ХарактерЗатрат = "Производство" ИЛИ ХарактерЗатрат = "Строительство" ИЛИ ХарактерЗатрат = "ТЗР" ИЛИ ХарактерЗатрат = "РБП" ИЛИ ХарактерЗатрат = "ОПЗ")  Тогда 
		СтрокаТабЧасти.НалоговоеНазначениеДоходовИЗатратТолькоПросмотр = Истина;
		СтрокаТабЧасти.НалоговоеНазначениеДоходовИЗатратТекст  = "<"+Строка(НалоговоеНазначениеАналитика)+">";
	Иначе
		СтрокаТабЧасти.НалоговоеНазначениеДоходовИЗатратТолькоПросмотр = Ложь;
		СтрокаТабЧасти.НалоговоеНазначениеДоходовИЗатратТекст  = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()

	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере(ИмяТабличнойЧасти = "")

	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Материалы" Тогда
		Документы.ТребованиеНакладная.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Материалы");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "МатериалыЗаказчика" Тогда
		Документы.ТребованиеНакладная.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "МатериалыЗаказчика");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СчетаУчетаЗатратВТаблицеПриИзмененииНаСервере(ЗаполнитьСтатьиЗатратЗначениямиПоУмолчанию)
	Перем НоменклатурнаяГруппа, СтатьяЗатрат;
	Перем ТаблицаСтатейЗатратНоменклатуры;
	
	Если Объект.СчетаУчетаЗатратВТаблице И Объект.Материалы.Количество() > 0 Тогда
		
		СвойстваСчетаЗатрат	= БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект.СчетЗатрат);
		Для Индекс = 1 По СвойстваСчетаЗатрат.КоличествоСубконто Цикл
			Если СвойстваСчетаЗатрат["ВидСубконто" + Индекс] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы Тогда
				НоменклатурнаяГруппа	= Объект["Субконто" + Индекс];
			ИначеЕсли СвойстваСчетаЗатрат["ВидСубконто" + Индекс] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат Тогда
				СтатьяЗатрат	= Объект["Субконто" + Индекс];
			КонецЕсли;
		КонецЦикла;
		
		Если ЗаполнитьСтатьиЗатратЗначениямиПоУмолчанию Тогда
			
			СписокНоменклатуры	= Объект.Материалы.Выгрузить(, "Номенклатура");
			СписокНоменклатуры	= ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(СписокНоменклатуры);
			
			Запрос	= Новый Запрос;
			Запрос.УстановитьПараметр("СписокНоменклатуры",	СписокНоменклатуры);
			Запрос.Текст	=
			"ВЫБРАТЬ
			|	Номенклатура.Ссылка КАК Номенклатура,
			|	Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.Ссылка В(&СписокНоменклатуры)
			|	И Номенклатура.СтатьяЗатрат <> ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ПустаяСсылка)";
			
			ТаблицаСтатейЗатратНоменклатуры = Запрос.Выполнить().Выгрузить();
			ТаблицаСтатейЗатратНоменклатуры.Индексы.Добавить("Номенклатура");
			
		КонецЕсли;
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Материалы Цикл
			
			СтрокаТабличнойЧасти.СчетЗатрат				= Объект.СчетЗатрат;
			СтрокаТабличнойЧасти.НоменклатурнаяГруппа	= НоменклатурнаяГруппа;
			
			Если ЗаполнитьСтатьиЗатратЗначениямиПоУмолчанию Тогда
				НайденнаяСтрока = ТаблицаСтатейЗатратНоменклатуры.Найти(СтрокаТабличнойЧасти.Номенклатура, "Номенклатура");
				Если НайденнаяСтрока <> Неопределено Тогда
					СтрокаТабличнойЧасти.СтатьяЗатрат	= НайденнаяСтрока.СтатьяЗатрат;
				Иначе
					СтрокаТабличнойЧасти.СтатьяЗатрат	= СтатьяЗатрат;
				КонецЕсли;
			Иначе
				СтрокаТабличнойЧасти.СтатьяЗатрат	= СтатьяЗатрат;
			КонецЕсли;
			
			ЗаполнитьДобавленныеКолонкиСтрокиМатериалы(СтрокаТабличнойЧасти, ПараметрыОбъекта);
			
		КонецЦикла;
		
	КонецЕсли;
	
	УправлениеВидимостью();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)
	
	ПараметрыФормы = Новый Структура;
	
	ДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	
	Если ИмяТаблицы = "Материалы" Тогда
		ПредставлениеТаблицы = НСтр("ru='Материалы';uk='Матеріали'");
	ИначеЕсли ИмяТаблицы = "МатериалыЗаказчика" Тогда
		ПредставлениеТаблицы = НСтр("ru='Материалы заказчика';uk='Матеріали замовника'");
		ПараметрыФормы.Вставить("Контрагент", Объект.Контрагент);
	КонецЕсли;
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Подбор номенклатуры в %1 (%2)';uk='Підбір номенклатури %1 (%2)'"),
		Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы.Вставить("ЕстьЦена",            Ложь);
	ПараметрыФормы.Вставить("ЕстьКоличество",      Истина);
	ПараметрыФормы.Вставить("ДатаРасчетов",        ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта",              ВалютаРегламентированногоУчета);
	ПараметрыФормы.Вставить("Организация",         Объект.Организация);
	ПараметрыФормы.Вставить("Склад",               Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок",           ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора",          "");
	ПараметрыФормы.Вставить("ИмяТаблицы",          ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги",              Ложь);
	ПараметрыФормы.Вставить("ПоказыватьОстатки",   Истина);
	ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
	Параметрыформы.Вставить("ПоказыватьЦены",      Ложь);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИмяТаблицы)	

	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");
	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		
		ТаблицаТоваров = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
		
	Иначе
		
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
		
	КонецЕсли;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта);
	
	Если Объект.СчетаУчетаЗатратВТаблице Тогда
		СчетЗатрат			= ПланыСчетов.Хозрасчетный.ОсновноеПроизводство;
	КонецЕсли;
	
	КоличествоДобавленныхСтрок = 0;
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтрокаТабличнойЧасти = Неопределено;
		Если Не ЭтоВставкаИзБуфера Тогда
		
			СтруктураОтбора = Новый Структура("Номенклатура, ЕдиницаИзмерения", СтрокаТовара.Номенклатура, СтрокаТовара.ЕдиницаИзмерения);
			СтрокаТабличнойЧасти = НайтиСтрокуТабличнойЧасти(ИмяТаблицы, СтруктураОтбора);
			
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли - увеличиваем количество.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТовара.Количество;
			
		Иначе
			
			СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТовара.Номенклатура);
			Если ЭтоВставкаИзБуфера
				И СведенияОНоменклатуре <> Неопределено
				И ЗначениеЗаполнено(СведенияОНоменклатуре.Услуга)
				И СведенияОНоменклатуре.Услуга Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
			КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок + 1;
			
			Если СведенияОНоменклатуре = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ИмяТаблицы = "Материалы" Тогда
				
				СтрокаТабличнойЧасти.НоменклатурнаяГруппа	= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.НоменклатурнаяГруппа),
					СтрокаТабличнойЧасти.НоменклатурнаяГруппа, СведенияОНоменклатуре.НоменклатурнаяГруппа);
				СтрокаТабличнойЧасти.СтатьяЗатрат			= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтатьяЗатрат),
					СтрокаТабличнойЧасти.СтатьяЗатрат, СведенияОНоменклатуре.СтатьяЗатрат);
				
				Если Объект.СчетаУчетаЗатратВТаблице Тогда
					СтрокаТабличнойЧасти.СчетЗатрат				= СчетЗатрат;
				КонецЕсли;
				
				ЗаполнитьДобавленныеКолонкиСтрокиМатериалы(СтрокаТабличнойЧасти, ПараметрыОбъекта);
				
			КонецЕсли;
			
			Документы.ТребованиеНакладная.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
				ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТаблицы, СведенияОНоменклатуре);
				
			Если ЭтоВставкаИзБуфера 
				И СтрокаТовара.Владелец().Колонки.Найти("СчетУчетаБУ") <> Неопределено 
				И ЗначениеЗаполнено(СтрокаТовара["СчетУчетаБУ"]) Тогда
				СтрокаТабличнойЧасти.Счет = СтрокаТовара.СчетУчетаБУ;
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЦикла;

	Если ЭтоВставкаИзБуфера Тогда
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуТабличнойЧасти(ИмяТабличнойЧасти, СтруктураОтбора)

	СтрокаТабличнойЧасти = Неопределено;

	МассивНайденныхСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

&НаСервере
Процедура ПроверитьНалоговоеНазначениеДоходовИЗатрат()
	
	ХарактерЗатрат = УправлениеПроизводствомВызовСервера.ПолучитьХарактерЗатратПоСчетуЗатрат(Объект.СчетЗатрат,,Объект.Дата);
	Если (ХарактерЗатрат = "Производство" ИЛИ ХарактерЗатрат = "Строительство" ИЛИ ХарактерЗатрат = "ТЗР" ИЛИ ХарактерЗатрат = "РБП" ИЛИ ХарактерЗатрат = "ОПЗ") Тогда
		Объект.НалоговоеНазначениеДоходовИЗатрат = Неопределено;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНалоговоеНазначениеДоходовИЗатратВСтроке(ДанныеСтроки, ПараметрыОбъекта)
	
	ХарактерЗатрат = УправлениеПроизводствомВызовСервера.ПолучитьХарактерЗатратПоСчетуЗатрат(ДанныеСтроки.СчетЗатрат,,ПараметрыОбъекта.Дата);
	Если (ХарактерЗатрат = "Производство" ИЛИ ХарактерЗатрат = "Строительство" ИЛИ ХарактерЗатрат = "ТЗР" ИЛИ ХарактерЗатрат = "РБП" ИЛИ ХарактерЗатрат = "ОПЗ") Тогда
		ДанныеСтроки.НалоговоеНазначениеДоходовИЗатрат = Неопределено;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура МатериалПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения		= СведенияОНоменклатуре.БазоваяЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Коэффициент			= СведенияОНоменклатуре.Коэффициент;
	СтрокаТабличнойЧасти.НоменклатурнаяГруппа	= СведенияОНоменклатуре.НоменклатурнаяГруппа;
	СтрокаТабличнойЧасти.СтатьяЗатрат			= СведенияОНоменклатуре.СтатьяЗатрат;
	
	Если ДанныеОбъекта.СчетаУчетаЗатратВТаблице Тогда
		
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетЗатрат) Тогда
			СтрокаТабличнойЧасти.СчетЗатрат = ПланыСчетов.Хозрасчетный.ОсновноеПроизводство;
		КонецЕсли;
		
	КонецЕсли;
	
	Документы.ТребованиеНакладная.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Материалы", СведенияОНоменклатуре);
		
	ЗаполнитьДобавленныеКолонкиСтрокиМатериалы(СтрокаТабличнойЧасти, ДанныеОбъекта);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура МатериалЗаказчикаПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения	= СведенияОНоменклатуре.БазоваяЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Коэффициент		= СведенияОНоменклатуре.Коэффициент;
	
	Документы.ТребованиеНакладная.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "МатериалыЗаказчика", СведенияОНоменклатуре);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета)

	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма, Форма.Объект,
		"Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
		Форма, 
		Форма.Объект, 
		"Субконто" + Суффикс + "%Индекс%", 
		"Субконто" + Суффикс + "%Индекс%", 
		ПараметрыДокумента);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(Форма, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)

	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("Организация", Форма.Объект.Организация);
	СписокПараметров.Вставить("СчетУчета"  , Форма.Объект[ИмяСчета]);
	
	Возврат СписокПараметров;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет, Постфикс = "", ЕстьПодразделение)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто" + Постфикс + "1",
		"Субконто" + Постфикс + "2",
		"Субконто" + Постфикс + "3");
		
	Если ЕстьПодразделение Тогда
		ПоляФормы.Вставить("Подразделение", "ПодразделениеЗатрат" + Постфикс);
	КонецЕсли;
	
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто" + Постфикс + "1",
		"ЗаголовокСубконто" + Постфикс + "2",
		"ЗаголовокСубконто" + Постфикс + "3");
	
	Если ЕстьПодразделение Тогда
		ЗаголовкиПолей.Вставить("Подразделение", "ЗаголовокПодразделение" + Постфикс);
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьНалоговоеНазначениеПроводки(Объект, Элементы, ПлательщикНДС)

	ХарактерЗатрат = УправлениеПроизводствомВызовСервера.ПолучитьХарактерЗатратПоСчетуЗатрат(Объект.СчетЗатрат,,Объект.Дата);                                                                                              
	Элементы.НалоговоеНазначениеДоходовИЗатрат.Доступность = НЕ (ХарактерЗатрат = "Производство" ИЛИ ХарактерЗатрат = "Строительство" ИЛИ ХарактерЗатрат = "ТЗР" ИЛИ ХарактерЗатрат = "РБП" ИЛИ ХарактерЗатрат = "ОПЗ");
	
	ТекстНадписи = "";
	Если Элементы.НалоговоеНазначениеДоходовИЗатрат.Доступность = Ложь Тогда
		// заполним характер затрат, признак Амортизируется и НалоговоеНазначениеДоходовИЗатрат
		ХарактерЗатрат = Неопределено;
		ХарактерЗатратРБП = Неопределено;		
		НалоговоеНазначениеПроводки = Неопределено;
		
		Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийТребованиеНакладная.Материалы") Тогда
			НалоговоеНазначениеНДС = НСтр("ru='Совпадает с налоговым назначением материала';uk='Співпадає з податковим призначенням матеріала'");
		Иначе	
		    НалоговоеНазначениеНДС = НСтр("ru='Совпадает с налоговым назначением оборудования';uk='Співпадає з податковим призначенням устаткування'");
		КонецЕсли;
		СтруктураСубконто = Новый Структура("Субконто1,Субконто2,Субконто3", Объект.Субконто1, Объект.Субконто2, Объект.Субконто3);
		НалоговыйУчет.ОпределениеАналитикиНалоговогоУчетаВПроводкахДляЗатрат(СтруктураСубконто, Объект.СчетЗатрат, ХарактерЗатрат,
																			 НалоговоеНазначениеПроводки, , НалоговоеНазначениеНДС,,,Объект.Дата, ХарактерЗатратРБП
																			,ПлательщикНДС
																			);
		Если НЕ ПлательщикНДС Тогда
			ТекстНадписи = "<" + Строка(НалоговоеНазначениеПроводки) + ">";
		ИначеЕсли ХарактерЗатрат = "ОПЗ"
			ИЛИ ХарактерЗатрат = "ТЗР" Тогда
			ТекстНадписи = "<" + Строка(НалоговоеНазначениеПроводки) + ">";
		ИначеЕсли ХарактерЗатрат = "Производство" Тогда
			ТекстНадписи = "<" + Строка(НалоговоеНазначениеПроводки) + ">, " + НСтр("ru='из аналитики счета - номенклатурной группы';uk='з аналітики рахунку - номенклатурної групи'");
		ИначеЕсли ХарактерЗатрат = "Строительство" Тогда
			ТекстНадписи = "<" + Строка(НалоговоеНазначениеПроводки) + ">, " + НСтр("ru='из аналитики счета - объекта строительства';uk=""з аналітики рахунку - об'єкта будівництва""");
		ИначеЕсли ХарактерЗатрат = "РБП" Тогда
			Если    ХарактерЗатратРБП = "Производство"
				ИЛИ ХарактерЗатратРБП = "Строительство"
				ИЛИ ХарактерЗатратРБП = "ОПЗ"
				Тогда
				ТекстНадписи = "<" + Строка(НалоговоеНазначениеПроводки) + ">, " + НСтр("ru='из аналитики счета - справочника РБП';uk='з аналітики рахунку - довідника витрат майбут. періодів'");
			Иначе			
				ТекстНадписи = "<" + Строка(НалоговоеНазначениеПроводки) + ">";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.НадписьИнформацияНалоговоеНазначениеДоходовИЗатрат.Заголовок = ТекстНадписи;
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура ЕдиницаИзмеренияПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ИмяТабличнойЧасти)

	ОбработкаТабличныхЧастей.ЗаполнитьКоэффициентТабЧасти(СтрокаТабличнойЧасти, Неопределено, ИмяТабличнойЧасти, Метаданные.Документы.ТребованиеНакладная);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаполнениемТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьСтатьиЗатратЗначениямиПоУмолчанию	= (Результат = КодВозвратаДиалога.Да);
	СчетаУчетаЗатратВТаблицеПриИзмененииНаСервере(ЗаполнитьСтатьиЗатратЗначениямиПоУмолчанию);
	
КонецПроцедуры

#Область КопированиеВставкаСтрокЧерезБуферОбмена

&НаСервере
Процедура СкопироватьСтрокиНаСервере(ИмяТаблицы)
	
	ОбщегоНазначения.СкопироватьСтрокиВБуферОбмена(Объект[ИмяТаблицы], 
		Элементы[ИмяТаблицы].ВыделенныеСтроки, Объект.Ссылка.Метаданные().Имя);

КонецПроцедуры

&НаСервере
Функция ВставитьСтрокиНаСервере(ИмяТаблицы)
	
	ПараметрыВставки = ОбработкаТабличныхЧастей.ПолучитьПараметрыВставкиДанныхИзБуфераОбмена(Объект.Ссылка, ИмяТаблицы);
	ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки);
	ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ПараметрыВставки, ПараметрыВставки.ИмяТаблицы);
	
	Возврат ПараметрыВставки.КоличествоДобавленныхСтрок;
	
КонецФункции

&НаКлиенте
Функция ПолучитьИмяТекущейТабличнойЧасти()
	
	ИмяТекущейСтраницы = Элементы.Страницы.ТекущаяСтраница.Имя;
	ИмяТаблицы = "";
	Если ИмяТекущейСтраницы = "СтраницаМатериалы" Тогда
		
		ИмяТаблицы = "Материалы";
		
	КонецЕсли;
	
	Возврат ИмяТаблицы;
	
КонецФункции

&НаСервере
Процедура ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки)
	
	СписокСвойств = Новый Массив;
	СписокСвойств.Добавить("Номенклатура");
	СписокСвойств.Добавить("ЕдиницаИзмерения");
	СписокСвойств.Добавить("Коэффициент");
	СписокСвойств.Добавить("Количество");
	Если ПараметрыВставки.ПоказыватьВДокументахСчетаУчета Тогда
		
		СписокСвойств.Добавить("Счет");
		Если ПараметрыВставки.ИсточникИДокументОдногоВида Тогда
			
			СписокСвойств.Добавить("СчетЗатрат");
			СписокСвойств.Добавить("СтатьяЗатрат");
			
		КонецЕсли;
		
	КонецЕсли;
	Если ПараметрыВставки.ИсточникИДокументОдногоВида Тогда
		
		СписокСвойств.Добавить("ДокументОприходования");
		СписокСвойств.Добавить("НоменклатурнаяГруппа");
		
	КонецЕсли;
	
	ПараметрыВставки.СписокСвойств = ОбработкаТабличныхЧастей.ПолучитьСписокСвойствИмеющихсяВТаблицеДанных(
		ПараметрыВставки.Данные, СписокСвойств);
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандыВставки(Форма, Доступность)

	Доступность = Не Форма.ТолькоПросмотр И Доступность;
	Элементы = Форма.Элементы;
	Элементы.МатериалыВставитьСтроки.Доступность					= Доступность;
	Элементы.МатериалыКонтекстноеМенюВставитьСтроки.Доступность		= Доступность;
	
КонецПроцедуры

#КонецОбласти

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