﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет запись объекта к отправке в регистр.
//
// Параметры:
//  ДанныеЗаписи - Структура - данные для записи с полями:
//      * УчетнаяСистема - СправоченикСсылка - (обязательное) учетная система.
//      * ИдентификаторОбъекта - Строка(50) - (обязательное) идентификатор объекта. 
//      * Обработчик - Строка(50) - (обязательное) имя обработчика.
//      * ИдентификаторФайла - УникальныйИдентификатор - идентификатор файла объекта.
//
Процедура ДобавитьЗапись(ДанныеЗаписи) Экспорт
    
    ОбязательныеСвойства = Новый Массив;
    ОбязательныеСвойства.Добавить("УчетнаяСистема");
    ОбязательныеСвойства.Добавить("ИдентификаторОбъекта");
    ОбязательныеСвойства.Добавить("Обработчик");
    
    СвойствоНеЗадано = ИнтеграцияОбъектовОбластейДанныхСловарь.СвойствоНеЗадано();
    Ошибки = Новый Массив;
    Для Каждого Свойство Из ОбязательныеСвойства Цикл
        Если Не ДанныеЗаписи.Свойство(Свойство) Тогда
            Ошибки.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СвойствоНеЗадано, Свойство)); 
        КонецЕсли;     	
    КонецЦикла;
    Если Ошибки.Количество() > 0 Тогда
        ВызватьИсключение СтрСоединить(Ошибки, Символы.ПС);    
    КонецЕсли; 
    
    МенеджерЗаписи = СоздатьМенеджерЗаписи();
    ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
    МенеджерЗаписи.Записать();
    
КонецПроцедуры

// Удаляет запись объекта к отправке из регистра.
//
// Параметры:
//  Отбор - Структура - данные для удаления с полями:
//      * УчетнаяСистема - СправочникСсылка - учетная система
//      * ИдентификаторОбъекта - Строка(50) - индентификатор объекта
//      * Обработчик - Строка(50) - имя обработчика.
//
Процедура УдалитьЗаписи(Отбор) Экспорт
    
    Набор = СоздатьНаборЗаписей();
    Набор.Отбор.УчетнаяСистема.Установить(Отбор.УчетнаяСистема, Истина);
    
    ДопОтборы = Новый Массив;
    ДопОтборы.Добавить("ИдентификаторОбъекта");
    ДопОтборы.Добавить("Обработчик");
    
    Для Каждого ДопОтбор Из ДопОтборы Цикл
        Если Отбор.Свойство(ДопОтбор) И ЗначениеЗаполнено(Отбор[ДопОтбор]) Тогда
            Набор.Отбор[ДопОтбор].Установить(Отбор[ДопОтбор], Истина);
        КонецЕсли; 
    КонецЦикла; 
    
    Набор.Записать();
    
КонецПроцедуры

// Возвращает количество объектов к отправке по учетной системе.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных - учетная система. 
// 
// Возвращаемое значение:
//   - Число - количество объектов.
//
Функция Количество(УчетнаяСистема) Экспорт
	
    Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ
        |   КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбъектыКОтправке.ИдентификаторОбъекта) КАК Количество
        |ИЗ
        |   РегистрСведений.ОбъектыКОтправке КАК ОбъектыКОтправке
        |       ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияИнтеграцииОбъектов КАК СостоянияИнтеграцииОбъектов
        |       ПО ОбъектыКОтправке.УчетнаяСистема = СостоянияИнтеграцииОбъектов.УчетнаяСистема
        |           И ОбъектыКОтправке.ИдентификаторОбъекта = СостоянияИнтеграцииОбъектов.ИдентификаторОбъекта
        |ГДЕ
        |   ОбъектыКОтправке.УчетнаяСистема = &УчетнаяСистема
        |   И ЕСТЬNULL(СостоянияИнтеграцииОбъектов.Состояние, &ПустоеСостояние) <> &Ошибка";
    
    Запрос.УстановитьПараметр("УчетнаяСистема", УчетнаяСистема);
    Запрос.УстановитьПараметр("Ошибка", Перечисления.СостоянияИнтеграцииОбъектов.Ошибка);
    Запрос.УстановитьПараметр("ПустоеСостояние", Перечисления.СостоянияИнтеграцииОбъектов.ПустаяСсылка());
    
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    Если Выборка.Следующий() Тогда
        Возврат Выборка.Количество;
    Иначе 
        Возврат 0;
    КонецЕсли; 
	
КонецФункции
 
Функция НовыйДанныеЗаписи() Экспорт
	
    ДанныеЗаписи = Новый Структура;
    ДанныеЗаписи.Вставить("УчетнаяСистема");
    ДанныеЗаписи.Вставить("ИдентификаторОбъекта");
    ДанныеЗаписи.Вставить("Обработчик");
    ДанныеЗаписи.Вставить("ИдентификаторФайла");
    Возврат ДанныеЗаписи;
	
КонецФункции

Функция ПеренестиОбработчикВИзмерение() Экспорт
	
    Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ
        |   ОбъектыКОтправке.УчетнаяСистема КАК УчетнаяСистема,
        |   ОбъектыКОтправке.ИдентификаторОбъекта КАК ИдентификаторОбъекта,
        |   ОбъектыКОтправке.УдалитьОбработчик КАК Обработчик,
        |   ОбъектыКОтправке.ИдентификаторФайла КАК ИдентификаторФайла
        |ИЗ
        |   РегистрСведений.ОбъектыКОтправке КАК ОбъектыКОтправке
        |ГДЕ
        |   ОбъектыКОтправке.Обработчик = """"
        |   И ОбъектыКОтправке.УдалитьОбработчик <> """"";
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    
    Пока Выборка.Следующий() Цикл
        Удаление = СоздатьМенеджерЗаписи();
        Удаление.УчетнаяСистема = Выборка.УчетнаяСистема;
        Удаление.ИдентификаторОбъекта = Выборка.ИдентификаторОбъекта;
    	Удаление.Удалить();
        Добавление = СоздатьМенеджерЗаписи();
        Добавление.УчетнаяСистема = Выборка.УчетнаяСистема;
        Добавление.ИдентификаторОбъекта = Выборка.ИдентификаторОбъекта;
        Добавление.Обработчик = Выборка.Обработчик;
    	Добавление.ИдентификаторФайла = Выборка.ИдентификаторФайла;
    	Добавление.Записать();
    КонецЦикла;
	
КонецФункции
 
#КонецОбласти

#КонецЕсли