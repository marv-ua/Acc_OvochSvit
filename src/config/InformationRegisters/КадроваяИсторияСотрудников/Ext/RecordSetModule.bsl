﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
    Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
        Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		// Обновлять записи необходимо, только при записи набора, содержащего первичные данные
		Если ДополнительныеСвойства.Свойство("ЭтоВторичныйНабор") 
			И ДополнительныеСвойства.ЭтоВторичныйНабор Тогда
			Возврат;
		КонецЕсли;
		
		// Соберем информацию о сотрудниках, у которых меняются данные кадровой истории
	    Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		ИзмеренияДаты = Новый ТаблицаЗначений;
		ИзмеренияДаты.Колонки.Добавить("ДатаНачала", Новый ОписаниеТипов("Дата"));
		ИзмеренияДаты.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));
		СтрокаИзмеренияДаты = ИзмеренияДаты.Добавить();
		
		МассивСтруктурОтбора = Новый Массив;
		МассивСтруктурОтбора.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "=", Отбор.Регистратор.Значение.Ссылка));
		
		ЗарплатаКадры.СоздатьПоТаблицеЗначенийВТИмяРегистра(Запрос.МенеджерВременныхТаблиц, Истина, "КадроваяИсторияСотрудников", ИзмеренияДаты, МассивСтруктурОтбора);
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение.Ссылка);
		Запрос.УстановитьПараметр("Источник", Выгрузить());
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	НаборИсточник.Сотрудник
		|ПОМЕСТИТЬ ВТСохраняемыеЗначения
		|ИЗ
		|	&Источник КАК НаборИсточник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ВЫБОР
		|		КОГДА СохраняемыеЗначения.Сотрудник ЕСТЬ NULL 
		|			ТОГДА ПредыдущиеЗначения.Сотрудник
		|		ИНАЧЕ СохраняемыеЗначения.Сотрудник
		|	КОНЕЦ КАК Сотрудник
		|ИЗ
		|	ВТКадроваяИсторияСотрудников КАК ПредыдущиеЗначения
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТСохраняемыеЗначения КАК СохраняемыеЗначения
		|		ПО ПредыдущиеЗначения.Сотрудник = СохраняемыеЗначения.Сотрудник";
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ДополнительныеСвойства.Вставить("МассивСотрудниковДляОбновления", РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Сотрудник"));
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
    Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
        Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		// Обновлять записи необходимо, только при записи набора, содержащего первичные данные
		Если ДополнительныеСвойства.Свойство("ЭтоВторичныйНабор") 
			И ДополнительныеСвойства.ЭтоВторичныйНабор Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ДополнительныеСвойства.Свойство("МассивСотрудниковДляОбновления") 
			ИЛИ ДополнительныеСвойства.МассивСотрудниковДляОбновления.Количество() = 0 Тогда
			Возврат;
		КонецЕсли; 
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("МассивСотрудниковДляОбновления", ДополнительныеСвойства.МассивСотрудниковДляОбновления);
		
		// Подготовим таблицу ИзмеренияДаты для получения среза последних
		ИзмеренияДаты = Новый ТаблицаЗначений;
		ИзмеренияДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
		ИзмеренияДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
		
		Для Каждого Сотрудник Из ДополнительныеСвойства.МассивСотрудниковДляОбновления Цикл
			СтрокаИзмеренияДаты = ИзмеренияДаты.Добавить();
			СтрокаИзмеренияДаты.Сотрудник = Сотрудник;
		КонецЦикла;
		
		// Получим последние значения занятости
		ЗарплатаКадры.СоздатьПоТаблицеЗначенийВТИмяРегистраСрезПоследних(Запрос.МенеджерВременныхТаблиц, Истина, "КадроваяИсторияСотрудников", ИзмеренияДаты);
		
		// Подготовим таблицу ИзмеренияДаты Для получения информации о датах приема и увольнения
		ИзмеренияДаты.Колонки.Добавить("ДатаНачала", Новый ОписаниеТипов("Дата"));
		ИзмеренияДаты.Колонки.Период.Имя = "ДатаОкончания";
		
		// Сформируем отбор по события прием и увольнение
		СобытияПриемУвольнение = Новый Массив;
		СобытияПриемУвольнение.Добавить(Перечисления.ВидыКадровыхСобытий.Прием);
		СобытияПриемУвольнение.Добавить(Перечисления.ВидыКадровыхСобытий.Увольнение);
		
		МассивСтруктурОтбора = Новый Массив;
		МассивСтруктурОтбора.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","ВидСобытия","В", СобытияПриемУвольнение));
		
		// Получим таблицу событий прием и увольнения
		ЗарплатаКадры.СоздатьПоТаблицеЗначенийВТИмяРегистра(Запрос.МенеджерВременныхТаблиц, Истина, "КадроваяИсторияСотрудников", ИзмеренияДаты, МассивСтруктурОтбора);
		
		КадровыйУчетВнутренний.ОбновитьТекущиеКадровыеДанныеСотрудников(Запрос);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
