﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммыКлиент.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает помощник обновления программы в режиме рабочего обновления:
// обновление версии конфигурации и/или платформы.
//
Процедура ОбновитьПрограмму() Экспорт
	
	ОткрытьФорму("Обработка.ОбновлениеПрограммы.Форма.Форма",
		Новый Структура("Сценарий", "РабочееОбновление"));
	
КонецПроцедуры

// Открывает помощник обновления программы в режиме перехода на новую редакцию
// конфигурации.
//
// Параметры:
//	НомерРедакции - Строка - номер редакции, на которую выполняется переход.
//		Заполняется в формате <Номер редакции>.<Номер подредакции>,
//		например "3.0", "3.1" или др.
//	ДополнительныеПараметры - Структура - дополнительные параметры открытия
//		помощника обновления. Поля структуры:
//		* ЗаголовокОкна - Строка - заголовок окна помощника обновления;
//		* ЗаголовокДоступноОбновление - Строка - заголовок информации о
//			доступном обновлении. Если не передан или не заполнен, тогда
//			заголовок не отображается;
//		* ЗаголовокНетОбновления - Строка - текст заголовка информации о
//			доступном обновлении, который должен отображаться при отсутствии обновления.
//			Если не передан или не заполнен, тогда
//			заголовок не отображается.
//
Процедура ПерейтиНаНовуюРедакцию(НомерРедакции, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(НомерРедакции) Тогда
		ВызватьИсключение НСтр("ru='Не передан номер редакции.';uk='Не переданий номер редакції.'");
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сценарий"          , "ПереходНаДругуюПрограммуИлиРедакцию");
	ПараметрыФормы.Вставить("НомерНовойРедакции", НомерРедакции);
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		Для Каждого КлючЗначение Из ДополнительныеПараметры Цикл
			ПараметрыФормы.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ОбновлениеПрограммы.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

// Открывает помощник обновления программы в режиме перехода на
// другую программу.
//
// Параметры:
//	ИмяНовойПрограммы - Строка - имя программы, на которую выполняется переход
//		(см. ИнтернетПоддержкаПользователейПереопределяемый.ПриОпределенииИмениПрограммы());
//	НомерРедакции - Строка - номер редакции другой программы. Заполняется в
//		формате <Номер редакции>.<Номер подредакции>, например "3.0", "3.1" или др.
//		Если не передан, тогда выполняется переход на версию с наивысшим номером;
//	ДополнительныеПараметры - Структура - дополнительные параметры открытия
//		помощника обновления. Поля структуры:
//		* ЗаголовокОкна - Строка - заголовок окна помощника обновления;
//		* ЗаголовокДоступноОбновление - Строка - заголовок информации о
//			доступном обновлении. Если не передан или не заполнен, тогда
//			заголовок не отображается;
//		* ЗаголовокНетОбновления - Строка - текст заголовка информации о
//			доступном обновлении, который должен отображаться при отсутствии обновления.
//			Если не передан или не заполнен, тогда
//			заголовок не отображается.
//
Процедура ПерейтиНаДругуюПрограмму(
	ИмяНовойПрограммы,
	НомерРедакции = Неопределено,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяНовойПрограммы) Тогда
		ВызватьИсключение НСтр("ru='Не передано имя новой программы.';uk='Не передано ім''я нової програми.'");
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сценарий"          , "ПереходНаДругуюПрограммуИлиРедакцию");
	ПараметрыФормы.Вставить("ИмяНовойПрограммы" , ИмяНовойПрограммы);
	ПараметрыФормы.Вставить("НомерНовойРедакции", НомерРедакции);
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		Для Каждого КлючЗначение Из ДополнительныеПараметры Цикл
			ПараметрыФормы.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ОбновлениеПрограммы.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

// Возвращает информацию о доступном обновлении
// программы в сценарии рабочего обновления.
//
// Возвращаемое значение:
//	Структура - информация о доступном обновлении.
//		Поля:
//		* Ошибка - Булево - признак возникновения ошибки при получении
//			информации о доступном обновлении. Истина - возникла ошибка,
//			Ложь - в противном случае;
//		* Сообщение - Строка - сообщение об ошибке, которое может быть
//			отображено пользователю;
//		* ИнформацияОбОшибке - Строка - подробное описание ошибки, которое
//			может быть записано в журнал регистрации;
//		* ДоступноОбновление - Булево - признак наличия обновлений.
//			Истина - доступно по меньшей мере одно обновление,
//			Ложь - в противном случае.
//		* Конфигурация - Структура - информация о доступном обновлении конфигурации.
//			Если обновление отсутствует, тогда значение Неопределено.
//			Поля:
//			** Версия - Строка - номер версии конфигурации;
//			** МинимальнаяВерсияПлатформы - Строка - минимальная версия платформы,
//				необходимая для перехода на эту версию конфигурации;
//			** РазмерОбновления - Число - размер обновления в байтах;
//			** URLНовоеВВерсии - Строка - URL файла описания "Новое в версии";
//			** URLПорядокОбновления - Строка - URL файла описания "Порядок обновления";
//		* Платформа - Структура - информация о доступном обновлении платформы.
//			Если обновление отсутствует, тогда значение Неопределено.
//			Поля:
//			** Версия - Строка - номер версии платформы;
//			** РазмерОбновления - Число - размер обновления в байтах;
//			** URLОсобенностиПерехода - Строка - URL файла описания "Особенности перехода на
//				новую версию платформы";
//			** URLСтраницыПлатформы - Строка - URL веб-страницы для ручного
//				получения дистрибутива;
//			** ОбязательностьУстановки - Число - обязательность применения обновления платформы:
//				0 - обязательно;
//				1 - рекомендуется;
//				2 - не обязательно.
//
Функция ИнформацияОДоступномОбновлении() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнтернетПоддержкаПользователей;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("НастройкиСоединения", ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами());
	Результат = ПолучениеОбновленийПрограммыВызовСервера.ИнформацияОДоступномОбновлении(
		ПараметрыРаботыКлиента.ИмяПрограммы,
		ПараметрыРаботыКлиента.ВерсияКонфигурации,
		"",
		"",
		"РабочееОбновление");
	
	Результат.Вставить("Ошибка", Не ПустаяСтрока(Результат.ИмяОшибки));
	Результат.Удалить("ИмяОшибки");
	Результат.Удалить("Сценарий");
	
	Если Не Результат.Конфигурация.ДоступноОбновление Тогда
		Результат.Конфигурация = Неопределено;
	Иначе
		Результат.Конфигурация.Удалить("ФайлыДляЗагрузки");
		Результат.Конфигурация.Удалить("ИдентификаторВерсии");
		Результат.Конфигурация.Удалить("ДоступноОбновление");
	КонецЕсли;

	Если Не Результат.Платформа.ДоступноОбновление Тогда
		Результат.Платформа = Неопределено;
	Иначе
		Результат.Платформа.Удалить("ИдентификаторФайла");
		Результат.Платформа.Удалить("РекомендуетсяПереход");
		Результат.Платформа.Удалить("ДоступноОбновление");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#Область ИнтеграцияСБиблиотекойСтандартныхПодсистем

#Область БСПНастройкиПрограммы

// Обработчик события ПриИзменении() элемента АвтоматическаяПроверкаОбновлений
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - УправляемаяФорма - форма панели администрирования;
//	Элемент - ПолеФормы - элементы управления формы панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_АвтоматическаяПроверкаОбновленийПриИзменении(Форма, Элемент) Экспорт
	
	Элементы = Форма.Элементы;
	
	Элементы.ДекорацияРасписаниеПроверкиОбновлений.Доступность = (Форма.БИПАвтоматическаяПроверкаОбновлений = 2);
	
	НастройкиОбновления = ГлобальныеНастройкиОбновления();
	НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы =
		Форма.БИПАвтоматическаяПроверкаОбновлений;
	ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьНастройкиОбновления(НастройкиОбновления);
	
	Если ИнтернетПоддержкаПользователейКлиент.ЗначениеПараметраПриложения("ПолучениеОбновленийПрограммы\ИДЗадания") = Неопределено Тогда
		// Если выполняется задание проверки, тогда после завершения очередной проверки
		// настройки будут применены автоматически.
		Если Форма.БИПАвтоматическаяПроверкаОбновлений <> 2 Тогда
			ОтключитьПроверкуПоРасписанию();
		Иначе
			ПодключитьПроверкуПоРасписанию();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события Нажатие() элемента ДекорацияРасписаниеПроверкиОбновлений
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - УправляемаяФорма - форма панели администрирования;
//	Элемент - ПолеФормы - элементы управления формы панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_ДекорацияРасписаниеПроверкиОбновленийНажатие(Форма, Элемент) Экспорт
	
	НастройкиОбновления = ГлобальныеНастройкиОбновления();
	РасписаниеПроверки = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиОбновления.Расписание);
	ДиалогРасписание = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеПроверки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриИзмененииРасписания", ЭтотОбъект, Форма);
	ДиалогРасписание.Показать(ОписаниеОповещения);
	
КонецПроцедуры

// Обработчик события Нажатие() элемента КаталогДистрибутиваПлатформы
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - УправляемаяФорма - форма панели администрирования;
//	Элемент - ПолеФормы - элементы управления формы панели администрирования;
//	СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
//
Процедура ИнтернетПоддержкаИСервисы_КаталогДистрибутиваПлатформыНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	#Если Не ВебКлиент Тогда
	ОбщегоНазначенияКлиент.ОткрытьПроводник(Форма.БИПКаталогДистрибутиваПлатформы);
	#КонецЕсли
	
КонецПроцедуры

// Обработчик команды БИПОбновлениеПрограммы
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - УправляемаяФорма - форма панели администрирования;
//	Команда - КомандаФормы - команда на панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_ОбновлениеПрограммы(Форма, Команда) Экспорт
	
	ОбновитьПрограмму();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при начале работы системы из
// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы().
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если Не ПараметрыРаботыКлиентаПриЗапуске.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыРаботыКлиентаПриЗапуске.Свойство("ИнтернетПоддержкаПользователей") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИПП = ПараметрыРаботыКлиентаПриЗапуске.ИнтернетПоддержкаПользователей;
	Если Не ПараметрыИПП.Свойство("ПолучениеОбновленийПрограммы") Тогда
		// Использование обновления платформы недоступно в текущем режиме работы.
		Возврат;
	КонецЕсли;
	
	НастройкиОбновления = ИнтернетПоддержкаПользователейКлиент.ЗначениеИзФиксированногоТипа(
		ПараметрыИПП.ПолучениеОбновленийПрограммы);
	ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
		"ПолучениеОбновленийПрограммы\НастройкиОбновления",
		НастройкиОбновления);
	
	Если НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 0 Тогда
		// Если не используется автоматическая проверка обновлений
		ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
			"ПолучениеОбновленийПрограммы\ПроверкаПриЗапускеВыполнена", Истина);
		Возврат;
	ИначеЕсли НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы <> 1 Тогда
		ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
			"ПолучениеОбновленийПрограммы\ПроверкаПриЗапускеВыполнена", Истина);
	КонецЕсли;
	
	// Вызвать автоматическую проверку обновления через 1 секунду после начала работы программы.
	ПодключитьОбработчикОжидания("ПолучениеОбновленийПрограммы_ПроверитьНаличиеОбновлений", 1.0, Истина);
	
КонецПроцедуры

// Отображает при начале работы программы форму помощника "Переход на новую
// версию платформы" в режиме "Используется нерекомендуемая
// версия платформы".
// Первый шаг помощника - информация о том, что используется версия платформы
// ниже рекомендуемой. Доступны кнопки: "Перейти на новую версию платформы",
// "Завершить работу", "Продолжить работу на текущей версии" (в зависимости от
// переданных параметров).
// Форма помощника отображается в режиме "Блокировать весь интерфейс".
// Предназначена для Интеграции с библиотекой стандартных подсистем (БСП).
//
// Параметры:
//	ОповещениеОЗакрытии - ОписаниеОповещения - обработчик оповещения о завершении
//		работы помощника. В обработчик оповещения передается значение:
//		- "Продолжить", если пользователь нажал кнопку "Продолжить работу на текущей версии",
//		- Неопределено - во всех остальных случаях;
//	СтандартнаяОбработка - Булево - в параметре возвращается значение Ложь,
//		если необходимо выполнить стандартную обработку версии платформы,
//		из-за недоступности использования помощника в текущем режиме
//		работы.
//
// Возвращаемое значение:
//	УправляемаяФорма - форма помощника перехода на новую версию платформы.
//
Процедура ПриПроверкеВерсииПлатформыПриЗапуске(ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Попытка
		СлужебнаяПриПроверкеВерсииПлатформыПриЗапуске(ОповещениеОЗакрытии, СтандартнаяОбработка);
	Исключение
		СтандартнаяОбработка = Истина;
		ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка проверки версии платформы при запуске. %1';uk='Помилка перевірки версії платформи при запуску. %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбщегоНазначения

Функция ГлобальныеНастройкиОбновления()
	
	НастройкиОбновления = ИнтернетПоддержкаПользователейКлиент.ЗначениеПараметраПриложения(
		"ПолучениеОбновленийПрограммы\НастройкиОбновления");
	Если НастройкиОбновления = Неопределено Тогда
		НастройкиОбновления = ПолучениеОбновленийПрограммыВызовСервера.НастройкиОбновления();
		ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
			"ПолучениеОбновленийПрограммы\НастройкиОбновления", НастройкиОбновления);
	КонецЕсли;
	
	Возврат НастройкиОбновления;
	
КонецФункции

Функция ОткрытаФормаОбработкиПолученияОбновлений()
	
	ПараметрОповещения = Новый Структура("Форма", Неопределено);
	Оповестить("ПолучениеОбновленийПрограммы_ПроверкаОткрытияФормы", ПараметрОповещения, ЭтотОбъект);
	Возврат (ПараметрОповещения.Форма <> Неопределено);
	
КонецФункции

Функция ЗаписатьОшибкуВЖурналРегистрации(Сообщение) Экспорт
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		ПолучениеОбновленийПрограммыКлиентСервер.ИмяСобытияЖурналаРегистрации(),
		"Ошибка",
		Сообщение);
	
КонецФункции

Функция ЗаписатьИнформациюВЖурналРегистрации(Сообщение) Экспорт
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		ПолучениеОбновленийПрограммыКлиентСервер.ИмяСобытияЖурналаРегистрации(),
		,
		Сообщение);
	
КонецФункции

Процедура СлужебнаяПриПроверкеВерсииПлатформыПриЗапуске(ОповещениеОЗакрытии, СтандартнаяОбработка)
	
	ПараметрыПроверки = ПолучениеОбновленийПрограммыВызовСервера.ПараметрыПроверкиВерсииПлатформыПриЗапуске();
	Если ПараметрыПроверки.Продолжить Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, "Продолжить");
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПроверки.ЭтоАдминистраторСистемы Тогда
		
		// Отобразить сообщение в помощнике обновления программы.
		ОткрытьФорму("Обработка.ОбновлениеПрограммы.Форма",
			Новый Структура("Сценарий, РаботаВПрограммеЗапрещена, ТекстСообщения",
				"СообщениеОНерекомендуемойВерсииПлатформы",
				ПараметрыПроверки.РаботаВПрограммеЗапрещена,
				ПараметрыПроверки.ТекстСообщения),
			,
			,
			,
			,
			ОповещениеОЗакрытии,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		// Обычному пользователю показать сообщение в отдельной форме.
		ОткрытьФорму("ОбщаяФорма.СообщениеНеобходимоОбновитьВерсиюПлатформы",
			Новый Структура("ТекстСообщения", ПараметрыПроверки.ТекстСообщения),
			,
			,
			,
			,
			ОповещениеОЗакрытии,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаНаличияОбновлений

Процедура ПроверитьНаличиеОбновлений() Экспорт
	
	НастройкиОбновления = ГлобальныеНастройкиОбновления();
	ИДЗадания = ИнтернетПоддержкаПользователейКлиент.ЗначениеПараметраПриложения("ПолучениеОбновленийПрограммы\ИДЗадания");
	ДатаПроверки = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если ИДЗадания = Неопределено Тогда
		
		// Обработать настройки автоматической проверки обновления.
		
		ВыполнитьПроверку = Ложь;
		Если НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 1 Тогда
			Если Не ИнтернетПоддержкаПользователейКлиент.ЗначениеПараметраПриложения(
				"ПолучениеОбновленийПрограммы\ПроверкаПриЗапускеВыполнена", Ложь) Тогда
				ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
					"ПолучениеОбновленийПрограммы\ПроверкаПриЗапускеВыполнена", Истина);
				ВыполнитьПроверку = Истина;
			КонецЕсли;
			
		ИначеЕсли НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 2 Тогда
			// Определение необходимости выполнения проверки по расписанию
			
			Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиОбновления.Расписание);
			ДатаПоследнейПроверки = Неопределено;
			Если НЕ НастройкиОбновления.Свойство("ДатаПоследнейПроверки", ДатаПоследнейПроверки) Тогда
				ДатаПоследнейПроверки = '00010101';
			КонецЕсли;
			
			Если Расписание.ТребуетсяВыполнение(ДатаПроверки, ДатаПоследнейПроверки) Тогда
				ВыполнитьПроверку = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ВыполнитьПроверку Тогда
			Если НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 2 Тогда
				// Если проверка по расписанию, тогда повторить вызов через 5 минут.
				ПодключитьПроверкуПоРасписанию();
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		Если НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 2 Тогда
			// Записать дату последней проверки.
			НастройкиОбновления.Вставить("ДатаПоследнейПроверки", ДатаПроверки);
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьНастройкиОбновления(НастройкиОбновления);
		КонецЕсли;
		
		ИДЗадания = ПолучениеОбновленийПрограммыВызовСервера.НачатьПроверкуНаличияОбновления();
		Если ИДЗадания <> Неопределено Тогда
			ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
				"ПолучениеОбновленийПрограммы\ИДЗадания", ИДЗадания);
			ПодключитьОбработкуРезультатаПроверки();
		ИначеЕсли НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 2 Тогда
			ПодключитьПроверкуПоРасписанию();
		КонецЕсли;
		
	Иначе
		
		// Выполняется проверка, определить состояние проверки.
		ИнформацияОДоступномОбновлении = ПолучениеОбновленийПрограммыВызовСервера.РезультатЗаданияПроверкиНаличияОбновлений(ИДЗадания);
		Если ИнформацияОДоступномОбновлении = Неопределено Тогда
			// Задание еще не завершено, повторить вызов через 10 секунд
			ПодключитьОбработкуРезультатаПроверки();
			
		Иначе
			
			// Задание завершено.
			ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
				"ПолучениеОбновленийПрограммы\ИДЗадания", Неопределено);
			
			// Обработка результата выполнения задания
			Если ТипЗнч(ИнформацияОДоступномОбновлении) = Тип("Структура") Тогда
				ОбработатьИнформациюОДоступномОбновлении(ИнформацияОДоступномОбновлении, ДатаПроверки);
			КонецЕсли;
			
			Если НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 2 Тогда
				ПодключитьПроверкуПоРасписанию();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриНажатииОповещенияИнформацииОДоступномОбновлении(ИнформацияОбОбновлении) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сценарий"              , "РабочееОбновление");
	ПараметрыФормы.Вставить("ИнформацияОбОбновлении", ИнформацияОбОбновлении);
	ОткрытьФорму("Обработка.ОбновлениеПрограммы.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

Процедура ОбработатьИнформациюОДоступномОбновлении(ИнформацияОДоступномОбновлении, ДатаПроверки)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		ПоказатьОповещение = Ложь;
		ПолучениеОбновленийПрограммыКлиентПереопределяемый.ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях(ПоказатьОповещение);
		Если Не ПоказатьОповещение Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Отображение оповещения.
	Если Не ПустаяСтрока(ИнформацияОДоступномОбновлении.ИмяОшибки) Тогда
		
		Если ИнформацияОДоступномОбновлении.ИмяОшибки = "ConnectError"
			ИЛИ ИнформацияОДоступномОбновлении.ИмяОшибки = "ServerError"
			ИЛИ ИнформацияОДоступномОбновлении.ИмяОшибки = "ClientError" Тогда
			
			// Обработать ошибку подключения
			Если Не ОткрытаФормаОбработкиПолученияОбновлений() Тогда
				ПоказатьОповещениеПользователя(
					НСтр("ru='Обновление программы';uk='Оновлення програми'"),
					Новый ОписаниеОповещения(
						"ПриНажатииОповещенияИнформацииОДоступномОбновлении",
						ЭтотОбъект,
						ИнформацияОДоступномОбновлении),
					НСтр("ru='Не удалось проверить наличие обновлений программы.';uk='Не вдалося перевірити наявність оновлень програми.'"),
					БиблиотекаКартинок.Ошибка32,
					СтатусОповещенияПользователя.Важное,
					"ПолучениеОбновленийПрограммы");
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ИнформацияОДоступномОбновлении.ДоступноОбновление Тогда
			
			Если ОткрытаФормаОбработкиПолученияОбновлений() Тогда
				Возврат;
			КонецЕсли;
			
			ЭтоФайловаяИБ = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
			ОбновлениеКомКонф = ИнформацияОДоступномОбновлении.Конфигурация;
			ОбновлениеКомПл   = ИнформацияОДоступномОбновлении.Платформа;
			РазмерОбновления = ?(ОбновлениеКомКонф.ДоступноОбновление, ОбновлениеКомКонф.РазмерОбновления, 0)
				+ ?(ОбновлениеКомПл.ДоступноОбновление И ЭтоФайловаяИБ
					И (Не ОбновлениеКомКонф.ДоступноОбновление Или ОбновлениеКомПл.ОбязательностьУстановки < 2),
					ОбновлениеКомПл.РазмерОбновления,
					0);
			
			ТекстОповещения = НСтр("ru='Доступно обновление программы.';uk='Доступно оновлення програми.'");
			Если РазмерОбновления <> 0 Тогда
				ТекстОповещения = ТекстОповещения + Символы.ПС
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Размер дистрибутива: %1.';uk='Розмір дистрибутива: %1.'"),
						ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеРазмераФайла(РазмерОбновления));
			КонецЕсли;
			
			Если Не ОбновлениеКомКонф.ДоступноОбновление
				И ОбновлениеКомПл.ДоступноОбновление
				И ОбновлениеКомПл.ОбязательностьУстановки < 2 Тогда
				ТекстОповещения = ТекстОповещения + Символы.ПС
					+ НСтр("ru='Рекомендуется установить это обновление.';uk='Рекомендується встановити це оновлення.'");
				Картинка         = БиблиотекаКартинок.Предупреждение32;
				СтатусОповещения = СтатусОповещенияПользователя.Важное;
			Иначе
				Картинка         = БиблиотекаКартинок.Информация32;
				СтатусОповещения = СтатусОповещенияПользователя.Информация;
			КонецЕсли;
			
			ПоказатьОповещениеПользователя(
				НСтр("ru='Обновление программы';uk='Оновлення програми'"),
				Новый ОписаниеОповещения(
					"ПриНажатииОповещенияИнформацииОДоступномОбновлении",
					ЭтотОбъект,
					ИнформацияОДоступномОбновлении),
				ТекстОповещения,
				Картинка,
				СтатусОповещения,
				"ПолучениеОбновленийПрограммы");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьПроверкуПоРасписанию()
	
	ПодключитьОбработчикОжидания("ПолучениеОбновленийПрограммы_ПроверитьНаличиеОбновлений", 300, Истина);
	
КонецПроцедуры

Процедура ПодключитьОбработкуРезультатаПроверки()
	
	ПодключитьОбработчикОжидания("ПолучениеОбновленийПрограммы_ПроверитьНаличиеОбновлений", 10, Истина);
	
КонецПроцедуры

Процедура ОтключитьПроверкуПоРасписанию()
	
	ОтключитьОбработчикОжидания("ПолучениеОбновленийПрограммы_ПроверитьНаличиеОбновлений");
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиПрограммы

Процедура ПриИзмененииРасписания(Расписание, Форма) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПериодПовтораВТечениеДня = Расписание.ПериодПовтораВТечениеДня;
	Если Форма.БИПАвтоматическаяПроверкаОбновлений = 2
		И ПериодПовтораВТечениеДня > 0
		И ПериодПовтораВТечениеДня < 300 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru='Интервал проверки не может быть задан чаще, чем один раз 5 минут.';uk='Інтервал перевірки не може бути заданий частіше, ніж один раз 5 хвилин.'"));
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	Элементы.ДекорацияРасписаниеПроверкиОбновлений.Заголовок =
		ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеРасписания(Расписание);
	
	НастройкиОбновления = ГлобальныеНастройкиОбновления();
	НастройкиОбновления.Расписание = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
	ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьНастройкиОбновления(НастройкиОбновления);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
