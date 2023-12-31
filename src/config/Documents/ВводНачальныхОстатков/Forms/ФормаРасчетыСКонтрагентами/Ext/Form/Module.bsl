﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыОбъекта());
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
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

	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Документы.ВводНачальныхОстатков.УстановитьЗаголовокФормы(ЭтаФорма);
	УправлениеФормойСервер();
	
	УстановитьСостояниеДокумента();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

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
Процедура ОрганизацияПриИзменении(Элемент)

	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ 

&НаКлиенте
Процедура РасчетыСКонтрагентамиКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	Если ВыбранноеЗначение <> СтрокаТаблицы.Контрагент Тогда
		СтрокаТаблицы.Документ = "";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиКонтрагентПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	ПараметрыСтроки		= ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	
	ПриИзмененииКонтрагентаРасчетов(ПараметрыСтроки);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы,ПараметрыСтроки);
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиДоговорКонтрагентаПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	ПараметрыСтроки		= ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ПараметрыДокумента	= Новый Структура("ВалютаРегламентированногоУчета, Дата, Организация",
		ВалютаРегламентированногоУчета, Объект.Дата, Объект.Организация);
	
	ПриИзмененииДоговораРасчетов(ПараметрыСтроки,ПараметрыДокумента);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиКурсВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ДоговорКонтрагента"     , СтрокаТаблицы.ДоговорКонтрагента);
	ПараметрыДокумента.Вставить("КратностьВзаиморасчетов", СтрокаТаблицы.КратностьВзаиморасчетов);
	ПараметрыДокумента.Вставить("КурсВзаиморасчетов"     , СтрокаТаблицы.КурсВзаиморасчетов);
	ПараметрыДокумента.Вставить("Дата"                   , Объект.Дата);
	
	СтруктураКурсаИКратности = Неопределено;
	
	ОткрытьФорму("Общаяформа.ФормаВводаКурсаИКратности", ПараметрыДокумента,,,,, Новый ОписаниеОповещения("РасчетыСКонтрагентамиКурсВзаиморасчетовНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("СтрокаТаблицы, Элемент", СтрокаТаблицы, Элемент)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиКурсВзаиморасчетовНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    СтрокаТаблицы = ДополнительныеПараметры.СтрокаТаблицы;
    Элемент = ДополнительныеПараметры.Элемент;
    
    СтруктураКурсаИКратности = Результат;
    Если СтруктураКурсаИКратности <> Неопределено Тогда
        СтрокаТаблицы.КурсВзаиморасчетов      = СтруктураКурсаИКратности.КурсВалюты;
        СтрокаТаблицы.КратностьВзаиморасчетов = СтруктураКурсаИКратности.КратностьВалюты;
        РасчетыСКонтрагентамиКурсВзаиморасчетовПриИзменении(Элемент);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиКурсВзаиморасчетовПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	Если СтрокаТаблицы.Валюта = ЭтаФорма.ВалютаРегламентированногоУчета Тогда
		СтрокаТаблицы.КурсВзаиморасчетов = 1;
		СтрокаТаблицы.КратностьВзаиморасчетов = 1;	
	Иначе	
		ПараметрыСтроки		= ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
		ПересчитатьСуммуПоСтроке(ПараметрыСтроки, Ложь);
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиСчетУчетаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	ПриВыбореСчетаРасчетыСКонтрагентами(СтрокаТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиСуммаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	ПараметрыСтроки		= ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ПараметрыДокумента	= Новый Структура("ВалютаРегламентированногоУчета",ВалютаРегламентированногоУчета);
	
	Если СтрокаТаблицы.Валюта = ВалютаРегламентированногоУчета Тогда
		ПересчитатьСуммуПоСтроке(ПараметрыСтроки);
	Иначе	
		ПересчитатьКурсПоСтроке(ПараметрыСтроки,ПараметрыДокумента);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	
	ДоговорКонтрагента  = СтрокаТаблицы.ДоговорКонтрагента;
	// Без договора сделку выбирать не будем.
	Если НЕ ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ТекстОповещения = НСтр("ru='Не выбран договор контрагента!';uk='Не обраний договір контрагента!'");
		ПоказатьОповещениеПользователя(ТекстОповещения);
		Возврат;
	КонецЕсли; 

	// Заполним возможный список типов документов, которые могут быть расчетными.
	МассивТипов = Новый Массив;

	//Список документов зависит от вида договора.
	Если СтрокаТаблицы.ТипКонтрагента = ПредопределенноеЗначение("Перечисление.СтатусыКонтрагентов.Покупатель") Тогда
		
		МассивТипов.Добавить(Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтПокупателя"));
		МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаДолга"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ОтчетКомиссионераОПродажах"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеСРасчетногоСчета"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПлатежныйОрдерСписаниеДенежныхСредств"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПлатежныйОрдерПоступлениеДенежныхСредств"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПриходныйКассовыйОрдер"));
		МассивТипов.Добавить(Тип("ДокументСсылка.РасходныйКассовыйОрдер"));
		МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПокупателю"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом"))			
		
	ИначеЕсли СтрокаТаблицы.ТипКонтрагента = ПредопределенноеЗначение("Перечисление.СтатусыКонтрагентов.Поставщик") Тогда
		
		МассивТипов.Добавить(Тип("ДокументСсылка.АвансовыйОтчет"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
		МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаДолга"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ОтчетКомитентуОПродажах"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеСРасчетногоСчета"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПлатежныйОрдерСписаниеДенежныхСредств"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПлатежныйОрдерПоступлениеДенежныхСредств"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеДопРасходов"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеТоваровУслуг"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПриходныйКассовыйОрдер"));
		МассивТипов.Добавить(Тип("ДокументСсылка.РасходныйКассовыйОрдер"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПоставщика"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом"));						
		
	Иначе // Прочее
		
		МассивТипов.Добавить(Тип("ДокументСсылка.АвансовыйОтчет"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтПокупателя"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
		МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаДолга"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ОтчетКомиссионераОПродажах"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ОтчетКомитентуОПродажах"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеСРасчетногоСчета"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПлатежныйОрдерСписаниеДенежныхСредств"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПлатежныйОрдерПоступлениеДенежныхСредств"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеДопРасходов"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеТоваровУслуг"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПриходныйКассовыйОрдер"));
		МассивТипов.Добавить(Тип("ДокументСсылка.РасходныйКассовыйОрдер"));
		МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПоставщика"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПокупателю"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом"));			
		
	КонецЕсли;
	
	ТипыДокументов = Новый ОписаниеТипов(МассивТипов);
	
	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("НачалоПериода",			'00010101');
	ПараметрыОбъекта.Вставить("КонецПериода",			КонецДня(Объект.Дата));
	ПараметрыОбъекта.Вставить("Организация",			Объект.Организация);
	ПараметрыОбъекта.Вставить("Контрагент",				СтрокаТаблицы.Контрагент);
	ПараметрыОбъекта.Вставить("ДоговорКонтрагента",		СтрокаТаблицы.ДоговорКонтрагента);
	ПараметрыОбъекта.Вставить("СчетУчета",				СтрокаТаблицы.СчетУчета);
	ПараметрыОбъекта.Вставить("ОстаткиОбороты",			"Дт");
	ПараметрыОбъекта.Вставить("ТипыДокументов",			"Метаданные.Документы.ВводНачальныхОстатков.ТабличныеЧасти.РасчетыСКонтрагентами.Реквизиты.Документ.Тип");
	ПараметрыОбъекта.Вставить("РежимОтбораДокументов",	ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоРеквизитам"));

	ПараметрыФормы	= Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиВалютнаяСуммаПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	ПараметрыСтроки		= ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	
	ПересчитатьСуммуПоСтроке(ПараметрыСтроки, Ложь);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиТипКонтрагентаПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	ПараметрыСтроки		= ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ПараметрыДокумента	= Новый Структура("ВалютаРегламентированногоУчета, Дата, Организация, ЗаполнятьБУ",
		ВалютаРегламентированногоУчета, Объект.Дата, Объект.Организация, Ложь);
	
	ЗаполнитьСчетаУчетаВСтрокеРасчетовСКонтрагентами(ПараметрыСтроки, ПараметрыДокумента);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСКонтрагентамиСтавкаНДСПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	ПараметрыСтроки		= ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	
	ПересчитатьСуммыПоСтрокеРегл(ПараметрыСтроки);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуНастройкиРежима(Команда)

	ПараметрыНастройкиРежима	= Новый Структура;
	ПараметрыНастройкиРежима.Вставить("ВводитьОстаткиЗапасовВРазрезеДатОприходования",	Объект.ВводитьОстаткиЗапасовВРазрезеДатОприходования);
	ПараметрыНастройкиРежима.Вставить("ВводитьОстаткиЗапасовВРазрезеПоставщиков",		Объект.ВводитьОстаткиЗапасовВРазрезеПоставщиков);
	ПараметрыНастройкиРежима.Вставить("ВводитьСуммыУлучшенияВключенныеВБалансовуюСтоимостьОС",	Объект.ВводитьСуммыУлучшенияВключенныеВБалансовуюСтоимостьОС);
	ПараметрыНастройкиРежима.Вставить("Организация", Объект.Организация);
	ПараметрыНастройкиРежима.Вставить("РазделУчета", Объект.РазделУчета);
	ПараметрыНастройкиРежима.Вставить("Дата",		 Объект.Дата);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОткрытьФормуНастройкиРежимаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ВводНачальныхОстатков.Форма.ФормаНастройкиРежима",
		ПараметрыНастройкиРежима,,,,,ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиРежимаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	РезультатНастройкиРежима = РезультатЗакрытия;
	
	Если ТипЗнч(РезультатНастройкиРежима) = Тип("Структура") Тогда
		
		Модифицированность	= Истина;
		
		ЗаполнитьЗначенияСвойств(Объект, РезультатНастройкиРежима);
		
		Объект.Дата	= РезультатНастройкиРежима.ДатаВводаОстатков;
		ДатаПриИзмененииСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОписаниеРаздела(Команда)

	ДанныеЗаполнения	= Новый Структура;
	ДанныеЗаполнения.Вставить("Дата",		 Объект.Дата);
	ДанныеЗаполнения.Вставить("Организация", Объект.Организация);
	ДанныеЗаполнения.Вставить("РазделУчета", Объект.РазделУчета);

	ОткрытьФорму("Документ.ВводНачальныхОстатков.Форма.ФормаСправки", Новый Структура("ДанныеЗаполнения", ДанныеЗаполнения), ЭтаФорма, ВариантОткрытияОкна.ОтдельноеОкно);

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

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);

	
	ТекущаяДатаДокумента			= Объект.Дата;
	
	ВалютаРегламентированногоУчета	= ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Если ТипЗнч(Параметры) = Тип("ДанныеФормыСтруктура") Тогда
		Параметры.Свойство("ОткрытиеИзОбработкиВводаНачальныхОстатков", ОткрытиеИзОбработкиВводаНачальныхОстатков);
	КонецЕсли;

	Документы.ВводНачальныхОстатков.УстановитьЗаголовокФормы(ЭтаФорма);
	УправлениеФормойСервер();

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормойСервер()

	// Установка режима "Только просмотр" для поля "Дата"
	Элементы.Дата.ТолькоПросмотр =
		ЗначениеЗаполнено(Документы.ВводНачальныхОстатков.ПолучитьДатуВводаОстатков(Объект.Организация));

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

	//Установить значения реквизитов
	ТекущаяДатаДокумента = Объект.Дата;
	ЕстьНалогНаПрибыльДо2015   = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, НачалоМесяца(ТекущаяДатаДокумента));
	ЕстьНДС              = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, НачалоМесяца(ТекущаяДатаДокумента));	
	ВалютаРегламентированногоУчета  = Константы.ВалютаРегламентированногоУчета.Получить();

	//Установить видимость
	ВидимостьНалоговыхРеквизитов = ЕстьНДС ИЛИ ЕстьНалогНаПрибыльДо2015; 
	
	Элементы.РасчетыСКонтрагентамиСуммаНУ.Видимость 				 = ВидимостьНалоговыхРеквизитов;
	Элементы.РасчетыСКонтрагентамиРасчетыВозврат.Видимость 			 = ВидимостьНалоговыхРеквизитов;
	Элементы.РасчетыСКонтрагентамиЗаТару.Видимость 					 = ВидимостьНалоговыхРеквизитов;
	Элементы.РасчетыСКонтрагентамиНетНалоговойНакладной.Видимость 	 = ЕстьНДС;
	Элементы.РасчетыСКонтрагентамиВзаиморасчетыЗакрыты.Видимость	 = ЕстьНДС;
	Элементы.РасчетыСКонтрагентамиСтавкаНДС.Видимость 				 = ВидимостьНалоговыхРеквизитов;
	Элементы.РасчетыСКонтрагентамиСуммаНДС.Видимость 				 = ВидимостьНалоговыхРеквизитов;
	Элементы.РасчетыСКонтрагентамиСчетУчетаНДС.Видимость 			 = ВидимостьНалоговыхРеквизитов;
	Элементы.РасчетыСКонтрагентамиСчетУчетаНДСПодтвержденный.Видимость = ВидимостьНалоговыхРеквизитов;
	Элементы.РасчетыСКонтрагентамиНалоговоеНазначение.Видимость 	 = ВидимостьНалоговыхРеквизитов;

	// Ограничение выбора счета учета:
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоВыданнымАвансам);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСДругимиДебиторамиВНациональнойВалюте);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСДругимиДебиторамиВИностраннойВалюте);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСДругимиКредиторамиВНациональнойВалюте);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСДругимиКредиторамиВИностраннойВалюте);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученным);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НалоговыеОбязательстваВсего);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НалоговыйКредитВсего);

	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоГарантийномуОбеспечению);
	МассивИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСРозничнымиПокупателями);
	
	СчетаДляОтбора = БухгалтерскийУчет.ПолучитьМассивСчетовССубсчетами(МассивСчетов, Ложь, , , МассивИсключений);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.РасчетыСКонтрагентамиСчетУчета, СчетаДляОтбора);
	
	//Ограничение типов контрагентов
	СписокВыбора = Элементы.РасчетыСКонтрагентамиТипКонтрагента.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(Перечисления.СтатусыКонтрагентов.Покупатель);
	СписокВыбора.Добавить(Перечисления.СтатусыКонтрагентов.Поставщик);
	
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	УправлениеФормойСервер();

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	ДатаВводаОстатков	= Документы.ВводНачальныхОстатков.ПолучитьДатуВводаОстатков(Объект.Организация);
	
	Если ЗначениеЗаполнено(ДатаВводаОстатков) Тогда
		Объект.Дата	= ДатаВводаОстатков;
	КонецЕсли;

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	УправлениеФормойСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКонтрагентаРасчетов(СтрокаТабличнойЧасти)
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если УправлениеВзаиморасчетами.УстановитьДоговорКонтрагента(СтрокаТабличнойЧасти.ДоговорКонтрагента,СтрокаТабличнойЧасти.Контрагент,Объект.Организация) тогда
		ПриИзмененииДоговораРасчетов(СтрокаТабличнойЧасти,Новый Структура("Дата,Организация",Объект.Дата,Объект.Организация));
	КонецЕсли;
	
КонецПроцедуры

//Параметры - структура (Организация,Дата)
&НаСервереБезКонтекста
Процедура ПриИзмененииДоговораРасчетов(СтрокаТабличнойЧасти,ПараметрыДокумента) Экспорт
	
	//  Для сделки нет значения по умолчанию в договоре, поэтому заполняем ее пустым значением.
	СтрокаТабличнойЧасти.Документ = Неопределено;

	Если СтрокаТабличнойЧасти.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
		СтрокаТабличнойЧасти.ТипКонтрагента = Перечисления.СтатусыКонтрагентов.Покупатель;
	Иначе
		СтрокаТабличнойЧасти.ТипКонтрагента = Перечисления.СтатусыКонтрагентов.Поставщик;
	КонецЕсли;
	СтрокаТабличнойЧасти.РасчетыВозврат = Перечисления.РасчетыВозврат.Расчеты;

	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Контрагент) Тогда
		Контрагент = СтрокаТабличнойЧасти.ДоговорКонтрагента.Владелец;
	КонецЕсли;

	// Курс надо тоже заполнить
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента) Тогда
		
		СтрокаТабличнойЧасти.Валюта = СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов;
		СтрокаТабличнойЧасти.КурсВзаиморасчетов = МодульВалютногоУчета.ПолучитьКурсВалюты(СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов, ПараметрыДокумента.Дата).Курс;
		СтрокаТабличнойЧасти.КратностьВзаиморасчетов = МодульВалютногоУчета.ПолучитьКурсВалюты(СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов, ПараметрыДокумента.Дата).Кратность;
		
		ПараметрыДокумента.Вставить("ЗаполнятьБУ",Истина);
		ЗаполнитьСчетаУчетаВСтрокеРасчетовСКонтрагентами(СтрокаТабличнойЧасти, ПараметрыДокумента);
		ПересчитатьСуммуПоСтроке(СтрокаТабличнойЧасти);
	КонецЕсли;
	
	ЗаполнитьДобавленныеКолонкиСтрокиТаблицы_РасчетыСКонтрагентами(СтрокаТабличнойЧасти, ПараметрыДокумента);
КонецПроцедуры

//Параметры - структура (Организация,Дата,ЗаполнятьБУ)
&НаСервереБезКонтекста
Процедура ЗаполнитьСчетаУчетаВСтрокеРасчетовСКонтрагентами(СтрокаТаблицы, ПараметрыДокумента) Экспорт

	СчетаУчета = БухгалтерскийУчетРасчетовСКонтрагентами.ПолучитьСчетаРасчетовСКонтрагентом(ПараметрыДокумента.Организация, СтрокаТаблицы.Контрагент, СтрокаТаблицы.ДоговорКонтрагента);

	Если СтрокаТаблицы.ТипКонтрагента = Перечисления.СтатусыКонтрагентов.Поставщик Тогда
		Если ПараметрыДокумента.ЗаполнятьБУ Тогда
			СтрокаТаблицы.СчетУчета = СчетаУчета.СчетРасчетов;	
		КонецЕсли;
		
		СтрокаТаблицы.СчетУчетаНДС		   		= СчетаУчета.СчетУчетаНДСПриобретений;
		СтрокаТаблицы.СчетУчетаНДСПодтвержденный	= СчетаУчета.СчетУчетаНДСПриобретенийПодтвержденный;
		СтрокаТаблицы.СтавкаНДС					= СчетаУчета.СтавкаНДСПриобретений;
		
		СтрокаТаблицы.НалоговоеНазначение		= СчетаУчета.НалоговоеНазначениеПриобретений;
        Если СтрокаТаблицы.ЗаТару Тогда
			СтрокаТаблицы.НалоговоеНазначение	= СчетаУчета.НалоговоеНазначениеПриобретенийПоТаре;
		КонецЕсли;
		
	ИначеЕсли СтрокаТаблицы.ТипКонтрагента = Перечисления.СтатусыКонтрагентов.Покупатель Тогда
		Если ПараметрыДокумента.ЗаполнятьБУ Тогда
			СтрокаТаблицы.СчетУчета = СчетаУчета.СчетРасчетовПокупателя;
		КонецЕсли;
		
		СтрокаТаблицы.СчетУчетаНДС		   		= СчетаУчета.СчетУчетаНДСПродаж;
		СтрокаТаблицы.СчетУчетаНДСПодтвержденный	= СчетаУчета.СчетУчетаНДСПродажПодтвержденный;
		СтрокаТаблицы.СтавкаНДС					= СчетаУчета.СтавкаНДСПродаж;
		
		СтрокаТаблицы.НалоговоеНазначение		= СчетаУчета.НалоговоеНазначениеПродаж;
        Если СтрокаТаблицы.ЗаТару Тогда
			СтрокаТаблицы.НалоговоеНазначение	= СчетаУчета.НалоговоеНазначениеПродажПоТаре;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧасти()

&НаСервереБезКонтекста
Процедура ПересчитатьСуммуПоСтроке(СтрокаДанных,ПересчетВалютнойСуммы = Истина)

	Если СтрокаДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ВалютаДоговора = СтрокаДанных.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	Если ПересчетВалютнойСуммы Тогда
		СтрокаДанных.ВалютнаяСумма = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаДанных.Сумма,
				мВалютаРегламентированногоУчета, ВалютаДоговора,
				1, СтрокаДанных.КурсВзаиморасчетов,
				1 ,СтрокаДанных.КратностьВзаиморасчетов);
	Иначе
		СтрокаДанных.Сумма = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаДанных.ВалютнаяСумма,
				ВалютаДоговора,мВалютаРегламентированногоУчета,
				СтрокаДанных.КурсВзаиморасчетов, 1, 
				СтрокаДанных.КратностьВзаиморасчетов, 1);
	КонецЕсли;  
			
	ПересчитатьСуммыПоСтрокеРегл(СтрокаДанных);		

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПересчитатьСуммыПоСтрокеРегл(СтрокаДанных)

	СтрокаДанных.СуммаНУ  = СтрокаДанных.Сумма;
	СтрокаДанных.СуммаНДС = СтрокаДанных.Сумма*УчетНДС.ПолучитьСтавкуНДС(СтрокаДанных.СтавкаНДС)/(100 +УчетНДС.ПолучитьСтавкуНДС(СтрокаДанных.СтавкаНДС));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореСчетаРасчетыСКонтрагентами(ТекущиеДанные)
	
	СчетУчетаВалютный = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(ТекущиеДанные.СчетУчета).Валютный;
	
	//обнулим незадействованные реквизиты
	Если НЕ СчетУчетаВалютный Тогда
		ТекущиеДанные.ВалютнаяСумма = ТекущиеДанные.Сумма;
		ТекущиеДанные.Валюта = ЭтаФорма.ВалютаРегламентированногоУчета;
		ТекущиеДанные.СуммаНДС = 0;
		ТекущиеДанные.СуммаНУ  = 0;
	КонецЕсли;
	
	РасчетыСКонтрагентамиСуммаПриИзменении(Неопределено);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПересчитатьКурсПоСтроке(СтрокаДанных,ПараметрыДокумента)
	
	Если СтрокаДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаДанных.Валюта = ПараметрыДокумента.ВалютаРегламентированногоУчета Тогда
		СтрокаДанных.КурсВзаиморасчетов = 1;
		СтрокаДанных.КратностьВзаиморасчетов = 1;
	Иначе
		СтрокаДанных.КурсВзаиморасчетов = ?(СтрокаДанных.ВалютнаяСумма*СтрокаДанных.КратностьВзаиморасчетов <>0, СтрокаДанных.Сумма/СтрокаДанных.ВалютнаяСумма*СтрокаДанных.КратностьВзаиморасчетов, 100);
  		ПересчитатьСуммыПоСтрокеРегл(СтрокаДанных);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ПоляСтрокиТабличнойЧасти(СтрокаТаблицы = Неопределено)

	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;
	КонецЕсли; 

	ПараметрыСтроки = Новый Структура("Валюта,
	|Контрагент,
	|ДоговорКонтрагента,
	|Документ, ДокументДоступность,
	|КратностьВзаиморасчетов,
	|КурсВзаиморасчетов,
	|ВалютнаяСумма,
	|Сумма,
	|СчетУчета,
	|СуммаНДС,
	|СтавкаНДС,
	|СуммаНУ,
	|ТипКонтрагента,
	|ВидЗадолженности,
	|ЗаТару,
	|РасчетыВозврат,
	|СчетУчетаНДС,
	|СчетУчетаНДСПодтвержденный,
	|НетНалоговойНакладной,
	|УдалитьСтатьяВДВР,
	|НалоговоеНазначение,
	|ВзаиморасчетыЗакрыты,
	|Амортизируется");
	
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, СтрокаТаблицы);

	Возврат ПараметрыСтроки;

КонецФункции

&НаКлиенте
Процедура РасчетыСКонтрагентамиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.РасчетыСКонтрагентами.ТекущиеДанные;

		ТекущиеДанные.ВидЗадолженности = ПредопределенноеЗначение("Перечисление.ВидыЗадолженности.Кредиторская");
		ТекущиеДанные.ТипКонтрагента   = ПредопределенноеЗначение("Перечисление.СтатусыКонтрагентов.Поставщик");
		ТекущиеДанные.РасчетыВозврат 	= ПредопределенноеЗначение("Перечисление.РасчетыВозврат.Расчеты");
		Если Не ЕстьНДС Тогда
			ТекущиеДанные.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность");
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	ПараметрыДокумента	= Новый Структура("РазделУчета, Организация",
		Объект.РазделУчета, Объект.Организация);

	Для каждого СтрокаТаблицы Из Объект.РасчетыСКонтрагентами Цикл

		ЗаполнитьДобавленныеКолонкиСтрокиТаблицы_РасчетыСКонтрагентами(СтрокаТаблицы, ПараметрыДокумента);

	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицы_РасчетыСКонтрагентами(СтрокаТаблицы, ПараметрыДокумента)
	
	СтрокаТаблицы.ДокументДоступность = ЗначениеЗаполнено(СтрокаТаблицы.ДоговорКонтрагента) И СтрокаТаблицы.ДоговорКонтрагента.ВедениеВзаиморасчетов <> Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом ;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
