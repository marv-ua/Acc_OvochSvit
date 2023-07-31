﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Сотрудник");
	
КонецПроцедуры

// Подсистема "Управление доступом"

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура Автозаполнение() Экспорт
	
	Отказ = Ложь;
	
    Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан сотрудник';uk='Не вказаний співробітник'"), ЭтотОбъект, "Сотрудник", "Объект", Отказ);
			
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана организация';uk='Не зазначена організація'"), ЭтотОбъект, "Организация", "Объект", Отказ);
			
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаНач) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана дата начала периода';uk='Не вказана дата початку періоду'"), ЭтотОбъект, "ДатаНач", "Объект", Отказ);
			
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаКон) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана дата окончания периода';uk='Не вказана дата закінчення періоду'"), ЭтотОбъект, "ДатаКон", "Объект", Отказ);
			
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	Если ВидСправки = Перечисления.ВидыСправокОДоходах.Произвольная Тогда
		АвтозаполнениеПроизвольная();
	//ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах Тогда	
	//	АвтозаполнениеСоцстрах();
	//ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Безработица Тогда	
	//	АвтозаполнениеБезработица();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия Тогда	
		АвтозаполнениеПенсия();	
	//ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия Тогда	
	//	АвтозаполнениеСубсидия();	
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.ДоходыИНалоги Тогда	
		АвтозаполнениеДоходыИНалоги();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия2015 Тогда	
		АвтозаполнениеСубсидия2015();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах2015 Тогда	
		АвтозаполнениеСоцстрах2015();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах2023 Тогда	
		АвтозаполнениеСоцстрах2023();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия2015 Тогда	
		АвтозаполнениеПенсия2015();	
	КонецЕсли;	

	Если Доходы.Количество() = 0 Тогда
		
		Сообщить(НСтр("ru='Не обнаружены данные для записи в табличную часть документа.';uk='Не виявлені дані для запису в табличну частину документа.'"), СтатусСообщения.Важное)
		
	КонецЕсли;
	
	//Дозаполним периоды
	ДатаТек = НачалоМесяца(ДатаНач);
	Пока ДатаТек <= ДатаКон Цикл
		СтрокаТЧ = Доходы.Найти(ДатаТек,"Период");
		Если СтрокаТЧ = Неопределено Тогда
			НС = Доходы.Добавить();
			НС.Период = ДатаТек;
			Если ВидСправки = Перечисления.ВидыСправокОДоходах.Безработица Тогда
				НС.КалендарныеДни = День(КонецМесяца(ДатаТек));
			КонецЕсли;	
		КонецЕсли;
		ДатаТек = ДобавитьМесяц(ДатаТек,1);
	КонецЦикла;
	Доходы.Сортировать("Период");

КонецПроцедуры //  Автозаполнение

Процедура АвтозаполнениеПроизвольная()
	Доходы.Очистить();
	ДоходыТекстЗапроса = 
	   "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	   |	ВЫБОР 
	   |		КОГДА НачисленияУдержанияПоСотрудникамОбороты.НачислениеУдержание ССЫЛКА ПланВидоврасчета.Начисления
	   |		ТОГДА НачисленияУдержанияПоСотрудникамОбороты.СуммаОборот
	   |		ИНАЧЕ 0
	   |	КОНЕЦ КАК Начислено,
	   |	ВЫБОР 
	   |		КОГДА НачисленияУдержанияПоСотрудникамОбороты.НачислениеУдержание ССЫЛКА ПланВидоврасчета.Удержания
	   |		ТОГДА НачисленияУдержанияПоСотрудникамОбороты.СуммаОборот
	   |		ИНАЧЕ 0
	   |	КОНЕЦ КАК Удержано,
	   |	НачисленияУдержанияПоСотрудникамОбороты.Период
	   |ПОМЕСТИТЬ ВТНачисленияИУдержания
	   |ИЗ
	   |	РегистрНакопления.НачисленияУдержанияПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц, ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация) КАК НачисленияУдержанияПоСотрудникамОбороты
	   |
	   |ОБЪЕДИНИТЬ ВСЕ
	   |
	   |ВЫБРАТЬ
	   |	0 КАК Начислено,
	   |	НДФЛПоСотрудникам.НалогОборот КАК Удержано,
	   |	НДФЛПоСотрудникам.Период
	   |ИЗ
	   |	РегистрНакопления.НДФЛПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц, ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация) КАК НДФЛПоСотрудникам
	   |
	   |ОБЪЕДИНИТЬ ВСЕ
	   |
	   |ВЫБРАТЬ
	   |	0 КАК Начислено,
	   |	ЕСВПоСотрудникам.СуммаОборот КАК Удержано,
	   |	ЕСВПоСотрудникам.Период
	   |ИЗ
	   |	РегистрНакопления.ЕСВПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц, ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация И СпособРасчета = &парамВзносы) КАК ЕСВПоСотрудникам
	   |;
	   |
	   |ВЫБРАТЬ
	   |	СУММА(НачисленияИУдержания.Начислено) КАК СовокупныйДоход,
	   |	СУММА(НачисленияИУдержания.Удержано) КАК Удержания,
	   |	СУММА(НачисленияИУдержания.Начислено - НачисленияИУдержания.Удержано) КАК СуммаКВыплате,
	   |	НачисленияИУдержания.Период
	   |ИЗ
	   |	ВТНачисленияИУдержания КАК НачисленияИУдержания
	   |СГРУППИРОВАТЬ ПО
	   |	НачисленияИУдержания.Период
	   |";

	Запрос = Новый Запрос(ДоходыТекстЗапроса);
	
	Запрос.УстановитьПараметр("парамФизическоеЛицо", Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("парамДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("парамДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("парамВзносы", Перечисления.СпособыРасчетаВзносов.Взносы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Строка = Доходы.Добавить();
		
		Строка.Период			= Выборка.Период;
		Строка.СовокупныйДоход	= Выборка.СовокупныйДоход;
		Строка.Удержания		= Выборка.Удержания;
		Строка.СуммаКВыплате	= Выборка.СуммаКВыплате;
	КонецЦикла;
	
КонецПроцедуры // АвтозаполнениеПроизвольная

Процедура АвтозаполнениеПенсия()
	
	Доходы.Очистить();
	ДоходыТекстЗапроса = 
	   "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	   |	ЕСВПоСотрудникам.Период КАК Период,
	   |	ЕСВПоСотрудникам.БазаОборот КАК БазаЕСВ,
	   |	ЕСВПоСотрудникам.БазаВзносаОборот КАК БазаВзносаЕСВ,
	   |	ЕСВПоСотрудникам.БазаДоначислениеОборот КАК БазаДоначисление,
	   |	0 КАК Выплачено
	   |ПОМЕСТИТЬ ВТНачисленияИУдержания	   
	   |ИЗ
	   |	РегистрНакопления.ЕСВПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц, ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация И СпособРасчета = &парамВзносыФОТ И ВидЕСВ В (&парамСписокПенсия)) КАК ЕСВПоСотрудникам
	   |;
	   |
	   |ВЫБРАТЬ
	   |	СУММА(НачисленияИУдержания.БазаЕСВ) КАК ВсегоОблагаемое,
	   |	СУММА(НачисленияИУдержания.БазаВзносаЕСВ-НачисленияИУдержания.БазаДоначисление) КАК РезультатВсего,
	   |	НачисленияИУдержания.Период
	   |ИЗ
	   |	ВТНачисленияИУдержания КАК НачисленияИУдержания
	   |СГРУППИРОВАТЬ ПО
	   |	НачисленияИУдержания.Период
	   |";
	
	
	Запрос = Новый Запрос(ДоходыТекстЗапроса);
	
	Запрос.УстановитьПараметр("парамФизическоеЛицо", Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("парамДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("парамДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("парамВзносыФОТ", Перечисления.СпособыРасчетаВзносов.ВзносыФОТ);
	
	СписокПенсия = Новый Массив(4);
	СписокПенсия[0]=(Перечисления.ВидыЕСВ.ОсновнаяЗарплата);
	СписокПенсия[1]=(Перечисления.ВидыЕСВ.Больничные);
	СписокПенсия[2]=(Перечисления.ВидыЕСВ.Декретные);
	СписокПенсия[3]=(Перечисления.ВидыЕСВ.ПоДоговорамГПХ);
	Запрос.УстановитьПараметр("парамСписокПенсия", СписокПенсия);
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Доходы.Загрузить(ТЗ);
	
КонецПроцедуры // АвтозаполнениеПенсия

Процедура АвтозаполнениеДоходыИНалоги()
	
	Запрос = Новый Запрос;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("парамФизическоеЛицо", Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("парамДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("парамДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("парамВзносы", Перечисления.СпособыРасчетаВзносов.Взносы);

	ДоходыТекстЗапроса = 
	   "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	   |	НДФЛПоСотрудникам.Период КАК Период,
	   |	СУММА(НДФЛПоСотрудникам.НалогОборот) КАК НДФЛ,
	   |	СУММА(НДФЛПоСотрудникам.ДоходОборот) КАК ДоходНДФЛ,
	   |	0 КАК Выплачено,
	   |	0 КАК ДоходВоенныйСбор,
	   |	0 КАК ВоенныйСбор,
	   |	СУММА(НДФЛПоСотрудникам.ДоходОборот) - СУММА(НДФЛПоСотрудникам.НалогОборот) КАК ДоходЗаВычетомНДФЛ
	   |ПОМЕСТИТЬ ВТНачисленияИУдержания
	   |ИЗ
	   |	РегистрНакопления.НДФЛПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц, ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация ) КАК НДФЛПоСотрудникам
	   |ГДЕ
	   |	НДФЛПоСотрудникам.ДоходНДФЛ.ВидСтавкиВоенныйСбор <> ДоходНДФЛ.ВидСтавкиРезидента
	   |СГРУППИРОВАТЬ ПО
	   |	НДФЛПоСотрудникам.Период
	   |
	   |ОБЪЕДИНИТЬ ВСЕ
	   |
	   |ВЫБРАТЬ 
	   |	НДФЛПоСотрудникам.Период КАК Период,
	   |	0 КАК НДФЛ,
	   |	0 КАК ДоходНДФЛ,
	   |	0 КАК Выплачено,
	   |	НДФЛПоСотрудникам.ДоходОборот КАК ДоходВоенныйСбор,
	   |	НДФЛПоСотрудникам.НалогОборот КАК ВоенныйСбор,
	   |	0 КАК ДоходЗаВычетомНДФЛ
	   |ИЗ
	   |	РегистрНакопления.НДФЛПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц, ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация ) КАК НДФЛПоСотрудникам
	   |ГДЕ
	   |	НДФЛПоСотрудникам.ДоходНДФЛ.ВидСтавкиВоенныйСбор = ДоходНДФЛ.ВидСтавкиРезидента
	   |ОБЪЕДИНИТЬ ВСЕ
	   |
	   |
	   |
	   |ВЫБРАТЬ
	   |	ВзаиморасчетыССотрудниками.ПериодВзаиморасчетов КАК Период,
	   |	0 КАК НДФЛ,
	   |	0 КАК ДоходНДФЛ,
	   |	ВзаиморасчетыССотрудниками.СуммаВзаиморасчетов КАК Выплачено,
   	   |	0,
	   |	0,
	   |	0
	   |ИЗ
	   |	РегистрНакопления.ВзаиморасчетыССотрудниками КАК ВзаиморасчетыССотрудниками
	   |ГДЕ
	   |	ВзаиморасчетыССотрудниками.ПериодВзаиморасчетов МЕЖДУ &парамДатаНач И &парамДатаКон
	   |    И ВзаиморасчетыССотрудниками.ФизическоеЛицо = &парамФизическоеЛицо
	   |    И ВзаиморасчетыССотрудниками.Организация = &парамОрганизация
	   |	И ВзаиморасчетыССотрудниками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	   |	И ВзаиморасчетыССотрудниками.КодОперации = ЗНАЧЕНИЕ(Перечисление.КодыОперацийВзаиморасчетыСРаботникамиОрганизаций.Выплата)
	   |	И ВзаиморасчетыССотрудниками.КодОперации <> ЗНАЧЕНИЕ(Перечисление.КодыОперацийВзаиморасчетыСРаботникамиОрганизаций.НДФЛ)
	   |;
	   |
	   |ВЫБРАТЬ
	   |	СУММА(НачисленияИУдержания.НДФЛ) КАК НДФЛ,
	   |	СУММА(НачисленияИУдержания.ДоходНДФЛ) КАК ДоходНДФЛ,
	   |	СУММА(НачисленияИУдержания.Выплачено) КАК Выплачено,
	   |	НачисленияИУдержания.Период,
	   |	СУММА(НачисленияИУдержания.ДоходВоенныйСбор) КАК ДоходВоенныйСбор,
	   |	СУММА(НачисленияИУдержания.ВоенныйСбор) КАК ВоенныйСбор,
	   |	СУММА(НачисленияИУдержания.ДоходЗаВычетомНДФЛ) КАК ДоходЗаВычетомНДФЛ
	   |ИЗ                                                  
	   |	ВТНачисленияИУдержания КАК НачисленияИУдержания
	   |СГРУППИРОВАТЬ ПО
	   |	НачисленияИУдержания.Период
	   |";

	
	
	Запрос.Текст = ДоходыТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	Колонки = Результат.Колонки;
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Строка = Доходы.Добавить();
		Строка.Период			= Выборка.Период;
		Строка.ДоходНДФЛ		= Выборка.ДоходНДФЛ;
		Строка.НДФЛ				= Выборка.НДФЛ;
		Строка.Выплачено		= Выборка.Выплачено;
		Строка.ДоходВоенныйСбор = Выборка.ДоходВоенныйСбор;
		Строка.ВоенныйСбор		= Выборка.ВоенныйСбор;
		Строка.ДоходЗаВычетомНДФЛ = Выборка.ДоходЗаВычетомНДФЛ;
		
	КонецЦикла;
	
КонецПроцедуры // АвтозаполнениеДоходыИНалоги

Процедура АвтозаполнениеСубсидия2015() Экспорт
	
	Доходы.Очистить();
	ДоходыТекстЗапроса = "
	 |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	 |  НДФЛ.НалоговыйПериод КАК Период,
	 |  ВЫБОР 
	 |   КОГДА НДФЛ.ДоходНДФЛ В (&парамВидыДоходовЗП)
	 |   ТОГДА НДФЛ.ДоходОборот 
	 |   ИНАЧЕ 0
	 |  КОНЕЦ КАК НачисленоЗП,
	 |  ВЫБОР 
	 |   КОГДА НДФЛ.ДоходНДФЛ В (&парамВидыДоходовЗП) ИЛИ НДФЛ.ДоходНДФЛ В (&парамВидыДоходовВС)
	 |   ТОГДА 0 
	 |   ИНАЧЕ НДФЛ.ДоходОборот
	 |  КОНЕЦ КАК НачисленоПрочее,
	 |  ВЫБОР 
	 |   КОГДА НДФЛ.ДоходНДФЛ В (&парамВидыДоходовЗП)
	 |   ТОГДА НДФЛ.НалогОборот 
	 |   ИНАЧЕ 0
	 |  КОНЕЦ КАК НДФЛ,
	 |  ВЫБОР 
	 |   КОГДА НДФЛ.ДоходНДФЛ В (&парамВидыДоходовЗП) ИЛИ НДФЛ.ДоходНДФЛ В (&парамВидыДоходовВС)
	 |   ТОГДА 0 
	 |   ИНАЧЕ НДФЛ.НалогОборот
	 |  КОНЕЦ КАК НДФЛПрочее
	 |ПОМЕСТИТЬ ВТНДФЛ
	 |ИЗ РегистрНакопления.НДФЛПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, ,ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация И НалоговыйПериод МЕЖДУ &парамДатаНач И &парамДатаКон) КАК НДФЛ
	 |;
	 |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ РАЗРЕШЕННЫЕ
     |		Удержания.Период КАК Период,
     |		Удержания.СуммаОборот КАК Алименты
	 |ПОМЕСТИТЬ ВТАлименты
	 |ИЗ РегистрНакопления.НачисленияУдержанияПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц,ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация И НачислениеУдержание ССЫЛКА ПланВидоврасчета.Удержания) КАК Удержания
     |ГДЕ
	 |	Удержания.НачислениеУдержание.КатегорияУдержания = &парамАлименты
	 |;
	 |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	ВложенныйЗапрос.Период КАК Период,
     |	СУММА(ВложенныйЗапрос.НачисленоЗП+ВложенныйЗапрос.НачисленоПрочее) КАК СовокупныйДоход,
     |	СУММА(ВложенныйЗапрос.НачисленоЗП) КАК НачисленоЗП,
     |	СУММА(ВложенныйЗапрос.НачисленоПрочее) КАК НачисленоПрочее,
	 |	СУММА(ВложенныйЗапрос.НДФЛ) КАК НДФЛ,
     |	СУММА(ВложенныйЗапрос.НДФЛПрочее) КАК НДФЛПрочее,
	 |	СУММА(ВложенныйЗапрос.Алименты) КАК Алименты
     |ИЗ
     |	(ВЫБРАТЬ
     |  	ТаблицаНДФЛ.Период КАК Период,
	 |  	ТаблицаНДФЛ.НачисленоЗП КАК НачисленоЗП,
	 |  	ТаблицаНДФЛ.НачисленоПрочее КАК НачисленоПрочее,
	 |  	ТаблицаНДФЛ.НДФЛ КАК НДФЛ,
	 |  	ТаблицаНДФЛ.НДФЛПрочее КАК НДФЛПрочее,
	 |  	0 КАК Алименты
     |	 ИЗ ВТНДФЛ КАК ТаблицаНДФЛ
     |	
     |	 ОБЪЕДИНИТЬ ВСЕ
     |	
     |	ВЫБРАТЬ
     |		ТаблицаАлименты.Период,
     |		0,
	 |		0,
	 |		0,
	 |		0,
     |		ТаблицаАлименты.Алименты
     |	ИЗ ВТАлименты КАК ТаблицаАлименты
     |) КАК ВложенныйЗапрос
     |
     |СГРУППИРОВАТЬ ПО
     |	ВложенныйЗапрос.Период";
						 
	Запрос = Новый Запрос(ДоходыТекстЗапроса);
	
	Запрос.УстановитьПараметр("парамФизическоеЛицо", Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("парамДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("парамДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("парамАлименты", Перечисления.КатегорииУдержаний.Алименты);
    ВидыДоходовЗП = Новый Массив();
	ВидыДоходовЗП.Добавить(Справочники.ВидыДоходовНДФЛ.Код01);
	Запрос.УстановитьПараметр("парамВидыДоходовЗП", ВидыДоходовЗП);
	Запрос.УстановитьПараметр("парамВидыДоходовВС", УчетНДФЛ.ЗначенияВоенныйСбор().ВидДоходаСписок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	Доходы.Загрузить(ТЗ);	
	
КонецПроцедуры //  Автозаполнение

Процедура АвтозаполнениеСоцстрах2015() Экспорт
	
	Доходы.Очистить();
	ДоходыТекстЗапроса = "
	 |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	 |  НАЧАЛОПЕРИОДА(ЕСВ.НалоговыйПериод,МЕСЯЦ) КАК Период,
	 |  СУММА(
	 |   ВЫБОР
	 |    КОГДА  ЕСВ.СпособРасчета = &парамВзносы ТОГДА 0
	 |    ИНАЧЕ ЕСВ.БазаВзноса-ЕСВ.БазаДоначисление
	 |	 КОНЕЦ ) КАК РезультатВсего,
	 |  СУММА(
	 |   ВЫБОР
	 |    КОГДА  ЕСВ.СпособРасчета = &парамВзносы ТОГДА ЕСВ.Сумма
	 |    ИНАЧЕ 0
	 |	 КОНЕЦ ) КАК РезультатВзносы,
	 |  МАКСИМУМ(
	 |   ВЫБОР
	 |    КОГДА  ЕСВ.СпособРасчета = &парамВзносы ТОГДА ЕСВ.Ставка
	 |    ИНАЧЕ 0
	 |	 КОНЕЦ ) КАК СтавкаВзносов,
	 |  ЕСВ.ВидЕСВ КАК ВидЕСВ
	 |ПОМЕСТИТЬ ВТЕСВ
	 |ИЗ РегистрНакопления.ЕСВПоСотрудникам КАК ЕСВ
	 |ГДЕ
	 |	ЕСВ.ФизическоеЛицо = &парамФизическоеЛицо
     |	И ЕСВ.НалоговыйПериод МЕЖДУ &парамДатаНач И &парамДатаКон
     |	И ЕСВ.Организация = &парамОрганизация
	 |	И ЕСВ.ВидЕСВ НЕ В (&парамВидыЕСВНеВключая)
	 |СГРУППИРОВАТЬ ПО
	 |  НАЧАЛОПЕРИОДА(ЕСВ.НалоговыйПериод,МЕСЯЦ),
	 |  ЕСВ.ВидЕСВ
	 |;
	 |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ РАЗРЕШЕННЫЕ
     |	Сотрудники.ДатаПриема КАК ДатаПриема,
     |	Сотрудники.ДатаУвольнения КАК ДатаУвольнения
	 |ПОМЕСТИТЬ ВТПриемУвольнение
	 |ИЗ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК Сотрудники
     |ГДЕ
     |	Сотрудники.Сотрудник = &Сотрудник
	 |;
     |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ 
     |	НАЧАЛОПЕРИОДА(Календарь.Дата,МЕСЯЦ) КАК Период,
     |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Календарь.Дата) КАК КалендарныеДниВсего
	 |ПОМЕСТИТЬ ВТКалендарныеДни
	 |ИЗ РегистрСведений.ДанныеПроизводственногоКалендаря КАК Календарь
	 |   ЛЕВОЕ СОЕДИНЕНИЕ ВТПриемУвольнение КАК ПриемУвольнение 
	 |   ПО ИСТИНА
     |ГДЕ
     |	Календарь.Дата МЕЖДУ &парамДатаНач И &парамДатаКон
	 |	И Календарь.ПроизводственныйКалендарь.Код = ""УК""
	 |	И Календарь.Дата >= ПриемУвольнение.ДатаПриема
	 |	И (Календарь.Дата <= ПриемУвольнение.ДатаУвольнения
	 |    ИЛИ ПриемУвольнение.ДатаУвольнения = ДАТАВРЕМЯ(1,1,1))
	 |СГРУППИРОВАТЬ ПО
	 |	НАЧАЛОПЕРИОДА(Календарь.Дата,МЕСЯЦ)
	 |;
	 |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |   КалендарныеДни.Период,
	 |   ВЫБОР
	 |		КОГДА ЕСТЬNULL(ЕСВ.ВидЕСВ,ЗНАЧЕНИЕ(Перечисление.ВидыЕСВ.ОсновнаяЗарплата)) = ЗНАЧЕНИЕ(Перечисление.ВидыЕСВ.ОсновнаяЗарплата)
	 | 		ТОГДА ЕСТЬNULL(КалендарныеДни.КалендарныеДниВсего,0)
	 | 		ИНАЧЕ 0 
	 |	КОНЕЦ КАК КалендарныеДни,
	 |  ЕСТЬNULL(ЕСВ.РезультатВсего,0) КАК РезультатВсего,
	 |  ЕСТЬNULL(ЕСВ.РезультатВзносы,0)	КАК РезультатВзносы,
	 |  ЕСТЬNULL(ЕСВ.СтавкаВзносов,0)*100 КАК СтавкаВзносов
	 |
	 |ИЗ ВТКалендарныеДни КАК КалендарныеДни
	 |   ЛЕВОЕ СОЕДИНЕНИЕ ВТЕСВ КАК ЕСВ
	 |   ПО КалендарныеДни.Период = ЕСВ.Период
	 |УПОРЯДОЧИТЬ ПО
	 |  КалендарныеДни.Период, ЕСВ.ВидЕСВ
	 |
	 |";
						 
	Запрос = Новый Запрос(ДоходыТекстЗапроса);
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("парамФизическоеЛицо", Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("парамДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("парамДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("парамВзносы", Перечисления.СпособыРасчетаВзносов.Взносы);
	ВидыЕСВНеВключая = Новый Массив();
	ВидыЕСВНеВключая.Добавить(Перечисления.ВидыЕСВ.Больничные);
	ВидыЕСВНеВключая.Добавить(Перечисления.ВидыЕСВ.Декретные);
	ВидыЕСВНеВключая.Добавить(Перечисления.ВидыЕСВ.НачисленияМобилизованным);
	Запрос.УстановитьПараметр("парамВидыЕСВНеВключая", ВидыЕСВНеВключая);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	Доходы.Загрузить(ТЗ);	
	
КонецПроцедуры //  Автозаполнение

Процедура АвтозаполнениеСоцстрах2023() Экспорт
	
	Доходы.Очистить();
	ДоходыТекстЗапроса = "
	 |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	 |  НАЧАЛОПЕРИОДА(ЕСВ.НалоговыйПериод,МЕСЯЦ) КАК Период,
	 |  СУММА(
	 |   ВЫБОР
	 |    КОГДА  ЕСВ.СпособРасчета = &парамВзносы ТОГДА 0
	 |    ИНАЧЕ ЕСВ.БазаВзноса-ЕСВ.БазаДоначисление
	 |	 КОНЕЦ ) КАК РезультатВсего,
	 |  СУММА(
	 |   ВЫБОР
	 |    КОГДА  ЕСВ.СпособРасчета = &парамВзносы ТОГДА ЕСВ.Сумма
	 |    ИНАЧЕ 0
	 |	 КОНЕЦ ) КАК РезультатВзносы,
	 |  МАКСИМУМ(
	 |   ВЫБОР
	 |    КОГДА  ЕСВ.СпособРасчета = &парамВзносы ТОГДА ЕСВ.Ставка
	 |    ИНАЧЕ 0
	 |	 КОНЕЦ ) КАК СтавкаВзносов,
	 |  ЕСВ.ВидЕСВ КАК ВидЕСВ
	 |ПОМЕСТИТЬ ВТЕСВ
	 |ИЗ РегистрНакопления.ЕСВПоСотрудникам КАК ЕСВ
	 |ГДЕ
	 |	ЕСВ.ФизическоеЛицо = &парамФизическоеЛицо
     |	И ЕСВ.НалоговыйПериод МЕЖДУ &парамДатаНач И &парамДатаКон
     |	И ЕСВ.Организация = &парамОрганизация
	 |	И ЕСВ.ВидЕСВ НЕ В (&парамВидыЕСВНеВключая)
	 |СГРУППИРОВАТЬ ПО
	 |  НАЧАЛОПЕРИОДА(ЕСВ.НалоговыйПериод,МЕСЯЦ),
	 |  ЕСВ.ВидЕСВ
	 |;
	 |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ РАЗРЕШЕННЫЕ
     |	Сотрудники.ДатаПриема КАК ДатаПриема,
     |	Сотрудники.ДатаУвольнения КАК ДатаУвольнения
	 |ПОМЕСТИТЬ ВТПриемУвольнение
	 |ИЗ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК Сотрудники
     |ГДЕ
     |	Сотрудники.Сотрудник = &Сотрудник
	 |;
     |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ 
     |	НАЧАЛОПЕРИОДА(Календарь.Дата,МЕСЯЦ) КАК Период,
     |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Календарь.Дата) КАК КалендарныеДниВсего
	 |ПОМЕСТИТЬ ВТКалендарныеДни
	 |ИЗ РегистрСведений.ДанныеПроизводственногоКалендаря КАК Календарь
	 |   ЛЕВОЕ СОЕДИНЕНИЕ ВТПриемУвольнение КАК ПриемУвольнение 
	 |   ПО ИСТИНА
     |ГДЕ
     |	Календарь.Дата МЕЖДУ &парамДатаНач И &парамДатаКон
	 |	И Календарь.ПроизводственныйКалендарь.Код = ""УК""
	 |	И Календарь.Дата >= ПриемУвольнение.ДатаПриема
	 |	И (Календарь.Дата <= ПриемУвольнение.ДатаУвольнения
	 |    ИЛИ ПриемУвольнение.ДатаУвольнения = ДАТАВРЕМЯ(1,1,1))
	 |СГРУППИРОВАТЬ ПО
	 |	НАЧАЛОПЕРИОДА(Календарь.Дата,МЕСЯЦ)
	 |;
	 |
	 |///////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |   КалендарныеДни.Период,
	 |   ВЫБОР
	 |		КОГДА ЕСТЬNULL(ЕСВ.ВидЕСВ,ЗНАЧЕНИЕ(Перечисление.ВидыЕСВ.ОсновнаяЗарплата)) = ЗНАЧЕНИЕ(Перечисление.ВидыЕСВ.ОсновнаяЗарплата)
	 | 		ТОГДА ЕСТЬNULL(КалендарныеДни.КалендарныеДниВсего,0)
	 | 		ИНАЧЕ 0 
	 |	КОНЕЦ КАК КалендарныеДни,
	 |  ЕСТЬNULL(ЕСВ.РезультатВсего,0) КАК РезультатВсего,
	 |  ЕСТЬNULL(ЕСВ.РезультатВзносы,0)	КАК РезультатВзносы,
	 |  ЕСТЬNULL(ЕСВ.СтавкаВзносов,0)*100 КАК СтавкаВзносов
	 |
	 |ИЗ ВТКалендарныеДни КАК КалендарныеДни
	 |   ЛЕВОЕ СОЕДИНЕНИЕ ВТЕСВ КАК ЕСВ
	 |   ПО КалендарныеДни.Период = ЕСВ.Период
	 |УПОРЯДОЧИТЬ ПО
	 |  КалендарныеДни.Период, ЕСВ.ВидЕСВ
	 |
	 |";
						 
	Запрос = Новый Запрос(ДоходыТекстЗапроса);
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("парамФизическоеЛицо", Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("парамДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("парамДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("парамВзносы", Перечисления.СпособыРасчетаВзносов.Взносы);
	ВидыЕСВНеВключая = Новый Массив();
	ВидыЕСВНеВключая.Добавить(Перечисления.ВидыЕСВ.Больничные);
	ВидыЕСВНеВключая.Добавить(Перечисления.ВидыЕСВ.Декретные);
	ВидыЕСВНеВключая.Добавить(Перечисления.ВидыЕСВ.НачисленияМобилизованным);
	Запрос.УстановитьПараметр("парамВидыЕСВНеВключая", ВидыЕСВНеВключая);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	Доходы.Загрузить(ТЗ);	
	
КонецПроцедуры //  Автозаполнение

Процедура АвтозаполнениеПенсия2015()
	
	Доходы.Очистить();
	ДоходыТекстЗапроса = 
	   "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	   |	ЕСВПоСотрудникам.Период КАК Период,
	   |	ЕСВПоСотрудникам.БазаОборот КАК БазаЕСВ,
	   |	ЕСВПоСотрудникам.БазаВзносаОборот КАК БазаВзносаЕСВ,
	   |	ЕСВПоСотрудникам.БазаДоначислениеОборот КАК БазаДоначисление,
	   |	0 КАК Выплачено
	   |ПОМЕСТИТЬ ВТНачисленияИУдержания	   
	   |ИЗ
	   |	РегистрНакопления.ЕСВПоСотрудникам.Обороты(&парамДатаНач, &парамДатаКон, Месяц, ФизическоеЛицо = &парамФизическоеЛицо И Организация.Ссылка = &парамОрганизация И СпособРасчета = &парамВзносыФОТ И ВидЕСВ В (&парамСписокПенсия)) КАК ЕСВПоСотрудникам
	   |;
	   |
	   |ВЫБРАТЬ
	   |	СУММА(НачисленияИУдержания.БазаЕСВ) КАК ВсегоОблагаемое,
	   |	СУММА(НачисленияИУдержания.БазаВзносаЕСВ-НачисленияИУдержания.БазаДоначисление) КАК РезультатВсего,
	   |	НачисленияИУдержания.Период
	   |ИЗ
	   |	ВТНачисленияИУдержания КАК НачисленияИУдержания
	   |СГРУППИРОВАТЬ ПО
	   |	НачисленияИУдержания.Период
	   |";
	
	
	Запрос = Новый Запрос(ДоходыТекстЗапроса);
	
	Запрос.УстановитьПараметр("парамФизическоеЛицо", Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("парамДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("парамДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("парамВзносыФОТ", Перечисления.СпособыРасчетаВзносов.ВзносыФОТ);
	
	СписокПенсия = Новый Массив(4);
	СписокПенсия[0]=(Перечисления.ВидыЕСВ.ОсновнаяЗарплата);
	СписокПенсия[1]=(Перечисления.ВидыЕСВ.Больничные);
	СписокПенсия[2]=(Перечисления.ВидыЕСВ.Декретные);
	СписокПенсия[3]=(Перечисления.ВидыЕСВ.ПоДоговорамГПХ);
	Запрос.УстановитьПараметр("парамСписокПенсия", СписокПенсия);
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Доходы.Загрузить(ТЗ);
	
КонецПроцедуры // АвтозаполнениеПенсия2015

#КонецЕсли