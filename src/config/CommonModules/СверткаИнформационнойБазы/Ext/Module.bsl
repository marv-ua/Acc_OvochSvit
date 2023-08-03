﻿Процедура ЗаписатьСтатусСозданияРезервнойКопии(СтруктураПараметров) Экспорт

	ЗначениеХранилища = Константы.СтатусСверткиИнформационнойБазы.Получить();
	
	Статус = ЗначениеХранилища.Получить();
	
	ЗаполнитьЗначенияСвойств(Статус, СтруктураПараметров);

	Константы.СтатусСверткиИнформационнойБазы.Установить(Новый ХранилищеЗначения(Статус));

КонецПроцедуры

Процедура ЗавершитьСозданиеРезервнойКопии(Знач РезервнаяКопияСоздана, Знач ИмяАдминистратора, Знач АвтоматическийРежимСвертки, ТекущийЭтапСвертки) Экспорт

	ТекстСообщения = НСтр("ru='Завершение создания резервной копии информационной базы из внешнего скрипта.';uk='Завершення створення резервної копії інформаційної бази з зовнішнього скрипта.'");
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТекущийЭтапСвертки", ТекущийЭтапСвертки);
	СтруктураПараметров.Вставить("РезервнаяКопияСоздана", РезервнаяКопияСоздана);
	СтруктураПараметров.Вставить("ПоказыватьПриСтарте", Истина);
	ЗаписатьСтатусСозданияРезервнойКопии(СтруктураПараметров);
	
КонецПроцедуры

// Выполняет очистку всех настроек обновления конфигурации.
Процедура СброситьСтатусСверткиИнформационнойБазы() Экспорт
	
	ЗначениеХранилища = Константы.СтатусСверткиИнформационнойБазы.Получить();
	
	Статус = ЗначениеХранилища.Получить();
	
	Статус.ТекущийЭтапСвертки = 0;

	Константы.СтатусСверткиИнформационнойБазы.Установить(Новый ХранилищеЗначения(Статус));
	
КонецПроцедуры

Процедура ОбновитьДеревоПоМетаданным(Объект)
	
	Объект.СпособыСверткиОбъектовМетаданных.Очистить();
	
	МассивТиповОбъектовМД = Новый Структура();
	МассивТиповОбъектовМД.Вставить("РегистрБухгалтерии", Метаданные.РегистрыБухгалтерии);
	МассивТиповОбъектовМД.Вставить("РегистрНакопления", Метаданные.РегистрыНакопления);
	МассивТиповОбъектовМД.Вставить("РегистрСведений", Метаданные.РегистрыСведений);
	
	Для Каждого ТипОбъектаМД Из МассивТиповОбъектовМД Цикл
		
		Для Каждого ОбъектМД из ТипОбъектаМД.Значение Цикл
			НоваяСтрокаОбъектМД = Объект.СпособыСверткиОбъектовМетаданных.Добавить();
			НоваяСтрокаОбъектМД.ТипОбъектаМД = ТипОбъектаМД.Ключ;
			НоваяСтрокаОбъектМД.ОбъектМД = ОбъектМД.Имя;
			НоваяСтрокаОбъектМД.ОбъектМДСиноним = ОбъектМД.Синоним;
			НоваяСтрокаОбъектМД.СпособСвертки = ПолучитьСпособСверткиПоУмолчанию(ТипОбъектаМД, ОбъектМД);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьРекомендуемымиПарараметрамиСверткиРегистров(Объект) Экспорт
	
	
	МакетРекомендуемыеПараметрыСверткиРегистров = Обработки.СверткаИнформационнойБазы.ПолучитьМакет("UK_РекомендуемыеНастройкиРегистров");
	МакетРекомендуемыеПараметрыСверткиРегистров.КодЯзыка = "ru";
	
	Объект.СпособыСверткиОбъектовМетаданных.Очистить();
	
	МДРегистовСведений = Метаданные.РегистрыСведений;
	МДРегистровНакопления = Метаданные.РегистрыНакопления;
	ТДРегистровБухгалтерии = Метаданные.РегистрыБухгалтерии;
	
	Для НомерСтроки = 1 По МакетРекомендуемыеПараметрыСверткиРегистров.ВысотаТаблицы Цикл
		
		
		НовСтрока = Объект.СпособыСверткиОбъектовМетаданных.Добавить();
		НовСтрока.ТипОбъектаМД = СокрЛП(МакетРекомендуемыеПараметрыСверткиРегистров.Область(НомерСтроки, 1).Текст);
		НовСтрока.ОбъектМД = СокрЛП(МакетРекомендуемыеПараметрыСверткиРегистров.Область(НомерСтроки, 2).Текст);
		
		Попытка
			Если НовСтрока.ТипОбъектаМД = "РегистрСведений" Тогда
				НовСтрока.ОбъектМДСиноним = МДРегистовСведений[НовСтрока.ОбъектМД].Синоним;
			ИначеЕсли НовСтрока.ТипОбъектаМД = "РегистрНакопления" Тогда
				НовСтрока.ОбъектМДСиноним = МДРегистровНакопления[НовСтрока.ОбъектМД].Синоним;
			ИначеЕсли НовСтрока.ТипОбъектаМД = "РегистрБухгалтерии" Тогда
				НовСтрока.ОбъектМДСиноним = ТДРегистровБухгалтерии[НовСтрока.ОбъектМД].Синоним;
			КонецЕсли;;
		Исключение
			ТекстОшибки = "Не найден "+НовСтрока.ТипОбъектаМД+"."+НовСтрока.ОбъектМД+"
			|Его нужно убрать из макета ОбработкаОбъект.СверткаИнформационнойБазы.Макеты.UK_РекомендуемыеНастройкиРегистров";			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
			Объект.СпособыСверткиОбъектовМетаданных.Удалить(НовСтрока);
			Продолжить;
		КонецПопытки; 
		НовСтрока.СпособСвертки = СокрЛП(МакетРекомендуемыеПараметрыСверткиРегистров.Область(НомерСтроки, 3).Текст);
	КонецЦикла;
	
//++ БУ ЗИК	
//~	СписокПосдсистем = Новый СписокЗначений;
//~	Для Каждого Подсистема Из Метаданные["Подсистемы"] Цикл
//~		Если СтрНайти(Подсистема.Имя, "ЗарплатаКадры") = 0 Тогда
//~			Продолжить;
//~		КонецЕсли;	
//~		СписокПосдсистем.Добавить(Подсистема);
//~		
//~		Для Каждого Подсистема1 Из Подсистема.Подсистемы Цикл
//~			СписокПосдсистем.Добавить(Подсистема1);
//~			Для Каждого Подсистема2 Из Подсистема1.Подсистемы Цикл
//~				СписокПосдсистем.Добавить(Подсистема2);
//~			КонецЦикла;	
//~		КонецЦикла;	
//~				
//~	КонецЦикла;
//~	
//~	Для Каждого Подсистема из СписокПосдсистем Цикл
//~		Для каждого ОбъектМД Из Подсистема.Значение.Состав Цикл
//~			Если МДРегистровНакопления.Содержит(ОбъектМД) Тогда
//~				СтрокиМД = Объект.СпособыСверткиОбъектовМетаданных.НайтиСтроки(Новый Структура("ОбъектМД", ОбъектМД.Имя));
//~				Если СтрокиМД.Количество() = 0 Тогда
//~					СтрокаМД = Объект.СпособыСверткиОбъектовМетаданных.Добавить();
//~				Иначе
//~					СтрокаМД = СтрокиМД[0];
//~				КонецЕсли;	
//~				СтрокаМД.ТипОбъектаМД = "РегистрНакопления";
//~				СтрокаМД.ОбъектМД = ОбъектМД.Имя;
//~             СтрокаМД.ОбъектМДСиноним = ОбъектМД.Синоним;
//~				СтрокаМД.СпособСвертки = "Не сворачивать";
//~			ИначеЕсли МДРегистовСведений.Содержит(ОбъектМД) Тогда
//~				СтрокиМД = Объект.СпособыСверткиОбъектовМетаданных.НайтиСтроки(Новый Структура("ОбъектМД", ОбъектМД.Имя));
//~				Если СтрокиМД.Количество() = 0 Тогда
//~					СтрокаМД = Объект.СпособыСверткиОбъектовМетаданных.Добавить();
//~				Иначе
//~					СтрокаМД = СтрокиМД[0];
//~				КонецЕсли;
//~				СтрокаМД.ТипОбъектаМД = "РегистрСведений";
//~				СтрокаМД.ОбъектМД = ОбъектМД.Имя;
//~             СтрокаМД.ОбъектМДСиноним = ОбъектМД.Синоним;
//~				СтрокаМД.СпособСвертки = "Не сворачивать";	
//~			КонецЕсли;
//~
//~		КонецЦикла;
//~			
//~	КонецЦикла;
//~	Объект.СпособыСверткиОбъектовМетаданных.Сортировать("ТипОбъектаМД, ОбъектМД");
//-- БУ ЗИК	
	
КонецПроцедуры

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru='Свертка информационной базы';uk='Згортка інформаційної бази'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Функция возвращает способ свертки для типа объекта метаданных по умолчанию
//
// Параметры
//  ТипОбъектаМД - элемент соответствия, полученного функцией ПолчитьМассивТиповОбъектовМД() 
//  ОбъектМД - метаданные, для которых нужно получить способ свертки
//
// Возвращаемое значение:
//  Строка - способ свертки для данного объекта
Функция ПолучитьСпособСверткиПоУмолчанию(ТипОбъектаМД, ОбъектМД)
	
	Если ТипОбъектаМД.Ключ = "РегистрСведений" Тогда
		Если ОбъектМД.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			СпособСвертки = "Не сворачивать";
			
		ИначеЕсли (ОбъектМД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору)
			И (НЕ Метаданные.Документы.ОперацияБух.Движения.Содержит(ОбъектМД)) Тогда
			СпособСвертки = "Не сворачивать";
			
		Иначе
			СпособСвертки = "Свернуть";
			
		КонецЕсли;	
		
	ИначеЕсли ТипОбъектаМД.Ключ = "РегистрНакопления" Тогда
		СпособСвертки = "Свернуть";
		
	ИначеЕсли ТипОбъектаМД.Ключ = "РегистрБухгалтерии" Тогда
		СпособСвертки = "Свернуть";		
		
	КонецЕсли;	
	
	Возврат СпособСвертки;
	
КонецФункции	

Функция ПолучитьСтруктуруСтатусаСверткиИнформационнойБазы(Объект) Экспорт
	
	ЗаполнитьРекомендуемымиНастройкамиБП20 = Ложь;
	
	// Определение редакции конфигурации
	ПодстрокиВерсии = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Метаданные.Версия, ".");
	Если ПодстрокиВерсии.Количество() > 1 Тогда
		Если ПодстрокиВерсии[0] = "2" и ПодстрокиВерсии[1] = "1" Тогда
			ЗаполнитьРекомендуемымиНастройкамиБП20 = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Для Бухгалтерии предприятия, редакция 2.0 способы обработки регистров заполняются рекомендуемыми параметрами.
	// В остальных случаях в зависимости от свойств регистров.
 	Если ЗаполнитьРекомендуемымиНастройкамиБП20 Тогда
		ЗаполнитьРекомендуемымиПарараметрамиСверткиРегистров(Объект)
	Иначе
		ОбновитьДеревоПоМетаданным(Объект)
	КонецЕсли;
	
	ИмяКаталогаВременныхФайлов = КаталогВременныхФайлов();
	ИмяКаталогаРезервнойКопииИБ = ?(Прав(ИмяКаталогаВременныхФайлов, 1) = "\", ИмяКаталогаВременныхФайлов, ИмяКаталогаВременныхФайлов + "\");
	
	Статус = Новый Структура;
	Статус.Вставить("СпособыСверткиОбъектовМетаданных", 	Объект.СпособыСверткиОбъектовМетаданных.Выгрузить());
	Статус.Вставить("ПериодСвертки", 						НачалоГода(ТекущаяДата()));
	Статус.Вставить("ИмяАдминистратораИБ");
	Статус.Вставить("ПарольАдминистратораИБ");
	Статус.Вставить("ИмяКаталогаРезервнойКопииИБ",			ИмяКаталогаРезервнойКопииИБ);
	Статус.Вставить("ТолькоВыбранныеОрганизации",			Ложь);
	Статус.Вставить("Организации");
	Статус.Вставить("ТекущийЭтапСвертки", 					0);
	Статус.Вставить("ПоказыватьПриСтарте", 					Ложь);
	Статус.Вставить("СоздатьРезервнуюКопию", 				Истина);
	Статус.Вставить("РезервнаяКопияСоздана", 				Ложь);
	Статус.Вставить("АктивизацияДвижений", 					Истина);
	Статус.Вставить("РекомендуемыеПараметры", 				Истина);
	Статус.Вставить("УстановитьДатуЗапретаИзмененияДанных",	Истина);

	Константы.СтатусСверткиИнформационнойБазы.Установить(Новый ХранилищеЗначения(Статус));
	
КонецФункции



