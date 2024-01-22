﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ФормаВыбратьСРегионом.Видимость = Ложь;
	
	Если Параметры.Свойство("ИмяФормы") Тогда
		
		Заголовок = Параметры.ИмяФормы;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Регион") Тогда
		
		Регион = Параметры.Регион;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") Тогда
		
		Основание = Параметры.Основание;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ДопПараметры") Тогда
		
		ДопПараметры = Параметры.ДопПараметры;
		
		Если ЗначениеЗаполнено(Регион) Тогда
			Элементы.ФормаВыбрать.Видимость = Ложь;
			Элементы.ФормаВыбратьСРегионом.Видимость = Истина;
			Элементы.Переместить(Элементы.ФормаВыбратьСРегионом, Элементы.ФормаВыбрать.Родитель, Элементы.ФормаВыбрать);
			Элементы.ФормаВыбратьСРегионом.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Регион) И ЗначениеЗаполнено(ДопПараметры) Тогда
		СтандартнаяОбработка = Ложь;
		Новый_Выбрать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСРегионом(Команда)
	Новый_Выбрать();
КонецПроцедуры

&НаКлиенте
Процедура Новый_Выбрать()
	
	Закрыть(Новый Структура("Регион,Ссылка", Регион, Элементы.Список.ТекущиеДанные.Ссылка));
	
КонецПроцедуры

