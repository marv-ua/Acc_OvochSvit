﻿#Область ПрограммныйИнтерфейс

//+++
// Добавляет описание строки расшифровки в таблицу расшифровок.
// В случае, если таблица расшифровок не инициализирована, выполняется ее инициализация.
//
Процедура ДобавитьСтрокуРасшифровки(ТаблицаРасшифровок, ИмяПоказателя, НаименованиеПоказателя, ЗнакОперации, НаименованиеСлагаемого, Сумма, ИмяРаздела, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТаблицаРасшифровок = Неопределено Тогда
		ТаблицаРасшифровок = Новый ТаблицаЗначений;
		ТаблицаРасшифровок.Колонки.Добавить("ИмяПоказателя");
		ТаблицаРасшифровок.Колонки.Добавить("НаименованиеПоказателя");
		ТаблицаРасшифровок.Колонки.Добавить("ЗнакОперации");
		ТаблицаРасшифровок.Колонки.Добавить("НаименованиеСлагаемого");
		ТаблицаРасшифровок.Колонки.Добавить("Сумма");
		ТаблицаРасшифровок.Колонки.Добавить("ИмяРаздела");
		ТаблицаРасшифровок.Колонки.Добавить("ДополнительныеПараметры");
	КонецЕсли;
	
	НоваяСтрокаРасшифровки = ТаблицаРасшифровок.Добавить();
	НоваяСтрокаРасшифровки.ИмяПоказателя           = ИмяПоказателя;
	НоваяСтрокаРасшифровки.НаименованиеПоказателя  = НаименованиеПоказателя;
	НоваяСтрокаРасшифровки.ЗнакОперации            = ЗнакОперации;
	НоваяСтрокаРасшифровки.НаименованиеСлагаемого  = НаименованиеСлагаемого;
	НоваяСтрокаРасшифровки.Сумма                   = Сумма;
	НоваяСтрокаРасшифровки.ИмяРаздела              = ИмяРаздела;
	НоваяСтрокаРасшифровки.ДополнительныеПараметры = ДополнительныеПараметры;
	
КонецПроцедуры

#КонецОбласти