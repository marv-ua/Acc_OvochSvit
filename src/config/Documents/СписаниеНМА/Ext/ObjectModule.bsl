﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыль"             , УчетнаяПолитика.ПлательщикНалогаНаПрибыль(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"		  , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                        , УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,ТаблицаПоНМА, ТаблицаМестонахождений, Отказ, Заголовок)

	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоНМА, ТаблицаМестонахождений, Отказ, Заголовок)

КонецПроцедуры

Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоНМА, ТаблицаМестонахождений, Отказ, Заголовок)
	
	ДатаДока       = Дата;
	ТекОрганизация = СтруктураШапкиДокумента.Организация;
    НомерЖурнала   = НСтр("ru='НА';uk='НА'",Локализация.КодЯзыкаИнформационнойБазы());

	УправлениеНеоборотнымиАктивами.ДополнитьТабличнуюЧастьСведениямиОбНМАБухНалогРегл(МоментВремени(), ТаблицаПоНМА,
	                                                  СтруктураШапкиДокумента, 
													  Отказ, Заголовок);

	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;								
	
	СостояниеНМА             = Движения.СостоянияНМАОрганизаций;
	ПроводкиБУ              = Движения.Хозрасчетный;
	
	// Подготовим таблицу с данными по амортизации для начисления амортизации по направлениям затрат
	ТабАмортизации = Новый ТаблицаЗначений;
	ТабАмортизации.Колонки.Добавить("НаправлениеАмортизации",
	                                Новый ОписаниеТипов("СправочникСсылка.СпособыОтраженияРасходовПоАмортизации"));
	ТабАмортизации.Колонки.Добавить("ОбъектУчета", 
	                                Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы"));
	ТабАмортизации.Колонки.Добавить("Сумма", ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТабАмортизации.Колонки.Добавить("СуммаНУ", ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТабАмортизации.Колонки.Добавить("СчетАмортизации");
	ТабАмортизации.Колонки.Добавить("НалоговоеНазначение", 		Новый ОписаниеТипов("СправочникСсылка.НалоговыеНазначенияАктивовИЗатрат"));
	ТабАмортизации.Колонки.Добавить("Местонахождение",			Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
	
	Для Каждого СтрокаНМА Из ТаблицаПоНМА Цикл
		
		Если СтрокаНМА.АмортизацияЗаМесяцБУ > 0 Тогда
			 
			НоваяСтрока = ТабАмортизации.Добавить();
			
			НоваяСтрока.Сумма                  	= СтрокаНМА.АмортизацияЗаМесяцБУ;
			НоваяСтрока.СуммаНУ                	= СтрокаНМА.АмортизацияЗаМесяцНУ;
			НоваяСтрока.ОбъектУчета            	= СтрокаНМА.НематериальныйАктив;
			НоваяСтрока.НаправлениеАмортизации 	= СтрокаНМА.НаправлениеБУ;
			НоваяСтрока.СчетАмортизации        	= СтрокаНМА.СчетНачисленияАмортизацииБУ;
			НоваяСтрока.НалоговоеНазначение 	= СтрокаНМА.НалоговоеНазначение_НМА;
			
			ТекМестонахождение 					= ТаблицаМестонахождений.Найти(СтрокаНМА.НематериальныйАктив,"НМА_БУ");
			НоваяСтрока.Местонахождение 		= ?(ТекМестонахождение = Неопределено, Неопределено, ТекМестонахождение.Местонахождение_БУ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Вызов процедуры списания амортизации по направлениям.
	// Создаются движения по начислению амортизации.
	УправлениеНеоборотнымиАктивами.ПолучитьРаспределениеАмортизацииПоНаправлениямРегл(ПроводкиБУ,
	                                                   Отказ,
													   Заголовок,
													   ТабАмортизации,
													   СтруктураШапкиДокумента,
													   НомерЖурнала,
													   НСтр("ru='Начисление амортизации НМА';uk='Нарахування амортизації НМА'",Локализация.КодЯзыкаИнформационнойБазы()));

													   
	НеОблНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
	
	// Создание движений документа по БУ
	Для Каждого СтрокаТЧ Из ТаблицаПоНМА Цикл

		ТекНМА = СтрокаТЧ.НематериальныйАктив;
		
		НепроизводственноеНМА = (СтрокаТЧ.НалоговоеНазначение_НМА = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность);
		
		// Движения по регистру СостоянияНМАОрганизаций
		Движение = СостояниеНМА.Добавить();
		Движение.Период               = ДатаДока;
		Движение.НематериальныйАктив  = ТекНМА;
		Движение.Организация          = ТекОрганизация;
		Движение.Состояние            = Перечисления.ВидыСостоянийНМА.Списан;
		
		// списание амортизации Д СчетНачисленияАмортизацииБУ К СчетУчетаНМА
		СуммаПроводки 	= СтрокаТЧ.АмортизацияБУ + СтрокаТЧ.АмортизацияЗаМесяцБУ;
		СуммаПроводкиНУ = СтрокаТЧ.АмортизацияНУ + СтрокаТЧ.АмортизацияЗаМесяцНУ;
		
		Если СуммаПроводки <> 0 ИЛИ СуммаПроводкиНУ <> 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период       = ДатаДока;
			Проводка.Активность   = Истина;
			Проводка.Организация  = ТекОрганизация;
			Проводка.Содержание   = НСтр("ru='Списана амортизация';uk='Списано амортизацію'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала = НомерЖурнала;
			Проводка.Сумма        = СуммаПроводки;
			
			Проводка.НалоговоеНазначениеДт = СтрокаТЧ.НалоговоеНазначение_НМА;
			Проводка.СуммаНУДт = СуммаПроводкиНУ;
			
			Проводка.СчетДт = СтрокаТЧ.СчетНачисленияАмортизацииБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "НематериальныеАктивы", ТекНМА);
			
			Проводка.СчетКт = СтрокаТЧ.СчетУчетаБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НематериальныеАктивы", ТекНМА);
			
			Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
			Проводка.СуммаНУКт = СуммаПроводкиНУ;
			
			Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
				// организация - не плательщик НДС. 
				Если НепроизводственноеНМА Тогда
					// Непроизводственное
					Проводка.НалоговоеНазначениеДт = СтрокаТЧ.НалоговоеНазначение_НМА;
					Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
				Иначе	
					Проводка.НалоговоеНазначениеДт = НеОблНДСДеятельность;
					Проводка.НалоговоеНазначениеКт = НеОблНДСДеятельность;
				КонецЕсли;	
			КонецЕсли;	
			
		КонецЕсли;
			
		// списание остаточной стоимости Д СчетСписанияБУ К СчетУчетаНМА
		СуммаПроводки = СтрокаТЧ.СтоимостьБУ - СтрокаТЧ.АмортизацияБУ - СтрокаТЧ.АмортизацияЗаМесяцБУ;
		СуммаПроводкиНУ = СтрокаТЧ.СтоимостьНУ - СтрокаТЧ.АмортизацияНУ - СтрокаТЧ.АмортизацияЗаМесяцНУ;
		
		Если СуммаПроводки <> 0 ИЛИ СуммаПроводкиНУ <> 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период       = ДатаДока;
			Проводка.Организация  = ТекОрганизация;
			Проводка.Содержание   = НСтр("ru='Списана ост. стоимость';uk='Списана зал. вартість'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала = НомерЖурнала;
			Проводка.Сумма        = СуммаПроводки;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
				
				Проводка.НалоговоеНазначениеДт = НалоговоеНазначениеДоходовИЗатрат;
				Если НалоговоеНазначениеДоходовИЗатрат <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность Тогда
					Проводка.СуммаНУДт = СуммаПроводкиНУ;
				КонецЕсли;
				
			КонецЕсли;
			
			Проводка.СчетДт = СтруктураШапкиДокумента.СчетСписанияБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтруктураШапкиДокумента.СубконтоБУ1);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтруктураШапкиДокумента.СубконтоБУ2);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтруктураШапкиДокумента.СубконтоБУ3);
			
			Проводка.СчетКт = СтрокаТЧ.СчетУчетаБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НематериальныеАктивы", ТекНМА);
			
			Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
			Проводка.СуммаНУКт = СуммаПроводкиНУ;
			
			Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
				// организация - не плательщик НДС. 
				Если НепроизводственноеНМА Тогда
					// Непроизводственное
					Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
				Иначе	
					Проводка.НалоговоеНазначениеКт = НеОблНДСДеятельность;
				КонецЕсли;	
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;
	
	УправлениеНеоборотнымиАктивами.ПроверкаДублированияЗаписейСостоянийНМА(СтруктураШапкиДокумента.Организация, ДатаДока, Движения.СостоянияНМАОрганизаций, Отказ, Заголовок);

КонецПроцедуры

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоНМА, Отказ, Заголовок) Экспорт
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НематериальныйАктив", "НематериальныйАктив");
	
	СтруктураПолей.Вставить("СтоимостьБУ",          "СтоимостьБУ");
	СтруктураПолей.Вставить("АмортизацияБУ",        "АмортизацияБУ");
	СтруктураПолей.Вставить("АмортизацияЗаМесяцБУ", "АмортизацияЗаМесяцБУ");
	
	СтруктураПолей.Вставить("СтоимостьНУ",          "СтоимостьНУ");
	СтруктураПолей.Вставить("АмортизацияЗаМесяцНУ", "АмортизацияЗаМесяцНУ");
	СтруктураПолей.Вставить("АмортизацияНУ",        "АмортизацияНУ");

	РезультатЗапросаПоНМА = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "НМА", СтруктураПолей);
	ТаблицаПоНМА          = РезультатЗапросаПоНМА.Выгрузить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)

	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоНМА;
	
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
	// Получим данные учетной политики
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоНМА, Отказ, Заголовок);
	
	//проверка, нет ли списанных НМА в табличной части
	УправлениеНеоборотнымиАктивами.ПроверитьНаСписанностьНМА(МоментВремени(), Организация, ТаблицаПоНМА, Отказ, Заголовок);
	
	// Подготовим таблицу местонахождения для ТабАмортизации
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТекОрганизация",  Организация);
	Запрос.УстановитьПараметр("ТекПериод",       Дата);
	Запрос.УстановитьПараметр("ВнешнийИсточник", ТаблицаПоНМА);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
   	|	НематериальныйАктив
	|ПОМЕСТИТЬ НематериальныеАктивы
	|ИЗ &ВнешнийИсточник КАК ВнешнийИсточник
	|";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НематериальныеАктивы.НематериальныйАктив 								КАК НематериальныйАктив,
	|	МестонахождениеНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив 	КАК НМА_БУ,
	|	МестонахождениеНМАБухгалтерскийУчетСрезПоследних.Местонахождение 		КАК Местонахождение_БУ
	|ИЗ
	|	НематериальныеАктивы
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеНМАБухгалтерскийУчет.СрезПоследних(&ТекПериод, НематериальныйАктив В (ВЫБРАТЬ НематериальныйАктив ИЗ НематериальныеАктивы) И Организация = &ТекОрганизация) КАК МестонахождениеНМАБухгалтерскийУчетСрезПоследних
	|	ПО НематериальныеАктивы.НематериальныйАктив = МестонахождениеНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив";
	ТаблицаМестонахождений = Запрос.Выполнить().Выгрузить();
	
	Если НЕ Отказ Тогда
		
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоНМА, ТаблицаМестонахождений, Отказ, Заголовок);
		
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПлательщикНалогаНаПрибыльДо2015  = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	КоличествоСубконто = СчетСписанияБУ.ВидыСубконто.Количество();
	
	Для Н = 1 По КоличествоСубконто Цикл
	
		ПроверяемыеРеквизиты.Добавить("СубконтоБУ" + Н);
	
	КонецЦикла;
	
	Если НЕ ПлательщикНалогаНаПрибыльДо2015 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалоговоеНазначениеДоходовИЗатрат");
	КонецЕсли;		
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "НМА", Новый Структура("НематериальныйАктив"), Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецЕсли
