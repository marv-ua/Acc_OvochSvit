﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСчетаУчетаРасчетов(Объект, СчетаУчета = Неопределено) Экспорт
	
	Если СчетаУчета = Неопределено Тогда
		СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
			Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента);
	КонецЕсли;
	
	
	Если Объект.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателяПриБартере;
		Объект.СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансовПокупателяПриБартере;
		
	Иначе
		
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателя;
		Объект.СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансовПокупателя;
		
	КонецЕсли;
	
	Объект.СчетУчетаНДС 				 	= СчетаУчета.СчетУчетаНДСПродаж;
	Объект.СчетУчетаНДСПодтвержденный  	 	= СчетаУчета.СчетУчетаНДСПродажПодтвержденный;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Форма ОЗ-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОЗ1";
	КомандаПечати.Представление = НСтр("ru='Форма ОЗ-1';uk='Форма ОЗ-1'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Расходная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru='Расходная накладная';uk='Видаткова накладна'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Передача ОС""';uk='Реєстр документів ""Передача ОЗ""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Функция формирует табличный документ с типовой печатной формой ОЗ-1
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьОЗ1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
	УстановитьПривилегированныйРежим(Истина);
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ТабДокумент   = Новый ТабличныйДокумент();
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПередачаОС_ОЗ1";
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_ОЗ1");
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка"     , Ссылка);
		Запрос.УстановитьПараметр("ТекДата"    , Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПередачаОС.Дата                                КАК ДатаАкта,
		|	ПередачаОС.Номер                               КАК НомерАкта,
		|	ВЫРАЗИТЬ(ПередачаОС.Контрагент.НаименованиеПолное
		|	                    КАК СТРОКА(1000))          КАК ПринялоПодразделение,
		|	ВЫРАЗИТЬ(ПередачаОС.Организация.НаименованиеПолное
		|	                    КАК СТРОКА(1000))          КАК Организация,
		|	ПередачаОС.Организация.КодПоЕДРПОУ                    КАК ЕДРПОУ
		|ИЗ
		|	Документ.ПередачаОС КАК ПередачаОС
		|ГДЕ
		|	ПередачаОС.Ссылка = &Ссылка";
		ВыборкаПоШапке = Запрос.Выполнить().Выбрать();
		ВыборкаПоШапке.Следующий();

		СписокОС = Ссылка.ОС.ВыгрузитьКолонку("ОсновноеСредство");
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка"                , Ссылка);
		Запрос.УстановитьПараметр("СписокОС"              , СписокОС);
		Запрос.УстановитьПараметр("ТекДата"               , Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("СостояниеПринятоКУчету", Перечисления.СостоянияОС.ВведеноВЭксплуатацию);
		Запрос.УстановитьПараметр("Организация"           , Ссылка.Организация);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПервоначальныеСведения.ИнвентарныйНомер        КАК ИнвентарныйНомер,
		|	ПервоначальныеСведения.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
		|	ПередачаОС.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОС,
		|	ПередачаОС.ОсновноеСредство.ЗаводскойНомер     КАК ЗаводскойНомер,
		|	ПередачаОС.ОсновноеСредство.ДатаВыпуска        КАК ГодВыпуска,
		|	ПередачаОС.ОсновноеСредство.НомерПаспорта      КАК НомерПаспорта,
		|	МестонахождениеОС.Местонахождение              КАК СдалоПодразделение,
		|	МестонахождениеОС.МОЛ.Код                      КАК КодМОЛа,
		|	ПринятКУчету.ДатаСостояния                     КАК ДатаВвода,
		|	ПередачаОС.СхемаРеализации.СчетСебестоимости   КАК СчетДт,
		|	СчетаОС_БУ.СчетУчета                           КАК СчетКт
		|ИЗ
		|	Документ.ПередачаОС.ОС КАК ПередачаОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
		|		                    &ТекДата,
		|		                    ОсновноеСредство В (&СписокОС)
		|		                    И Организация = &Организация) КАК ПервоначальныеСведения
		|		ПО ПередачаОС.ОсновноеСредство = ПервоначальныеСведения.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
		|		                    &ТекДата,
		|		                    ОсновноеСредство В (&СписокОС)
		|		                    И Организация = &Организация) КАК МестонахождениеОС
		|		ПО ПередачаОС.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			(ВЫБРАТЬ
		|				СостоянияОС.ОсновноеСредство КАК ОсновноеСредство,
		|				СостоянияОС.ДатаСостояния    КАК ДатаСостояния
		|			ИЗ
		|				РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОС
		|			ГДЕ
		|				СостоянияОС.Состояние = &СостояниеПринятоКУчету
		|				И СостоянияОС.ОсновноеСредство В(&СписокОС)
		|				И СостоянияОС.Организация = &Организация) КАК ПринятКУчету
		|		ПО ПередачаОС.ОсновноеСредство = ПринятКУчету.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
		|		                    &ТекДата,
		|		                    ОсновноеСредство В (&СписокОС)
		|		                    И Организация = &Организация) КАК СчетаОС_БУ
		|		ПО ПередачаОС.ОсновноеСредство = СчетаОС_БУ.ОсновноеСредство
		|ГДЕ
		|	ПередачаОС.Ссылка = &Ссылка";
		Результат = Запрос.Выполнить();
		ВыборкаПоОС = Результат.Выбрать();
		
		СписокПодразделений = Результат.Выгрузить().ВыгрузитьКолонку("СдалоПодразделение");
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);

		Пока ВыборкаПоОС.Следующий() Цикл

			ОбластьМакета = Макет.ПолучитьОбласть("ОЗ1");
			Параметры     = ОбластьМакета.Параметры;
			Параметры.Заполнить(ВыборкаПоШапке);
			
		
			Параметры.ПринялоПодразделение = СокрП(ВыборкаПоШапке.ПринялоПодразделение);
			Параметры.Заполнить(ВыборкаПоОС);
			Параметры.ВидОперации = "Вибуття";
			Параметры.Организация = СокрП(ВыборкаПоШапке.Организация);
			Параметры.Валюта      = ВалютаРегламентированногоУчета;
			Параметры.Заполнить(ВыборкаПоКомиссии);
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
		КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции // ПечатьОЗ1()

// Функция формирует табличный документ с печатной формой накладной,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьНакладной(МассивОбъектов, ОбъектыПечати, ПараметрыВывода, ИмяМакета)
	УстановитьПривилегированныйРежим(Истина);

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеализацияТоваровУслуг_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПередачаОС.ПФ_MXL_Накладная");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Номер,
		|	Дата,
		|	ДоговорКонтрагента,
		|	ДоговорКонтрагента.Дата  		КАК ДоговорДата,
		|	ДоговорКонтрагента.Номер 		КАК ДоговорНомер,
		|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,
		|	ДоговорКонтрагента.ВидДоговора  КАК ВидДоговораКонтрагента,
	//	|	Ответственный.ФизЛицо.Наименование КАК Отпустил,
		|	ПредставительОрганизации КАК ПредставительПоставщика,
		|	ВЫРАЗИТЬ(МестоСоставленияДокумента КАК СТРОКА(1000)) КАК МестоСоставленияДокумента,
		|	Организация,
		|	ДоверенностьСерия,
		|	ДоверенностьНомер,
		|	ДоверенностьДата,
		|	Получил,
		|	ПолучилПоДругомуДокументу,
		|	ДокументПодтверждающийПолномочия, 
		|	АдресДоставки,
		|	Контрагент  КАК Покупатель,
		|	Организация КАК Поставщик,
		|	Сделка,
		|//	Склад,
		|	СуммаДокумента,
		|	ВалютаДокумента,
		|	СуммаВключаетНДС
		|ИЗ
		|	Документ.ПередачаОС КАК ПередачаОС
		|
		|ГДЕ
		|	ПередачаОС.Ссылка = &ТекущийДокумент";
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Номенклатура,
		|	Номенклатура.НаименованиеПолное КАК Товар,
		|	Номенклатура.Код КАК Код,
		|	Сумма,
		|	СуммаНДС,
		|   НомерСтроки
		|ИЗ 
		|	(ВЫБРАТЬ
		|		ОсновноеСредство     КАК Номенклатура,
		|		СтавкаНДС            КАК СтавкаНДС,
		|		СУММА(Сумма)         КАК Сумма,
		|		СУММА(СуммаНДС)      КАК СуммаНДС,
		|		МИНИМУМ(НомерСтроки) КАК НомерСтроки
		|	ИЗ
		|		Документ.ПередачаОС.ОС КАК ПередачаОС
		|	ГДЕ
		|		ПередачаОС.Ссылка = &ТекущийДокумент
		|	СГРУППИРОВАТЬ ПО
		|		ОсновноеСредство,
		|		Сумма,
		|		СтавкаНДС
		|	) КАК ВложенныйЗапросПоТоварам
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		ЗапросТовары = Запрос.Выполнить().Выгрузить();

		УчитыватьНДС = УчетнаяПолитика.ПлательщикНДС(Шапка.Организация, Шапка.Дата);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		Если Шапка.ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером  Тогда
			ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Расходная накладная (на комиссию)';uk='Видаткова накладна (на комісію)'",КодЯзыкаПечать),КодЯзыкаПечать);
		Иначе	
			ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Расходная накладная';uk='Видаткова накладна'",КодЯзыкаПечать),КодЯзыкаПечать);
		КонецЕсли; 

		ТабДокумент.Вывести(ОбластьМакета);

		СведенияОПокупателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
		ОбластьМакета.Параметры.РеквизитыПоставщика =     ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "НомерСчета,Банк,МФО,/,ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
	    ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(Шапка);
	 	ОбластьМакета.Параметры.ПредставлениеПокупателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РеквизитыПокупателя		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе,"ФактическийАдрес,Телефоны,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим дополнительно информацию о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,Сделка,Склад,АдресДоставки,";
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
	    Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";

		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Суффикс = "";
		Если УчитыватьНДС Тогда
			Если Ссылка.СуммаВключаетНДС Тогда
				Суффикс  = Суффикс  + НСтр("ru=' с ';uk=' з '",КодЯзыкаПечать);
			Иначе	
				Суффикс  = Суффикс  + НСтр("ru=' без ';uk=' без '",КодЯзыкаПечать);
			КонецЕсли;
			Суффикс = Суффикс  + НСтр("ru='НДС';uk='ПДВ'",КодЯзыкаПечать);
		КонецЕсли;
		ОбластьМакета.Параметры.Цена  = НСтр("ru='Цена';uk='Ціна'",КодЯзыкаПечать) + Суффикс;
		ОбластьМакета.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		
		Сумма    = 0;
		СуммаНДС = 0;
		
		Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Сообщить(НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.';uk='В одному з рядків не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
				Продолжить;
			КонецЕсли;

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.Товар 		= СокрЛП(ВыборкаСтрокТовары.Товар);
			ОбластьМакета.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
			ОбластьМакета.Параметры.Цена	 = ВыборкаСтрокТовары.Сумма;		
			ОбластьМакета.Параметры.Количество	 = 1;		
			ОбластьМакета.Параметры.ЕдиницаИзмерения	 = НСтр("ru='шт';uk='шт'");		
			ТабДокумент.Вывести(ОбластьМакета);

			Сумма          = Сумма       + ВыборкаСтрокТовары.Сумма;
			СуммаНДС       = СуммаНДС    + ВыборкаСтрокТовары.СуммаНДС;

		КонецЦикла;

		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма);
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести ИтогоНДС
		Если УчитыватьНДС Тогда
			// НДС
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
			ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаНДС,,"""");
			ОбластьМакета.Параметры.НДС      = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
			ТабДокумент.Вывести(ОбластьМакета);
			
			// всего с НДС (если сумма не включает НДС)
			Если НЕ Шапка.СуммаВключаетНДС Тогда
				ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
				ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма + СуммаНДС);
				ОбластьМакета.Параметры.НДС      = НСтр("ru='Всего с НДС:';uk='Всього із ПДВ:'",КодЯзыкаПечать);
				ТабДокумент.Вывести(ОбластьМакета);
			КонецЕсли;
		КонецЕсли;

		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
		ОбластьМакета.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований ';uk='Всього найменувань '",КодЯзыкаПечать) + ЗапросТовары.Количество() + "," +
												 НСтр("ru=' на сумму ';uk=' на суму '",КодЯзыкаПечать)  + ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента);
												 
		ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента,КодЯзыкаПечать)
		 										 + ?(НЕ УчитыватьНДС, "", Символы.ПС + НСтр("ru='В т.ч. НДС: ';uk='У т.ч. ПДВ: '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаНДС, Шапка.ВалютаДокумента, КодЯзыкаПечать));

		ТабДокумент.Вывести(ОбластьМакета);

		Если ЗначениеЗаполнено(Шапка.МестоСоставленияДокумента) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("МестоСоставления");
			ОбластьМакета.Параметры.МестоСоставления = СокрЛП(Шапка.МестоСоставленияДокумента);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли; 

		// Вывести подписи
		ДанныеПредставителя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Шапка.Организация,Шапка.ПредставительПоставщика, Шапка.Дата);
		ДолжностьПредставителя = СокрЛП(ДанныеПредставителя.Должность);
		
		ДолжностьФИОПредставителя = ?(ЗначениеЗаполнено(ДолжностьПредставителя),ДолжностьПредставителя + " ","") + 
									?(ДанныеПредставителя.Фамилия = Неопределено,"",ДанныеПредставителя.Фамилия + " ") + 
									?(ДанныеПредставителя.Имя = Неопределено,"",ДанныеПредставителя.Имя + " ") +
									?(ДанныеПредставителя.Отчество = Неопределено,"",ДанныеПредставителя.Отчество);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Ответственный = ДолжностьФИОПредставителя;
		ТабДокумент.Вывести(ОбластьМакета);
		Если Шапка.ПолучилПоДругомуДокументу Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ПодписиПоДругомуДокументу");
		Иначе			
			ОбластьМакета = Макет.ПолучитьОбласть("ПодписиПоДоверенности");
		КонецЕсли; 
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
 
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
		КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции // ПечатьДокумента()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОЗ1") Тогда

		ИмяМакета = "";
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОЗ1", НСтр("ru='Форма ОЗ-1';uk='Форма ОЗ-1'"),
			ПечатьОЗ1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета), , ИмяМакета);

	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", НСтр("ru='Приходная накладная';uk='Прибуткова накладна'"), 
			ПечатьНакладной(МассивОбъектов, ОбъектыПечати, ПараметрыВывода, ИмяМакета),,"Документ.ПередачаОС.ПФ_MXL_Накладная", , Истина);
	КонецЕсли;
	
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли