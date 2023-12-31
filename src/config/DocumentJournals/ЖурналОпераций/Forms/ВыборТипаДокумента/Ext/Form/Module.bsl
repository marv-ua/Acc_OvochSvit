﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоВводНаОсновании = ЗначениеЗаполнено(Параметры.Основание);
	
	ТипыДокументовРазрешенные = Неопределено;
	Если Параметры.КлючНазначенияИспользования = "ДокументыПокупателей"
		Или Параметры.КлючНазначенияИспользования = "ДокументыПоставщиков" Тогда
		
		ТипыДокументовРазрешенные = ЖурналыДокументов.ЖурналОпераций.СписокТиповПоНазначениюИспользования(
			Параметры.КлючНазначенияИспользования);
			
	КонецЕсли;
	
	Если ЭтоВводНаОсновании Тогда
		МетаданныеОснование = Параметры.Основание.Метаданные();
		Если ТипыДокументовРазрешенные = Неопределено Тогда // доступен полный набор типов
			Для Каждого ОбъектМетаданных Из Метаданные.Документы Цикл
				
				Если ОбъектМетаданных.ВводитсяНаОсновании.Содержит(МетаданныеОснование) 
					И ПравоДоступа("Изменение", ОбъектМетаданных)
					И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
					ТипыДокументов.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Синоним);
				КонецЕсли;
			КонецЦикла;
			
		Иначе // доступен ограниченный набор типов
			
			Для Каждого ОбъектМетаданныхТип Из ТипыДокументовРазрешенные Цикл 
				
				ОбъектМетаданных = Метаданные.НайтиПоТипу(ОбъектМетаданныхТип);
				Если ОбъектМетаданных.ВводитсяНаОсновании.Содержит(МетаданныеОснование) 
				   И ПравоДоступа("Изменение", ОбъектМетаданных)
				   И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
					ТипыДокументов.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Синоним);
				КонецЕсли;
				
			КонецЦикла;	
		КонецЕсли;
		
	Иначе	
		
		ДокументыЖурнала = ЖурналыДокументов.ЖурналОпераций.СоставДокументов(Параметры.КлючНазначенияИспользования);
		Для Каждого ОбъектМетаданных Из ДокументыЖурнала Цикл
			Если ПравоДоступа("Изменение", ОбъектМетаданных) Тогда
				ТипыДокументов.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Синоним);
			КонецЕсли;
		КонецЦикла;
	
	КонецЕсли;
	
	Если ТипыДокументов.Количество() = 0 Тогда
		Если ЭтоВводНаОсновании Тогда
		 	ВызватьИсключение НСтр("ru='Команда не может быть выполнена для указанного объекта.';uk=""Команда не може бути виконана для зазначеного об'єкта.""");
		Иначе
		 	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Нарушение прав доступа!';uk='Порушення прав доступу!'"), , , , Отказ);
		КонецЕсли;  
		Возврат;
	КонецЕсли;
	
	ТипыДокументов.СортироватьПоПредставлению();
	
	// Установка текущей строки списка
	Если ЗначениеЗаполнено(Параметры.НачальноеЗначение) Тогда
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Параметры.НачальноеЗначение);
		Если ОбъектМетаданных <> Неопределено Тогда
			ТекущаяСтрока = ТипыДокументов.НайтиПоЗначению(ОбъектМетаданных.Имя);
			Если ТекущаяСтрока <> Неопределено Тогда
				Элементы.ТипыДокументов.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТипыДокументов

&НаКлиенте
Процедура ТипыДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТипыДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ТекущиеДанные = Элементы.ТипыДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
