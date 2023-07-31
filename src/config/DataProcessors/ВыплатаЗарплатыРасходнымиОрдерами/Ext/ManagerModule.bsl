﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура Автозаполнение(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	Объект             = ПараметрыЗаполнения.Объект;
	ПлатежнаяВедомость = Объект.ПлатежнаяВедомость;
	
	ТекстЗапрос = 	
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗарплатаКВыплатеОрганизаций.ФизЛицо КАК ФизическоеЛицо,
	|	ЗарплатаКВыплатеОрганизаций.СчетУчета,
	|	ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Ссылка, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка), &ПустойРКО) КАК РКО,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Проведен, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.Проведен), ЛОЖЬ) = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Отметка,
	|	СУММА(ЗарплатаКВыплатеОрганизаций.Сумма) КАК Сумма
	|ПОМЕСТИТЬ ВТ_РасходныеДокументы
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплаты.ПараметрыОплаты КАК ЗарплатаКВыплатеОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплаты.РаботникиОрганизации КАК РаботникиОрганизации
	|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = РаботникиОрганизации.Ссылка
	|			И ЗарплатаКВыплатеОрганизаций.ФизЛицо = РаботникиОрганизации.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = РасходныйКассовыйОрдер.ПлатежнаяВедомость
	|			И ЗарплатаКВыплатеОрганизаций.ФизЛицо = РасходныйКассовыйОрдер.Контрагент
	|			И ЗарплатаКВыплатеОрганизаций.СчетУчета = РасходныйКассовыйОрдер.СчетУчетаРасчетовПоЗП
	|			И (РасходныйКассовыйОрдер.ВидОперации = &ВыплатаЗаработнойПлатыРаботнику)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер.ВыплатаЗаработнойПлаты КАК РасходныйКассовыйОрдерВыплатаЗаработнойПлаты
	|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ведомость
	|			И (РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.ВидОперации = &ВыплатаЗаработнойПлатыПоВедомостям)
	|ГДЕ
	|	РаботникиОрганизации.ВыплаченностьЗарплаты = &Выплачено
	|	И РаботникиОрганизации.СпособВыплаты = &ЧерезКассу
	|	И ЗарплатаКВыплатеОрганизаций.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОрганизаций.ФизЛицо,
	|	ЗарплатаКВыплатеОрганизаций.СчетУчета,
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Проведен, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.Проведен), ЛОЖЬ) = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗарплатаКВыплатеОрганизаций.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗарплатаКВыплатеОрганизаций.СчетУчета КАК СчетУчета,
	|	ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Ссылка, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка), &ПустойРКО) КАК РКО,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Проведен, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.Проведен), ЛОЖЬ) = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Отметка,
	|	СУММА(ЗарплатаКВыплатеОрганизаций.КВыплате) КАК Сумма
//	|ПОМЕСТИТЬ ВТ_РасходныеДокументы
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.ЗарплатаПодробно КАК ЗарплатаКВыплатеОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = РасходныйКассовыйОрдер.ПлатежнаяВедомость
	|			И ЗарплатаКВыплатеОрганизаций.ФизическоеЛицо = РасходныйКассовыйОрдер.Контрагент
	|			И ЗарплатаКВыплатеОрганизаций.СчетУчета = РасходныйКассовыйОрдер.СчетУчетаРасчетовПоЗП
	|			И (РасходныйКассовыйОрдер.ВидОперации = &ВыплатаЗаработнойПлатыРаботнику)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер.ВыплатаЗаработнойПлаты КАК РасходныйКассовыйОрдерВыплатаЗаработнойПлаты
	|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ведомость
	|			И ЗарплатаКВыплатеОрганизаций.СчетУчета = РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.СчетУчета
	|			И (РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.ВидОперации = &ВыплатаЗаработнойПлатыПоВедомостям)
	|ГДЕ
	|	ЗарплатаКВыплатеОрганизаций.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОрганизаций.ФизическоеЛицо,
	|	ЗарплатаКВыплатеОрганизаций.СчетУчета,
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Проведен, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.Проведен), ЛОЖЬ) = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_РасходныеДокументы.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТ_РасходныеДокументы.СчетУчета КАК СчетУчета,
	|	ВТ_РасходныеДокументы.РКО КАК РКО,
	|	ВТ_РасходныеДокументы.Отметка КАК Отметка,
	|	ВТ_РасходныеДокументы.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА ВТ_РасходныеДокументы.РКО = &ПустойРКО
	|			ТОГДА 3
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ВТ_РасходныеДокументы.РКО.Проведен
	|					ТОГДА 0
	|				КОГДА ВТ_РасходныеДокументы.РКО.ПометкаУдаления
	|					ТОГДА 1
	|				ИНАЧЕ 2
	|			КОНЕЦ
	|	КОНЕЦ КАК СостояниеДокумета
	|ИЗ
	|	ВТ_РасходныеДокументы КАК ВТ_РасходныеДокументы";	
	
	Запрос = Новый Запрос(ТекстЗапрос);
	Запрос.УстановитьПараметр("Ссылка",   ПлатежнаяВедомость);
	Запрос.УстановитьПараметр("ПустойРКО",Документы.РасходныйКассовыйОрдер.ПустаяСсылка());
	Запрос.УстановитьПараметр("Выплачено",Перечисления.ВыплаченностьЗарплаты.Выплачено);
	Запрос.УстановитьПараметр("ЧерезКассу",Перечисления.СпособыВыплатыЗарплаты.ЧерезКассу);
	Запрос.УстановитьПараметр("ВыплатаЗаработнойПлатыРаботнику",Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыРаботнику);
	Запрос.УстановитьПараметр("ВыплатаЗаработнойПлатыПоВедомостям",Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыПоВедомостям);
	         
	Объект.РКО = Запрос.Выполнить().Выгрузить();
	
	РезультатВыполнения = Новый Структура("Объект", Объект);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Процедура СоздатьРКО(ПараметрыСоздания, АдресХранилища) Экспорт
	
	Объект                        = ПараметрыСоздания.Объект;
	Организация                   = Объект.Организация;
	ПлатежнаяВедомость            = Объект.ПлатежнаяВедомость;
	СтатьяДвиженияДенежныхСредств = Объект.СтатьяДвиженияДенежныхСредств;
	ДатаРКО                       = Объект.ДатаРКО;
	РКО                           = Объект.РКО;
	
	ВалютаРегламентированногоУчета        = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Основание = "Платежная ведомость №" + ПлатежнаяВедомость.Номер + " от " + ПлатежнаяВедомость.Дата;
	
	СчетКасса = ПланыСчетов.Хозрасчетный.КассаВНациональнойВалюте;
	
	Для Каждого СтрокаТаблицы Из РКО Цикл
		
		Если СтрокаТаблицы.Отметка И НЕ ЗначениеЗаполнено(СтрокаТаблицы.РКО) Тогда
			
			ДокументРКО = Документы.РасходныйКассовыйОрдер.СоздатьДокумент();
			ДокументРКО.Дата		 		= ДатаРКО;
			ДокументРКО.ВидОперации			= Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыРаботнику;
			ДокументРКО.СуммаДокумента		= СтрокаТаблицы.Сумма;
			ДокументРКО.Контрагент			= СтрокаТаблицы.ФизическоеЛицо;
			ДокументРКО.ВалютаДокумента		= ВалютаРегламентированногоУчета;
			ДокументРКО.СчетКасса			= СчетКасса;
			ДокументРКО.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
			ДокументРКО.ПлатежнаяВедомость	= ПлатежнаяВедомость;
			ДокументРКО.СчетУчетаРасчетовПоЗП	= СтрокаТаблицы.СчетУчета;
			ДокументРКО.Основание			= Основание;
			ДокументРКО.Организация			= Организация;
			
		    ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ДокументРКО.Организация, ДокументРКО.Контрагент, ДокументРКО.Дата, Ложь);
			
			ДокументРКО.Выдать              =  ДанныеФизЛица.Представление;
			ДокументРКО.ПоДокументу         =  ДанныеФизЛица.ПредставлениеДокумента;
			
			ДокументРКО.Записать();
			
			СтрокаТаблицы.РКО	= ДокументРКО.Ссылка;
			СтрокаТаблицы.СостояниеДокумета	= 2;
						
		КонецЕсли;
		
	КонецЦикла;
	
	РезультатВыполнения = Новый Структура("Объект", Объект);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ПровестиРКО(ПараметрыПроведения, АдресХранилища) Экспорт

	Объект = ПараметрыПроведения.Объект;
	РКО    = Объект.РКО;
	
	Отказ = Ложь;

	Для Каждого СтрокаТаблицы Из РКО Цикл
		Если СтрокаТаблицы.Отметка и ЗначениеЗаполнено(СтрокаТаблицы.РКО) Тогда
			ДокументРКО = СтрокаТаблицы.РКО.ПолучитьОбъект();
			Если ДокументРКО.ПометкаУдаления Тогда
				ДокументРКО.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			Попытка
				ДокументРКО.Записать(РежимЗаписиДокумента.Проведение);
				СтрокаТаблицы.СостояниеДокумета	= 0;
			Исключение
				ТекстСообщения = НСтр("ru='Не удалось провести документ: %1';uk='Не вдалося провести документ: %1'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка(ДокументРКО));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			КонецПопытки;
			СтрокаТаблицы.Отметка = Не СтрокаТаблицы.Отметка;
		КонецЕсли;
	КонецЦикла;
	
	РезультатВыполнения = Новый Структура("Отказ, Объект", Отказ, Объект);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

#КонецЕсли