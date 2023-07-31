﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв3УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.2015 №897 (с изменения по приказу от 08.07.2016 г. № 585)';uk= 'Затверджена наказом Мінфіна від 20.10.2015 №897 (зі змінами згідно Наказу від 08.07.2016 р. № 585)'");
	НоваяФорма.ДатаНачалоДействия = '2016-07-01';
	НоваяФорма.ДатаКонецДействия  = '2017-03-31';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв3УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 08.07.2016 №585 (в редакции приказа Минфина от 28.04.2017 N 467)';uk= 'Затверджена наказом Мінфіна від 08.07.2016 №585 (у редакції наказу Мінфіна від 28.04.2017 N 467)'");
	НоваяФорма.ДатаНачалоДействия = '2017-04-01';
	НоваяФорма.ДатаКонецДействия  = '2018-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.2015 №897 (в редакции приказа Минфина от 28.04.2017 N 467 с изменениями, внесенными приказом от 19.10.2018 № 842)';uk= 'Затверджена наказом Мінфіна від 20.10.2015 №897 (у редакції наказу Мінфіна від 28.04.2017 N 467 зі змінами, внесеними наказом від 19.10.2018 № 842)'");
	НоваяФорма.ДатаНачалоДействия = '2019-01-01';
	НоваяФорма.ДатаКонецДействия  = '2019-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2020Кв1УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.2015 №897 (в редакции приказа от 28.04.2017 №467 с изменениями, внесенными приказами от 19.10.2018 №842 и от 14.11.2019 №481)';uk= 'Затверджена наказом Мінфіна від 20.10.2015 №897 (у редакції наказу від 28.04.2017 №467 зі змінами, внесеними наказами від 19.10.2018 №842 та від 14.11.2019 №481)'");
	НоваяФорма.ДатаНачалоДействия = '2020-01-01';
	НоваяФорма.ДатаКонецДействия  = '2020-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв1УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.15 №897 (в редакции приказа от 28.04.17 №467 с изменениями, внесенными приказом от 29.10.20 №649)';uk= 'Затверджена наказом Мінфіна від 20.10.15 №897 (у редакції наказу від 28.04.2017 №467 зі змінами, внесеними наказом від 29.10.20 №649)'");
	НоваяФорма.ДатаНачалоДействия = '2021-01-01';
	НоваяФорма.ДатаКонецДействия  = '2021-09-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв4УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.15 №897 (в редакции приказа от 28.04.17 №467 с изменениями, внесенными приказами от 29.10.20 №649 и от 04.06.21 №317)';uk= 'Затверджена наказом Мінфіна від 20.10.15 №897 (у редакції наказу від 28.04.2017 №467 зі змінами, внесеними наказами від 29.10.20 №649 та від 04.06.21 №317)'");
	НоваяФорма.ДатаНачалоДействия = '2021-10-01';
	НоваяФорма.ДатаКонецДействия  = '2022-03-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022Кв1УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.15 №897 (в редакции приказа от 28.04.17 №467 с изменениями, внесенными приказом от 17.11.21 №601)';uk= 'Затверджена наказом Мінфіна від 20.10.15 №897 (у редакції наказу від 28.04.2017 №467 зі змінами, внесеними наказом від 29.10.20 №649 та від 17.11.21 №601)'");
	НоваяФорма.ДатаНачалоДействия = '2022-03-31';
	НоваяФорма.ДатаКонецДействия  = '2022-03-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022Кв2УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.15 №897 (в редакции приказа от 28.04.17 №467 с изменениями, внесенными приказами от 17.11.21 №601 и от 10.02.22 №58)';uk= 'Затверджена наказом Мінфіна від 20.10.15 №897 (у редакції наказу від 28.04.2017 №467 зі змінами, внесеними наказами від 17.11.21 №601 та від 10.02.22 №58)'");
	НоваяФорма.ДатаНачалоДействия = '2022-04-01';
	НоваяФорма.ДатаКонецДействия  = '2022-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2023Кв1УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.15 №897 (в редакции приказа от 28.04.17 №467 с изменениями, внесенными приказами от 25.08.2022 №254 и 13.09.22 №274)';uk= 'Затверджена наказом Мінфіна від 20.10.15 №897 (у редакції наказу від 28.04.2017 №467 зі змінами, внесеними наказами від 25.08.2022 №254 та 13.09.22 №274)'");
	НоваяФорма.ДатаНачалоДействия = '2023-01-01';
	НоваяФорма.ДатаКонецДействия  = Неопределено;
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");          
	                                                                       //дата приказа    //номер приказа     //имя формы
	Форма20051001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2005-10-12'		,"448"				,"ФормаОтчета2005Кв4");
	Форма20110401 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-02-28'		,"114"				,"ФормаОтчета2011Кв2");
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-09-28'		,"1213"				,"ФормаОтчета2012Кв1");
	Форма20121001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2012-12-05'		,"1281"				,"ФормаОтчета2013Кв1");
	Форма20131001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-12-30'		,"872"				,"ФормаОтчета2014Кв1");
	
	Возврат ФормыИФорматы;
	
КонецФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецЕсли