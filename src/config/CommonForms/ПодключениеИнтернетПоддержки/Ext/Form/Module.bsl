﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru='Использование Интернет-поддержки недоступно при работе в модели сервиса.';uk='Використання Інтернет-підтримки недоступне при роботі в моделі сервісу.'");
	КонецЕсли;
	
	РежимВводаНастроекКлиентаЛицензирования = Параметры.РежимВводаНастроекКлиентаЛицензирования;
	Если РежимВводаНастроекКлиентаЛицензирования Тогда
		НастройкиСоединенияССерверами =
			ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	Если ДанныеАутентификации <> Неопределено Тогда
		Логин = ДанныеАутентификации.Логин;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИПП_АктивизироватьФормуПодключенияИПП" Тогда
		Если Параметр.Активизирована <> Истина Тогда
			Если ВладелецФормы = Неопределено
				Или РежимОткрытияОкна <> РежимОткрытияОкнаФормы.БлокироватьОкноВладельца Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьЭтуФорму", 0.1, Истина);
			ИначеЕсли ЭтотОбъект.ВладелецФормы <> Неопределено Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьВладельца", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		
		ИнтернетПоддержкаПользователейКлиент.ОткрытьГлавнуюСтраницуПортала();
		
	Иначе
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru='Интернет-поддержка. Подключение Интернет-поддержки';uk='Інтернет-підтримка. Підключення Інтернет-підтримки'"),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не получается подключить Интернет-поддержку пользователей.
                    |Для подключения указывается логин %1.'
                    |;uk='Не виходить підключити Інтернет-підтримку користувачів.
                    |Для підключення вказується логін %1.'"),
				Элементы.Логин.ТекстРедактирования),
			,
			,
			Новый Структура("Логин, НастройкиСоединенияССерверами",
				Элементы.Логин.ТекстРедактирования,
				НастройкиСоединенияССерверами));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВосстановленияПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуВосстановленияПароля();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНетЛогинаИПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуРегистрацииНовогоПользователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтернетПоддержкаПользователейКлиент.ОткрытьГлавнуюСтраницуПортала();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Не ЗаполнениеЛогинаИПароляКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиСоединенияССерверами = Неопределено Тогда
		НастройкиСоединенияССерверами = ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами();
	КонецЕсли;
	
	Состояние(, , НСтр("ru='Подключение Интернет-поддержки...';uk='Підключення Інтернет-підтримки...'"));
	РезультатАутентификации =
		АутентифицироватьПользователя(
			Логин,
			Пароль,
			Истина);
	Состояние();
	
	Если ПустаяСтрока(РезультатАутентификации.КодОшибки) Тогда
		ПараметрыОповещения = Новый Структура("Логин, Пароль", Логин, "");
		Закрыть(ПараметрыОповещения);
		Оповестить("ИнтернетПоддержкаПодключена", ПараметрыОповещения);
	ИначеЕсли РезультатАутентификации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ПоказатьПредупреждение(, РезультатАутентификации.СообщениеОбОшибке);
	Иначе
		
		// Сетевая или иная ошибка.
		// В этом случае:
		//	- пользователю отображается сообщение об ошибке проверки логина и пароля;
		//	- логин и пароль сохраняются в программе - см. метод АутентифицироватьПользователя().
		
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Логин и пароль сохранены в программе, но проверка корректности
                |логина и пароля не выполнена из-за ошибки:
                |%1'
                |;uk='Логін і пароль збережені в програмі, але перевірка коректності
                |логіна і пароля не виконана через помилки:
                |%1'"),
			РезультатАутентификации.СообщениеОбОшибке);
		
		ПоказатьПредупреждение(
			Новый ОписаниеОповещения("ПриСообщенииОбОшибкеПроверкиКорректностиЛогинаИПароля", ЭтотОбъект),
			ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Общего назначения.

&НаКлиенте
Функция ЗаполнениеЛогинаИПароляКорректно()
	
	Если ПустаяСтрока(Логин) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Логин"" не заполнено.';uk='Поле ""Логін"" не заповнено.'"),
			,
			"Логин");
		Возврат Ложь;
		
	ИначеЕсли ПустаяСтрока(Пароль) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Пароль"" не заполнено.';uk='Поле ""Пароль"" не заповнено.'"),
			,
			"Пароль");
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Знач ДанныеАутентификации)
	
	// Проверка права записи данных
	Если Не ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП() Тогда
		ВызватьИсключение НСтр("ru='Недостаточно прав для записи данных аутентификации Интернет-поддержки.';uk='Недостатньо прав для запису даних аутентифікації Інтернет-підтримки.'");
	КонецЕсли;
	
	// Запись данных
	УстановитьПривилегированныйРежим(Истина);
	ИнтернетПоддержкаПользователей.СохранитьДанныеАутентификации(ДанныеАутентификации);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АутентифицироватьПользователя(Знач Логин, Знач Пароль, Знач ЗапомнитьПароль)
	
	РезультатАутентификации =
		ИнтернетПоддержкаПользователей.ПроверитьЛогинИПароль(
			Логин,
			Пароль);
	
	Если РезультатАутентификации.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
		СохранитьДанныеАутентификации(
			?(ЗапомнитьПароль, Новый Структура("Логин, Пароль", Логин, Пароль), Неопределено));
	КонецЕсли;
	
	Возврат РезультатАутентификации;
	
КонецФункции

&НаКлиенте
Процедура ПриСообщенииОбОшибкеПроверкиКорректностиЛогинаИПароля(ДополнительныеПараметры) Экспорт
	
	ПараметрыОповещения = Новый Структура("Логин, Пароль", Логин, "");
	Закрыть(ПараметрыОповещения);
	Оповестить("ИнтернетПоддержкаПодключена", ПараметрыОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьЭтуФорму()
	
	ЭтотОбъект.Активизировать();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьВладельца()
	
	ЭтотОбъект.ВладелецФормы.Активизировать();
	
КонецПроцедуры

#КонецОбласти
