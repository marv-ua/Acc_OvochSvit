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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв3УФ";
	НоваяФорма.ОписаниеОтчета     =  НСтр("ru='Приложение к НП(С)БУ №1 ""Общие требования к финансовой отчетности"" с изменениями внесенными Приказом Минфина Украины от 27.06.2013 №627';uk='Додаток до НП(С)БО №1 ""Загальні вимоги до фінансової звітності"" зі змінами внесеними Наказом Мінфіну України від 27.06.2013 №627'");
	НоваяФорма.ДатаНачалоДействия = '2013-07-01';
	НоваяФорма.ДатаКонецДействия  = '2021-07-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021УФ";
	НоваяФорма.ОписаниеОтчета     =  НСтр("ru='Приложение к НП(С)БУ №1 ""Общие требования к финансовой отчетности"" с изменениями внесенными Приказами Минфина Украины от 27.06.13 №627 и от 09.07.21 №385';uk='Додаток до НП(С)БО №1 ""Загальні вимоги до фінансової звітності"" зі змінами внесеними Наказами Мінфіну України від 27.06.13 №627 та від 09.07.21 №385'");
	НоваяФорма.ДатаНачалоДействия = '2021-08-01';
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
	Форма19990331 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '1999-03-31'		,"22-2"				,"ФормаОтчета2003Кв4");
	Форма20070101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2006-12-11'		,"18-1"				,"ФормаОтчета2007Кв1");
	Форма20080101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2008-03-05'		,"32-3"				,"ФормаОтчета2008Кв1");
	Форма20091001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2009-09-25'		,"24-1"				,"ФормаОтчета2009Кв4");
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-12-09'		,"12-1"				,"ФормаОтчета2012Кв1");
	Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-02-07'		,"454"				,"ФормаОтчета2013Кв1");
	Форма20130701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-06-27'		,"454"				,"ФормаОтчета2013Кв3");
	
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