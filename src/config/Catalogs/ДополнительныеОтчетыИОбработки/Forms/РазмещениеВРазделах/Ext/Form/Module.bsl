﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение таблицы доступных разделов.
	
	ИспользуемыеРазделы = Новый Массив;
	Если Параметры.ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
		ИспользуемыеРазделы = ДополнительныеОтчетыИОбработки.РазделыДополнительныхОбработок();
	Иначе
		ИспользуемыеРазделы = ДополнительныеОтчетыИОбработки.РазделыДополнительныхОтчетов();
	КонецЕсли;
	
	РабочийСтол = ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола();
	
	Для Каждого Раздел Из ИспользуемыеРазделы Цикл
		НоваяСтрока = Разделы.Добавить();
		Если Раздел = РабочийСтол Тогда
			НоваяСтрока.Раздел = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
		Иначе
			НоваяСтрока.Раздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Раздел);
		КонецЕсли;
		НоваяСтрока.Представление = ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(НоваяСтрока.Раздел);
	КонецЦикла;
	
	Разделы.Сортировать("Представление Возр");
	
	// Включение разделов
	
	Для Каждого ЭлементСписка Из Параметры.Разделы Цикл
		НайденнаяСтрока = Разделы.НайтиСтроки(Новый Структура("Раздел", ЭлементСписка.Значение));
		Если НайденнаяСтрока.Количество() = 1 Тогда
			НайденнаяСтрока[0].Используется = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	РезультатВыбора = Новый СписокЗначений;
	
	Для Каждого РазделЭлемент Из Разделы Цикл
		Если РазделЭлемент.Используется Тогда
			РезультатВыбора.Добавить(РазделЭлемент.Раздел);
		КонецЕсли;
	КонецЦикла;
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти
