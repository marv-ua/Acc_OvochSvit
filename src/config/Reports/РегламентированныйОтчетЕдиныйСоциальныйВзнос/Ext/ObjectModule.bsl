﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
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
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Приложение 4 к Приказу Миндоходов  №435 от 14.04.2015 г. (в редакции Приказу Миндоходов от 11.04.2016 г. № 441)';uk= 'Додаток 4 до наказу Міндоходів  №435 від 14.04.2015 р. (у редакції наказу Мінфіна від 11.04.2016 р. № 441)'");
	НоваяФорма.ДатаНачалоДействия = '2016-06-01';
	НоваяФорма.ДатаКонецДействия  = '2018-07-31';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Приложение 4 к Приказу Минфина № 511 от 15.05.2018';uk= 'Додаток 4 до наказу Мінфіна № 511 від 15.05.2018'");
	НоваяФорма.ДатаНачалоДействия = '2018-08-01';
	НоваяФорма.ДатаКонецДействия  = '2020-11-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Приложение 4 к Приказу Минфина № 511 от 15.05.2018 (в редакции Приказа Минфина № 670 от 05.11.2020)';uk= 'Додаток 4 до наказу Мінфіна № 511 від 15.05.2018 (у редакції Наказу Мінфіна № 670 від 05.11.2020)'");
	НоваяФорма.ДатаНачалоДействия = '2020-12-01';
	НоваяФорма.ДатаКонецДействия  = Неопределено;
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БП 2.1.9.1.1";

#КонецЕсли

