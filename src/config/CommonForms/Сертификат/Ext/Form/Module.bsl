﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.АдресСертификата) Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(Параметры.АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДанныеСертификата);
		АдресСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.Ссылка) Тогда
		АдресСертификата = АдресСертификата(Параметры.Ссылка, УникальныйИдентификатор);
		
		Если АдресСертификата = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось открыть сертификат ""%1"",
                           |т.к. он не найден в справочнике.'
                           |;uk='Не вдається відкрити сертифікат ""%1"",
                           |тому що він не знайдений у довіднику.'"), Параметры.Ссылка);
		КонецЕсли;
	Иначе // Отпечаток
		АдресСертификата = АдресСертификата(Параметры.Отпечаток, УникальныйИдентификатор);
		
		Если АдресСертификата = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось открыть сертификат, т.к. он не найден
                           |по отпечатку ""%1"".'
                           |;uk='Не вдається відкрити сертифікат, тому що його не знайдено
                           |по відбитку ""%1"".'"), Параметры.Отпечаток);
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеСертификата = Неопределено Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДанныеСертификата);
	КонецЕсли;
	
	СтруктураСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
	
	НазначениеПодписание = Сертификат.ИспользоватьДляПодписи;
	НазначениеШифрование = Сертификат.ИспользоватьДляШифрования;
	
	Отпечаток      = СтруктураСертификата.Отпечаток;
	КомуВыдан      = СтруктураСертификата.КомуВыдан;
	КемВыдан       = СтруктураСертификата.КемВыдан;
	ДействителенДо = СтруктураСертификата.ДействителенДо;
	
	ЗаполнитьКодыНазначенияСертификата(СтруктураСертификата.Назначение, НазначениеКоды);
	
	ЗаполнитьСвойстваСубъекта(Сертификат);
	ЗаполнитьСвойстваИздателя(Сертификат);
	
	ГруппаВнутреннихПолей = "Общие";
	ЗаполнитьВнутренниеПоляСертификата();
	
	Если Параметры.Свойство("ОткрытиеИзФормыЭлементаСертификата") Тогда
		Элементы.ФормаСохранитьВФайл.Видимость = Ложь;
		Элементы.ФормаПроверить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаВнутреннихПолейПриИзменении(Элемент)
	
	ЗаполнитьВнутренниеПоляСертификата();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьВФайл(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(Неопределено, АдресСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ЭлектроннаяПодписьКлиент.ПроверитьСертификат(Новый ОписаниеОповещения(
		"ПроверитьЗавершение", ЭтотОбъект), АдресСертификата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры Проверить.
&НаКлиенте
Процедура ПроверитьЗавершение(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьПредупреждение(, НСтр("ru='Сертификат действителен.';uk='Сертифікат дійсний.'"));
		
	ИначеЕсли Результат <> Неопределено Тогда
		ПараметрыПредупреждения = Новый Структура;
		
		ПараметрыПредупреждения.Вставить("ТекстПредупреждения", Результат);
		ПараметрыПредупреждения.Вставить("ЗаголовокПредупреждения", НСтр("ru='Сертификат недействителен по причине:';uk='Сертифікат недійсний з причини:'"));
		
		ОткрытьФорму("ОбщаяФорма.РезультатПроверки", ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваСубъекта(Сертификат)
	
	Коллекция = ЭлектроннаяПодписьКлиентСервер.СвойстваСубъектаСертификата(Сертификат);
	
	ПредставленияСвойств = Новый СписокЗначений;
	ПредставленияСвойств.Добавить("ОбщееИмя",         НСтр("ru='Общее имя';uk='Загальне ім''я'"));
	ПредставленияСвойств.Добавить("Страна",           НСтр("ru='Страна';uk='Країна'"));
	ПредставленияСвойств.Добавить("Регион",           НСтр("ru='Регион';uk='Регіон'"));
	ПредставленияСвойств.Добавить("НаселенныйПункт",  НСтр("ru='Населенный пункт';uk='Населений пункт'"));
	ПредставленияСвойств.Добавить("Улица",            НСтр("ru='Улица';uk='Вулиця'"));
	ПредставленияСвойств.Добавить("Организация",      НСтр("ru='Организация';uk='Організація'"));
	ПредставленияСвойств.Добавить("Подразделение",    НСтр("ru='Подразделение';uk='Підрозділ'"));
	ПредставленияСвойств.Добавить("Должность",        НСтр("ru='Должность';uk='Посада'"));
	ПредставленияСвойств.Добавить("ЭлектроннаяПочта", НСтр("ru='Электронная почта';uk='Електронна пошта'"));
	ПредставленияСвойств.Добавить("ОГРН",             НСтр("ru='ОГРН';uk='ОГРН'"));
	ПредставленияСвойств.Добавить("ОГРНИП",           НСтр("ru='ОГРНИП';uk='ОГРНИП'"));
	ПредставленияСвойств.Добавить("СНИЛС",            НСтр("ru='СНИЛС';uk='СНІЛС'"));
	ПредставленияСвойств.Добавить("ИНН",              НСтр("ru='ИНН';uk='ІПН'"));
	ПредставленияСвойств.Добавить("Фамилия",          НСтр("ru='Фамилия';uk='Прізвище'"));
	ПредставленияСвойств.Добавить("Имя",              НСтр("ru='Имя';uk='Ім''я'"));
	ПредставленияСвойств.Добавить("Отчество",         НСтр("ru='Отчество';uk='По батькові'"));
	
	Для каждого ЭлементСписка Из ПредставленияСвойств Цикл
		Если Не ЗначениеЗаполнено(Коллекция[ЭлементСписка.Значение]) Тогда
			Продолжить;
		КонецЕсли;
		Строка = Субъект.Добавить();
		Строка.Свойство = ЭлементСписка.Представление;
		Строка.Значение = Коллекция[ЭлементСписка.Значение];
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваИздателя(Сертификат)
	
	Коллекция = ЭлектроннаяПодписьКлиентСервер.СвойстваИздателяСертификата(Сертификат);
	
	ПредставленияСвойств = Новый СписокЗначений;
	ПредставленияСвойств.Добавить("ОбщееИмя",         НСтр("ru='Общее имя';uk='Загальне ім''я'"));
	ПредставленияСвойств.Добавить("Страна",           НСтр("ru='Страна';uk='Країна'"));
	ПредставленияСвойств.Добавить("Регион",           НСтр("ru='Регион';uk='Регіон'"));
	ПредставленияСвойств.Добавить("НаселенныйПункт",  НСтр("ru='Населенный пункт';uk='Населений пункт'"));
	ПредставленияСвойств.Добавить("Улица",            НСтр("ru='Улица';uk='Вулиця'"));
	ПредставленияСвойств.Добавить("Организация",      НСтр("ru='Организация';uk='Організація'"));
	ПредставленияСвойств.Добавить("Подразделение",    НСтр("ru='Подразделение';uk='Підрозділ'"));
	ПредставленияСвойств.Добавить("ЭлектроннаяПочта", НСтр("ru='Электронная почта';uk='Електронна пошта'"));
	ПредставленияСвойств.Добавить("ОГРН",             НСтр("ru='ОГРН';uk='ОГРН'"));
	ПредставленияСвойств.Добавить("ИНН",              НСтр("ru='ИНН';uk='ІПН'"));
	
	Для каждого ЭлементСписка Из ПредставленияСвойств Цикл
		Если Не ЗначениеЗаполнено(Коллекция[ЭлементСписка.Значение]) Тогда
			Продолжить;
		КонецЕсли;
		Строка = Издатель.Добавить();
		Строка.Свойство = ЭлементСписка.Представление;
		Строка.Значение = Коллекция[ЭлементСписка.Значение];
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВнутренниеПоляСертификата()
	
	ВнутреннееСодержание.Очистить();
	ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
	Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
	
	Если ГруппаВнутреннихПолей = "Общие" Тогда
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Ложь;
		
		ДобавитьСвойство(Сертификат, "Версия",                    НСтр("ru='Версия';uk='Версія'"));
		ДобавитьСвойство(Сертификат, "ДатаНачала",                НСтр("ru='Дата начала';uk='Дата початку'"));
		ДобавитьСвойство(Сертификат, "ДатаОкончания",             НСтр("ru='Дата окончания';uk='Дата закінчення'"));
		ДобавитьСвойство(Сертификат, "ИспользоватьДляПодписи",    НСтр("ru='Использовать для подписи';uk='Використовувати для підпису'"));
		ДобавитьСвойство(Сертификат, "ИспользоватьДляШифрования", НСтр("ru='Использовать для шифрования';uk='Використовувати для шифрування'"));
		ДобавитьСвойство(Сертификат, "ОткрытыйКлюч",              НСтр("ru='Открытый ключ';uk='Відкритий ключ'"), Истина);
		ДобавитьСвойство(Сертификат, "Отпечаток",                 НСтр("ru='Отпечаток';uk='Відбиток'"), Истина);
		ДобавитьСвойство(Сертификат, "СерийныйНомер",             НСтр("ru='Серийный номер';uk='Серійний номер'"), Истина);
		
	ИначеЕсли ГруппаВнутреннихПолей = "РасширенныеСвойства" Тогда
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Ложь;
		
		Коллекция = Сертификат.РасширенныеСвойства;
		Для Каждого КлючИЗначение Из Коллекция Цикл
			ДобавитьСвойство(Коллекция, КлючИЗначение.Ключ, КлючИЗначение.Ключ);
		КонецЦикла;
	Иначе
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Истина;
		
		ИменаИдентификаторов = Новый СписокЗначений;
		ИменаИдентификаторов.Добавить("OID2_5_4_3",              "CN");
		ИменаИдентификаторов.Добавить("OID2_5_4_6",              "C");
		ИменаИдентификаторов.Добавить("OID2_5_4_8",              "ST");
		ИменаИдентификаторов.Добавить("OID2_5_4_7",              "L");
		ИменаИдентификаторов.Добавить("OID2_5_4_9",              "Street");
		ИменаИдентификаторов.Добавить("OID2_5_4_10",             "O");
		ИменаИдентификаторов.Добавить("OID2_5_4_11",             "OU");
		ИменаИдентификаторов.Добавить("OID2_5_4_12",             "T");
		ИменаИдентификаторов.Добавить("OID1_2_840_113549_1_9_1", "E");
		
		ИменаИдентификаторов.Добавить("OID1_2_643_100_1",     "OGRN");
		ИменаИдентификаторов.Добавить("OID1_2_643_100_5",     "OGRNIP");
		ИменаИдентификаторов.Добавить("OID1_2_643_100_3",     "SNILS");
		ИменаИдентификаторов.Добавить("OID1_2_643_3_131_1_1", "INN");
		ИменаИдентификаторов.Добавить("OID2_5_4_4",           "SN");
		ИменаИдентификаторов.Добавить("OID2_5_4_42",          "GN");
		
		ИменаИИдентификаторы = Новый Соответствие;
		Коллекция = Сертификат[ГруппаВнутреннихПолей];
		
		Для Каждого ЭлементСписка Из ИменаИдентификаторов Цикл
			Если Коллекция.Свойство(ЭлементСписка.Значение) Тогда
				ДобавитьСвойство(Коллекция, ЭлементСписка.Значение, ЭлементСписка.Представление);
			КонецЕсли;
			ИменаИИдентификаторы.Вставить(ЭлементСписка.Значение, Истина);
			ИменаИИдентификаторы.Вставить(ЭлементСписка.Представление, Истина);
		КонецЦикла;
		
		Для Каждого КлючИЗначение Из Коллекция Цикл
			Если ИменаИИдентификаторы.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
				ДобавитьСвойство(Коллекция, КлючИЗначение.Ключ, КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСвойство(ЗначенияСвойств, Свойство, Представление, НижнийРегистр = Неопределено)
	
	Значение = ЗначенияСвойств[Свойство];
	Если ТипЗнч(Значение) = Тип("Дата") Тогда
		Значение = МестноеВремя(Значение, ЧасовойПоясСеанса());
	ИначеЕсли ТипЗнч(Значение) = Тип("ФиксированныйМассив") Тогда
		ФиксированныйМассив = Значение;
		Значение = "";
		Для каждого ЭлементМассива Из ФиксированныйМассив Цикл
			Значение = Значение + ?(Значение = "", "", Символы.ПС) + СокрЛП(ЭлементМассива);
		КонецЦикла;
	КонецЕсли;
	
	Строка = ВнутреннееСодержание.Добавить();
	Если СтрНачинаетсяС(Свойство, "OID") Тогда
		Строка.Идентификатор = СтрЗаменить(Сред(Свойство, 4), "_", ".");
		Если Свойство <> Представление Тогда
			Строка.Свойство = Представление;
		КонецЕсли;
	Иначе
		Строка.Свойство = Представление;
	КонецЕсли;
	
	Если НижнийРегистр = Истина Тогда
		Строка.Значение = НРег(Значение);
	Иначе
		Строка.Значение = Значение;
	КонецЕсли;
	
КонецПроцедуры

// Преобразует назначения сертификатов в коды назначения.
//
// Параметры:
//  Назначение    - Строка - многострочное назначение сертификата, например:
//                           "Microsoft Encrypted File System (1.3.6.1.4.1.311.10.3.4)
//                           |E-mail Protection (1.3.6.1.5.5.7.3.4)
//                           |TLS Web Client Authentication (1.3.6.1.5.5.7.3.2)".
//  
//  КодыНазначения - Строка - коды назначения "1.3.6.1.4.1.311.10.3.4, 1.3.6.1.5.5.7.3.4, 1.3.6.1.5.5.7.3.2".
//
&НаСервере
Процедура ЗаполнитьКодыНазначенияСертификата(Назначение, КодыНазначения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Коды = "";
	
	Для Индекс = 1 По СтрЧислоСтрок(Назначение) Цикл
		
		Строка = СтрПолучитьСтроку(Назначение, Индекс);
		ТекущийКод = "";
		
		Позиция = СтрНайти(Строка, "(", НаправлениеПоиска.СКонца);
		Если Позиция <> 0 Тогда
			ТекущийКод = Сред(Строка, Позиция + 1, СтрДлина(Строка) - Позиция - 1);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущийКод) Тогда
			Коды = Коды + ?(Коды = "", "", ", ") + СокрЛП(ТекущийКод);
		КонецЕсли;
		
	КонецЦикла;
	
	КодыНазначения = Коды;
	
КонецПроцедуры

&НаСервере
Функция АдресСертификата(СсылкаОтпечаток, ИдентификаторФормы = Неопределено)
	
	ДанныеСертификата = Неопределено;
	
	Если ТипЗнч(СсылкаОтпечаток) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		Хранилище = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаОтпечаток, "ДанныеСертификата");
		Если ТипЗнч(Хранилище) = Тип("ХранилищеЗначения") Тогда
			ДанныеСертификата = Хранилище.Получить();
		КонецЕсли;
	Иначе
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Отпечаток", СсылкаОтпечаток);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Сертификаты.ДанныеСертификата
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
		|ГДЕ
		|	Сертификаты.Отпечаток = &Отпечаток";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДанныеСертификата = Выборка.ДанныеСертификата.Получить();
		Иначе
			Сертификат = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(СсылкаОтпечаток, Ложь, Ложь);
			Если Сертификат <> Неопределено Тогда
				ДанныеСертификата = Сертификат.Выгрузить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		Возврат ПоместитьВоВременноеХранилище(ДанныеСертификата, ИдентификаторФормы);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
