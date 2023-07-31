﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки в модели сервиса", процедуры
//  и функции с повторным использованием возвращаемых значений.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает фиксированную массив, содержащий имена констант, регулирующих доступность
//  использования дополнительных отчетов и обработок в модели сервиса.
//
Функция РегулирующиеКонстанты() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("НезависимоеИспользованиеДополнительныхОтчетовИОбработокВМоделиСервиса");
	Результат.Добавить("ИспользованиеКаталогаДополнительныхОтчетовИОбработокВМоделиСервиса");
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Функция возвращает массив, содержащий имена реквизитов справочника ДополнительныеОтчетыИОбработки,
//  которые запрещено изменять при наличии связи с поставляемыми обработками.
//
Функция КонтролируемыеРеквизиты() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("БезопасныйРежим");
	Результат.Добавить("ХранилищеОбработки");
	Результат.Добавить("ИмяОбъекта");
	Результат.Добавить("Версия");
	Результат.Добавить("Вид");
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Функция возвращает соответствие элементов перечисления ПричиныОтключенияДополнительныхОтчетовИОбработокВМоделиСервиса
//  подробному описанию причины отключения.
//
Функция РасширенныеОписанияПричинБлокировки() Экспорт
	
	Причины = Перечисления.ПричиныОтключенияДополнительныхОтчетовИОбработокВМоделиСервиса;
	
	Результат = Новый Соответствие();
	Результат.Вставить(Причины.БлокировкаАдминистраторомСервиса, НСтр("ru='Использование дополнительной обработки запрещено из-за нарушений правил сервиса!';uk='Використання додаткової обробки заборонено через порушення правил сервісу!'"));
	Результат.Вставить(Причины.БлокировкаВладельцем, НСтр("ru='Использование дополнительной обработки запрещено владельцем обработки!';uk='Використання додаткової обробки заборонено власником обробки!'"));
	Результат.Вставить(Причины.ОбновлениеВерсииКонфигурации, НСтр("ru='Использование дополнительной обработки временно недоступно по причине выполнения обновления приложения. Данный процесс может занять несколько минут. Приносим извинения на доставленные неудобства.';uk='Використання додаткової обробки тимчасово недоступне через виконання оновлення програми. Даний процес може зайняти кілька хвилин. Приносимо вибачення за незручності.'"));
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти