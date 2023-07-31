﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСчетаУчетаРасчетов(Объект) Экспорт
	
	СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
		Объект.Организация,  Объект.Контрагент,  Объект.ДоговорКонтрагента);
	
	Если Объект.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом 	= СчетаУчета.СчетРасчетовПриБартере;
		Объект.СчетУчетаРасчетовПоАвансам     	= СчетаУчета.СчетАвансовПриБартере;
	Иначе
		Объект.СчетУчетаРасчетовСКонтрагентом 	= СчетаУчета.СчетРасчетов;
		Объект.СчетУчетаРасчетовПоАвансам 		= СчетаУчета.СчетАвансов;
	КонецЕсли;	
	
	Объект.СчетУчетаНДС 						= СчетаУчета.СчетУчетаНДСПриобретений;
	Объект.СчетУчетаНДСПодтвержденный  			= СчетаУчета.СчетУчетаНДСПриобретенийПодтвержденный;
	
КонецПроцедуры

Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(СтрокаТаблицы) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НематериальныйАктив) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы.СчетУчетаБУ = ПланыСчетов.Хозрасчетный.ПриобретениеНематериальныхАктивов;
	
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

	// Приходная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru='Приходная накладная';uk='Прибуткова накладна'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Поступление НМА""';uk='Реєстр документів ""Надходження НМА""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьПоступлениеТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыВывода, ИмяМакета)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПоступлениеНМА_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПоступлениеНМА.ПФ_MXL_Накладная");
	
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
		|	Ответственный.ФизическоеЛицо.Наименование КАК Получил,
		|	Организация,
		|	Контрагент  КАК Поставщик,
		|	Организация КАК Покупатель,
		|	Сделка,
		|	СуммаДокумента,
		|	ВалютаДокумента,
		|	СуммаВключаетНДС
		|ИЗ
		|	Документ.ПоступлениеНМА КАК ПоступлениеНМА
		|
		|ГДЕ
		|	ПоступлениеНМА.Ссылка = &ТекущийДокумент";
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("ПустаяЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
		
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
		|	ВложенныйЗапрос.Номенклатура,
		|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК Товар,
		|	ВложенныйЗапрос.Сумма,
		|	ВложенныйЗапрос.СуммаНДС
		|ИЗ
		|	(ВЫБРАТЬ
		|		МИНИМУМ(ПоступлениеНМА.НомерСтроки) КАК НомерСтроки,
		|		ПоступлениеНМА.НематериальныйАктив КАК Номенклатура,
		|		ПоступлениеНМА.СтавкаНДС КАК СтавкаНДС,
		|		СУММА(ПоступлениеНМА.Сумма) КАК Сумма,
		|		СУММА(ПоступлениеНМА.СуммаНДС) КАК СуммаНДС
		|	ИЗ
		|		Документ.ПоступлениеНМА.НМА КАК ПоступлениеНМА
		|	ГДЕ
		|		ПоступлениеНМА.Ссылка = &ТекущийДокумент
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ПоступлениеНМА.НематериальныйАктив,
		|		ПоступлениеНМА.СтавкаНДС) КАК ВложенныйЗапрос
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		ЗапросТовары = Запрос.Выполнить().Выгрузить();

		УчитыватьНДС = УчетнаяПолитика.ПлательщикНДС(Шапка.Организация, Шапка.Дата);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Поступление НМА';uk='Надходження НМА'",КодЯзыкаПечать),КодЯзыкаПечать);

		ТабДокумент.Вывести(ОбластьМакета);

		СведенияОПокупателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
		ОбластьМакета.Параметры.РеквизитыПоставщика =     ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "НомерСчета,Банк,МФО,/,ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,",,КодЯзыкаПечать);
	    ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(Шапка);
	 	ОбластьМакета.Параметры.ПредставлениеПокупателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РеквизитыПокупателя		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "НомерСчета,Банк,МФО,/,ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим дополнительно информацию о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,";
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
			Если Шапка.СуммаВключаетНДС Тогда
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

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.Товар 		= СокрЛП(ВыборкаСтрокТовары.Товар);
			ОбластьМакета.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
			
			ОбластьМакета.Параметры.Цена	 			= ВыборкаСтрокТовары.Сумма;		
			ОбластьМакета.Параметры.Количество	 		= 1;		
			ОбластьМакета.Параметры.ЕдиницаИзмерения 	= НСтр("ru='шт';uk='шт'");		
			
			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Сообщить(НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.';uk='В одному з рядків не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
				Продолжить;
			КонецЕсли;
			
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
												 НСтр("ru=' на сумму ';uk=' на суму '",КодЯзыкаПечать)  + ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента) + ".";
												 
		ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента,КодЯзыкаПечать)
		 										 + ?(НЕ УчитыватьНДС, "", Символы.ПС + НСтр("ru='В т.ч. НДС: ';uk='У т.ч. ПДВ: '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаНДС, Шапка.ВалютаДокумента, КодЯзыкаПечать));

		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	

	Возврат ТабДокумент;

КонецФункции // ПечатьПоступлениеТоваров()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", 
			НСтр("ru='Приходная накладная';uk='Прибуткова накладна'"), ПечатьПоступлениеТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыВывода, ИмяМакета),, ИмяМакета, , Истина);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация, НомерВходящегоДокумента, ДатаВходящегоДокумента",
		"Контрагент", "НомерВходящегоДокумента", "ДатаВходящегоДокумента");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли