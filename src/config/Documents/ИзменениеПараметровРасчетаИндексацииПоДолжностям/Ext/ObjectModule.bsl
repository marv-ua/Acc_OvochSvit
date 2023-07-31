﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ЗаполнитьПоШтатнойРасстановке(Организация, ДатаАктуальности) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаАктуальности", ДатаАктуальности);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	КадроваяИсторияСотрудников.Подразделение КАК Подразделение,
		|	КадроваяИсторияСотрудников.Должность КАК Должность
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК КадроваяИсторияСотрудников
		|ГДЕ
		|	КадроваяИсторияСотрудников.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|
		|УПОРЯДОЧИТЬ ПО
		|	КадроваяИсторияСотрудников.Подразделение.Наименование,
		|	КадроваяИсторияСотрудников.Должность.Наименование";
		
	ШтатныеЕдиницы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

// Подсистема "Управление доступом"

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//

Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
 
 ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "");
 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ДанныеДляПроведения = ДанныеДляПроведения();
	
	Если ДанныеДляПроведения.Количество() > 0 Тогда
		Движения.ПараметрыРасчетаИндексации.Записывать = Истина;
	КонецЕсли; 
		
	Движения.ПараметрыРасчетаИндексации.Загрузить(ДанныеДляПроведения);

	Если ДополнительныеСвойства.Свойство("ОтключитьПроверкуДатыЗапретаИзменения")
		И ДополнительныеСвойства.ОтключитьПроверкуДатыЗапретаИзменения Тогда
		
		Движения.ПараметрыРасчетаИндексации.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		
	КонецЕсли;
 
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	УдалитьДокументОснование = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры // ОбработкаЗаполнения()


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = ШтатныеЕдиницы.Выгрузить();
	
	ДанныеДляПроведения.Колонки.Добавить("Организация");
	ДанныеДляПроведения.ЗаполнитьЗначения(Организация, "Организация"); 
	
	ДанныеДляПроведения.Колонки.Добавить("Период");
	Для Каждого СтрокаТаблицы Из ДанныеДляПроведения Цикл
		СтрокаТаблицы.Период = СтрокаТаблицы.ДатаИзменения;		       	
	КонецЦикла;
	
	Возврат ДанныеДляПроведения
	
КонецФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.КадровыйПеревод") Тогда
		
		ДокументОснование = Основание;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаСобытия",ДокументОснование.ДатаНачала);
		Запрос.УстановитьПараметр("Сотрудник",ДокументОснование.Сотрудник);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КадроваяИсторияСотрудниковСрезПоследних.Подразделение,
		|	КадроваяИсторияСотрудниковСрезПоследних.Должность
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаСобытия, Сотрудник = &Сотрудник) КАК КадроваяИсторияСотрудниковСрезПоследних";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Организация = ДокументОснование.Организация;
			НС = ШтатныеЕдиницы.Добавить();
			НС.ДатаИзменения = ДокументОснование.ДатаНачала;
			НС.Подразделение = Выборка.Подразделение;
			НС.Должность = Выборка.Должность;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры	// ЗаполнитьПоДокументуОснованию
#КонецЕсли