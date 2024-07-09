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
	РазобратьСтроки();
//	РазобранныеСтрокиВДокумент();
	
КонецПроцедуры

Процедура РазобранныеСтрокиВДокумент() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДанныеСБота.ПутьКФайлу КАК ПутьКФайлу,
	               |	ДанныеСБота.НомерСтрокиФайла КАК НомерСтрокиФайла,
	               |	ДанныеСБота.IdOrder КАК IdOrder,
	               |	ДанныеСБота.CreationDate КАК CreationDate,
	               |	ДанныеСБота.TitleOrder КАК TitleOrder,
	               |	ДанныеСБота.ResponsibleName КАК ResponsibleName,
	               |	ДанныеСБота.ResponsiblePhone КАК ResponsiblePhone,
	               |	ДанныеСБота.UserName КАК UserName,
	               |	ДанныеСБота.UserLastName КАК UserLastName,
	               |	ДанныеСБота.UserPhoneNumber КАК UserPhoneNumber,
	               |	ДанныеСБота.StageName КАК StageName,
	               |	ДанныеСБота.Tags КАК Tags,
	               |	ДанныеСБота.GoodsEdits КАК GoodsEdits,
	               |	ДанныеСБота.Photo КАК Photo,
	               |	ДанныеСБота.NeedDelivery КАК NeedDelivery,
	               |	ДанныеСБота.InvoiceNumber КАК InvoiceNumber,
	               |	ДанныеСБота.ЗаписаноВДокумент КАК ЗаписаноВДокумент
	               |ИЗ
	               |	РегистрСведений.а_РазобранныеДанныеСБота КАК ДанныеСБота
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.а_ЗагруженныеДанныеСБота КАК а_ЗагруженныеДанныеСБота
	               |		ПО ДанныеСБота.ПутьКФайлу = а_ЗагруженныеДанныеСБота.ПутьКФайлу
	               |			И ДанныеСБота.НомерСтрокиФайла = а_ЗагруженныеДанныеСБота.НомерСтрокиФайла
				   |			И а_ЗагруженныеДанныеСБота.ДатаЗагрузки > &ДатаЗагрузки
	               |ГДЕ
	               |	НЕ ДанныеСБота.ЗаписаноВДокумент
	               |	И ДанныеСБота.GoodsEdits <> """"";
	Запрос.УстановитьПараметр("ДатаЗагрузки", ДобавитьМесяц(ТекущаяДата(), -1));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НомерНакладной = СокрЛП(Выборка.InvoiceNumber);
   		ПолныйНомерНакладной = Формат(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(НомерНакладной), "ЧЦ=11; ЧВН=; ЧГ=");
		Док = Документы.РеализацияТоваровУслуг.НайтиПоНомеру(ПолныйНомерНакладной, НачалоГода(ТекущаяДатаСеанса()));
		
		Если Не ЗначениеЗаполнено(Док) Или СтрДлина(Выборка.GoodsEdits) < 10 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрТовары = СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(Выборка.GoodsEdits, "[", ""), "]", ""), Символы.НПП, ""), Символы.ПС, "");
		МассивТовары = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрТовары, ",_x000D_");
		
		Об = Док.ПолучитьОбъект();
		
		ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, ЭтоКомиссия, Реализация");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Об, "Дата,Организация,Склад");
		ДанныеОбъекта.Реализация	= Истина;
		ДанныеОбъекта.ЭтоКомиссия	= (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Об.ДоговорКонтрагента, "ВидДоговора") = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);		
		СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
			ОбщегоНазначения.ВыгрузитьКолонку(Об.Товары, "Номенклатура", Истина), ДанныеОбъекта
		);		
		
		
		БылиИзменения = Ложь;
		Для Каждого ЭлТовары Из МассивТовары Цикл
			
			СтрТовар = СтрЗаменить(СтрЗаменить(ЭлТовары, """", ""), "_x000D_", "");
			МассивТовар = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрТовар, ", ");
			Если Не МассивТовар.ВГраница() = 1 Тогда
				ЗаписьЖурналаРегистрации("Загрузка с бота.Загрузка в накладную", УровеньЖурналаРегистрации.Предупреждение,,,"Не удалось загрузить строку <"+ЭлТовары+"> в документ");
				Продолжить;
			КонецЕсли;
			Артикул = Справочники.ДополнительныеАртикулы.НайтиПоНаименованию(
				СокрЛП(СтрЗаменить(СтрЗаменить(МассивТовар[0], "Артикул товару", ""), "-", ""))
			);
			Кво = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(
				СокрЛП(СтрЗаменить(СтрЗаменить(СтрЗаменить(МассивТовар[1], "Кількість", ""), "-", ""), ",", "."))
			);
			
			Если Кво = 0 Тогда
				Для Каждого строкаТовары Из Об.Товары Цикл
					Если строкаТовары.ДополнительныйАртикул = Артикул Тогда
						БылиИзменения = Истина;
						строкаТовары.Количество = 0;
						
						//СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаНоменклатуры(Об.Организация, строкаТовары.Номенклатура);
						СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(строкаТовары.Номенклатура);
						Если СведенияОНоменклатуре = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
							ДанныеОбъекта, строкаТовары, "Товары", СведенияОНоменклатуре
						);
					КонецЕсли;
					
				КонецЦикла;
			Иначе
				БылиИзменения = Истина;
				НоваяСтрокаТовара = Об.Товары.Добавить();
				НоваяСтрокаТовара.ДополнительныйАртикул = Артикул;
				Если ЗначениеЗаполнено(Артикул.Номенклатура) Тогда
					НоваяСтрокаТовара.Номенклатура = Артикул.Номенклатура;
				Иначе
					НоваяСтрокаТовара.Номенклатура = Справочники.ДополнительныеАртикулы.НайтиНоменклатуруПоАртикулу(Артикул);
				КонецЕсли;                                                                                                   
				НоваяСтрокаТовара.Количество = Кво;
				
				НоваяСтрокаТовара.Коэффициент = 1;
                СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаНоменклатуры(Об.Организация, НоваяСтрокаТовара.Номенклатура);
				НоваяСтрокаТовара.СтавкаНДС = СведенияОНоменклатуре.Номенклатура.СтавкаНДС; 
				Документы.РеализацияТоваровУслуг.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
						ДанныеОбъекта, НоваяСтрокаТовара, "Товары", СведенияОНоменклатуре
				);
			КонецЕсли;
		КонецЦикла;
		
		Если БылиИзменения Тогда
			Попытка
				Об.Записать(?(Об.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись), ?(Об.Проведен, РежимПроведенияДокумента.Неоперативный, Неопределено));
			Исключение
				ЗаписьЖурналаРегистрации("Загрузка с бота.Загрузка в накладную", УровеньЖурналаРегистрации.Предупреждение, Об.Метаданные(), Об.Ссылка,"Не удалось Записать документ <"+Об.Ссылка+">");
			КонецПопытки;
			
			ерпсАктПриемкиПередачиСервер.ОбнЦ_ОбновитьЦеныНаСервере(
				Об.Ссылка, Об.ТипЦен, Об, Истина, Истина
			);
			
			Менеджер = РегистрыСведений.а_РазобранныеДанныеСБота.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Менеджер, Выборка);
			Менеджер.ЗаписаноВДокумент = Истина;

		КонецЕсли;
		
			
	
		
	КонецЦикла;
	
КонецПроцедуры

Процедура РазобратьСтроки() Экспорт
	
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
	               |	И НЕ ДанныеСБота.РазобраноСтроки
	               |	И ДанныеСБота.ДатаЗагрузки > &ДатаЗагрузки";
	Запрос.УстановитьПараметр("ДатаЗагрузки", ДобавитьМесяц(ТекущаяДата(), -1));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		МассивДанных = СтрРазделить(Выборка.Данные, ";");
		
		// Заполним данные в РС а_РазобранныеДанныеСБота
		Менеджер = РегистрыСведений.а_РазобранныеДанныеСБота.СоздатьМенеджерЗаписи();
		Менеджер.ПутьКФайлу = Выборка.ПутьКФайлу;
		Менеджер.НомерСтрокиФайла = Выборка.НомерСтрокиФайла;
		
		Менеджер.IdOrder = МассивДанных[0];
		Менеджер.CreationDate = СтроковыеФункцииКлиентСервер.СтрокаВДату(Лев(СокрЛП(МассивДанных[1]), 10));
		Менеджер.TitleOrder = МассивДанных[2];
		Менеджер.ResponsibleName = МассивДанных[3];
		Менеджер.ResponsiblePhone = МассивДанных[4];
		Менеджер.UserName = МассивДанных[5];
		Менеджер.UserLastName = МассивДанных[6];
		Менеджер.UserPhoneNumber = МассивДанных[7];
		Менеджер.StageName = МассивДанных[8];
		Менеджер.Tags = МассивДанных[9];
		Менеджер.GoodsEdits = МассивДанных[10];
		Менеджер.Photo = МассивДанных[11];
		Менеджер.NeedDelivery = МассивДанных[12];
		Менеджер.InvoiceNumber = МассивДанных[13];
		
		Попытка
			Менеджер.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Продолжить;
		КонецПопытки;
		
		Набор = РегистрыСведений.а_ЗагруженныеДанныеСБота.СоздатьНаборЗаписей();
		Набор.Отбор.ДатаЗагрузки.Установить(Выборка.ДатаЗагрузки);
		Набор.Отбор.ПутьКФайлу.Установить(Выборка.ПутьКФайлу);
		Набор.Отбор.НомерСтрокиФайла.Установить(Выборка.НомерСтрокиФайла);
		Набор.Прочитать();
		Для Каждого Запись Из Набор Цикл
			Запись.РазобраноСтроки = Истина;
		КонецЦикла;
		Попытка
			Набор.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Продолжить;
		КонецПопытки;

	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗагрузитьКартинки() Экспорт
	
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