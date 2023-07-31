﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных
Перем СтрокаСообщенияОбОшибке Экспорт;
Перем СтрокаСообщенияОбОшибкеЖР Экспорт;

Перем СообщенияОшибок; // Соответствие с предопределенными сообщениями ошибок обработки.
Перем ИмяОбъекта;		// имя объекта метаданных

Перем ВременныйФайлСообщенияОбмена; // временный файл сообщения обмена для выгрузки/загрузки данных.
Перем ВременныйКаталогСообщенийОбмена; // Временный каталог для сообщений обмена.

Перем ТемаСообщения;		// шаблон темы сообщения
Перем ТелоСообщенияПростое;	// Текст тела сообщения с вложением - файлом XML.
Перем ТелоСообщенияСжатое;		// Текст тела сообщения с вложением - сжатым файлом.
Перем ТелоСообщенияПакетное;	// Текст тела сообщения с вложением - сжатый файл, в котором с набор файлов.
Перем ОбщийМодульРаботаСПочтовымиСообщениями;

Перем ИдентификаторКаталога;
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Создает временный каталог в каталоге временных файлов пользователя операционной системы.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка.
// 
Функция ВыполнитьДействияПередОбработкойСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	ИдентификаторКаталога = Неопределено;
	
	Возврат СоздатьВременныйКаталогСообщенийОбмена();
	
КонецФункции

// Выполняет отправку сообщения обмена на заданный ресурс из временного каталога сообщения обмена.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка.
// 
Функция ОтправитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ОтправитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Получает сообщение обмена с заданного ресурса во временный каталог сообщения обмена.
//
// Параметры:
//  ПроверкаНаличия - Булево - Истина, если необходимо только проверить наличие сообщений обмена, без их загрузки.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка.
// 
Функция ПолучитьСообщение(ПроверкаНаличия = Ложь) Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ПолучитьСообщениеОбмена(ПроверкаНаличия);
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Удаляет временный каталог сообщений обмена после выполнения выгрузки или загрузки данных.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина
//
Функция ВыполнитьДействияПослеОбработкиСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	УдалитьВременныйКаталогСообщенийОбмена();
	
	Возврат Истина;
	
КонецФункции

// Выполняет инициализацию свойств обработки начальными значениями и константами.
//
// Параметры:
//  Нет.
// 
Процедура Инициализация() Экспорт
	
	ИнициализацияСообщений();
	
	ТемаСообщения = "Exchange message (%1)"; // Строка не подлежит локализации.
	ТемаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТемаСообщения, ШаблонИмениФайлаСообщения);
	
	ТелоСообщенияПростое	= НСтр("ru='Сообщение обмена данными';uk='Повідомлення обміну даними'");
	ТелоСообщенияСжатое	= НСтр("ru='Сжатое сообщение обмена данными';uk='Стисле повідомлення обміну даними'");
	ТелоСообщенияПакетное	= НСтр("ru='Пакетное сообщение обмена данными';uk='Пакетне повідомлення обміну даними'");
	
КонецПроцедуры

// Выполняет проверку возможности установки подключения к заданному ресурсу.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - подключение может быть установлено; Ложь - нет.
//
Функция ПодключениеУстановлено() Экспорт
	
	ИнициализацияСообщений();
	
	Если НЕ ЗначениеЗаполнено(EMAILУчетнаяЗапись) Тогда
		ПолучитьСообщениеОбОшибке(101);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Время изменения файла сообщения обмена.
//
// Возвращаемое значение:
//  Строка - время изменения файла сообщения обмена.
//
Функция ДатаФайлаСообщенияОбмена() Экспорт
	
	Результат = Неопределено;
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Если ВременныйФайлСообщенияОбмена.Существует() Тогда
			
			Результат = ВременныйФайлСообщенияОбмена.ПолучитьВремяИзменения();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Полное имя файла сообщения обмена.
//
// Возвращаемое значение:
//  Строка - полное имя файла сообщения обмена.
//
Функция ИмяФайлаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйФайлСообщенияОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

// Полное имя каталога сообщения обмена.
//
// Возвращаемое значение:
//  Строка - полное имя каталога сообщения обмена.
//
Функция ИмяКаталогаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйКаталогСообщенийОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйКаталогСообщенийОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

Функция СоздатьВременныйКаталогСообщенийОбмена()
	
	// Создаем временный каталог для сообщений обмена.
	Попытка
		ИмяВременногоКаталога = ОбменДаннымиСервер.СоздатьВременныйКаталогСообщенийОбмена(ИдентификаторКаталога);
	Исключение
		ПолучитьСообщениеОбОшибке(4);
		ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	ВременныйКаталогСообщенийОбмена = Новый Файл(ИмяВременногоКаталога);
	
	ИмяФайлаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".xml");
	
	ВременныйФайлСообщенияОбмена = Новый Файл(ИмяФайлаСообщения);
	
	Возврат Истина;
КонецФункции

Функция УдалитьВременныйКаталогСообщенийОбмена()
	
	Попытка
		Если Не ПустаяСтрока(ИмяКаталогаСообщенияОбмена()) Тогда
			УдалитьФайлы(ИмяКаталогаСообщенияОбмена());
			ВременныйКаталогСообщенийОбмена = Неопределено;
		КонецЕсли;
		
		Если Не ИдентификаторКаталога = Неопределено Тогда
			ОбменДаннымиСервер.ПолучитьФайлИзХранилища(ИдентификаторКаталога);
			ИдентификаторКаталога = Неопределено;
		КонецЕсли;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ОтправитьСообщениеОбмена()
	
	Результат = Истина;
	
	Расширение = ?(СжиматьФайлИсходящегоСообщения(), ".zip", ".xml");
	
	ИмяФайлаИсходящегоСообщения = ШаблонИмениФайлаСообщения + Расширение;
	
	Если СжиматьФайлИсходящегоСообщения() Тогда
		
		// Получаем имя для временного файла архива.
		ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
		
		Попытка
			
			Архиватор = Новый ЗаписьZipФайла(ИмяВременногоФайлаАрхива, ПарольАрхиваСообщенияОбмена, НСтр("ru='Файл сообщения обмена';uk='Файл повідомлення обміну'"));
			Архиватор.Добавить(ИмяФайлаСообщенияОбмена());
			Архиватор.Записать();
			
		Исключение
			
			Результат = Ложь;
			ПолучитьСообщениеОбОшибке(3);
			ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
		Архиватор = Неопределено;
		
		Если Результат Тогда
			
			// Выполняем проверку на максимально допустимый размер сообщения обмена.
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяВременногоФайлаАрхива, МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			Результат = ОтправитьСообщениеПоЭлектроннойПочте(
									ТелоСообщенияСжатое,
									ИмяФайлаИсходящегоСообщения,
									ИмяВременногоФайлаАрхива);
			
		КонецЕсли;
		
	Иначе
		
		Если Результат Тогда
			
			// Выполняем проверку на максимально допустимый размер сообщения обмена.
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяФайлаСообщенияОбмена(), МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			Результат = ОтправитьСообщениеПоЭлектроннойПочте(
									ТелоСообщенияПростое,
									ИмяФайлаИсходящегоСообщения,
									ИмяФайлаСообщенияОбмена());
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСообщениеОбмена(ПроверкаНаличия)
	
	ТаблицаСообщенийОбмена = Новый ТаблицаЗначений;
	ТаблицаСообщенийОбмена.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Массив"));
	ТаблицаСообщенийОбмена.Колонки.Добавить("ДатаОтправления", Новый ОписаниеТипов("Дата"));
	
	МассивКолонок = Новый Массив;
	
	МассивКолонок.Добавить("Идентификатор");
	МассивКолонок.Добавить("ДатаОтправления");
	МассивКолонок.Добавить("Тема");
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Колонки", МассивКолонок);
	ПараметрыЗагрузки.Вставить("ПолучениеЗаголовков", Истина);
	
	Попытка
		НаборСообщений = ОбщийМодульРаботаСПочтовымиСообщениями.ЗагрузитьПочтовыеСообщения(EMAILУчетнаяЗапись, ПараметрыЗагрузки);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(103);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	ПодстрокаТемыДляПоиска = ВРег(СтрЗаменить(СокрЛП(ШаблонИмениФайлаСообщения), "Message_", ""));
	
	Для Каждого ПочтовоеСообщение Из НаборСообщений Цикл
		
		ТемаПС = СокрЛП(ПочтовоеСообщение.Тема);
		ТемаПС = СтрЗаменить(ТемаПС, Символы.Таб, "");
		
		Если ВРег(ТемаПС) <> ВРег(СокрЛП(ТемаСообщения)) Тогда
			// Возможно, имя сообщения в формате Message_[префикс]_УИД1_УИД2
			Если СтрНайти(ВРег(ТемаПС), ПодстрокаТемыДляПоиска) = 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаСообщенийОбмена.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПочтовоеСообщение);
		
	КонецЦикла;
	
	Если ТаблицаСообщенийОбмена.Количество() = 0 Тогда
		
		Если Не ПроверкаНаличия Тогда
			ПолучитьСообщениеОбОшибке(104);
		
			СтрокаСообщения = НСтр("ru='Не обнаружены письма с заголовком: ""%1""';uk='Не виявлені листи із заголовком: ""%1""'");
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ТемаСообщения);
			ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		КонецЕсли;
		
		Возврат Ложь;
		
	Иначе
		
		Если ПроверкаНаличия Тогда
			Возврат Истина;
		КонецЕсли;
		
		ТаблицаСообщенийОбмена.Сортировать("ДатаОтправления Убыв");
		
		МассивКолонок = Новый Массив;
		МассивКолонок.Добавить("Вложения");
		
		ПараметрыЗагрузки = Новый Структура;
		ПараметрыЗагрузки.Вставить("Колонки", МассивКолонок);
		ПараметрыЗагрузки.Вставить("ЗаголовкиИдентификаторы", ТаблицаСообщенийОбмена[0].Идентификатор);
		
		Попытка
			НаборСообщений = ОбщийМодульРаботаСПочтовымиСообщениями.ЗагрузитьПочтовыеСообщения(EMAILУчетнаяЗапись, ПараметрыЗагрузки);
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ПолучитьСообщениеОбОшибке(105);
			ДополнитьСообщениеОбОшибке(ТекстОшибки);
			Возврат Ложь;
		КонецПопытки;
		
		ДвоичныеДанные = НаборСообщений[0].Вложения.Получить(ШаблонИмениФайлаСообщения+".zip");
		
		Если ДвоичныеДанные <> Неопределено Тогда
			ФайлЗапакован = Истина;
		Иначе
			ДвоичныеДанные = НаборСообщений[0].Вложения.Получить(ШаблонИмениФайлаСообщения+".xml");
			ФайлЗапакован = Ложь;
		КонецЕсли;
		
		// Возможно, имя сообщения в формате Message_[префикс]_УИД1_УИД2
		ФайлЗапакован = Ложь;
		ШаблонПоиска = СтрЗаменить(ШаблонИмениФайлаСообщения, "Message_","");
		Для Каждого ТекВложение Из НаборСообщений[0].Вложения Цикл
			Если СтрНайти(ТекВложение.Ключ, ШаблонПоиска) > 0 Тогда
				ДвоичныеДанные = ТекВложение.Значение;
				Если СтрЗаканчиваетсяНа(ТекВложение.Ключ,".zip") > 0 Тогда
					ФайлЗапакован = Истина;
				КонецЕсли;
				// Перепишем точный шаблон имени файла как имя вложения без расширения.
				СтруктураИмениВложенногоФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ТекВложение.Ключ,Ложь);
				ШаблонИмениФайлаСообщения = СтруктураИмениВложенногоФайла.ИмяБезРасширения;
				Прервать;
			КонецЕсли;
		КонецЦикла;
			
		Если ДвоичныеДанные = Неопределено Тогда
			ПолучитьСообщениеОбОшибке(109);
			Возврат Ложь;
		КонецЕсли;
		
		Если ФайлЗапакован Тогда
			
			// Получаем имя для временного файла архива.
			ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
			
			Попытка
				ДвоичныеДанные.Записать(ИмяВременногоФайлаАрхива);
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(106);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
			
			// Распаковываем временный файл архива.
			УспешноРаспаковано = ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоФайлаАрхива, ИмяКаталогаСообщенияОбмена(), ПарольАрхиваСообщенияОбмена);
			
			Если Не УспешноРаспаковано Тогда
				ПолучитьСообщениеОбОшибке(2);
				Возврат Ложь;
			КонецЕсли;
			
			// Проверка на существование файла сообщения.
			Файл = Новый Файл(ИмяФайлаСообщенияОбмена());
			
			Если Не Файл.Существует() Тогда
				// Возможно, имя архива не соответствует имени файла внутри.
				СтруктураИмениФайлаСообщения = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаСообщенияОбмена(),Ложь);

				Если ШаблонИмениФайлаСообщения <> СтруктураИмениФайлаСообщения.ИмяБезРасширения Тогда
					МассивРаспакованныхФайлов = НайтиФайлы(ИмяКаталогаСообщенияОбмена(), "*.xml", Ложь);
					Если МассивРаспакованныхФайлов.Количество() > 0 Тогда
						РаспакованныйФайл = МассивРаспакованныхФайлов[0];
						ПереместитьФайл(РаспакованныйФайл.ПолноеИмя,ИмяФайлаСообщенияОбмена());
					Иначе
						ПолучитьСообщениеОбОшибке(5);
						Возврат Ложь;
					КонецЕсли;
				Иначе
					ПолучитьСообщениеОбОшибке(5);
					Возврат Ложь;
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			Попытка
				ДвоичныеДанные.Записать(ИмяФайлаСообщенияОбмена());
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(106);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПолучитьСообщениеОбОшибке(НомерСообщения)
	
	УстановитьСтрокуСообщенияОбОшибке(СообщенияОшибок[НомерСообщения]);
	
КонецПроцедуры

Процедура УстановитьСтрокуСообщенияОбОшибке(Знач Сообщение)
	
	Если Сообщение = Неопределено Тогда
		Сообщение = НСтр("ru='Внутренняя ошибка';uk='Внутрішня помилка'");
	КонецЕсли;
	
	СтрокаСообщенияОбОшибке   = Сообщение;
	СтрокаСообщенияОбОшибкеЖР = ИмяОбъекта + ": " + Сообщение;
	
КонецПроцедуры

Процедура ДополнитьСообщениеОбОшибке(Сообщение)
	
	СтрокаСообщенияОбОшибкеЖР = СтрокаСообщенияОбОшибкеЖР + Символы.ПС + Сообщение;
	
КонецПроцедуры

// Переопределяемая функция, возвращает максимально допустимый размер
// сообщения, которое может быть отправлено.
// 
Функция МаксимальныйДопустимыйРазмерСообщения()
	
	Возврат EMAILМаксимальныйДопустимыйРазмерСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Флаг сжатия файла исходящего сообщения.
// 
Функция СжиматьФайлИсходящегоСообщения()
	
	Возврат EMAILСжиматьФайлИсходящегоСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Инициализация

Процедура ИнициализацияСообщений()
	
	СтрокаСообщенияОбОшибке   = "";
	СтрокаСообщенияОбОшибкеЖР = "";
	
КонецПроцедуры

Процедура ИнициализацияСообщенийОшибок()
	
	СообщенияОшибок = Новый Соответствие;
	
	// Общие коды ошибок
	СообщенияОшибок.Вставить(001, НСтр("ru='Не обнаружены сообщения обмена.';uk='Не виявлені повідомлення обміну.'"));
	СообщенияОшибок.Вставить(002, НСтр("ru='Ошибка при распаковке сжатого файла сообщения.';uk='Помилка при розпакуванні стислого файлу повідомлення.'"));
	СообщенияОшибок.Вставить(003, НСтр("ru='Ошибка при сжатии файла сообщения обмена.';uk='Помилка при стиску файлу повідомлення обміну.'"));
	СообщенияОшибок.Вставить(004, НСтр("ru='Ошибка при создании временного каталога.';uk='Помилка при створенні тимчасового каталогу.'"));
	СообщенияОшибок.Вставить(005, НСтр("ru='Архив не содержит файл сообщения обмена.';uk='Архів не містить файл повідомлення обміну.'"));
	СообщенияОшибок.Вставить(006, НСтр("ru='Сообщение обмена не отправлено: превышен допустимый размер сообщения.';uk='Повідомлення обміну не відправлено: перевищений припустимий розмір повідомлення.'"));
	
	// Коды ошибок, зависящие от вида транспорта.
	СообщенияОшибок.Вставить(101, НСтр("ru='Ошибка инициализации: не указана учетная запись электронной почты транспорта сообщений обмена.';uk='Помилка ініціалізації: не зазначений обліковий запис електронної пошти транспорту повідомлень обміну.'"));
	СообщенияОшибок.Вставить(102, НСтр("ru='Ошибка при отправке сообщения электронной почты.';uk='Помилка при відправленні повідомлення електронної пошти.'"));
	СообщенияОшибок.Вставить(103, НСтр("ru='Ошибка при получении заголовков сообщений с сервера электронной почты.';uk='Помилка при одержанні заголовків повідомлень із сервера електронної пошти.'"));
	СообщенияОшибок.Вставить(104, НСтр("ru='Не обнаружены сообщения обмена на почтовом сервере.';uk='Не виявлені повідомлення обміну на поштовому сервері.'"));
	СообщенияОшибок.Вставить(105, НСтр("ru='Ошибка при получении сообщения с сервера электронной почты.';uk='Помилка при одержанні повідомлення із сервера електронної пошти.'"));
	СообщенияОшибок.Вставить(106, НСтр("ru='Ошибка при записи файла сообщения обмена на диск.';uk='Помилка при записі файлу повідомлення обміну на диск.'"));
	СообщенияОшибок.Вставить(107, НСтр("ru='Проверка параметров учетной записи завершилась с ошибками.';uk='Перевірка параметрів облікового запису завершився з помилками.'"));
	СообщенияОшибок.Вставить(108, НСтр("ru='Превышен допустимый размер сообщения обмена.';uk='Перевищений припустимий розмір повідомлення обміну.'"));
	СообщенияОшибок.Вставить(109, НСтр("ru='Ошибка: в почтовом сообщении не найден файл с сообщением.';uk='Помилка: у поштовому повідомленні не знайдений файл із повідомленням.'"));
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Работа с E-MAIL

Функция ОтправитьСообщениеПоЭлектроннойПочте(Тело, ИмяФайлаИсходящегоСообщения, ПутьКФайлу)
	
	Вложения = Новый Соответствие;
	Вложения.Вставить(ИмяФайлаИсходящегоСообщения,
						Новый ДвоичныеДанные(ПутьКФайлу));
	
	АдресЭлектроннойПочты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(EMAILУчетнаяЗапись, "АдресЭлектроннойПочты");					
						
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Кому",     АдресЭлектроннойПочты);
	ПараметрыСообщения.Вставить("Тема",     ТемаСообщения);
	ПараметрыСообщения.Вставить("Тело",     Тело);
	ПараметрыСообщения.Вставить("Вложения", Вложения);
	
	Попытка
		ОбщийМодульРаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(EMAILУчетнаяЗапись, ПараметрыСообщения);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ИнициализацияСообщений();
ИнициализацияСообщенийОшибок();

ВременныйКаталогСообщенийОбмена = Неопределено;
ВременныйФайлСообщенияОбмена    = Неопределено;

ИмяОбъекта = НСтр("ru='Обработка: %1';uk='Обробка: %1'");
ИмяОбъекта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИмяОбъекта, Метаданные().Имя);

Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
	ОбщийМодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
КонецЕсли;

#КонецОбласти

#КонецЕсли