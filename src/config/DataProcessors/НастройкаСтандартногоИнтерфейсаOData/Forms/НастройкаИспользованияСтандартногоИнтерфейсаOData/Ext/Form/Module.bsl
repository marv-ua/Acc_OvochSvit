﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда
		ВызватьИсключение НСтр("ru='Недостаточно прав для настройки автоматического REST-сервиса';uk='Недостатньо прав для настройки автоматичного REST-сервісу'");
	КонецЕсли;
	
	НастройкиАвторизации = Обработки.НастройкаСтандартногоИнтерфейсаOData.НастройкиАвторизацииДляСтандартногоИнтерфейсаOData();
	
	СоздатьПользователяСтандартногоИнтерфейсаOData = НастройкиАвторизации.Используется;
	
	Если ЗначениеЗаполнено(НастройкиАвторизации.Логин) Тогда
		
		ИмяПользователя = НастройкиАвторизации.Логин;
		
		Если СоздатьПользователяСтандартногоИнтерфейсаOData Тогда
			
			ПроверкаИзмененияПароля = Строка(Новый УникальныйИдентификатор());
			Пароль = ПроверкаИзмененияПароля;
			ПодтверждениеПароля = ПроверкаИзмененияПароля;
			
		КонецЕсли;
		
	Иначе
		
		ИмяПользователя = "odata.user";
		
	КонецЕсли;
		
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если СоздатьПользователяСтандартногоИнтерфейсаOData Тогда
		
		Если Не ЗначениеЗаполнено(ИмяПользователя) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указано имя пользователя';uk='Не вказано ім''я користувача'"), , "ИмяПользователя");
			Отказ = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Пароль) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан пароль';uk='Не вказаний пароль'"), , "Пароль");
			Отказ = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПодтверждениеПароля) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указано подтверждение пароля';uk='Не вказано підтвердження пароля'"), , "ПодтверждениеПароля");
			Отказ = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Пароль) И ЗначениеЗаполнено(ПодтверждениеПароля) И Пароль <> ПодтверждениеПароля Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Подтверждение пароля не совпадает с паролем';uk='Підтвердження паролю не збігається з паролем'"), , "ПодтверждениеПароля");
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("ОбъектыМетаданных");
	ОтборСтрок = Новый Структура();
	ОтборСтрок.Вставить("Использование", Истина);
	Строки = Дерево.Строки.НайтиСтроки(ОтборСтрок, Истина);
	Если Строки.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не выбрано ни одного объекта, к которому разрешен доступ через автоматический REST-сервис';uk='Не обрано жодного об''єкта, до якого дозволений доступ через автоматичний REST-сервіс'"), , "ОбъектыМетаданных");
		Отказ = Истина;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектыМетаданныхИспользованиеПриИзменении(Элемент)
	
	Если Элементы.ОбъектыМетаданных.ТекущиеДанные.Использование Тогда
		
		Добавление = Истина;
		Зависимости = ЗависимостиДляДобавленияОбъекта(Элементы.ОбъектыМетаданных.ТекущиеДанные.ПолучитьИдентификатор());
		
	Иначе
		
		Добавление = Ложь;
		Зависимости = ЗависимостиДляУдаленияОбъекта(Элементы.ОбъектыМетаданных.ТекущиеДанные.ПолучитьИдентификатор());
		
	КонецЕсли;
	
	Если Зависимости.Количество() > 0 Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ПолноеИмяОбъекта", Элементы.ОбъектыМетаданных.ТекущиеДанные.ПолноеИмя);
		ПараметрыФормы.Вставить("ЗависимостиОбъекта", Зависимости);
		ПараметрыФормы.Вставить("Добавление", Добавление);
		
		Контекст = Новый Структура();
		Контекст.Вставить("Зависимости", Зависимости);
		Контекст.Вставить("Добавление", Добавление);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбъектыМетаданныхИспользованиеПриИзмененииПродолжение", ЭтотОбъект, Контекст);
		
		ОткрытьФорму(
			"Обработка.НастройкаСтандартногоИнтерфейсаOData.Форма.ЗависимостиОбъектаМетаданных",
			ПараметрыФормы,
			,
			,
			,
			,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПользователяСтандартногоИнтерфейсаODataПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Функция Сохранить(Команда = Неопределено)
	
	Если Модифицированность Тогда
		
		Если ПроверитьЗаполнение() И ОбъектыМетаданных.ПолучитьЭлементы().Количество() > 0 Тогда
			
			СохранитьНаСервере();
			Возврат Истина;
			
		Иначе
			
			Возврат Ложь;
			
		КонецЕсли;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда = Неопределено)
	
	Если Сохранить() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМетаданные(Команда)
	
	Если Модифицированность И ОбъектыМетаданных.ПолучитьЭлементы().Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьМетаданныеПродолжение", ЭтаФорма);
		ПоказатьВопрос(Оповещение, НСтр("ru='Загрузить метаданные заново? Внесенные изменения будут потеряны.';uk='Метадані завантажити заново? Внесені зміни будуть втрачені.'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗагрузитьМетаданныеПродолжение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМетаданныеПродолжение(РезультатВопроса, ДопПараметр) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ЗапуститьПодготовкуПараметровНастройки();
	
	Если ТипЗнч(Результат) = Тип("Структура") 
		И НЕ Результат.ЗаданиеВыполнено Тогда
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьИДоступность()
	
	Элементы.ИмяПользователяИПароль.Доступность = СоздатьПользователяСтандартногоИнтерфейсаOData;
	
КонецПроцедуры

&НаСервере
Функция ЗависимостиДляДобавленияОбъекта(Знач ИдентификаторСтроки)
	
	ТаблицаЗависимостей = РеквизитФормыВЗначение("ЗависимостиДляДобавления");
	Возврат ЗависимостиДляОбъекта(ИдентификаторСтроки, ТаблицаЗависимостей, Истина);
	
КонецФункции

&НаСервере
Функция ЗависимостиДляУдаленияОбъекта(Знач ИдентификаторСтроки)
	
	ТаблицаЗависимостей = РеквизитФормыВЗначение("ЗависимостиДляУдаления");
	Возврат ЗависимостиДляОбъекта(ИдентификаторСтроки, ТаблицаЗависимостей, Ложь);
	
КонецФункции

&НаСервере
Функция ЗависимостиДляОбъекта(Знач ИдентификаторСтроки, ТаблицаЗависимостей, ИспользованиеЭталон)
	
	Результат = Новый Массив();
	
	ИмяТекущегоОбъекта = ОбъектыМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки).ПолноеИмя;
	
	ДеревоОбъектов = РеквизитФормыВЗначение("ОбъектыМетаданных");
	
	ЗаполнитьТребуемыеЗависимостиОбъектаПоСтроке(Результат, ДеревоОбъектов, ТаблицаЗависимостей, ИмяТекущегоОбъекта, ИспользованиеЭталон);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТребуемыеЗависимостиОбъектаПоСтроке(Результат, ДеревоОбъектов, ТаблицаЗависимостей, ИмяТекущегоОбъекта, ИспользованиеЭталон)
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("ИмяОбъекта", ИмяТекущегоОбъекта);
	
	СтрокиЗависимостей = ТаблицаЗависимостей.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаЗависимости Из СтрокиЗависимостей Цикл
		
		ЗависимыйОбъектВДереве = ДеревоОбъектов.Строки.Найти(СтрокаЗависимости.ИмяЗависимогоОбъекта, "ПолноеИмя", Истина);
		
		Если ЗависимыйОбъектВДереве.Использование <> ИспользованиеЭталон И Результат.Найти(СтрокаЗависимости.ИмяЗависимогоОбъекта) = Неопределено Тогда
			
			Результат.Добавить(СтрокаЗависимости.ИмяЗависимогоОбъекта);
			ЗаполнитьТребуемыеЗависимостиОбъектаПоСтроке(Результат, ДеревоОбъектов, ТаблицаЗависимостей, 
				СтрокаЗависимости.ИмяЗависимогоОбъекта, ИспользованиеЭталон);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИспользованиеЗависимостей(Знач Зависимости, Знач Использование)
	
	КорневыеЭлементы = ОбъектыМетаданных.ПолучитьЭлементы();
	
	Для Каждого КорневойЭлемент Из КорневыеЭлементы Цикл
		
		ЭлементыДерева = КорневойЭлемент.ПолучитьЭлементы();
		
		Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
			
			Если Зависимости.Найти(ЭлементДерева.ПолноеИмя) <> Неопределено Тогда
				
				ЭлементДерева.Использование = Использование;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыМетаданныхИспользованиеПриИзмененииПродолжение(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		УстановитьИспользованиеЗависимостей(Контекст.Зависимости, Контекст.Добавление);
		
	Иначе
		
		Элементы.ОбъектыМетаданных.ТекущиеДанные.Использование = Не Элементы.ОбъектыМетаданных.ТекущиеДанные.Использование;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьЗакрытиеПослеВопроса", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	НачатьТранзакцию();
	
	Попытка
		
		Настройки = Новый Структура();
		
		Настройки.Вставить("Используется", СоздатьПользователяСтандартногоИнтерфейсаOData);
		Настройки.Вставить("Логин", ИмяПользователя);
		
		Если Пароль = ПодтверждениеПароля Тогда
			
			Если Пароль <> ПроверкаИзмененияПароля Тогда
				Настройки.Вставить("Пароль", Пароль);
			КонецЕсли;
			
		Иначе
			
			ВызватьИсключение НСтр("ru='Пароль и подтверждение пароля не совпадают!';uk='Пароль і підтвердження пароля не збігаються!'");
			
		КонецЕсли;
		
		Обработки.НастройкаСтандартногоИнтерфейсаOData.ЗаписатьНастройкиАвторизацииДляСтандартногоИнтерфейсаOData(Настройки);
		
		Состав = Новый Массив();
		
		Дерево = РеквизитФормыВЗначение("ОбъектыМетаданных");
		Строки = Дерево.Строки.НайтиСтроки(Новый Структура("Использование", Истина), Истина);
		Для Каждого Строка Из Строки Цикл
			Состав.Добавить(Строка.ПолноеИмя);
		КонецЦикла;
		
		РаботаВБезопасномРежиме.ВыполнитьВБезопасномРежиме("УстановитьСоставСтандартногоИнтерфейсаOData(Параметры);", Состав);
		
		Модифицированность = Ложь;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗакрытиеПослеВопроса(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		СохранитьИЗакрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПараметрыНастройки()
	
	Данные = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Данные.ДеревоОбъектов, "ОбъектыМетаданных");
	ЗначениеВРеквизитФормы(Данные.ЗависимостиДобавления, "ЗависимостиДляДобавления");
	ЗначениеВРеквизитФормы(Данные.ЗависимостиУдаления, "ЗависимостиДляУдаления");
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьПодготовкуПараметровНастройки()
	
	СтруктураПараметров = Новый Структура;
	
	НаименованиеЗадания = "ПодготовитьПараметрыНастройкиСоставаСтандартногоИнтерфейсаOData";
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"Обработки.НастройкаСтандартногоИнтерфейсаOData.ПодготовитьПараметрыНастройкиСоставаСтандартногоИнтерфейсаOData",
		СтруктураПараметров, 
		НаименованиеЗадания);
		
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПараметрыНастройки();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПараметрыНастройки();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти


