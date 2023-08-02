﻿&НаКлиенте
Перем мРежимВыбораКолонок,мПутьКОбработке;
&НаКлиенте
Процедура УправлениеВидимостью()
	Если мРежимВыбораКолонок Тогда
		Элементы.ТаблицаЗначений.Видимость = Ложь;
		Элементы.СтруктураКолонок.Видимость = Истина;
	Иначе
		Элементы.ТаблицаЗначений.Видимость = Истина;
		Элементы.СтруктураКолонок.Видимость = Ложь;
	КонецЕсли;
	

КонецПроцедуры // УправлениеВидимостью()

&НаКлиенте
Процедура Колонки(Команда)
	мРежимВыбораКолонок = Истина;
	УправлениеВидимостью();
КонецПроцедуры


&НаКлиенте
Процедура ЗакрытьНастройкуКолонок(Команда)
	мРежимВыбораКолонок = Ложь;
	УправлениеВидимостью();
КонецПроцедуры


&НаКлиенте
Процедура СтруктураКолонокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
КонецПроцедуры

&НаСервере
Процедура ИзменитьДобавитьКолонкуТаблицы(ОписаниеКолонкиИд)
	ОписаниеКолонки = СтруктураКолонок.НайтиПоИдентификатору(ОписаниеКолонкиИд);
	МассивРеквизитов = Новый Массив;
	ТекТип = ОписаниеКолонки.ТипЗначения;
	Если ЭлементыСинхронизированы(ОписаниеКолонкиИд) Тогда
		Возврат
	КонецЕсли;
	
	УдалитьКолонкуИзТаблицы(ОписаниеКолонки.ПолучитьИдентификатор());
	
	МассивРеквизитов.Добавить(Новый РеквизитФормы(ОписаниеКолонки.ИмяКолонки, ТекТип, "ТаблицаЗначений")); 
	ИзменитьРеквизиты(МассивРеквизитов);
	НовыйЭлемент = Элементы.Добавить("ТаблицаЗначений" + ОписаниеКолонки.ИмяКолонки, Тип("ПолеФормы"), Элементы.ТаблицаЗначений);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "ТаблицаЗначений." + ОписаниеКолонки.ИмяКолонки;
	

КонецПроцедуры // ДобавитьНовуюКолонкуТаблицы()

&НаСервере
Функция ЭлементыСинхронизированы(ИдСтруктуры)
	ОписаниеКолонки = СтруктураКолонок.НайтиПоИдентификатору(ИдСтруктуры);
	ТЗ = РеквизитФормыВЗначение("ТаблицаЗначений");
	ТекКолонкаТЗ = ТЗ.Колонки.Найти(ОписаниеКолонки.ИмяКолонки); 
	Если ТекКолонкаТЗ = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;	
	Если ТекКолонкаТЗ.ТипЗначения <> ОписаниеКолонки.ТипЗначения Тогда
		Возврат Ложь
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции // ЭлементыСинхронизированы()


&НаСервере
Процедура УдалитьКолонкуИзТаблицы(ОписаниеКолонкиИд)
	ОписаниеКолонки = СтруктураКолонок.НайтиПоИдентификатору(ОписаниеКолонкиИд);
	Если Элементы.Найти("ТаблицаЗначений"+ОписаниеКолонки.ИмяКолонки)=Неопределено Тогда
		Возврат;
	КонецЕсли;
	Элементы.Удалить(Элементы["ТаблицаЗначений"+ОписаниеКолонки.ИмяКолонки]);
	МассивУдаляемыхРеквизитов = Новый Массив;
	МассивУдаляемыхРеквизитов.Добавить("ТаблицаЗначений."+ОписаниеКолонки.ИмяКолонки);
	ИзменитьРеквизиты(,МассивУдаляемыхРеквизитов);

КонецПроцедуры // УдалитьКолонкуИзТаблицы()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеВидимостью();
	мПутьКОбработке = ВладелецФормы.мПутьКОбработке;
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МассивРеквизитов = Новый Массив;
	Для Каждого ОписаниеКолонки Из Параметры.СтруктураКолонок Цикл
		НоваяСтрока = СтруктураКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ОписаниеКолонки.Значение);
		ИзменитьДобавитьКолонкуТаблицы(НоваяСтрока.ПолучитьИдентификатор());
	КонецЦикла;
	
	Для Каждого СодержимоеТаблицы Из Параметры.ВходящийСписок Цикл
		НоваяСтрока = ТаблицаЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СодержимоеТаблицы.Значение);
	КонецЦикла;
	ЭтаФорма.ТолькоПросмотр = Параметры.ТолькоПросмотр;
КонецПроцедуры


&НаКлиенте
Процедура СтруктураКолонокПередУдалением(Элемент, Отказ)
	УдалитьКолонкуИзТаблицы(Элементы.СтруктураКолонок.ТекущаяСтрока);
КонецПроцедуры


&НаКлиенте
Процедура СтруктураКолонокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НЕ НоваяСтрока Тогда
		Элементы.СтруктураКолонокИмяКолонки.ТолькоПросмотр = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если Параметры.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	ОписаниеТаблицыРодителя = ВладелецФормы.Элементы.ПараметрыЗапроса.ТекущиеДанные.ОписаниеТаблицыЗначений;
	ОписаниеТаблицыРодителя.Очистить();
	Для Каждого Колонка Из СтруктураКолонок Цикл
		НоваяСтруктура = Новый Структура;
		НоваяСтруктура.Вставить("ИмяКолонки",Колонка.ИмяКолонки);
		НоваяСтруктура.Вставить("ТипЗначения",Колонка.ТипЗначения);
		ОписаниеТаблицыРодителя.Добавить(НоваяСтруктура);
	КонецЦикла;
		
	ТаблицаЗначенийРодителя = ВладелецФормы.Элементы.ПараметрыЗапроса.ТекущиеДанные.ТаблицаЗначений;
	ТаблицаЗначенийРодителя.Очистить();
	Для Каждого СтрокаТЗ Из ТаблицаЗначений Цикл
		СтруктураЗагрузки = Новый Структура;
		Для Каждого Колонка Из СтруктураКолонок Цикл
			СтруктураЗагрузки.Вставить(Колонка.ИмяКолонки,СтрокаТЗ[Колонка.ИмяКолонки]);
		КонецЦикла;
		ТаблицаЗначенийРодителя.Добавить(СтруктураЗагрузки);
	КонецЦикла;
	ВладелецФормы.Элементы.ПараметрыЗапроса.ТекущиеДанные.ЗначениеПараметра = "ТаблицаЗначений : " + СокрЛП(ТаблицаЗначений.Количество()) + " стр.";
КонецПроцедуры


&НаКлиенте
Процедура СтруктураКолонокПриИзменении(Элемент) 
	
	ТекДанные = Элементы.СтруктураКолонок.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	Если ПустаяСтрока(ТекДанные.ИмяКолонки) ИЛИ ТекДанные.ТипЗначения = Новый ОписаниеТипов Тогда
		Возврат;
	КонецЕсли;

	ИзменитьДобавитьКолонкуТаблицы(ТекДанные.ПолучитьИдентификатор());

КонецПроцедуры


&НаКлиенте
Процедура СтруктураКолонокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекДанные = Элементы.СтруктураКолонок.ТекущиеДанные;
	Если Не ОтменаРедактирования и (ПустаяСтрока(ТекДанные.ИмяКолонки) ИЛИ ТекДанные.ТипЗначения = Новый ОписаниеТипов) Тогда
		//недозаполненное описание колонки
		Сообщить("Имя колонки и тип значения должны быть заполнены");
		Отказ = Истина;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСовместимость82(ИмяОткрываемойФормы,СтруктураПараметров = Неопределено,МодульРезультата = "") Экспорт
	
	Если ВладелецФормы.ВладелецФормы.Это82() Тогда
		Результат = ОткрытьФормуМодально(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма);
		Если МодульРезультата <> "" Тогда
			Выполнить(МодульРезультата+"(Результат,Неопределено)");
		КонецЕсли;
	Иначе
		Если МодульРезультата <> "" Тогда
			ОписаниеОповещения = Неопределено;
			Выполнить("ОписаниеОповещения = Новый ОписаниеОповещения(МодульРезультата,ЭтаФорма)");
			Выполнить("ОткрытьФорму(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)");
		Иначе
			Выполнить("ОткрытьФорму(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)");
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры // ОткрытьФормуСовместимость82()

&НаКлиенте
Процедура СтруктураКолонокТипЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыИсходящие = Новый Структура("ВыбираемыеТипы,МножественныйВыбор,НачальнаяПометка",Новый ОписаниеТипов,Истина,Элементы.СтруктураКолонок.ТекущиеДанные.ТипЗначения);
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуСовместимость82(мПутьКОбработке+".ВыборТипаУпр",ПараметрыИсходящие,"НачалоВыбораЗавершение");
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораЗавершение(Результат,ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Элементы.СтруктураКолонок.ТекущиеДанные.ТипЗначения = Результат;
		СтруктураКолонокПриИзменении(1);
	КонецЕсли;
КонецПроцедуры // НачалоВыбораЗавершение()


мРежимВыбораКолонок = Ложь;