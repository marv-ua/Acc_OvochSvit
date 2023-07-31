﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		УстановитьПредставлениеРасписания(ЭтотОбъект);
		ПараметрыМетода = ОбщегоНазначения.ЗначениеВСтрокуXML(Новый Массив);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Идентификатор = Объект.Ссылка.УникальныйИдентификатор();
	
	Расписание = ТекущийОбъект.Расписание.Получить();
	УстановитьПредставлениеРасписания(ЭтотОбъект);
	
	ПараметрыМетода = ОбщегоНазначения.ЗначениеВСтрокуXML(ТекущийОбъект.Параметры.Получить());
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Расписание = Новый ХранилищеЗначения(Расписание);
	ТекущийОбъект.Параметры = Новый ХранилищеЗначения(ОбщегоНазначения.ЗначениеИзСтрокиXML(ПараметрыМетода));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Идентификатор = Объект.Ссылка.УникальныйИдентификатор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовУправленияФормы

&НаКлиенте
Процедура ПредставлениеРасписанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	Если ЗначениеЗаполнено(Объект.Шаблон) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Для заданий на основе шаблонов, расписание задается в шаблоне.';uk='Для задань на основі шаблонів, розклад задається в шаблоні.'"));
		Возврат;
	КонецЕсли;
	
	Если Расписание = Неопределено Тогда
		РедактируемоеРасписание = Новый РасписаниеРегламентногоЗадания;
	Иначе
		РедактируемоеРасписание = Расписание;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РедактируемоеРасписание);
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ИзменитьРасписание", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРасписанияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	Расписание = Неопределено;
	Модифицированность = Истина;
	УстановитьПредставлениеРасписания(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьРасписание(НовоеРасписание, ДополнительныеПараметры) Экспорт
	
	Если НовоеРасписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Расписание = НовоеРасписание;
	Модифицированность = Истина;
	УстановитьПредставлениеРасписания(ЭтотОбъект);
	
	ПоказатьОповещениеПользователя(НСтр("ru='Перепланирование';uk='Перепланування'"), , НСтр("ru='Новое расписание будет учтено при
        |следующем выполнении задания'
        |;uk='Новий розклад буде врахований при
        |наступному виконанні завдання'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеРасписания(Знач Форма)
	
	Расписание = Форма.Расписание;
	
	Если Расписание <> Неопределено Тогда
		Форма.ПредставлениеРасписания = Строка(Расписание);
	ИначеЕсли ЗначениеЗаполнено(Форма.Объект.Шаблон) Тогда
		Форма.ПредставлениеРасписания = НСтр("ru='<Задается в шаблоне>';uk='<Задається в шаблоні>'");
	Иначе
		Форма.ПредставлениеРасписания = НСтр("ru='<Не задано>';uk='<Не задано>'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


