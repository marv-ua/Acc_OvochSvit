﻿////////////////////////////////////////////////////////////////////////////////
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
	
	// первоначальное заполнение объекта
	Если Форма.Параметры.Ключ.Пустая() Тогда
		
		Если ЗначенияДляЗаполнения = Неопределено Тогда
			ЗначенияДляЗаполнения = Новый Структура;
		КонецЕсли;
		
		ЗначенияДляЗаполнения.Вставить("ПредыдущийМесяц",	"Объект.ПериодРегистрации");
		ЗначенияДляЗаполнения.Вставить("Организация",		"Объект.Организация");
		ЗначенияДляЗаполнения.Вставить("Ответственный",		"Объект.Ответственный");
		ЗначенияДляЗаполнения.Вставить("Подразделение",		"Объект.Подразделение");
		
		ЗначенияДляЗаполнения.Вставить("ГлавныйБухгалтер",		"Объект.ГлавныйБухгалтер");
		ЗначенияДляЗаполнения.Вставить("Руководитель",			"Объект.Руководитель");
		ЗначенияДляЗаполнения.Вставить("ДолжностьРуководителя",	"Объект.ДолжностьРуководителя");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(Форма, ЗначенияДляЗаполнения);
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.СпособВыплаты", ПредопределенноеЗначение("Справочник.ВидыВыплат.Очередная"), Истина);
        ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.Округление", УчетЗарплаты.СпособОкругления(Форма.Объект.Организация), Истина);
		
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");

		Форма.УстановитьДоступностьЭлементов();
		
	КонецЕсли;
	
	// Запоминаем способы округления
	ВыборкаСпособовОкругления = Справочники.СпособыОкругленияПриВыплатеЗарплаты.Выбрать(,,, "Точность");
	Пока ВыборкаСпособовОкругления.Следующий() Цикл
		Форма.СпособыОкругления.Добавить(ВыборкаСпособовОкругления.Ссылка, ВыборкаСпособовОкругления.Наименование);
	КонецЦикла;	
	
	
КонецПроцедуры

// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМ

// Обработка сообщений пользователю для форм ведомостей
// 	Привязывает сообщения объекта к полям формы
//
// Параметры:
// 	Форма - УправляемаяФорма.
//
Процедура ВедомостьОбработатьСообщенияПользователю(Форма) Экспорт
	
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	
	Для Каждого Сообщение Из Сообщения Цикл
		Если Найти(Сообщение.Поле, "ПериодРегистрации") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПериодРегистрацииСтрокой";
		КонецЕсли;
		Если Найти(Сообщение.Поле, "Округление") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПараметрыРасчетаИнфо";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает доступность элементов формы ведомости
// 	Документ ввода начальных остатков, или по ведомость, по которой есть выплаты
//	доступны только для просмотра.
//
// Параметры:
// 	Форма - УправляемаяФорма - форма, которая создаётся.
//
Процедура ВедомостьУстановитьДоступностьЭлементов(Форма) Экспорт
	
	Форма.ТолькоПросмотр = 
		ДатыЗапретаИзменения.ИзменениеЗапрещено(Форма.Объект.Ссылка.Метаданные().ПолноеИмя(), Форма.Объект.Ссылка, Ложь) 
		ИЛИ ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(Форма.Объект.Ссылка)
		ИЛИ ВзаиморасчетыССотрудниками.ЕстьПеречислениеНалоговПоВедомости(Форма.Объект.Ссылка);
	
КонецПроцедуры
