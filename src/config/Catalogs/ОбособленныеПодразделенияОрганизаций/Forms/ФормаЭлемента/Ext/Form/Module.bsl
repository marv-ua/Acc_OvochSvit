﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указан владелец обособленного подразделения!';uk='Не вказаний власник відокремленого підрозділу!'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ОбновитьИнформациюОбОтветственныхЛицах();
	
	Элементы.ВсеОтветственныеЛица.Доступность = НЕ ТолькоПросмотр;
	Элементы.Руководитель.Доступность = НЕ ТолькоПросмотр;
	Элементы.ГлавныйБухгалтер.Доступность = НЕ ТолькоПросмотр;
	Элементы.Кассир.Доступность = НЕ ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ПередЗаписьюСервер()
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюСервер()
	
	// преобразуем так как это необходимо для формирования номера налоговых накладных: 1 -> 0001 (только числа)
	Попытка
		
		ПрефиксЧисловой = Число(Объект.Префикс);
		Если ПрефиксЧисловой < 0  Тогда
			ПрефиксЧисловой = - ПрефиксЧисловой;
		КонецЕсли;
		
		Объект.Префикс = Формат(ПрефиксЧисловой,"ЧЦ=4; ЧВН=; ЧГ=" );
		
	Исключение
		
		Объект.Префикс = "";
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	НаименованиеПриИзмененииСервер()
КонецПроцедуры

&НаСервере
Процедура НаименованиеПриИзмененииСервер()
	
	Если ПустаяСтрока(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.НаименованиеДляНалоговыхДокументов) Тогда
		Объект.НаименованиеДляНалоговыхДокументов = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРуководителяНажатие(Элемент, СтандартнаяОбработка)
	Перем ОтветственноеЛицо;
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОтветственноеЛицо	= ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Руководитель");
	
	ЗначенияЗаполнения	= Новый Структура("СтруктурнаяЕдиница,ОтветственноеЛицо",
		Объект.Ссылка,
		ОтветственноеЛицо);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",					РуководительКлючЗаписи);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения",	ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеГлавногоБухгалтераНажатие(Элемент, СтандартнаяОбработка)
	Перем ОтветственноеЛицо;
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОтветственноеЛицо	= ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер");
	
	ЗначенияЗаполнения	= Новый Структура("СтруктурнаяЕдиница,ОтветственноеЛицо",
		Объект.Ссылка,
		ОтветственноеЛицо);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",					ГлавныйБухгалтерКлючЗаписи);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения",	ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКассираНажатие(Элемент, СтандартнаяОбработка)
	Перем ОтветственноеЛицо;
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОтветственноеЛицо	= ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Кассир");
	
	ЗначенияЗаполнения	= Новый Структура("СтруктурнаяЕдиница,ОтветственноеЛицо",
		Объект.Ссылка,
		ОтветственноеЛицо);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",					КассирКлючЗаписи);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения",	ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ВсеОтветственныеЛица(Команда)
	
	Если Объект.Ссылка.Пустая() И НЕ Записать() Тогда
		Возврат;
	КонецЕсли;
		
	Отбор			= Новый Структура("СтруктурнаяЕдиница", Объект.Ссылка);
	ПараметрыФормы	= Новый Структура("Отбор", Отбор);
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаСписка", ПараметрыФормы);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьИнформациюОбОтветственныхЛицах()
	
	Руководитель		= НСтр("ru='Создать';uk='Створити'");
	ГлавныйБухгалтер	= НСтр("ru='Создать';uk='Створити'");
	Кассир				= НСтр("ru='Создать';uk='Створити'");
	
	РуководительКлючЗаписи		= РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч();
	ГлавныйБухгалтерКлючЗаписи	= РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч();
	КассирКлючЗаписи			= РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч();
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос	= Новый Запрос;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",	Объект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтветственныеЛицаОрганизацийСрезПоследних.Период КАК Период,
	|	ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	ПРЕДСТАВЛЕНИЕ(ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо) КАК ФизическоеЛицо,
	|	ПРЕДСТАВЛЕНИЕ(ОтветственныеЛицаОрганизацийСрезПоследних.Должность) КАК Должность,
	|	ВЫБОР
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель)
	|			ТОГДА ""Руководитель""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер)
	|			ТОГДА ""ГлавныйБухгалтер""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Кассир)
	|			ТОГДА ""Кассир""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ПредставлениеОтветственногоЛица
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних КАК ОтветственныеЛицаОрганизацийСрезПоследних
	|ГДЕ
	|	ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И (ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель)
	|			ИЛИ ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер)
	|			ИЛИ ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Кассир))";
	
	
	Отбор	= Новый Структура("Период, СтруктурнаяЕдиница, ОтветственноеЛицо");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ПустаяСтрока(Выборка.ПредставлениеОтветственногоЛица) Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементФормы	= ЭтаФорма.Элементы.Найти(Выборка.ПредставлениеОтветственногоЛица);
		Если ЭлементФормы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭтаФорма[Выборка.ПредставлениеОтветственногоЛица]	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 (%2)';uk='%1 (%2)'"),
			Выборка.ФизическоеЛицо, Выборка.Должность);
		
		ЗаполнитьЗначенияСвойств(Отбор, Выборка);
		ЭтаФорма[Выборка.ПредставлениеОтветственногоЛица + "КлючЗаписи"]	= РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьКлючЗаписи(Отбор);
		
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОтветственныхЛиц" Тогда
		ОбновитьИнформациюОбОтветственныхЛицах()
	КонецЕсли;
	
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

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
