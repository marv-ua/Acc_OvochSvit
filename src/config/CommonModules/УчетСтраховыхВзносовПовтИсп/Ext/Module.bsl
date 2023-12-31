﻿
Функция ОпределитьНалоговыйПериод(ПериодРегистрации, ПериодДействия, ВидЕСВ, КатегорияНачисления) Экспорт
	
	Если НЕ ЗНачениеЗаполнено(ВидЕСВ) ИЛИ ВидЕСВ = Перечисления.ВидыЕСВ.НеУчитывается Тогда
		Возврат Дата(1,1,1);
	КонецЕсли;
	
	Если ВидЕСВ = Перечисления.ВидыЕСВ.ОсновнаяЗарплата Тогда
		//Отпуска учитываются по периоду действия, если он за текущий или будущий период
		Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска Тогда
			Возврат МАКС(ПериодРегистрации, ПериодДействия);
		КонецЕсли;
		//Все прочие учитываются по периоду регистрации
		Возврат ПериодРегистрации;
	КонецЕсли;
	
	Если ВидЕСВ = Перечисления.ВидыЕСВ.ПоДоговорамГПХ Тогда
		//Договора учитываются по периоду действия, если он за текущий или прошедший период
		Возврат МИН(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	Если ВидЕСВ = Перечисления.ВидыЕСВ.Больничные Тогда
		//Больничные учитываются по периоду действия, если он за текущий или прошедший период
		Возврат МИН(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	Если ВидЕСВ = Перечисления.ВидыЕСВ.Декретные Тогда
		//Декретные учитываются по периоду действия
		Возврат ПериодДействия;
	КонецЕсли;
	
	//Все прочие учитываются по периоду регистрации
	Возврат ПериодРегистрации;
	
КонецФункции	




