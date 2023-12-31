﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СхемаКомпоновкиДанных = Параметры.СхемаКомпоновкиДанных;
	Настройки = Параметры.Настройки;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	КомпоновщикНастроек.Восстановить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьКнопка(Команда)
	
	ДопПараметры = Новый Структура("Настройки", КомпоновщикНастроек.Настройки);
	Закрыть(ДопПараметры);
	
КонецПроцедуры

#КонецОбласти

