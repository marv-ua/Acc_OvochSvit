﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получение данных о документах подсистемы зарплата
//
// Параметры:
//	Ведомости			- массив документов ВедомостьНаВыплатуЗарплаты
//	ФизическиеЛица		- массив элементов справочника ФизическиеЛица, чьи данные необходимо получить из ведомостей
//	ФормаРасчетов		- ПеречислениеСсылка.ФормыОплаты, определяющая, какие ведомости необходимо вернуть: наличные или безналичные
//	Регистратор			- ссылка на документ оплаты, для заполнения которого используется получение данных ведомостей, 
//							нужен для того, чтобы игнорировать движения
//
// Возвращаемое значение:
//	ТаблицаЗначений с колонками:
//		ФизическоеЛицо					- тип СправочникСсылка.ФизическиеЛица
//		СуммаКВыплате					- тип Число
//		КомпенсацияЗаЗадержкуЗарплаты	- тип Число
//		Ведомость						- тип ДокументСсылка.ВедомостьНаВыплатуЗарплаты
//
Функция ДанныеВедомостей(Ведомости, СпособВыплаты, ФизическиеЛица = Неопределено, Регистратор = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ведомости",			Ведомости);
	Запрос.УстановитьПараметр("ПоВсемФизлицам",		ФизическиеЛица = Неопределено);
	Запрос.УстановитьПараметр("ФизическиеЛица",		ФизическиеЛица);
	Запрос.УстановитьПараметр("СпособВыплаты",		СпособВыплаты);
	Запрос.УстановитьПараметр("Регистратор",		Регистратор);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(Основной.Сумма) КАК СуммаКВыплате,
	|	Основной.Ссылка КАК Ведомость,
	|	Основной.СчетУчета,
	|	Работники.Банк
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплаты.ПараметрыОплаты КАК Основной
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплаты.РаботникиОрганизации КАК Работники
	|		ПО (Работники.Ссылка = Основной.Ссылка)
	|			И (Работники.Физлицо = Основной.Физлицо)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОплатаВедомостейНаВыплатуЗарплаты КАК ОплатаВедомостейНаВыплатуЗарплаты
	|		ПО (ОплатаВедомостейНаВыплатуЗарплаты.Ведомость = Основной.Ссылка)
	|			И (ОплатаВедомостейНаВыплатуЗарплаты.ФизическоеЛицо = Основной.Физлицо)
	|			И (ОплатаВедомостейНаВыплатуЗарплаты.СчетУчета = Основной.СчетУчета)
	|			И (ОплатаВедомостейНаВыплатуЗарплаты.Регистратор <> &Регистратор)
	|ГДЕ
	|	Работники.Ссылка В(&Ведомости)
	|	И (&ПоВсемФизлицам
	|			ИЛИ Основной.Физлицо В (&ФизическиеЛица))
	|	И Работники.СпособВыплаты = &СпособВыплаты
	|	И Работники.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено)
	|	И ОплатаВедомостейНаВыплатуЗарплаты.ФизическоеЛицо ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	Основной.Ссылка,
	|	Основной.СчетУчета,
	|	Работники.Банк";

	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	|	ДляВсехСтрок( ЗначениеРазрешено(РаботникиОрганизации.ФизЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";

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

	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Ведомость на выплату зарплаты""';uk='Реєстр документів ""Відомість на виплату зарплати""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли