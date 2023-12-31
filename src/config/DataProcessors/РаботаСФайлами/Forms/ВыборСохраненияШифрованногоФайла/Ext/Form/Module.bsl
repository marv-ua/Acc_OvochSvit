﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СохранятьСРасшифровкой = 1;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		МодульЭлектроннаяПодписьКлиентСервер =
			ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьКлиентСервер");
		
		РасширениеДляЗашифрованныхФайлов = 
			МодульЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки().РасширениеДляЗашифрованныхФайлов;
	Иначе
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранятьСРасшифровкой", "ВидПереключателя", ВидПереключателя.Переключатель);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаСохранитьФайл", "Отображение", ОтображениеКнопки.Картинка);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОтмена", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("СохранятьСРасшифровкой", СохранятьСРасшифровкой);
	СтруктураВозврата.Вставить("РасширениеДляЗашифрованныхФайлов", РасширениеДляЗашифрованныхФайлов);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти
