﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    ДатаЦены = ТекущаяДата(); 
    ЗаполнитьТаблицуЦен()
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаполнитьЦены(НоменклатураЦен,ДатаЦен)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", ДатаЦен);
	Запрос.УстановитьПараметр("Ссылка", НоменклатураЦен);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТипыЦенНоменклатуры.Ссылка КАК ТипЦен,
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|	ЛОЖЬ КАК Записать,
	|	ВЫБОР
	|		КОГДА ЦеныНоменклатурыСрезПоследних.Валюта ЕСТЬ NULL 
	|			ТОГДА ТипыЦенНоменклатуры.ВалютаЦены
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.Валюта
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА ЦеныНоменклатурыСрезПоследних.Регистратор ЕСТЬ NULL 
	|			ТОГДА МАКСИМУМ(ЦеныНоменклатурыСрезПоследних1.Регистратор)
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.Регистратор
	|	КОНЕЦ КАК Документ
	|ИЗ
	|	Справочник.ТипыЦенНоменклатуры КАК ТипыЦенНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Номенклатура = &Ссылка) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.ТипЦен = ТипыЦенНоменклатуры.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, ) КАК ЦеныНоменклатурыСрезПоследних1
	|		ПО (ЦеныНоменклатурыСрезПоследних1.ТипЦен = ТипыЦенНоменклатуры.Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТипыЦенНоменклатуры.Ссылка,
	|	ЦеныНоменклатурыСрезПоследних.Цена,
	|	ЦеныНоменклатурыСрезПоследних.Валюта,
	|	ЦеныНоменклатурыСрезПоследних.Регистратор,
	|	ВЫБОР
	|		КОГДА ЦеныНоменклатурыСрезПоследних.Валюта ЕСТЬ NULL 
	|			ТОГДА ТипыЦенНоменклатуры.ВалютаЦены
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.Валюта
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТипыЦенНоменклатуры.Наименование";
	
	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СоздатьДокументЦен(ДатаЦены, Строка, Номенклатура)
    ДокументОбъект = Строка.Документ;
    Если Не ЗначениеЗаполнено(ДокументОбъект) Или НЕ ДатаЦены = ДокументОбъект.Дата Тогда
        ДокументОбъект = Документы.УстановкаЦенНоменклатуры.СоздатьДокумент();
        ДокументОбъект.Дата = НачалоДня(ДатаЦены);
        ДокументОбъект.ТипЦен = Строка.ТипЦен;
        СтрокаДокумента = ДокументОбъект.Товары.Добавить();
    Иначе
        ДокументОбъект = Строка.Документ.ПолучитьОбъект();
        
        Если ДокументОбъект.Товары.Найти(Номенклатура) = НЕОПРЕДЕЛЕНО Тогда
            СтрокаДокумента = ДокументОбъект.Товары.Добавить();
        Иначе
            СтрокаДокумента = ДокументОбъект.Товары.Найти(Номенклатура);
        КонецЕсли;
    КонецЕсли;    
    
    СтрокаДокумента.Номенклатура = Номенклатура;
    СтрокаДокумента.Цена = Строка.Цена;
    СтрокаДокумента.Валюта = Строка.Валюта;
    Попытка
        ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
    Исключение
        		
		ТекстСообщения = НСтр("ru='Не удалось создать документ для установки цен типа ""%1""';uk='Не вдалося створити документ для встановлення цін типу ""%1""'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.ТипЦен);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		ОписаниеОшибки = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание);
		
    КонецПопытки;
    
    
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЦены(Команда)
    СтрокиДляЗаписи = ЦеныНоменклатуры.НайтиСтроки(Новый Структура("Записать", Истина));
    
    ТекстСообщения = "";
	НачалоПредупреждения = НСтр("ru='Не указано значение цены для записи (тип цен ';uk= 'Не вказано значення ціни для запису (тип цін '");
    Для Каждого Строка Из СтрокиДляЗаписи Цикл
        Если Не ЗначениеЗаполнено(Строка.Цена) Тогда
            ТекстСообщения = ТекстСообщения + НачалоПредупреждения + Строка.ТипЦен + ")
            |";
        КонецЕсли;
    КонецЦикла;
    Если ЗначениеЗаполнено(ТекстСообщения) Тогда
        ПоказатьПредупреждение( , ТекстСообщения);
        Возврат;
    КонецЕсли;
    
    ЗаписатьЦеныНаСервере()
    
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЦеныНаСервере()
    
    СтрокиДляЗаписи = ЦеныНоменклатуры.НайтиСтроки(Новый Структура("Записать", Истина));
    Для Каждого Строка Из СтрокиДляЗаписи Цикл
        ДанныеСтроки = Новый Структура("ТипЦен,Цена,Валюта,Документ",Строка.ТипЦен,Строка.Цена,Строка.Валюта,Строка.Документ);
        СоздатьДокументЦен(ДатаЦены, ДанныеСтроки, Параметры.НоменклатураЦен);
    КонецЦикла;
    
    ЗаполнитьТаблицуЦен()
    
КонецПроцедуры

&НаКлиенте
Процедура ДатаЦенПриИзменении(Элемент)
    ЗаполнитьТаблицуЦен()
КонецПроцедуры

&НаСервере
Процедура  ЗаполнитьТаблицуЦен()
    
    Результат = ЗаполнитьЦены(Параметры.НоменклатураЦен, ДатаЦены); 
    ЗначениеВРеквизитФормы(Результат,"ЦеныНоменклатуры");
    
КонецПроцедуры


&НаКлиенте
Процедура ЦеныНоменклатурыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
    
    // После редактировании строки автоматически установим в этой строке флажок "Записать".
    Элементы.ЦеныНоменклатуры.ТекущиеДанные.Записать = Не ОтменаРедактирования;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЦены(Команда)
    ЗаполнитьТаблицуЦен()
КонецПроцедуры
