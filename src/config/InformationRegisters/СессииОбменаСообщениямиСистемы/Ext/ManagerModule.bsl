﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Создает новую сессию обмена сообщениями и возвращает ее идентификатор
//
Функция НоваяСессия() Экспорт
	
	Сессия = Новый УникальныйИдентификатор;
	
	СтруктураЗаписи = Новый Структура("Сессия, ДатаНачала", Сессия, ТекущаяУниверсальнаяДата());
	
	ДобавитьЗапись(СтруктураЗаписи);
	
	Возврат Сессия;
КонецФункции

// Получает статус сессии: Выполняется, Успешно, Ошибка.
//
Функция СтатусСессии(Знач Сессия) Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить(0, "Выполняется");
	Результат.Вставить(1, "Успешно");
	Результат.Вставить(2, "Ошибка");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА СессииОбменаСообщениямиСистемы.ЗавершенаСОшибкой
	|			ТОГДА 2
	|		КОГДА СессииОбменаСообщениямиСистемы.ЗавершенаУспешно
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Результат
	|ИЗ
	|	РегистрСведений.СессииОбменаСообщениямиСистемы КАК СессииОбменаСообщениямиСистемы
	|ГДЕ
	|	СессииОбменаСообщениямиСистемы.Сессия = &Сессия";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сессия", Сессия);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		СтрокаСообщения = НСтр("ru='Сессия обмена сообщениями системы ""%1"" не найдена.';uk='Сесія обміну повідомленнями системи ""%1"" не знайдено.'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, Строка(Сессия));
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Результат[Выборка.Результат];
КонецФункции

// Отмечает успешное выполнение сессии
//
Процедура ЗафиксироватьУспешноеВыполнениеСессии(Знач Сессия) Экспорт
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("Сессия", Сессия);
	СтруктураЗаписи.Вставить("ЗавершенаУспешно", Истина);
	СтруктураЗаписи.Вставить("ЗавершенаСОшибкой", Ложь);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

// Отмечает неуспешное выполнение сессии
//
Процедура ЗафиксироватьНеуспешноеВыполнениеСессии(Знач Сессия) Экспорт
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("Сессия", Сессия);
	СтруктураЗаписи.Вставить("ЗавершенаУспешно", Ложь);
	СтруктураЗаписи.Вставить("ЗавершенаСОшибкой", Истина);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

// Сохраняет данные сессии и отмечает успешное выполнение сессии
//
Процедура СохранитьДанныеСессии(Знач Сессия, Данные) Экспорт
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("Сессия", Сессия);
	СтруктураЗаписи.Вставить("Данные", Данные);
	СтруктураЗаписи.Вставить("ЗавершенаУспешно", Истина);
	СтруктураЗаписи.Вставить("ЗавершенаСОшибкой", Ложь);
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

// Получает данные сессии и удаляет сессию из информационной базы
//
Функция ПолучитьДанныеСессии(Знач Сессия) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СессииОбменаСообщениямиСистемы");
		ЭлементБлокировки.УстановитьЗначение("Сессия", Сессия);
		Блокировка.Заблокировать();
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	СессииОбменаСообщениямиСистемы.Данные КАК Данные
		|ИЗ
		|	РегистрСведений.СессииОбменаСообщениямиСистемы КАК СессииОбменаСообщениямиСистемы
		|ГДЕ
		|	СессииОбменаСообщениямиСистемы.Сессия = &Сессия";
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Сессия", Сессия);
		Запрос.Текст = ТекстЗапроса;
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			СтрокаСообщения = НСтр("ru='Сессия обмена сообщениями системы ""%1"" не найдена.';uk='Сесія обміну повідомленнями системи ""%1"" не знайдено.'");
			СтрокаСообщения = СтрШаблон(СтрокаСообщения, Строка(Сессия));
			ВызватьИсключение СтрокаСообщения;
		КонецЕсли;
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Результат = Выборка.Данные;
		
		УдалитьЗапись(Сессия);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

// Вспомогательные процедуры и функции

Процедура ДобавитьЗапись(СтруктураЗаписи)
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СессииОбменаСообщениямиСистемы");
	
КонецПроцедуры

Процедура ОбновитьЗапись(СтруктураЗаписи)
	
	ОбменДаннымиСервер.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "СессииОбменаСообщениямиСистемы");
	
КонецПроцедуры

Процедура УдалитьЗапись(Знач Сессия)
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(Новый Структура("Сессия", Сессия), "СессииОбменаСообщениямиСистемы");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли