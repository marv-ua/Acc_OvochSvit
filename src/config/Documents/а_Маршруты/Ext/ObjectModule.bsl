﻿Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	//ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	//Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
	//	И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
	//	ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	//КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	// регістр а_ДатаВывозаФакт
	Движения.а_ДатаВывозаФакт.Записывать = Истина;
	Для Каждого ТекСтрокаПунктыРазгрузки Из ПунктыРазгрузки Цикл
		Движение = Движения.а_ДатаВывозаФакт.Добавить();
		Движение.Объект = ТекСтрокаПунктыРазгрузки.Заявка;
		Движение.Идентификатор = ТекСтрокаПунктыРазгрузки.Идентификатор;
		Движение.ДатаОтгрузки = ТекСтрокаПунктыРазгрузки.ДатаОтгрузки;
		Движение.Водитель = ТекСтрокаПунктыРазгрузки.Водитель;
		Движение.Авто = ТекСтрокаПунктыРазгрузки.Авто;
		Движение.Прицеп = ТекСтрокаПунктыРазгрузки.Прицеп;
		Движение.Перевозчик = ТекСтрокаПунктыРазгрузки.Перевозчик;
		Движение.Период = Дата;//ТекСтрокаПунктыРазгрузки.ДатаОтгрузки;
		Движение.ГрузоподъемностьАвто = ТекСтрокаПунктыРазгрузки.ГрузоподъемностьАвто;
		
		// а_СтатусыЗаявок
		Менеджер = РегистрыСведений.а_СтатусыЗаявок.СоздатьМенеджерЗаписи();
		Менеджер.Период = ПериодНачало;
		Менеджер.Объект = ТекСтрокаПунктыРазгрузки.Заявка;
		Менеджер.Идентификатор = ТекСтрокаПунктыРазгрузки.Идентификатор;
		Менеджер.ТипСтатуса = Перечисления.а_ТипыСтатусов.СтатусВывоза;
		Менеджер.СтатусОбработан = ТекСтрокаПунктыРазгрузки.СтатусОбработан;
		Попытка
			Менеджер.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
		//КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	Для Каждого ТекСтрокаПунктыРазгрузки Из ПунктыРазгрузки Цикл
		Менеджер = РегистрыСведений.а_СтатусыЗаявок.СоздатьМенеджерЗаписи();
		Менеджер.Объект = ТекСтрокаПунктыРазгрузки.Заявка;
		Менеджер.Идентификатор = ТекСтрокаПунктыРазгрузки.Идентификатор;
		Менеджер.ТипСтатуса = Перечисления.а_ТипыСтатусов.СтатусВывоза;
		Менеджер.СтатусОбработан = Ложь;
		Попытка
			Менеджер.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры


Процедура ЗаполнитьМаршруты() Экспорт
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПериодОтгрузки", ПериодОтгрузки);
	Запрос.УстановитьПараметр("Регион", Регион);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата1", ПериодНачало);
	Запрос.УстановитьПараметр("Дата2", ПериодОкончание);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
					|	Заявка.Ссылка КАК Заявка,
					|	Заявка.ПунктРазгрузки КАК ПунктРазгрузки,
					|	Заявка.Контрагент КАК Контрагент,
					|	Заявка.Договор КАК Договор,
					|	Заявка.Идентификатор КАК Идентификатор,
					|	ЕСТЬNULL(Факт.ДатаОтгрузки, Заявка.ДатаОтгрузки) КАК ДатаОтгрузки,
					|	Заявка.Количество КАК Количество,
					|	Заявка.Организация КАК Организация,
					|	ЕСТЬNULL(Факт.Водитель, Заявка.Водитель) КАК Водитель,
					|	ЕСТЬNULL(Факт.Авто, Заявка.Авто) КАК Авто,
					|	ЕСТЬNULL(Факт.Прицеп, Заявка.Прицеп) КАК Прицеп,
					|	ЕСТЬNULL(Факт.Перевозчик, Заявка.Перевозчик) КАК Перевозчик,
					|	Заявка.КонтактноеЛицо КАК КонтактноеЛицо,
					|	Заявка.КонтактныеДанные КАК КонтактныеДанные,
					|	Заявка.Склад КАК Склад,
					|	Заявка.Обработано КАК Обработано,
					|	Заявка.Статус КАК Статус,
					|	Заявка.Регион КАК Регион,
					|	Заявка.СтадияОбработан КАК СтадияОбработан,
					|	Заявка.СтадияПечатьСклад КАК СтадияПечатьСклад,
					|	Заявка.СтадияГотовыеДокументы КАК СтадияГотовыеДокументы,
					|	Заявка.СтадияВыполнена КАК СтадияВыполнена,
					|	Заявка.Стадия5 КАК Стадия5,
					|	Заявка.Стадия6 КАК Стадия6,
					|	Заявка.ЗаказНаЗборку КАК ЗаказНаЗборку,
					|	ЕСТЬNULL(а_СтатусыЗаявок.СтатусОбработан, ЛОЖЬ) КАК СтатусОбработан,
					|	ЕСТЬNULL(Факт.ГрузоподъемностьАвто, Заявка.ПунктРазгрузки.Авто) КАК ГрузоподъемностьАвто
					|ПОМЕСТИТЬ ВТДанные
					|ИЗ
					|	Документ.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.ПунктыРазгрузки КАК Заявка
					|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.а_ЗаявкиКВывозу КАК ЗаявкиКВывозу
					|		ПО Заявка.Ссылка = ЗаявкиКВывозу.Объект
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.а_ДатаВывозаФакт.СрезПоследних(КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ), ) КАК Факт
					|		ПО Заявка.Идентификатор = Факт.Идентификатор
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.а_СтатусыЗаявок.СрезПоследних(КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ)) КАК а_СтатусыЗаявок
					|		ПО Заявка.Ссылка = а_СтатусыЗаявок.Объект
					|			И Заявка.Идентификатор = а_СтатусыЗаявок.Идентификатор
					|			И (а_СтатусыЗаявок.ТипСтатуса = ЗНАЧЕНИЕ(Перечисление.а_ТипыСтатусов.СтатусВывоза))
					|			И а_СтатусыЗаявок.СтатусОбработан
					|ГДЕ
					|	Заявка.Ссылка.ПериодОтгрузки = &ПериодОтгрузки
					|	И Заявка.Регион = &Регион
					|	И Заявка.Организация = &Организация
					|	И (Заявка.Ссылка.Дата МЕЖДУ ДОБАВИТЬКДАТЕ(&Дата1, МЕСЯЦ, -1) И ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ), ДЕНЬ, 6))
					|	И (ЕСТЬNULL(Факт.ДатаОтгрузки, Заявка.ДатаОтгрузки) МЕЖДУ &Дата1 И КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ))
					|
					|ОБЪЕДИНИТЬ ВСЕ
					|
					|ВЫБРАТЬ
					|	Факт.Объект,
					|	Заявка.ПунктРазгрузки,
					|	Заявка.Контрагент,
					|	Заявка.Договор,
					|	Факт.Идентификатор,
					|	ЕСТЬNULL(Факт.ДатаОтгрузки, Заявка.ДатаОтгрузки),
					|	Заявка.Количество,
					|	Заявка.Организация,
					|	ЕСТЬNULL(Факт.Водитель, Заявка.Водитель),
					|	ЕСТЬNULL(Факт.Авто, Заявка.Авто),
					|	ЕСТЬNULL(Факт.Прицеп, Заявка.Прицеп),
					|	ЕСТЬNULL(Факт.Перевозчик, Заявка.Перевозчик),
					|	Заявка.КонтактноеЛицо,
					|	Заявка.КонтактныеДанные,
					|	Заявка.Склад,
					|	Заявка.Обработано,
					|	Заявка.Статус,
					|	Заявка.Регион,
					|	Заявка.СтадияОбработан,
					|	Заявка.СтадияПечатьСклад,
					|	Заявка.СтадияГотовыеДокументы,
					|	Заявка.СтадияВыполнена,
					|	Заявка.Стадия5,
					|	Заявка.Стадия6,
					|	Заявка.ЗаказНаЗборку,
					|	ЕСТЬNULL(а_СтатусыЗаявок.СтатусОбработан, ЛОЖЬ),
					|	ЕСТЬNULL(Факт.ГрузоподъемностьАвто, Заявка.ПунктРазгрузки.Авто)
					|ИЗ
					|	РегистрСведений.а_ДатаВывозаФакт.СрезПоследних(, Регистратор = &Ссылка) КАК Факт
					|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.ПунктыРазгрузки КАК Заявка
					|		ПО (Заявка.Ссылка = Факт.Объект)
					|			И (Заявка.Идентификатор = Факт.Идентификатор)
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.а_СтатусыЗаявок.СрезПоследних(КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ)) КАК а_СтатусыЗаявок
					|		ПО Факт.Объект = а_СтатусыЗаявок.Объект
					|			И Факт.Идентификатор = а_СтатусыЗаявок.Идентификатор
					|			И (а_СтатусыЗаявок.ТипСтатуса = ЗНАЧЕНИЕ(Перечисление.а_ТипыСтатусов.СтатусВывоза))
					|			И а_СтатусыЗаявок.СтатусОбработан
					|ГДЕ
					|	Факт.Регистратор = &Ссылка
					|	И Заявка.Регион = &Регион
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ РАЗЛИЧНЫЕ Данные.* ИЗ ВТДанные КАК Данные
					|ВНУТРЕННЕЕ СОЕДИНЕНИЕ (
					|ВЫБРАТЬ
					|	МАКСИМУМ(Т.ДатаОтгрузки) КАК ДатаОтгрузки,
					|	Т.Идентификатор КАК Идентификатор
					|ИЗ
					|	ВТДанные КАК Т
					|
					|СГРУППИРОВАТЬ ПО
					|	Т.Идентификатор) КАК СрезПоДате
					|ПО СрезПоДате.ДатаОтгрузки = Данные.ДатаОтгрузки
					|И СрезПоДате.Идентификатор = Данные.Идентификатор
					|";
	
	Если Не ЗначениеЗаполнено(ПериодОтгрузки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Период отгрузки не заполнен - будет заполнено за все периоды.'; uk = 'Період відвантаження не заповнено - буде заповнено по всіх періодах.'"));
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Заявка.Ссылка.ПериодОтгрузки = &ПериодОтгрузки", "ИСТИНА");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Регион) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Регион не заполнен. Будет заполнено по всем регионам.'; uk = 'Регіон не заповнено. Буде заповнено по всіх регіонах.'"));
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Заявка.Регион = &Регион", "");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПериодНачало) И Не ЗначениеЗаполнено(ПериодОкончание) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Заявка.Ссылка.Дата МЕЖДУ ДОБАВИТЬКДАТЕ(&Дата1, НЕДЕЛЯ, -1) И ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ), ДЕНЬ, 6)", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЕСТЬNULL(Факт.ДатаОтгрузки, Заявка.ДатаОтгрузки) МЕЖДУ &Дата1 И КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ)", "");
	КонецЕсли;
	
	ПунктыРазгрузки.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры


