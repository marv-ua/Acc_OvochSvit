﻿
&НаКлиенте
Процедура КонтрагентыЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Закрыть(Элементы.Контрагенты.ТекущиеДанные.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Элементы.Контрагенты.ТекущиеДанные.Значение);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокВыбораКонтрагентов") тогда
		Для Каждого ТекКонтрагент из Параметры.СписокВыбораКонтрагентов Цикл
			
			НовСтр = ЭтотОбъект.Контрагенты.Добавить();
			НовСтр.Значение = ТекКонтрагент.Значение;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
