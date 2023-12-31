﻿Процедура АктуализироватьДанные(НаборЗаписейУчетнойПолитики) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОтборПоОрганизации = Неопределено;
	Если НаборЗаписейУчетнойПолитики.Отбор.Найти("Организация") <> Неопределено И НаборЗаписейУчетнойПолитики.Отбор.Организация.Использование Тогда
		ОтборПоОрганизации = НаборЗаписейУчетнойПолитики.Отбор.Организация.Значение;
	КонецЕсли;
	
	Запрос = Новый ПостроительЗапроса;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	УчетнаяПолитикаОрганизаций.ПлательщикНДС КАК ПлательщикНДС,
	|	УчетнаяПолитикаОрганизаций.ПлательщикЕдиногоНалога КАК ПлательщикЕдиногоНалога,
	|	УчетнаяПолитикаОрганизаций.ГруппаПлательщикаЕдиногоНалога КАК ГруппаПлательщикаЕдиногоНалога,
	|	УчетнаяПолитикаОрганизаций.ДатаИзмененияСхемыНалогообложенияВСерединеМесяца КАК ДатаИзмененияСхемыНалогообложенияВСерединеМесяца,
	|	УчетнаяПолитикаОрганизаций.Период КАК Период
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|		ПО Организации.Ссылка = УчетнаяПолитикаОрганизаций.Организация
	|{ГДЕ
	|	Организации.Ссылка.* КАК Организация}
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|ИТОГИ ПО
	|	Организация";
	
	Если ЗначениеЗаполнено(ОтборПоОрганизации) Тогда
		Запрос.Отбор.Добавить("Организация").Установить(ОтборПоОрганизации);
	КонецЕсли;
	
	Запрос.Выполнить();
	ВыборкаОрганизация = Запрос.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаОрганизация.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.СтатусыПлательщиковЕдиногоНалога.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(ВыборкаОрганизация.Организация);
		
		ТекущиеЗначения = Новый Структура("ПлательщикЕдиногоНалога, ПлательщикНДС, ГруппаПлательщикаЕдиногоНалога");
		ДатаПоследнегоИзменения = Неопределено;
		
		Выборка = ВыборкаОрганизация.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если НЕ ЗначениеЗаполнено(Выборка.Период) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.ДатаИзмененияСхемыНалогообложенияВСерединеМесяца) Тогда
				ДатаВыборки = Мин(Выборка.Период, Выборка.ДатаИзмененияСхемыНалогообложенияВСерединеМесяца);
			Иначе         
				ДатаВыборки = Выборка.Период;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДатаПоследнегоИзменения) И ДатаВыборки >= ДатаПоследнегоИзменения Тогда
				Продолжить;
			КонецЕсли;
			
			ЕстьОтличия = Ложь;
			Для каждого ЭлементСтруктуры Из ТекущиеЗначения Цикл
				Если ЭлементСтруктуры.Значение <> Выборка[ЭлементСтруктуры.Ключ] Тогда
					ЕстьОтличия = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ЕстьОтличия Тогда
				
				ЗаполнитьЗначенияСвойств(ТекущиеЗначения, Выборка);
				
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ТекущиеЗначения);
				НоваяЗапись.Период = ДатаВыборки;
				НоваяЗапись.Организация = ВыборкаОрганизация.Организация;
			
			Иначе
				
				Если ДатаВыборки < ДатаПоследнегоИзменения Тогда
					НоваяЗапись.Период = ДатаВыборки;
				КонецЕсли;
				
			КонецЕсли;
			
			ДатаПоследнегоИзменения = ДатаВыборки;	
			
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры