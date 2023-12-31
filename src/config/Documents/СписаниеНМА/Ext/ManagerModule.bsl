﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	
	// Форма ОЗ-3
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "НА3";
	КомандаПечати.Представление = НСтр("ru='Форма НА-3';uk='Форма НА-3'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Списание НМА""';uk='Реєстр документів ""Списання НМА""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Функция формирует табличный документ с типовой печатной формой НА-3
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНА3(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент   = Новый ТабличныйДокумент();
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеНМА_НА3";
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_НА3");
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
	
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ДатаДок",     Ссылка.Дата);
		Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
		Запрос.УстановитьПараметр("СписокНМА",   Ссылка.НМА.ВыгрузитьКолонку("НематериальныйАктив"));                    
		Запрос.УстановитьПараметр("Ссылка",      Ссылка);
		Запрос.УстановитьПараметр("Руководитель", Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
		Запрос.УстановитьПараметр("Бухгалтер"   , Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СписаниеНМА.Ссылка.Организация                          КАК Организация,
		|	СписаниеНМА.Ссылка.Организация.НаименованиеПолное       КАК НаименованиеПолноеОрганизации,
		|	СписаниеНМА.Ссылка.Организация.КодПоЕДРПОУ              КАК КодПоЕДРПОУ,
		|	Руководитель.ФизическоеЛицо                             КАК ФИОРук,
		|	Бухгалтер.ФизическоеЛицо                                КАК ФИОБух,
		|	СписаниеНМА.Ссылка.Дата                                 КАК ДатаДок,
		|	СписаниеНМА.Ссылка.Номер                                КАК НомерДок,
		|	СписаниеНМА.НематериальныйАктив.НаименованиеПолное      КАК НаименованиеПолное,
		|	СписаниеНМА.НематериальныйАктив.Код                     КАК ИнвентарныйНомер,     
		|	СписаниеНМА.НематериальныйАктив.ПрочиеСведения          КАК ПрочиеСведения,                 
		|	СписаниеНМА.Ссылка.СчетСписанияБУ                       КАК СчетСписанияБУ,
		|	СписаниеНМА.СтоимостьБУ                                 КАК ПервоначальнаяСтоимость,
		|	СписаниеНМА.СтоимостьБУ - СписаниеНМА.АмортизацияБУ 
		|		- СписаниеНМА.АмортизацияЗаМесяцБУ                  КАК ОстаточнаяСтоимость,
		|	ПервоначальныеСведенияНМА_БУ.СрокПолезногоИспользования КАК СрокИспользования,                          
		|	ПервоначальныеСведенияНМА_БУ.ЛиквидационнаяСтоимость    КАК ЛиквидационнаяСтоимость,
		|	СчетаУчетаНМА_БУ.СчетУчета                              КАК СчетУчетаБУ,
		|	МестонахождениеНМАБухгалтерскийУчетСрезПоследних.МОЛ
		|ИЗ
		|	Документ.СписаниеНМА.НМА КАК СписаниеНМА
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(&ДатаДок,
		|			Организация = &Организация
		|		    И НематериальныйАктив В (&СписокНМА)) КАК ПервоначальныеСведенияНМА_БУ
		|		ПО СписаниеНМА.Ссылка.Организация = ПервоначальныеСведенияНМА_БУ.Организация
		|			И СписаниеНМА.НематериальныйАктив = ПервоначальныеСведенияНМА_БУ.НематериальныйАктив
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(&ДатаДок,
		|			Организация = &Организация
		|		    И НематериальныйАктив В (&СписокНМА)) КАК СчетаУчетаНМА_БУ
		|		ПО СписаниеНМА.Ссылка.Организация = СчетаУчетаНМА_БУ.Организация
		|			И СписаниеНМА.НематериальныйАктив = СчетаУчетаНМА_БУ.НематериальныйАктив
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
		|		                    &ДатаДок,
		|		                    СтруктурнаяЕдиница = &Организация
		|			                И ОтветственноеЛицо = &Бухгалтер) КАК Бухгалтер
		|		ПО СписаниеНМА.Ссылка.Организация = Бухгалтер.СтруктурнаяЕдиница
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
		|		                    &ДатаДок,
		|		                    СтруктурнаяЕдиница = &Организация
		|			                И ОтветственноеЛицо = &Руководитель) КАК Руководитель
		|		ПО СписаниеНМА.Ссылка.Организация = Руководитель.СтруктурнаяЕдиница
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеНМАБухгалтерскийУчет.СрезПоследних(
		|				&ДатаДок,
		|				Организация = &Организация
		|					И НематериальныйАктив В (&СписокНМА)) КАК МестонахождениеНМАБухгалтерскийУчетСрезПоследних
		|		ПО СписаниеНМА.Ссылка.Организация = МестонахождениеНМАБухгалтерскийУчетСрезПоследних.Организация
		|			И СписаниеНМА.НематериальныйАктив = МестонахождениеНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив
		|ГДЕ
		|	СписаниеНМА.Ссылка = &Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		
		НеПервый      = Ложь;
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);

		Пока Выборка.Следующий() Цикл
		
			ОбластьМакета = Макет.ПолучитьОбласть("НА3");
			Параметры     = ОбластьМакета.Параметры;
			Параметры.Заполнить(Выборка);
			Параметры.Заполнить(ВыборкаПоКомиссии);
			
			
			Параметры.КодПоЕДРПОУ = Выборка.КодПоЕДРПОУ;
			Параметры.ФИОРук      = ФизическиеЛицаБП.ФамилияИнициалыФизЛица(Выборка.ФИОРук);
			Параметры.ФИОБух      = ФизическиеЛицаБП.ФамилияИнициалыФизЛица(Выборка.ФИОБух);
			
			ДанныеМОЛ = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(
										Ссылка.Организация, 
										Выборка.МОЛ, 
										Ссылка.Дата, 
										Истина // ФИОКратко 
									 );
			Параметры.МОЛДолжность	= ДанныеМОЛ.Должность;
			Параметры.МОЛФИО 		= ДанныеМОЛ.Представление;
			
			Если НеПервый Тогда
				
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
			Иначе
				
				НеПервый = Истина;
				
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакета);
		
		КонецЦикла;	
		
		ТабДокумент.ОбластьПечати = ТабДокумент.Область( , 2, , ТабДокумент.ШиринаТаблицы);

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции // ПечатьНА3()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НА3") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "НА3",
			НСтр("ru='Форма НА-3';uk='Форма НА-3'"), ПечатьНА3(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета),, ИмяМакета);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "СубконтоБУ1");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли