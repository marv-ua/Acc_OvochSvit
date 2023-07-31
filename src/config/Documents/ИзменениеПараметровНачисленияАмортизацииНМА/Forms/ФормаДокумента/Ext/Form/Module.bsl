﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
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
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНематериальныхАктивов.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	
	СтруктураПараметров = Новый Структура;
	Если Объект.НМА.Количество() > 0 Тогда
		СтруктураПараметров.Вставить("АдресВХранилище", ПоместитьНМАВХранилище());
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодборНематериальныхАктивов.Форма.Форма", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаНМА(Команда)
	
	Если Объект.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Заполнение возможно только в непроведенном документе';uk='Заповнення можливе тільки в непроведеному документі'"), 60);
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация");
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны!
|Продолжить?';uk='При заповненні існуючі дані будуть перераховані!
|Продовжити?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьДляСпискаНМАЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаНМАЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьДляСпискаНМАСервер();

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиФормы

&НаКлиенте
Процедура НМАСпособНачисленияАмортизацииБУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Элемент.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивСпособовАмортизацииБУ());
КонецПроцедуры

&НаКлиенте
Процедура НМАСпособНачисленияАмортизацииНУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТЧ = Элементы.НМА.ТекущиеДанные;
	Элемент.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивСпособовАмортизацииНУ(СтрокаТЧ.СпособНачисленияАмортизацииБУ, Объект.Дата));
КонецПроцедуры


&НаКлиенте
Процедура НМАСпособНачисленияАмортизацииБУПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.НМА.ТекущиеДанные;
	
	Если Объект.Дата >= Дата('20200301') Тогда
		СтрокаТЧ.СпособНачисленияАмортизацииНУ = СтрокаТЧ.СпособНачисленияАмортизацииБУ;
	ИначеЕсли СтрокаТЧ.СпособНачисленияАмортизацииБУ <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Производственный") Тогда
		СтрокаТЧ.СпособНачисленияАмортизацииНУ = СтрокаТЧ.СпособНачисленияАмортизацииБУ;
	Иначе	
		СтрокаТЧ.СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Прямолинейный");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивСпособовАмортизацииБУ() Экспорт
                                                                                                        
	МассивСпособовАмортизации = Новый Массив;
	
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Прямолинейный);
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Производственный);
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УменьшенияОстатка);
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УскоренногоУменьшенияОстатка);
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Кумулятивный);
	
	Возврат МассивСпособовАмортизации;

КонецФункции // ПолучитьМассивСпособовАмортизацииБУ()

&НаСервереБезКонтекста
Функция ПолучитьМассивСпособовАмортизацииНУ(СпособАмортизацииБУ, ДатаИзменениеПараметров) Экспорт
                                                                                                        
	МассивСпособовАмортизации = Новый Массив;
	
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Прямолинейный);
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УменьшенияОстатка);
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УскоренногоУменьшенияОстатка);
	МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Кумулятивный);
	
	Если ДатаИзменениеПараметров >= Дата('20200301') 
			И СпособАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Производственный Тогда
		МассивСпособовАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Производственный);	
	КонецЕсли;
	
	Возврат МассивСпособовАмортизации;

КонецФункции // ПолучитьМассивСпособовАмортизацииБУ()


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента			= Объект.Дата;

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДляСпискаНМАСервер()
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВнешнийИсточник", Объект.НМА.Выгрузить());
	Запрос.УстановитьПараметр("Организация"	, Объект.Организация);
	Запрос.УстановитьПараметр("Период"		, Объект.Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
   	|	НематериальныйАктив
	|ПОМЕСТИТЬ НематериальныеАктивы
	|ИЗ &ВнешнийИсточник КАК ВнешнийИсточник
	|";
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	НематериальныеАктивы.НематериальныйАктив КАК НематериальныйАктив,
				   |	ПервоначальныеСведенияБУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизацииБУ,
				   |	ПервоначальныеСведенияБУ.СрокПолезногоИспользования КАК СрокПолезногоИспользованияБУ,
				   |	ПервоначальныеСведенияНУ.СрокПолезногоИспользования КАК СрокПолезногоИспользованияНУ,
				   |	ПервоначальныеСведенияНУ.СпособНачисленияАмортизации КАК СпособНачисленияАмортизацииНУ,
				   |	ПервоначальныеСведенияБУ.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимостьБУ,
				   |	ПервоначальныеСведенияБУ.СпособНачисленияАмортизации КАК СпособНачисленияАмортизацииБУ
	               |ИЗ
	               |	НематериальныеАктивы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(&Период, Организация = &Организация И НематериальныйАктив В (ВЫБРАТЬ НематериальныйАктив ИЗ НематериальныеАктивы)) КАК ПервоначальныеСведенияБУ
	               |		ПО НематериальныеАктивы.НематериальныйАктив = ПервоначальныеСведенияБУ.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАНалоговыйУчет.СрезПоследних(&Период, Организация = &Организация И НематериальныйАктив В (ВЫБРАТЬ НематериальныйАктив ИЗ НематериальныеАктивы)) КАК ПервоначальныеСведенияНУ
	               |		ПО НематериальныеАктивы.НематериальныйАктив = ПервоначальныеСведенияНУ.НематериальныйАктив
				   |";
		
	ТЗ = Запрос.Выполнить().Выгрузить();

	Для каждого СтрокаТЧ Из Объект.НМА Цикл

		СтрокаТЗ = ТЗ.Найти(СтрокаТЧ.НематериальныйАктив,"НематериальныйАктив");

		Если СтрокаТЗ = Неопределено Тогда
			
			СтрокаТЧ.СрокПолезногоИспользованияБУ                  	= 0;
			СтрокаТЧ.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ 	= 0;
			СтрокаТЧ.ЛиквидационнаяСтоимостьБУ                     	= 0;
			
			СтрокаТЧ.СрокПолезногоИспользованияНУ                  	= 0;
			
		Иначе

			СтрокаТЧ.СрокПолезногоИспользованияБУ                  	= СтрокаТЗ.СрокПолезногоИспользованияБУ;
			СтрокаТЧ.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ 	= СтрокаТЗ.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ;
			СтрокаТЧ.ЛиквидационнаяСтоимостьБУ                     	= СтрокаТЗ.ЛиквидационнаяСтоимостьБУ;
			СтрокаТЧ.СпособНачисленияАмортизацииБУ                 	= СтрокаТЗ.СпособНачисленияАмортизацииБУ;
			
			СтрокаТЧ.СрокПолезногоИспользованияНУ                  	= СтрокаТЗ.СрокПолезногоИспользованияНУ;
			
			СтрокаТЧ.СпособНачисленияАмортизацииНУ                 	= СтрокаТЗ.СпособНачисленияАмортизацииНУ;
			
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьНМАВХранилище()

	ТаблицаНМА = Объект.НМА.Выгрузить(, "НомерСтроки, НематериальныйАктив");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаНМА);

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(Знач ВыбранноеЗначение)
	
	ДобавленныеСтроки = УправлениеНеоборотнымиАктивами.ОбработатьПодборНематериальныхАктивов(Объект.НМА, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
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

#КонецОбласти