﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеРегистра(Команда)
	
	ЕстьИзменения = Ложь;
	
	ОбновитьДанныеРегистраНаСервере(ЕстьИзменения);
	
	Если ЕстьИзменения Тогда
		Текст = НСтр("ru='Обновление выполнено успешно.';uk='Оновлення виконане успішно.'");
	Иначе
		Текст = НСтр("ru='Обновление не требуется.';uk='Оновлення не потрібно.'");
	КонецЕсли;
	
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Очистить();
	
	ОформитьГруппуДанных(0, НСтр("ru='Стандартные значения доступа';uk='Стандартні значення доступу'"));
	ОформитьГруппуДанных(1, НСтр("ru='Обычные/внешние пользователи';uk='Звичайні/зовнішні користувачі'"));
	ОформитьГруппуДанных(2, НСтр("ru='Обычные/внешние группы пользователей';uk='Звичайні/зовнішні групи користувачів'"));
	ОформитьГруппуДанных(3, НСтр("ru='Группы исполнителей';uk='Групи виконавців'"));
	ОформитьГруппуДанных(4, НСтр("ru='Объекты авторизации';uk='Об''єкти авторизації'"));
	
КонецПроцедуры

&НаСервере
Процедура ОформитьГруппуДанных(ГруппаДанных, Текст)
	
	ЭлементОформления = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ГруппаДанных");
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппаДанных");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = ГруппаДанных;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", Текст);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеРегистраНаСервере(ЕстьИзменения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегистрыСведений.ГруппыЗначенийДоступа.ОбновитьДанныеРегистра(ЕстьИзменения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
