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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016МесУФ";
	НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 21.07.2015 N 172";
	НоваяФорма.ДатаНачалоДействия = '2016-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016КвУФ";
	НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 21.07.2015 N 172";
	НоваяФорма.ДатаНачалоДействия = '2016-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-12-31';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017МесУФ";
	НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 10.06.2016 N 90";
	НоваяФорма.ДатаНачалоДействия = '2017-01-01';
	НоваяФорма.ДатаКонецДействия  = '2020-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017КвУФ";
	НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 10.06.2016 N 90";
	НоваяФорма.ДатаНачалоДействия = '2017-01-01';
	НоваяФорма.ДатаКонецДействия  = '2018-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019КвУФ";
	НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 06.07.2018 N 134";
	НоваяФорма.ДатаНачалоДействия = '2019-01-01';
	НоваяФорма.ДатаКонецДействия  = '2019-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2020КвУФ";
	НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 31.07.2019 N 259";
	НоваяФорма.ДатаНачалоДействия = '2020-01-01';
	НоваяФорма.ДатаКонецДействия  = '2020-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021МесУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 17.06.2020 № 179';uk= 'Затверджена наказом Держкомстату України від 17.06.2020 N 179'");
	НоваяФорма.ДатаНачалоДействия = '2021-01-01';
	НоваяФорма.ДатаКонецДействия  = '2021-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021КвУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 17.06.2020 № 178';uk= 'Затверджена наказом Держкомстату України від 17.06.2020 N 178'");
	НоваяФорма.ДатаНачалоДействия = '2021-01-01';
	НоваяФорма.ДатаКонецДействия  = '2021-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022МесУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 25.06.2021 № 135(месячная)';uk= 'Затверджена наказом Держкомстату України від 25.06.2021 № 135 (місячна)'");
	НоваяФорма.ДатаНачалоДействия = '2022-01-01';
	НоваяФорма.ДатаКонецДействия  = '2022-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022КвУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 25.06.2021 № 135(квартальная)';uk= 'Затверджена наказом Держкомстату України від 25.06.2021 № 135 (квартальна)'");
	НоваяФорма.ДатаНачалоДействия = '2022-01-01';
	НоваяФорма.ДатаКонецДействия  = '2022-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2023МесУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 12.05.2022 № 87 (месячная)';uk= 'Затверджена наказом Держкомстату України від 12.05.2022 № 87 (місячна)'");
	НоваяФорма.ДатаНачалоДействия = '2023-01-01';
	НоваяФорма.ДатаКонецДействия  = '2023-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2023КвУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 12.05.2022 № 87(квартальная)';uk= 'Затверджена наказом Держкомстату України від 12.05.2022 № 87 (квартальна)'");
	НоваяФорма.ДатаНачалоДействия = '2023-01-01';
	НоваяФорма.ДатаКонецДействия  = '2023-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2024МесУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 30.03.2023 № 128 (месячная)';uk= 'Затверджена наказом Держкомстату України від 30.03.2023 № 128 (місячна)'");
	НоваяФорма.ДатаНачалоДействия = '2024-01-01';
	НоваяФорма.ДатаКонецДействия  = '0001-01-01';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2024КвУФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Госкомстата Украины от 30.03.2023 № 128(квартальная)';uk= 'Затверджена наказом Держкомстату України від 30.03.2023 № 128 (квартальна)'");
	НоваяФорма.ДатаНачалоДействия = '2024-01-01';
	НоваяФорма.ДатаКонецДействия  = '0001-01-01';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БП 2.1.24.3.1";

#КонецЕсли
