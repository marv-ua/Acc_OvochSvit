﻿Процедура ОткрытьГиперссылку(Форма, Команда) Экспорт
	
	Гиперссылка = Форма.ПолезнаяИнформация_Гиперссылки.НайтиПоЗначению(Команда.Имя);
	
	Если Гиперссылка <> Неопределено Тогда
	
		ПерейтиПоНавигационнойСсылке(Гиперссылка.Представление);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьВсеМатериалы(Форма, Команда) Экспорт
	
	Документ = "<html><body>" + Форма[Команда.Имя] + "</body></html>";
	
	ОбщегоНазначенияБПКлиент.ОткрытьВебСтраницу(Документ, НСтр("ru='Все материалы';uk='Всі матеріали'"));	
	
КонецПроцедуры

Процедура СкрытьОповещения(Форма, Команда) Экспорт
	
	ИмяГруппы = "ГруппаПолезнаяИнформация";
	Форма.Элементы[ИмяГруппы].Видимость = Ложь;
	
	ИмяНастройки = СтрЗаменить(Команда.Имя, "ПолезнаяИнформацияСкрыть", "");
	
	ОбщегоНазначенияВызовСервера.ХранилищеСистемныхНастроекСохранить("ПолезнаяИнформация", ИмяНастройки, ПолезнаяИнформацияВызовСервера.ПолучитьВерсиюИБ());
	
КонецПроцедуры


