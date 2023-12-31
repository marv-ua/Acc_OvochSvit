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
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Справка-расчет себестоимости выпущенной продукции и оказанных услуг производственного характера ';uk='Довідка-розрахунок собівартості випущеної продукції і наданих послуг виробничого характеру '") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(?(ПараметрыОтчета.СНачалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),ПараметрыОтчета.НачалоПериода),
																										ПараметрыОтчета.КонецПериода);
	
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
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НалоговыйУчет", ПараметрыОтчета.ПоказательНУ);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");
	
	Группировка = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ЗаголовокТаблицыПоПлановымЦенам");
	
	Таблица = НайтиПоИмени(Группировка.Структура,"ПоПлановымЦенам");
	
	ГруппировкаПериод 	= НайтиПоИмени(Таблица.Строки,"Группировка");
	ГруппировкаНомГруппа = НайтиПоИмени(ГруппировкаПериод.Структура,"ГруппировкаНомГруппа");
	ГруппировкаПродукция = НайтиПоИмени(ГруппировкаПериод.Структура,"Продукция");
	
	ОтборГруппировки = Группировка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировки.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаПериод = ГруппировкаПериод.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаПериод.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаНомГруппа = ГруппировкаНомГруппа.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаНомГруппа.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаПродукция = ГруппировкаПродукция.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаПродукция.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	//Показатели группировки по периоду
	ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодСуммаБазаРасчетов 						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодСуммаНЗП			 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодРасходыВключенныеВСтоимость 			= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Группировки.ПродукцияПериод");
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Ресурсы.СуммаПлан");
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.Коэффициент");
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодСумма									= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодОтклонениеФактическойСебестоимости		= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	ГруппировкаПериодСуммаБазаРасчетов.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодСуммаНЗП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодРасходыВключенныеВСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодСумма.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;;
	ГруппировкаПериодОтклонениеФактическойСебестоимости.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;;
	
	//Показатели группировки по ном. группе и подразделению
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппа.Выбор,"Группировки.СчетУчета");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппа.Выбор,"Подразделение");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппа.Выбор,"НоменклатурнаяГруппа");
	
	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппаСуммаБазаРасчетов 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппаСуммаНЗП			 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппаРасходыВключенныеВСтоимость 			= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Группировки.ПродукцияГруппировка");
	
	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Ресурсы.СуммаПлан");
	
	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.Коэффициент");
	
	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппаСумма								= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));

	Группа = ГруппировкаНомГруппа.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппаОтклонениеФактическойСебестоимости	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	ГруппировкаНомГруппаСуммаБазаРасчетов.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаНомГруппаСуммаНЗП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаНомГруппаРасходыВключенныеВСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаНомГруппаСумма.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаНомГруппаОтклонениеФактическойСебестоимости.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Показатели группировки по номменклатуре
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукция.Выбор,"Группировки.СчетУчета");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукция.Выбор,"Подразделение");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукция.Выбор,"НоменклатурнаяГруппа");
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПродукцияСуммаБазаРасчетов 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПродукцияСуммаНЗП			 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПродукцияРасходыВключенныеВСтоимость 			= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукцияСуммаБазаРасчетов,"Ресурсы.СуммаБазаРасчетовБУ");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукцияСуммаНЗП,"Ресурсы.СуммаНЗПБУ");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукцияРасходыВключенныеВСтоимость,"Ресурсы.РасходыВключенныеВСтоимостьНУ");
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Номенклатура");
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Ресурсы.СуммаПлан");
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.Коэффициент");
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПродукцияСумма								= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
    ГруппировкаПродукцияСумма.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Группа = ГруппировкаПродукция.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПродукцияОтклонениеФактическойСебестоимости	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
    ГруппировкаПродукцияОтклонениеФактическойСебестоимости.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Таблица ПоВыручке
	Группировка = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ЗаголовокТаблицыПоВыручке");
	Таблица = НайтиПоИмени(Группировка.Структура,"ПоВыручке");
	
	ГруппировкаПериодПоВыручке 	= НайтиПоИмени(Таблица.Строки,"ГруппировкаУслуги");
	
	ГруппировкаНомГруппаПоВыручке = НайтиПоИмени(ГруппировкаПериодПоВыручке.Структура,"ГруппировкаНомГруппаУслуги");
	
	ОтборГруппировкиПоВыручке = Группировка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкиПоВыручке.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаПериодПоВыручке = ГруппировкаПериодПоВыручке.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаПериодПоВыручке.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаНомГруппаПоВыручке = ГруппировкаНомГруппаПоВыручке.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаНомГруппаПоВыручке.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
	//Показатели группировки по периоду
	ГруппировкаПериодПоВыручке.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Группа = ГруппировкаПериодПоВыручке.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодПоВыручкеСуммаБазаРасчетов 						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));

	Группа = ГруппировкаПериодПоВыручке.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодПоВыручкеСуммаНЗП			 						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));

	Группа = ГруппировкаПериодПоВыручке.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодПоВыручкеРасходыВключенныеВСтоимость 				= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	ГруппировкаПериодПоВыручкеСуммаБазаРасчетов.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодПоВыручкеСуммаНЗП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодПоВыручкеРасходыВключенныеВСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Показатели группировки по ном. группе и подразделению
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаПоВыручке.Выбор,"Группировки.СчетУчета");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаПоВыручке.Выбор,"Подразделение");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаПоВыручке.Выбор,"НоменклатурнаяГруппа");
	
	Группа = ГруппировкаНомГруппаПоВыручке.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппадПоВыручкеСуммаБазаРасчетов 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаНомГруппаПоВыручке.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппадПоВыручкеСуммаНЗП			 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаНомГруппаПоВыручке.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаНомГруппадПоВыручкеРасходыВключенныеВСтоимость 			= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	ГруппировкаНомГруппадПоВыручкеСуммаБазаРасчетов.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаНомГруппадПоВыручкеСуммаНЗП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаНомГруппадПоВыручкеРасходыВключенныеВСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Добавляем показатели в группы
	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
						
			//Показатели группировки по периоду
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодСуммаБазаРасчетов, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодСуммаНЗП, "Ресурсы.СуммаНЗП" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодРасходыВключенныеВСтоимость, "Ресурсы.РасходыВключенныеВСтоимость" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодСумма, "Ресурсы.Сумма" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодОтклонениеФактическойСебестоимости, "Ресурсы.ОтклонениеФактическойСебестоимости" + ИмяПоказателя);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодПоВыручкеСуммаБазаРасчетов, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодПоВыручкеСуммаНЗП, "Ресурсы.СуммаНЗП" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодПоВыручкеРасходыВключенныеВСтоимость, "Ресурсы.РасходыВключенныеВСтоимость" + ИмяПоказателя);
			
			//Показатели группировки по ном. группе и подразделению
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаСуммаБазаРасчетов, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаСуммаНЗП, "Ресурсы.СуммаНЗП" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаРасходыВключенныеВСтоимость, "Ресурсы.РасходыВключенныеВСтоимость" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаСумма, "Ресурсы.Сумма" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппаОтклонениеФактическойСебестоимости, "Ресурсы.ОтклонениеФактическойСебестоимости" + ИмяПоказателя);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппадПоВыручкеСуммаБазаРасчетов, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппадПоВыручкеСуммаНЗП, "Ресурсы.СуммаНЗП" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаНомГруппадПоВыручкеРасходыВключенныеВСтоимость, "Ресурсы.РасходыВключенныеВСтоимость" + ИмяПоказателя);				
			
			//Показатели группировки по номменклатуре
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукцияСумма, "Ресурсы.Сумма" + ИмяПоказателя);
			
			//Отборы
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериод, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаНомГруппа, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПродукция, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
				
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиПоВыручке, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериодПоВыручке, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаНомГруппаПоВыручке, "Ресурсы.СуммаБазаРасчетов" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, "Ресурсы.Сумма" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериод, "Ресурсы.Сумма" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаНомГруппа, "Ресурсы.Сумма" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПродукция, "Ресурсы.Сумма" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
				
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиПоВыручке, "Ресурсы.Сумма" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериодПоВыручке, "Ресурсы.Сумма" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаНомГруппаПоВыручке, "Ресурсы.Сумма" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, "Ресурсы.СуммаПлан" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериод, "Ресурсы.СуммаПлан" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаНомГруппа, "Ресурсы.СуммаПлан" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПродукция, "Ресурсы.СуммаПлан" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
				
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиПоВыручке, "Ресурсы.СуммаПлан" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериодПоВыручке, "Ресурсы.СуммаПлан" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаНомГруппаПоВыручке, "Ресурсы.СуммаПлан" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			
			Если Найти("БУ,НУ",ИмяПоказателя) <> 0 Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПродукцияОтклонениеФактическойСебестоимости, "Ресурсы.ОтклонениеФактическойСебестоимости" + ИмяПоказателя);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ИтогиГруппировкиТаблицаПоПлановымЦенам 	= МакетКомпоновки.Тело[0].Тело[1].Строки[0].Тело[2];
	ИтогиГруппировкиТаблицаПоВыручке 		= МакетКомпоновки.Тело[2].Тело[1].Строки[0].Тело[2];
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Двойная,1);

	МакетИтоговТаблицыПоПолановымЦенам = МакетКомпоновки.Макеты[МакетКомпоновки.Тело[0].Тело[1].Строки[0].МакетПодвала.Макет];	
	МакетИтоговТаблицыПоВыручке = МакетКомпоновки.Макеты[МакетКомпоновки.Тело[2].Тело[1].Строки[0].МакетПодвала.Макет];	
	
	Для ИндексЯчейки = 0 По МакетИтоговТаблицыПоПолановымЦенам.Макет[0].Ячейки.Количество() - 1 Цикл
		МакетИтоговТаблицыПоПолановымЦенам.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Значение = Линия;
		МакетИтоговТаблицыПоПолановымЦенам.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Использование = Истина;
	КонецЦикла;
	
	Для ИндексЯчейки = 0 По МакетИтоговТаблицыПоВыручке.Макет[0].Ячейки.Количество() - 1 Цикл
		МакетИтоговТаблицыПоВыручке.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Значение = Линия;
		МакетИтоговТаблицыПоВыручке.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Использование = Истина;
	КонецЦикла;
	
	
	//Удаляем лишние итоги
		МакетКомпоновки.Тело[0].Тело[1].Строки[0].Тело.Удалить(ИтогиГруппировкиТаблицаПоПлановымЦенам);
		МакетКомпоновки.Тело[2].Тело[1].Строки[0].Тело.Удалить(ИтогиГруппировкиТаблицаПоВыручке);
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
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
	КонецЦикла;	
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

#КонецЕсли