﻿////////////////////////////////////////////////////////////////////////////////
// Взаиморасчёты с сотрудниками
// Серверные процедуры и функции форм документов
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Процедуры форм ведомостей на выплату заработной платы

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМ

// Обработчик события ПриСозданииНаСервере
// 	Устанавливает первоначальные значения реквизитов объекта
//	Инициализирует реквизиты формы
//
// Параметры:
// 	Форма - УправляемаяФорма - форма, которая создаётся.
// 	Отказ - Булево - признак отказа от создания формы.
// 	СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
// 	ЗначенияДляЗаполнения - структура с дополнительными заполняемыми реквизитами
//		Имя элемента структуры идентифицирует значение, которое необходимо заполнить
//		Значение элемента структуры - путь к реквизиту формы, значение которого необходимо заполнить
//		Необязательный параметр.
//		По умолчанию заполняются:
//			ПериодРегистрации
//			Организация
//			Подразделение
//			Ответственный
//			ГлавныйБухгалтер
//			Руководитель
//			ДолжностьРуководителя
//
Процедура ВедомостьПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, ЗначенияДляЗаполнения = Неопределено) Экспорт
	ВзаиморасчетыССотрудникамиФормыВнутренний.ВедомостьПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, ЗначенияДляЗаполнения)
КонецПроцедуры

// Обработчик события ПриЧтенииНаСервере
//
// Параметры:
// 	Форма - УправляемаяФорма - форма, которая создаётся.
// 	ТекущийОбъект - читаемый объект
//
Процедура ВедомостьПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	Форма.РассчитыватьНалоги = ТекущийОбъект.СпособВыплаты.РасчитыватьВзносы;
	Форма.УстановитьДоступностьЭлементов();
	
КонецПроцедуры

// Обработчик события ОбработкаПроверкиЗаполненияНаСервере
// 	Инициирует проверку заполнения объекта
//	
Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	ТекущийОбъект = Форма.РеквизитФормыВЗначение("Объект");
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Форма.ОбработатьСообщенияПользователю();
		Отказ = Истина
	КонецЕсли;	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");
КонецПроцедуры

// Серверная часть обработчика события изменения организации.
//
// Параметры:
// 	Форма - УправляемаяФорма.
//
Процедура ВедомостьОрганизацияПриИзмененииНаСервере(Форма) Экспорт   
	
		ЗначенияДляЗаполнения = ВедомостьЗначенияДляЗаполненияОтветственныхЛиц(Форма);
		Для Каждого ЗначениеДляЗаполнения Из ЗначенияДляЗаполнения Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ЗначениеДляЗаполнения.Значение, Неопределено);
		КонецЦикла;
		ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(Форма, ЗначенияДляЗаполнения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"))
	
КонецПроцедуры

// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМ

Функция ВедомостьЗначенияДляЗаполненияОтветственныхЛиц(Форма) Экспорт  
	
	МенеджерВедомости = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Форма.Объект.Ссылка);
	РеквизитыОтветственныхЛиц = МенеджерВедомости.РеквизитыОтветственныхЛиц();
	
	ЗначенияДляЗаполнения = Новый Структура;
	Для Каждого Реквизит Из РеквизитыОтветственныхЛиц Цикл
		ПутьРеквизита = "Объект."+Реквизит;
		ЗначенияДляЗаполнения.Вставить(Реквизит, ПутьРеквизита);
	КонецЦикла;
	
	Возврат ЗначенияДляЗаполнения
	
КонецФункции	

// Серверная часть обработчика команды заполнения
// 	Вызывает процедуру заполнения модуля объекта
//
// Параметры:
// 	Форма - УправляемаяФорма.
//
Процедура ВедомостьЗаполнитьНаСервере(Форма) Экспорт
	
	ТекущийОбъект = Форма.РеквизитФормыВЗначение("Объект");
	
	Если ТекущийОбъект.МожноЗаполнитьАвтоматически() Тогда
		ТекущийОбъект.ЗаполнитьАвтоматически();
	КонецЕсли;	
	
	Форма.ОбработатьСообщенияПользователю();
	
	Форма.ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект")
	
КонецПроцедуры

// Серверная часть обработчика команды расчёта сумм к выплате
// 	Вызывает процедуру заполнения модуля объекта
//
// Параметры:
// 	Форма - УправляемаяФорма - форма, которая создаётся.
//
Процедура ВедомостьРассчитатьНаСервере(Форма) Экспорт
	
	ТекущийОбъект = Форма.РеквизитФормыВЗначение("Объект");
	
	Если ТекущийОбъект.МожноЗаполнитьАвтоматически() Тогда
		ТекущийОбъект.Рассчитать();
	КонецЕсли;	
	
	Форма.ОбработатьСообщенияПользователю();
	
	Форма.ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект")
	
КонецПроцедуры


// Серверная часть обработчика команды расчёта сумм к выплате
// 	Вызывает процедуру заполнения модуля объекта
//
// Параметры:
// 	Форма - УправляемаяФорма - форма, которая создаётся.
//
Процедура ВедомостьРассчитатьНалогиНаСервере(Форма) Экспорт
	
	ТекущийОбъект = Форма.РеквизитФормыВЗначение("Объект");
	
	Если ТекущийОбъект.МожноРассчитатьНалоги() Тогда
		ТекущийОбъект.РассчитатьНалоги();
	КонецЕсли;	
	
	Форма.ОбработатьСообщенияПользователю();
	
	Форма.ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект")
	
КонецПроцедуры

// Обработка сообщений пользователю для форм ведомостей
// 	Привязывает сообщения объекта к полям формы
//
// Параметры:
// 	Форма - УправляемаяФорма.
//
Процедура ВедомостьОбработатьСообщенияПользователю(Форма) Экспорт
	ВзаиморасчетыССотрудникамиФормыВнутренний.ВедомостьОбработатьСообщенияПользователю(Форма)	
КонецПроцедуры

// Устанавливает доступность элементов формы ведомости
// 	Документ ввода начальных остатков, или по ведомость, по которой есть выплаты
//	доступны только для просмотра.
//
// Параметры:
// 	Форма - УправляемаяФорма - форма, которая создаётся.
//
Процедура ВедомостьУстановитьДоступностьЭлементов(Форма) Экспорт
	ВзаиморасчетыССотрудникамиФормыВнутренний.ВедомостьУстановитьДоступностьЭлементов(Форма);
КонецПроцедуры
