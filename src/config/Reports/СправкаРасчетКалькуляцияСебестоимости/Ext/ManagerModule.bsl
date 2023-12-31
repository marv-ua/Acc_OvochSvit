﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки,
							|ИспользоватьПриВыводеЗаголовка",
							Истина, Истина, Истина, Ложь,Истина);
							
КонецФункции

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
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета) + " (" + ПараметрыОтчета.НазваниеНабораПоказателейОтчета + ")";
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
КонецПроцедуры

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
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Справка-расчет калькуляция себестоимости продукции ';uk='Довідка-розрахунок калькуляція собівартості продукції '") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
    Если БухгалтерскийУчетПереопределяемый.ПолучитьИспользоватьКлассыСчетовВКачествеГрупп() Тогда
		СчетЗатратыПоЭлементам 		= ПланыСчетов.Хозрасчетный.ЗатратыПоЭлементам;
	Иначе
		СчетЗатратыПоЭлементам	= Новый Массив;
		СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.МатериальныеЗатраты);
		СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ЗатратыНаОплатуТруда);
		СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ОтчисленияНаСоциальныеМероприятия);
		СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.Амортизация);
		СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты);
		СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам);
	КонецЕсли;
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетЗатратыПоЭлементам",  СчетЗатратыПоЭлементам);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НалоговыйУчет", ПараметрыОтчета["ПоказательНУ"]);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	//Таблица выпуска
	Группировка = НайтиПоИмени(НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ТаблицаВыпуска").Строки,"НоменклатураВыпуска");
	
	//Себестоимость
	Строка = Группировка.Структура.Добавить(); 
	КоличествоЗаписейСтроки = Строка.ПараметрыВывода.Элементы.Найти("КоличествоЗаписей");
	КоличествоЗаписейСтроки.Значение = 1;
	КоличествоЗаписейСтроки.Использование = Истина;
	
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Номенклатура");
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Параметры.НазваниеСебестоимостьЕдВыпуска");
	
	ГруппаПоказателиСтрока1 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоказателиСтрока1.Использование = КоличествоПоказателей > 1;
	ГруппаПоказателиСтрока1.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСуммыСтрока1 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСуммыСтрока1.Использование = Истина;
	ГруппаСуммыСтрока1.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Количество
	Строка = Группировка.Структура.Добавить(); 
	КоличествоЗаписейСтроки = Строка.ПараметрыВывода.Элементы.Найти("КоличествоЗаписей");
	КоличествоЗаписейСтроки.Значение = 1;
	КоличествоЗаписейСтроки.Использование = Истина;
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Параметры.НазваниеПустоеПоле");
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Параметры.НазваниеКоличествоВыпуска");
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Ресурсы.КоличествоВыпуска");
	
	//Сумма
	Строка = Группировка.Структура.Добавить(); 
	КоличествоЗаписейСтроки = Строка.ПараметрыВывода.Элементы.Найти("КоличествоЗаписей");
	КоличествоЗаписейСтроки.Значение = 1;
	КоличествоЗаписейСтроки.Использование = Истина;
	
	ГруппаПодразделениеНомГруппа = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПодразделениеНомГруппа.Использование = Истина;
	ГруппаПодразделениеНомГруппа.Расположение  = РасположениеПоляКомпоновкиДанных.Вместе;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПодразделениеНомГруппа, "Подразделение");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПодразделениеНомГруппа, "НоменклатурнаяГруппа");
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Параметры.НазваниеФактическаяСтоимостьВыпуска");
	
	ГруппаПоказателиСтрока3 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоказателиСтрока3.Использование = КоличествоПоказателей > 1;
	ГруппаПоказателиСтрока3.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСуммыСтрока3 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСуммыСтрока3.Использование = Истина;
	ГруппаСуммыСтрока3.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказателиСтрока3, "ПоказателиВыпуска." + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСуммыСтрока3, "Ресурсы.Сумма" + ИмяПоказателя + "Выпуска");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказателиСтрока1, "ПоказателиВыпуска." + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСуммыСтрока1, "Ресурсы.СтоимостьЕд" + ИмяПоказателя + "Выпуска");
		КонецЕсли;
	КонецЦикла;	
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");
		
	//Основная таблица
	Таблица	= НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ОсновнаяТаблица");
	
	ГруппировкаВидЗатрат = НайтиПоИмени(Таблица.Строки,"Группировки.ВидЗатрат");
	ОтборГруппировкаВидЗатрат = ГруппировкаВидЗатрат.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаВидЗатрат.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ГруппировкаСтатьяЗатрат = НайтиПоИмени(ГруппировкаВидЗатрат.Структура,"Группировки.СтатьяЗатрат");
	ОтборГруппировкаСтатьяЗатрат = ГруппировкаСтатьяЗатрат.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаСтатьяЗатрат.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ГруппировкаКорСчетЗатрат = НайтиПоИмени(ГруппировкаСтатьяЗатрат.Структура,"Группировки.КорСчетЗатрат");
	ОтборГруппировкаКорСчетЗатрат = ГруппировкаКорСчетЗатрат.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаКорСчетЗатрат.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ГруппировкаКорСубконто1Затрат = НайтиПоИмени(ГруппировкаКорСчетЗатрат.Структура,"Группировки.КорСубконто1Затрат");
	ОтборГруппировкаКорСубконто1Затрат = ГруппировкаКорСубконто1Затрат.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаКорСубконто1Затрат.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ГруппировкаИтогоРасходов = НайтиПоИмени(Таблица.Строки,"ИтогоРасходов");
	
	ОтборГруппировкаИтогоРасходов = ГруппировкаИтогоРасходов.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаИтогоРасходов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	
	// Колонка "показатели"
	Если КоличествоПоказателей > 1 Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "Показатели";
		Колонка.Использование = Истина;
		
		ГруппаПоказатели = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	
	// Колонка "Количество"
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "Количество";
	Колонка.Использование = Истина;
	
	Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Использование = Истина;
	Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.КоличествоЗатрат");
	
	// Колонка "Стоимость"
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "Стоимость";
	Колонка.Использование = Истина;
	
	Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Использование = Истина;
	Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.СтоимостьЕд" + ИмяПоказателя + "Затрат");
		КонецЕсли;
	КонецЦикла;
	
	// Колонка "Сумма"
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "КолонкаСуммаЗатрат";
	Колонка.Использование = Истина;
	КоличествоЗаписейСтроки = Колонка.ПараметрыВывода.Элементы.Найти("КоличествоЗаписей");
	КоличествоЗаписейСтроки.Значение = 1;
	КоличествоЗаписейСтроки.Использование = Истина;
	
	Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Использование = Истина;
	Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	
	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.Сумма" + ИмяПоказателя + "Затрат");
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаВидЗатрат, "Ресурсы.Сумма" + ИмяПоказателя + "Затрат",0,ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаИтогоРасходов, "Ресурсы.Сумма" + ИмяПоказателя + "Затрат",0,ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаСтатьяЗатрат, "Ресурсы.Сумма" + ИмяПоказателя + "Затрат",0,ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаКорСчетЗатрат, "Ресурсы.Сумма" + ИмяПоказателя + "Затрат",0,ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаКорСубконто1Затрат, "Ресурсы.Сумма" + ИмяПоказателя + "Затрат",0,ВидСравненияКомпоновкиДанных.НеРавно);
			
		КонецЕсли;
	КонецЦикла;
	
	//Таблица НЗП
	Группировка = НайтиПоИмени(НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ТаблицаНЗП").Строки,"ОстатокНЗП");
	
	//Заголовок
	Строка = Группировка.Структура.Добавить(); 
	КоличествоЗаписейСтроки = Строка.ПараметрыВывода.Элементы.Найти("КоличествоЗаписей");
	КоличествоЗаписейСтроки.Значение = 1;
	КоличествоЗаписейСтроки.Использование = Истина;
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Параметры.ОстатокНЗП");
	
	//Остаток НЗП на начало периода
	Строка = Группировка.Структура.Добавить(); 
	КоличествоЗаписейСтроки = Строка.ПараметрыВывода.Элементы.Найти("КоличествоЗаписей");
	КоличествоЗаписейСтроки.Значение = 1;
	КоличествоЗаписейСтроки.Использование = Истина;
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Параметры.НЗПНаНачалоПериода");
	
	ГруппаПоказателиСтрока1 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоказателиСтрока1.Использование = КоличествоПоказателей > 1;
	ГруппаПоказателиСтрока1.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСуммыСтрока1 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСуммыСтрока1.Использование = Истина;
	ГруппаСуммыСтрока1.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Остаток НЗП на конец периода
	Строка = Группировка.Структура.Добавить(); 
	КоличествоЗаписейСтроки = Строка.ПараметрыВывода.Элементы.Найти("КоличествоЗаписей");
	КоличествоЗаписейСтроки.Значение = 1;
	КоличествоЗаписейСтроки.Использование = Истина;
	
	Поле = Строка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Параметры.НЗПНаКонецПериода");
	
	ГруппаПоказателиСтрока2 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоказателиСтрока2.Использование = КоличествоПоказателей > 1;
	ГруппаПоказателиСтрока2.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСуммыСтрока2 = Строка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСуммыСтрока2.Использование = Истина;
	ГруппаСуммыСтрока2.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказателиСтрока1, "ПоказателиВыпуска." + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСуммыСтрока1, "Ресурсы.Сумма" + ИмяПоказателя + "НачальныйОстаток");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказателиСтрока2, "ПоказателиВыпуска." + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСуммыСтрока2, "Ресурсы.Сумма" + ИмяПоказателя + "КонечныйОстаток");
		КонецЕсли;
	КонецЦикла;	
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Тело 5 Группировка "Номенклатура выпуска"
	// 	  Тело 0 - Путая строка
	// 	  Тело 1 - ТаблицаВыпуска
	// 	  Тело 2 - Путая строка
	// 	  Тело 3 - ОсновнаяТаблица
	// 	  Тело 4 - Путая строка
	// 	  Тело 5 - ТаблицаНЗП
	
	Тело2 = МакетКомпоновки.Тело[0].Тело[2];
	Тело4 = МакетКомпоновки.Тело[0].Тело[4];
	
	//Удаляем разрыв между таблицой выпуска и основной таблицой
	Если МакетКомпоновки.Тело[0].Тело[1].Имя = "ТаблицаВыпуска" Тогда
		МакетКомпоновки.Тело[0].Тело.Удалить(Тело2);
	КонецЕсли;
	
	//Удаляем разрыв между основной таблицой и таблицой НЗП
	Если МакетКомпоновки.Тело[0].Тело[2].Имя = "ОсновнаяТаблица" Тогда
		МакетКомпоновки.Тело[0].Тело.Удалить(Тело4);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Результат.ФиксацияСверху = 0;
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	
	Возврат НаборПоказателей;
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
	КонецЦикла;	
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","КалькуляцияСебестоимости", "Калькуляция себестоимости"));
	
	Возврат Массив;
	
КонецФункции

#КонецЕсли