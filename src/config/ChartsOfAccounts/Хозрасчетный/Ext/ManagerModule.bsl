﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьСчетаИсключения() Экспорт
	
	МассивСчетовИсключений = Новый Массив;
	
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.ТорговаяНаценка);
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.ТоварыВТорговле);
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСРабочимиИСлужащимиПоДругимОперациям);
	
	Возврат Новый ФиксированныйМассив(МассивСчетовИсключений);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

Функция ПечатьПланаСчетов(ВыводитьОписания = Ложь)
	
	Макет = ПланыСчетов.Хозрасчетный.ПолучитьМакет("Описание");
	
	Шапка  = Макет.ПолучитьОбласть("Шапка");
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.Вывести(Шапка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИспользоватьВалютныйУчет", БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПланаСчетов.Ссылка КАК Ссылка,
	|	ТаблицаПланаСчетов.ЭтоГруппа КАК ЭтоГруппа,
	|	ТаблицаПланаСчетов.Ссылка.Код КАК Код,
	|	ТаблицаПланаСчетов.Ссылка.Наименование КАК Наименование,
	|	ТаблицаПланаСчетов.Ссылка.Валютный КАК Валютный,
	|	ТаблицаПланаСчетов.Ссылка.Количественный КАК Количественный,
	|	ТаблицаПланаСчетов.Ссылка.Забалансовый КАК Забалансовый,
	|	ТаблицаПланаСчетов.Ссылка.Вид КАК Вид,
	|	ТаблицаПланаСчетов.Ссылка.ВидыСубконто.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВидСубконто.Наименование КАК Наименование,
	|		ТолькоОбороты КАК ТолькоОбороты
	|	) КАК ВидыСубконто
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПланСчетов1.Ссылка КАК Ссылка,
	|		ВЫБОР
	|			КОГДА КОЛИЧЕСТВО(ПланСчетов2.Ссылка) > 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ЭтоГруппа
	|	ИЗ
	|		ПланСчетов.Хозрасчетный КАК ПланСчетов1
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК ПланСчетов2
	|			ПО ПланСчетов1.Ссылка = ПланСчетов2.Родитель
	|	ГДЕ
	|		ПланСчетов1.ПометкаУдаления = ЛОЖЬ
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПланСчетов1.Ссылка) КАК ТаблицаПланаСчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО (&ИспользоватьВалютныйУчет
	|				ИЛИ НЕ &ИспользоватьВалютныйУчет
	|					И НЕ ТаблицаПланаСчетов.Ссылка.Валютный)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаПланаСчетов.Ссылка.Порядок";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоГруппа Тогда
			Строка = Макет.ПолучитьОбласть("Группа");
		Иначе
			Строка = Макет.ПолучитьОбласть("Строка");
		КонецЕсли;
			
		Строка.Параметры.Заполнить(Выборка);
			
		Если Выборка.Вид = ВидСчета.Активный Тогда
			Строка.Параметры.Активность = "А";
		ИначеЕсли Выборка.Вид = ВидСчета.Пассивный Тогда
			Строка.Параметры.Активность = "П";
		Иначе
			Строка.Параметры.Активность = "АП";
		КонецЕсли;
		
		ВидыСубконто = Выборка.ВидыСубконто.Выбрать();
		Пока ВидыСубконто.Следующий() Цикл
			Строка.Параметры["Субконто" + ВидыСубконто.НомерСтроки] = ?(ВидыСубконто.ТолькоОбороты, "(об) ", "") + ВидыСубконто.Наименование;
		КонецЦикла;
			
		ТабДокумент.Вывести(Строка);
		
		Если ВыводитьОписания Тогда
		
			Попытка
				Описание = Макет.ПолучитьОбласть(ПланыСчетов[Выборка.Ссылка.Метаданные().Имя].ПолучитьИмяПредопределенного(Выборка.Ссылка));
				ТабДокумент.Вывести(Описание);
			Исключение
				// Запись в журнал регистрации не требуется
			КонецПопытки;
		
		КонецЕсли;
		
	КонецЦикла;
	
	ТабДокумент.ФиксацияСверху = 2;
	
	Возврат ТабДокумент;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
    // Устанавливаем признак доступности печати покомплектно.
    ПараметрыВывода.ДоступнаПечатьПоКомплектно = Ложь;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПростойСписок") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПростойСписок", НСтр("ru='Простой список';uk='Простий список'"), ПечатьПланаСчетов());                                            
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СПодробнымиОписаниями") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СПодробнымиОписаниями", НСтр("ru='С подробными описаниями';uk='З докладними описами'"), ПечатьПланаСчетов(Истина));                                            
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет() Тогда
		Параметры.Отбор.Вставить("Валютный", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли


