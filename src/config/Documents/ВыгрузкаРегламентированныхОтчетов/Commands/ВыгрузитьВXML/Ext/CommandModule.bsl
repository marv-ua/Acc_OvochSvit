﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеДокументов = ПолучитьПараметрыДокументов(ПараметрКоманды);
	ВозможностьОткрытияОтчетов = Новый Структура("РегламентированныйОтчетНалоговаяНакладная,РегламентированныйОтчетПриложение2КНалоговойНакладной");
	
	Для Индекс = 0 ПО ПараметрКоманды.ВГраница() Цикл
		
		Документ = ПараметрКоманды[Индекс];
		
		ДанныеДокумента = Неопределено;
		Если НЕ ДанныеДокументов.Свойство("_" + Формат(Индекс, "ЧГ="), ДанныеДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.НалоговаяНакладная") Тогда
			ИмяОтчета = "РегламентированныйОтчетНалоговаяНакладная";
		ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.Приложение2КНалоговойНакладной") Тогда
			ИмяОтчета = "РегламентированныйОтчетПриложение2КНалоговойНакладной";
		Иначе
			Продолжить;
		КонецЕсли;	
		
		
		Если ВозможностьОткрытияОтчетов[ИмяОтчета] = Неопределено Тогда
			ВозможностьОткрытияОтчетов[ИмяОтчета]  = ПроверитьВозможностьОткрытияОтчетаНаСервере(ИмяОтчета); 
		КонецЕсли;
		
		Если НЕ ВозможностьОткрытияОтчетов[ИмяОтчета] = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыОткрытияОсновнойФормыОтчета = Новый Структура;
		
		ПараметрыОткрытияОсновнойФормыОтчета.Вставить("Организация", 1);
		ПараметрыОткрытияОсновнойФормыОтчета.Вставить("мДатаНачалаПериодаОтчета", ДанныеДокумента.мДатаНачалаПериодаОтчета);
		ПараметрыОткрытияОсновнойФормыОтчета.Вставить("мДатаКонцаПериодаОтчета", ДанныеДокумента.мДатаКонцаПериодаОтчета);

		Попытка
			
			Если РегламентированнаяОтчетность.ЭтоВнешнийОтчет(ИмяОтчета) Тогда
				ОсновнаяФорма = ПолучитьФорму("ВнешнийОтчет." + ИмяОтчета + ".Форма.ОсновнаяФорма", ПараметрыОткрытияОсновнойФормыОтчета);
			Иначе			
				ОсновнаяФорма = ПолучитьФорму("Отчет." + ИмяОтчета + ".Форма.ОсновнаяФорма", ПараметрыОткрытияОсновнойФормыОтчета);
			КонецЕсли;
			
		Исключение
			ОсновнаяФорма = ПолучитьФорму("Отчет." + ИмяОтчета + ".Форма.ОсновнаяФорма", ПараметрыОткрытияОсновнойФормыОтчета);
		КонецПопытки;
		
		ДатаВыбораФормыВыгрузки = ДанныеДокумента.ДатаПодписи;
		ТекРабочаяДата = ТекущаяДата();
		Если ТекРабочаяДата >= '2016-04-01' Тогда
			
			Если НЕ ДанныеДокумента.ВыгрузкаПечатьНН_ПоФормеНаДатуДокумента = Истина Тогда
				ДатаВыбораФормыВыгрузки = ТекРабочаяДата;
			КонецЕсли;
			
		КонецЕсли;	
		//мВыбраннаяФорма = ОсновнаяФорма.ПолучитьФормуДляПериода(ДанныеДокумента.ДатаПодписи);
		мВыбраннаяФорма = ОсновнаяФорма.ПолучитьФормуДляПериода(ДатаВыбораФормыВыгрузки);

		
		Если мВыбраннаяФорма = Неопределено Тогда
			Сообщить("Выгрукза документа " + Документ + " невозможна - отчет " + ИмяОтчета + " не поддерживает выгрузку по форме, действующей, в указанный период!");
		    Продолжить;
		КонецЕсли;
		
		ДатаПодписи = ТекущаяДата();
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", ДанныеДокумента.мДатаНачалаПериодаОтчета);
		ПараметрыФормы.Вставить("мСохраненныйДок",          Неопределено);
		ПараметрыФормы.Вставить("мСкопированаФорма",        Неопределено);
		ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  ДанныеДокумента.мДатаКонцаПериодаОтчета);
		ПараметрыФормы.Вставить("мПериодичность",           ДанныеДокумента.мПериодичность);
		ПараметрыФормы.Вставить("Организация",              ДанныеДокумента.Организация);
		ПараметрыФормы.Вставить("ДатаПодписи",              ДанныеДокумента.ДатаПодписи);
		ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
		ПараметрыФормы.Вставить("мНалоговыйДокумент",		Документ);
		
		Попытка
			
			Если РегламентированнаяОтчетность.ЭтоВнешнийОтчет(ИмяОтчета) Тогда
				ВыбФормаОтчета = ОткрытьФорму("ВнешнийОтчет." + ИмяОтчета + ".Форма." + мВыбраннаяФорма, ПараметрыФормы, ,Документ);
			Иначе			
				ВыбФормаОтчета = ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма." + мВыбраннаяФорма, ПараметрыФормы, ,Документ);
			КонецЕсли;
		
		Исключение
			ВыбФормаОтчета = ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма." + мВыбраннаяФорма, ПараметрыФормы, ,Документ);
		КонецПопытки;
		
		ВыбФормаОтчета.ЗаполнитьИзДокументаИсточника();
		
		ВыбФормаОтчета.Модифицированность = Истина;

		
	КонецЦикла;	     
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВозможностьОткрытияОтчетаНаСервере(ИмяОтчета)

	Возврат РегламентированнаяОтчетность.ПроверитьВозможностьОткрытияОтчета(ИмяОтчета);	

КонецФункции

&НаСервере
Функция ПолучитьПараметрыДокументов(МассивДокументов)

	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НалоговаяНакладная.Ссылка,
	               |	НалоговаяНакладная.Организация,
	               |	НАЧАЛОПЕРИОДА(НалоговаяНакладная.Дата, МЕСЯЦ) КАК мДатаНачалаПериодаОтчета,
	               |	КОНЕЦПЕРИОДА(НалоговаяНакладная.Дата, МЕСЯЦ) КАК мДатаКонцаПериодаОтчета,
	               |	НалоговаяНакладная.Дата КАК ДатаПодписи,
	               |	ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц) КАК мПериодичность
	               |ИЗ
	               |	Документ.НалоговаяНакладная КАК НалоговаяНакладная
	               |ГДЕ
	               |	НалоговаяНакладная.Ссылка В(&Массив)
	               |
	               |ОБЪЕДИНИТЬ
	               |
	               |ВЫБРАТЬ
	               |	Приложение2КНалоговойНакладной.Ссылка,
	               |	Приложение2КНалоговойНакладной.Организация,
	               |	НАЧАЛОПЕРИОДА(Приложение2КНалоговойНакладной.Дата, МЕСЯЦ),
	               |	КОНЕЦПЕРИОДА(Приложение2КНалоговойНакладной.Дата, МЕСЯЦ),
	               |	Приложение2КНалоговойНакладной.Дата,
	               |	ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	               |ИЗ
	               |	Документ.Приложение2КНалоговойНакладной КАК Приложение2КНалоговойНакладной
	               |ГДЕ
	               |	Приложение2КНалоговойНакладной.Ссылка В(&Массив)
				   |";

	Запрос.УстановитьПараметр("Массив", МассивДокументов);
	ПараметрыДокументов = Запрос.Выполнить().Выгрузить();
	
	СтруктураПараметровДокументов = Новый Структура;
	
	Для Индекс = 0 ПО МассивДокументов.ВГраница() Цикл
	
		ТекСсылка = МассивДокументов[Индекс];
		
		ПараметрыДокумента = ПараметрыДокументов.Найти(ТекСсылка, "Ссылка");
		Если ПараметрыДокумента = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПараметровДокумента = Новый Структура("Ссылка, Организация, мДатаНачалаПериодаОтчета, мДатаКонцаПериодаОтчета, ДатаПодписи, мПериодичность, ВыгрузкаПечатьНН_ПоФормеНаДатуДокумента");
		ЗаполнитьЗначенияСвойств(СтруктураПараметровДокумента, ПараметрыДокумента);	
		
		// начиная с 04.2016 выгрузка в ЕРНН должна осуществляется по форме НА ДАТУ РЕГИСТРАЦИИ??!!
		// проверим соответствующую настройку (возможно данное положение со временем будет отменено)
		НастройкаПечати = НалоговыйУчетПовтИсп.НастройкаПечатиНалоговыхДокументов(СтруктураПараметровДокумента.Организация, ТекущаяДата());
		ВыгрузкаПечатьНН_ПоФормеНаДатуДокумента = НастройкаПечати.ВыгрузкаПечатьНН_ПоФормеНаДатуДокумента; 
		СтруктураПараметровДокумента.Вставить("ВыгрузкаПечатьНН_ПоФормеНаДатуДокумента", ВыгрузкаПечатьНН_ПоФормеНаДатуДокумента);
		 
		СтруктураПараметровДокументов.Вставить("_" + Формат(Индекс, "ЧГ="), СтруктураПараметровДокумента);
		
	КонецЦикла;
	
	Возврат  СтруктураПараметровДокументов

КонецФункции // ()
