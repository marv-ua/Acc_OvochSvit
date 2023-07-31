﻿
// Функция возвращает курс ставку НДС
//
// Параметры:
//  Валюта - СправочникСсылка.Валюты, валюта, по которой необходимо получить курс
//  ДатаКурса - Дата, календарная дата, на которую необходимо получить курс валюты
//
// Возвращаемое значение:
//	Курс переданной валюты на переданную дату, 1 в случае отсутствия значения.
//
Функция ПолучитьСтавкуНДС(СтавкаНДС) Экспорт

	Если СтавкаНДС = Перечисления.СтавкиНДС.НДС20 Тогда
		Возврат 20;
	КонецЕсли;

	Если СтавкаНДС = Перечисления.СтавкиНДС.НДС7 Тогда
		Возврат 7;
	КонецЕсли;
	
	Если СтавкаНДС = Перечисления.СтавкиНДС.НДС14 Тогда
		Возврат 14;
	КонецЕсли;
	
	Возврат 0;

КонецФункции

