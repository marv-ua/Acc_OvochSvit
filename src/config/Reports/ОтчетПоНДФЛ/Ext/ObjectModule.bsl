﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Функция возвращает номер версии универсального механизма, с которой совместим отчет.
//
Функция ВерсияСтандартныхФункцийОтчетов() Экспорт
	Возврат "1";
КонецФункции

// Функция возвращает структуру настроек отчета
//
Функция ПолучитьНастройкиОтчета() Экспорт
	
	Настройки = ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию();  // получим настройки по умолчанию
	Настройки.СоответствиеПериодичностиПараметров.Вставить(Новый ПараметрКомпоновкиДанных("Период"), Перечисления.ДоступныеПериодыОтчета.Месяц);
	Возврат Настройки;
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	//ЗарплатаКадрыОбщиеНаборыДанных.ЗаменитьПредставленияЗапросов(ЭтотОбъект);
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);

КонецПроцедуры

#КонецЕсли