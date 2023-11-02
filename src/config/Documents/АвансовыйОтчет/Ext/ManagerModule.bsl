﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет счета учета номенклатуры в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСчетовУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаСпискаНоменклатуры(
		ДанныеОбъекта.Организация, ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта.Склад, ДанныеОбъекта.Дата);
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СчетаУчета = СоответствиеСчетовУчета.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СчетаУчета);
	КонецЦикла;

КонецПроцедуры

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - структура сведений о номенклатуре, либо стуктура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре) Экспорт

	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		// СведенияОНоменклатуре - структура сведений номенклатуры
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчета") Тогда
		// СведенияОНоменклатуре - структура счетов учета номенклатуры
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ИмяТабличнойЧасти = "Товары" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетУчетаБУ;
		КонецЕсли;

		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
	ИначеЕсли ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетУчетаБУ;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
	ИначеЕсли ИмяТабличнойЧасти = "Прочее" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
			СтрокаТабличнойЧасти.СчетЗатрат	= СчетаУчета.СчетУчетаБУ;
			СтрокаТабличнойЧасти.Субконто1	= СчетаУчета.СубконтоБУ1;
			СтрокаТабличнойЧасти.Субконто2	= СчетаУчета.СубконтоБУ2;
			СтрокаТабличнойЧасти.Субконто3	= СчетаУчета.СубконтоБУ3;
		КонецЕсли;

		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначениеДоходовИЗатрат) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначениеДоходовИЗатрат = СчетаУчета.НалоговоеНазначениеДоходовИЗатрат;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Функция Счет9Класса(Счет)
	
	Если БухгалтерскийУчетПереопределяемый.ПолучитьИспользоватьКлассыСчетовВКачествеГрупп() Тогда
		Счет9Класса = Счет.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ЗатратыДеятельности); 
	Иначе
		СчетаЗатрат	= Новый Массив;
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.СебестоимостьРеализации);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеЗатраты);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ПотериОтУчастияВКапитале);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыДеятельности);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.НалогНаПрибыль);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ЧрезвычайныеЗатраты);
		Счет9Класса = (СчетаЗатрат.Найти(Счет) <> Неопределено);
	КонецЕсли;
	
	Возврат(Счет9Класса);
				
КонецФункции

Процедура РассчитатьПропорциональныйНДСПоСтроке(СтрокаТаблицы, Знач ПлательщикНДС, Знач КоэффициентПропорциональногоНДС)
	
	Если Не ПлательщикНДС Тогда
		СтрокаТаблицы.СуммаНДСПропорциональноКредит = 0;
	Иначе
		
		Если СтрокаТаблицы.НалоговоеНазначение <> ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально") Тогда
		    СтрокаТаблицы.СуммаНДСПропорциональноКредит = 0;
		Иначе	
			СтрокаТаблицы.СуммаНДСПропорциональноКредит = СтрокаТаблицы.СуммаНДС * КоэффициентПропорциональногоНДС;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьПропорциональныйНДСПоДокументу(Объект, ПлательщикНДС, КоэффициентПропорциональногоНДС) Экспорт 
	
	Для каждого СтрокаТаблицы Из Объект.Товары Цикл
		РассчитатьПропорциональныйНДСПоСтроке(СтрокаТаблицы, ПлательщикНДС, КоэффициентПропорциональногоНДС);
	КонецЦикла;
	Для каждого СтрокаТаблицы Из Объект.ОплатаПоставщикам Цикл
		РассчитатьПропорциональныйНДСПоСтроке(СтрокаТаблицы, ПлательщикНДС, КоэффициентПропорциональногоНДС);
	КонецЦикла;
	Для каждого СтрокаТаблицы Из Объект.Прочее Цикл
		РассчитатьПропорциональныйНДСПоСтроке(СтрокаТаблицы, ПлательщикНДС, КоэффициентПропорциональногоНДС);
	КонецЦикла;
	
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
	
	// Авансовый отчет
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Аванс_Отчет";
	КомандаПечати.Представление = НСтр("ru='Авансовый отчет';uk='Авансовий звіт'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Реестр документов ""Авансовый отчет""';uk='Реєстр документів ""Авансовий звіт""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,ОбъектыПечати, ПараметрыВывода) Экспорт

	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета ОтчетККМ формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Аванс_Отчет") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Аванс_Отчет",
			НСтр("ru='Авансовый отчет';uk='Авансовий звіт'"),
			ПечатьАвансовогоОтчета(МассивОбъектов, ОбъектыПечати, ИмяМакета),
			,
			ИмяМакета);
	КонецЕсли;
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьАвансовогоОтчета(МассивОбъектов, ОбъектыПечати, ИмяМакета)

	УстановитьПривилегированныйРежим(Истина);
	
	// Запрос по Шапке.
	ЗапросШапка = Новый Запрос;
	ЗапросШапка.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата                  КАК ДатаДокумента,
	|	ФизЛицо               КАК ПодотчетноеЛицо,
	|	ФизЛицо.КодПоДРФО	  КАК ДРФОПодотчетногоЛица,
	|	Организация           КАК Руководители,
	|	Организация.Ссылка    КАК Организация,
	|   Организация.ЮридическоеФизическоеЛицо КАК ОрганизацияЮридическоеФизическоеЛицо,
	|	НазначениеАванса      КАК НазначениеАванса,  
	|	ВалютаДокумента,
	|	СуммаВключаетНДС,
	|	ВалютаДокумента,
	|	КурсДокумента,
	|	КратностьДокумента,
	|	ВалютаДокумента.Представление       КАК ПредставлениеВалютыДокумента,
	|	СуммаДокумента 		  КАК СуммаДокумента	
	|ИЗ
	|	Документ.АвансовыйОтчет КАК АвансовыйОтчет
	|
	|ГДЕ
	|	АвансовыйОтчет.Ссылка = &ТекущийДокумент";

	КоличествоАО = 0;
	КоличествоАО_01012011 = 0;
	КоличествоАО_25012013 = 0;
	КоличествоАО_04022014 = 0;
	КоличествоАО_06112015 = 0;
	КоличествоАО_19042016 = 0;
	КоличествоАО_01072023 = 0;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АвансовыйОтчет_АвансовыйОтчет";
	МакетАО          = УправлениеПечатью.МакетПечатнойФормы("Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет");
	МакетАО_01012011 = УправлениеПечатью.МакетПечатнойФормы("Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет01012011");
	МакетАО_25012013 = УправлениеПечатью.МакетПечатнойФормы("Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет25012013");
	МакетАО_04022014 = УправлениеПечатью.МакетПечатнойФормы("Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет04022014");
	МакетАО_06112015 = УправлениеПечатью.МакетПечатнойФормы("Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет06112015");
	МакетАО_19042016 = УправлениеПечатью.МакетПечатнойФормы("Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет19042016");
	МакетАО_01072023 = УправлениеПечатью.МакетПечатнойФормы("Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет01072023");
	
	КодЯзыкаПечать = "uk";
	
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	ПервыйДокумент = Истина;
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ЗапросШапка.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Шапка = ЗапросШапка.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ВариантДо01012011 = Шапка.ДатаДокумента < Дата("20110131000000");
		Вариант04002014 = Ложь;
		Вариант19042016 = Ложь;
		Вариант01072023 = Ложь;
		Если ВариантДо01012011 Тогда
			Макет = МакетАО;
			КоличествоАО = КоличествоАО + 1;
		ИначеЕсли Шапка.ДатаДокумента < Дата("20130125000000") Тогда
			Макет = МакетАО_01012011;
			КоличествоАО_01012011 = КоличествоАО_01012011 + 1;
		ИначеЕсли Шапка.ДатаДокумента < Дата("20140204000000") Тогда
			Макет       = МакетАО_25012013;
			КоличествоАО_25012013 = КоличествоАО_25012013 + 1;
		ИначеЕсли Шапка.ДатаДокумента < Дата("20151106000000") Тогда
			Макет       = МакетАО_04022014;
			Вариант04002014 = Истина;
			КоличествоАО_04022014 = КоличествоАО_04022014 + 1;
		ИначеЕсли Шапка.ДатаДокумента < Дата("20160419000000") Тогда
			Макет       = МакетАО_06112015;
			Вариант04002014 = Истина;
			КоличествоАО_06112015 = КоличествоАО_06112015 + 1;
		ИначеЕсли Шапка.ДатаДокумента < Дата("20230713") Тогда
			Макет       = МакетАО_19042016;
			Вариант04002014 = Истина;
			КоличествоАО_19042016 = КоличествоАО_19042016 + 1;
			Вариант19042016 = Истина;
		Иначе
			Макет       = МакетАО_01072023;
			Вариант04002014 = Истина;
			Вариант19042016 = Истина;
			Вариант01072023 = Истина;
			КоличествоАО_01072023 = КоличествоАО_01072023 + 1;
		КонецЕсли;

		// ТИТУЛЬНЫЙ ЛИСТ
		Запрос = Новый Запрос();
		Если НЕ (Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета) Тогда
			Запрос.УстановитьПараметр("СчетРасчетов", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицамиВИностраннойВалюте);
		Иначе
			Запрос.УстановитьПараметр("СчетРасчетов", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицамиВНациональнойВалюте);
		КонецЕсли;
		
		Запрос.УстановитьПараметр("Сотрудник",  Шапка.ПодотчетноеЛицо);
		Запрос.УстановитьПараметр("Организация",Шапка.Организация);
		Запрос.УстановитьПараметр("ДатаИтогов", Шапка.ДатаДокумента);
		Запрос.УстановитьПараметр("Валюта",		Шапка.ВалютаДокумента);
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Счет,
		|	ХозрасчетныйОстатки."+?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета,"","Валютная")+"СуммаОстатокДт КАК СуммаОстатокКт,
		|	ХозрасчетныйОстатки."+?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета,"","Валютная")+"СуммаОстатокКт КАК СуммаОстатокДт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ДатаИтогов,
		|			Счет В ИЕРАРХИИ (&СчетРасчетов),
		|			,
		|			Организация = &Организация
		|				И Субконто1 = &Сотрудник
		|				"+?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета,"","И Валюта = &Валюта")+") КАК ХозрасчетныйОстатки";

		ПредыдущийАванс = Запрос.Выполнить().Выбрать();
		ПредыдущийАванс.Следующий();
		
		Перерасход = ?(ПредыдущийАванс.СуммаОстатокДт = Null, 0, ПредыдущийАванс.СуммаОстатокДт);
		Остаток    = ?(ПредыдущийАванс.СуммаОстатокКт = Null, 0, ПредыдущийАванс.СуммаОстатокКт);

		СуммаДоДокумента = 0;

		Если НЕ ЗначениеЗаполнено(Перерасход) Тогда
			Перерасход = 0;
		Иначе
			СуммаДоДокумента = - Число(Перерасход);
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(Остаток) Тогда
			Остаток = 0;
		Иначе
			СуммаДоДокумента = Число(Остаток);
		КонецЕсли;

		ВыданныеАвансы = Ссылка.ВыданныеАвансы;
		МассивАвансовыхДокументов = ВыданныеАвансы.ВыгрузитьКолонку("ДокументАванса");
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("МассивАвансовыхДокументов", МассивАвансовыхДокументов);	
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(РасходныйКассовыйОрдер.СуммаДокумента) КАК СуммаДокумента,
		|	РасходныйКассовыйОрдер.Ссылка
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
		|ГДЕ
		|	РасходныйКассовыйОрдер.Ссылка В(&МассивАвансовыхДокументов)
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходныйКассовыйОрдер.Ссылка";
		
		Таб = Запрос.Выполнить().Выгрузить();
		ПолученоИзКассы = Число(Таб.Итог("СуммаДокумента"));
	 	
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("МассивАвансовыхДокументов", МассивАвансовыхДокументов);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(СписаниеСРасчетногоСчета.СуммаДокумента) КАК СуммаДокумента
		|ИЗ
		|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
		|ГДЕ
		|	СписаниеСРасчетногоСчета.Ссылка В(&МассивАвансовыхДокументов)
		|
		|СГРУППИРОВАТЬ ПО
		|	СписаниеСРасчетногоСчета.Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СУММА(ПлатежныйОрдерСписаниеДенежныхСредств.СуммаДокумента)
		|ИЗ
		|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК ПлатежныйОрдерСписаниеДенежныхСредств
		|ГДЕ
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка В(&МассивАвансовыхДокументов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка
		|";
		
		Таб = Запрос.Выполнить().Выгрузить();
		ПолученоИзКассы = ПолученоИзКассы + Число(Таб.Итог("СуммаДокумента"));

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");

		СуммаДоДокумента = СуммаДоДокумента - ПолученоИзКассы;

		// Выводим титульный лист авансового отчета
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(Шапка); 
		ДополнительныеПараметрыМакета = Новый Структура;
		ОбластьМакета.Параметры.НомерДокумента  = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Шапка.Номер);
		
		// для расписки получим ФИО с инициалами.
		ДанныеСотрудника = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Шапка.Организация, Шапка.ПодотчетноеЛицо, Шапка.ДатаДокумента);

		ФИОПодотчетногоЛица 						= " " + ДанныеСотрудника.Фамилия + " " + ДанныеСотрудника.Имя + " " + ДанныеСотрудника.Отчество;
		ДополнительныеПараметрыМакета.Вставить("ФИОПодотчетногоЛицаКратко", ДанныеСотрудника.Представление);
		ДополнительныеПараметрыМакета.Вставить("ФИОПодотчетногоЛица", СокрЛП(ФИОПодотчетногоЛица));
		ДополнительныеПараметрыМакета.Вставить("ПредставлениеПодразделения", СокрЛП(ДанныеСотрудника.ПОдразделениеОрганизации));
		ДополнительныеПараметрыМакета.Вставить("ДолжностьПодотчетногоЛицаПредставление", СокрЛП(ДанныеСотрудника.Должность));
		
		Если СуммаДоДокумента >= 0 тогда
			ОбластьМакета.Параметры.НачальныйОстаток    =   СуммаДоДокумента;
		Иначе
			ОбластьМакета.Параметры.НачальныйПерерасход = - СуммаДоДокумента;
		КонецЕсли;

		КоличествоДокументов = ?(ВыданныеАвансы.Количество()>3, 3, ВыданныеАвансы.Количество());
		Для Инд = 1 По КоличествоДокументов Цикл
			
			ДокументАванса = ВыданныеАвансы[Инд-1].ДокументАванса;
			Если Не ЗначениеЗаполнено(ДокументАванса) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ДокументАванса.Метаданные().Имя = "РасходныйКассовыйОрдер" Тогда
				Документ = "Видатковий касовий ордер №" + Строка(ДокументАванса.НомерОрдера) + " від " 
							+ Строка(Формат(ДокументАванса.Дата, "ДФ=dd.MM.yyyy"));
							
			ИначеЕсли ДокументАванса.Метаданные().Имя = "СписаниеСРасчетногоСчета" Тогда
				Документ = "Платіжне доручення вихідне №" + Строка(ДокументАванса.НомерВходящегоДокумента) + " від " 
							+ Строка(Формат(ДокументАванса.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"));
							
			ИначеЕсли ДокументАванса.Метаданные().Имя = "ПлатежныйОрдерСписаниеДенежныхСредств" Тогда
				Документ = "Платіжний ордер на списання коштів №" + Строка(ДокументАванса.Номер) + " від " 
							+ Строка(Формат(ДокументАванса.Дата, "ДФ=dd.MM.yyyy"));	
			КонецЕсли;
			
			ОбластьМакета.Параметры["Документ" + Инд] = Документ;
			ОбластьМакета.Параметры["Получено" + Инд] = ДокументАванса.СуммаДокумента;
			
		КонецЦикла;
		
		ОбластьМакета.Параметры.ИтогВсегоПолучено = ПолученоИзКассы;
		
		ОбластьМакета.Параметры.Израсходовано = Шапка.СуммаДокумента;
		ОбластьМакета.Параметры.СуммаОтчетПодтверждаю = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента, КодЯзыкаПечать);

		ДополнительныеПараметрыМакета.Вставить("СуммаСНДСЧислом", Формат(Шапка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2;")); 
	    ДополнительныеПараметрыМакета.Вставить("СуммаДокумента", Формат(Шапка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2;"));
		
		ОстатокНаКонец = СуммаДоДокумента + ПолученоИзКассы - Шапка.СуммаДокумента;
		Если ОстатокНаКонец >= 0  Тогда
			ОбластьМакета.Параметры.КонечныйОстаток    = ОстатокНаКонец;
		Иначе
			ОбластьМакета.Параметры.КонечныйПерерасход = - ОстатокНаКонец;
		КонецЕсли;
		Если Вариант04002014 Тогда
			ОбластьМакета.Параметры.ВалютаЗаголовокКолонки = ?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета, "грн,коп.",Строка(Шапка.ВалютаДокумента));
			Если ОстатокНаКонец >= 0  Тогда
				//Остаток надо возвращать в валюте
				ОбластьМакета.Параметры.ВалютаОстатокПерерасход = ?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета, "грн,коп.",Строка(Шапка.ВалютаДокумента));
			Иначе
				//Перерасход надо возвращать в гривнях
				ОбластьМакета.Параметры.ВалютаОстатокПерерасход = "грн,коп.";
			КонецЕсли;
			ПараметрыНеОбязательные = Новый Структура("ВалютаДокументаРасписка",?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета, "грн,коп",Строка(Шапка.ВалютаДокумента)));
		    ОбластьМакета.Параметры.Заполнить(ПараметрыНеОбязательные);
		КонецЕсли; 

		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,");


		ЕДРПОУОрганизации = БухгалтерскийУчетПереопределяемый.ПолучитьКодОрганизации(СведенияОбОрганизации);
		Для Инд = 1 По 8 Цикл
			ОбластьМакета.Параметры["ЕДРПОУОрганизации_" + Инд] = Сред(ЕДРПОУОрганизации, Инд, 1);
		КонецЦикла; 
		// если организация - физ.лицо нужно "добавить" две ячейки
		Если Шапка.ОрганизацияЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
			Для Инд = 9 По 10 Цикл
				ОбластьМакета.Параметры["ЕДРПОУОрганизации_" + Инд] = Сред(ЕДРПОУОрганизации, Инд, 1);
			КонецЦикла; 
			Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,2);
			ОбластьМакета.Область("КодОрганизации9").Обвести(Линия,Линия,Линия,Линия);
			ОбластьМакета.Область("КодОрганизации10").Обвести(Линия,Линия,Линия,Линия);
		КонецЕсли;

		
		Для Инд = 1 По 10 Цикл
			ОбластьМакета.Параметры["ДРФОПодотчетногоЛица_" + Инд] = Сред(Шапка.ДРФОПодотчетногоЛица, Инд, 1);
		КонецЦикла;
		
		ДополнительныеПараметрыМакета.Вставить("Дата", Шапка.ДатаДокумента);
		ОбластьМакета.Параметры.ДатаКоротко 		= Формат(Шапка.ДатаДокумента, "ДФ=dd.MM.yyyy");

		ЗапросПоПроводкам = Новый Запрос();
		ЗапросПоПроводкам.УстановитьПараметр("Ссылка", Ссылка);
		Если НЕ (Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета) Тогда
			ЗапросПоПроводкам.УстановитьПараметр("СчетРасчетов", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицамиВИностраннойВалюте);
		Иначе
			ЗапросПоПроводкам.УстановитьПараметр("СчетРасчетов", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицамиВНациональнойВалюте);
		КонецЕсли;
		ЗапросПоПроводкам.Текст = "
		|ВЫБРАТЬ
		|	Хозрасчетный.СчетДт,
		|	Хозрасчетный.СчетКт,
		|	СУММА(Хозрасчетный."+?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета,"Сумма","ВалютнаяСуммаКт")+") КАК Сумма,
		|	МИНИМУМ(Хозрасчетный.НомерСтроки) КАК НомерСтроки
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
		|
		|ГДЕ
		|	Хозрасчетный.Регистратор = &Ссылка
		|	И Хозрасчетный.СчетКт В ИЕРАРХИИ(&СчетРасчетов)
		|
		|СГРУППИРОВАТЬ ПО
		|	Хозрасчетный.СчетДт,
		|	Хозрасчетный.СчетКт
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		ВыборкаПроводок = ЗапросПоПроводкам.Выполнить().Выгрузить();
		ВыборкаПроводокКопияДт = ВыборкаПроводок.Скопировать();
		ВыборкаПроводокКопияДт.Свернуть("СчетДт", "Сумма");
		ИспользуемыеКлассыСчетовРасходов = УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(Шапка.Организация, Шапка.ДатаДокумента);

		Счетчик = 0;
		Если ВариантДо01012011 Тогда
			
			Для каждого СтрокаВыборки Из ВыборкаПроводокКопияДт Цикл
				
				Если Счетчик = 5 тогда
					Прервать;
				КонецЕсли;
				
				Если (ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8
					ИЛИ ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8и9)
					И Счет9Класса(СтрокаВыборки.СчетДт) Тогда
					Продолжить;		
				КонецЕсли;
				
				ИспСумма     = Окр(?(СтрокаВыборки.Сумма = Null, 0, СтрокаВыборки.Сумма), 2, 1);
				ЦелСумма     = Цел(?(СтрокаВыборки.Сумма = Null, 0, СтрокаВыборки.Сумма));		
				КопСумма     = 100 * (Окр(ИспСумма - ЦелСумма, 2, 1));
				
				Если КопСумма = 0 Тогда
					Если ЦелСумма = 0 Тогда
						КопСумма = "";
					Иначе
						КопСумма = "00";	
					КонецЕсли; 
				ИначеЕсли КопСумма < 10 Тогда
					КопСумма = "0" + Строка(КопСумма);
				Иначе
					КопСумма = Строка(КопСумма);
				КонецЕсли; 
				
				Если ЦелСумма = 0 Тогда
					Если КопСумма = 0 Тогда
						ЦелСумма = "";
					Иначе
						ЦелСумма = Строка(ЦелСумма);	
					КонецЕсли;  
				КонецЕсли;		
				
				ОбластьМакета.Параметры["СчетДт" 			+ (Счетчик + 1)] = СтрокаВыборки.СчетДт;
				ОбластьМакета.Параметры["СуммаБезКопеекДт" 	+ (Счетчик + 1)] = ЦелСумма;
				ОбластьМакета.Параметры["СуммаКопейкиДт"   	+ (Счетчик + 1)] = КопСумма;
				
				Счетчик = Счетчик + 1;
				
			КонецЦикла;
			
			ВыборкаПроводокКопияКт = ВыборкаПроводок.Скопировать();
			ВыборкаПроводокКопияКт.Свернуть("СчетКт", "Сумма");
			
			Счетчик = 0;
			Для каждого СтрокаВыборки Из ВыборкаПроводокКопияКт Цикл
				
				Если Счетчик = 5 тогда
					Прервать;
				КонецЕсли;
				
				Если (ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8
					ИЛИ ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8и9)
					И Счет9Класса(СтрокаВыборки.СчетКт) Тогда
					Продолжить;		
				КонецЕсли;
				
				ИспСумма     = Окр(?(СтрокаВыборки.Сумма = Null, 0, СтрокаВыборки.Сумма), 2, 1);
				ЦелСумма     = Цел(?(СтрокаВыборки.Сумма = Null, 0, СтрокаВыборки.Сумма));		
				КопСумма     = 100 * (Окр(ИспСумма - ЦелСумма, 2, 1));
				
				Если КопСумма = 0 Тогда
					Если ЦелСумма = 0 Тогда
						КопСумма = "";
					Иначе
						КопСумма = "00";	
					КонецЕсли; 
				ИначеЕсли КопСумма < 10 Тогда
					КопСумма = "0" + Строка(КопСумма);
				Иначе
					КопСумма = Строка(КопСумма);
				КонецЕсли; 
				
				Если ЦелСумма = 0 Тогда
					Если КопСумма = 0 Тогда
						ЦелСумма = "";
					Иначе
						ЦелСумма = Строка(ЦелСумма);	
					КонецЕсли;  
				КонецЕсли;		
				
				ОбластьМакета.Параметры["СчетКт" 			+ (Счетчик + 1)] = СтрокаВыборки.СчетКт;
				ОбластьМакета.Параметры["СуммаБезКопеекКт" 	+ (Счетчик + 1)] = ЦелСумма;
				ОбластьМакета.Параметры["СуммаКопейкиКт"   	+ (Счетчик + 1)] = КопСумма;
				
				Счетчик = Счетчик + 1;
				
			КонецЦикла;
			
		Иначе
			
			Для каждого СтрокаВыборки Из ВыборкаПроводок Цикл
				
				Если Счетчик = 10 тогда
					Прервать;
				КонецЕсли;
				
				Если (ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8
					ИЛИ ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8и9)
					И Счет9Класса(СтрокаВыборки.СчетДт) Тогда
					Продолжить;		
				КонецЕсли;
				
				Если (ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8
					ИЛИ ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8и9)
					И Счет9Класса(СтрокаВыборки.СчетКт) Тогда
					Продолжить;		
				КонецЕсли;
				
				ИспСумма     = Окр(?(СтрокаВыборки.Сумма = Null, 0, СтрокаВыборки.Сумма), 2, 1);
				ЦелСумма     = Цел(?(СтрокаВыборки.Сумма = Null, 0, СтрокаВыборки.Сумма));		
				КопСумма     = 100 * (Окр(ИспСумма - ЦелСумма, 2, 1));
				
				Если КопСумма = 0 Тогда
					Если ЦелСумма = 0 Тогда
						КопСумма = "";
					Иначе
						КопСумма = "00";	
					КонецЕсли; 
				ИначеЕсли КопСумма < 10 Тогда
					КопСумма = "0" + Строка(КопСумма);
				Иначе
					КопСумма = Строка(КопСумма);
				КонецЕсли; 
				
				Если ЦелСумма = 0 Тогда
					Если КопСумма = 0 Тогда
						ЦелСумма = "";
					Иначе
						ЦелСумма = Строка(ЦелСумма);	
					КонецЕсли;  
				КонецЕсли;		
				
				ОбластьМакета.Параметры["СчетДт" 				+ (Счетчик + 1)] = СтрокаВыборки.СчетДт;
				ОбластьМакета.Параметры["СчетКт" 				+ (Счетчик + 1)] = СтрокаВыборки.СчетКт;
				
				Если Вариант19042016 Тогда
					ОбластьМакета.Параметры["Сумма" 			+ (Счетчик + 1)] = ИспСумма;
				Иначе
					ОбластьМакета.Параметры["СуммаБезКопеек"	+ (Счетчик + 1)] = ЦелСумма;
					ОбластьМакета.Параметры["СуммаКопейки"  	+ (Счетчик + 1)] = КопСумма;
				КонецЕсли; 
				
				Счетчик = Счетчик + 1;
				
			КонецЦикла;
			
		КонецЕсли;    

		// ОБОРОТНАЯ СТОРОНА
		ЗапросТовары = Новый Запрос();
		ЗапросТовары.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		ЗапросТовары.УстановитьПараметр("ПустаяДата", 	   Дата("00010101"));
		ЗапросТовары.УстановитьПараметр("ТекущийДокумент", Ссылка);
		ЗапросТовары.УстановитьПараметр("Валюта",          Шапка.ВалютаДокумента);
		
		ЗапросТовары.Текст =" 
		|ВЫБРАТЬ
		|	АвансовыйОтчет.Номенклатура КАК Номенклатура,
		|	АвансовыйОтчет.Номенклатура.НаименованиеПолное КАК НоменклатураПолное,
		|	АвансовыйОтчет.НомерВходящегоДокумента КАК Номер,
		|	АвансовыйОтчет.ДатаВходящегоДокумента КАК Дата,
		|	АвансовыйОтчет.Контрагент,
		|	АвансовыйОтчет.ВидДокВходящий,
		|	"""" КАК Содержание,
		|	АвансовыйОтчет.СчетУчетаБУ КАК Счет,
		|	NULL КАК СчетЗатрат8Класса,
		|	АвансовыйОтчет.СчетУчетаНДС КАК СчетНДС,
		|	СУММА(АвансовыйОтчет.Сумма) КАК ПоОтчету,
		|	СУММА(АвансовыйОтчет.СуммаНДС) КАК СуммаНДС,
		|	СУММА(АвансовыйОтчет.СуммаНДСПропорциональноКредит) КАК СуммаНДСПропорциональноКредит,
		|	АвансовыйОтчет.НалоговоеНазначение КАК НалоговоеНазначение,
		|	NULL КАК СуточныеДатаС,
		|	NULL КАК СуточныеДатаПо
		|ПОМЕСТИТЬ ДанныеАвансовогоОтчета
		|ИЗ
		|	Документ.АвансовыйОтчет.Товары КАК АвансовыйОтчет
		|ГДЕ
		|	АвансовыйОтчет.Ссылка = &ТекущийДокумент
		|
		|СГРУППИРОВАТЬ ПО
		|	АвансовыйОтчет.Номенклатура,
		|	АвансовыйОтчет.Номенклатура.НаименованиеПолное,
		|	АвансовыйОтчет.НомерВходящегоДокумента,
		|	АвансовыйОтчет.ДатаВходящегоДокумента,
		|	АвансовыйОтчет.Контрагент,
		|	АвансовыйОтчет.ВидДокВходящий,
		|	АвансовыйОтчет.СчетУчетаБУ,
		|	АвансовыйОтчет.СчетУчетаНДС,
		|	АвансовыйОтчет.НалоговоеНазначение
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	""Оплата постачальникам"",
		|	""Оплата постачальникам"",
		|	АвансовыйОтчет.НомерВходящегоДокумента,
		|	АвансовыйОтчет.ДатаВходящегоДокумента,
		|	АвансовыйОтчет.Контрагент,
		|	АвансовыйОтчет.ВидДокВходящий,
		|	ВЫРАЗИТЬ(АвансовыйОтчет.Содержание КАК СТРОКА(1000)),
		|	АвансовыйОтчет.СчетУчетаРасчетовСКонтрагентом,
		|	NULL КАК СчетЗатрат8Класса,
		|	NULL,
		|	СУММА(АвансовыйОтчет.Сумма),
		|	0,
		|	0,
		|	NULL,
		|	NULL,
		|	NULL
		|ИЗ
		|	Документ.АвансовыйОтчет.ОплатаПоставщикам КАК АвансовыйОтчет
		|ГДЕ
		|	АвансовыйОтчет.Ссылка = &ТекущийДокумент
		|
		|СГРУППИРОВАТЬ ПО
		|	АвансовыйОтчет.НомерВходящегоДокумента,
		|	АвансовыйОтчет.ДатаВходящегоДокумента,
		|	АвансовыйОтчет.Контрагент,
		|	АвансовыйОтчет.ВидДокВходящий,
		|	ВЫРАЗИТЬ(АвансовыйОтчет.Содержание КАК СТРОКА(1000)),
		|	АвансовыйОтчет.СчетУчетаРасчетовСКонтрагентом
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	АвансовыйОтчет.Номенклатура,
		|	АвансовыйОтчет.Номенклатура.НаименованиеПолное КАК НоменклатураПолное,
		|	АвансовыйОтчет.НомерВходящегоДокумента,
		|	АвансовыйОтчет.ДатаВходящегоДокумента,
		|	АвансовыйОтчет.Контрагент,
		|	АвансовыйОтчет.ВидДокВходящий,
		|	ВЫРАЗИТЬ(АвансовыйОтчет.Содержание КАК СТРОКА(1000)),
		|	АвансовыйОтчет.СчетЗатрат,
		|	ВЫБОР
		|		КОГДА АвансовыйОтчет.Субконто1 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА АвансовыйОтчет.Субконто1.Счет8Класса
		|		КОГДА АвансовыйОтчет.Субконто2 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА АвансовыйОтчет.Субконто2.Счет8Класса
		|		КОГДА АвансовыйОтчет.Субконто3 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА АвансовыйОтчет.Субконто3.Счет8Класса
		|		ИНАЧЕ NULL
		|	КОНЕЦ,
		|	АвансовыйОтчет.СчетУчетаНДС,
		|	СУММА(АвансовыйОтчет.Сумма),
		|	СУММА(АвансовыйОтчет.СуммаНДС),
		|	СУММА(АвансовыйОтчет.СуммаНДСПропорциональноКредит),
		|	АвансовыйОтчет.НалоговоеНазначение,
		|	АвансовыйОтчет.СуточныеДатаС,
		|	АвансовыйОтчет.СуточныеДатаПо
		|ИЗ
		|	Документ.АвансовыйОтчет.Прочее КАК АвансовыйОтчет
		|ГДЕ
		|	АвансовыйОтчет.Ссылка = &ТекущийДокумент
		|
		|СГРУППИРОВАТЬ ПО
		|	АвансовыйОтчет.Номенклатура,
		|	АвансовыйОтчет.Номенклатура.НаименованиеПолное,
		|	АвансовыйОтчет.НомерВходящегоДокумента,
		|	АвансовыйОтчет.ДатаВходящегоДокумента,
		|	АвансовыйОтчет.Контрагент,
		|	АвансовыйОтчет.ВидДокВходящий,
		|	ВЫРАЗИТЬ(АвансовыйОтчет.Содержание КАК СТРОКА(1000)),
		|	АвансовыйОтчет.СчетЗатрат,
		|	ВЫБОР
		|		КОГДА АвансовыйОтчет.Субконто1 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА АвансовыйОтчет.Субконто1.Счет8Класса
		|		КОГДА АвансовыйОтчет.Субконто2 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА АвансовыйОтчет.Субконто2.Счет8Класса
		|		КОГДА АвансовыйОтчет.Субконто3 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА АвансовыйОтчет.Субконто3.Счет8Класса
		|		ИНАЧЕ NULL
		|	КОНЕЦ,
		|	АвансовыйОтчет.НалоговоеНазначение,
		|	АвансовыйОтчет.СуточныеДатаС,
		|	АвансовыйОтчет.СуточныеДатаПо,
		|	АвансовыйОтчет.СчетУчетаНДС";

		ЗапросТовары.Выполнить();
		
		// Свертка сумм по документам, подтверждающим расходы.
		ЗапросТовары.Текст =
		"ВЫБРАТЬ
		|	Номенклатура,
		|	НоменклатураПолное КАК НоменклатураПолное,
		|	Номер,
		|	Дата,
		|	Контрагент,
		|	ВидДокВходящий,
		|	Содержание,
		|	Счет,
		|	СчетЗатрат8Класса,
		|	СчетНДС,
		|	СУММА(ПоОтчету) КАК ПоОтчету,
		|	СУММА(СуммаНДС) КАК СуммаНДС,
		|	СУММА(СуммаНДСПропорциональноКредит) КАК СуммаНДСПропорциональноКредит,
		|	НалоговоеНазначение,
		|	СуточныеДатаС,
		|	СуточныеДатаПо,
		|	ВЫБОР
		|		КОГДА НЕ ЕСТЬNULL(СуточныеДатаС, &ПустаяДата) = &ПустаяДата
		|			ТОГДА СуточныеДатаС
		|		ИНАЧЕ Дата
		|	КОНЕЦ КАК ДатаДляСортировки
		|ИЗ 
		|	ДанныеАвансовогоОтчета
		|
		|СГРУППИРОВАТЬ ПО
		|	Номенклатура,
		|	НоменклатураПолное,
		|	Контрагент,
		|	Номер,
		|	Дата,
		|	ВидДокВходящий,
		|	Содержание,
		|	Счет,
		|	СчетЗатрат8Класса,
		|	СчетНДС,
		|	НалоговоеНазначение,
		|	СуточныеДатаС,
		|	СуточныеДатаПо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаДляСортировки,
		|	Номер
		|";
		
		Товар = ЗапросТовары.Выполнить().Выбрать();
		
		ДополнительныеПараметрыМакета.Вставить("КоличествоДокументов", Товар.Количество());
		ОбластьМакета.Параметры.Заполнить(ДополнительныеПараметрыМакета);
		ТабДокумент.Вывести(ОбластьМакета);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		Если Вариант04002014 Тогда
			ОбластьМакета.Параметры.ВалютаЗаголовокКолонки = ?(Шапка.ВалютаДокумента = мВалютаРегламентированногоУчета, "грн,коп.",Строка(Шапка.ВалютаДокумента));
		КонецЕсли; 
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим табличные части
		НомерСтроки   = 0;

		ИтогоПоОтчету        = 0;
		ИтогоПоОтчетуВВалюте = 0;
		СуммаВВалюте = 0;

		Пока Товар.Следующий() Цикл

			ОбластьСНДС = (НЕ(Товар.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность)
							 И НЕ (Товар.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность)
							 И (Товар.СуммаНДС > 0));
			ОбластьМакета = ?(ОбластьСНДС, Макет.ПолучитьОбласть("СтрокаСНДС"), Макет.ПолучитьОбласть("Строка"));

			ОбластьМакета.Параметры.Заполнить(Товар);
			
			НомерСтроки = НомерСтроки + 1;
			
			ОснованиеПлатежа = ?(НЕ ЗначениеЗаполнено(Товар.Контрагент),"",СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Контр. ""%1""", ?(ЗначениеЗаполнено(Товар.Контрагент.НаименованиеПолное),Товар.Контрагент.НаименованиеПолное, Товар.Контрагент.Наименование)));
			НазначениеПлатежа = ?(ЗначениеЗаполнено(Товар.Содержание), СокрЛП(Товар.Содержание), СокрЛП(Товар.НоменклатураПолное)); 
			
			ОснованиеПлатежа = ОснованиеПлатежа + ?(НЕ ЗначениеЗаполнено(НазначениеПлатежа),"",СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" за ""%1""", НазначениеПлатежа)); 
			
			Если (ЗначениеЗаполнено(Товар.ВидДокВходящий))
			 ИЛИ (ЗначениеЗаполнено(Товар.Номер))
			 ИЛИ (ЗначениеЗаполнено(Товар.Дата)) Тогда
				ОснованиеПлатежа = ОснованиеПлатежа + " на підставі док. ";
				ОснованиеПлатежа = ОснованиеПлатежа + ?(НЕ ЗначениеЗаполнено(Товар.ВидДокВходящий),""," """ + Товар.ВидДокВходящий + """");
				ОснованиеПлатежа = ОснованиеПлатежа + ?(НЕ ЗначениеЗаполнено(Товар.Номер),"",СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" № %1", Товар.Номер));
				ОснованиеПлатежа = ОснованиеПлатежа + ?(НЕ ЗначениеЗаполнено(Товар.Дата),"",СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" від %1", Формат(Товар.Дата, "ДЛФ=Д")));
			КонецЕсли;		    
			
			ОбластьМакета.Параметры.ОснованиеПлатежа = ОснованиеПлатежа;			
			
			ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
			
			Если ОбластьСНДС Тогда 
				Если Товар.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально Тогда
					Если Шапка.СуммаВключаетНДС Тогда
						ОбластьМакета.Параметры.СуммаБезНДС = Товар.ПоОтчету - Товар.СуммаНДСПропорциональноКредит;	
					Иначе
						ОбластьМакета.Параметры.СуммаБезНДС = Товар.ПоОтчету + Товар.СуммаНДС - Товар.СуммаНДСПропорциональноКредит;
					КонецЕсли;
					ОбластьМакета.Параметры.СуммаНДС = Товар.СуммаНДСПропорциональноКредит;
				Иначе
					ОбластьМакета.Параметры.СуммаБезНДС = Товар.ПоОтчету - ?(Шапка.СуммаВключаетНДС, Товар.СуммаНДС, 0);
					ОбластьМакета.Параметры.СуммаНДС = Товар.СуммаНДС;
				КонецЕсли;
			Иначе	
				ОбластьМакета.Параметры.СуммаБезНДС = Товар.ПоОтчету + ?(Шапка.СуммаВключаетНДС, 0, Товар.СуммаНДС);
			КонецЕсли;
			
			ИтогоПоОтчету = ИтогоПоОтчету + Товар.ПоОтчету 	+ ?(Шапка.СуммаВключаетНДС, 0, Товар.СуммаНДС);
			
			Если (ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8
					ИЛИ ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8и9)
						И (?(ЗначениеЗаполнено(Товар.Счет),Счет9Класса(Товар.Счет), Истина)  
						ИЛИ Товар.Счет = ПланыСчетов.Хозрасчетный.Производство
						ИЛИ Товар.Счет.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.Производство) 
						ИЛИ Товар.Счет = ПланыСчетов.Хозрасчетный.БракВПроизводстве
						ИЛИ Товар.Счет.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.БракВПроизводстве))
					
					Тогда
					
			  	СчетБУ = Товар.СчетЗатрат8Класса;
				
			Иначе
				СчетБУ = Товар.Счет;
			КонецЕсли;
			
			ОбластьМакета.Параметры.СчетБу = СчетБу;		
			
			Если ЗначениеЗаполнено(Товар.СуточныеДатаС) И ЗначениеЗаполнено(Товар.СуточныеДатаПо) Тогда
			
				Если Товар.СуточныеДатаС > Товар.СуточныеДатаПо Тогда	
					ОписаниеПериода = "Період заданий не вірно";
			    Иначе
					ОписаниеПериода = ПредставлениеПериода(НачалоДня(Товар.СуточныеДатаС), КонецДня(Товар.СуточныеДатаПо), "Л = "+Локализация.ОпределитьКодЯзыкаДляФормат("uk")+"; ФП = Истина");
				КонецЕсли;
				ОбластьМакета.Параметры.Дата = ОписаниеПериода;
			
			ИначеЕсли ЗначениеЗаполнено(Товар.Дата) Тогда
				
				ОбластьМакета.Параметры.Дата = Товар.Дата;
				
			КонецЕсли; 
			
			ТабДокумент.Вывести(ОбластьМакета);

		КонецЦикла;

		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.СуммаСНДС = ИтогоПоОтчету;
		ТабДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал авансовго отчета
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ТабДокумент.Вывести(ОбластьМакета);

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);

	КонецЦикла;
		
	ИспользованоМакетов = ?(КоличествоАО > 0, 1, 0) + ?(КоличествоАО_01012011 > 0, 1, 0) + 
							?(КоличествоАО_25012013 > 0, 1, 0) + ?(КоличествоАО_04022014 > 0, 1, 0) + 
							?(КоличествоАО_06112015 > 0, 1, 0) + ?(КоличествоАО_19042016 > 0, 1, 0)
							+ ?(КоличествоАО_01072023 > 0, 1, 0);
	Если ИспользованоМакетов = 1 Тогда
		Если КоличествоАО > 0 Тогда 
			ИмяМакета = "Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет";
		ИначеЕсли КоличествоАО_01012011 > 0  Тогда
			ИмяМакета = "Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет01012011";
		ИначеЕсли КоличествоАО_25012013 > 0 Тогда 
			ИмяМакета = "Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет25012013";
		ИначеЕсли КоличествоАО_04022014 > 0 Тогда 
			ИмяМакета = "Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет04022014";
		ИначеЕсли КоличествоАО_06112015 > 0 Тогда 
			ИмяМакета = "Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет06112015";
		ИначеЕсли КоличествоАО_19042016 > 0 Тогда 
			ИмяМакета = "Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет19042016";
		ИначеЕсли КоличествоАО_01072023 > 0 Тогда 
			ИмяМакета = "Документ.АвансовыйОтчет.ПФ_MXL_UK_АвансовыйОтчет01072023";
		КонецЕсли;
	КонецЕсли;  

	Возврат ТабДокумент;

КонецФункции // ПечатьАвансовогоОтчета()

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "ФизЛицо");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли