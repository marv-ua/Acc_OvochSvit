﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВерсияОтчета Экспорт;
Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина от 19.06.2015 № 578';uk= 'Затверджена Наказом Мінфина від 19.06.2015 № 578'"); 
	НоваяФорма.ДатаНачалоДействия = '2015-07-01';
	НоваяФорма.ДатаКонецДействия  = '2017-06-30';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина от 19.06.2015 № 578 (c изменениями согласно Приказа Минфина от 17.03.2017 № 369)';uk= 'Затверджена Наказом Мінфина від 19.06.2015 № 578 (зі змінами згідно Наказу Мінфіну від 17.03.2017 № 369)'"); 
	НоваяФорма.ДатаНачалоДействия = '2017-07-01';
	НоваяФорма.ДатаКонецДействия  = '2020-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина от 19.06.2015 № 578 (c изменениями согласно Приказа Минфина от 09.12.2020 № 752)';uk= 'Затверджена Наказом Мінфина від 19.06.2015 № 578 (зі змінами згідно Наказу Мінфіну від 09.12.2020 № 752)'"); 
	НоваяФорма.ДатаНачалоДействия = '2021-01-01';
	НоваяФорма.ДатаКонецДействия  = '2022-12-14';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2023УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина от 19.06.2015 № 578 (c изменениями согласно Приказа Минфина от 24.11.2022 № 394)';uk= 'Затверджена Наказом Мінфина від 19.06.2015 № 578 (зі змінами згідно Наказу Мінфіну від 24.11.2022 № 394)'"); 
	НоваяФорма.ДатаНачалоДействия = '2022-12-15';
	НоваяФорма.ДатаКонецДействия  = Неопределено;
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БП 2.1.21.3.1";

#КонецЕсли
