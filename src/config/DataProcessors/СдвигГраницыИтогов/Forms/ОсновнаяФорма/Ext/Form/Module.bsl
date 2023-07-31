﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	Если Не УправлениеИтогамиИАгрегатамиСлужебный.НадоСдвинутьГраницуИтогов() Тогда
		Отказ = Истина; // Период уже был установлен в сеансе другого пользователя.
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДлительнаяОперация = ДлительнаяОперацияЗапускСервер(УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ДлительнаяОперацияЗавершениеКлиент", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДлительнаяОперацияЗапускСервер(УникальныйИдентификатор)
	ИмяМетода = "Обработки.СдвигГраницыИтогов.ВыполнитьКоманду";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru='Итоги и агрегаты: Ускорение проведения документов и формирования отчетов';uk='Підсумки і агрегати: Прискорення проведення документів і формування звітів'");
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, Неопределено, НастройкиЗапуска);
КонецФункции

&НаКлиенте
Процедура ДлительнаяОперацияЗавершениеКлиент(Операция, ДополнительныеПараметры) Экспорт
	
	Обработчик = Новый ОписаниеОповещения("ДлительнаяОперацияПослеВыводаРезультата", ЭтотОбъект);
	Если Операция = Неопределено Тогда
		ВыполнитьОбработкуОповещения(Обработчик, Ложь);
	Иначе
		Если Операция.Статус = "Выполнено" Тогда
			ПоказатьОповещениеПользователя(НСтр("ru='Оптимизация успешно завершена';uk='Оптимізація успішно завершена'"),,, БиблиотекаКартинок.Успешно32);
			ВыполнитьОбработкуОповещения(Обработчик, Истина);
		Иначе
			ВызватьИсключение Операция.КраткоеПредставлениеОшибки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительнаяОперацияПослеВыводаРезультата(Результат, ДополнительныеПараметры) Экспорт
	Если ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, Результат); // Обход особенности вызова из ПриОткрытии.
	КонецЕсли;
	Если Открыта() Тогда
		Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти