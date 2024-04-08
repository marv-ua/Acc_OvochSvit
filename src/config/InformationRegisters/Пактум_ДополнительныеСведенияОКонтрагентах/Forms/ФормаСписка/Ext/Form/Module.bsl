﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ИД") Тогда
		ЕстьОтбор = Ложь;
		Для Каждого Эл Из Список.Отбор.Элементы Цикл
			Если Строка(Эл) = "Контрагент" Тогда
				ЕстьОтбор = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ЕстьОтбор Тогда
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Контрагент");
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.ПравоеЗначение = Параметры.Контрагент;
	        ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		
		Отбор = Новый Структура;
		Отбор.Вставить("ИД", Параметры.ИД);
		Отбор.Вставить("Контрагент", Параметры.Контрагент);
	    КлючЗаписи = РегистрыСведений.Пактум_ДополнительныеСведенияОКонтрагентах.СоздатьКлючЗаписи(Отбор);
		Элементы.Список.ТекущаяСтрока = КлючЗаписи; 
	КонецЕсли;
КонецПроцедуры
