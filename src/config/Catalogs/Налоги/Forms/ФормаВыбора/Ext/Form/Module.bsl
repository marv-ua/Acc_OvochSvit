﻿#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокОтбора") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка", Параметры.СписокОтбора, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти   