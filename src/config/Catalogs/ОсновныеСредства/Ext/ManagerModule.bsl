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

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Инвентарная карточка ОС (ОЗ-6)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОЗ6";
	КомандаПечати.Представление = НСтр("ru='Инвентарная карточка ОС (ОЗ-6)';uk='Інвентарна картка ОЗ (ОЗ-6)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиКарточкиОС";
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой инвентарной карточки ОС (форма ОЗ-6)
// Возвращаемое значение:
// Табличный документ - печатная форма инвентарной карточки ОС
Функция ПечатьОЗ6(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ОсновныеСредства.ПФ_MXL_UK_ОЗ6");
	Шапка						= Макет.ПолучитьОбласть("Шапка");
	ШапкаМодернизацииИРемонта	= Макет.ПолучитьОбласть("ШапкаМодернизацииИРемонта");
	СтрокаМодернизацииИРемонта 	= Макет.ПолучитьОбласть("СтрокаМодернизацииИРемонта");
	Подвал						= Макет.ПолучитьОбласть("Подвал");

	ТабДок = Новый ТабличныйДокумент();
	Организация      = Неопределено;
	
	Если ПараметрыПечати.Свойство("ДатаСведений") Тогда
		ДатаСведений = ПараметрыПечати.ДатаСведений;
	Иначе
		ДатаСведений = ТекущаяДатаСеанса();
	КонецЕсли;
	
	cВидаУчета   = "Бухгалтерський";
	ВалютаПечати = Константы.ВалютаРегламентированногоУчета.Получить().Наименование;
	ВидУчета 	 = "Бух";
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ОсновноеСредство", Ссылка);
		Запрос.УстановитьПараметр("ДатаСведений"    , ДатаСведений);
		Запрос.УстановитьПараметр("СостояниеВвода"  , Перечисления.СостоянияОС.ВведеноВЭксплуатацию);
		Запрос.УстановитьПараметр("СостояниеВыбытия", Перечисления.СостоянияОС.СнятоСУчета);
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПервоначальныеСведенияОС.Организация                         КАК Организация,
		|	ПервоначальныеСведенияОС.Организация.НаименованиеПолное      КАК ОрганизацияНаименованиеПолное,
		|	ПервоначальныеСведенияОС.Организация.Наименование            КАК ОрганизацияНаименование,
		|	ПервоначальныеСведенияОС.ОсновноеСредство.НаименованиеПолное КАК НаименованиеПолное,
		|	ПервоначальныеСведенияОС.ОсновноеСредство.Наименование       КАК Наименование,
		|	ПервоначальныеСведенияОС.ОсновноеСредство.Модель             КАК Модель,
		|	ПервоначальныеСведенияОС.ИнвентарныйНомер                    КАК ИнвентарныйНомер,
		|	ПервоначальныеСведенияОС.ОсновноеСредство.ЗаводскойНомер     КАК ЗаводскойНомер,
		|	ПервоначальныеСведенияОС.ОсновноеСредство.Изготовитель       КАК ИзготовительОС,
		|	ПервоначальныеСведенияОС.ОсновноеСредство.НомерПаспорта      КАК НомерПаспорта,
		|	ПервоначальныеСведенияОС.ОсновноеСредство.ДатаВыпуска        КАК ДатаВыпуска,
		|	ПервоначальныеСведенияОС.ПервоначальнаяСтоимость             КАК ПервоначальнаяСтоимость,
		|	ВводВЭксплуатацию.ДатаСостояния                              КАК ДокументВводаВЭксплуатациюДата,
		|	ВводВЭксплуатацию.НомерДокумента                             КАК ДокументВводаВЭксплуатациюНомер,
		|	ПервоначальныеСведенияОС.Организация.КодПоЕДРПОУ             КАК ЕДРПОУ,
		|	ПРЕДСТАВЛЕНИЕ(ПеремещенияОС.Местонахождение)                 КАК Подразделение,
		|	ПРЕДСТАВЛЕНИЕ(ПеремещенияОС.СчетУчета)                       КАК СчетУчета,
		|	ПРЕДСТАВЛЕНИЕ(ПеремещенияОС.СчетНачисленияАмортизации)       КАК СчетАмортизации,
		|	ПеремещенияОС.ДатаВыбытия                                    КАК ДокументВыбытияДата,
		|	ПеремещенияОС.НомерДокумента                                 КАК ДокументВыбытияНомер,
		|	ПеремещенияОС.Период                                         КАК Период
		|ИЗ
		|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
		|	                &ДатаСведений, 
		|	                ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.СостоянияОСОрганизаций КАК ВводВЭксплуатацию
		|		ПО ПервоначальныеСведенияОС.ОсновноеСредство = ВводВЭксплуатацию.ОсновноеСредство
		|			И ПервоначальныеСведенияОС.Организация = ВводВЭксплуатацию.Организация
		|			И (ВводВЭксплуатацию.Состояние = &СостояниеВвода)
		|			И (ВводВЭксплуатацию.ДатаСостояния <= &ДатаСведений)
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			(ВЫБРАТЬ
		|				Перемещения.Организация КАК Организация,
		|				Перемещения.ОсновноеСредство КАК ОсновноеСредство,
		|				Перемещения.Местонахождение КАК Местонахождение,
		|				Перемещения.Период КАК Период,
		|				ЕСТЬNULL(Перемещения.ДатаВыбытия, СостоянияОС.ДатаСостояния) КАК ДатаВыбытия,
		|				ВЫБОР
		|					КОГДА Перемещения.ДатаВыбытия ЕСТЬ NULL 
		|						ТОГДА СостоянияОС.НомерДокумента
		|					ИНАЧЕ МестонахождениеОС.Регистратор.Номер
		|				КОНЕЦ КАК НомерДокумента,
		|				СчетаУчетаОС.СчетУчета КАК СчетУчета,
		|				СчетаУчетаОС.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации
		|			ИЗ
		|				(ВЫБРАТЬ
		|					МестонахождениеОС.Организация КАК Организация,
		|					МестонахождениеОС.ОсновноеСредство КАК ОсновноеСредство,
		|					МестонахождениеОС.Местонахождение КАК Местонахождение,
		|					МестонахождениеОС.Период КАК Период,
		|					МИНИМУМ(МестонахождениеОС1.Период) КАК ДатаВыбытия,
		|					МАКСИМУМ(СчетаУчетаОС.Период) КАК ДатаСчета
		|				ИЗ
		|					РегистрСведений.МестонахождениеОСБухгалтерскийУчет КАК МестонахождениеОС
		|						ЛЕВОЕ СОЕДИНЕНИЕ 
		|							РегистрСведений.МестонахождениеОСБухгалтерскийУчет КАК МестонахождениеОС1
		|						ПО МестонахождениеОС.Период < МестонахождениеОС1.Период
		|							И МестонахождениеОС.Организация = МестонахождениеОС1.Организация
		|							И МестонахождениеОС.ОсновноеСредство = МестонахождениеОС1.ОсновноеСредство
		|							И (МестонахождениеОС1.Период <= &ДатаСведений)
		|						ЛЕВОЕ СОЕДИНЕНИЕ 
		|							РегистрСведений.СчетаБухгалтерскогоУчетаОС КАК СчетаУчетаОС
		|						ПО МестонахождениеОС.ОсновноеСредство = СчетаУчетаОС.ОсновноеСредство
		|							И МестонахождениеОС.Организация = СчетаУчетаОС.Организация
		|							И МестонахождениеОС.Период >= СчетаУчетаОС.Период
		|							И (СчетаУчетаОС.Период <= &ДатаСведений)
		|				ГДЕ
		|					МестонахождениеОС.ОсновноеСредство = &ОсновноеСредство
		|					И МестонахождениеОС.Период <= &ДатаСведений
		|			
		|				СГРУППИРОВАТЬ ПО
		|					МестонахождениеОС.Местонахождение,
		|					МестонахождениеОС.Период,
		|					МестонахождениеОС.Организация,
		|					МестонахождениеОС.ОсновноеСредство) КАК Перемещения
		|				ЛЕВОЕ СОЕДИНЕНИЕ 
		|					РегистрСведений.МестонахождениеОСБухгалтерскийУчет КАК МестонахождениеОС
		|				ПО Перемещения.ДатаВыбытия = МестонахождениеОС.Период
		|					И Перемещения.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
		|					И Перемещения.Организация = МестонахождениеОС.Организация
		|				ЛЕВОЕ СОЕДИНЕНИЕ 
		|					РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОС
		|				ПО Перемещения.ОсновноеСредство = СостоянияОС.ОсновноеСредство
		|					И Перемещения.Организация = СостоянияОС.Организация
		|					И (Перемещения.ДатаВыбытия ЕСТЬ NULL )
		|					И (СостоянияОС.Состояние = &СостояниеВыбытия)
		|					И (СостоянияОС.ДатаСостояния <= &ДатаСведений)
		|				ЛЕВОЕ СОЕДИНЕНИЕ 
		|					РегистрСведений.СчетаБухгалтерскогоУчетаОС КАК СчетаУчетаОС
		|				ПО Перемещения.ОсновноеСредство = СчетаУчетаОС.ОсновноеСредство
		|					И Перемещения.Организация = СчетаУчетаОС.Организация
		|					И Перемещения.ДатаСчета = СчетаУчетаОС.Период) КАК ПеремещенияОС
		|		ПО ПервоначальныеСведенияОС.ОсновноеСредство = ПеремещенияОС.ОсновноеСредство
		|			И ПервоначальныеСведенияОС.Организация = ПеремещенияОС.Организация
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПеремещенияОС.Период";
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() тогда
			
			СведенияОбОС = Результат.Выбрать();
			ПерваяСтрока = Истина;
			
			Пока СведенияОбОС.Следующий() Цикл
			
				Если ПерваяСтрока Тогда
					
					Шапка.Параметры.Заполнить(СведенияОбОС);
					Шапка.Параметры.НаименованиеОС          = ? (НЕ ЗначениеЗаполнено(СведенияОбОС.НаименованиеПолное),
					СведенияОбОС.Наименование, СведенияОбОС.НаименованиеПолное);
					Шапка.Параметры.ОрганизацияНаименование = ? (НЕ ЗначениеЗаполнено(СведенияОбОС.ОрганизацияНаименованиеПолное),
					СведенияОбОС.ОрганизацияНаименование, СведенияОбОС.ОрганизацияНаименованиеПолное);
					
					СтрокаМодернизацииИРемонта.Параметры.ИнвентарныйНомер = СведенияОбОС.ИнвентарныйНомер;
					Организация                                           = СведенияОбОС.Организация;
					
					ПерваяСтрока = Ложь;
					
					Шапка.Параметры.Валюта     = ВалютаПечати;
					Шапка.Параметры.cВидаУчета = cВидаУчета;
					
					ТабДок.Вывести(Шапка);
					
					СтрокаПеремещения = Макет.ПолучитьОбласть("СтрокаПеремещения");
					СтрокаПеремещения.Параметры.Заполнить(СведенияОбОС);
					
					ТабДок.Вывести(СтрокаПеремещения);
					
				Иначе
					
					СтрокаПеремещения = Макет.ПолучитьОбласть("СтрокаПеремещения");
					СтрокаПеремещения.Параметры.Заполнить(СведенияОбОС);
					
					ТабДок.Вывести(СтрокаПеремещения);
					
				КонецЕсли;	
			
			КонецЦикла;
			
			ПодвалПеремещения = Макет.ПолучитьОбласть("ПодвалПеремещения");
			ТабДок.Вывести(ПодвалПеремещения);
			
		Иначе
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='На момент печати основное средство %1 не принималось к учету.
|Нельзя сформировать инвентарную карточку объекта!';uk=""На момент друку основний засіб %1 не приймався до обліку.
|Не можна сформувати інвентарну картку об'єкта!"""), Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
			
		КонецЕсли;
		

		// Модернизация ОС и ремонт
		ТаблицаМодернизаций = Новый ТаблицаЗначений;
		ТаблицаМодернизаций.Колонки.Добавить("Дата");
		ТаблицаМодернизаций.Колонки.Добавить("Номер");
		ТаблицаМодернизаций.Колонки.Добавить("Сумма");
		
		ТаблицаРемонтов = Новый ТаблицаЗначений;
		ТаблицаРемонтов.Колонки.Добавить("Дата");
		ТаблицаРемонтов.Колонки.Добавить("Номер");
		ТаблицаРемонтов.Колонки.Добавить("Сумма");
		
		ШапкаМодернизацииИРемонта.Параметры.Валюта     = ВалютаПечати;
		ШапкаМодернизацииИРемонта.Параметры.cВидаУчета = cВидаУчета;
		ТабДок.Вывести(ШапкаМодернизацииИРемонта);
		
		Запрос = Новый Запрос;	
		Запрос.УстановитьПараметр("ОсновноеСредство"   , Ссылка);
		Запрос.УстановитьПараметр("ДатаСведений"       , ДатаСведений);
		Запрос.УстановитьПараметр("УсловиеМодернизаций", Перечисления.ВидыСобытийОС.Модернизация);
		Запрос.УстановитьПараметр("УсловиеРемонтов"    , Перечисления.ВидыСобытийОС.Ремонт);
		Запрос.УстановитьПараметр("ВидОперацииОС"      , Перечисления.ВидыСобытийОС.ВводВЭксплуатацию);
		Запрос.УстановитьПараметр("Организация"        , Организация);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ВЫБОР КОГДА ОперацииОС.Событие.ВидСобытияОС = (&УсловиеМодернизаций) 
		|		  ТОГДА ОперацииОС.СуммаЗатратБУ ИНАЧЕ 0 КОНЕЦ) КАК СуммаЗатратМодернизаций,
		|	СУММА(ВЫБОР КОГДА ОперацииОС.Событие.ВидСобытияОС = (&УсловиеРемонтов) 
		|		  ТОГДА ОперацииОС.СуммаЗатратБУ ИНАЧЕ 0 КОНЕЦ) КАК СуммаЗатратРемонтов,
		|	ОперацииОС.Регистратор       КАК Регистратор,
		|	ОперацииОС.Период            КАК Период,
		|	ОперацииОС.Событие           КАК Операция,
		|	ОперацииОС.НомерДокумента    КАК НомерДокумента,
		|	ОперацииОС.НазваниеДокумента КАК НазваниеДокумента
		|ИЗ
		|	РегистрСведений.СобытияОСОрганизаций КАК ОперацииОС
		|
		|ГДЕ
		|	ОперацииОС.Событие.ВидСобытияОС <> &ВидОперацииОС
		|	И ОперацииОС.Период < &ДатаСведений
		|	И ОперацииОС.ОсновноеСредство = &ОсновноеСредство
		|	И ОперацииОС.Организация = &Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	ОперацииОС.Период,
		|	ОперацииОС.Регистратор,
		|	ОперацииОС.Событие,
		|	ОперацииОС.НомерДокумента,
		|	ОперацииОС.НазваниеДокумента
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период,
		|	Регистратор";
		Результат = Запрос.Выполнить();
		
		
		СпособВыборки = ОбходРезультатаЗапроса.ПоГруппировкам;
		ВыборкаРегистраторов = Результат.Выбрать(СпособВыборки);
		
		Пока ВыборкаРегистраторов.Следующий() Цикл
			
			СуммаМодернизаций = ВыборкаРегистраторов.СуммаЗатратМодернизаций;
			СуммаРемонтов     = ВыборкаРегистраторов.СуммаЗатратРемонтов;
			
			Если СуммаМодернизаций <> 0 Тогда		
				
				СтрокаТаблицыМодернизаций = ТаблицаМодернизаций.Добавить();
				СтрокаТаблицыМодернизаций.Номер = ВыборкаРегистраторов.НомерДокумента;
				СтрокаТаблицыМодернизаций.Дата  = ВыборкаРегистраторов.Период;
				СтрокаТаблицыМодернизаций.Сумма = СуммаМодернизаций;
				
			КонецЕсли;
			
			Если СуммаРемонтов <> 0 Тогда		
				
				СтрокаТаблицыРемонтов = ТаблицаРемонтов.Добавить();
				СтрокаТаблицыРемонтов.Номер = ВыборкаРегистраторов.НомерДокумента;
				СтрокаТаблицыРемонтов.Дата  = ВыборкаРегистраторов.Период;
				СтрокаТаблицыРемонтов.Сумма = СуммаРемонтов;
				
			КонецЕсли;
			
		КонецЦикла;
		
		КоличествоСтрокМодернизации = ТаблицаМодернизаций.Количество();
		КоличествоСтрокРемонтов     = ТаблицаРемонтов.Количество();
		КоличествоСтрок             = Макс(КоличествоСтрокМодернизации, 
		                                   Окр(КоличествоСтрокРемонтов / 2, 0, РежимОкругления.Окр15как20));
		СчетСтрокРемонтов           = 0;
		
		Для СчетСтрок = 0 По КоличествоСтрок-1 Цикл
			
			// строка модернизации
			Если СчетСтрок < КоличествоСтрокМодернизации Тогда
				
				СтрокаТаблицы = ТаблицаМодернизаций.Получить(СчетСтрок);
				СтрокаМодернизацииИРемонта.Параметры.ДатаМодернизации  = СтрокаТаблицы.Дата;
				СтрокаМодернизацииИРемонта.Параметры.НомерМодернизации = СтрокаТаблицы.Номер;
				СтрокаМодернизацииИРемонта.Параметры.СуммаМодернизации = СтрокаТаблицы.Сумма; 
				
			Иначе
				
				СтрокаМодернизацииИРемонта.Параметры.ДатаМодернизации  = "";
				СтрокаМодернизацииИРемонта.Параметры.НомерМодернизации = "";
				СтрокаМодернизацииИРемонта.Параметры.СуммаМодернизации = ""; 
				
			КонецЕсли;
			
			// первая подстрока ремонта
			Если СчетСтрокРемонтов < КоличествоСтрокРемонтов Тогда
				
				СтрокаМодернизации = ТаблицаРемонтов.Получить(СчетСтрокРемонтов);			
				СтрокаМодернизацииИРемонта.Параметры.ДатаРемонта  = СтрокаМодернизации.Дата;
				СтрокаМодернизацииИРемонта.Параметры.НомерРемонта = СтрокаМодернизации.Номер;
				СтрокаМодернизацииИРемонта.Параметры.СуммаРемонта = СтрокаМодернизации.Сумма;
				СчетСтрокРемонтов = СчетСтрокРемонтов + 1;
				
			Иначе
				
				СтрокаМодернизацииИРемонта.Параметры.ДатаРемонта  = "";
				СтрокаМодернизацииИРемонта.Параметры.НомерРемонта = "";
				СтрокаМодернизацииИРемонта.Параметры.СуммаРемонта = "";
				
			КонецЕсли;
			
			// вторая подстрока ремонта
			Если СчетСтрокРемонтов < КоличествоСтрокРемонтов Тогда
				
				СтрокаМодернизации = ТаблицаРемонтов.Получить(СчетСтрокРемонтов);
				СтрокаМодернизацииИРемонта.Параметры.ДатаРемонта1  = СтрокаМодернизации.Дата;
				СтрокаМодернизацииИРемонта.Параметры.НомерРемонта1 = СтрокаМодернизации.Номер;
				СтрокаМодернизацииИРемонта.Параметры.СуммаРемонта1 = СтрокаМодернизации.Сумма;
				СчетСтрокРемонтов = СчетСтрокРемонтов + 1;
				
			Иначе
				
				СтрокаМодернизацииИРемонта.Параметры.ДатаРемонта1  = "";
				СтрокаМодернизацииИРемонта.Параметры.НомерРемонта1 = "";
				СтрокаМодернизацииИРемонта.Параметры.СуммаРемонта1 = "";
				
			КонецЕсли;
			
			ТабДок.Вывести(СтрокаМодернизацииИРемонта);		
			
		КонецЦикла;
		
		Подвал.Параметры.ДатаЗаполнения = ДатаСведений;
		ТабДок.Вывести(Подвал);		
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);

	КонецЦикла;	
		
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ПолеСлева     = 5;
	ТабДок.ПолеСправа    = 5;
	ТабДок.ПолеСверху    = 0;
	ТабДок.ПолеСнизу     = 0;
	ТабДок.ИмяПараметровПечати = НСтр("ru='КарточкаОЗ6';uk='КарточкаОЗ6'");
	
	Возврат ТабДок;
	
КонецФункции // ПечатьОЗ6() 

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОЗ6") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ОЗ6", НСтр("ru='Инвентарная карточка ОС (ОЗ-6)';uk='Інвентарна картка ОЗ (ОЗ-6)'"), ПечатьОЗ6(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли