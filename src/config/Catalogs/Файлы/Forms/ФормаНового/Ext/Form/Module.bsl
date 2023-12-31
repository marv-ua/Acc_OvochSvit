﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимСоздания = Параметры.РежимСоздания;
	
	Если Параметры.ДоступнаКомандаСканировать Тогда
		Если Параметры.ДоступнаКомандаСканировать Тогда
			Элементы.РежимСоздания.СписокВыбора.Добавить(3, НСтр("ru='Со сканера';uk='Зі сканера'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьФайлВыполнить()
	Закрыть(РежимСоздания);
КонецПроцедуры

#КонецОбласти