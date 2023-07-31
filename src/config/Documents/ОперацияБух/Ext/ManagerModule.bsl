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

	// Бухгалтерская справка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БухгалтерскаяСправка";
	КомандаПечати.Представление = НСтр("ru='Бухгалтерская справка';uk='Бухгалтерська довідка'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Операция""';uk='Реєстр документів ""Операція""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
	
КонецПроцедуры

Функция ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросШапка = Новый Запрос();
	ЗапросШапка.Текст = 
	"ВЫБРАТЬ
	|	ОперацияБух.Организация,
	|	ОперацияБух.Номер,
	|	ОперацияБух.Дата,
	|	ОперацияБух.Ответственный,
	|	ВЫРАЗИТЬ(ОперацияБух.Содержание КАК СТРОКА(1000)) КАК Содержание
	|ИЗ
	|	Документ.ОперацияБух КАК ОперацияБух
	|ГДЕ
	|	ОперацияБух.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХозрасчетныйДвиженияССубконто.НомерСтроки КАК НомерСтроки,
	|	ХозрасчетныйДвиженияССубконто.СчетДт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт2,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт3,
	|	ХозрасчетныйДвиженияССубконто.СчетКт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт2,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт3,
	|	ХозрасчетныйДвиженияССубконто.Организация,
	|	ХозрасчетныйДвиженияССубконто.ВалютаДт,
	|	ХозрасчетныйДвиженияССубконто.ВалютаКт,
	|	ХозрасчетныйДвиженияССубконто.Сумма,
	|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаДт,
	|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаКт,
	|	ХозрасчетныйДвиженияССубконто.КоличествоДт,
	|	ХозрасчетныйДвиженияССубконто.КоличествоКт,
	|	ХозрасчетныйДвиженияССубконто.Содержание
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор = &Регистратор) КАК ХозрасчетныйДвиженияССубконто
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОперацияБух.ПФ_MXL_БухгалтерскаяСправка");
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	// Получаем области макета для вывода в табличный документ.
	ШапкаДокумента   = Макет.ПолучитьОбласть("Шапка");
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	СтрокаТаблицы    = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ПодвалТаблицы    = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ПодвалДокумента  = Макет.ПолучитьОбласть("Подвал");
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по умолчанию.
	ТабДокумент.ПолеСверху              = 10;
	ТабДокумент.ПолеСлева               = 0;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 0;
	ТабДокумент.РазмерКолонтитулаСверху = 10;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
	
	// Загрузим настройки пользователя.
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОперацияБух_БухгалтерскаяСправка";
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ЗапросШапка.УстановитьПараметр("Ссылка", Ссылка);
		Док = ЗапросШапка.Выполнить().Выбрать();
		Док.Следующий();
		
		Запрос.УстановитьПараметр("Регистратор", Ссылка);
		ВыборкаДвижений = Запрос.Выполнить().Выбрать();
		
		// Выведем шапку документа.
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Док.Организация, Док.Дата);
		
		ШапкаДокумента.Параметры.Организация    = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,,,КодЯзыкаПечать);
		
		ШапкаДокумента.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Док.Номер, Истина, Истина);
		ШапкаДокумента.Параметры.ДатаДокумента  = Формат(Док.Дата, "ДЛФ=D;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ШапкаДокумента.Параметры.Содержание     = СокрЛП(Док.Содержание);
		
		ТабДокумент.Вывести(ШапкаДокумента);
		
		// Выведем заголовок таблицы.
		ТабДокумент.Вывести(ЗаголовокТаблицы);
		
		// Выведем строки документа.
		Пока ВыборкаДвижений.Следующий() Цикл
			
			СтрокаТаблицы.Параметры.Заполнить(ВыборкаДвижений);
			
			АналитикаДт = Локализация.ПолучитьЛокализованноеПредставление(ВыборкаДвижений.СубконтоДт1, КодЯзыкаПечать) + Символы.ПС
			            + Локализация.ПолучитьЛокализованноеПредставление(ВыборкаДвижений.СубконтоДт2, КодЯзыкаПечать) + Символы.ПС
	                    + Локализация.ПолучитьЛокализованноеПредставление(ВыборкаДвижений.СубконтоДт3, КодЯзыкаПечать);
						
			АналитикаКт = Локализация.ПолучитьЛокализованноеПредставление(ВыборкаДвижений.СубконтоКт1, КодЯзыкаПечать) + Символы.ПС
			            + Локализация.ПолучитьЛокализованноеПредставление(ВыборкаДвижений.СубконтоКт2, КодЯзыкаПечать) + Символы.ПС
	                    + Локализация.ПолучитьЛокализованноеПредставление(ВыборкаДвижений.СубконтоКт3, КодЯзыкаПечать);
						
			СтрокаТаблицы.Параметры.АналитикаДт = АналитикаДт;
			СтрокаТаблицы.Параметры.АналитикаКт = АналитикаКт;
										 
			// Проверим, помещается ли строка с подвалом.
			СтрокаСПодвалом = Новый Массив;
			СтрокаСПодвалом.Добавить(СтрокаТаблицы);
			СтрокаСПодвалом.Добавить(ПодвалТаблицы);
			СтрокаСПодвалом.Добавить(ПодвалДокумента);
			
			Если НЕ ТабДокумент.ПроверитьВывод(СтрокаСПодвалом) Тогда
				
				// Выведем подвал таблицы.
				ТабДокумент.Вывести(ПодвалТаблицы);
					
				// Выведем разрыв страницы.
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();

				// Выведем заголовок таблицы.
				ТабДокумент.Вывести(ЗаголовокТаблицы);
				
			КонецЕсли;
			
			ТабДокумент.Вывести(СтрокаТаблицы);
			
		КонецЦикла;
		
		// Выведем подвал таблицы.
		ТабДокумент.Вывести(ПодвалТаблицы);
		
		// Выведем подвал документа.
		ПодвалДокумента.Параметры.РасшифровкаПодписиИсполнителя = ?(НЕ ЗначениеЗаполнено(Док.Ответственный), "", ФизическиеЛицаБП.ФамилияИнициалыФизЛица(Док.Ответственный.ФизическоеЛицо));
		ТабДокумент.Вывести(ПодвалДокумента);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);

	КонецЦикла;	
	
	Возврат ТабДокумент;
		
КонецФункции // ПечатьБухгалтерскойСправки()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
	ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета ПлатежноеПоручение формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "БухгалтерскаяСправка") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "БухгалтерскаяСправка", НСтр("ru='Бухгалтерская справка';uk='Бухгалтерська довідка'"), 
			ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ОперацияБух.ПФ_MXL_БухгалтерскаяСправка", , Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли