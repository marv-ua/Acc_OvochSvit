﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Синхронизация данных"
// Серверные процедуры, обслуживающие правила регистрации объектов.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик регистрации изменений для начальной выгрузки данных.
// Используется для переопределения стандартной обработки регистрации изменений.
// При стандартной обработке будут зарегистрированы изменения всех данных из состава плана обмена.
// Если для плана обмена предусмотрены фильтры ограничения миграции данных,
// то использование этого обработчика позволит повысить производительность начальной выгрузки данных.
// В обработчике следует реализовать регистрацию изменений с учетом фильтров ограничения миграции данных.
// Если для плана обмена используются ограничения миграции по дате или по дате и организациям,
// то можно воспользоваться универсальной процедурой
// ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям.
// Обработчик используется только для универсального обмена данными с использованием правил обмена
// и для универсального обмена данными без правил обмена и не используется для обменов в РИБ.
// Использование обработчика позволяет повысить производительность
// начальной выгрузки данных в среднем в 2-4 раза.
//
// Параметры:
//
// Получатель - ПланОбменаСсылка - Узел плана обмена, в который требуется выгрузить данные.
//
// СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//  Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная обработка события
//  производиться не будет.
//  Отказ от стандартной обработки не отменяет действие.
//  Значение по умолчанию - Истина.
//
Процедура ОбработкаРегистрацииНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата30Бухгалтерия21") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата30Бухгалтерия21");
		Модуль.ОбработкаРегистрацииНачальнойВыгрузкиДанных(Получатель, СтандартнаяОбработка, Отбор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти