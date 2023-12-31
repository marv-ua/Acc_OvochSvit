﻿
Функция ПолучитьСписокДоступныхЗначений(Отбор, ЕстьНедоступные = Ложь) Экспорт
	
	СтруктураДоступныхЗначений = ПолучитьДоступныеЗначения(Отбор, Неопределено);
	ЕстьНедоступные            = СтруктураДоступныхЗначений.ЕстьНедоступные;
	Возврат СтруктураДоступныхЗначений.ДоступныеЗначения;

КонецФункции

Функция ПолучитьДоступныеЗначения(Отбор, СтрокаПоиска)
	
	Исключения = Новый Массив;
	Если НЕ ПолучитьФункциональнуюОпцию("ВедетсяПроизводственнаяДеятельность") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийПередачаТоваров.ВПереработку);
		Исключения.Добавить(Перечисления.ВидыОперацийПередачаТоваров.ИзПереработки);
	КонецЕсли;
	
 	ДоступныеЗначения = Новый СписокЗначений;
	ЕстьНедоступные   = Ложь;
	
	Для каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийПередачаТоваров.ЗначенияПеречисления Цикл
		
		Если ТипЗнч(СтрокаПоиска) = Тип("Строка")
			И НЕ ПустаяСтрока(СтрокаПоиска)
			И Найти(НРег(ЗначениеПеречисления.Синоним), НРег(СтрокаПоиска)) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		Ссылка = Перечисления.ВидыОперацийПередачаТоваров[ЗначениеПеречисления.Имя];
		Если ТипЗнч(Отбор) = Тип("ПеречислениеСсылка.ВидыОперацийПередачаТоваров")
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

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора         = ПолучитьДоступныеЗначения(Параметры.Отбор, Параметры.СтрокаПоиска).ДоступныеЗначения;
	
КонецПроцедуры
