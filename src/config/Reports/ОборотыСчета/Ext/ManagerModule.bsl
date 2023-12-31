﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Обороты счета ';uk='Обороти рахунку '") + ПараметрыОтчета.Счет + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ИспользоватьКлассыСчетовВКачествеГрупп = БухгалтерскийУчетПереопределяемый.ПолучитьИспользоватьКлассыСчетовВКачествеГрупп();
	КоличествоУровнейКорСчет = ?(ИспользоватьКлассыСчетовВКачествеГрупп, 2, 1);
	
	Если (ПараметрыОтчета.Счет.Родитель = Неопределено ИЛИ ПараметрыОтчета.Счет.Родитель = ПланыСчетов.Хозрасчетный.ПустаяСсылка()) 
		  И ИспользоватьКлассыСчетовВКачествеГрупп Тогда
		КоличествоУровнейСчет = КоличествоУровнейКорСчет
	Иначе
		КоличествоУровнейСчет = 1;
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
		"Счет", БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархии(ПараметрыОтчета.Счет));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
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
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");
	МассивПоказателей.Добавить("Разница");

	МассивПоказателейДоп = Новый Массив;
	МассивПоказателейДоп.Добавить("ВалютнаяСумма");
	МассивПоказателейДоп.Добавить("Количество");
	
	ВидОстатков = ?(ПараметрыОтчета.РазвернутоеСальдо, "Развернутый", "");
	
	ВыводимыеПоля = Новый Массив;
	
	// Колонка "Сальдо на начало Дт"
	Если ПараметрыОтчета.СальдоНаНачалоДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "НачальноеСальдоДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на начало Кт"
	Если ПараметрыОтчета.СальдоНаНачалоКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "НачальноеСальдоКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты за период Дт"
	Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "ОборотДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		ЗначениеПараметраАвтоОтступа = ЭлементОформления.Оформление.Элементы.Найти("АвтоОтступ");
		Если ЗначениеПараметраАвтоОтступа <> Неопределено И ЗначениеПараметраАвтоОтступа.Использование Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = НСтр("ru='Уменьшенный автоотступ';uk='Зменшений автовідступ'");
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
	
	// Колонка "Обороты со счетами Дт"
	Если ПараметрыОтчета.ОборотыСоСчетамиДт Тогда
		Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда 
			Колонка = Колонка.Структура.Добавить();
		Иначе 
			Колонка = Таблица.Колонки.Добавить();
		КонецЕсли;
		Колонка.Имя           = "КорСчетДт";
		Колонка.Использование = Истина;
		
		ПолеГруппировки = Колонка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
		
		Если Не ПараметрыОтчета.ПоСубсчетамКорСчетов Тогда
			ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Колонка.Отбор, "SystemFields.LevelInGroup", КоличествоУровнейКорСчет, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		КонецЕсли;
		
		ЭлементПорядка = Колонка.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Использование     = Истина;
		ЭлементПорядка.Поле              = Новый ПолеКомпоновкиДанных("КорСчет");
		ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, "КорСчет");
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		ОтборГруппаИЛИ = Колонка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ОтборГруппаИЛИ.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		ОтборГруппаИЛИ.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты за период Кт"
	Если ПараметрыОтчета.ОборотыЗаПериодКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "ОборотКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты со счетами Кт"
	Если ПараметрыОтчета.ОборотыСоСчетамиКт Тогда
		Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда 
			Колонка = Колонка.Структура.Добавить();
		Иначе 
			Колонка = Таблица.Колонки.Добавить();
		КонецЕсли;
		Колонка.Имя           = "КорСчетКт";
		Колонка.Использование = Истина;
		
		ПолеГруппировки = Колонка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
		
		Если Не ПараметрыОтчета.ПоСубсчетамКорСчетов Тогда
			ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Колонка.Отбор, "SystemFields.LevelInGroup", КоличествоУровнейКорСчет, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		КонецЕсли;
		
		ЭлементПорядка = Колонка.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Использование     = Истина;
		ЭлементПорядка.Поле              = Новый ПолеКомпоновкиДанных("КорСчет");
		ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, "КорСчет");
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		ОтборГруппаИЛИ = Колонка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ОтборГруппаИЛИ.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		ОтборГруппаИЛИ.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на конец Дт"
	Если ПараметрыОтчета.СальдоНаКонецДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "КонечноеСальдоДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатков + "ОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на конец Кт"
	Если ПараметрыОтчета.СальдоНаКонецКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "КонечноеСальдоКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатков + "ОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	ДобавитьОтборПоВыводимымПолям(ВыводимыеПоля, КомпоновщикНастроек.Настройки, Ложь);
	
	Структура = Таблица.Строки.Добавить();
	Структура.Имя = "Счет";
	
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных")); 
	
	ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
	ПолеОформления.Поле = ПолеГруппировки.Поле;
	
	Если Не ПараметрыОтчета.ПоСубсчетам Тогда
		ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Структура.Отбор, "SystemFields.LevelInGroup", КоличествоУровнейСчет, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
		ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);			
	КонецЕсли;
	
	КоличествоГруппировок = ?(ПараметрыОтчета.ПоСубсчетам, 1, 0);
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить();
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			ПолеОформления.Поле = ПолеГруппировки.Поле;
						
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	// Период
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировкуПоПериоду(ПараметрыОтчета, Структура);
	
	Для каждого ЭлементГруппировки Из Структура.ПоляГруппировки.Элементы Цикл
		Если ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных(?(ПараметрыОтчета.Периодичность = 2, "Регистратор", "Период")) Тогда
			Поле = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			Поле.Поле = ЭлементГруппировки.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Валюта
	Если ПараметрыОтчета.ПоказательВалютнаяСумма И БухгалтерскиеОтчетыКлиентСервер.НайтиГруппировку(Таблица.Строки, "Валюта") = Неопределено Тогда
		Структура = Структура.Структура.Добавить();
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");		
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
				
	КонецЕсли;
	           
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
		
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
	// Пометить строки для удаления по счетам, на которых не ведется налоговый учет
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("НУ");
	МассивПоказателей.Добавить("Разница");
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	Для Каждого Показатель Из МассивПоказателей Цикл
		Поле = УсловноеОформление.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + Показатель + "НачальныйОстатокДт");
		Поле = УсловноеОформление.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + Показатель + "НачальныйРазвернутыйОстатокДт");
	КонецЦикла;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "Счет.НалоговыйУчет", Ложь);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
		
	Для Каждого ЭлементТелаМакета Из МакетКомпоновки.Тело Цикл 
		Если ТипЗнч(ЭлементТелаМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ПараметрыОтчета.Вставить("ВысотаШапки", МакетКомпоновки.Макеты[ЭлементТелаМакета.МакетШапки].Макет.Количество()); 
			Прервать;	
		КонецЕсли;
	КонецЦикла;
		
	Для Каждого ГруппировкаТелаКомпоновки Из МакетКомпоновки.Тело Цикл
		Если ТипЗнч(ГруппировкаТелаКомпоновки) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ПараметрыОтчета.Вставить("ШиринаШапки", МакетКомпоновки.Макеты[ГруппировкаТелаКомпоновки.МакетШапки].Макет[0].Ячейки.Количество()); 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	Результат.ФиксацияСлева = ПараметрыОтчета.ШиринаШапки;
		
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("Разница");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Задает набор опций, которые позволяет настраивать отчет.
//
// Возвращаемое значение:
//   Массив      - имена опций.
//
Функция СохраняемыеОпции() Экспорт
	
	КоллекцияНастроек = Новый Массив;
	Для каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Добавить("Показатель" + Показатель);
	КонецЦикла;
	КоллекцияНастроек.Добавить("РазвернутоеСальдо");
	КоллекцияНастроек.Добавить("ВключатьОбособленныеПодразделения");
	КоллекцияНастроек.Добавить("ПоСубсчетам");
	КоллекцияНастроек.Добавить("ПоСубсчетамКорСчетов");
	КоллекцияНастроек.Добавить("Периодичность");
	КоллекцияНастроек.Добавить("РазмещениеДополнительныхПолей");
	КоллекцияНастроек.Добавить("СальдоНаНачалоДт");
	КоллекцияНастроек.Добавить("СальдоНаНачалоКт");
	КоллекцияНастроек.Добавить("СальдоНаКонецДт");
	КоллекцияНастроек.Добавить("СальдоНаКонецКт");
	КоллекцияНастроек.Добавить("ОборотыЗаПериодДт");
	КоллекцияНастроек.Добавить("ОборотыЗаПериодКт");
	КоллекцияНастроек.Добавить("ОборотыСоСчетамиДт");
	КоллекцияНастроек.Добавить("ОборотыСоСчетамиКт");
	
	Возврат КоллекцияНастроек;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ДобавитьОтборПоВыводимымПолям(ВыводимыеПоля, Структура, ВыводитьОтбор = Истина)
	
	// Добавим отбор на пустые строки (Если все выводимые поля для записи равны 0) 
	Если ВыводитьОтбор Тогда	
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);			
	КонецЕсли;	
	
	ОтборГруппировки = Структура.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировки.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ОтборГруппировки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ПропускатьРазница = НЕ Найти(ВыводимыеПоля[0], ".Разница");
	
	Для Каждого ВыбранноеПоле Из ВыводимыеПоля Цикл
		
		Если Найти(ВыбранноеПоле, ".Разница") И ПропускатьРазница Тогда
			Продолжить;	
		КонецЕсли;	
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
		
	КонецЦикла;	
	
КонецПроцедуры	

#КонецЕсли