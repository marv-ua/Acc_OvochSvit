﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура("ПредыдущийМесяц, Ответственный", 
		"Объект.ПериодРегистрации",
		"Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
	КонецЕсли;
	
	ПлательщикНалогаНаПрибыльДо2015 = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеОтражениеЗарплатыВУчете";
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьДобавленныеКолонкиТаблиц();
	УстановитьСостояниеДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьВидимостьСтраниц();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УстановитьВидимостьСтраниц();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыОтражениеВУчете

&НаКлиенте
Процедура ОтражениеВУчетеПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ОтражениеВУчете.ТекущиеДанные;
	
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Дт");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СтрокаТаблицы.СчетДт, "Дт", Истина);
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Кт");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СтрокаТаблицы.СчетКт, "Кт", Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеПередНачаломИзменения(Элемент, Отказ)
	
	СтрокаТаблицы = Элементы.ОтражениеВУчете.ТекущиеДанные;
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Дт");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СтрокаТаблицы.СчетДт, "Дт", Истина);
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Кт");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СтрокаТаблицы.СчетКт, "Кт", Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНадписиВПроводке(Элементы.ОтражениеВУчете.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.ОтражениеВУчете.ТекущиеДанные;
	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, СтрокаТаблицы, "СубконтоДт%Индекс%", "СчетДт");
	ПараметрыДокумента.Вставить("СчетУчета", СтрокаТаблицы.СчетДт);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСчетДтПриИзменении(Элемент)
	
	ОбработатьИзменениеСчета("Дт");

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДтПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Дт");

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСчетКтПриИзменении(Элемент)
	
	ОбработатьИзменениеСчета("Кт");

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКтПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Кт");
		
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.ОтражениеВУчете.ТекущиеДанные;
	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, СтрокаТаблицы, "СубконтоКт%Индекс%", "СчетКт");
	ПараметрыДокумента.Вставить("СчетУчета", СтрокаТаблицы.СчетКт);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

#КонецОбласти






#Область ОбработчикиСобытийТаблицыФормыУдержаннаяЗарплата

&НаКлиенте
Процедура УдержаннаяЗарплатаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
	
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьПараметрыВыбораПолейСубконтоУдержания(ЭтаФорма);
	УстановитьЗаголовкиИДоступностьСубконтоУдержания(ЭтаФорма, СтрокаТаблицы.СчетУчета, Истина);

КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаПередНачаломИзменения(Элемент, Отказ)
	СтрокаТаблицы = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
	ИзменитьПараметрыВыбораПолейСубконтоУдержания(ЭтаФорма);
	УстановитьЗаголовкиИДоступностьСубконтоУдержания(ЭтаФорма, СтрокаТаблицы.СчетУчета, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	ПоляОбъекта = Новый Структура("Субконто1,Субконто2,Субконто3,Организация");
	ПоляОбъекта.Субконто1      = "Субконто1";
	ПоляОбъекта.Субконто2      = "Субконто2";
	ПоляОбъекта.Субконто3      = "Субконто3";
	ПоляОбъекта.Организация    = Объект.Организация;
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(ТекущиеДанные["СчетУчета"], ТекущиеДанные, ПоляОбъекта, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаСубконтоПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконтоУдержания(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, СтрокаТаблицы, "Субконто%Индекс%", "СчетУчета");
	ПараметрыДокумента.Вставить("СчетУчета", СтрокаТаблицы.СчетУчета);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаСчетУчетаПриИзменении(Элемент)
	ОбработатьИзменениеСчетаУдержания();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыНачисленныеПроцентыПоЗаймам

&НаКлиенте
Процедура НачисленныеПроцентыПоЗаймамПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.НачисленныеПроцентыПоЗаймам.ТекущиеДанные;
	
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьПараметрыВыбораПолейСубконтоПроценты(ЭтаФорма);
	УстановитьЗаголовкиИДоступностьСубконтоПроценты(ЭтаФорма, СтрокаТаблицы.СчетУчета, Истина);

КонецПроцедуры

&НаКлиенте
Процедура НачисленныеПроцентыПоЗаймамПередНачаломИзменения(Элемент, Отказ)
	СтрокаТаблицы = Элементы.НачисленныеПроцентыПоЗаймам.ТекущиеДанные;
	ИзменитьПараметрыВыбораПолейСубконтоПроценты(ЭтаФорма);
	УстановитьЗаголовкиИДоступностьСубконтоПроценты(ЭтаФорма, СтрокаТаблицы.СчетУчета, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НачисленныеПроцентыПоЗаймамПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.НачисленныеПроцентыПоЗаймам.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	ПоляОбъекта = Новый Структура("Субконто1,Субконто2,Субконто3,Организация");
	ПоляОбъекта.Субконто1      = "Субконто1";
	ПоляОбъекта.Субконто2      = "Субконто2";
	ПоляОбъекта.Субконто3      = "Субконто3";
	ПоляОбъекта.Организация    = Объект.Организация;
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(ТекущиеДанные["СчетУчета"], ТекущиеДанные, ПоляОбъекта, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НачисленныеПроцентыПоЗаймамСубконтоПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконтоПроценты(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НачисленныеПроцентыПоЗаймамСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.НачисленныеПроцентыПоЗаймам.ТекущиеДанные;
	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, СтрокаТаблицы, "Субконто%Индекс%", "СчетУчета");
	ПараметрыДокумента.Вставить("СчетУчета", СтрокаТаблицы.СчетУчета);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
КонецПроцедуры

&НаКлиенте
Процедура НачисленныеПроцентыПоЗаймамСчетУчетаПриИзменении(Элемент)
	ОбработатьИзменениеСчетаПроценты();
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконтоУдержания(Форма)

	ИдСтроки = Форма.Элементы.УдержаннаяЗарплата.ТекущаяСтрока;
	Если ИдСтроки <> Неопределено Тогда
		СтрокаТаблицы = Форма.Объект.УдержаннаяЗарплата.НайтиПоИдентификатору(ИдСтроки);
		ПараметрыДокумента = ПолучитьСписокПараметров(Форма, СтрокаТаблицы, "Субконто%Индекс%", "СчетУчета");
		БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
			Форма, СтрокаТаблицы, "Субконто%Индекс%", "УдержаннаяЗарплатаСубконто%Индекс%", ПараметрыДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконтоУдержания(Форма, Счет, ЭтоТаблица = Ложь)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		"УдержаннаяЗарплатаСубконто1",
		"УдержаннаяЗарплатаСубконто2",
		"УдержаннаяЗарплатаСубконто3");
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, Неопределено, ЭтоТаблица);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеСчетаУдержания()

	ТекущиеДанные = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
	
	ПоляФормы = Новый Структура("Субконто1,Субконто2,Субконто3");
	ПоляФормы.Субконто1 = "УдержаннаяЗарплатаСубконто1";
	ПоляФормы.Субконто2 = "УдержаннаяЗарплатаСубконто2";
	ПоляФормы.Субконто3 = "УдержаннаяЗарплатаСубконто3";
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(ТекущиеДанные["СчетУчета"], ЭтаФорма, ПоляФормы, Неопределено, Истина);
	
	ПоляОбъекта = Новый Структура("Субконто1,Субконто2,Субконто3,Организация");
	ПоляОбъекта.Субконто1      = "Субконто1";
	ПоляОбъекта.Субконто2      = "Субконто2";
	ПоляОбъекта.Субконто3      = "Субконто3";
	ПоляОбъекта.Организация    = Объект.Организация;
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(ТекущиеДанные["СчетУчета"], ТекущиеДанные, ПоляОбъекта, Истина);
	
	ИзменитьПараметрыВыбораПолейСубконтоУдержания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконтоПроценты(Форма)

	ИдСтроки = Форма.Элементы.НачисленныеПроцентыПоЗаймам.ТекущаяСтрока;
	Если ИдСтроки <> Неопределено Тогда
		СтрокаТаблицы = Форма.Объект.НачисленныеПроцентыПоЗаймам.НайтиПоИдентификатору(ИдСтроки);
		ПараметрыДокумента = ПолучитьСписокПараметров(Форма, СтрокаТаблицы, "Субконто%Индекс%", "СчетУчета");
		БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
			Форма, СтрокаТаблицы, "Субконто%Индекс%", "НачисленныеПроцентыПоЗаймамСубконто%Индекс%", ПараметрыДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконтоПроценты(Форма, Счет, ЭтоТаблица = Ложь)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		"НачисленныеПроцентыПоЗаймамСубконто1",
		"НачисленныеПроцентыПоЗаймамСубконто2",
		"НачисленныеПроцентыПоЗаймамСубконто3");
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, Неопределено, ЭтоТаблица);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеСчетаПроценты()

	ТекущиеДанные = Элементы.НачисленныеПроцентыПоЗаймам.ТекущиеДанные;
	
	ПоляФормы = Новый Структура("Субконто1,Субконто2,Субконто3");
	ПоляФормы.Субконто1 = "НачисленныеПроцентыПоЗаймамСубконто1";
	ПоляФормы.Субконто2 = "НачисленныеПроцентыПоЗаймамСубконто2";
	ПоляФормы.Субконто3 = "НачисленныеПроцентыПоЗаймамСубконто3";
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(ТекущиеДанные["СчетУчета"], ЭтаФорма, ПоляФормы, Неопределено, Истина);
	
	ПоляОбъекта = Новый Структура("Субконто1,Субконто2,Субконто3,Организация");
	ПоляОбъекта.Субконто1      = "Субконто1";
	ПоляОбъекта.Субконто2      = "Субконто2";
	ПоляОбъекта.Субконто3      = "Субконто3";
	ПоляОбъекта.Организация    = Объект.Организация;
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(ТекущиеДанные["СчетУчета"], ТекущиеДанные, ПоляОбъекта, Истина);
	
	ИзменитьПараметрыВыбораПолейСубконтоПроценты(ЭтаФорма);
	
КонецПроцедуры






#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

	ПлательщикНалогаНаПрибыльДо2015 = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	ПлательщикНалогаНаПрибыльДо2015 = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	ПлательщикНалогаНаПрибыльДо2015 = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	ПоляОбъектаДт = Новый Структура(
		"Субконто1, Субконто2, Субконто3, Подразделение",
		"СубконтоДт1", "СубконтоДт2", "СубконтоДт3", "ПодразделениеДт");
	ПоляОбъектаКт = Новый Структура(
		"Субконто1, Субконто2, Субконто3, Подразделение",
		"СубконтоКт1", "СубконтоКт2", "СубконтоКт3", "ПодразделениеКт");

	Для каждого СтрокаТаблицы Из ОБъект.ОтражениеВУчете Цикл
		БухгалтерскийУчетКлиентСервер.УстановитьДоступностьСубконто(СтрокаТаблицы.СчетДт, СтрокаТаблицы, ПоляОбъектаДт);
		БухгалтерскийУчетКлиентСервер.УстановитьДоступностьСубконто(СтрокаТаблицы.СчетКт, СтрокаТаблицы, ПоляОбъектаКт);
		ЗаполнитьНадписиВПроводке(СтрокаТаблицы);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНадписиВПроводке(СтрокаТаблицы)
	
	СтрокаТаблицы.НадписьНУ = НСтр("ru='НУ:';uk='ПО:'");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокПараметров(Форма, Объект, ШаблонИмяПоляОбъекта, ИмяПоляСчетУчета)

	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		ТипПоля = ТипЗнч(Объект[ИмяПоля]);
		Если ТипПоля = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", Объект[ИмяПоля]);
		ИначеЕсли ТипПоля = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", Объект[ИмяПоля]);
		ИначеЕсли ТипПоля = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", Объект[ИмяПоля]);
		ИначеЕсли ТипПоля = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", Объект[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("ОстаткиОбороты", 1);
	СписокПараметров.Вставить("Организация"   , Форма.Объект.Организация);
	СписокПараметров.Вставить("СчетУчета",      Объект[ИмяПоляСчетУчета]);

	Возврат СписокПараметров;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, ДтКт)

	ИдСтроки = Форма.Элементы.ОтражениеВУчете.ТекущаяСтрока;
	Если ИдСтроки <> Неопределено Тогда
		СтрокаТаблицы = Форма.Объект.ОтражениеВУчете.НайтиПоИдентификатору(ИдСтроки);
		ПараметрыДокумента = ПолучитьСписокПараметров(Форма, СтрокаТаблицы, "Субконто" + ДтКт + "%Индекс%", "Счет" + ДтКт);
		БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
			Форма, СтрокаТаблицы, "Субконто" + ДтКт + "%Индекс%", "ОтражениеВУчетеСубконто" + ДтКт + "%Индекс%", ПараметрыДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет, ДтКт = "", ЭтоТаблица = Ложь)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ОтражениеВУчетеСубконто" + ДтКт + "1",
		"ОтражениеВУчетеСубконто" + ДтКт + "2",
		"ОтражениеВУчетеСубконто" + ДтКт + "3");
	ПоляФормы.Вставить("Подразделение", "ОтражениеВУчетеПодразделение" + ДтКт);
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, Неопределено, ЭтоТаблица);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеСчета(ДтКт)

	ТекущиеДанные = Элементы.ОтражениеВУчете.ТекущиеДанные;
	
	ПоляФормы = Новый Структура("Субконто1,Субконто2,Субконто3");
	ПоляФормы.Субконто1 = "ОтражениеВУчетеСубконто" + ДтКт + "1";
	ПоляФормы.Субконто2 = "ОтражениеВУчетеСубконто" + ДтКт + "2";
	ПоляФормы.Субконто3 = "ОтражениеВУчетеСубконто" + ДтКт + "3";
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(ТекущиеДанные["Счет" + ДтКт], ЭтаФорма, ПоляФормы, Неопределено, Истина);
	
	ПоляОбъекта = Новый Структура("Субконто1,Субконто2,Субконто3,Подразделение,Организация");
	ПоляОбъекта.Субконто1      = "Субконто" + ДтКт + "1";
	ПоляОбъекта.Субконто2      = "Субконто" + ДтКт + "2";
	ПоляОбъекта.Субконто3      = "Субконто" + ДтКт + "3";
	ПоляОбъекта.Подразделение  = "Подразделение" + ДтКт;
	ПоляОбъекта.Организация    = Объект.Организация;
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(ТекущиеДанные["Счет" + ДтКт], ТекущиеДанные, ПоляОбъекта, Истина);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, ДтКт);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматОбмена30ПриИзменении(Элемент)
	УстановитьВидимостьСтраниц();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьСтраниц()
	
	Элементы.ФорматОбмена30.ТолькоПросмотр = Объект.Проведен;
	Элементы.ОтражениеВУчетеСтраница.Видимость = НЕ Объект.ФорматОбмена30;
	Элементы.НачисленияИВзносыСтраница.Видимость = Объект.ФорматОбмена30;
	Элементы.НДФЛСтраница.Видимость = Объект.ФорматОбмена30;
	Элементы.УдержанияСтраница.Видимость = Объект.ФорматОбмена30;
	Элементы.ГруппаЗарплатаОтражена.Видимость = Объект.ФорматОбмена30;
	Элементы.ГруппаИтого.Видимость = Объект.ФорматОбмена30;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаОтраженаВБухучетеПриИзменении(Элемент)
	Если Объект.ЗарплатаОтраженаВБухучете Тогда
		Объект.Бухгалтер = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		Объект.Бухгалтер = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыУдержанийНаСервере()
	ДокументОбъект = РеквизитФормыВЗначение("Объект"); 
	ДокументОбъект.ЗаполнитьПараметрыУдержанийОбъекта();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыУдержаний(Команда)
	ЗаполнитьПараметрыУдержанийНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыПроцентовНаСервере()
	ДокументОбъект = РеквизитФормыВЗначение("Объект"); 
	ДокументОбъект.ЗаполнитьПараметрыПроцентовОбъекта();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыПроцентов(Команда)
	ЗаполнитьПараметрыПроцентовНаСервере();
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти