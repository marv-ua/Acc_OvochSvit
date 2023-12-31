﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьСкладПоУмолчанию(Пользователь = Неопределено) Экспорт
	
	ЗначениеПоУмолчанию = Справочники.Склады.ПустаяСсылка();
	
	// По умолчанию берем основной склад пользователя.
	ОсновнойСклад = ХранилищеОбщихНастроек.Загрузить("ОсновнойСклад",,, Пользователь);
	
	Если ТипЗнч(ОсновнойСклад) = ТипЗнч(ЗначениеПоУмолчанию) 
		И ОбщегоНазначения.СсылкаСуществует(ОсновнойСклад) Тогда
		ЗначениеПоУмолчанию = ОсновнойСклад;
	Иначе
		// Ведется учет по единственному складу
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		
		"ВЫБРАТЬ ПЕРВЫЕ 2
		|	Склады.Ссылка КАК Склад
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	НЕ Склады.ЭтоГруппа";
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Если Выборка.Количество() = 1 Тогда
				Если Выборка.Следующий() Тогда
					ЗначениеПоУмолчанию = Выборка.Склад;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти	
	
#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли