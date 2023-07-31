﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НачалоПериода,КонецПериода");
	ДатаНачалаГода = ?(ЗначениеЗаполнено(КонецПериода), НачалоГода(КонецПериода), НачалоГода(ТекущаяДатаСеанса()));
	ЦветТекущегоПериода    = Новый Цвет(252, 235, 159);
	ЦветПериодаПоУмолчанию = Элементы.ВыбратьГод.ЦветФона;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПерейтиНаГодНазад(Команда)
	
	ДатаНачалаГода = НачалоГода(ДатаНачалаГода - 1);
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаГодВперед(Команда)
	
	ДатаНачалаГода = КонецГода(ДатаНачалаГода) + 1;
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал1(Команда)
	
	ВыбратьКвартал(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал2(Команда)
	
	ВыбратьКвартал(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал3(Команда)
	
	ВыбратьКвартал(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал4(Команда)
	
	ВыбратьКвартал(4);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГод(Команда)
	
	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = КонецГода(ДатаНачалаГода);
	
	ВыполнитьВыборПериода();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьАктивныйПериод()

	Если НачалоКвартала(НачалоПериода) = НачалоКвартала(КонецПериода) Тогда
		НомерКвартала = Месяц(КонецКвартала(НачалоПериода)) / 3;
		ТекущийЭлемент = Элементы["ВыбратьКвартал" + НомерКвартала];
	ИначеЕсли НачалоГода(НачалоПериода) = НачалоГода(КонецПериода) Тогда
		ТекущийЭлемент = Элементы["ВыбратьГод"];
	Иначе
		ТекущийЭлемент = Элементы["ВыбратьГод"];
	КонецЕсли;

	Если Год(ДатаНачалаГода) = Год(НачалоПериода) Тогда
		ТекущийЭлемент.ЦветФона = ЦветТекущегоПериода;
	Иначе
		ТекущийЭлемент.ЦветФона = ЦветПериодаПоУмолчанию;
	КонецЕсли;
	
	Элементы.ВыбратьГод.Заголовок = Формат(ДатаНачалаГода, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ДФ=""гггг '%1'""", НСтр("ru='год';uk='рік'")));
	Элементы.ВыбратьГод.Отображение = ОтображениеКнопки.Авто; // для корректной работы в веб-клиенте
	Элементы.ВыбратьГод.Отображение = ОтображениеКнопки.Текст;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыборПериода()

	РезультатВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецДня(КонецПериода));
	ОповеститьОВыборе(РезультатВыбора);

КонецПроцедуры 

&НаКлиенте
Процедура ВыбратьКвартал(НомерКвартала)
	
	НачалоПериода = Дата(Год(ДатаНачалаГода), НомерКвартала * 3 - 2, 1);
	КонецПериода  = КонецКвартала(НачалоПериода);
	
	ВыполнитьВыборПериода();
	
КонецПроцедуры

