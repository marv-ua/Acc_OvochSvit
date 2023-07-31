﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

// Данный модуль содержит интерфейсные процедуры функции
// вызова процессов выгрузки и загрузки данных.


#Область ПрограммныйИнтерфейс

// Выгружает данные в zip-архив, из которого они в дальнейшем могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеИзАрхива().
//
// Параметры:
//  ПараметрыВыгрузки - Структура, содержащая параметры выгрузки данных.
//    Ключи:
//      ВыгружаемыеТипы - Массив(ОбъектМетаданных) - массив объектов метаданных, данные
//       которых требуется выгрузить в архив,
//      ВыгружатьПользователей - Булево - выгружать информацию о пользователях информационной базы,
//      ВыгружатьНастройкиПользователей - Булево, игнорируется если ВыгружатьПользователей = Ложь.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков выгрузки данных.
//
// Возвращаемое значение - Строка, путь к файлу выгрузки.
//
Функция ВыгрузитьДанныеВАрхив(Знач ПараметрыВыгрузки) Экспорт
	
	Если Не ПроверитьНаличиеПрав() Тогда
		ВызватьИсключение НСтр("ru='Недостаточно прав доступа для выгрузки данных!';uk='Недостатньо прав доступу для вивантаження даних!'");
	КонецЕсли;
	
	ВнешнийМонопольныйРежим = МонопольныйРежим();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружаемыеТипы") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружаемыеТипы", Новый Массив());
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьПользователей") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьПользователей", Ложь);
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьНастройкиПользователей") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьНастройкиПользователей", Ложь);
	КонецЕсли;
	
	Каталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(Каталог);
	Каталог = Каталог + "\";
	
	Архив = Неопределено;
	
	Попытка
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Истина);
		КонецЕсли;
		
		ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузитьДанныеВКаталог(Каталог, ПараметрыВыгрузки);
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		
		Архив = ПолучитьИмяВременногоФайла("zip");
		Архиватор = Новый ЗаписьZipФайла(Архив, , , МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Оптимальный);
		Архиватор.Добавить(Каталог + "*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		Архиватор.Записать();
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		
		Возврат Архив;
		
	Исключение
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Если Архив <> Неопределено Тогда
			ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Архив);
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецФункции

// Загружает данные из zip архива с XML файлами.
//
// Параметры:
//  ИмяАрхива - Строка - полное имя файла архива с данными,
//  ПараметрыЗагрузки - Структура, содержащая параметры загрузки данных.
//    Ключи:
//      ЗагружаемыеТипы - Массив(ОбъектМетаданных) - массив объектов метаданных, данные
//        которых требуется загрузить из архива. Если значение параметра задано - все прочие
//        данные, содержащиеся в файле выгрузки, загружены не будут. Если значение параметра
//        не задано - будут загружены все данные, содержащиеся в файле выгрузки.
//      ЗагружатьПользователей - Булево - загружать информацию о пользователях информационной базы,
//      ЗагружатьНастройкиПользователей - Булево, игнорируется, если ЗагружатьПользователей = Ложь.
//      СопоставлениеПользователей - ТаблицаЗначений - таблица с колонками:
//        * Пользователь - СправочникСсылка.Пользователи - идентификатора пользователя из архива.
//        * ИдентификаторПользователяСервиса - УникальныйИдентификатор - идентификатор пользователя сервиса.
//        * СтароеИмяПользователяИБ - Строка - старое имя пользователя базы.
//        * НовоеИмяПользователяИБ - Строка - новое имя пользователя базы.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков загрузки данных.
//
Процедура ЗагрузитьДанныеИзАрхива(Знач ИмяАрхива, Знач ПараметрыЗагрузки) Экспорт
	
	Если Не ПроверитьНаличиеПрав() Тогда
		ВызватьИсключение НСтр("ru='Недостаточно прав доступа для загрузки данных!';uk='Недостатньо прав доступу для завантаження даних!'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешнийМонопольныйРежим = МонопольныйРежим();
	
	Каталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(Каталог);
	Каталог = Каталог + "\";
	
	Архиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Попытка
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Истина);
		КонецЕсли;
		
		Архиватор.ИзвлечьВсе(Каталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		ВыгрузкаЗагрузкаДанныхСлужебный.ЗагрузитьДанныеИзКаталога(Каталог, ПараметрыЗагрузки);
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецПроцедуры

// Проверяет совместимость выгрузки из файла с текущей конфигурацией информационной базы.
//
// Параметры:
//  ИмяАрхива - Строка, путь к файлу выгрузки.
//
// Возвращаемое значение: Булево, Истина - если данные из архива могут быть загружены
//  в текущую конфигурацию.
//
Функция ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(Знач ИмяАрхива) Экспорт
	
	Каталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(Каталог);
	Каталог = Каталог + "\";
	
	Архиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Попытка
		
		ЭлементОписанияВыгрузки = Архиватор.Элементы.Найти("DumpInfo.xml");
		
		Если ЭлементОписанияВыгрузки = Неопределено Тогда
			ВызватьИсключение НСтр("ru='В файле выгрузки отсутствует файл DumpInfo.xml!';uk='У файлі вивантаження відсутній файл DumpInfo.xml!'");
		КонецЕсли;
		
		Архиватор.Извлечь(ЭлементОписанияВыгрузки, Каталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		
		ФайлОписанияВыгрузки = Каталог + "DumpInfo.xml";
		
		ИнформацияОВыгрузке = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектXDTOИзФайла(
			ФайлОписанияВыгрузки, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "DumpInfo")
		);
		
		Результат = ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(ИнформацияОВыгрузке)
			И ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузкаВАрхивеСовместимаСТекущейВерсиейКонфигурации(ИнформацияОВыгрузке);
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
		Возврат Результат;
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет наличие права "АдминистрированиеДанных"
//
// Возвращаемое значение:
//	Булево - Истина, если имеется, Ложь - иначе.
//
Функция ПроверитьНаличиеПрав()
	
	Возврат ПравоДоступа("АдминистрированиеДанных", Метаданные);
	
КонецФункции

#КонецОбласти