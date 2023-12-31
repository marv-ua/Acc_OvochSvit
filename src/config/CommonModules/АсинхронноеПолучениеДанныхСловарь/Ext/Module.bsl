﻿
#Область ПрограммныйИнтерфейс

#Область КодыВозврата

// Возвращает код ошибки данных.
// 
// Возвращаемое значение:
//   Число - стандартный код возврата по имени метода. 
//
Функция КодВозвратаОшибкаДанных() Экспорт
	
	Возврат 10400;
    
КонецФункции

// Возвращает код внутренней ошибки.
// 
// Возвращаемое значение:
//   Число - стандартный код возврата по имени метода. 
//
Функция КодВозвратаВнутренняяОшибка() Экспорт
	
	Возврат 10500;
    
КонецФункции

//  Возвращает код выполнения с предупреждениями.
// 
// Возвращаемое значение:
//   Число - стандартный код возврата по имени метода. 
//
Функция КодВозвратаВыполненоСПредупреждениями() Экспорт
	
	Возврат 10240;
    
КонецФункции
    
// Возвращает код успешного выполнения.
// 
// Возвращаемое значение:
//   Число - стандартный код возврата по имени метода. 
//
Функция КодВозвратаВыполнено() Экспорт
	
	Возврат 10200;
	
КонецФункции

// Возвращает код отсутствия данных.
// 
// Возвращаемое значение:
//   Число - стандартный код возврата по имени метода. 
//
Функция КодВозвратаНеНайдено() Экспорт
	
	Возврат 10404;
	
КонецФункции

#КонецОбласти 

#Область ТипыФайлов

Функция ТипJSON() Экспорт
	
	Возврат "json";
	
КонецФункции

Функция ТипXLSX() Экспорт
	
	Возврат "xlsx";
	
КонецФункции

Функция ТипPDF() Экспорт
	
	Возврат "pdf";
	
КонецФункции
    
#КонецОбласти 

#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

Функция ЗапросСписок() Экспорт
	
	Возврат "list";
	
КонецФункции

Функция МетодНеПоддерживается() Экспорт
	
	Возврат НСтр("ru='Метод не поддерживается.';uk='Метод не підтримується.'");
	
КонецФункции

Функция ФорматНеПоддерживается() Экспорт
	
    Возврат НСтр("ru='Формат не поддерживается';uk='Формат не підтримується'");	
	
КонецФункции
 
Функция ПолеРезультат() Экспорт
	
	Возврат "result";
	
КонецФункции
 
Функция ПолеФайл() Экспорт
	
    Возврат "file";	
	
КонецФункции

Функция ПолеВерсия() Экспорт
	
    Возврат "version";	
	
КонецФункции

Функция ПолеОбработчик() Экспорт
	
    Возврат "handler";	
	
КонецФункции

Функция ПолеКодВозврата() Экспорт
	
	Возврат "response";
	
КонецФункции

Функция ПолеОшибка() Экспорт
	
	Возврат "error";
	
КонецФункции

Функция ПолеСообщениеОбОшибке() Экспорт
	
	Возврат "message";
	
КонецФункции

Функция ПолеХранилище() Экспорт
	
	Возврат "storage";
	
КонецФункции

Функция ПолеИдентификатор() Экспорт
	
	Возврат "id";
	
КонецФункции

Функция ПолеОсновнойРаздел() Экспорт
	
	Возврат "general";
	
КонецФункции

#КонецОбласти 
