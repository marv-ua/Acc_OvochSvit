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
	Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2010-10-08'		,"22-2"				,"ФормаОтчета2011");
	Форма20110801 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-06-23'		,"18-1"				,"ФормаОтчета2011Мес8");
	Форма20111201 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-10-25'		,"32-3"				,"ФормаОтчета2011Мес12");
	Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2012-12-10'		,"24-1"				,"ФормаОтчета2013");
	Форма20130701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-07-22'		,"12-1"				,"ФормаОтчета2013Мес7");
	Форма20130901 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-09-09'		,"454"				,"ФормаОтчета2013Мес9");
	
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