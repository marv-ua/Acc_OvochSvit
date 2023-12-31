﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Функция проверяет, существуют ли ссылки на номенклатуру в движениях регистров 
//
// Возвращаемое значение:
//  Истина - если есть движения, Ложь - если нет.
//
Функция СуществуютСсылки()

	УстановитьПривилегированныйРежим(Истина);

	СуществуютСсылки = Ложь; 
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекущийВладелец", Ссылка);
	Запрос.Текст = "";

	ТипНоменклатура = ТипЗнч(Справочники.Номенклатура.ПустаяСсылка());

	Запрос.УстановитьПараметр("ВидСубконто", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ХозрасчетныйСубконто.Значение
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
	|ГДЕ
	|	ХозрасчетныйСубконто.Вид = &ВидСубконто
	|	И ХозрасчетныйСубконто.Значение = &ТекущийВладелец
	|	";
	
	Для Каждого РегистрНакопления Из Метаданные.РегистрыНакопления Цикл

		Для Каждого РеквизитРегистра Из РегистрНакопления.Измерения Цикл

			Если РеквизитРегистра.Тип.СодержитТип(ТипНоменклатура) Тогда

				Если Запрос.Текст <> "" Тогда
					Запрос.Текст = Запрос.Текст + "
					|ОБЪЕДИНИТЬ ВСЕ
					|";
				КонецЕсли;
				Запрос.Текст = Запрос.Текст + "
				|ВЫБРАТЬ ПЕРВЫЕ 1
				|	РегистрНакопления."+РегистрНакопления.Имя+"."+РеквизитРегистра.Имя+" КАК Номенклатура
				|ГДЕ
				|	"+РеквизитРегистра.Имя+" = &ТекущийВладелец
				|";

			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	Если НЕ Запрос.Текст = "" Тогда
		СуществуютСсылки = НЕ Запрос.Выполнить().Пустой();
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);

	Возврат СуществуютСсылки;

КонецФункции //  Номенклатура_СуществуютСсылки()

// Обработчик события ПередЗаписью формы.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ЭтоГруппа Тогда

		СуществуютСсылки = НЕ ЭтоНовый() И СуществуютСсылки();

		Если Услуга <> Ссылка.Услуга И СуществуютСсылки Тогда

			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Номенклатура ""%1"" участвует в товародвижении.
|Признак услуги не может быть изменен!';uk='Номенклатура ""%1"" бере участь у русі товарів.
|Ознака послуги не може бути змінена!'"), СокрЛП(Ссылка));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, 
				"Услуга", "Объект", Отказ);

		КонецЕсли;
		
		Если (НЕ Услуга) И БазоваяЕдиницаИзмерения <> Ссылка.БазоваяЕдиницаИзмерения И СуществуютСсылки Тогда

			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Номенклатура ""%1"" участвует в товародвижении. Базовая единица не может быть изменена';uk='Номенклатура ""%1"" бере участь у русі товарів. Базова одиниця виміру не може бути змінена!'"), СокрЛП(Ссылка));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, 
				"БазоваяЕдиницаИзмерения", "Объект", Отказ);

		КонецЕсли;


	КонецЕсли;

КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// пропишем в регистр базовую единицу измрения единицы измерения 
	// установим для нее коэффициент = 1
	Если НЕ ЭтоГруппа И НЕ БазоваяЕдиницаИзмерения.Пустая() Тогда
	
		СведенияОЕдиницах = ЕдиницыИзмерения.Найти(БазоваяЕдиницаИзмерения, "ЕдиницаИзмерения");
		ЗаписатьЭлемент = Ложь;
		
		Если СведенияОЕдиницах = Неопределено Тогда
			Запись = ЕдиницыИзмерения.Добавить();
			Запись.Коэффициент 		= 1;
			Запись.ЕдиницаИзмерения = БазоваяЕдиницаИзмерения;
			ЗаписатьЭлемент = Истина;
		ИначеЕсли СведенияОЕдиницах.Коэффициент <> 1 Тогда 	
			СведенияОЕдиницах.Коэффициент = 1;
			ЗаписатьЭлемент = Истина;
		КонецЕсли;
		
		Если ЗаписатьЭлемент Тогда
		
			Записать();	
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
		
		НоменклатураГТД     = Неопределено;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если НЕ ЭтоГруппа Тогда
		
		СохраняемыеЗначенияРеквизитов = ХранилищеОбщихНастроек.Загрузить("Номенклатура_СохраняемыеЗначенияРеквизитов");
		Если ЗначениеЗаполнено(СохраняемыеЗначенияРеквизитов) Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СохраняемыеЗначенияРеквизитов);	
		КонецЕсли;
		
		БазоваяЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.ПолучитьЕдиницуИзмеренияПоУмолчанию();
		
	КонецЕсли; 

КонецПроцедуры

#КонецЕсли