﻿#Область ОбработчикиКомандФормы

#Область ВыгрузитьСертификат

&НаКлиенте
Процедура ВыгрузитьСертификат(Команда)
	
	ТекущаяЗапись = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяЗапись <> Неопределено Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ИмяФайлаСертификата = ТекущиеДанные.Наименование + ".cer";
		Иначе
			ИмяФайлаСертификата = "Сертификат.cer";
		КонецЕсли;
		Оповещение = Новый ОписаниеОповещения("ВыгрузитьСертификатПослеВыполненияПоиска", 
			ЭтотОбъект, Новый Структура("ИмяФайла", ИмяФайлаСертификата));
		ХранилищеСертификатовКлиент.НайтиСертификат(Оповещение, Новый Структура("Отпечаток", ТекущиеДанные.Отпечаток));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьСертификатПослеВыполненияПоиска(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено И ЗначениеЗаполнено(Результат.Сертификат) Тогда
		ПолучитьФайл(ПоместитьВоВременноеХранилище(Результат.Сертификат.Сертификат), 
			ВходящийКонтекст.ИмяФайла, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузитьСертификат

&НаКлиенте
Процедура ЗагрузитьСертификат(Команда)
	
	ТекстПодсказки = НСтр("ru='Укажите тип хранилища';uk='Зазначте тип сховища'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьСертификатПослеВыбораТипаХранилища", ЭтотОбъект);
	ПоказатьВводЗначения(ОписаниеОповещения, , ТекстПодсказки, Тип("ПеречислениеСсылка.ТипХранилищаСертификатов"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСертификатПослеВыбораТипаХранилища(ТипХранилища, ДополнительныеПараметры) Экспорт
	
	Если ТипХранилища <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьСертификатПослеПомещенияФайла", ЭтотОбъект, ТипХранилища);
		НачатьПомещениеФайла(ОписаниеОповещения,,, Истина, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСертификатПослеПомещенияФайла(Результат, АдресСертификата, ВыбранноеИмяФайла, ТипХранилища) Экспорт
	
	Если Результат Тогда
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьСертификатПослеДобавленияВХранилище", ЭтотОбъект);
		ХранилищеСертификатовКлиент.Добавить(Оповещение, АдресСертификата, ТипХранилища);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСертификатПослеДобавленияВХранилище(Результат, ВходящийКонтекст) Экспорт

	Если Результат.Выполнено Тогда
		Элементы.Список.Обновить();
	ИначеЕсли Результат.Свойство("ИнформацияОбОшибке") Тогда 
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(Результат.ИнформацияОбОшибке));		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти