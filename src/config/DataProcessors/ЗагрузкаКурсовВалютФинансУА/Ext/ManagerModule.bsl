﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Загружает курсы валют на текущую дату.
//
// Параметры:
//  ПараметрыЗагрузки - Структура - детали загрузки:
//   * НачалоПериода - Дата - начало периода загрузки;
//   * КонецПериода - Дата - конец периода загрузки;
//   * СписокВалют - ТаблицаЗначений - загружаемые валюты:
//     ** Валюта - СправочникСсылка.Валюты;
//     ** КодВалюты - Строка.
//  АдресРезультата - Строка - адрес во временном хранилище для помещения результатов загрузки.
//
Процедура ЗагрузитьАктуальныйКурс(ПараметрыЗагрузки = Неопределено, АдресРезультата = Неопределено) Экспорт
	
	ИмяСобытия = ИмяСобытияЖурналаРегистрации();
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru='Начата регламентная загрузка курсов валют';uk='розпочато регламентне завантаження курсів валют'"));
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	СостояниеЗагрузки = Неопределено;
	ПриЗагрузкеВозниклиОшибки = Ложь;
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КурсыВалют.Валюта КАК Валюта,
		|	КурсыВалют.Валюта.Код КАК КодВалюты,
		|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
		|ИЗ
		|	РегистрСведений.КурсыВалют КАК КурсыВалют
		|ГДЕ
		|	КурсыВалют.Валюта.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
		|	И НЕ КурсыВалют.Валюта.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	КурсыВалют.Валюта,
		|	КурсыВалют.Валюта.Код";
		Запрос = Новый Запрос(ТекстЗапроса);
		Выборка = Запрос.Выполнить().Выбрать();
		
		КонецПериода = ТекущаяДата;
		Пока Выборка.Следующий() Цикл
			НачалоПериода = ?(Выборка.ДатаКурса = '198001010000', НачалоГода(ДобавитьМесяц(ТекущаяДата, -12)), Выборка.ДатаКурса + 60*60*24);
			СписокВалют = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка);
			ЗагрузитьКурсыВалютПоПараметрам(СписокВалют, НачалоПериода, КонецПериода,,,, ПриЗагрузкеВозниклиОшибки);
		КонецЦикла;
	Иначе
		Результат = ЗагрузитьКурсыВалютПоПараметрам(
			ПараметрыЗагрузки.СписокВалют,
			ПараметрыЗагрузки.НачалоПериода, 
			ПараметрыЗагрузки.КонецПериода, 
			ПараметрыЗагрузки.ИсточникДанных, 
			ПараметрыЗагрузки.КодДоступа, 
			ПараметрыЗагрузки.БукваДиска, 
			ПриЗагрузкеВозниклиОшибки);
	КонецЕсли;
		
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;

	Если ПриЗагрузкеВозниклиОшибки Тогда
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			, 
			,
			НСтр("ru='Во время регламентного задания загрузки курсов валют возникли ошибки';uk='Під час регламентного завдання завантаження курсів валют виникли помилки'"));
		ВызватьИсключение НСтр("ru='Загрузка курсов не выполнена.';uk='Завантаження курсів не виконано.'");
	Иначе
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Информация,
			,
			,
			НСтр("ru='Завершена регламентная загрузка курсов валют.';uk='Завершено регламентне завантаження курсів валют.'"));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список разрешений для загрузки курсов валют с сайта finance.ua.
//
// Параметры:
//  Разрешения - Массив - коллекция разрешений.
//
Процедура ДобавитьРазрешения(Разрешения) Экспорт

	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Протокол = "HTTP";
	Адрес = "fin.1c.ua";
	Порт = Неопределено;
	Описание = НСтр("ru='Загрузка курсов валют из Интернета.';uk='Завантаження курсів валют з Інтернету.'");
	Разрешения.Добавить( 
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));

КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Зависимости) Экспорт
КонецПроцедуры

// Процедура для загрузки курсов валют по определенному периоду.
//
// Параметры:
// Валюты		- Любая коллекция - со следующими полями:
//					КодВалюты - числовой код валюты.
//					Валюта - ссылка на валюту.
// НачалоПериодаЗагрузки	- Дата - начало периода загрузки курсов.
// ОкончаниеПериодаЗагрузки	- Дата - окончание периода загрузки курсов.
//
// Возвращаемое значение:
// Массив состояния загрузки  - каждый элемент - структура с полями.
//		Валюта - загружаемая валюта.
//		СтатусОперации - завершилась ли загрузка успешно.
//		Сообщение - пояснение о загрузке (текст сообщения об ошибке или поясняющее сообщение).
//
Функция ЗагрузитьКурсыВалютПоПараметрам(Знач Валюты, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки, 
	Знач ИсточникДанных = Ложь,
	Знач КодДоступа = "",
	Знач БукваДиска = "",
	ПриЗагрузкеВозниклиОшибки = Ложь)
	
	СостояниеЗагрузки = Новый Массив;
	
	ПараметрыПолучения = Неопределено;
	ИмяФайлаДневногоКурса = Формат(ОкончаниеПериодаЗагрузки, "ДФ=/yyyy/MM/dd");

	СерверИсточник = "http://fin.1c.ua";
	СерверИсточникИТС = БукваДиска + ":\1CIts\EXE\Finance\";
	
	Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
		Адрес = "1c/";
		ТМП   = Формат(ОкончаниеПериодаЗагрузки, "ДФ=/yyyy/MM/dd"); // Не локализуется - путь к файлу на сервере 
	Иначе
		Адрес = "1c/cb/";
		ТМП   = ""; 
	КонецЕсли;
	
	Код = ?(КодДоступа <> Неопределено, "?" + КодДоступа, "");
	
	ШаблонИмениФайла = СерверИсточник + "/" + Адрес + "%1" + ТМП + ".tsv" + СокрЛП(Код);
	ШаблонИмениФайлаИТС = СерверИсточникИТС + "%1" + ".tsv";

	ВалютыЗагружаемыеИзИнтернета = ВалютыЗагружаемыеИзИнтернета();
	
	Для Каждого Валюта Из Валюты Цикл
		Если ВалютыЗагружаемыеИзИнтернета.Найти(Валюта.Валюта) = Неопределено Тогда
			ПриЗагрузкеВозниклиОшибки = Истина;
			СтатусОперации = Ложь;
			ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Невозможно получить файл данных с курсами валюты (%1 - %2):
                    |Курсы данной валюты не предоставляются.'
                    |;uk='Неможливо отримати файл даних з курсами валюти (%1 - %2):
                    |Курси даної валюти не надаються.'"),
				Валюта.КодВалюты,
				Валюта.Валюта);
				
			ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , , ПоясняющееСообщение);
		Иначе
			ФайлНаВебСервере = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла, Валюта.КодВалюты);
			ФайлНаДискеИТС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайлаИТС, Валюта.КодВалюты);
			
			Если НЕ ИсточникДанных Тогда // Интернет
				Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере);	
			Иначе // ИТС
				ВходящийФайл = Новый Файл(ФайлНаДискеИТС);
				Статус = ВходящийФайл.Существует();
				
				Результат = Новый Структура("Статус, Путь", Статус, ФайлНаДискеИТС);
				
				Если НЕ Статус Тогда
					Результат.Вставить("СообщениеОбОшибке", ФайлНаДискеИТС);
				КонецЕсли;	
			КонецЕсли;
			
			Если Результат.Статус Тогда
				ПоясняющееСообщение = ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
				Если НЕ ИсточникДанных Тогда // Интернет
					УдалитьФайлы(Результат.Путь);
				КонецЕсли;
				СтатусОперации = ПустаяСтрока(ПоясняющееСообщение);
			Иначе
				ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Невозможно получить файл данных с курсами валюты (%1 - %2):
                        |%3
                        |Возможно, нет доступа к веб сайту с курсами валют, либо указана несуществующая валюта.'
                        |;uk='Неможливо отримати файл даних з курсами валюти (%1 - %2):
                        |%3
                        |Можливо, немає доступу до веб сайту з курсами валют, або вказана неіснуюча валюта.'"),
					Валюта.КодВалюты,
					Валюта.Валюта,
					Результат.СообщениеОбОшибке);
				СтатусОперации = Ложь;
				ПриЗагрузкеВозниклиОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
		СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, СтатусОперации, ПоясняющееСообщение));
		
	КонецЦикла;
	
	Возврат СостояниеЗагрузки;
	
КонецФункции

// Загружает информацию о курсе валюты Валюта из файла ПутьКФайлу в регистр
// сведений курсов валют. При этом файл с курсами разбирается, и записываются
// только те данные, которые удовлетворяют периоду (НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки).
//
Функция ЗагрузитьКурсВалютыИзФайла(Знач Валюта, Знач ПутьКФайлу, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки)
	
	СтатусЗагрузки = 1;
	
	ЧислоЗагружаемыхДнейВсего = 1 + (ОкончаниеПериодаЗагрузки - НачалоПериодаЗагрузки) / ( 24 * 60 * 60);
	
	ЧислоЗагруженныхДней = 0;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла();
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПутьКФайлу);
		ДвоичныеДанные.Записать(ИмяФайла);
	Иначе
		ИмяФайла = ПутьКФайлу;
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент();
	
	
	Текст.Прочитать(ИмяФайла, КодировкаТекста.ANSI);
	
	ДатаЗапрета = Неопределено;
	Для НомерСтроки = 1 По Текст.КоличествоСтрок() Цикл
		
		Стр = Текст.ПолучитьСтроку(НомерСтроки);
		Если (Стр = "") ИЛИ (СтрНайти(Стр, Символы.Таб) = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		ЧастиСтроки = СтрРазделить(Стр, Символы.Таб, Истина);
		
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ДатаКурса = ОкончаниеПериодаЗагрузки;
			// В случае ИТСа формат строки такой же как и за период (3 значения) - 20120428	100	798.9900
			Если ЧастиСтроки.Количество() = 3 Тогда
				Кратность = Число(ЧастиСтроки[1]);
				Курс = КурсИзСтроки(ЧастиСтроки[2]);
			Иначе
				Кратность = Число(ЧастиСтроки[0]);
				Курс = КурсИзСтроки(ЧастиСтроки[1]);
			КонецЕсли;
		Иначе
			ДатаКурсаСтр = ЧастиСтроки[0];
			ДатаКурса = Дата(Лев(ДатаКурсаСтр,4), Сред(ДатаКурсаСтр,5,2), Сред(ДатаКурсаСтр,7,2));
			Кратность = Число(ЧастиСтроки[1]);
			Курс = КурсИзСтроки(ЧастиСтроки[2]);
		КонецЕсли;
		
		Если ДатаКурса > ОкончаниеПериодаЗагрузки Тогда
			Прервать;
		КонецЕсли;
		
		Если ДатаКурса < НачалоПериодаЗагрузки Тогда 
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Валюта.Установить(Валюта);
		НаборЗаписей.Отбор.Период.Установить(ДатаКурса);
		Запись = НаборЗаписей.Добавить();
		Запись.Валюта = Валюта;
		Запись.Период = ДатаКурса;
		Запись.Курс = Курс;
		Запись.Кратность = Кратность;
		
		Записывать = Истина;
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
			МодульДатыЗапретаИзмененияСлужебный = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзмененияСлужебный");
			Если МодульДатыЗапретаИзмененияСлужебный.ЗапретИзмененияПроверяется(Метаданные.РегистрыСведений.КурсыВалют) Тогда
				МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
				Записывать = Не МодульДатыЗапретаИзменения.ИзменениеЗапрещено(НаборЗаписей);
				Если Не Записывать Тогда
					Если ДатаЗапрета = Неопределено Тогда
						ДатаЗапрета = ДатаКурса;
					Иначе
						ДатаЗапрета = Макс(ДатаЗапрета, ДатаКурса);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Записывать Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЧислоЗагруженныхДней = ЧислоЗагруженныхДней + 1;
	КонецЦикла;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		УдалитьФайлы(ИмяФайла);
		УдалитьИзВременногоХранилища(ПутьКФайлу);
	КонецЕсли;
	
	ПояснениеОЗагрузке = "";
	Если ЧислоЗагружаемыхДнейВсего <> ЧислоЗагруженныхДней Тогда
		Если ЧислоЗагруженныхДней = 0 Тогда
			ПояснениеОЗагрузке = НСтр("ru='Курсы валюты %1 (%2) не загружены.
                |Нет сведение о курсе за указанный период.'
                |;uk='Курси валют %1 (%2) не завантажені.
                |Немає відомостей про курс за зазначений період.'");
		Иначе
			ПояснениеОЗагрузке = НСтр("ru='Загружены не все курсы по валюте %1 (%2).';uk='Завантажені не всі курси по валюті %1 (%2).'");
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ПояснениеОЗагрузке) Тогда
		ПояснениеОЗагрузке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПояснениеОЗагрузке, Валюта.Наименование, Валюта.Код);
	КонецЕсли;
	
	Если ДатаЗапрета <> Неопределено Тогда
		ПояснениеОЗагрузке = ПояснениеОЗагрузке + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Загрузка курсов валюты %1(%2) ограничена датой запрета изменений %3.
            |Курсы запрещенного периода были пропущены при загрузке.'
            |;uk='Завантаження курсів валют %1(%2) обмежене датою заборони змін %3.
            |Курси забороненого періоду були пропущені при завантаженні.'"), Валюта.Наименование, Валюта.Код, Формат(ДатаЗапрета, "ДЛФ=D"));
	КонецЕсли;
	
	ПояснениеОЗагрузке = СокрЛП(ПояснениеОЗагрузке);
	
	СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
	СписокОшибок = Новый Массив;
	Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
		СписокОшибок.Добавить(СообщениеПользователю.Текст);
	КонецЦикла;
	СписокОшибок = ОбщегоНазначенияКлиентСервер.СвернутьМассив(СписокОшибок);
	ПояснениеОЗагрузке = ПояснениеОЗагрузке + ?(ПустаяСтрока(ПояснениеОЗагрузке), "", Символы.ПС) + СтрСоединить(СписокОшибок, Символы.ПС);
	
	Возврат ПояснениеОЗагрузке;
	
КонецФункции

// Предназначена для преобразования формата чисел, используемого в файле курсов валюты.
// Работает в любой локализации, не поддерживает отрицательные числа.
Функция КурсИзСтроки(Знач Строка)
	
	Строка = СокрЛП(Строка);
	ЧастиСтроки = СтрРазделить(Строка, ".", Истина);
	
	Если Строка = "" Или ЧастиСтроки.Количество() > 2 Тогда
		ВызватьИсключение НСтр("ru='Преобразование значения к типу Число не может быть выполнено.';uk='Перетворення значення до типу Число не може бути виконано.'");
	КонецЕсли;
	
	ДлинаДробнойЧасти = 0;
	Если ЧастиСтроки.Количество() > 1 Тогда
		ДлинаДробнойЧасти = СтрДлина(ЧастиСтроки[1]);
	КонецЕсли;
	
	Строка = СтрСоединить(ЧастиСтроки, "");
	Результат = 0;
	Если Строка <> "" Тогда
		Результат = Число(Строка) / Pow(10, ДлинаДробнойЧасти);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьПараметрыРегламентногоЗадания(ИзменяемыеПараметры)
КонецПроцедуры

Функция ВалютыЗагружаемыеИзИнтернета()
	КлассификаторXML = Справочники.Валюты.ПолучитьМакет("КлассификаторВалют").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	НайденныеСтроки = КлассификаторТаблица.НайтиСтроки(Новый Структура("FinanceLoading", "Истина"));
	ЗагружаемыеПоКлассификатору = КлассификаторТаблица.Скопировать(НайденныеСтроки, "Code").ВыгрузитьКолонку("Code");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	НЕ Валюты.ПометкаУдаления
	|	И Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
	|	И Валюты.Код В(&ЗагружаемыеПоКлассификатору)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЗагружаемыеПоКлассификатору", ЗагружаемыеПоКлассификатору);
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
КонецФункции

Функция ИмяСобытияЖурналаРегистрации()
	Возврат НСтр("ru='Валюты.Загрузка курсов валют';uk='Валюти.Завантаження курсів валют'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецФункции

#КонецОбласти

#КонецЕсли