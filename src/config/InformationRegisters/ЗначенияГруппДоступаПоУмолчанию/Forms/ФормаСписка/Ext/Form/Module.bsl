﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
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
Процедура ОбновитьДанныеРегистраНаСервере(ЕстьИзменения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(, ЕстьИзменения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Очистить();
	ТипыЗначенийДоступа = Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип.Типы();
	
	Для Каждого Тип Из ТипыЗначенийДоступа Цикл
		Типы = Новый Массив;
		Типы.Добавить(Тип);
		ОписаниеТипа = Новый ОписаниеТипов(Типы);
		ПустаяСсылкаТипа = ОписаниеТипа.ПривестиЗначение(Неопределено);
		
		// Оформление.
		ЭлементОформления = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		ЭлементОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", Строка(Тип));
		
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТипЗначенийДоступа");
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ПустаяСсылкаТипа;
		ЭлементОтбора.Использование  = Истина;
		
		ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
		ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТипЗначенийДоступа");
		ЭлементПоля.Использование = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
