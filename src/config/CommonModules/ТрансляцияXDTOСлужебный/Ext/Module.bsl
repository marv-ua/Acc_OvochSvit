﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание версии сообщения. Возвращаемое значение используется для передачи
// в качестве параметров ОписаниеИсходнойВерсии и ОписаниеРезультирующейВерсии.
// Процедуры НайтиЦепочкиТрансляции().
//
// Параметры:
//  Номер - строка, номер версии сообщения в формате РР.{П|ПП}.ЗЗ.СС,
//  Пакет - строка, пространство имен версии сообщения.
//
// Возвращаемое значение:
//  Структура(Номер, Пакет).
//
Функция СформироватьОписаниеВерсии(Номер = Неопределено, Пакет = Неопределено) Экспорт
	
	Возврат Новый Структура("Номер, Пакет", Номер, Пакет);
	
КонецФункции // СформироватьОписаниеВерсии()

// Для внутреннего использования.
Функция ПолучитьИнтерфейсСообщения(Знач Сообщение) Экспорт
	
	ПакетыИсходногоСообщения = ПолучитьПакетыСообщения(Сообщение);
	ЗарегистрированныеИнтерфейсы = ИнтерфейсыСообщенийВМоделиСервиса.ПолучитьИнтерфейсыОтправляемыхСообщений();
	
	Для Каждого ПакетИсходногоСообщения Из ПакетыИсходногоСообщения Цикл
		
		ИнтерфейсСообщения = ЗарегистрированныеИнтерфейсы.Получить(ПакетИсходногоСообщения);
		Если ЗначениеЗаполнено(ИнтерфейсСообщения) Тогда
			
			Возврат Новый Структура("ПрограммныйИнтерфейс, ПространствоИмен", ИнтерфейсСообщения, ПакетИсходногоСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

// Для внутреннего использования.
Функция ВыполнитьТрансляцию(Знач ИсходныйОбъект, Знач ОписаниеИсходнойВерсии, Знач ОписаниеРезультирующейВерсии) Экспорт
	
	ЦепочкаТрансляцииИнтерфейса = ПолучитьЦепочкуТрансляции(
			ОписаниеИсходнойВерсии,
			ОписаниеРезультирующейВерсии);
	Если ЦепочкаТрансляцииИнтерфейса = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='В конфигурации не зарегистрирован обработчик трансляции из версии %1 в версию %2.';uk='У конфігурації не зареєстрований обробник трансляції з версії %1 у версію %2.'"),
			СформироватьПредставлениеВерсии(ОписаниеИсходнойВерсии),
			СформироватьПредставлениеВерсии(ОписаниеРезультирующейВерсии));
	Иначе
		
		ТаблицаТрансляцииИнтерфейса = Новый ТаблицаЗначений();
		ТаблицаТрансляцииИнтерфейса.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка"));
		ТаблицаТрансляцииИнтерфейса.Колонки.Добавить("Значение", Новый ОписаниеТипов("ОбщийМодуль"));
		ТаблицаТрансляцииИнтерфейса.Колонки.Добавить("ВерсияЧислом", Новый ОписаниеТипов("Число"));
		
		Для Каждого ЭтапТрансляцииИнтерфейса Из ЦепочкаТрансляцииИнтерфейса Цикл
			
			ЭтапТаблицы = ТаблицаТрансляцииИнтерфейса.Добавить();
			ЗаполнитьЗначенияСвойств(ЭтапТаблицы, ЭтапТрансляцииИнтерфейса);
			Версия = ЭтапТрансляцииИнтерфейса.Значение.РезультирующаяВерсия();
			Разряды = СтрРазделить(Версия, ".");
			Итератор = 0;
			ВерсияЧислом = 0;
			Для Каждого Разряд Из Разряды Цикл
				
				ВерсияЧислом = ВерсияЧислом + (Число(Разряд) * Pow(1000, Разряды.Количество() - Итератор));
				Итератор = Итератор + 1;
				
			КонецЦикла;
			ЭтапТаблицы.ВерсияЧислом = ВерсияЧислом;
			
		КонецЦикла;
		
		ТаблицаТрансляцииИнтерфейса.Сортировать("ВерсияЧислом Убыв");
		
	КонецЕсли;
	
	Для Каждого ЭтапТрансляцииИнтерфейса Из ТаблицаТрансляцииИнтерфейса Цикл
		
		Обработчик = ЭтапТрансляцииИнтерфейса.Значение;
		
		ВыполнятьСтандартнуюОбработку = Истина;
		Обработчик.ПередТрансляцией(ИсходныйОбъект, ВыполнятьСтандартнуюОбработку);
		
		Если ВыполнятьСтандартнуюОбработку Тогда
			ПравилаТрансляцииИнтерфейсов = СформироватьПравилаТрансляцииИнтерфейсов(ИсходныйОбъект, ЭтапТрансляцииИнтерфейса);
			ИсходныйОбъект = ТранслироватьОбъект(ИсходныйОбъект, ПравилаТрансляцииИнтерфейсов);
		Иначе
			ИсходныйОбъект = Обработчик.ТрансляцияСообщения(ИсходныйОбъект);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИсходныйОбъект;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает пакеты, входящие в зависимости исходного пакета.
//
// Параметры:
//  ПакетОбъектаСообщения - строка, пространство имен пакета, для которого выполняется
//    поиск зависимостей.
//
// Возвращаемое значение:
//  ФиксированныйМассив, элементы - строка.
//
Функция ПолучитьЗависимостиПакета(Знач ПакетОбъектаСообщения)
	
	Результат = Новый Массив();
	ЗависимостиПакета = ФабрикаXDTO.Пакеты.Получить(ПакетОбъектаСообщения).Зависимости;
	Для Каждого Зависимость Из ЗависимостиПакета Цикл
		
		ПакетЗависимостиСообщения = Зависимость.URIПространстваИмен;
		Результат.Добавить(ПакетЗависимостиСообщения);
		ВложенныеЗависимости = ПолучитьЗависимостиПакета(ПакетЗависимостиСообщения);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, ВложенныеЗависимости, Истина);
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Возвращает цепочку выполнения обработчиков трансляции между версиями интерфейса сообщений.
//  Если в конфигурации зарегистрировано несколько возможных цепочек трансляции между версиями
//  интерфейса сообщений - вернет оптимальную (содержащую меньшее число этапов).
//
// Параметры:
//  ОписаниеИсходнойВерсии - Структура, описание исходной версии транслируемого сообщения,
//      достаточное для однозначного определения обработчиков в таблице трансляции.
//    Поля структуры:
//      Номер - строка, исходная версия сообщения в формате РР.{П|ПП}.ЗЗ.СС,
//      Пакет - строка, пространство имен исходной версии сообщения,
//  ОписаниеРезультирующейВерсии - Структура, описание результирующей версии, в которую
//      требуется транслировать сообщение, достаточное для однозначного определения
//      обработчиков в таблице трансляции.
//    Поля структуры:
//      Номер - строка, результирующая версия сообщения в 
//        формате РР.{П|ПП}.ЗЗ.СС,
//      Пакет - строка, пространство имен результирующей версии
//        сообщения.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие:
//    Ключ - Пакет результирующей версии сообщения.
//    Значение - ОбщийМодуль, обработчик трансляции.
//
Функция ПолучитьЦепочкуТрансляции(Знач ОписаниеИсходнойВерсии, Знач ОписаниеРезультирующейВерсии)
	
	ЗарегистрированныеОбработчикиТрансляции = ПолучитьОбработчикиТрансляции();
	
	ЦепочкиТрансляции = Новый Массив();
	НайтиЦепочкиТрансляции(
			ЗарегистрированныеОбработчикиТрансляции,
			ОписаниеИсходнойВерсии,
			ОписаниеРезультирующейВерсии,
			ЦепочкиТрансляции);
	
	Если ЦепочкиТрансляции.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат ВыбратьЦепочкуТрансляции(ЦепочкиТрансляции);
	КонецЕсли;
	
КонецФункции

// При наличии нескольких цепочек трансляции сообщения из одной версии в другую,
// возвращает наиболее оптимальную (содержащую меньше всего этапов).
//
// Параметры:
//  ЦепочкиТрансляции - Массив, полученные в результате работы функции НайтиЦепочкиТрансляции().
//
// Возвращаемое значение:
//  ТаблицаЗначений - элемент массива, цепочка трансляции, содержащая наименьшее количество этапов.
Функция ВыбратьЦепочкуТрансляции(Знач ЦепочкиТрансляции)
	
	Если ЦепочкиТрансляции.Количество() = 1 Тогда
		Возврат ЦепочкиТрансляции.Получить(0);
	Иначе
		
		ТекущийВыбор = Неопределено;
		
		Для Каждого ЦепочкаТрансляции Из ЦепочкиТрансляции Цикл
			
			Если ТекущийВыбор = Неопределено Тогда
				ТекущийВыбор = ЦепочкаТрансляции;
			Иначе
				ТекущийВыбор = ?(ЦепочкаТрансляции.Количество() < ТекущийВыбор.Количество(),
						ЦепочкаТрансляции, ТекущийВыбор);
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат ТекущийВыбор;
		
	КонецЕсли;
	
КонецФункции

// Формирует человекочитаемое представление версии интерфейса сообщений.
//
// Параметры:
//  ОписаниеВерсии - Структура, результат выполнения функции СформироватьОписаниеВерсии().
//
// Возвращаемое значение: строка.
//
Функция СформироватьПредставлениеВерсии(ОписаниеВерсии)
	
	Результат = "";
	
	Если ЗначениеЗаполнено(ОписаниеВерсии.Номер) Тогда
		
		Результат = ОписаниеВерсии.Номер;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеВерсии.Пакет) Тогда
		
		ПредставлениеПакета = "{" + ОписаниеВерсии.Пакет + "}";
		
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + " (" +  ПредставлениеПакета + ")";
		Иначе
			Результат = ПредставлениеПакета;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Для внутреннего использования.
Функция ТранслироватьОбъект(Знач Объект, Знач ПравилаТрансляцииИнтерфейсов)
	
	ПакетИсходногоОбъекта = Объект.Тип().URIПространстваИмен;
	ЦепочкаТрансляцииИнтерфейса = ПравилаТрансляцииИнтерфейсов.Получить(ПакетИсходногоОбъекта);
	
	Если ЦепочкаТрансляцииИнтерфейса = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось определить обработчик трансляции для пакета {%1}, невозможно выполнение стандартной трансляции для обработки данного свойства';uk='Не вдалося визначити обробник трансляції для пакета {%1}, неможливо виконання стандартної трансляції для обробки цієї властивості'"), 
			ПакетИсходногоОбъекта);
	КонецЕсли;
	
	Если ЦепочкаТрансляцииИнтерфейса.Количество() > 0 Тогда
		
		Для Каждого ИтерацияТрансляции Из ЦепочкаТрансляцииИнтерфейса Цикл
			
			Обработчик = ИтерацияТрансляции.Значение;
			
			ВыполнятьСтандартнуюОбработку = Истина;
			Обработчик.ПередТрансляцией(Объект, ВыполнятьСтандартнуюОбработку);
			
			Если ВыполнятьСтандартнуюОбработку Тогда
				Объект = СтандартнаяОбработка(Объект, Обработчик.ПакетРезультирующейВерсии(), ПравилаТрансляцииИнтерфейсов);
			Иначе
				Объект = Обработчик.ТрансляцияСообщения(Объект);
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		// Отсутствие итераций в цепочке трансляции означает, что версия не изменилась, и нужно просто
		// скопировать значения свойств исходного объекта в результирующий объект.
		Объект = СтандартнаяОбработка(Объект, Объект.Тип().URIПространстваИмен, ПравилаТрансляцииИнтерфейсов);
		
	КонецЕсли;
	
	Возврат Объект;
	
КонецФункции

// Для внутреннего использования.
Функция СтандартнаяОбработка(Знач Объект, Знач ПакетРезультирующегоОбъекта, Знач ПравилаТрансляцииИнтерфейсов)
	
	ТипИсходногоОбъекта = Объект.Тип();
	Если ТипИсходногоОбъекта.URIПространстваИмен = ПакетРезультирующегоОбъекта Тогда
		ТипРезультирующегоОбъекта = ТипИсходногоОбъекта;
	Иначе
		ТипРезультирующегоОбъекта = ФабрикаXDTO.Тип(ПакетРезультирующегоОбъекта, ТипИсходногоОбъекта.Имя);
		Если ТипРезультирующегоОбъекта = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось выполнить стандартную обработку трансляции типа %1 в пакет %2: тип %1 не существует в пакете %2.';uk='Не вдалося виконати стандартну обробку трансляції типу %1 у пакет %2: тип %1 не існує у пакеті %2.'"),
				"{" + ТипИсходногоОбъекта.URIПространстваИмен + "}" + ТипИсходногоОбъекта.Имя,
				"{" + ПакетРезультирующегоОбъекта + "}");
		КонецЕсли;
	КонецЕсли;
		
	РезультирующийОбъект = ФабрикаXDTO.Создать(ТипРезультирующегоОбъекта);
	СвойстваИсходногоОбъекта = Объект.Свойства();
	
	Для Каждого Свойство Из ТипРезультирующегоОбъекта.Свойства Цикл
		
		СвойствоОригинала = ТипИсходногоОбъекта.Свойства.Получить(Свойство.ЛокальноеИмя);
		Если СвойствоОригинала = Неопределено Тогда
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось выполнить стандартную обработку конвертации типа %1 в тип %2: свойство %3 не определено для типа %1.';uk='Не вдалося виконати стандартну обробку конвертації типу %1 у тип %2: властивість %3 не визначена для типу %1.'"),
				"{" + ТипИсходногоОбъекта.URIПространстваИмен + "}" + ТипИсходногоОбъекта.Имя,
				"{" + ТипРезультирующегоОбъекта.URIПространстваИмен + "}" + ТипРезультирующегоОбъекта.Имя,
				Свойство.ЛокальноеИмя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Свойство Из ТипИсходногоОбъекта.Свойства Цикл
		
		ТранслируемоеСвойство = ТипРезультирующегоОбъекта.Свойства.Получить(Свойство.ЛокальноеИмя);
		Если ТранслируемоеСвойство = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось выполнить стандартную обработку конвертации типа %1 в тип %2: свойство %3 не определено для типа %2.';uk='Не вдалося виконати стандартну обробку конвертації типу %1 у тип %2: властивість %3 не визначена для типу %2.'"),
				"{" + ТипИсходногоОбъекта.URIПространстваИмен + "}" + ТипИсходногоОбъекта.Имя,
				"{" + ТипРезультирующегоОбъекта.URIПространстваИмен + "}" + ТипРезультирующегоОбъекта.Имя,
				Свойство.ЛокальноеИмя);
		КонецЕсли;
			
		Если Объект.Установлено(Свойство) Тогда
			
			Если Свойство.ВерхняяГраница = 1 Тогда
				
				// ОбъектXDTO или ЗначениеXDTO.
				ТранслируемоеЗначение = Объект.ПолучитьXDTO(Свойство);
				
				Если ТипЗнч(ТранслируемоеЗначение) = Тип("ОбъектXDTO") Тогда
					РезультирующийОбъект.Установить(ТранслируемоеСвойство, ТранслироватьОбъект(ТранслируемоеЗначение, ПравилаТрансляцииИнтерфейсов));
				Иначе
					РезультирующийОбъект.Установить(ТранслируемоеСвойство, ТранслируемоеЗначение);
				КонецЕсли;
				
			Иначе
				
				// СписокXDTO
				ТранслируемыйСписок = Объект.ПолучитьСписок(Свойство);
				
				Для Итератор = 0 По ТранслируемыйСписок.Количество() - 1 Цикл
					
					ЭлементСписка = ТранслируемыйСписок.ПолучитьXDTO(Итератор);
					
					Если ТипЗнч(ЭлементСписка) = Тип("ОбъектXDTO") Тогда
						РезультирующийОбъект[Свойство.ЛокальноеИмя].Добавить(ТранслироватьОбъект(ЭлементСписка, ПравилаТрансляцииИнтерфейсов));
					Иначе
						РезультирующийОбъект[Свойство.ЛокальноеИмя].Добавить(ЭлементСписка);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат РезультирующийОбъект;
	
КонецФункции

// Для внутреннего использования.
Функция СформироватьПравилаТрансляцииИнтерфейсов(Знач Сообщение, Знач ИтерацияТрансляцииИнтерфейса)
	
	ПравилаТрансляцииИнтерфейсов = Новый Соответствие();
	
	ПакетыИсходногоСообщения = Новый Массив();
	ПакетыРезультирующегоСообщения = Новый Массив();
	
	ПакетыИсходногоСообщения = ПолучитьПакетыСообщения(Сообщение);
	
	ОбработчикТрансляцииИнтерфейса = ИтерацияТрансляцииИнтерфейса.Значение;
	
	ПакетыРезультирующегоСообщения.Добавить(ОбработчикТрансляцииИнтерфейса.ПакетРезультирующейВерсии());
	ЗависимостиПакетаКорреспондента = ПолучитьЗависимостиПакета(ОбработчикТрансляцииИнтерфейса.ПакетРезультирующейВерсии());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПакетыРезультирующегоСообщения, ЗависимостиПакетаКорреспондента, Истина);
	
	ПравилоТрансляцииИнтерфейса = Новый Соответствие();
	ПравилоТрансляцииИнтерфейса.Вставить(ИтерацияТрансляцииИнтерфейса.Ключ, ИтерацияТрансляцииИнтерфейса.Значение);
	
	ПравилаТрансляцииИнтерфейсов.Вставить(ОбработчикТрансляцииИнтерфейса.ПакетИсходнойВерсии(), ПравилоТрансляцииИнтерфейса);
	
	Для Каждого ПакетИсходногоСообщения Из ПакетыИсходногоСообщения Цикл
		
		ЦепочкаТрансляции = ПравилаТрансляцииИнтерфейсов.Получить(ПакетИсходногоСообщения);
		
		Если ЦепочкаТрансляции = Неопределено Тогда
			
			Если ПакетыРезультирующегоСообщения.Найти(ПакетИсходногоСообщения) <> Неопределено Тогда
				
				// Один и тот же пакет используется и в исходной версии интерфейса, и в результирующей.
				// Транслировать его не потребуется, достаточно будет просто переложить значения свойств.
				ПравилаТрансляцииИнтерфейсов.Вставить(ПакетИсходногоСообщения, Новый Соответствие());
				
			Иначе
				
				// Пакет исходной версии интерфейса сообщения не используется в результирующей версии интерфейса сообщения.
				// Нужно определить, в какой пакет результирующей версии его необходимо транслировать.
				
				ВозможныеЦепочки = Новый Массив();
				Для Каждого ПакетРезультирующегоСообщения Из ПакетыРезультирующегоСообщения Цикл
					
					ЦепочкаПакета = ПолучитьЦепочкуТрансляции(
						СформироватьОписаниеВерсии(
								, ПакетИсходногоСообщения),
						СформироватьОписаниеВерсии(
								, ПакетРезультирующегоСообщения));
						
					Если ЗначениеЗаполнено(ЦепочкаПакета) Тогда
						 ВозможныеЦепочки.Добавить(ЦепочкаПакета);
					КонецЕсли;
					
				КонецЦикла;
				
				Если ВозможныеЦепочки.Количество() > 0 Тогда
					
					ИспользуемаяЦепочка = ВыбратьЦепочкуТрансляции(ВозможныеЦепочки);
					ПравилаТрансляцииИнтерфейсов.Вставить(ПакетИсходногоСообщения, ИспользуемаяЦепочка);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПравилаТрансляцииИнтерфейсов;
	
КонецФункции

// Возвращает массив, заполненный пространствами имен, используемыми в сообщении.
//
// Параметры:
//  Сообщение - ОбъектXDTO, сообщение, для которого требуется получить перечень
//    пространств имен пакетов.
//
// Возвращаемое значение:
//  Массив, тип элементов: строка.
//
Функция ПолучитьПакетыСообщения(Знач Сообщение)
	
	Результат = Новый Массив();
	
	// Пакет XDTO-объекта
	ПакетОбъектаСообщения = Сообщение.Тип().URIПространстваИмен;
	Результат.Добавить(ПакетОбъектаСообщения);
	
	// Зависимости пакета XDTO-объекта.
	Зависимости = ПолучитьЗависимостиПакета(ПакетОбъектаСообщения);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, Зависимости, Истина);
	
	// Свойства XDTO-объекта
	СвойстваОбъекта = Сообщение.Свойства();
	Для Каждого Свойство Из СвойстваОбъекта Цикл
		
		Если Сообщение.Установлено(Свойство) Тогда
			
			Если Свойство.ВерхняяГраница = 1 Тогда
				
				ЗначениеСвойства = Сообщение.ПолучитьXDTO(Свойство);
				
				Если ТипЗнч(ЗначениеСвойства) = Тип("ОбъектXDTO") Тогда
				
					ПакетыСвойства = ПолучитьПакетыСообщения(ЗначениеСвойства);
					ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, ПакетыСвойства, Истина);
					
				КонецЕсли;
				
			Иначе
				
				СписокСвойств = Сообщение.ПолучитьСписок(Свойство);
				Итератор = 0;
				
				Для Итератор = 0 По СписокСвойств.Количество() - 1 Цикл
					
					ЭлементСписка = СписокСвойств.ПолучитьXDTO(Итератор);
					
					Если ТипЗнч(ЭлементСписка) = Тип("ОбъектXDTO") Тогда
						
						ПакетыСвойства = ПолучитьПакетыСообщения(ЭлементСписка);
						ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, ПакетыСвойства, Истина);
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Процедура используется для построения цепочек выполнения обработчиков трансляции
// при трансляции сообщения из одной версии в другую.
//
// Параметры:
//  ОбработчикиТрансляции - ТаблицаЗначений, структура которой была получена с помощью
//      функции СформироватьТаблицуОбработчиковТрансляции(), содержащая
//      все зарегистрированные в конфигурации обработчики трансляции сообщений,
//  ОписаниеИсходнойВерсии - Структура, описание исходной версии транслируемого сообщения,
//      достаточное для однозначного определения обработчиков в таблице трансляции.
//    Поля структуры:
//      Номер - строка, исходная версия сообщения в формате РР.{П|ПП}.ЗЗ.СС,
//      Пакет - строка, пространство имен исходной версии сообщения,
//  ОписаниеРезультирующейВерсии - Структура, описание результирующей версии, в которую
//      требуется транслировать сообщение, достаточное для однозначного определения
//      обработчиков в таблице трансляции.
//    Поля структуры:
//      Номер - строка, результирующая версия сообщения в 
//        формате РР.{П|ПП}.ЗЗ.СС,
//      Пакет - строка, пространство имен результирующей версии
//        сообщения,
//  ЦепочкиТрансляции - Массив, после выполнения процедуры в данный параметр будут помещены все
//      возможные цепочки трансляции сообщения из исходной в результирующую версию. Элементами
//      массива являются фиксированные соответствия (ключ - пространство имен пакета результирующей
//      версии, значение - ОбщийМодуль, являющийся обработчиком трансляции),
//  ТекущаяЦепочка - служебный параметр, используемый при рекурсивном выполнении процедуры,
//    при первоначальном вызове должен быть не установлен.
//
Процедура НайтиЦепочкиТрансляции(Знач ОбработчикиТрансляции, Знач ОписаниеИсходнойВерсии, 
			Знач ОписаниеРезультирующейВерсии, ЦепочкиТрансляции, ТекущаяЦепочка = Неопределено)
	
	Фильтр = Новый Структура();
	Если ЗначениеЗаполнено(ОписаниеИсходнойВерсии.Номер) Тогда
		Фильтр.Вставить("ИсходнаяВерсия", ОписаниеИсходнойВерсии.Номер);
	КонецЕсли;
	Если ЗначениеЗаполнено(ОписаниеИсходнойВерсии.Пакет) Тогда
		Фильтр.Вставить("ПакетИсходнойВерсии", ОписаниеИсходнойВерсии.Пакет);
	КонецЕсли;
	
	Ветки = ОбработчикиТрансляции.Скопировать(Фильтр);
	Для Каждого Ветка Из Ветки Цикл
		
		Если ТекущаяЦепочка = Неопределено Тогда
			ТекущаяЦепочка = Новый Соответствие();
		КонецЕсли;
		ТекущаяЦепочка.Вставить(Ветка.ПакетРезультирующейВерсии, Ветка.Обработчик);
		
		Если Ветка.РезультирующаяВерсия = ОписаниеРезультирующейВерсии.Номер
				ИЛИ Ветка.ПакетРезультирующейВерсии = ОписаниеРезультирующейВерсии.Пакет Тогда
			ЦепочкиТрансляции.Добавить(Новый ФиксированноеСоответствие(ТекущаяЦепочка));
		Иначе
			НайтиЦепочкиТрансляции(ОбработчикиТрансляции,
					СформироватьОписаниеВерсии(
							, Ветка.ПакетРезультирующейВерсии),
					СформироватьОписаниеВерсии(
							ОписаниеРезультирующейВерсии.Номер, ОписаниеРезультирующейВерсии.Пакет),
					ЦепочкиТрансляции, ТекущаяЦепочка);
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

// Конструктор таблицы обработчиков трансляции.
Функция СоздатьТаблицуОбработчиковТрансляции()
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить("ИсходнаяВерсия");
	Результат.Колонки.Добавить("ПакетИсходнойВерсии");
	Результат.Колонки.Добавить("РезультирующаяВерсия");
	Результат.Колонки.Добавить("ПакетРезультирующейВерсии");
	Результат.Колонки.Добавить("Обработчик");
	
	Возврат Результат;
	
КонецФункции

// Возвращает таблицу обработчиков трансляции сообщений, существующих в конфигурации.
//
Функция ПолучитьОбработчикиТрансляции()
	
	Результат = СоздатьТаблицуОбработчиковТрансляции();
	МассивОбработчиковТрансляции = Новый Массив();
	
	ОбработчикиТрансляцииСообщений = ИнтерфейсыСообщенийВМоделиСервиса.ПолучитьОбработчикиТрансляцииСообщений();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОбработчиковТрансляции, ОбработчикиТрансляцииСообщений);
	
	ТрансляцияXDTOПереопределяемый.ЗаполнитьОбработчикиТрансляцииСообщений(МассивОбработчиковТрансляции);
	
	Для Каждого Обработчик Из МассивОбработчиковТрансляции Цикл
		
		РегистрацияОбработчика = Результат.Добавить();
		РегистрацияОбработчика.ИсходнаяВерсия = Обработчик.ИсходнаяВерсия();
		РегистрацияОбработчика.РезультирующаяВерсия = Обработчик.РезультирующаяВерсия();
		РегистрацияОбработчика.ПакетИсходнойВерсии = Обработчик.ПакетИсходнойВерсии();
		РегистрацияОбработчика.ПакетРезультирующейВерсии = Обработчик.ПакетРезультирующейВерсии();
		РегистрацияОбработчика.Обработчик = Обработчик;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
