﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Незачислено") Тогда
		ДанныеЗаполнения = Документы.ВедомостьНаВыплатуЗарплатыВБанк.ДанныеЗаполненияНезачисленнымиСтроками();
		ДанныеЗаполнения.Ведомость	= Параметры.Незачислено.Ведомость;
		ДанныеЗаполнения.Физлица	= Параметры.Незачислено.Физлица;
		Ведомость = РеквизитФормыВЗначение ("Объект");
		Ведомость.Заполнить(ДанныеЗаполнения);
		ЗначениеВРеквизитФормы(Ведомость, "Объект");
	КонецЕсли;
	
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

	ВзаиморасчетыССотрудникамиФормы.ВедомостьПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьПриОткрытии(ЭтаФорма, Отказ);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ВзаиморасчетыССотрудникамиФормы.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыплатыПриИзменении(Элемент)
	
	СпособВыплатыПриИзмененииНаСервере();
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьСпособВыплатыПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиент.КомментарийНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка)
КонецПроцедуры

///////////////////////////////////////////////////////
// редактирование месяца строкой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	ПериодРегистрацииПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	ПериодРегистрацииПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
	ПериодРегистрацииПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыЗарплата 

&НаКлиенте
Процедура ЗарплатаПриАктивизацииСтроки(Элемент)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьЗарплатаПриАктивизацииСтроки(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьЗарплатаПриНачалеРедактирования(ЭтаФорма, Элемент, НоваяСтрока, Копирование)
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаКВыплатеПриИзменении(Элемент)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьЗарплатаКВыплатеПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаСотрудникПриИзменении(Элемент)
	Элементы.Зарплата.ТекущиеДанные.НомерЛицевогоСчета = НомерЛицевогоСчетаПоСотруднику(
		Элементы.Зарплата.ТекущиеДанные.Сотрудник,
		Объект.Организация,
		Объект.ЗарплатныйПроект,
		Объект.ПериодРегистрации)
КонецПроцедуры
	
&НаКлиенте
Процедура ЗарплатаПодробноПриИзменении(Элемент)
	
	ЗарплатаПодробноПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗарплатаПодробноПриИзмененииНаСервере()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТЗПодробно = ТекущийОбъект.ЗарплатаПодробно.Выгрузить();
	ТЗПодробно.Свернуть("ФизическоеЛицо","КВыплате");
	
	ТЗПодробно.Колонки.Добавить("НомерЛицевогоСчета");
	
	МассивФизическихЛиц = ТЗПодробно.ВыгрузитьКолонку("ФизическоеЛицо");
	
	МассивСотрудников = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(МассивФизическихЛиц, Истина, ТекущийОбъект.Организация, ТекущийОбъект.Дата).ВыгрузитьКолонку("Сотрудник");
	
	ЛицевыеСчетаСотрудников = ЗарплатныеПроекты.ЛицевыеСчетаСотрудников(МассивСотрудников, Истина, ТекущийОбъект.Организация, ТекущийОбъект.ПериодРегистрации, ТекущийОбъект.ЗарплатныйПроект);
	
	Для Каждого СтрокаТЧ Из ТЗПодробно Цикл
		СтрокаЛС = ЛицевыеСчетаСотрудников.Найти(СтрокаТЧ.ФизическоеЛицо, "ФизическоеЛицо");
		Если СтрокаЛС = Неопределено Тогда
			СтрокаТЧ.НомерЛицевогоСчета = "";
		Иначе
			СтрокаТЧ.НомерЛицевогоСчета = СтрокаЛС.НомерЛицевогоСчета
		КонецЕсли
	КонецЦикла;
	
	
	ТекущийОбъект.Зарплата.Загрузить(ТЗПодробно);
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");

	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьЗаполнить(ЭтаФорма);
	ПослеЗаполненияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда) Экспорт
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьРассчитать(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьНалоги(Команда) Экспорт
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьРассчитатьНалоги(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыРасчетаИзменить(Команда)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьПараметрыРасчетаИзменить(ЭтаФорма, Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПослеЗаполненияНаСервере()
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов()
	
	Если ЕстьЗаполненныеТабличныеЧасти() Тогда
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.Отображать;
	Иначе
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	КонецЕсли;
	
	Элементы.Организация.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	Элементы.ПодразделениеОрганизации.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	Элементы.ПериодРегистрации.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	Элементы.ЗарплатныйПроект.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	Элементы.СпособВыплаты.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	
КонецПроцедуры

&НаСервере
Функция ЕстьЗаполненныеТабличныеЧасти()
	
	ДанныеВТЧЕсть = Ложь;
	
	СписокТабличныхЧастей = СписокТабличныхЧастейДокумента();
	
	Для каждого ИмяТабличнойЧасти Из СписокТабличныхЧастей Цикл
		Если Объект[ИмяТабличнойЧасти].Количество() > 0 Тогда
			ДанныеВТЧЕсть = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат ДанныеВТЧЕсть;
	
КонецФункции

&НаСервере
Функция СписокТабличныхЧастейДокумента()
	
	СписокТабличныхЧастей = Новый Массив;
	
	СписокТабличныхЧастей.Добавить("Зарплата");
	СписокТабличныхЧастей.Добавить("ЗарплатаПодробно");
	СписокТабличныхЧастей.Добавить("НДФЛ");
	СписокТабличныхЧастей.Добавить("Взносы");
	СписокТабличныхЧастей.Добавить("ВзносыФОТ");
	
	Возврат СписокТабличныхЧастей;
	
КонецФункции

&НаСервере
Процедура ОчиститьТабличныеЧасти()
	
	СписокТабличныхЧастей = СписокТабличныхЧастейДокумента();
	
	Для каждого ИмяТабличнойЧасти Из СписокТабличныхЧастей Цикл
		Объект[ИмяТабличнойЧасти].Очистить();
	КонецЦикла;
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

///////////////////////////////////////////////////////
// Вызовы сервера

&НаСервере
Процедура ЗаполнитьНаСервере() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьЗаполнитьНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура РассчитатьНаСервере() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьРассчитатьНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура РассчитатьНалогиНаСервере() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьРассчитатьНалогиНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервереБезКонтекста
Функция НомерЛицевогоСчетаПоСотруднику(Сотрудник, Организация, ЗарплатныйПроект, ПериодРегистрации)
	
	Если НЕ ЗначениеЗаполнено(ЗарплатныйПроект) Тогда
		Возврат ""
	КонецЕсли;
	
	СписокСотрудников = Новый Массив;
	СписокСотрудников.Добавить(Сотрудник);
	
	ЛицевыеСчетаСотрудников = ЗарплатныеПроекты.ЛицевыеСчетаСотрудников(СписокСотрудников, Истина, Организация, ПериодРегистрации, ЗарплатныйПроект);
	
	Если ЛицевыеСчетаСотрудников.Количество() = 0 Тогда
		Возврат ""
	Иначе
		Возврат ЛицевыеСчетаСотрудников[0].НомерЛицевогоСчета
	КонецЕсли
	
КонецФункции

///////////////////////////////////////////////////////
// Обратные вызовы

&НаСервере
Процедура ОбработатьСообщенияПользователю() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьОбработатьСообщенияПользователю(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьУстановитьДоступностьЭлементов(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьУстановитьПредставлениеПараметровРасчета(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьОрганизацияПриИзмененииНаСервере(ЭтаФорма);  
	Объект.Округление = УчетЗарплаты.СпособОкругления(Объект.Организация);
	ОчиститьТабличныеЧасти();
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатныйПроектПриИзменении(Элемент)
	ЗарплатныйПроектПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗарплатныйПроектПриИзмененииНаСервере()
	ОчиститьТабличныеЧасти();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОрганизацииПриИзменении(Элемент)
	ПодразделениеОрганизацииПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодразделениеОрганизацииПриИзмененииНаСервере()
	ОчиститьТабличныеЧасти();
КонецПроцедуры

&НаСервере
Процедура СпособВыплатыПриИзмененииНаСервере()
	ЭтаФорма.РассчитыватьНалоги = ЭтаФорма.Объект.СпособВыплаты.РасчитыватьВзносы;
	ОчиститьТабличныеЧасти();
КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзмененииНаСервере()
	ОчиститьТабличныеЧасти();
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