﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщегоНазначения

// Определяет имя текущей программы, по которому программа идентифицируется в
// сервисах Интернет-поддержки.
//
// Параметры:
//	ИмяПрограммы - Строка - в параметре возвращается уникальное имя программы в
//		сервисах Интернет-поддержки.
//
// Пример:
//	ИмяПрограммы = "Trade";
//
Процедура ПриОпределенииИмениПрограммы(ИмяПрограммы) Экспорт
	
	ИмяПрограммы = "BASAccounting";
	Если СтрНайти(ВРег(Метаданные.Имя), "БАЗОВАЯ1") > 0 Тогда
		ИмяПрограммы = ИмяПрограммы + "OneBase";
	ИначеЕсли СтрНайти(ВРег(Метаданные.Имя), "БАЗОВАЯ") > 0 Тогда
		ИмяПрограммы = ИмяПрограммы + "Base";
	ИначеЕсли СтрНайти(ВРег(Метаданные.Имя), "КОРП") > 0 Тогда
		ИмяПрограммы = ИмяПрограммы + "Corp";
	КонецЕсли;
	
КонецПроцедуры

// В процедуре заполняется код языка интерфейса конфигурации (Метаданные.Языки),
// который передается сервисам Интернет-поддержки.
// Код языка заполняется в формате ISO-639-1.
// Если коды языков интерфейса конфигурации определены в формате ISO-639-1,
// тогда тело метода заполнять не нужно.
//
// Параметры:
//	КодЯзыка - Строка - в параметре передается код языка, указанный в
//		Метаданные.Языки;
//	КодЯзыкаВФорматеISO639_1 - Строка - в параметре возвращается
//		код языка в формате ISO-639-1.
//
// Пример:
//	Если КодЯзыка = "rus" Тогда
//		КодЯзыкаВФорматеISO639_1 = "ru";
//	ИначеЕсли КодЯзыка = "english" Тогда
//		КодЯзыкаВФорматеISO639_1 = "en";
//	КонецЕсли;
//
Процедура ПриОпределенииКодаЯзыкаИнтерфейсаКонфигурации(КодЯзыка, КодЯзыкаВФорматеISO639_1) Экспорт
	
	
	
КонецПроцедуры

// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о сервисах: идентификатор, наименование, описание и картинка.
// Модуль должен обязательно содержать процедуру ПриДобавленииОписанийСервисовСопровождения.
//
// Параметры:
//  МодулиСервисов - Массив - имена серверных общих модулей библиотек и конфигурации.
//
Процедура ПриОпределенииСервисовСопровождения(МодулиСервисов) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаСобытийБиблиотеки

// Реализует обработку события сохранения в информационной базе данных
// аутентификации пользователя Интернет-поддержки - логина и пароля
// для подключения к сервисам Интернет-поддержки.
//
// Параметры:
//	ДанныеПользователя - Структура - структура с полями:
//		* Логин - Строка - логин пользователя;
//		* Пароль - Строка - пароль пользователя;
//
Процедура ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки(ДанныеПользователя) Экспорт
	
	
	
КонецПроцедуры

// Реализует обработку события удаления из информационной базы данных
// аутентификации пользователя Интернет-поддержки - логина и пароля
// для подключения к сервисам Интернет-поддержки.
//
Процедура ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки() Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеВерсииИБ

// Процедура вызывается при первом запуске библиотеки БИП.
// Процедура - для общих данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбщиеДанные_ПервыйЗапуск() Экспорт

КонецПроцедуры

// Процедура вызывается при первом запуске библиотеки БИП.
// Процедура - для каждой области данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбластьДанных_ПервыйЗапуск() Экспорт

КонецПроцедуры

// Процедура вызывается при обновлении библиотеки БИП на любую новую версию.
// Процедура - для общих данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбщиеДанные_ПерейтиНаВерсию() Экспорт

КонецПроцедуры

// Процедура вызывается при обновлении библиотеки БИП на любую новую версию.
// Процедура - для каждой области данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбластьДанных_ПерейтиНаВерсию() Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти
