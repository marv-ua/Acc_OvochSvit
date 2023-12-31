﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Пактум_Сервер.Пактум_Права() Тогда
		Отказ=Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВосстановитьНастройки();
	фИспользоватьПроксиПриИзменении(0);
	Авторизация(0);
КонецПроцедуры

&НаСервере 
Процедура СохранитьНастройки() 
	Настройки = Новый Структура; 
	Настройки.Вставить("Логин", Логин); 
	Настройки.Вставить("Пароль", Пароль);
	
	СписокПИБ=ПользователиИнформационнойБазы.ПолучитьПользователей();
	Если СписокПИБ.Количество()=0 Тогда
		Сообщить("Недостаточно прав для записи настроек");
		Возврат;
	КонецЕсли;
	Для Каждого ПИБ Из СписокПИБ Цикл
		ХранилищеОбщихНастроек.Сохранить("Обработка.Пактум_Контрагент_Подключение", , Настройки, , ПИБ.Имя);
	КонецЦикла;

	//Выб=Справочники.Пользователи.Выбрать();
	//Пока Выб.Следующий() Цикл
	//	Если Выб.ЭтоГруппа Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Выб.ИдентификаторПользователяИБ);
	//	ХранилищеОбщихНастроек.Сохранить("Обработка.Пактум_Контрагент_Подключение", , Настройки, , ПользовательИБ.Имя);
	//КонецЦикла;
КонецПроцедуры 

&НаСервере 
Процедура ВосстановитьНастройки() 
	Настройки=ХранилищеОбщихНастроек.Загрузить("Обработка.Пактум_Контрагент");
	Если ТипЗнч(Настройки)=Тип("Структура") Тогда
		Объект.фИспользоватьПрокси=Настройки.фИспользоватьПрокси;
		Объект.АдресПрокси=Настройки.АдресПрокси;
		Объект.ПортПрокси=Настройки.ПортПрокси;
		Объект.фИспользоватьЛогинПарольПрокси=Настройки.фИспользоватьЛогинПарольПрокси;
		Объект.ЛогинПрокси=Настройки.ЛогинПрокси;
		Объект.ПарольПрокси=Настройки.ПарольПрокси;
	КонецЕсли;
	
	Настройки=ХранилищеОбщихНастроек.Загрузить("Обработка.Пактум_Контрагент_Подключение");
	Если ТипЗнч(Настройки)=Тип("Структура") Тогда
		Логин=Настройки.Логин;
		Пароль=Настройки.Пароль;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Авторизация(Команда)
	СохранитьНастройки();
	ЗаписатьНастройкиПодключения_Сервер();
	
	Стру=Пактум_Сервер.Авторизация_Пактум();
	Если Стру.Результат Тогда
		Если Стру.Свойство("Депозит") Тогда
			Элементы.мБалансЗн.Заголовок=Строка(Стру.Депозит);
			Элементы.мАктивацияЗн.Заголовок=Лев(Стру.ДатаСтарт, 10)+" "+Сред(Стру.ДатаСтарт, 12, 5);
			Элементы.мОкончаниеЗн.Заголовок=Лев(Стру.ДатаКонец, 10)+" "+Сред(Стру.ДатаКонец, 12, 5);
		Иначе
			Элементы.мБалансЗн.Заголовок="";
			Элементы.мАктивацияЗн.Заголовок="";
			Элементы.мОкончаниеЗн.Заголовок="";
			Сообщить(НСтр("ru='Данный пин-код не существует.';uk='Цей пін-код не існує.'"));
		КонецЕсли;
	Иначе
		Элементы.мБалансЗн.Заголовок="";
		Элементы.мАктивацияЗн.Заголовок="";
		Элементы.мОкончаниеЗн.Заголовок="";
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура фИспользоватьПроксиПриИзменении(Элемент)
	Элементы.ГруппаПрокси1.Доступность=Объект.фИспользоватьПрокси;
	Элементы.ГруппаПрокси2.Доступность=Объект.фИспользоватьПрокси;
	Если Не Объект.фИспользоватьПрокси Тогда
		Объект.фИспользоватьЛогинПарольПрокси=Ложь;
	КонецЕсли;
	фИспользоватьЛогинПарольПроксиПриИзменении(0);
КонецПроцедуры

&НаКлиенте
Процедура фИспользоватьЛогинПарольПроксиПриИзменении(Элемент)
	Элементы.ГруппаПрокси3.Доступность=Объект.фИспользоватьЛогинПарольПрокси;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкиПодключения(Команда)
	ЗаписатьНастройкиПодключения_Сервер();	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиПодключения_Сервер()
	Соо=Новый СообщениеПользователю;
	фЗаписано=Ложь;
	Если Объект.фИспользоватьПрокси Тогда
		фВсеОК=Истина;
		Если СокрЛП(Объект.АдресПрокси)="" Тогда
			Соо.Текст=НСтр("ru='Не заполнен адрес!';uk='Не вказано адресу сервера'");
			Соо.Сообщить();
			фВсеОК=Ложь;
		КонецЕсли;
		пПорт=СокрЛП(Объект.ПортПрокси);
		Если пПорт="" Тогда
			Соо.Текст=НСтр("ru='Не заполнен порт!';uk='Не вказано порт'");
			Соо.Сообщить();
			фВсеОК=Ложь;
		Иначе
			Для А=1 По СтрДлина(пПорт) Цикл
				пСимв=Сред(пПорт, А, 1);
				Если Найти("1234567890", пСимв)=0 Тогда
					Соо.Текст=НСтр("ru='Порт должен содержать только цифры!';uk='Порт повинен містити тільки цифри!'");
					Соо.Сообщить();
					фВсеОК=Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если Не фВсеОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Настройки = Новый Структура; 
	Настройки.Вставить("фИспользоватьПрокси", Объект.фИспользоватьПрокси); 
	Настройки.Вставить("АдресПрокси", Объект.АдресПрокси); 
	Настройки.Вставить("ПортПрокси", Объект.ПортПрокси); 
	Настройки.Вставить("фИспользоватьЛогинПарольПрокси", Объект.фИспользоватьЛогинПарольПрокси); 
	Настройки.Вставить("ЛогинПрокси", Объект.ЛогинПрокси); 
	Настройки.Вставить("ПарольПрокси", Объект.ПарольПрокси); 
	//ХранилищеОбщихНастроек.Сохранить("Обработка.Пактум_Контрагент", , Настройки);	
	СписокПИБ=ПользователиИнформационнойБазы.ПолучитьПользователей();
	Если СписокПИБ.Количество()=0 Тогда
		Сообщить("Недостаточно прав для записи настроек");
		Возврат;
	КонецЕсли;
	Для Каждого ПИБ Из СписокПИБ Цикл
		ХранилищеОбщихНастроек.Сохранить("Обработка.Пактум_Контрагент", , Настройки, , ПИБ.Имя);
	КонецЦикла;
КонецПроцедуры