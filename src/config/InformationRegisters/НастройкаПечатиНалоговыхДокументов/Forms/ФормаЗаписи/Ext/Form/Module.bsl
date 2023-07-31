﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Ключ.Пустой() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьРеквизитыФормы();

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Возврат;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Общие сведения


&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	ДатаОкончанияДействия = НайтиДатуОкончанияДействия(Запись.Период, Запись.Организация, Параметры.Ключ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)

	ДатаОкончанияДействия = НайтиДатуОкончанияДействия(Запись.Период, Запись.Организация, Параметры.Ключ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ЗаполнитьРеквизитыФормы();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиДатуОкончанияДействия(Знач ТекПериод, Знач ТекОрганизация, Знач КлючФормы)

	ДатаОкончания = ТекПериод;

	Запрос = Новый Запрос();

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	*
	|ИЗ
	|	РегистрСведений.НастройкаПечатиНалоговыхДокументов КАК Настройка";

	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Сортировать("Период");

	ДеревоНастройки = Новый ДеревоЗначений;
	ДеревоНастройки.Колонки.Добавить("Организация");
	ДеревоНастройки.Колонки.Добавить("Период");

	Для каждого Строка Из Результат Цикл
		НастройкаОрганизации = ДеревоНастройки.Строки.Найти(Строка.Организация, "Организация");
		Если НастройкаОрганизации = Неопределено Тогда
			НастройкаОрганизации = ДеревоНастройки.Строки.Добавить();
			НастройкаОрганизации.Организация = Строка.Организация;
		КонецЕсли;
		ПоПериоду = НастройкаОрганизации.Строки.Добавить();
		ПоПериоду.Период = Строка.Период;

		СтруктураНастройки = Новый Структура;
		Для Каждого Колонка Из Результат.Колонки Цикл
			СтруктураНастройки.Вставить(Колонка.Имя, Строка[Колонка.Имя]);
		КонецЦикла;

	КонецЦикла;	
	
	НастройкаОрганизации = ДеревоНастройки.Строки.Найти(ТекОрганизация, "Организация");
	Если НастройкаОрганизации <> Неопределено Тогда
		Для каждого СтрокаНастройки Из НастройкаОрганизации.Строки Цикл
			Если СтрокаНастройки.Период = КлючФормы.Период Тогда
				Продолжить;
			КонецЕсли;
			Если СтрокаНастройки.Период > ДатаОкончания Тогда
				ДатаОкончания = СтрокаНастройки.Период - 1;
				Возврат ДатаОкончания;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	ДатаОкончания = ?(ДатаОкончания = ТекПериод, КонецГода(ТекущаяДата()), КонецГода(ДатаОкончания));
	ДатаОкончания = ?(ТекПериод > ТекущаяДата(), КонецГода(ТекПериод), КонецГода(ДатаОкончания));

	Возврат ДатаОкончания;

КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()

	ДатаОкончанияДействия = НайтиДатуОкончанияДействия(Запись.Период, Запись.Организация, Параметры.Ключ);
	
КонецПроцедуры
