﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
		
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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

	// Если дата действия отличалась на 10 дней, т.е. не была исправлена, надо ее поправить
	Если НачалоДня(Объект.ДатаДействия) - НачалоДня(ТекущаяДатаДокумента) = 10 * (24 * 60 * 60) Тогда
		Объект.ДатаДействия = Объект.Дата + 10 * (24 * 60 * 60);
	КонецЕсли;
	
	ТекущаяДатаДокумента = Объект.Дата; 

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	ДанныеОбъекта = Новый Структура("Организация, СтруктурнаяЕдиница, Контрагент, ДоговорКонтрагента");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ОрганизацияПриИзмененииНаСервере(ДанныеОбъекта);
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);
	
	ДоговорКонтрагентаОбработатьИзменение();

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	ДанныеОбъекта = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, НаПолучениеОт");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	КонтрагентПриИзмененииНаСервере(ДанныеОбъекта);
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);
	
	ДоговорКонтрагентаОбработатьИзменение();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	ДоговорКонтрагентаОбработатьИзменение();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)

	ПаспортныеДанные = ПолучитьПаспортныеДанныеСтрокой(Объект.Организация, Объект.ФизЛицо);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СделкаПриИзменении(Элемент)
	
	СделкаОбработатьИзменение();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("Дата",               Объект.Дата);
	ПараметрыОбъекта.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	ПараметрыОбъекта.Вставить("Контрагент",         Объект.Контрагент);
	ПараметрыОбъекта.Вставить("Организация",        Объект.Организация);
	ПараметрыОбъекта.Вставить("ТипыДокументов",     "Метаданные.Документы.Доверенность.Реквизиты.Сделка.Тип");
		
	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНаименованиеТовараНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОтбора = Новый Структура("НаименованиеПолное", СокрЛП(Элемент.ТекстРедактирования));
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыОтбора, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНаименованиеТовараОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Номенклатура") Тогда
		ТекДанные = Элементы.Товары.ТекущиеДанные;
		РеквизитыСтрока = "НаименованиеПолное, БазоваяЕдиницаИзмерения";
		ЗначенияРеквизитов = ПолучитьСвойстваТовара(ВыбранноеЗначение, РеквизитыСтрока); 
		ВыбранноеЗначение = ЗначенияРеквизитов.НаименованиеПолное;
		
		Если НЕ ЗначениеЗаполнено(ТекДанные.ЕдиницаПоКлассификатору) ИЛИ
			ТекДанные.ЕдиницаПоКлассификатору <> ЗначенияРеквизитов.БазоваяЕдиницаИзмерения Тогда
			ТекДанные.ЕдиницаПоКлассификатору = ЗначенияРеквизитов.БазоваяЕдиницаИзмерения;
		КонецЕсли;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборТовары(Команда)
	
	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора, 
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
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

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента = Объект.Дата;
	
	Если ЗначениеЗаполнено(Объект.ФизЛицо) Тогда
		ПаспортныеДанные = ОбщегоНазначенияБПВызовСервера.ПолучитьПаспортныеДанныеСтрокой(Объект.Организация, Объект.ФизЛицо);
	КонецЕсли;
	
	УстановитьПараметрыВыбора(ЭтаФорма);
	
	УстановитьСостояниеДокумента();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.СтруктурнаяЕдиница.Доступность = ЗначениеЗаполнено(Объект.Организация);
	Элементы.ДоговорКонтрагента.Доступность = ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент);
	Элементы.Сделка.Доступность = ЗначениеЗаполнено(Объект.Организация) И 
		ЗначениеЗаполнено(Объект.Контрагент) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	Элементы.НаПолучениеОт.Доступность = ЗначениеЗаполнено(Объект.Организация) И 
		ЗначениеЗаполнено(Объект.Контрагент) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	Элементы.ПоДокументу.Доступность = ЗначениеЗаполнено(Объект.Организация) И 
		ЗначениеЗаполнено(Объект.Контрагент) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	
	Если ЗначениеЗаполнено(Объект.ФизЛицо) И Форма.ПаспортныеДанные = "Отсутствуют данные об удостоверении личности." Тогда
		Элементы.ГруппаПаспортныеДанные.ТекущаяСтраница = Элементы.ГруппаПаспортныеДанныеОтсутствуют;
	Иначе
		Элементы.ГруппаПаспортныеДанные.ТекущаяСтраница = Элементы.ГруппаЕстьПаспортныеДанные;
		Элементы.ДекорацияЕстьПаспортныеДанные.Заголовок = Форма.ПаспортныеДанные;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбора(Форма)
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОрганизацияПриИзмененииНаСервере(ДанныеОбъекта)
	
	УчетДенежныхСредствБП.УстановитьБанковскийСчет(ДанныеОбъекта.СтруктурнаяЕдиница, ДанныеОбъекта.Организация,
		ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(
		ДанныеОбъекта.ДоговорКонтрагента, ДанныеОбъекта.Контрагент, ДанныеОбъекта.Организация);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КонтрагентПриИзмененииНаСервере(ДанныеОбъекта)
	
	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(
		ДанныеОбъекта.ДоговорКонтрагента, ДанныеОбъекта.Контрагент, ДанныеОбъекта.Организация);
	
	ДанныеОбъекта.НаПолучениеОт = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеОбъекта.Контрагент, "НаименованиеПолное");
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаОбработатьИзменение()
	
	Объект.Сделка      = Неопределено;
	СделкаОбработатьИзменение();
	
КонецПроцедуры

&НаКлиенте
Процедура СделкаОбработатьИзменение()
	
	Объект.ПоДокументу = ПолучитьПредставлениеДокумента(Объект.Сделка);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ПараметрыФормы = Новый Структура;
	
	ЗаголовокПодбора = НСтр("ru='Подбор номенклатуры в %1 (%2)';uk='Підбір номенклатури %1 (%2)'");
	
	ПредставлениеТаблицы = НСтр("ru='Товары';uk='Товари'");
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы.Вставить("Заголовок"         , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"        , ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"        , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"            , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("ЕстьКоличество"    , Истина);
	
	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)
	
	ВидПодбора = "";
	
	Возврат ВидПодбора;

КонецФункции

&НаСервере
Функция ПолучитьСвойстваТовара(Товар, РеквизитыСтрока)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Товар, РеквизитыСтрока);
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтрокаТаблицы = Объект[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТовара);
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТовара.Номенклатура);
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы.НаименованиеТовара      = СведенияОНоменклатуре.НаименованиеПолное;
		СтрокаТаблицы.ЕдиницаПоКлассификатору = СтрокаТовара.ЕдиницаИзмерения;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПаспортныеДанныеСтрокой(Организация, ФизЛицо) Экспорт

	Возврат ОбщегоНазначенияБПВызовСервера.ПолучитьПаспортныеДанныеСтрокой(Организация, ФизЛицо);

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеДокумента(Сделка)
	
	Возврат Документы.Доверенность.ПолучитьТекстПоДокументу(Сделка);
	
КонецФункции

#КонецОбласти
