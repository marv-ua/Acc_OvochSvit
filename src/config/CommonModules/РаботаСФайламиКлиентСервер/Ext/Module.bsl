﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать РаботаСФайлами.ОпределитьФормуПрисоединенногоФайла.
// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы файла.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника с именем "*ПрисоединенныеФайлы".
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОпределитьФормуПрисоединенногоФайла(Источник,
                                                      ВидФормы,
                                                      Параметры,
                                                      ВыбраннаяФорма,
                                                      ДополнительнаяИнформация,
                                                      СтандартнаяОбработка) Экспорт
	
	РаботаСФайламиСлужебныйВызовСервера.ОпределитьФормуПрисоединенногоФайла(
		Источник,
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Инициализирует структуру со сведениями о файле.
//
// Параметры:
//   Режим        - Строка - "Файл" или "ФайлСВерсией".
//   ИсходныйФайл - Файл   - файл, на основании которого заполняются свойства структуры.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//    * ИмяБезРасширения             - Строка - имя файла без расширения.
//    * РасширениеБезТочки           - Строка - расширение файла.
//    * ВремяИзменения               - Дата   - дата и время изменения файла.
//    * ВремяИзмененияУниверсальное  - Дата   - UTC дата и время изменения файла.
//    * Размер                       - Число  - размер файла в байтах.
//    * АдресВременногоХранилищаФайла  - Строка, ХранилищеЗначения - адрес во временном хранилище с двоичными данными
//                                       файла или непосредственно двоичные данные файла.
//    * АдресВременногоХранилищаТекста - Строка, ХранилищеЗначения - адрес во временном хранилище с извлеченным текстов
//                                       для ППД или непосредственно сами данные с текстом.
//    * ЭтоВебКлиент                 - Булево - Истина, если вызов идет из веб клиента.
//    * Автор                        - СправочникСсылка.Пользователи - автор файла. Если Неопределено, то текущий
//                                                                     пользователь.
//    * Комментарий                  - Строка - комментарий к файлу.
//    * ЗаписатьВИсторию             - Булево - записать в историю работы пользователя.
//    * ХранитьВерсии                - Булево - разрешить хранение версий у файла в ИБ;
//                                              при создании новой версии - создавать новую версию, или изменять
//                                              существующую (Ложь).
//    * Зашифрован                   - Булево - файл зашифрован.
//
Функция СведенияОФайле(Знач Режим, Знач ИсходныйФайл = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяБезРасширения");
	Результат.Вставить("Комментарий", "");
	Результат.Вставить("АдресВременногоХранилищаТекста");
	Результат.Вставить("Автор");
	Результат.Вставить("ИмяСправочникаХранилищаФайлов", "Файлы");
	Результат.Вставить("АдресВременногоХранилищаФайла");
	Результат.Вставить("РасширениеБезТочки");
	Результат.Вставить("ВремяИзменения", Дата('00010101'));
	Результат.Вставить("ВремяИзмененияУниверсальное", Дата('00010101'));
	Результат.Вставить("Размер", 0);
	Результат.Вставить("Зашифрован");
	Результат.Вставить("ЗаписатьВИсторию", Ложь);
	Результат.Вставить("Кодировка");
	Результат.Вставить("НовыйСтатусИзвлеченияТекста");
	Если Режим = "ФайлСВерсией" Тогда
		Результат.Вставить("ХранитьВерсии", Истина);
		Результат.Вставить("СсылкаНаВерсиюИсточник");
		Результат.Вставить("НоваяВерсияДатаСоздания");
		Результат.Вставить("НоваяВерсияАвтор");
		Результат.Вставить("НоваяВерсияКомментарий");
		Результат.Вставить("НоваяВерсияНомерВерсии");
	Иначе
		Результат.Вставить("ХранитьВерсии", Ложь);
	КонецЕсли;
	
	Если ИсходныйФайл <> Неопределено Тогда
		Результат.ИмяБезРасширения            = ИсходныйФайл.ИмяБезРасширения;
		Результат.РасширениеБезТочки          = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ИсходныйФайл.Расширение);
		Результат.ВремяИзменения              = ИсходныйФайл.ПолучитьВремяИзменения();
		Результат.ВремяИзмененияУниверсальное = ИсходныйФайл.ПолучитьУниверсальноеВремяИзменения();
		Результат.Размер                      = ИсходныйФайл.Размер();
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определить, можно ли занять файл и, если нет, то сформировать текст ошибки.
//
// Параметры:
//  ДанныеФайла  - Структура - структура с данными файла.
//  СтрокаОшибки - Строка - (возвращаемое значение) - если файл занять нельзя,
//                 тогда содержит описание ошибки.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда текущий пользователь может занять файл или
//           файл уже занят текущим пользователем.
//
Функция МожноЛиЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт
	
	Если ДанныеФайла.ПометкаУдаления = Истина Тогда
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Нельзя занять файл ""%1"",
                       |т.к. он помечен на удаление.'
                       |;uk='Не можна зайняти файл ""%1"",
                       |т. я. він відмічений для вилучення.'"),
			Строка(ДанныеФайла.Ссылка));
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Не ЗначениеЗаполнено(ДанныеФайла.Редактирует) Или ДанныеФайла.ФайлРедактируетТекущийПользователь;  
	
	Если Не Результат Тогда
		
		ДатаЗаема = ?(ЗначениеЗаполнено(ДанныеФайла.ДатаЗаема), 
			" " + НСтр("ru='с';uk='з'") + " " + Формат(ДанныеФайла.ДатаЗаема, "ДЛФ=ДВ"), "");
		
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Файл ""%1""
                       |уже занят для редактирования пользователем
                       |""%2""%3.'
                       |;uk='Файл ""%1""
                       |вже зайнятий для редагування користувачем
                       |""%2""%3.'"),
			Строка(ДанныеФайла.Ссылка), Строка(ДанныеФайла.Редактирует), ДатаЗаема);
			
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru='Файлы';uk='Файли'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция СобытиеЖурналаРегистрацииСинхронизация() Экспорт
	
	Возврат НСтр("ru='Синхронизация файлов с облачным сервисом';uk='Синхронізація файлів з хмарним сервісом'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти