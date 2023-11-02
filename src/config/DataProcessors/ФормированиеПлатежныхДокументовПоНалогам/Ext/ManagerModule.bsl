﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура АвтозаполнениеПоВедомостям(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	Объект             = ПараметрыЗаполнения.Объект;
	ПлатежныеВедомости = Объект.ДокументыНачисления.ВыгрузитьКолонку("Ведомость");
	
	Если ПлатежныеВедомости.Количество() = 0 Тогда
		РезультатВыполнения = Новый Структура("Объект", Объект);
		ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	Запрос.УстановитьПараметр("ПлатежныеВедомости",   ПлатежныеВедомости);
	Запрос.УстановитьПараметр("Организация",   Объект.Организация);
	Запрос.УстановитьПараметр("ПустаяОрганизация",   Справочники.Организации.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойНалог",   Справочники.Налоги.ПустаяСсылка());
	Запрос.УстановитьПараметр("ВоенныйСбор",   УчетНДФЛ.ЗначенияВоенныйСбор().Налог);
	Запрос.УстановитьПараметр("ДоходВоенныйСбор",   УчетНДФЛ.ЗначенияВоенныйСбор().ВидДоходаСписок);
	Запрос.УстановитьПараметр("ПустаяСтатья",  Справочники.СтатьиНалоговыхДеклараций.ПустаяСсылка());
	
	Запрос.Текст = 	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗарплатаКВыплатеНДФЛ.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеНДФЛ.Налог КАК Сумма,
	|	&ПустойНалог КАК Налог,
	|	&ПустаяСтатья КАК Статья
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплаты.НДФЛ КАК ЗарплатаКВыплатеНДФЛ
	|ГДЕ
	|   ЗарплатаКВыплатеНДФЛ.Ссылка В (&ПлатежныеВедомости) 
	|   И НЕ ЗарплатаКВыплатеНДФЛ.ДоходНДФЛ В (&ДоходВоенныйСбор) 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеНДФЛ.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеНДФЛ.Налог КАК Сумма,
	|	&ПустойНалог КАК Налог,
	|	&ПустаяСтатья КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.НДФЛ КАК ЗарплатаКВыплатеНДФЛ
	|ГДЕ
	|   ЗарплатаКВыплатеНДФЛ.Ссылка В (&ПлатежныеВедомости)
	|   И НЕ ЗарплатаКВыплатеНДФЛ.ДоходНДФЛ В (&ДоходВоенныйСбор) 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеНДФЛ.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеНДФЛ.Налог КАК Сумма,
	|	&ПустойНалог КАК Налог,
	|	&ПустаяСтатья КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.НДФЛ КАК ЗарплатаКВыплатеНДФЛ
	|ГДЕ
	|   ЗарплатаКВыплатеНДФЛ.Ссылка В (&ПлатежныеВедомости)
	|   И НЕ ЗарплатаКВыплатеНДФЛ.ДоходНДФЛ В (&ДоходВоенныйСбор) 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеНДФЛ.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеНДФЛ.Налог КАК Сумма,
	|	&ПустойНалог КАК Налог,
	|	&ВоенныйСбор КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплаты.НДФЛ КАК ЗарплатаКВыплатеНДФЛ
	|ГДЕ
	|   ЗарплатаКВыплатеНДФЛ.Ссылка В (&ПлатежныеВедомости) 
	|   И ЗарплатаКВыплатеНДФЛ.ДоходНДФЛ В (&ДоходВоенныйСбор) 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеНДФЛ.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеНДФЛ.Налог КАК Сумма,
	|	&ПустойНалог КАК Налог,
	|	&ВоенныйСбор КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.НДФЛ КАК ЗарплатаКВыплатеНДФЛ
	|ГДЕ
	|   ЗарплатаКВыплатеНДФЛ.Ссылка В (&ПлатежныеВедомости)
	|   И ЗарплатаКВыплатеНДФЛ.ДоходНДФЛ В (&ДоходВоенныйСбор) 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеНДФЛ.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеНДФЛ.Налог КАК Сумма,
	|	&ПустойНалог КАК Налог,
	|	&ВоенныйСбор КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.НДФЛ КАК ЗарплатаКВыплатеНДФЛ
	|ГДЕ
	|   ЗарплатаКВыплатеНДФЛ.Ссылка В (&ПлатежныеВедомости)
	|   И ЗарплатаКВыплатеНДФЛ.ДоходНДФЛ В (&ДоходВоенныйСбор) 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеВзносы.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеВзносы.Результат КАК Сумма,
	|	ЗарплатаКВыплатеВзносы.Налог КАК Налог,
	|	ЗарплатаКВыплатеВзносы.СтатьяНалоговойДекларации КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплаты.Взносы КАК ЗарплатаКВыплатеВзносы
	|ГДЕ
	|   ЗарплатаКВыплатеВзносы.Ссылка В (&ПлатежныеВедомости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеВзносы.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеВзносы.Сумма КАК Сумма,
	|	ЗарплатаКВыплатеВзносы.Налог КАК Налог,
	|	ЗарплатаКВыплатеВзносы.СтатьяНалоговойДекларации КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Взносы КАК ЗарплатаКВыплатеВзносы
	|ГДЕ
	|   ЗарплатаКВыплатеВзносы.Ссылка В (&ПлатежныеВедомости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеВзносы.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеВзносы.Сумма КАК Сумма,
	|	ЗарплатаКВыплатеВзносы.Налог КАК Налог,
	|	ЗарплатаКВыплатеВзносы.СтатьяНалоговойДекларации КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.Взносы КАК ЗарплатаКВыплатеВзносы
	|ГДЕ
	|   ЗарплатаКВыплатеВзносы.Ссылка В (&ПлатежныеВедомости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеВзносы.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеВзносы.Результат КАК Сумма,
	|	ЗарплатаКВыплатеВзносы.Налог КАК Налог,
	|	ВЫБОР	
    |		КОГДА ЗарплатаКВыплатеВзносы.Ссылка.ФорматОбмена30
	|   		ТОГДА ЗарплатаКВыплатеВзносы.Налог
	|			ИНАЧЕ ЗарплатаКВыплатеВзносы.СтатьяНалоговойДекларации 
	|	КОНЕЦ КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплаты.ВзносыФОТ КАК ЗарплатаКВыплатеВзносы
	|ГДЕ
	|   ЗарплатаКВыплатеВзносы.Ссылка В (&ПлатежныеВедомости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеВзносы.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеВзносы.Сумма КАК Сумма,
	|	ЗарплатаКВыплатеВзносы.Налог КАК Налог,
	|	ЗарплатаКВыплатеВзносы.СтатьяНалоговойДекларации КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.ВзносыФОТ КАК ЗарплатаКВыплатеВзносы
	|ГДЕ
	|   ЗарплатаКВыплатеВзносы.Ссылка В (&ПлатежныеВедомости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеВзносы.Ссылка КАК Ведомость,
	|	ЗарплатаКВыплатеВзносы.Сумма КАК Сумма,
	|	ЗарплатаКВыплатеВзносы.Налог КАК Налог,
	|	ЗарплатаКВыплатеВзносы.СтатьяНалоговойДекларации КАК Статья
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.ВзносыФОТ КАК ЗарплатаКВыплатеВзносы
	|ГДЕ
	|   ЗарплатаКВыплатеВзносы.Ссылка В (&ПлатежныеВедомости)
	|;
	|
	|ВЫБРАТЬ
	|	СУММА(ДанныеДокументов.Сумма) КАК Сумма,
	|	ДанныеДокументов.Ведомость КАК Ведомость,
	|	ДанныеДокументов.Налог КАК Налог,
	|	ДанныеДокументов.Статья КАК Статья
	|ПОМЕСТИТЬ ВТДанныеДокументовСводно
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.Ведомость,
	|   ДанныеДокументов.Налог,
	|   ДанныеДокументов.Статья
	|;
	|
	|ВЫБРАТЬ
	|   ВЫБОР
	|    КОГДА Параметры.СтатьяНалоговойДекларации = НЕОПРЕДЕЛЕНО
	|    ТОГДА &ПустаяСтатья
	|    КОГДА Параметры.СтатьяНалоговойДекларации = &ПустойНалог
	|    ТОГДА &ПустаяСтатья
	|    ИНАЧЕ Параметры.СтатьяНалоговойДекларации 
	|   КОНЕЦ КАК Статья,
	|   Параметры.СчетУчета КАК СчетУчета,
	|   Параметры.Контрагент КАК Контрагент,
	|   Параметры.СчетКонтрагента КАК СчетКонтрагента
	|ПОМЕСТИТЬ ВТПараметрыДокументовОрганизация
	|ИЗ
	|	РегистрСведений.ПараметрыПлатежныхДокументовПоНалогам КАК Параметры
	|ГДЕ
	|   Параметры.Организация = &Организация
	|;
	|
	|ВЫБРАТЬ
	|   ВЫБОР
	|    КОГДА Параметры.СтатьяНалоговойДекларации = НЕОПРЕДЕЛЕНО
	|    ТОГДА &ПустаяСтатья
	|    КОГДА Параметры.СтатьяНалоговойДекларации = &ПустойНалог
	|    ТОГДА &ПустаяСтатья
	|    ИНАЧЕ Параметры.СтатьяНалоговойДекларации 
	|   КОНЕЦ КАК Статья,
	|   Параметры.СчетУчета КАК СчетУчета,
	|   Параметры.Контрагент КАК Контрагент,
	|   Параметры.СчетКонтрагента КАК СчетКонтрагента
	|ПОМЕСТИТЬ ВТПараметрыДокументов
	|ИЗ
	|	РегистрСведений.ПараметрыПлатежныхДокументовПоНалогам КАК Параметры
	|ГДЕ
	|   Параметры.Организация = &ПустаяОрганизация
	|;
	|
	|ВЫБРАТЬ
	|   ДанныеДокументов.Ведомость КАК Ведомость,
	|   ДанныеДокументов.Сумма КАК Сумма,
	|   ДанныеДокументов.Налог КАК Налог,
	|   ДанныеДокументов.Статья КАК Статья,
	|   ЕСТЬNULL(ПараметрыДокументовОрганизация.СчетУчета,ЕСТЬNULL(ПараметрыДокументов.СчетУчета,ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка))) КАК СчетУчета,
	|   ЕСТЬNULL(ПараметрыДокументовОрганизация.Контрагент,ЕСТЬNULL(ПараметрыДокументов.Контрагент,ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))) КАК Контрагент,
	|   ЕСТЬNULL(ПараметрыДокументовОрганизация.СчетКонтрагента,ЕСТЬNULL(ПараметрыДокументов.СчетКонтрагента,ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяСсылка))) КАК СчетКонтрагента
	|ПОМЕСТИТЬ ВТДанныеДокументовСПараметрами
	|ИЗ
	|	ВТДанныеДокументовСводно КАК ДанныеДокументов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВТПараметрыДокументовОрганизация КАК ПараметрыДокументовОрганизация
	|	ПО ДанныеДокументов.Статья = ПараметрыДокументовОрганизация.Статья
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВТПараметрыДокументов КАК ПараметрыДокументов
	|	ПО ДанныеДокументов.Статья = ПараметрыДокументов.Статья
	|ГДЕ	
	|	ДанныеДокументов.Сумма > 0
	|;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|   ПлатежныеДокументы.Ссылка КАК Платежка,
	|   ПлатежныеДокументы.Ведомость КАК Ведомость,
	|   ПлатежныеДокументы.Ссылка.СчетУчетаРасчетовСКонтрагентом КАК СчетУчета,
	|   ПлатежныеДокументы.Ссылка.Контрагент КАК Контрагент,
	|   ПлатежныеДокументы.Ссылка.СчетКонтрагента КАК СчетКонтрагента,
	|   ПлатежныеДокументы.Сумма КАК Сумма,
	|   ВЫБОР 
	|   	КОГДА ПлатежныеДокументы.СубконтоДт1 ССЫЛКА Справочник.Налоги И ПлатежныеДокументы.СубконтоДт1 <> &ВоенныйСбор ТОГДА ПлатежныеДокументы.СубконтоДт1 
	|   	КОГДА ПлатежныеДокументы.СубконтоДт2 ССЫЛКА Справочник.Налоги И ПлатежныеДокументы.СубконтоДт2 <> &ВоенныйСбор ТОГДА ПлатежныеДокументы.СубконтоДт2
	|   	КОГДА ПлатежныеДокументы.СубконтоДт3 ССЫЛКА Справочник.Налоги И ПлатежныеДокументы.СубконтоДт3 <> &ВоенныйСбор ТОГДА ПлатежныеДокументы.СубконтоДт3
	|       ИНАЧЕ &ПустойНалог
	|   КОНЕЦ КАК Налог,
	|   ВЫБОР 
	|		КОГДА ПлатежныеДокументы.СубконтоДт1 ССЫЛКА Справочник.СтатьиНалоговыхДеклараций ТОГДА ПлатежныеДокументы.СубконтоДт1
	|		КОГДА ПлатежныеДокументы.СубконтоДт1 ССЫЛКА Справочник.Налоги И  ПлатежныеДокументы.СубконтоДт1 = &ВоенныйСбор ТОГДА ПлатежныеДокументы.СубконтоДт1 
	|		КОГДА ПлатежныеДокументы.СубконтоДт2 ССЫЛКА Справочник.СтатьиНалоговыхДеклараций ТОГДА ПлатежныеДокументы.СубконтоДт2
	|		КОГДА ПлатежныеДокументы.СубконтоДт2 ССЫЛКА Справочник.Налоги И  ПлатежныеДокументы.СубконтоДт2 = &ВоенныйСбор ТОГДА ПлатежныеДокументы.СубконтоДт2 
	|		КОГДА ПлатежныеДокументы.СубконтоДт3 ССЫЛКА Справочник.СтатьиНалоговыхДеклараций ТОГДА ПлатежныеДокументы.СубконтоДт3
	|		КОГДА ПлатежныеДокументы.СубконтоДт3 ССЫЛКА Справочник.Налоги И  ПлатежныеДокументы.СубконтоДт3 = &ВоенныйСбор ТОГДА ПлатежныеДокументы.СубконтоДт3 
	|       ИНАЧЕ &ПустаяСтатья
	|   КОНЕЦ КАК Статья
	|ПОМЕСТИТЬ ВТПлатежныеДокументы	
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета.ПеречислениеНалогов КАК ПлатежныеДокументы
	|ГДЕ
	|   ПлатежныеДокументы.Ведомость В  (&ПлатежныеВедомости)
	|
	|;
	|ВЫБРАТЬ
	|   ДанныеДокументов.Ведомость,
	|   ДанныеДокументов.Сумма,
	|   ДанныеДокументов.Налог,
	|   ДанныеДокументов.Статья,
	|   ДанныеДокументов.СчетУчета,
	|   ДанныеДокументов.Контрагент,
	|   ДанныеДокументов.СчетКонтрагента,
	|   ПлатежныеДокументы.Платежка,
	|	ВЫБОР
	|		КОГДА ПлатежныеДокументы.Платежка ЕСТЬ NULL
	|			ТОГДА 3
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПлатежныеДокументы.Платежка.Проведен
	|					ТОГДА 0
	|				КОГДА ПлатежныеДокументы.Платежка.ПометкаУдаления
	|					ТОГДА 1
	|				ИНАЧЕ 2
	|			КОНЕЦ
	|	КОНЕЦ КАК СостояниеДокумета
	|ПОМЕСТИТЬ ВТНалоги
	|ИЗ
	|	ВТДанныеДокументовСПараметрами КАК ДанныеДокументов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВТПлатежныеДокументы КАК ПлатежныеДокументы
	|	ПО ДанныеДокументов.Ведомость = ПлатежныеДокументы.Ведомость
	|	 И ДанныеДокументов.Налог = ПлатежныеДокументы.Налог
	|	 И ДанныеДокументов.Статья = ПлатежныеДокументы.Статья
	|	 И ДанныеДокументов.СчетУчета = ПлатежныеДокументы.СчетУчета
	|	 И ДанныеДокументов.Контрагент = ПлатежныеДокументы.Контрагент
	|	 И ДанныеДокументов.СчетКонтрагента = ПлатежныеДокументы.СчетКонтрагента
    |;
	|ВЫБРАТЬ
	|   Налоги.Ведомость,
	|   Налоги.Сумма,
	|   Налоги.Налог,
	|   Налоги.Статья КАК СтатьяНалоговойДекларации,
	|   Налоги.СчетУчета,
	|   Налоги.Контрагент,
	|   Налоги.СчетКонтрагента,
	|   Налоги.Платежка
	|ИЗ
	|	ВТНалоги КАК Налоги
	|";	
	
	Объект.Налоги = Запрос.Выполнить().Выгрузить();
	
	РезультатВыполнения = Новый Структура("Объект", Объект);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Процедура АвтозаполнениеДокументов(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	Объект             = ПараметрыЗаполнения.Объект;
	Налоги 			   = Объект.Налоги;
	ПлатежныеДокументы = Налоги.ВыгрузитьКолонку("Платежка");
	
	Если Налоги.Количество() = 0 Тогда
		РезультатВыполнения = Новый Структура("Объект", Объект);
		ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	Запрос.УстановитьПараметр("Налоги",   	Налоги);
	Запрос.УстановитьПараметр("ПлатежныеДокументы",   ПлатежныеДокументы);
	
	Запрос.Текст = 	
	"ВЫБРАТЬ 
	|   Налоги.Ведомость,
	|   Налоги.Сумма,
	|   Налоги.Налог,
	|   Налоги.СтатьяНалоговойДекларации,
	|   Налоги.СчетУчета,
	|   Налоги.Контрагент,
	|   Налоги.СчетКонтрагента,
	|   Налоги.Платежка
	|ПОМЕСТИТЬ ВТНалоги
	|ИЗ
	|	&Налоги КАК Налоги";
	
	Запрос.Выполнить();
	
	Запрос.Текст = 	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|   ПлатежныеДокументы.Ссылка,
	|   ПлатежныеДокументы.Проведен,
	|   ПлатежныеДокументы.ПометкаУдаления
	|ПОМЕСТИТЬ ВТПлатежныеДокументы
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК ПлатежныеДокументы
	|ГДЕ
	|   ПлатежныеДокументы.Ссылка В (&ПлатежныеДокументы) 
	|;
	|
	|ВЫБРАТЬ
	|   Налоги.Ведомость,
	|   Налоги.Сумма,
	|   Налоги.Налог,
	|   Налоги.СтатьяНалоговойДекларации,
	|   Налоги.СчетУчета,
	|   Налоги.Контрагент,
	|   Налоги.СчетКонтрагента,
	|   Налоги.Платежка,
	|	ВЫБОР
	|		КОГДА ПлатежныеДокументы.Ссылка ЕСТЬ NULL
	|			ТОГДА 3
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПлатежныеДокументы.Проведен
	|					ТОГДА 1
	|				КОГДА ПлатежныеДокументы.ПометкаУдаления
	|					ТОГДА 2
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|	КОНЕЦ КАК СостояниеДокумета
	|ПОМЕСТИТЬ ВТПлатежныеДокументыИНалоги
	|ИЗ
	|	ВТНалоги КАК Налоги
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВТПлатежныеДокументы КАК ПлатежныеДокументы
	|	ПО Налоги.Платежка = ПлатежныеДокументы.Ссылка
    |;
	|
	|ВЫБРАТЬ
	|   СУММА(Налоги.Сумма) КАК Сумма,
	|   Налоги.Налог,
	|   Налоги.СчетУчета,
	|   Налоги.Контрагент,
	|   Налоги.СчетКонтрагента,
	|   Налоги.Платежка,
	|   Налоги.СостояниеДокумета
	|ИЗ
	|	ВТПлатежныеДокументыИНалоги КАК Налоги
	|СГРУППИРОВАТЬ ПО
	|   Налоги.Налог,
	|   Налоги.СчетУчета,
	|   Налоги.Контрагент,
	|   Налоги.СчетКонтрагента,
	|   Налоги.Платежка,
	|   Налоги.СостояниеДокумета
	|";
	
	Объект.Платежки = Запрос.Выполнить().Выгрузить();
	
	РезультатВыполнения = Новый Структура("Объект", Объект);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Процедура СоздатьДокументы(ПараметрыСоздания, АдресХранилища) Экспорт
	
	Объект                        = ПараметрыСоздания.Объект;
	Организация                   = Объект.Организация;
	СтатьяДвиженияДенежныхСредств = Объект.СтатьяДвиженияДенежныхСредств;
	ДатаПлатежки                  = Объект.ДатаПлатежки;
	Платежки                      = Объект.Платежки;
	Налоги                        = Объект.Налоги;
	
	ВалютаРегламентированногоУчета        = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ПодходящаяПлатежка = Неопределено;
	
	Отбор = Новый Структура ("СчетУчета, Контрагент, СчетКонтрагента");
	Для Каждого СтрокаТаблицы Из Платежки Цикл
		
		Если СтрокаТаблицы.Отметка И НЕ ЗначениеЗаполнено(СтрокаТаблицы.Платежка) Тогда
			
			ДокументПлатежка = Документы.СписаниеСРасчетногоСчета.СоздатьДокумент();
			ДокументПлатежка.Дата		 		= ДатаПлатежки;
			ДокументПлатежка.ДатаВыписки		= ДатаПлатежки;
			ДокументПлатежка.ВидОперации		= Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога;
			ДокументПлатежка.Контрагент			= СтрокаТаблицы.Контрагент;
			ДокументПлатежка.СчетКонтрагента	= СтрокаТаблицы.СчетКонтрагента;
			Если НЕ СтрокаТаблицы.СчетКонтрагента.Пустая() Тогда
				ДокументПлатежка.НазначениеПлатежа = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
					СтрокаТаблицы.СчетКонтрагента, "ТекстНазначения"));
			КонецЕсли;
			ДокументПлатежка.ВалютаДокумента	= ВалютаРегламентированногоУчета;
			ДокументПлатежка.Организация		= Организация;
			ДокументПлатежка.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
			ДокументПлатежка.СчетБанк		= ПланыСчетов.Хозрасчетный.ТекущиеСчетаВНациональнойВалюте;
			ДокументПлатежка.СчетОрганизации				= Организация.ОсновнойБанковскийСчет;
			ДокументПлатежка.СчетУчетаРасчетовСКонтрагентом	= СтрокаТаблицы.СчетУчета;
			
			// табличная часть
			Отбор.СчетУчета = СтрокаТаблицы.СчетУчета;
			Отбор.СчетКонтрагента = СтрокаТаблицы.СчетКонтрагента;
			Отбор.Контрагент = СтрокаТаблицы.Контрагент;
			СтрокиНалогов = Налоги.НайтиСтроки(Отбор);
			Для Каждого СтрокаНалогов Из СтрокиНалогов Цикл
				
				Если ЗначениеЗаполнено(СтрокаНалогов.Платежка) Тогда
					ПодходящаяПлатежка = СтрокаНалогов.Платежка;
					Продолжить;
				КонецЕсли;	
				
				Если ДокументПлатежка.Ссылка.Пустая() Тогда
					ДокументПлатежка.Записать();
				КонецЕсли;
				
				СтрокаПлатежки = ДокументПлатежка.ПеречислениеНалогов.Добавить();
				СтрокаПлатежки.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
				Если СтрокаНалогов.Налог = Справочники.Налоги.ПустаяСсылка()
					И СтрокаНалогов.СтатьяНалоговойДекларации = Справочники.СтатьиНалоговыхДеклараций.ПустаяСсылка() Тогда
					//НДФЛ
				ИначеЕсли СтрокаНалогов.СтатьяНалоговойДекларации = УчетНДФЛ.ЗначенияВоенныйСбор().Налог Тогда	
					//Военный сбор
					СтрокаПлатежки.СубконтоДт1 = УчетНДФЛ.ЗначенияВоенныйСбор().Налог;
				Иначе	
					//Взносы
					СтрокаПлатежки.СубконтоДт1 = СтрокаНалогов.Налог;
					СтрокаПлатежки.СубконтоДт2 = СтрокаНалогов.СтатьяНалоговойДекларации;
				КонецЕсли;	
				СтрокаПлатежки.Сумма = СтрокаНалогов.Сумма;
				ДокументПлатежка.СуммаДокумента	= ДокументПлатежка.СуммаДокумента + СтрокаНалогов.Сумма;
				
				СтрокаПлатежки.Ведомость = СтрокаНалогов.Ведомость;
				
				СтрокаНалогов.Платежка = ДокументПлатежка.Ссылка;
				
			КонецЦикла;
			Если ДокументПлатежка.ПеречислениеНалогов.Количество() > 0 Тогда
				ДокументПлатежка.Записать();
				СтрокаТаблицы.Платежка = ДокументПлатежка.Ссылка;
			Иначе
				СтрокаТаблицы.Платежка = ПодходящаяПлатежка;
			КонецЕсли;	
			
			СтрокаТаблицы.СостояниеДокумета	= 0;
			
		КонецЕсли;
		
	КонецЦикла;

	
	РезультатВыполнения = Новый Структура("Объект", Объект);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ПровестиДокументы(ПараметрыПроведения, АдресХранилища) Экспорт

	Объект = ПараметрыПроведения.Объект;
	Платежки                      = Объект.Платежки;
	
	Отказ = Ложь;

	Для Каждого СтрокаТаблицы Из Платежки Цикл
		Если СтрокаТаблицы.Отметка и ЗначениеЗаполнено(СтрокаТаблицы.Платежка) Тогда
			Платежка = СтрокаТаблицы.Платежка.ПолучитьОбъект();
			Если Платежка.Проведен Тогда
				Продолжить;
			Конецесли;	
			Если Платежка.ПометкаУдаления Тогда
				Платежка.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			Попытка
				Платежка.Записать(РежимЗаписиДокумента.Проведение);
				СтрокаТаблицы.СостояниеДокумета	= 1;
			Исключение
				ТекстСообщения = НСтр("ru='Не удалось провести документ: %1';uk='Не вдалося провести документ: %1'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка(Платежка));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			КонецПопытки;
			СтрокаТаблицы.Отметка = Не СтрокаТаблицы.Отметка;
		КонецЕсли;
	КонецЦикла;
	
	РезультатВыполнения = Новый Структура("Отказ, Объект", Отказ, Объект);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

#КонецЕсли