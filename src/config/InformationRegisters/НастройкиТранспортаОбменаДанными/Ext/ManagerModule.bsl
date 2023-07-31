﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
		
	НачатьТранзакцию();
	Попытка
		ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаДанными");
		
		ЗаписатьПароль("COMПарольПользователя", "COMПарольПользователя", СтруктураЗаписи);
		ЗаписатьПароль("FTPСоединениеПароль", "FTPСоединениеПароль", СтруктураЗаписи);
		ЗаписатьПароль("WSПароль", "WSПароль", СтруктураЗаписи);
		ЗаписатьПароль("ПарольАрхиваСообщенияОбмена", "ПарольАрхиваСообщенияОбмена", СтруктураЗаписи);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Процедура обновляет запись в регистре по переданным значениям структуры.
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	НачатьТранзакцию();
	Попытка
		ОбменДаннымиСервер.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаДанными");
		
		ЗаписатьПароль("COMПарольПользователя", "COMПарольПользователя", СтруктураЗаписи);
		ЗаписатьПароль("FTPСоединениеПароль", "FTPСоединениеПароль", СтруктураЗаписи);
		ЗаписатьПароль("WSПароль", "WSПароль", СтруктураЗаписи);
		ЗаписатьПароль("ПарольАрхиваСообщенияОбмена", "ПарольАрхиваСообщенияОбмена", СтруктураЗаписи);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования.
// 
Функция НастройкиТранспортаWS(Корреспондент, ПараметрыАутентификации = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = СоставНастроекТранспортаОбмена("WS");
	Результат = ПолучитьДанныеРегистраПоСтруктуре(Корреспондент, СтруктураНастроек);
	
	WSПароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Корреспондент, "WSПароль");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(WSПароль) = Тип("Строка")
		Или WSПароль = Неопределено Тогда
		
		Результат.Вставить("WSПароль", WSПароль);
	Иначе
		ВызватьИсключение НСтр("ru='Ошибка при извлечении пароля из безопасного хранилища.';uk='Помилка при витяганні пароля з безпечного сховища.'");
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыАутентификации) = Тип("Структура") Тогда // Инициация обмена пользователем с клиента.
		
		Если ПараметрыАутентификации.ИспользоватьТекущегоПользователя Тогда
			
			Результат.WSИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
			
		КонецЕсли;
		
		Пароль = Неопределено;
		
		Если ПараметрыАутентификации.Свойство("Пароль", Пароль)
			И Пароль <> Неопределено Тогда // Ввели пароль на клиенте
			
			Результат.WSПароль = Пароль;
			
		Иначе // Пароль на клиенте не вводили.
			
			Пароль = ОбменДаннымиСервер.ПарольСинхронизацииДанных(Корреспондент);
			
			Результат.WSПароль = ?(Пароль = Неопределено, "", Пароль);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПараметрыАутентификации) = Тип("Строка") Тогда
		Результат.WSПароль = ПараметрыАутентификации;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	НастройкиТранспорта = СохраненныеНастройкиТранспорта();
	
	Пока НастройкиТранспорта.Следующий() Цикл
		
		ПараметрыЗапроса = ПараметрыЗапросаНаИспользованиеВнешнихРесурсов();
		ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, НастройкиТранспорта, ПараметрыЗапроса);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СохраненныеНастройкиТранспорта()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиТранспорта.Корреспондент КАК Корреспондент,
	|	НастройкиТранспорта.FTPСоединениеПуть,
	|	НастройкиТранспорта.FILEКаталогОбменаИнформацией,
	|	НастройкиТранспорта.WSURLВебСервиса,
	|	НастройкиТранспорта.COMКаталогИнформационнойБазы,
	|	НастройкиТранспорта.COMИмяИнформационнойБазыНаСервере1СПредприятия,
	|	НастройкиТранспорта.FTPСоединениеПуть КАК FTPСоединениеПуть,
	|	НастройкиТранспорта.FTPСоединениеПорт КАК FTPСоединениеПорт,
	|	НастройкиТранспорта.WSURLВебСервиса КАК WSURLВебСервиса,
	|	НастройкиТранспорта.FILEКаталогОбменаИнформацией КАК FILEКаталогОбменаИнформацией
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаДанными КАК НастройкиТранспорта";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции

Функция ПараметрыЗапросаНаИспользованиеВнешнихРесурсов() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ЗапрашиватьCOM",  Истина);
	Параметры.Вставить("ЗапрашиватьFILE", Истина);
	Параметры.Вставить("ЗапрашиватьWS",   Истина);
	Параметры.Вставить("ЗапрашиватьFTP",  Истина);
	
	Возврат Параметры;
	
КонецФункции

Процедура ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, Запись, ПараметрыЗапроса) Экспорт
	
	Разрешения = Новый Массив;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Если ПараметрыЗапроса.ЗапрашиватьFTP И Не ПустаяСтрока(Запись.FTPСоединениеПуть) Тогда
		
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(Запись.FTPСоединениеПуть);
		Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			СтруктураАдреса.Схема, СтруктураАдреса.Хост, Запись.FTPСоединениеПорт));
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.ЗапрашиватьFILE И Не ПустаяСтрока(Запись.FILEКаталогОбменаИнформацией) Тогда
		
		Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
			Запись.FILEКаталогОбменаИнформацией, Истина, Истина));
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.ЗапрашиватьWS И Не ПустаяСтрока(Запись.WSURLВебСервиса) Тогда
		
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(Запись.WSURLВебСервиса);
		Если ЗначениеЗаполнено(СтруктураАдреса.Схема) Тогда
			Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				СтруктураАдреса.Схема, СтруктураАдреса.Хост, СтруктураАдреса.Порт));
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.ЗапрашиватьCOM И (Не ПустаяСтрока(Запись.COMКаталогИнформационнойБазы)
		Или Не ПустаяСтрока(Запись.COMИмяИнформационнойБазыНаСервере1СПредприятия)) Тогда
		
		ИмяCOMСоединителя = ОбщегоНазначенияКлиентСервер.ИмяCOMСоединителя();
		Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаСозданиеCOMКласса(
			ИмяCOMСоединителя, ОбщегоНазначения.ИдентификаторCOMСоединителя(ИмяCOMСоединителя)));
		
	КонецЕсли;
	
	// Разрешения для обмена через почту запрашиваются в подсистеме Работе с почтовыми сообщениями.
	
	Если Разрешения.Количество() > 0 Тогда
		
		ЗапросыРазрешений.Добавить(
			МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения, Запись.Корреспондент));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьПароль(ИмяПароляВСтруктуре, ИмяПароляПриЗаписи, СтруктураЗаписи)
	
	Если СтруктураЗаписи.Свойство(ИмяПароляВСтруктуре) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(СтруктураЗаписи.Корреспондент, СтруктураЗаписи[ИмяПароляВСтруктуре], ИмяПароляПриЗаписи);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции получения значений настроек для узла плана обмена.

// Получает значения настроек транспорта определенного вида.
// Если вид транспорта не указан (ВидТранспортаОбмена = Неопределено),
// то получает настройки всех видов транспорта, заведенных в системе.
//
Функция НастройкиТранспорта(Знач Корреспондент, Знач ВидТранспортаОбмена = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Корреспондент = Корреспондент;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Возврат НастройкиТранспортаОбмена(Корреспондент, ВидТранспортаОбмена);
	ИначеЕсли ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат РегистрыСведений["НастройкиТранспортаОбменаОбластиДанных"].НастройкиТранспорта(Корреспондент);
	КонецЕсли;
	
	Возврат НастройкиТранспортаОбмена(Корреспондент, ВидТранспортаОбмена);
	
КонецФункции

Функция ВидТранспортаСообщенийОбменаПоУмолчанию(Корреспондент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Возвращаемое значение функции.
	ВидТранспортаСообщений = Неопределено;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиТранспорта.ВидТранспортаСообщенийОбменаПоУмолчанию КАК ВидТранспортаСообщенийОбменаПоУмолчанию
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаДанными КАК НастройкиТранспорта
	|ГДЕ
	|	НастройкиТранспорта.Корреспондент = &Корреспондент");
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВидТранспортаСообщений = Выборка.ВидТранспортаСообщенийОбменаПоУмолчанию;
	КонецЕсли;
	
	Если ВидТранспортаСообщений = Неопределено
		И ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиТранспортаОбластейДанных.ВидТранспортаСообщенийОбменаПоУмолчанию КАК ВидТранспортаСообщенийОбменаПоУмолчанию
		|ИЗ
		|	РегистрСведений.НастройкиТранспортаОбменаОбластиДанных КАК НастройкиТранспортаОбластиДанных
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиТранспортаОбменаОбластейДанных КАК НастройкиТранспортаОбластейДанных
		|		ПО (НастройкиТранспортаОбластейДанных.КонечнаяТочкаКорреспондента = НастройкиТранспортаОбластиДанных.КонечнаяТочкаКорреспондента)
		|ГДЕ
		|	НастройкиТранспортаОбластиДанных.Корреспондент = &Корреспондент");
		Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ВидТранспортаСообщений = Выборка.ВидТранспортаСообщенийОбменаПоУмолчанию;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВидТранспортаСообщений;
	
КонецФункции

Функция ИмяКаталогаОбменаИнформацией(ВидТранспортаСообщенийОбмена, УзелИнформационнойБазы) Экспорт
	
	// Возвращаемое значение функции.
	Результат = "";
	
	Если ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
		
		Результат = НастройкиТранспорта["FILEКаталогОбменаИнформацией"];
		
	ИначеЕсли ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
		
		Результат = НастройкиТранспорта["FTPСоединениеПуть"];
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция НастройкиТранспортаДляУзлаЗаданы(Корреспондент) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	1 КАК ЕстьНастройки
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаДанными КАК НастройкиТранспорта
	|ГДЕ
	|	НастройкиТранспорта.Корреспондент = &Корреспондент");
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция НастроенныеВидыТранспорта(УзелИнформационнойБазы) Экспорт
	
	Результат = Новый Массив;
	
	НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Не НастройкиТранспорта = Неопределено Тогда
			Если ЗначениеЗаполнено(НастройкиТранспорта.FILEКаталогОбменаИнформацией) Тогда
				Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(НастройкиТранспорта.FTPСоединениеПуть) Тогда
				Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Если ЗначениеЗаполнено(НастройкиТранспорта.COMКаталогИнформационнойБазы) 
			Или ЗначениеЗаполнено(НастройкиТранспорта.COMИмяИнформационнойБазыНаСервере1СПредприятия) Тогда
			Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиТранспорта.EMAILУчетнаяЗапись) Тогда
			Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиТранспорта.FILEКаталогОбменаИнформацией) Тогда
			Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиТранспорта.FTPСоединениеПуть) Тогда
			Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиТранспорта.WSURLВебСервиса) Тогда
			Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

// Получает значения настроек транспорта определенного вида.
// Если вид транспорта не указан (ВидТранспортаОбмена = Неопределено),
// то получает настройки всех видов транспорта, заведенных в системе.
//
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  
//
Функция НастройкиТранспортаОбмена(Корреспондент, ВидТранспортаОбмена)
	
	СтруктураНастроек = Новый Структура;
	
	// Общие настройки для всех видов транспорта.
	СтруктураНастроек.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию");
	СписокПаролей = "ПарольАрхиваСообщенияОбмена";
	
	Если ВидТранспортаОбмена = Неопределено Тогда
		СписокПаролей = СписокПаролей + ",FTPСоединениеПароль,WSПароль,COMПарольПользователя";
		Для Каждого ВидТранспорта Из Перечисления.ВидыТранспортаСообщенийОбмена Цикл
			
			СтруктураНастроекТранспорта = СоставНастроекТранспортаОбмена(ОбщегоНазначения.ИмяЗначенияПеречисления(ВидТранспорта));
			
			СтруктураНастроек = ОбъединитьКоллекции(СтруктураНастроек, СтруктураНастроекТранспорта);
			
		КонецЦикла;
		
	Иначе
		
		СтруктураНастроекТранспорта = СоставНастроекТранспортаОбмена(ОбщегоНазначения.ИмяЗначенияПеречисления(ВидТранспортаОбмена));
		СтруктураНастроек = ОбъединитьКоллекции(СтруктураНастроек, СтруктураНастроекТранспорта);
		
		Если ВидТранспортаОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.COM Тогда
			СписокПаролей = СписокПаролей + ",COMПарольПользователя";
		ИначеЕсли ВидТранспортаОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
			СписокПаролей = СписокПаролей + ",WSПароль";
		ИначеЕсли ВидТранспортаОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
			СписокПаролей = СписокПаролей + ",FTPСоединениеПароль";
		КонецЕсли;
	КонецЕсли;
	
	Результат = ПолучитьДанныеРегистраПоСтруктуре(Корреспондент, СтруктураНастроек);
	Результат.Вставить("ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений", Истина);
	
	УстановитьПривилегированныйРежим(Истина);
	Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Корреспондент, СписокПаролей);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(Пароли) = Тип("Структура") Тогда
		Для каждого КлючИЗначение Из Пароли Цикл
			Результат.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	Иначе
		Результат.Вставить(СписокПаролей, Пароли);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьДанныеРегистраПоСтруктуре(Корреспондент, СтруктураНастроек)
	
	Если Не ЗначениеЗаполнено(Корреспондент) Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	Если СтруктураНастроек.Количество() = 0 Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	// Формируем текст запроса только по необходимым полям -
	// параметрам для указанного вида транспорта.
	ТекстЗапроса = "ВЫБРАТЬ ";
	
	Для Каждого ЭлементНастройки Из СтруктураНастроек Цикл
		
		ТекстЗапроса = ТекстЗапроса + ЭлементНастройки.Ключ + ", ";
		
	КонецЦикла;
	
	// Убираем последний символ ", ".
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ТекстЗапроса, 2);
	
	ТекстЗапроса = ТекстЗапроса + "
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаДанными КАК НастройкиТранспорта
	|ГДЕ
	|	НастройкиТранспорта.Корреспондент = &Корреспондент
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Если есть данные для узла, то заполняем структуру.
	Если Выборка.Следующий() Тогда
		
		Для Каждого ЭлементНастройки Из СтруктураНастроек Цикл
			
			СтруктураНастроек[ЭлементНастройки.Ключ] = Выборка[ЭлементНастройки.Ключ];
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтруктураНастроек;
	
КонецФункции

Функция СоставНастроекТранспортаОбмена(ПодстрокаПоиска)
	
	СтруктураНастроекТранспорта = Новый Структура;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Запись = НаборЗаписей.Добавить(); // Для значений по умолчанию.
	
	Для Каждого Ресурс Из НаборЗаписей.Метаданные().Ресурсы Цикл
		
		Если СтрНайти(Ресурс.Имя, ПодстрокаПоиска) <> 0 Тогда
			
			СтруктураНастроекТранспорта.Вставить(Ресурс.Имя, Запись[Ресурс.Имя]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураНастроекТранспорта;
	
КонецФункции

Функция ОбъединитьКоллекции(Структура1, Структура2)
	
	СтруктураРезультат = Новый Структура;
	
	ДополнитьКоллекцию(Структура1, СтруктураРезультат);
	ДополнитьКоллекцию(Структура2, СтруктураРезультат);
	
	Возврат СтруктураРезультат;
КонецФункции

Процедура ДополнитьКоллекцию(Источник, Приемник)
	
	Для Каждого Элемент Из Источник Цикл
		
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли