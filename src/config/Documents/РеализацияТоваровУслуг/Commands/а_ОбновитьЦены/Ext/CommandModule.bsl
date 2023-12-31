﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПоказатьВопрос(Новый ОписаниеОповещения("ОбнЦ_ОбновитьЦеныДалее", ЭтотОбъект, Новый Структура("ПараметрыВыполненияКоманды,ПараметрКоманды", ПараметрыВыполненияКоманды,ПараметрКоманды)),
		НСтр("ru = 'Обновить цены?
              |'; uk = 'Оновити ціни?'"),
		РежимДиалогаВопрос.ДаНет,
		,
		,
		НСтр("ru = 'Обновить цены?'; uk = 'Оновити ціни?'")
	);

КонецПроцедуры

&НаКлиенте
Процедура ОбнЦ_ОбновитьЦеныДалее(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да И ДопПараметры.Количество() > 0 Тогда

		Список = ПолучитьСписокТиповЦен(ПериодДокумента(ДопПараметры.ПараметрКоманды[0]));
		Если Список.Количество() Тогда
			Оповещение = Новый ОписаниеОповещения("ВыборТипаЦенДалее", ЭтотОбъект, ДопПараметры.ПараметрКоманды);
			
			Попытка
				ДопПараметры.ПараметрыВыполненияКоманды.Источник.ПоказатьВыборИзСписка(Оповещение, Список, ДопПараметры.ПараметрыВыполненияКоманды.Источник.Элементы.ФормаКоманднаяПанель);
			Исключение
				ДопПараметры.ПараметрыВыполненияКоманды.Источник.ПоказатьВыборИзСписка(Оповещение, Список, ДопПараметры.ПараметрыВыполненияКоманды.Источник.Элементы.ГруппаКоманднаяПанель);
			КонецПопытки;
		Иначе
			ВыборТипаЦенДалее(Неопределено, ДопПараметры.ПараметрКоманды);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПериодДокумента(Док)
	
	Возврат Док.а_Периоды;
	
КонецФункции

&НаКлиенте
Процедура ВыборТипаЦенДалее(Результат = Неопределено, ДопПараметры) Экспорт
	
	Кво = 1;
	Для Каждого Док Из ДопПараметры Цикл
		
		Состояние("Обробка документу",  Цел(100*Кво/ДопПараметры.Количество()), Док);
	
		ОбнЦ_ОбновитьЦеныНаСервере(Док, ?(не Результат = Неопределено, Результат.Значение, Неопределено));
		Кво = Кво + 1;
	КонецЦикла;
			
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокТиповЦен(Период)
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		Возврат Новый СписокЗначений;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТипыЦенНоменклатуры.а_Период КАК а_Период,
	               |	ТипыЦенНоменклатуры.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ТипыЦенНоменклатуры КАК ТипыЦенНоменклатуры
	               |ГДЕ
	               |	ТипыЦенНоменклатуры.а_Период = &Период";
	Запрос.УстановитьПараметр("Период", Период);
	
	М = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(М);
	
	Возврат Список;
	
КонецФункции

&НаСервере
Процедура ОбнЦ_ОбновитьЦеныНаСервере(Ссылка, ТипЦен)
	
	Об = Ссылка.ПолучитьОбъект();
	Об.ТипЦен = ?(не ТипЦен = Неопределено, ТипЦен, Об.ТипЦен);
	
	Для Каждого ТекущаяСтрока из Об.Товары Цикл
		Если Не ЗначениеЗаполнено(Об.ТипЦен) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(
				НСтр("ru = 'Не заполнен тип цен в документе %1'; uk = 'Не заповнено тип цін в документі %1'"),
				Об.Ссылка)
			);
			Продолжить;
		КонецЕсли;
		
		СрезЦен = РегистрыСведений.ЦеныНоменклатуры.ПолучитьПоследнее(Об.Дата,
			Новый Структура("ТипЦен, Номенклатура",
				Об.ТипЦен,
				ТекущаяСтрока.Номенклатура)
		);
		
		Если Не ЗначениеЗаполнено(СрезЦен.Цена) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяСтрока.Цена = СрезЦен.Цена;
		
		
		СтрокаТаблицы = ТекущаяСтрока;
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТаблицы, 0);

		Попытка
			Если СтрокаТаблицы.СуммаНДС Или СтрокаТаблицы.СуммаНДС = 0 Тогда
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Об.СуммаВключаетНДС);
			КонецЕсли;
		Исключение
		КонецПопытки;

		Попытка
			Если СтрокаТаблицы.СуммаВРознице Или СтрокаТаблицы.СуммаВРознице = 0 Тогда
				СтрокаТаблицы.СуммаВРознице = СтрокаТаблицы.Количество * СтрокаТаблицы.ЦенаВРознице;
			КонецЕсли;
		Исключение
		КонецПопытки;		

		Попытка
			Если СтрокаТаблицы.Всего Или СтрокаТаблицы.Всего = 0 Тогда
				//Если УчитыватьНДС Тогда
					СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Об.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
				//Иначе
				//	СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма;	
				//КонецЕсли; 
			КонецЕсли;
		Исключение
		КонецПопытки;
		
		Попытка
			Если СтрокаТаблицы.СуммаНУ Или СтрокаТаблицы.СуммаНУ = 0 Тогда
				СтрокаТаблицы.СуммаНУ = СтрокаТаблицы.Сумма;		
			КонецЕсли;
		Исключение
		КонецПопытки;
		
		
		
	КонецЦикла;
	
	Попытка 
		Об.Записать(
			?(Об.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись),
			?(Об.Проведен, РежимПроведенияДокумента.Неоперативный, Неопределено)
		);
	Исключение
		Сообщить(СтрШаблон(НСтр("ru = 'обшика записи документа %1, %2'; uk = 'помилка запису документу %1, %2'")
			, Об.Ссылка, ОписаниеОшибки())
		);
	КонецПопытки;
	
КонецПроцедуры

