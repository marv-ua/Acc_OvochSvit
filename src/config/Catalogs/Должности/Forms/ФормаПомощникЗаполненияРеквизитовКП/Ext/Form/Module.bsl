﻿///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТЗПодходящихПрофессий();
	ПолучитьДолжностьИРекомендуемыеРеквизитыКП();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТЗПодходящихПрофессий()
	
	Макет = Справочники.Должности.ПолучитьМакет("КлассификаторПрофессий");
	ТЗПрофессий = ДанныеФормыВЗначение(ТЗПодходящихПрофессий, Тип("ТаблицаЗначений"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДолжностиОрганизаций.Ссылка КАК Ссылка,
	|	ДолжностиОрганизаций.Наименование КАК Наименование,
	|	ДолжностиОрганизаций.КодКП КАК КодКП,
	|	ДолжностиОрганизаций.КодЗКППТР,
	|	ДолжностиОрганизаций.НаименованиеПоКП
	|ИЗ
	|	Справочник.Должности КАК ДолжностиОрганизаций
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеПоКП";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(Выборка.КодКП) Тогда
			Продолжить
		Иначе	
			Если НЕ ЗначениеЗаполнено(Выборка.КодЗКППТР) И НЕ ЗначениеЗаполнено(Выборка.НаименованиеПоКП) Тогда
				НоваяДолжность = ТЗПрофессий.Добавить();
				НоваяДолжность.Должность = Выборка.Ссылка;
				НоваяДолжность.КодКП = СокрЛП(Выборка.КодКП);
				СписокКодовЗКППТР = Новый СписокЗначений();
				СписокНаименованийПоКП = Новый СписокЗначений();
				
				ТекущаяСтрока = 0;
				ТЗ = Макет.ТекущаяОбласть;
				Пока ТекущаяСтрока < Макет.ВысотаТаблицы Цикл
					ТЗ = Макет.НайтиТекст(СокрЛП(Выборка.КодКП), ТЗ,,,,,Истина);		
					Если ТЗ = Неопределено Тогда
						Прервать;
					КонецЕсли;                 
					
					СтрокаКодЗКППТР = "R" + Формат(ТЗ.Верх,"ЧГ=0")+"C3";
					СтрокаНаименованиеПоКП = "R" +  Формат(ТЗ.Верх,"ЧГ=0")+"C6";
					Если НЕ (СокрЛП(Макет.Область(СтрокаКодЗКППТР).Текст) = "" ИЛИ СокрЛП(Макет.Область(СтрокаКодЗКППТР).Текст) = "-") Тогда 
						СписокКодовЗКППТР.Добавить(СокрЛП(Макет.Область(СтрокаКодЗКППТР).Текст)); 
					КонецЕсли;	
					СписокНаименованийПоКП.Добавить(СокрЛП(Макет.Область(СтрокаНаименованиеПоКП).Текст));
					
					ТекущаяСтрока = ТЗ.Верх;
				КонецЦикла;
				СписокКодовЗКППТР.СортироватьПоЗначению(НаправлениеСортировки.Возр);
				СписокНаименованийПоКП.СортироватьПоЗначению(НаправлениеСортировки.Возр);
				
				НоваяДолжность.СписокКодовЗКППТР =  СписокКодовЗКППТР;
				НоваяДолжность.СписокНаименованийПоКП =  СписокНаименованийПоКП;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	ЗначениеВДанныеФормы(ТЗПрофессий, ТЗПодходящихПрофессий);

КонецПроцедуры

&НаСервере
Процедура ПолучитьДолжностьИРекомендуемыеРеквизитыКП()
	
	ТЗПрофессий = ДанныеФормыВЗначение(ТЗПодходящихПрофессий, Тип("ТаблицаЗначений"));
	Для Каждого СтрокаДолжности Из ТЗПрофессий Цикл
		
		НоваяСтрока = ТЗДолжности.Добавить();
		НоваяСтрока.Должность= СтрокаДолжности.Должность;
		НоваяСтрока.КодКП 	 = СтрокаДолжности.КодКП;
		
		СписокКодовЗКППТР = СписокСоответствияКодаЗКППТР(СтрокаДолжности.КодКП);
		Если СписокКодовЗКППТР.Количество() > 0 Тогда
			НоваяСтрока.КодЗКППТР = СписокКодовЗКППТР[0].Значение;
		КонецЕсли;
		
		СписокНаименованийПоКП = СписокСоответствияНаименованияПоКП(СтрокаДолжности.КодКП);
		Если СписокНаименованийПоКП.Количество() > 0 Тогда
			НоваяСтрока.НаименованиеПоКП = СписокНаименованийПоКП[0].Значение;
		КонецЕсли;
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Функция СписокСоответствияКодаЗКППТР(КодКП)
	
	ТЗПрофессий = ДанныеФормыВЗначение(ТЗПодходящихПрофессий, Тип("ТаблицаЗначений"));
	НайденнаяСтрока = ТЗПрофессий.Найти(КодКП,"КодКП");
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат Новый СписокЗначений();
	Иначе	
		Возврат НайденнаяСтрока.СписокКодовЗКППТР;
	КонецЕсли;	

КонецФункции

&НаСервере
Функция СписокСоответствияНаименованияПоКП(КодКП)
	
	ТЗПрофессий = ДанныеФормыВЗначение(ТЗПодходящихПрофессий, Тип("ТаблицаЗначений"));
	НайденнаяСтрока = ТЗПрофессий.Найти(КодКП,"КодКП");
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат Новый СписокЗначений();
	Иначе	
		Возврат НайденнаяСтрока.СписокНаименованийПоКП;
	КонецЕсли;	

КонецФункции

&НаКлиенте
Процедура ТЗДолжностиНаименованиеПоКПНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Список = СписокСоответствияНаименованияПоКП(ЭтаФорма.Элементы.ТЗДолжности.ТекущиеДанные.КодКП);	
	Элемент.СписокВыбора.ЗагрузитьЗначения(Список.ВыгрузитьЗначения())
	
КонецПроцедуры

&НаКлиенте
Процедура ТЗДолжностиКодЗКППТРНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Список = СписокСоответствияКодаЗКППТР(ЭтаФорма.Элементы.ТЗДолжности.ТекущиеДанные.КодКП);	
	Элемент.СписокВыбора.ЗагрузитьЗначения(Список.ВыгрузитьЗначения())

КонецПроцедуры

&НаСервере
Процедура ВыбратьДолжностьИЗакрытьФорму()
	
	Для Каждого Строка ИЗ ТЗДолжности Цикл
		Если ЗначениеЗаполнено(Строка.НаименованиеПоКП) ИЛИ ЗначениеЗаполнено(Строка.КодЗКППТР) Тогда
			Должность = Строка.Должность.ПолучитьОбъект();
			Должность.НаименованиеПоКП = Строка.НаименованиеПоКП;
			Должность.КодЗКППТР = Строка.КодЗКППТР;
			Должность.Записать();		
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ВыбратьДолжностьИЗакрытьФорму();
	Закрыть();
	Оповестить("ЗакрытиеФормыПомощника",);
	
КонецПроцедуры



