﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список документов, которые регистрируются в журнале при указанном назначении использования.
// Из списка исключаются документы отключенные функциональными опциями.
//
// Параметры:
//  КлючНазначенияИспользования - Строка - вид ограничения на список метаданных.
//
// Возвращаемое значение:
//   Массив      - доступные объекты метаданных.
//
Функция СоставДокументов(КлючНазначенияИспользования = "") Экспорт
	
	Если КлючНазначенияИспользования = "ДокументыПоКонтрагенту" Тогда
		
		ТипыДокументовРазрешенные = КритерииОтбора.ДокументыПоКонтрагенту.СоставДокументов();
		
	ИначеЕсли КлючНазначенияИспользования = "ДокументыПоДоговоруКонтрагента" Тогда
		
		ТипыДокументовРазрешенные = КритерииОтбора.ДокументыПоДоговоруКонтрагента.СоставДокументов();
		
	ИначеЕсли КлючНазначенияИспользования = "ДокументыПокупателей"
	 Или КлючНазначенияИспользования = "ДокументыПоставщиков" Тогда
	 
		ТипыДокументов = СписокТиповПоНазначениюИспользования(КлючНазначенияИспользования);
		ТипыДокументовРазрешенные = Новый Массив;
		Для каждого ТипДокумента Из ТипыДокументов Цикл
			ТипыДокументовРазрешенные.Добавить(Метаданные.НайтиПоТипу(ТипДокумента));
		КонецЦикла;
		
	Иначе
		
		ТипыДокументовРазрешенные = Неопределено;
		
	КонецЕсли;
	
	СписокДокументов = Новый Массив;
	
	ДокументыЖурнала = Метаданные.ЖурналыДокументов.ЖурналОпераций.РегистрируемыеДокументы;
	Если ТипыДокументовРазрешенные <> Неопределено Тогда
		
		Для Каждого РегистрируемыйДокумент Из ТипыДокументовРазрешенные Цикл
			
			Если ДокументыЖурнала.Содержит(РегистрируемыйДокумент) <> Неопределено
			   И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(РегистрируемыйДокумент) Тогда
				СписокДокументов.Добавить(РегистрируемыйДокумент);
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого РегистрируемыйДокумент Из ДокументыЖурнала Цикл
			
			Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(РегистрируемыйДокумент) Тогда
				СписокДокументов.Добавить(РегистрируемыйДокумент);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СписокДокументов;
	
КонецФункции 

// Возвращает список типов документов, которые должны сейчас выводиться в журнале.
//
Функция СписокТиповПоНазначениюИспользования(КлючНазначенияИспользования) Экспорт
	
	СписокДокументов = Новый Массив;
	
	Если КлючНазначенияИспользования = "ДокументыПокупателей"
	 Или КлючНазначенияИспользования = "ДокументыКонтрагентов" Тогда
	 
	    СписокДокументов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.НалоговаяНакладная"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПокупателю")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.ПриходныйКассовыйОрдер"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.ОтчетКомиссионераОПродажах"));  
		СписокДокументов.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтПокупателя"));  
		СписокДокументов.Добавить(Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.РеализацияУслугПоПереработке")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.Приложение1КНалоговойНакладной")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.Приложение2КНалоговойНакладной")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.ПередачаНМА"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.ПередачаОС"));
	 
	КонецЕсли;
	
	Если КлючНазначенияИспользования = "ДокументыПоставщиков"
	 Или КлючНазначенияИспользования = "ДокументыКонтрагентов" Тогда
	 
	    СписокДокументов.Добавить(Тип("ДокументСсылка.ПоступлениеТоваровУслуг"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.ПоступлениеДопРасходов"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.СписаниеСРасчетногоСчета"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.РасходныйКассовыйОрдер"));
		СписокДокументов.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.ОтчетКомитентуОПродажах")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.ПлатежноеПоручение")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.ГТДИмпорт")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.ПоступлениеНМА")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПоставщика")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.Доверенность")); 
		СписокДокументов.Добавить(Тип("ДокументСсылка.РегистрацияВходящегоНалоговогоДокумента"));
	 
	КонецЕсли;
	
	Возврат СписокДокументов;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(Ссылка)";

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
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("НомерВходящегоДокумента", "НомерВходящегоДокумента");
	Результат.Вставить("ДатаВходящегоДокумента",  "ДатаВходящегоДокумента");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли