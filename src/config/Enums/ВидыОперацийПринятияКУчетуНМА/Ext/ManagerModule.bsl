﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора         =  ПолучитьДоступныеЗначения(Параметры.Отбор, Параметры.СтрокаПоиска).ДоступныеЗначения;
	
КонецПроцедуры

Функция ПолучитьДоступныеЗначения(Отбор, СтрокаПоиска)
	
	Исключения = Новый Массив;
	
 	ДоступныеЗначения = Новый СписокЗначений;
	ЕстьНедоступные   = Ложь;
	
	Для каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийПринятияКУчетуНМА.ЗначенияПеречисления Цикл
		
		Если ЗначениеПеречисления = Метаданные.Перечисления.ВидыОперацийПринятияКУчетуНМА.ЗначенияПеречисления.ВводНачальныхОстатков Тогда
			ЕстьНедоступные = Истина;
			Продолжить;
		КонецЕсли; 
		
		Если ТипЗнч(СтрокаПоиска) = Тип("Строка")
			И НЕ ПустаяСтрока(СтрокаПоиска)
			И Найти(НРег(ЗначениеПеречисления.Синоним), НРег(СтрокаПоиска)) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		Ссылка = Перечисления.ВидыОперацийПринятияКУчетуНМА[ЗначениеПеречисления.Имя];
		Если ТипЗнч(Отбор) = Тип("ПеречислениеСсылка.ВидыОперацийПринятияКУчетуНМА")
			И Отбор <> Ссылка Тогда
			Продолжить;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ФиксированныйМассив")
			И Отбор.Найти(Ссылка) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Исключения.Найти(Ссылка) <> Неопределено Тогда
			ЕстьНедоступные = Истина;
			Продолжить;
		КонецЕсли;
		ДоступныеЗначения.Добавить(Ссылка, ЗначениеПеречисления.Синоним);
		
	КонецЦикла;
	
	Возврат Новый Структура("ДоступныеЗначения,ЕстьНедоступные", ДоступныеЗначения, ЕстьНедоступные);
	
КонецФункции

#КонецЕсли
