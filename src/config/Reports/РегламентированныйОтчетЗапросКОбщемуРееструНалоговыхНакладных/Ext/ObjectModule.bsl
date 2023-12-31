﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВерсияОтчета Экспорт;
Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
		
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Версия с сентября 2016 г.';uk='Версія з вересня 2016 р.'");
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20181130';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Версия с декабря 2018 г.';uk='Версія з грудня 2018 р.'");
	НоваяФорма.ДатаНачалоДействия = '20181201';
	НоваяФорма.ДатаКонецДействия  = '20190331';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Версия с апреля 2019 г.';uk='Версія з квітня 2019 р.'");
	НоваяФорма.ДатаНачалоДействия = '20190401';
	НоваяФорма.ДатаКонецДействия  = '20190831';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019м9УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Версия с сентября 2019 г.';uk='Версія з вересня 2019 р.'");
	НоваяФорма.ДатаНачалоДействия = '20190901';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БУ 2.0.1.1.1";

#КонецЕсли
