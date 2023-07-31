﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список документов, реквизиты которых входят в состав критерия отбора
//
// Возвращаемое значение:
// Массив объектов метаданных
//
Функция СоставДокументов() Экспорт
	
	СписокДокументов = Новый Массив;
	
	МетаданныеКритерия = Метаданные.КритерииОтбора.ДокументыПоКонтрагенту;
	
	Для Каждого МетаданныеРеквизита Из МетаданныеКритерия.Состав Цикл
		Родитель = МетаданныеРеквизита.Родитель();
		Если Метаданные.Документы.Содержит(Родитель) Тогда
			Если СписокДокументов.Найти(Родитель) = Неопределено Тогда
				СписокДокументов.Добавить(Родитель);
			КонецЕсли;
		Иначе
			РодительРодителя = Родитель.Родитель();
			Если Метаданные.Документы.Содержит(РодительРодителя) Тогда
				Если СписокДокументов.Найти(РодительРодителя) = Неопределено Тогда
					СписокДокументов.Добавить(РодительРодителя);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокДокументов;
	
КонецФункции

#КонецОбласти

#КонецЕсли