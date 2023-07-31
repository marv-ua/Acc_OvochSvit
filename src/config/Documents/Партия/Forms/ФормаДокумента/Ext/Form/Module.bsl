﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		УстановитьДоговорКонтрагента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	УстановитьДоговорКонтрагента();

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	ДанныеОбъекта = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, ВалютаДокумента");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	ДоговорКонтрагентаПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);

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

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоговорКонтрагента()

	ДанныеОбъекта = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, ВалютаДокумента");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	УстановитьДоговорКонтрагентаНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьДоговорКонтрагентаНаСервере(ДанныеОбъекта)

	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(ДанныеОбъекта.ДоговорКонтрагента, ДанныеОбъекта.Контрагент, ДанныеОбъекта.Организация);
	
	ДоговорКонтрагентаПриИзмененииНаСервере(ДанныеОбъекта);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДоговорКонтрагентаПриИзмененииНаСервере(ДанныеОбъекта)

	Если ЗначениеЗаполнено(ДанныеОбъекта.ДоговорКонтрагента) Тогда
		СвойстваДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеОбъекта.ДоговорКонтрагента, "ВалютаВзаиморасчетов");
		ДанныеОбъекта.ВалютаДокумента = СвойстваДоговора.ВалютаВзаиморасчетов;
	Иначе
		ДанныеОбъекта.ВалютаДокумента       = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
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