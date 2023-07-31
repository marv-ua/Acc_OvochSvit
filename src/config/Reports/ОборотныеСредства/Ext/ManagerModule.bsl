﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьВнешниеНаборыДанных,
							|ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки,
							|ИспользоватьРасширенныеПараметрыРасшифровки",
							Истина, Истина, Ложь, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Оборотные средства';uk='Обігові кошти'") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ПС = ПланыСчетов["Хозрасчетный"];
	
	
	Счет20      = ПС.ПроизводственныеЗапасы;
	Счет21      = ПС.ТекущиеБиологическиеАктивы;
	Счет22      = ПС.МалоценныеИБыстроизнашивающиесяПредметы;
	Счет23      = ПС.Производство;
	Счет24      = ПС.БракВПроизводстве;
	Счет25      = ПС.Полуфабрикаты;
	Счет26      = ПС.ГотоваяПродукция;
	Счет27      = ПС.ПродукцияСельскохозяйственногоПроизводства;
	Счет28      = ПС.Товары;
	Счет28_6    = ПС.НеоборотныеАктивыИГруппыВыбытияУдерживаемыеДляПродажи;
	
	Счет30      = ПС.Касса;
	Счет31      = ПС.СчетаВБанках;
	Счет33      = ПС.ПрочиеДенежныеСредства;
	Счет33_3    = ПС.ДенежныеСредстваВПутиВНациональнойВалюте;
	Счет33_4    = ПС.ДенежныеСредстваВПутиВИностраннойВалюте;
	
	Счет34      = ПС.КраткосрочныеВекселяПолученные;
	Счет35      = ПС.ТекущиеФинансовыеИнвестиции;
	
	Счет37_5    = ПС.РасчетыПоВозмещениюПричиненногоУщерба;
	
	
	ТаблицаРазделы = Новый ТаблицаЗначений;
	ТаблицаРазделы.Колонки.Добавить("Раздел");
	ТаблицаРазделы.Колонки.Добавить("Порядок");
	ТаблицаРазделы.Колонки.Добавить("Родитель");
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Раздел  = "ДенежныеСредства"; //НСтр("ru='Денежные средства';uk='Кошти'");
	НоваяСтрока.Порядок = 1;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Раздел  = "КраткосрочныеФинансовыеВложения"; //НСтр("ru='Краткосрочные финансовые вложения';uk='Короткострокові фінансові вкладення'");
	НоваяСтрока.Порядок = 2;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Раздел  = "ЗадолженностьПокупателей"; //НСтр("ru='Задолженность покупателей';uk='Заборгованість покупців'");
	НоваяСтрока.Порядок = 3;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Раздел  = "АвансыВыданные"; //НСтр("ru='Авансы выданные';uk='Аванси, що видано'");
	НоваяСтрока.Порядок = 4;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Родитель  = "Запасы"; //НСтр("ru='Запасы, в т.ч.';uk='Запаси, у т.ч.'");
	НоваяСтрока.Раздел    = "ПроизводственныеЗапасы"; //НСтр("ru='Производственные запасы';uk='Виробничі запаси'");
	НоваяСтрока.Порядок   = 5;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Родитель  = "Запасы"; //НСтр("ru='Запасы, в т.ч.';uk='Запаси, у т.ч.'");
	НоваяСтрока.Раздел    = "ТекущиеБиологическиеАктивы"; //НСтр("ru='Текущие биологические активы';uk='Поточні біологічні активи'");
	НоваяСтрока.Порядок   = 6;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Родитель  = "Запасы"; //НСтр("ru='Запасы, в т.ч.';uk='Запаси, у т.ч.'");
	НоваяСтрока.Раздел    = "НезавершенноеПроизводство"; //НСтр("ru='Незавершенное производство';uk='Незавершене виробництво'");
	НоваяСтрока.Порядок   = 7;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Родитель  = "Запасы"; //НСтр("ru='Запасы, в т.ч.';uk='Запаси, у т.ч.'");
	НоваяСтрока.Раздел    = "ГотоваяПродукция"; //НСтр("ru='Готовая продукция';uk='Готова продукція'");
	НоваяСтрока.Порядок   = 8;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Родитель  = "Запасы"; //НСтр("ru='Запасы, в т.ч.';uk='Запаси, у т.ч.'");
	НоваяСтрока.Раздел    = "Товары"; //НСтр("ru='Товары';uk='Товари'");
	НоваяСтрока.Порядок   = 9;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Родитель  = "Запасы"; //НСтр("ru='Запасы, в т.ч.';uk='Запаси, у т.ч.'");
	НоваяСтрока.Раздел    = "БракВПроизводстве"; //НСтр("ru='Брак в производстве';uk='Брак у виробництві'");
	НоваяСтрока.Порядок   = 10;
	
	НоваяСтрока = ТаблицаРазделы.Добавить();
	НоваяСтрока.Раздел    = "НедостачиКВзысканию"; //НСтр("ru='Недостачи к взысканию';uk='Недостачі до стягнення'");
	НоваяСтрока.Порядок   = 11;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Хозрасчетный.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Счета
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПроизводственныеЗапасы),ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТекущиеБиологическиеАктивы), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МалоценныеИБыстроизнашивающиесяПредметы), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Производство), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.БракВПроизводстве), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Полуфабрикаты), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ГотоваяПродукция), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПродукцияСельскохозяйственногоПроизводства), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Товары), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НеоборотныеАктивыИГруппыВыбытияУдерживаемыеДляПродажи), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Касса), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.СчетаВБанках), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеДенежныеСредства), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.КраткосрочныеВекселяПолученные), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТекущиеФинансовыеИнвестиции), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоВозмещениюПричиненногоУщерба))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХозрасчетныйОстаткиИОбороты.Период КАК Период,
	|	ХозрасчетныйОстаткиИОбороты.Счет КАК Счет,
	|	ХозрасчетныйОстаткиИОбороты.Организация КАК Организация,
	|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокДт КАК СуммаНачальныйОстатокДт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокКт КАК СуммаНачальныйОстатокКт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокДт КАК СуммаКонечныйОстатокДт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокКт КАК СуммаКонечныйОстатокКт
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Месяц,
	|			,
	|			Счет В
	|				(ВЫБРАТЬ
	|					Счета.Ссылка
	|				ИЗ
	|					Счета КАК Счета),
	|			,
	|			) КАК ХозрасчетныйОстаткиИОбороты
	|ИТОГИ
	|	СУММА(СуммаНачальныйОстатокДт),
	|	СУММА(СуммаНачальныйОстатокКт),
	|	СУММА(СуммаКонечныйОстатокДт),
	|	СУММА(СуммаКонечныйОстатокКт)
	|ПО
	|	Организация,
	|	Период,
	|	Счет ИЕРАРХИЯ";
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(
		ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
		
	Если Периодичность = 6 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Месяц", "День");
	ИначеЕсли Периодичность = 7 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Месяц", "Неделя");
	ИначеЕсли Периодичность = 8 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Месяц", "Декада");
	ИначеЕсли Периодичность = 10 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Месяц", "Квартал");
	ИначеЕсли Периодичность = 11 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Месяц", "Полугодие");
	ИначеЕсли Периодичность = 12 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Месяц", "Год");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&НачалоПериода", "");
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		Запрос.УстановитьПараметр("КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&КонецПериода", "");
	КонецЕсли;
	
	
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	
	МассивСтрокаДляУдаления = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаРезультат Цикл
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Счет) Тогда
			МассивСтрокаДляУдаления.Добавить(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаДляУдаления Из МассивСтрокаДляУдаления Цикл
		ТаблицаРезультат.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	ТаблицаРезультат.Свернуть("Период,Счет,Организация,СуммаНачальныйОстатокДт,СуммаНачальныйОстатокКт,СуммаКонечныйОстатокДт,СуммаКонечныйОстатокКт");
	
	ТаблицаОборотныеСредства = Новый ТаблицаЗначений;
	ТаблицаОборотныеСредства.Колонки.Добавить("Период"               , Новый ОписаниеТипов("Дата"));
	ТаблицаОборотныеСредства.Колонки.Добавить("Организация"          , Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаОборотныеСредства.Колонки.Добавить("СуммаНачальныйОстаток", Новый ОписаниеТипов("Число"));
	ТаблицаОборотныеСредства.Колонки.Добавить("СуммаКонечныйОстаток" , Новый ОписаниеТипов("Число"));
	ТаблицаОборотныеСредства.Колонки.Добавить("Порядок"              , Новый ОписаниеТипов("Число"));
	ТаблицаОборотныеСредства.Колонки.Добавить("Раздел"               , Новый ОписаниеТипов("Строка"));
	ТаблицаОборотныеСредства.Колонки.Добавить("Родитель"             , Новый ОписаниеТипов("Строка"));
	ТаблицаОборотныеСредства.Колонки.Добавить("Счет"                 , Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультат Цикл
		Счет = СтрокаТаблицы.Счет;
		
		// Краткосрочные финансовые вложения
		Если Счет = Счет34 ИЛИ Счет = Счет35 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[1], "Дт", 1);
			
			// Запасы (расчет составных частей)  
			// Сырье и материалы	
		ИначеЕсли Счет = Счет20 ИЛИ Счет = Счет22 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[4], "Дт", 1);
			
			// Животные на выращивании и откорме
		ИначеЕсли Счет = Счет21 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[5], "Дт", 1);
			
			// НЗП	
		ИначеЕсли Счет = Счет23 ИЛИ Счет = Счет25 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[6], "Дт", 1);
			
			// Готовая продукция
		ИначеЕсли Счет = Счет26 или Счет = Счет27 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[7], "Дт", 1);
			
			// Товары
		ИначеЕсли Счет = Счет28 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[8], "Дт", 1);
		ИначеЕсли Счет = Счет28_6 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[8], "Дт", -1);
			
			
			// Брак в производстве
		ИначеЕсли Счет = Счет24 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[9], "Дт", 1);
			
			// Недостачи к взысканию
		ИначеЕсли Счет = Счет37_5 Тогда
			ДобавитьСтрокуВТаблицу(ТаблицаОборотныеСредства, СтрокаТаблицы, ТаблицаРазделы[10], "Дт", 1);
			
		КонецЕсли;
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура("ОборотныеСредства", ТаблицаОборотныеСредства);
	
	Возврат ВнешниеНаборыДанных;
		                                
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	ИсключенныеСчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(1);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИсключенныеСчета", ИсключенныеСчета);

	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	ВыводитьДиаграмму = Неопределено;
	
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Таблица   = Неопределено;
	Диаграмма = Неопределено;
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл		
		Если ЭлементСтруктуры.Имя = "Таблица" Тогда
			Таблица = ЭлементСтруктуры;
		ИначеЕсли ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			Диаграмма = ЭлементСтруктуры;
		КонецЕсли;		
	КонецЦикла;
	
	Если Диаграмма <> Неопределено Тогда
		
		Если ВыводитьДиаграмму Тогда
			
			Диаграмма.Точки.Очистить();
			ГруппировкаПериод = Диаграмма.Точки.Добавить();
			ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
			ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
			ПолеГруппировки.НачалоПериода =	НачалоДня(ПараметрыОтчета.НачалоПериода);
			ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
			
			ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			// Группировка
			Диаграмма.Серии.Очистить();
			Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
				Если ПолеВыбраннойГруппировки.Использование Тогда
					Группировка = Диаграмма.Серии.Добавить();
					БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);				
					Прервать;
				КонецЕсли;
			КонецЦикла; 
			
		Иначе
			
			Диаграмма.Использование = ВыводитьДиаграмму;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Таблица <> Неопределено Тогда
		Таблица.Колонки.Очистить();
		ГруппировкаПериод = Таблица.Колонки.Добавить();
		ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
		ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
		ПолеГруппировки.НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
		ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
		
		ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
		// Группировка
		Таблица.Строки.Очистить();
		Группировка = Таблица.Строки;
		Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
			Если ПолеВыбраннойГруппировки.Использование Тогда
				Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
					Группировка = Группировка.Добавить();
				Иначе
					Группировка = Группировка.Структура.Добавить();
				КонецЕсли;
				БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ОборотныеСредства").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.ОбщиеПоказатели, "");
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;

КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("Периодичность"                    , 0);
	КоллекцияНастроек.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьДиаграмму"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;

КонецФункции

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
		
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
   	
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("Организация", ОтчетОбъект.Организация);
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
		
	Раздел        = Неопределено;
	Период        = Неопределено;
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ОтчетОбъект.Периодичность, ОтчетОбъект.НачалоПериода, ОтчетОбъект.КонецПериода);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);

 	Для Каждого Отбор Из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") тогда
			Если Отбор.Значение = NULL тогда
				Продолжить;
			КонецЕсли;
			
			Если Отбор.Поле = "Подразделение" Тогда
				Если ЗначениеЗаполнено(Отбор.Значение) И БухгалтерскиеОтчетыВызовСервераПовтИсп.ДоступностьУчетаПоПодразделениям() Тогда
					ДополнительныеСвойства.Вставить("Подразделение", Отбор.Значение);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			ИначеЕсли Отбор.Поле = "Организация" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.Значение);
			ИначеЕсли Отбор.Поле = "Период" Тогда
				Период = Отбор.Значение;
			ИначеЕсли  Отбор.Поле = "Раздел" Тогда
				Раздел = Отбор.Значение;
			Иначе
				Если Отбор.Иерархия Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			КонецЕсли;	
		ИначеЕсли ТипЗнч(Отбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизацииСОП###" Тогда
				Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
					Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
						ДополнительныеСвойства.Вставить("Организация"                      , ЭлементОтбора.ПравоеЗначение);
						ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Истина);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
				ДополнительныеСвойства.Вставить("Организация"                      , Отбор.ПравоеЗначение);
				ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Ложь);
			ИначеЕсли Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение") 
				И Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
				И БухгалтерскиеОтчетыВызовСервераПовтИсп.ДоступностьУчетаПоПодразделениям() Тогда
				ДополнительныеСвойства.Вставить("Подразделение", Отбор.ПравоеЗначение);
			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.ЛевоеЗначение, Отбор.ПравоеЗначение, Отбор.ВидСравнения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	НастройкиРасшифровки = Новый Структура;
	
	Если НРег(Раздел) = "денежные средства" Тогда
		Если Период <> Неопределено Тогда
			ДополнительныеСвойства.Вставить("Период", БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, Периодичность));
		Иначе
			ДополнительныеСвойства.Вставить("Период", ОтчетОбъект.КонецПериода);
		КонецЕсли;
		ДополнительныеСвойства.Вставить("КлючВарианта", "ОстаткиДенежныхСредств");
		
		СписокПунктовМеню = Новый СписокЗначений;
		СписокПунктовМеню.Добавить("ОстаткиДенежныхСредств", "Остатки денежных средств");
		
		НастройкиРасшифровки.Вставить("ОстаткиДенежныхСредств", ПользовательскиеНастройки);
		
	ИначеЕсли НРег(Раздел) = "задолженность покупателей" Тогда
		Если Период <> Неопределено Тогда
			ДополнительныеСвойства.Вставить("Период", БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, Периодичность));
		Иначе
			ДополнительныеСвойства.Вставить("Период", ОтчетОбъект.КонецПериода);
		КонецЕсли;
		ДополнительныеСвойства.Вставить("КлючВарианта", "ЗадолженностьПокупателейПоСрокамДолга");
		
		СписокПунктовМеню = Новый СписокЗначений;
		СписокПунктовМеню.Добавить("ЗадолженностьПокупателейПоСрокамДолга", "Задолженность покупателей по срокам долга");
		
		НастройкиРасшифровки.Вставить("ЗадолженностьПокупателейПоСрокамДолга", ПользовательскиеНастройки);
	Иначе
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеОбъекта, Адрес);
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ДобавитьСтрокуВТаблицу(Таблица, СтрокаТаблицы, Раздел, СторонаПроводки, Знак)
	
	НоваяСтрока = Таблица.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	НоваяСтрока.СуммаНачальныйОстаток = Знак * СтрокаТаблицы["СуммаНачальныйОстаток" + СторонаПроводки];
	НоваяСтрока.СуммаКонечныйОстаток  = Знак * СтрокаТаблицы["СуммаКонечныйОстаток" + СторонаПроводки];
	НоваяСтрока.Раздел    = Раздел.Раздел;
	НоваяСтрока.Родитель  = Раздел.Родитель;
	НоваяСтрока.Порядок   = Раздел.Порядок;
	
КонецПроцедуры
#КонецЕсли