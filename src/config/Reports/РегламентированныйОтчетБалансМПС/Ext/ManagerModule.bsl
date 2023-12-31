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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1УФ";
	НоваяФорма.ОписаниеОтчета     =  НСтр("ru='Приложение к Положению (стандарту) бухучета №25 (с изменениями, внесенными приказами Минфином Украины № 48 от 08.02.14 г.)';uk='Додаток до Положення (стандарту) бухгалтерського обліку №25 (зі змінами, внесеними наказами Мінфіну України № 48 від 08.02.14 р.)'");
	НоваяФорма.ДатаНачалоДействия = "20140101";
	НоваяФорма.ДатаКонецДействия  = "20190731";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв3УФ";
	НоваяФорма.ОписаниеОтчета     =  НСтр("ru='Приложение к Положению (стандарту) бухучета №25 (с изменениями, внесенными приказами Минфином Украины № 48 от 08.02.14 г. и № 226 от 31.05.19 г.)';uk='Додаток до Положення (стандарту) бухгалтерського обліку №25 (зі змінами, внесеними наказами Мінфіну України № 48 від 08.02.14 р. та № 226 від 31.05.19 р.)'");
	НоваяФорма.ДатаНачалоДействия = "20190801";
	НоваяФорма.ДатаКонецДействия  = "20201031";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2020Кв4УФ";
	НоваяФорма.ОписаниеОтчета     =  НСтр("ru='Приложение к НП(С)БУ №25 (с изменениями, внесенными приказами Минфином Украины №48 от 08.02.14, №226 от 31.05.19, №588 от 29.09.20)';uk='Додаток до НП(С)БО №25 (зі змінами, внесеними наказами Мінфіну України №48 от 08.02.14, №226 от 31.05.19, №588 от 29.09.20)'");
	НоваяФорма.ДатаНачалоДействия = "20201101";
	НоваяФорма.ДатаКонецДействия  = '2021-07-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021УФ";
	НоваяФорма.ОписаниеОтчета     =  НСтр("ru='Приложение к НП(С)БУ №25 (с изменениями, внесенными приказами Минфином Украины №48 от 08.02.14, №226 от 31.05.19, №385 от 09.07.21)';uk='Додаток до НП(С)БО №25 (зі змінами, внесеними наказами Мінфіну України №48 від 08.02.14, №226 від 31.05.19, №385 від 09.07.21)'");
	НоваяФорма.ДатаНачалоДействия = '2021-08-01';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
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
	
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2014-02-08'		,"25"				,"ФормаОтчета2014Кв1УФ");
	Форма20190801 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2019-05-31'		,"226"				,"ФормаОтчета2019Кв3УФ");
	
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