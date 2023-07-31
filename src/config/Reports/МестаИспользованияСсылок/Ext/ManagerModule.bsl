﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Включен = Ложь;
	НастройкиВарианта.Описание = НСтр("ru='Поиск мест использования объектов приложения.';uk='Пошук місць використання об''єктів прикладної програми.'");
КонецПроцедуры

// Для вызова из процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. 
//                                      См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено - добавленная команда или Неопределено, если нет прав на просмотр отчета.
//
Функция ДобавитьКомандуМестаИспользования(КомандыОтчетов) Экспорт
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.МестаИспользованияСсылок) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Команда = КомандыОтчетов.Добавить();
	Команда.Представление      = НСтр("ru='Места использования';uk='Місця використання'");
	Команда.МножественныйВыбор = Истина;
	Команда.Важность           = "СмТакже";
	Команда.ИмяПараметраФормы  = "Отбор.НаборСсылок";
	Команда.КлючВарианта       = "Основной";
	Команда.Менеджер           = "Отчет.МестаИспользованияСсылок";
	Возврат Команда;
КонецФункции

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли