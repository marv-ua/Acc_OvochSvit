﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		Объект.ДатаНачала = ТекущаяДатаСеанса();
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Объект.Начисления.Очистить();
		КонецЕсли; 
		
		Если Параметры.Свойство("Сотрудник") И ЗначениеЗаполнено(Параметры.Сотрудник) Тогда 
			Объект.Сотрудник = Параметры.Сотрудник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			ЗаполнитьСоставОплатыТруда();
			УстановитьТекущиеКадровыеДанные();
		КонецЕсли;
		
		УстановитьФункциональныеОпцииФормы();
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УстановитьТекущиеКадровыеДанные();
	
	УстановитьФункциональныеОпцииФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	КадровыйУчетКлиент.ОповеститьОбИзмененииРабочегоМеста(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПодразделениеИДолжностьПриИзменении(Элемент)
	
	УстановитьДанныеРабочегоМеста(ЭтаФорма);
		
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
	УстановитьКомментарии();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменилисьНачисленияПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
	УстановитьКомментарии();
	
	Если НЕ Объект.ИзменитьНачисления Тогда
		ЗаполнитьСоставОплатыТруда();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы() 
	
	ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Объект.Организация);
	
	ПараметрыФО = Новый Структура("Организация", ГоловнаяОрганизация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	КадровыйУчетФормы.ЗаполнитьОтветственныхЛицПоОрганизации(ЭтаФорма);
	УстановитьФункциональныеОпцииФормы();
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ЗаполнитьСоставОплатыТруда();
	УстановитьТекущиеКадровыеДанные();
	
	УстановитьДанныеРабочегоМеста(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ЗаполнитьСоставОплатыТруда();
	
	УстановитьТекущиеКадровыеДанные();
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДанныеРабочегоМеста(Форма)
	
	Объект = Форма.Объект;
	
	Если Объект.ИзменитьПодразделениеИДолжность Тогда
		Объект.ОбособленноеПодразделение 	= Форма.ТекущееОбособленноеПодразделение;
		Объект.Подразделение 				= Форма.ТекущееПодразделение;
		Объект.Должность 					= Форма.ТекущаяДолжность;
		Объект.ВидЗанятости 				= Форма.ТекущийВидЗанятости;
 		Объект.ПринятНаНовоеРабочееМесто    = Форма.ТекущийПринятНаНовоеРабочееМесто;
	Иначе
		Объект.ОбособленноеПодразделение 	= ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
		Объект.Подразделение 				= ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
		Объект.Должность 					= ПредопределенноеЗначение("Справочник.Должности.ПустаяСсылка");
		Объект.ВидЗанятости 				= ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ПустаяСсылка");
 		Объект.ПринятНаНовоеРабочееМесто    = Ложь;
		Объект.ИзменениеДолжности		    = Ложь; 
	КонецЕсли;
   
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущиеКадровыеДанные()
	
	СтруктураОтбораКадровыхДанных = Новый Структура("ЛевоеЗначение, ВидСравнения, ПравоеЗначение", "Регистратор", "<>", Объект.Ссылка);
	Отбор = Новый Массив;
	Отбор.Добавить(СтруктураОтбораКадровыхДанных);
	
	ПоляОтбораПериодическихДанных = Новый Структура;
	ПоляОтбораПериодическихДанных.Вставить("КадроваяИсторияСотрудников", Отбор);
	Поля = "Подразделение,Должность,Организация,ВидЗанятости,ПринятНаНовоеРабочееМесто";
	
	ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, Объект.Сотрудник, Поля, НачалоДня(Объект.ДатаНачала) - 1, ПоляОтбораПериодическихДанных);
	
	Если ДанныеСотрудников.Количество() > 0 Тогда
		
		ТекущиеКадровыеДанныеСотрудника = ДанныеСотрудников[0];
		
		ТекущееОбособленноеПодразделение 	= ТекущиеКадровыеДанныеСотрудника.Организация;
		ТекущееПодразделение 				= ТекущиеКадровыеДанныеСотрудника.Подразделение;
		ТекущаяДолжность 					= ТекущиеКадровыеДанныеСотрудника.Должность;
		ТекущийВидЗанятости					= ТекущиеКадровыеДанныеСотрудника.ВидЗанятости;
		ТекущийПринятНаНовоеРабочееМесто    = ТекущиеКадровыеДанныеСотрудника.ПринятНаНовоеРабочееМесто;  
		
		Если Объект.ПредыдущаяДолжность <> ТекущаяДолжность Тогда
			 Объект.ПредыдущаяДолжность = ТекущаяДолжность;
		КонецЕсли;	
			
		
	КонецЕсли;	
	
	УстановитьКомментарии();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКомментарии()
	
	Если Объект.ИзменитьПодразделениеИДолжность Тогда
		
		Если ЗначениеЗаполнено(ТекущееПодразделение) Тогда
			
			ПозицияКомментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ранее сотрудник занимал должность ""%1"" в подразделении ""%2""';uk='Раніше співробітник обіймав посаду ""%1"" в підрозділі ""%2""'"),
				ТекущаяДолжность, ТекущееПодразделение); 
						
		Иначе
				
			ПозицияКомментарий = НСтр("ru='Сотрудник еще не принят на работу';uk='Співробітник ще не прийнятий на роботу'");
			
		КонецЕсли;
		
	Иначе
		
		ПозицияКомментарий = "";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоставОплатыТруда()
	
	Объект.Начисления.Очистить();
	Объект.Удержания.Очистить();
	Объект.КатегорияЕСВ = "";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	СтрокаСотрудник = ТаблицаСотрудников.Добавить();
	СтрокаСотрудник.Сотрудник = Объект.Сотрудник;
	СтрокаСотрудник.Период = ?(ЗначениеЗаполнено(Объект.ДатаНачала), НачалоДня(Объект.ДатаНачала) - 1, ТекущаяДатаСеанса());
	
	ЗарплатаКадры.СоздатьПоТаблицеЗначенийВТИмяРегистраСрезПоследних(
		Запрос.МенеджерВременныхТаблиц, 
		Истина,
		"ПлановыеНачисления",
		ТаблицаСотрудников);
		
	ЗарплатаКадры.СоздатьПоТаблицеЗначенийВТИмяРегистраСрезПоследних(
		Запрос.МенеджерВременныхТаблиц, 
		Истина,
		"ПлановыеУдержания",
		ТаблицаСотрудников);
		
	ЗарплатаКадры.СоздатьПоТаблицеЗначенийВТИмяРегистраСрезПоследних(
		Запрос.МенеджерВременныхТаблиц, 
		Истина,
		"ЕСВСотрудников",
		ТаблицаСотрудников);	
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлановыеНачисления.Начисление,
	|	ПлановыеНачисления.Размер
	|ИЗ
	|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
	|ГДЕ
	|	ПлановыеНачисления.Размер <> 0
	|УПОРЯДОЧИТЬ ПО
	|   ПлановыеНачисления.Начисление.КатегорияНачисленияИлиНеоплаченногоВремени, ПлановыеНачисления.Размер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПлановыеУдержания.Удержание,
	|	ПлановыеУдержания.Контрагент,
	|	ПлановыеУдержания.Размер
	|ИЗ
	|	ВТПлановыеУдержанияСрезПоследних КАК ПлановыеУдержания
	|ГДЕ
	|	ПлановыеУдержания.Размер <> 0
	|УПОРЯДОЧИТЬ ПО
	|   ПлановыеУдержания.Размер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСВСотрудников.КатегорияЕСВ
	|ИЗ
	|	ВТЕСВСотрудниковСрезПоследних КАК ЕСВСотрудников
	|ГДЕ
	|	ЕСВСотрудников.КатегорияЕСВ <> ЗНАЧЕНИЕ(Справочник.КатегорииЗастрахованныхЛицЕСВ.ПустаяСсылка)";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	Объект.Начисления.Загрузить(РезультатыЗапроса[0].Выгрузить());
	Объект.Удержания.Загрузить(РезультатыЗапроса[1].Выгрузить());
	ВыборкаЕСВ = РезультатыЗапроса[2].Выбрать();
	Если ВыборкаЕСВ.Следующий() Тогда
		Объект.КатегорияЕСВ = ВыборкаЕСВ.КатегорияЕСВ;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	ИзменитьПозициюДолжность		= Форма.Объект.ИзменитьПодразделениеИДолжность;
	ИзменитьНачисления				= Форма.Объект.ИзменитьНачисления;
	
	Форма.Элементы.Подразделение.Доступность = ИзменитьПозициюДолжность;
	Форма.Элементы.Должность.Доступность = ИзменитьПозициюДолжность;
	Форма.Элементы.ВидЗанятости.Доступность = ИзменитьПозициюДолжность;
	Форма.Элементы.ПринятНаНовоеРабочееМесто.Доступность = ИзменитьПозициюДолжность;
	Форма.Элементы.ИзменениеДолжности.Доступность = ИзменитьПозициюДолжность;
	Форма.Элементы.ОбособленноеПодразделение.Доступность = Ложь;
	
	Форма.Элементы.НачисленияУдержания.ТолькоПросмотр = НЕ ИзменитьНачисления;
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	Объект.ИзменениеДолжности = (ЭтаФорма.ТекущаяДолжность <> Объект.Должность);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
