﻿#Область СлужебныйПрограммныйИнтерфейс

Функция Подключены() Экспорт
	
	Если Заблокированы() Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	// Вызов на сервере гарантирует получение корректного состояния в случае,
	// когда данные регистрации информационной базы были изменены методом 
	// СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы.
	Возврат СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
КонецФункции

Функция Заблокированы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеРегистрации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	
	Заблокированы = ДанныеРегистрации <> Неопределено;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Заблокированы;
	
КонецФункции

Процедура Заблокировать() Экспорт 
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда 
		ВызватьИсключение 
			НСтр("ru='Обсуждения не заблокированы. Для выполнения операции требуется право администрирования данных.';uk='Обговорення не заблоковані. Для виконання операції потрібно право адміністрування даних.'");
	КонецЕсли;
	
	Если Заблокированы() Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеРегистрации = СистемаВзаимодействия.ПолучитьДанныеРегистрацииИнформационнойБазы();
	
	Если ТипЗнч(ДанныеРегистрации) = Тип("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия") Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
			"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия", 
			ДанныеРегистрации);
	КонецЕсли;
	
	СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы(Неопределено);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура Разблокировать() Экспорт 
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда 
		ВызватьИсключение 
			НСтр("ru='Обсуждения не заблокированы. Для выполнения операции требуется право администрирования данных.';uk='Обговорення не заблоковані. Для виконання операції потрібно право адміністрування даних.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеРегистрации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	
	Если ТипЗнч(ДанныеРегистрации) = Тип("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия") Тогда 
		СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы(ДанныеРегистрации);
	КонецЕсли;
	
	ДанныеРегистрации = Неопределено;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти