﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриВыводеЗаголовка(ПараметрыОтчета,Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервераПовтИсп.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация);
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	Результат.Вывести(ОбластьОрганизация);
	
	//Заголовок
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета);
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Проверка суммы входящего НДС ';uk='Перевірка суми вхідного ПДВ '") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(?(ПараметрыОтчета.СНачалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),ПараметрыОтчета.НачалоПериода),
																										ПараметрыОтчета.КонецПериода);
	
КонецФункции

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт

	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ?(ПараметрыОтчета.СначалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),НачалоДня(ПараметрыОтчета.НачалоПериода)));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	// Группировки строк
	Родитель = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "Таблица");
	Родитель.Строки.Очистить();
	Родитель.Колонки.Очистить();
	
	Индекс = 0;
	ПерваяГруппировка = Истина;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если ПерваяГруппировка Тогда
				Группировка = Родитель.Строки.Вставить(Индекс);
				ПерваяГруппировка = Ложь;
			Иначе
				Группировка = Группировка.Структура.Добавить();
			КонецЕсли;
			
			ПолеГруппировки = Группировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Группировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		КонецЕсли;
	КонецЦикла;
	
	// Группировки колонок
	Группировка = Родитель.Колонки.Вставить(Индекс);
	ПолеГруппировки = Группировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ВидРасчетов");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Группировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	

		                     
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Результат.ФиксацияСверху = 0;
	
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
	|ИспользоватьПослеКомпоновкиМакета,
	|ИспользоватьПослеВыводаРезультата,
	|ИспользоватьДанныеРасшифровки,
	|ИспользоватьПриВыводеЗаголовка,
	|ИспользоватьРасширенныеПараметрыРасшифровки",
	Истина, Истина, Истина, Истина, Истина, Истина);
	
КонецФункции

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
		
	// Инициализируем список пунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполниим соответствие полей которые мы хотим получить из данных расшифровки
	СоответствиеПолей = Новый Соответствие;
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеРасшифровки ИЗ ЗначениеРасшифровки.ПолучитьПоля() Цикл
			Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ПолеРасшифровки.Значение);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	// Прежде всего интересны данные группировочных полей
	Для Каждого Группировка Из ДанныеОтчета.Объект.Группировка Цикл
		
		Если Группировка.Использование Тогда
			
			СоответствиеПолей.Вставить(Группировка.Поле);
			
		КонецЕсли;
		
	КонецЦикла;
			
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки",          Истина);
	ДополнительныеСвойства.Вставить("Организация",               ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("НачалоПериода",             ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода",              ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("СНачалаГода",            	 ДанныеОтчета.Объект.СНачалаГода);
	ДополнительныеСвойства.Вставить("МакетОформления",           ДанныеОтчета.Объект.МакетОформления);
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	// Получаем структуру полей доступных в расшифровке
	Данные_Расшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	// Если в отчете уже есть регистратор, то дальше не расшифровываем, а открываем документ.
	Регистратор = Данные_Расшифровки.Получить("НалоговыйДокумент");

	Если Регистратор <> Неопределено Тогда
		ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
		ПараметрыРасшифровки.Вставить("Значение", Регистратор);
		Возврат;
	КонецЕсли;
			
	// Формируем отборы нового отчета.
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		Если ЗначениеРасшифровки.Ключ = "ЗаТару" Или ЗначениеРасшифровки.Ключ = "ВидДеятельностиНДС" Или ЗначениеРасшифровки.Ключ = "Амортизируется"
			Или ЗначениеРасшифровки.Ключ = "СложныйНалоговыйУчет" Или ЗначениеРасшифровки.Ключ = "ДляХозяйственнойДеятельности" Тогда
			Продолжить;
		КонецЕсли;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
	КонецЦикла;
	
	// Формируем группировки нового отчета.
	Группировка = Новый Массив();
	ЕстьГруппировкаПоДокументу = Ложь;
	Для Каждого СтрокаГруппировки Из ДанныеОтчета.Объект.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаГруппировки);
			Группировка.Добавить(СтрокаДляРасшифровки);
			
			Если СтрокаГруппировки.Поле = "НалоговыйДокумент" Тогда
				ЕстьГруппировкаПоДокументу = Истина;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	
	Если НЕ ЕстьГруппировкаПоДокументу Тогда
		
		СтрокаДляРасшифровки = Новый Структура();
		СтрокаДляРасшифровки.Вставить("Использование", 	Истина);
		СтрокаДляРасшифровки.Вставить("Поле", 			"НалоговыйДокумент");
		СтрокаДляРасшифровки.Вставить("Представление", 	НСтр("ru='Документ';uk= 'Документ'"));
		СтрокаДляРасшифровки.Вставить("ТипГруппировки", 0);
		
		Группировка.Добавить(СтрокаДляРасшифровки);
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Группировка", Группировка);
	
	// Формируем дополнительные поля.
	ДополнительныеПоля = Новый Массив();
	
	Для Каждого ДополнительноеПоле Из ДанныеОтчета.Объект.ДополнительныеПоля Цикл
		Если ДополнительноеПоле.Использование Тогда
			
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, ДополнительноеПоле);
			ДополнительныеПоля.Добавить(СтрокаДляРасшифровки);
			
		КонецЕсли;
	КонецЦикла;

	ДополнительныеСвойства.Вставить("ДополнительныеПоля", ДополнительныеПоля);
	
	СписокПунктовМеню.Добавить("ПроверкаСуммыВходящегоНДС", "Проверка суммы входящего НДС");
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("ПроверкаСуммыВходящегоНДС", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

#КонецЕсли