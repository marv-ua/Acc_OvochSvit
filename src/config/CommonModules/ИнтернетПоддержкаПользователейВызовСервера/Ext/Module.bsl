﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейВызовСервера.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, доступно ли текущему пользователю выполнение подключения
// Интернет-поддержки: авторизация/регистрация пользователя, регистрация
// программного продукта в соответствии с текущим режимом работы
// и правами пользователя.
//
// Возвращаемое значение:
//	Булево - Истина - подключение Интернет-поддержки доступно,
//		Ложь - в противном случае.
//
Функция ДоступноПодключениеИнтернетПоддержки() Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Записывает в журнал регистрации описание ошибки
// с именем события "Интернет-поддержка пользователей.Ошибка".
//
// Параметры:
//	СообщениеОбОшибке - Строка - строковое представление ошибки.
//	Данные - Произвольный - данные, к которым относится сообщение об ошибке.
//
Процедура ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке, Данные = Неопределено) Экспорт
	
	ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке, Данные);
	
КонецПроцедуры

#Область Тарификация

Функция УслугаПодключена(Знач ИдентификаторУслуги, Знач ЗначениеРазделителя = Неопределено) Экспорт
	
	Результат = ИнтернетПоддержкаПользователей.УслугаПодключена(ИдентификаторУслуги, ЗначениеРазделителя);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ЛогИОтладка

// Процедура записывает сообщение в журнал регистрации.
//
// Параметры:
//  ИмяСобытия                      - строка;
//  ИдентификаторШага               - строка;
//  УровеньРегистрации              - строковое представление константы УровеньЖурналаРегистрации;
//  ОбъектМетаданных                - строковое представление объекта метаданных;
//  Данные                          - данные;
//  Комментарий                     - строка - произвольный комментарий;
//  ВестиПодробныйЖурналРегистрации - Булево - признак записи незначащих событий (Информации и Примечания).
//
Процедура ЗаписатьСообщениеВЖурналРегистрации(
			ИмяСобытия,
			ИдентификаторШага,
			УровеньРегистрации = "Ошибка",
			ОбъектМетаданных = "",
			Данные = Неопределено,
			Комментарий = "",
			ВестиПодробныйЖурналРегистрации = Истина) Экспорт

	ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
		ИмяСобытия,
		ИдентификаторШага,
		УровеньРегистрации,
		ОбъектМетаданных,
		Данные,
		Комментарий,
		ВестиПодробныйЖурналРегистрации);

КонецПроцедуры

// Выгружает журнал регистрации по событиям во временное хранилище.
//
// Параметры:
//  ПараметрыОтбора - Структура - структура с ключами:
//   * ДатаНачала    - Дата - начало периода журнала;
//   * ДатаОкончания - Дата - конец периода журнала;
//   * Событие       - Массив - массив событий 
//  ПараметрыФайлаВыгрузки - Структура, Неопределено - структура с ключами:
//   * Архивировать - Булево - Истина, если необходимо архивировать выгрузку.
//
// Возвращаемое значение:
//   Структура с ключами:
//    * АдресВременногоХранилищаФайла - Строка - Адрес выгруженных данных в хранилище;
//    * ТекстОшибки - Строка - Текст ошибки или пустая строка.
//
Функция ВыгрузитьВсеСобытияЖурналаРегистрации(ПараметрыОтбора, ПараметрыФайлаВыгрузки) Экспорт

	Результат = ИнтернетПоддержкаПользователей.ВыгрузитьВсеСобытияЖурналаРегистрации(ПараметрыОтбора, ПараметрыФайлаВыгрузки);

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПередНачаломРаботыСистемы(Знач ПараметрыКлиента) Экспорт
	
	Результат = Новый Структура;
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСеанса.ПараметрыКлиентаНаСервереБИП = Новый ФиксированнаяСтруктура(ПараметрыКлиента);
	УстановитьПривилегированныйРежим(Ложь);
	
	КлиентЛицензирования.ПередНачаломРаботыСистемы();
	Результат.Вставить("ДоступнаРаботаСНастройкамиКлиентаЛицензирования",
		ИнтернетПоддержкаПользователей.ДоступнаРаботаСНастройкамиКлиентаЛицензирования());
	
	Возврат Результат;
	
КонецФункции

// Преобразует переданную строку в форматированную строку текста HTML.
//
Функция ФорматированнаяСтрокаИзHTML(Знач ТекстСообщения) Экспорт
	
	Возврат ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
		ТекстСообщения);
	
КонецФункции

Функция КонфигурацияЗарегистрированаВСервисеИПП(ОшибкаОбращенияКВебСервису) Экспорт
	
	Возврат Ложь;

КонецФункции

#Область БСПНастройкиПрограммы

Процедура ВыйтиИзИПП() Экспорт
	
	// Проверка права записи данных
	Если Не ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП() Тогда
		ВызватьИсключение НСтр("ru='Недостаточно прав для записи данных аутентификации Интернет-поддержки.';uk='Недостатньо прав для запису даних аутентифікації Інтернет-підтримки.'");
	КонецЕсли;
	
	// Запись данных
	УстановитьПривилегированныйРежим(Истина);
	ИнтернетПоддержкаПользователей.СохранитьДанныеАутентификации(Неопределено);
	
	// Удаление данные кэша подключения тестовых периодов
	// и существующих регламентных заданий.
	ПодключениеСервисовСопровождения.ОтключитьИнтернетПоддержкуПользователей();
	
КонецПроцедуры

#КонецОбласти

#Область КлиентЛицензирования

// Возвращает Истина, если доступна работа с настройками клиента лицензирования,
// Ложь - в противном случае.
//
Функция ДоступнаРаботаСНастройкамиКлиентаЛицензирования()
	
	Возврат ИнтернетПоддержкаПользователей.ДоступнаРаботаСНастройкамиКлиентаЛицензирования();
	
КонецФункции

#КонецОбласти

#Область ОтправкаСообщенийВСлужбуТехническойПоддержки

Функция ОтправитьДанныеСообщенияВТехПоддержку(
	Знач Тема,
	Знач Сообщение,
	Знач Получатель,
	Знач Вложения,
	Знач ДопПараметры) Экспорт
	
	// Извлечение данных из временного хранилища.
	Если Вложения <> Неопределено Тогда
		Для каждого ТекВложение Из Вложения Цикл
			Если ТекВложение.Свойство("Адрес") Тогда
				ДДФайла = ПолучитьИзВременногоХранилища(ТекВложение.Адрес);
				ТекВложение.Вставить(
					"Текст",
					ИнтернетПоддержкаПользователейКлиентСервер.ТекстВДвоичныхДанных(ДДФайла));
				ТекВложение.Удалить("Адрес");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НастройкиСоединенияССерверами = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	
	Результат = ИнтернетПоддержкаПользователейКлиентСервер.ОтправитьДанныеСообщенияВТехПоддержку(
		Тема,
		Сообщение,
		Получатель,
		Вложения,
		НастройкиСоединенияССерверами,
		ДопПараметрыОтправкиСообщения(ДопПараметры));
	
	Результат.Вставить("Предупреждение", "");
	
	Если ПустаяСтрока(Результат.КодОшибки) Тогда
		ЗаполнитьПараметрыСтраницыОтправкиСообщенияВТехПоддержку(Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция URLСтраницыОтправкиСообщенияВТехПоддержку(Домен, ТокенДанных)

	Возврат "https://"
		+ ИнтернетПоддержкаПользователейКлиентСервер.ХостСервисовТехническойПоддержки(Домен)
		+ "/confirm?uuid=" + ТокенДанных;

КонецФункции

Процедура ЗаполнитьПараметрыСтраницыОтправкиСообщенияВТехПоддержку(ПараметрыСообщения)
	
	НастройкиСоединенияССерверами = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	
	ПараметрыСообщения.Вставить("URLСтраницы", "");
	ПараметрыСообщения.URLСтраницы = URLСтраницыОтправкиСообщенияВТехПоддержку(
		НастройкиСоединенияССерверами.ДоменРасположенияСерверовИПП,
		ПараметрыСообщения.ТокенДанных);
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		РезультатПолученияТикета =
			ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки(ПараметрыСообщения.URLСтраницы);
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ЗначениеЗаполнено(РезультатПолученияТикета.Тикет) Тогда
			ПараметрыСообщения.URLСтраницы = ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
				"/ticket/auth?token=" + РезультатПолученияТикета.Тикет,
				НастройкиСоединенияССерверами);
		Иначе
			Если РезультатПолученияТикета.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
				ПараметрыСообщения.Предупреждение = НСтр("ru='Ошибка входа на Портал ИТС.
                    |Подробнее см. в журнале регистрации.'
                    |;uk='Помилка входу на Портал ІТС.
                    |Докладніше див. у журналі реєстрації.'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДопПараметрыОтправкиСообщения(Знач ДопПараметры)
	
	Результат = Новый Структура;
	Результат.Вставить("Логин"         , "");
	Результат.Вставить("ПарольЗаполнен", Ложь);
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	Если ДанныеАутентификации <> Неопределено Тогда
		Результат.Логин = ДанныеАутентификации.Логин;
		Результат.ПарольЗаполнен = ЗначениеЗаполнено(ДанныеАутентификации.Пароль);
	КонецЕсли;
	
	Результат.Вставить("ШаблонТекстаСообщения", ШаблонТекстаСообщения(ДопПараметры));
	
	Вложения = Новый Массив;
	Вложения.Добавить(
		Новый Структура(
			"Представление, Текст",
			НСтр("ru='Техническая информация.txt';uk='Технічна информация.txt'"),
			ТекстВложенияТехническаяИнформация(
				ДопПараметры.ВидПриложения,
				Результат)));
	
	Результат.Вставить("Вложения", Вложения);
	
	Возврат Результат;
	
КонецФункции

Функция ШаблонТекстаСообщения(ДопПараметры)
	
	Возврат НСтр("ru='Здравствуйте!
            |
            |%msgtxt
            |
            |Регистрационный номер программного продукта: <Укажите рег. номер>;
            |Организация: <Укажите название организации>.
            |С уважением,
            |.'
            |;uk='Доброго дня!
            |
            |%msgtxt
            |
            |Реєстраційний номер програмного продукту: <Вкажіть реєстр. номер>;
            |Організація: <Вкажіть назву організації>.
            |З повагою,
            |.'");
	
КонецФункции

// Возвращает текст описания технических параметров программы.
Функция ТекстВложенияТехническаяИнформация(ВидПриложения, ДопПараметры)
	
	// Общие технические параметры и информация о сеансе
	СистИнфо = Новый СистемнаяИнформация;
	ЭтоФайловаяИБ = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ИмяПрограммы = Строка(ИнтернетПоддержкаПользователей.СлужебнаяИмяПрограммы());
	Если ИмяПрограммы = "Unknown" Тогда
		ИмяПрограммы = НСтр("ru='<Не заполнено>';uk='<Не заповлене>'");
	КонецЕсли;
	
	// Общая информация:
	Результат = НСтр("ru='Техническая информация о программе:
        |Название программы: %1
        |Имя программы: %2;
        |Версия программы: %3;
        |Поставщик: %4;
        |Версия Платформы: %5;
        |Версия Библиотеки Интернет-поддержки: %6;
        |Версия Библиотеки стандартных подсистем: %7;
        |Вид приложения: %8;
        |Режим: %9;'
        |;uk='Технічна інформація про програму:
        |Назва програми: %1
        |Ім''я програми: %2;
        |Версія програми: %3;
        |Постачальник: %4;
        |Версія Платформи: %5;
        |Версія Бібліотеки Інтернет-підтримки: %6;
        |Версія Бібліотеки стандартних підсистем: %7;
        |Вид програми: %8;
        |Режим: %9;'");
	
	Результат =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Результат,
			Метаданные.Синоним,
			ИмяПрограммы
				+ " (" + Строка(ИнтернетПоддержкаПользователей.ИмяКонфигурации()) + ")",
			Строка(ИнтернетПоддержкаПользователей.ВерсияКонфигурации()),
			Метаданные.Поставщик,
			Строка(СистИнфо.ВерсияПриложения),
			ИнтернетПоддержкаПользователейКлиентСервер.ВерсияБиблиотеки(),
			СтандартныеПодсистемыСервер.ВерсияБиблиотеки(),
			ВидПриложения,
			?(ЭтоФайловаяИБ, НСтр("ru='Файловый';uk='Файловий'"), НСтр("ru='Серверный';uk='Серверний'")));
	
	// Права:
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Полные права: %1;
                |Права администратора: %2;
                |Права для подключения Интернет-поддержки: %3;'
                |;uk='Повні права: %1;
                |Права адміністратора: %2;
                |Права для підключення Інтернет-підтримки: %3;'"),
			?(Пользователи.ЭтоПолноправныйПользователь(, Ложь, Ложь), НСтр("ru='есть';uk='є'"), НСтр("ru='нет';uk='немає'")),
			?(Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь), НСтр("ru='есть';uk='є'"), НСтр("ru='нет';uk='немає'")),
			?(ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП(), НСтр("ru='есть';uk='є'"), НСтр("ru='нет';uk='немає'")));
	
	// Личные данные:
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Логин для подключения Интернет-поддержки: %1;
                |Пароль для подключения Интернет-поддержки: %2;
                |Регистрационный номер программного продукта: %3;'
                |;uk='Логін для підключення Інтернет-підтримки: %1;
                |Пароль для підключення Інтернет-підтримки: %2;
                |Реєстраційний номер програмного продукту: %3;'"),
			ДопПараметры.Логин,
			?(ДопПараметры.ПарольЗаполнен, НСтр("ru='заполнен';uk='заповнений'"), НСтр("ru='не заполнен';uk='не заповнено'")),
			ИнтернетПоддержкаПользователей.РегистрационныйНомерПрограммногоПродукта());
	
	// Настройки соединения:
	НастройкиСоединения = ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами();
	Результат = Результат
		+ Символы.ПС
		+ НСтр("ru='Настройки соединения с серверами Интернет-поддержки:
                |	Доменная зона: bas-soft.eu'
                |;uk='Настройки з''єднання з серверами Інтернет-підтримки:
                |	Доменна зона: bas-soft.eu'");	
	
	// Настройки прокси:
	НастройкиПрокси = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	Если НастройкиПрокси = Неопределено Тогда
		ЗначениеНастройкиПрокси = НСтр("ru='не используется';uk='не використовується'");
	Иначе
		Если НастройкиПрокси.Получить("ИспользоватьПрокси") Тогда
			ЗначениеНастройкиПрокси = ?(НастройкиПрокси.Получить("ИспользоватьСистемныеНастройки"),
				НСтр("ru='автоматические';uk='автоматичні'"),
				НСтр("ru='ручные';uk='ручні'"));
		Иначе
			ЗначениеНастройкиПрокси = НСтр("ru='не используется';uk='не використовується'");
		КонецЕсли;
	КонецЕсли;
	
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Настройки прокси-сервера: %1';uk='Настройки проксі-сервера: %1'"),
			ЗначениеНастройкиПрокси);
	
	// Настройки клиента лицензирования:
	Если ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Тогда
		ИДКонфигурации = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.ИДКонфигурации();
		Если Не ПустаяСтрока(ИДКонфигурации) Тогда
			Результат = Результат + Символы.ПС
				+ НСтр("ru='Имя клиента лицензирования:';uk='Ім''я клієнта ліцензування:'") + " "
				+ КлиентЛицензирования.ИмяКлиентаЛицензирования()
				+ Символы.ПС + НСтр("ru='Идентификатор конфигурации:';uk='Ідентифікатор конфігурації:'")
				+ Символы.ПС + ИДКонфигурации;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыИФункции

// Прокси-функция для получения тикета в контексте сервера платформы
// при вызове из клиентского приложения.
//
Функция ТикетАутентификацииДляОткрытияСтраницы(Знач URLСтраницы) Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.ТикетАутентификацииДляОткрытияСтраницы(URLСтраницы);
	
КонецФункции

#КонецОбласти

#КонецОбласти
