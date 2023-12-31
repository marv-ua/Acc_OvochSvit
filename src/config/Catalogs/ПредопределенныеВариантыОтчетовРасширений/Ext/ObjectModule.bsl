﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ПроверитьЗаполнениеПредопределенного(Отказ);
	КонецЕсли;
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Не ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ВызватьИсключение НСтр("ru='Справочник ""Предопределенные варианты отчетов"" изменяется только при автоматическом заполнении его данных.';uk='Довідник ""Напередвизначені варіанти звітів"" змінюється тільки при автоматичному заповненні його даних.'");
	КонецЕсли;
КонецПроцедуры

// Базовые проверки корректности данных предопределенных вариантов отчетов.
Процедура ПроверитьЗаполнениеПредопределенного(Отказ)
	Если ПометкаУдаления Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Отчет) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не заполнено поле ""%1""';uk='Не заповнене поле ""%1""'"), "Отчет");
	Иначе
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли