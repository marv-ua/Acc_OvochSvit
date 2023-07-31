﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СведенияОПланеОбмена = СведенияОПланеОбмена(ПараметрКоманды);
	
	Если СведенияОПланеОбмена.РазделенныйРежим Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Загрузка правил обмена данными в разделенном режиме недоступна.';uk='Завантаження правил обміну даними в розділеному режимі недоступна.'"));
		Возврат;
	КонецЕсли;
	
	Если СведенияОПланеОбмена.ИспользуютсяПравилаКонвертации Тогда
		ОбменДаннымиКлиент.ЗагрузитьПравилаСинхронизацииДанных(СведенияОПланеОбмена.ИмяПланаОбмена);
	Иначе
		Отбор              = Новый Структура("ИмяПланаОбмена, ВидПравил", СведенияОПланеОбмена.ИмяПланаОбмена, СведенияОПланеОбмена.ВидПравилПРО);
		ЗначенияЗаполнения = Новый Структура("ИмяПланаОбмена, ВидПравил", СведенияОПланеОбмена.ИмяПланаОбмена, СведенияОПланеОбмена.ВидПравилПРО);
		
		ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "ПравилаДляОбменаДанными", 
			ПараметрКоманды, "ПравилаРегистрацииОбъектов");
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СведенияОПланеОбмена(Знач УзелИнформационнойБазы)
	
	Результат = Новый Структура("РазделенныйРежим",
		ОбщегоНазначения.РазделениеВключено() И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных());
		
	Если Не Результат.РазделенныйРежим Тогда
		Результат.Вставить("ИмяПланаОбмена",
			ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы));
			
		Результат.Вставить("ИспользуютсяПравилаКонвертации",
			ОбменДаннымиПовтИсп.ЕстьМакетПланаОбмена(Результат.ИмяПланаОбмена, "ПравилаОбмена"));
			
		Результат.Вставить("ВидПравилПРО", Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти