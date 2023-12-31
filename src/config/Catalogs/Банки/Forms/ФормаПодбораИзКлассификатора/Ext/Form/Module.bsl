﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дерево = Справочники.Банки.ПолучитьДеревоКлассификатора();	
	
	Дерево.Колонки.МФО.Имя = "Код";
	Дерево.Колонки.Добавить("Выбран",     Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Существует", Новый ОписаниеТипов("Булево"));
	
	Соответствие = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Банки.Код КАК Код
	|ИЗ
	|	Справочник.Банки КАК Банки";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Соответствие.Вставить(СокрЛП(Выборка.Код), СокрЛП(Выборка.Код));
	КонецЦикла;
	
	Для каждого СтрокаУровень1 Из Дерево.Строки Цикл
		Для каждого СтрокаУровень2 Из СтрокаУровень1.Строки Цикл
			Если Соответствие.Получить(СтрокаУровень2.Код) <> Неопределено Тогда
				СтрокаУровень2.Существует = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоКлассификатора");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ ДЕРЕВО КЛАССИФИКАТОРА

&НаКлиенте
Процедура ОбходДереваВверх(ТекущиеДанные)

	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда // Верхний уровень
		
		ДочерниеСтроки = Родитель.ПолучитьЭлементы();
		КоличествоВыбранных = 0;
		ОбщееКоличество = 0;
		Для каждого Элемент Из ДочерниеСтроки Цикл
			Если Элемент.Выбран = 2 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 0.5;
			ИначеЕсли Элемент.Выбран = 1 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 1;
			КонецЕсли;
			ОбщееКоличество = ОбщееКоличество + 1;
		КонецЦикла;
		
		Если ОбщееКоличество = КоличествоВыбранных Тогда
			Родитель.Выбран = 1;
		ИначеЕсли КоличествоВыбранных = 0 Тогда
			Родитель.Выбран = 0;
		Иначе
			Родитель.Выбран = 2;
		КонецЕсли;
		
		ОбходДереваВверх(Родитель);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбходДереваВниз(ТекущиеДанные)
	
	ДочерниеСтроки = ТекущиеДанные.ПолучитьЭлементы();
	Для каждого Элемент Из ДочерниеСтроки Цикл
		Элемент.Выбран = ТекущиеДанные.Выбран;
		ОбходДереваВниз(Элемент);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранПриИзменении(ТекущиеДанные)
	
	Если ТекущиеДанные.Выбран = 2 Тогда
		ТекущиеДанные.Выбран = 0;
	КонецЕсли;
	
	ОбходДереваВверх(ТекущиеДанные);
	ОбходДереваВниз(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКлассификатораВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоКлассификатора.ТекущиеДанные;
	ВыбранПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	ОбработатьРезультатыПодбораНаСервере();
	ОповеститьОбИзменении(Тип("СправочникСсылка.Банки"));	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ОбработатьРезультатыПодбораНаСервере()
	
	МассивВыбранныхСтрок = Новый Массив;
	МассивКодов = Новый Массив;
	
	Дерево = РеквизитФормыВЗначение("ДеревоКлассификатора");
	Для каждого СтрокаУровень1 Из Дерево.Строки Цикл
		Если СтрокаУровень1.Выбран Тогда
			Для каждого СтрокаУровень2 Из СтрокаУровень1.Строки Цикл
				Если СтрокаУровень2.Выбран Тогда					
					Если СтрокаУровень2.Выбран И Не ПустаяСтрока(СтрокаУровень2.Код)Тогда
					
						МассивВыбранныхСтрок.Добавить(СтрокаУровень2);
						МассивКодов.Добавить(СтрокаУровень2.Код);
						
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Банки.Ссылка КАК Ссылка,
	|	ВЫРАЗИТЬ(Банки.Код КАК СТРОКА) КАК Код
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Код В (&МассивКодов)";
	
	Запрос.УстановитьПараметр("МассивКодов", МассивКодов);
	
	ТаблицаКлассификатор = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаКлассификатор Из ТаблицаКлассификатор Цикл
		СтрокаКлассификатор.Код = СокрЛП(СтрокаКлассификатор.Код);
	КонецЦикла;
	ТаблицаКлассификатор.Индексы.Добавить("Код");
	
	НачатьТранзакцию();
	
	Для каждого СтрокаДерева Из МассивВыбранныхСтрок Цикл
		
		НайденныйЭлемент = ТаблицаКлассификатор.Найти(СтрокаДерева.Код, "Код");
		Если НайденныйЭлемент <> Неопределено Тогда
			СправочникОбъект = НайденныйЭлемент.Ссылка.ПолучитьОбъект();
		Иначе
			СправочникОбъект = Справочники.Банки.СоздатьЭлемент();
		КонецЕсли;
		
		СсылкаРодитель =  Справочники.Банки.НайтиПоНаименованию(СтрокаДерева.Родитель.Наименование, Истина);
		Если НЕ ЗначениеЗаполнено(СсылкаРодитель) Тогда
			СправочникГруппа = Справочники.Банки.СоздатьГруппу();
			СправочникГруппа.Наименование = СтрокаДерева.Родитель.Наименование;
			СправочникГруппа.УстановитьНовыйКод();
			СправочникГруппа.Записать();
			СсылкаРодитель = СправочникГруппа.Ссылка;
		КонецЕсли;
		СправочникОбъект.Родитель = СсылкаРодитель;
		
		ЗаполнитьЗначенияСвойств(СправочникОбъект, СтрокаДерева, "Код, Наименование, КоррСчет, Город, Адрес, Телефоны, КодПоЕДРПОУ");
				
		СправочникОбъект.Записать();
	
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры
