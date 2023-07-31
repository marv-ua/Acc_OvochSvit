﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ИнтервалОжидания;
&НаКлиенте
Перем ФормаЗакрывается;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Пожалуйста, подождите...';uk='Будь ласка, зачекайте...'");
	Если Не ПустаяСтрока(Параметры.ТекстСообщения) Тогда
		ТекстСообщения = Параметры.ТекстСообщения + Символы.ПС + ТекстСообщения;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		ИнтервалОжидания = ?(Параметры.Интервал <> 0, Параметры.Интервал, 1);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ОтменитьЗадание", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;
	
	ОтменитьВыполнениеЗадания();
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура Отмена(Команда)
	
	ФормаЗакрывается = Истина;
	Подключаемый_ПроверитьВыполнениеЗадания(); // а вдруг задание уже выполнилось.
	Если Статус = "Отменено" Тогда
		Статус = Неопределено;
		Закрыть(РезультатВыполнения(Неопределено));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Задание = ПроверитьЗаданиеВыполнено(ФормаЗакрывается);
	Статус = Задание.Статус;
	
	Если Задание.Прогресс <> Неопределено Тогда
		ПрогрессСтрокой = ПрогрессСтрокой(Задание.Прогресс);
		Если Не ПустаяСтрока(ПрогрессСтрокой) Тогда
			Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения + " " + ПрогрессСтрокой;
		КонецЕсли;
	КонецЕсли;
	Если Задание.Сообщения <> Неопределено И ВладелецФормы <> Неопределено Тогда
		ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
		Для каждого СообщениеПользователю Из Задание.Сообщения Цикл
			СообщениеПользователю.ИдентификаторНазначения = ИдентификаторНазначения;
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Статус = "Выполнено" Тогда
		
		ПоказатьОповещение();
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ОповеститьОВыборе(Задание.Результат);
			Возврат;
		КонецЕсли;
		Закрыть(РезультатВыполнения(Задание));
		Возврат;
		
	ИначеЕсли Статус = "Ошибка" Тогда
		
		Закрыть(РезультатВыполнения(Задание));
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ВызватьИсключение Задание.КраткоеПредставлениеОшибки;
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		Если Параметры.Интервал = 0 Тогда
			ИнтервалОжидания = ИнтервалОжидания * 1.4;
			Если ИнтервалОжидания > 15 Тогда
				ИнтервалОжидания = 15;
			КонецЕсли;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтменитьЗадание()
	
	Отмена(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение()
	
	Если Параметры.ОповещениеПользователя = Неопределено Или Не Параметры.ОповещениеПользователя.Показать Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Параметры.ОповещениеПользователя;
	
	НавигационнаяСсылкаОповещения = Оповещение.НавигационнаяСсылка;
	Если НавигационнаяСсылкаОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		НавигационнаяСсылкаОповещения = ВладелецФормы.Окно.ПолучитьНавигационнуюСсылку();
	КонецЕсли;
	ПояснениеОповещения = Оповещение.Пояснение;
	Если ПояснениеОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		ПояснениеОповещения = ВладелецФормы.Окно.Заголовок;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru='Действие выполнено';uk='Дія виконана'")), 
		НавигационнаяСсылкаОповещения, ПояснениеОповещения);

КонецПроцедуры

&НаСервере
Функция ПроверитьЗаданиеВыполнено(ФормаЗакрывается)
	
	Задание = ДлительныеОперации.ОперацияВыполнена(ИдентификаторЗадания, Ложь, Параметры.ВыводитьПрогрессВыполнения,
		Параметры.ВыводитьСообщения);
	
	Если Параметры.ПолучатьРезультат Тогда
		Если Задание.Статус = "Выполнено" Тогда
			Задание.Вставить("Результат", ПолучитьИзВременногоХранилища(Параметры.АдресРезультата));
		Иначе
			Задание.Вставить("Результат", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	Если ФормаЗакрывается = Истина Тогда
		ОтменитьВыполнениеЗадания();
		Задание.Статус = "Отменено";
	КонецЕсли;	
	
	Возврат Задание;
	
КонецФункции

&НаКлиенте
Функция ПрогрессСтрокой(Прогресс)
	
	Результат = "";
	Если Прогресс = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Процент = 0;
	Если Прогресс.Свойство("Процент", Процент) Тогда
		Результат = Строка(Процент) + "%";
	КонецЕсли;
	Текст = 0;
	Если Прогресс.Свойство("Текст", Текст) Тогда
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + " (" + Текст + ")";
		Иначе
			Результат = Текст;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция РезультатВыполнения(Задание)
	
	Если Задание = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", Задание.Статус);
	Результат.Вставить("АдресРезультата", Параметры.АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата", Параметры.АдресДополнительногоРезультата);
	Результат.Вставить("КраткоеПредставлениеОшибки", Задание.КраткоеПредставлениеОшибки);
	Результат.Вставить("ПодробноеПредставлениеОшибки", Задание.ПодробноеПредставлениеОшибки);
	Результат.Вставить("Сообщения", Задание.Сообщения);
	
	Если Параметры.ПолучатьРезультат Тогда
		Результат.Вставить("Результат", Задание.Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВозвращатьРезультатВОбработкуВыбора()
	Возврат ОписаниеОповещенияОЗакрытии = Неопределено
		И Параметры.ПолучатьРезультат
		И ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма");
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти
