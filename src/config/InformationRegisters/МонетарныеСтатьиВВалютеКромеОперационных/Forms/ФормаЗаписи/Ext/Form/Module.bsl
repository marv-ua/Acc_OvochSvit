﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьЗаголовкиИДоступностьСубконто();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	УстановитьЗаголовкиИДоступностьСубконто();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьЗаголовкиИДоступностьСубконто()

	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1", "Субконто2", "Субконто3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1", "ЗаголовокСубконто2", "ЗаголовокСубконто3"); 
		
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Запись.Счет, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);

КонецПроцедуры
