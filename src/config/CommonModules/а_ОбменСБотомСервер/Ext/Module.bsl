﻿#Область ПрограммныйИнтерфейс

Функция КаталогФайловОтчетовБота() Экспорт
	
	Возврат "D:\OS-BOT7\";
	
КонецФункции

Функция КаталогЗагруженныхФайловОтчетовБота() Экспорт
	
	Возврат "D:\BOT_Loaded\";
	
КонецФункции

Функция ПрефиксОтчета() Экспорт
	
	Возврат "Звіт_по_накладних_";
	
КонецФункции

Процедура ВыполнитьЗагрузкуСБота() Экспорт
	
	ПрочитатьФайлы();
	ЗагрузитьКартинки();
	
КонецПроцедуры

Процедура ЗагрузитьКартинки()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДанныеСБота.ДатаЗагрузки КАК ДатаЗагрузки,
	               |	ДанныеСБота.ПутьКФайлу КАК ПутьКФайлу,
	               |	ДанныеСБота.НомерСтрокиФайла КАК НомерСтрокиФайла,
	               |	ДанныеСБота.Данные КАК Данные
	               |ИЗ
	               |	РегистрСведений.а_ЗагруженныеДанныеСБота КАК ДанныеСБота
	               |ГДЕ
	               |	НЕ ДанныеСБота.Ошибка
	               |	И НЕ ДанныеСБота.Обработано
	               |	И ДанныеСБота.ДатаЗагрузки > &ДатаЗагрузки";
	Запрос.УстановитьПараметр("ДатаЗагрузки", ДобавитьМесяц(ТекущаяДата(), -1));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		МассивДанных = СтрРазделить(Выборка.Данные, ";");
		
		// загрузим картинки
		Попытка
			Адрес = МассивДанных[11];
			НомерНакладной = МассивДанных[13];
		Исключение
			Продолжить;
		КонецПопытки;
		Если СтрНайти(Адрес, "http") Тогда
			ПолныйНомерНакладной = Формат(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(НомерНакладной), "ЧЦ=11; ЧВН=; ЧГ=");
			Док = Документы.РеализацияТоваровУслуг.НайтиПоНомеру(ПолныйНомерНакладной, НачалоГода(Выборка.ДатаЗагрузки));
			Если Не ЗначениеЗаполнено(Док) Тогда
				Продолжить;
			КонецЕсли;
			
			ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
			ПараметрыПолучения.Порт = ?(СтрНайти(Адрес, "https"), 443, 80);
			ПараметрыПолучения.ЗащищенноеСоединение = ?(СтрНайти(Адрес, "https"), Истина, Ложь);
			
        	АдресВХранилище = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(Адрес, ПараметрыПолучения, Истина);
			
			Если Не АдресВХранилище.КодСостояния = 200 Тогда
				Продолжить;
			КонецЕсли;
		
			ПараметрыФайла = ПараметрыДобавленияФайла();
			ПараметрыФайла.ИмяБезРасширения = НомерНакладной;
			ПараметрыФайла.РасширениеБезТочки = "jpeg";
			ПараметрыФайла.ВладелецФайлов = Док;
			СсылкаНаФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла,
				АдресВХранилище.Путь,
				Нстр("ru = 'Файл загружен в документ при загрузке из бота: '; uk = 'Файл завантажено в документ за допомогою бота: '") + ТекущаяДата(),
			);
			
			Набор = РегистрыСведений.а_ЗагруженныеДанныеСБота.СоздатьНаборЗаписей();
			Набор.Отбор.ПутьКФайлу.Установить(Выборка.ПутьКФайлу);
			Набор.Отбор.НомерСтрокиФайла.Установить(Выборка.НомерСтрокиФайла);
			Набор.Отбор.ДатаЗагрузки.Установить(Выборка.ДатаЗагрузки);
			Набор.Прочитать();
			Для Каждого Запись Из Набор Цикл
				Запись.Обработано = Истина;
			КонецЦикла;
			Набор.Записать();			
			
		КонецЕсли;
		
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПрочитатьФайлы()
	
	НайденныеФайлы = НайтиФайлы(КаталогФайловОтчетовБота()
		, ""+ПрефиксОтчета()+"*.xlsx"
		, Ложь
	);
	
	Для Каждого НайденныйФайл Из НайденныеФайлы Цикл
		ТабДок = Новый ТабличныйДокумент;
		Попытка
			ТабДок.Прочитать(НайденныйФайл.ПолноеИмя);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			ЗаписатьЛог(НайденныйФайл.ПолноеИмя,, ОписаниеОшибки(), Истина);
			Продолжить;
		КонецПопытки;
		
		
		Для Сч = 2 По ТабДок.ВысотаТаблицы Цикл
			МассивДанных = Новый Массив;
			Для Кч = 1 По ТабДок.ШиринаТаблицы Цикл
				
				МассивДанных.Добавить(ТабДок.Область(Сч,Кч,Сч,Кч).Текст);		
				
			КонецЦикла;
			ЗаписатьЛог(НайденныйФайл.ПолноеИмя, Сч, СтрСоединить(МассивДанных,";"));
		КонецЦикла;    
		
	    ФайлНаДиске = Новый Файл(НайденныйФайл.ПолноеИмя);
	    Если ФайлНаДиске.Существует() Тогда
		    ПереместитьФайл(
		        НайденныйФайл.ПолноеИмя,
		        ""+НайденныйФайл.Путь+"LOADED\"+НайденныйФайл.Имя
		    );
		КонецЕсли;		

	КонецЦикла;

КонецПроцедуры

Процедура ЗаписатьЛог(ИмяФайла, НомерСтрокиФайла = 0, Данные = "", Ошибка = Ложь)
	
	Менеджер = РегистрыСведений.а_ЗагруженныеДанныеСБота.СоздатьМенеджерЗаписи();
	Менеджер.ДатаЗагрузки = ТекущаяДатаСеанса();
	Менеджер.ПутьКФайлу = ИмяФайла;
	Менеджер.НомерСтрокиФайла = НомерСтрокиФайла;
	Менеджер.Данные = Данные;
	Менеджер.Ошибка = Ошибка;
	
	Менеджер.Записать();
 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыДобавленияФайла() Экспорт
	
	Возврат Новый Структура("Автор,ВладелецФайлов,ИмяБезРасширения,РасширениеБезТочки,ВремяИзмененияУниверсальное,ГруппаФайлов,Кодировка");	
	
КонецФункции

#КонецОбласти