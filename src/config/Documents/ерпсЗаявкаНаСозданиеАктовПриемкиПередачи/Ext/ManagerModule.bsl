﻿

// Функция формирует табличный документ с печатной формой накладной,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)

	УстановитьПривилегированныйРежим(Истина);
	

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЕРПСАктПриемаПередачиТовара.Макет");
	
	// печать производится на языке, указанном в настройках
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Возврат ТабДокумент;

КонецФункции


#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Акт об оказании услуг
	//КомандаПечати = КомандыПечати.Добавить();
	//КомандаПечати.Идентификатор = "Акт";
	//КомандаПечати.Представление = НСтр("ru='Акт прийому передачі товару';uk='Акт прийому передачі товару'");
	//КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	//КомандаПечати.СписокФорм    = "ФормаСписка,ФормаДокумента";
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОтчетПоЗаякам";
	КомандаПечати.Представление = НСтр("ru='Отчет по заявкам';uk='Звіт по заявках'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Акт", НСтр("ru='Акт прийому передачі товару';uk='Акт прийому передачі товару'"), 
			ПолучитьТабличныйДокумент_Акт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ЕРПСАктПриемаПередачиТовара.Макет", , Истина);
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОтчетПоЗаякам") Тогда
		
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм
				, "ОтчетПоЗаякам"
				, НСтр("ru='Отчет по заявкам';uk='Звіт по заявках'")
				, Печать_ОтчетПоЗаявкам(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
				,
				, ИмяМакета
		);
	КонецЕсли;
		
		
КонецПроцедуры

Функция Печать_ОтчетПоЗаявкам(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент   = Новый ТабличныйДокумент();
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	ТабДокумент.ИмяПараметровПечати 	= "ПАРАМЕТРЫ_ПЕЧАТИ_Печать_ОтчетПоЗаявкам";
	Отчет = Отчеты.ОтчетПоЗаякам.Создать();

	текСсылка = МассивОбъектов[0]; 
	//Получаем схему из макета
	СхемаКомпоновкиДанных = Отчет.ПолучитьМакет(?(ЗначениеЗаполнено(ИмяМакета), ИмяМакета, "ОсновнаяСхемаКомпоновкиДанных"));
	
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	//ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Настройки.Отбор
	//		, "Регистратор"
	//		, текСсылка
	//		,
	//		,
	//		, 
	//		, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный
	//);
	
	ПараметрПериод = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заявка"));
	Если ПараметрПериод <> Неопределено Тогда
		ПараметрПериод.Значение = текСсылка;
		ПараметрПериод.Использование = Истина;
	КонецЕсли;
	ПараметрПериод = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодОтчета"));
	Если ПараметрПериод <> Неопределено Тогда
		ПараметрПериод.Использование = Ложь;
	КонецЕсли;
	
	// отбор
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") Тогда
		Если ПараметрыПечати.Свойство("Водитель") Тогда
			НовыйЭлементОтбора = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ПолеОтбора = Новый ПолеКомпоновкиДанных("Водитель");
			НовыйЭлементОтбора.ЛевоеЗначение = ПолеОтбора;
			НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НовыйЭлементОтбора.Использование = Истина;
			НовыйЭлементОтбора.ПравоеЗначение = ПараметрыПечати.Водитель;
		КонецЕсли;
		Если ПараметрыПечати.Свойство("Авто") Тогда
			НовыйЭлементОтбора = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ПолеОтбора = Новый ПолеКомпоновкиДанных("Авто");
			НовыйЭлементОтбора.ЛевоеЗначение = ПолеОтбора;
			НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НовыйЭлементОтбора.Использование = Истина;
			НовыйЭлементОтбора.ПравоеЗначение = ПараметрыПечати.Авто;
		КонецЕсли;
		Если ПараметрыПечати.Свойство("ПунктыРазгрузки") Тогда
			НовыйЭлементОтбора = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ПолеОтбора = Новый ПолеКомпоновкиДанных("ПунктРазгрузки");
			НовыйЭлементОтбора.ЛевоеЗначение = ПолеОтбора;
			НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			НовыйЭлементОтбора.Использование = Истина;
			НовыйЭлементОтбора.ПравоеЗначение = ПараметрыПечати.ПунктыРазгрузки;
		КонецЕсли;
	КонецЕсли;
	//

	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДокумент);
	
	//ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);   
	
	ПроцессорВывода.НачатьВывод();

	ЭлементРезультата = ПроцессорКомпоновкиДанных.Следующий();
	Пока ЭлементРезультата <> Неопределено Цикл
	    Если ЭлементРезультата.ЗначенияПараметров.Количество()=1 Тогда
	        Если ЭлементРезультата.ЗначенияПараметров[0].Значение = "Разорвать" Тогда
	            ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	        КонецЕсли;
	    КонецЕсли;
	    ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	    ЭлементРезультата = ПроцессорКомпоновкиДанных.Следующий();
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();
	
	ТабДокумент.АвтоМасштаб = Ложь;
	ТабДокумент.МасштабПечати = 200;
	
	Возврат ТабДокумент;
	
	
КонецФункции

Функция ПолучитьТабличныйДокумент_Акт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)

	УстановитьПривилегированныйРежим(Истина);
	

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЕРПСАктПриемаПередачиТовара.Макет");
	
	// печать производится на языке, указанном в настройках
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Возврат ТабДокумент;

КонецФункции 

Функция ПолучитьПечатнуюФормуАктаПоКонтрагенту(ДокументСсылка, СтруктураКонтрагента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЕРПСАктПриемаПередачиТовара.Макет");
	
	//Получение областей макета
	ОБластьЗаголовок     	 = Макет.ПолучитьОбласть("Заголовок"); 
	
	ОбластьШапка 		 	 = Макет.ПолучитьОбласть("Шапка");
	
	ОбластьТекстАктаПред 	 = Макет.ПолучитьОбласть("ТекстАктаПред");
	ОбластьТекстАктаНачало 	 = Макет.ПолучитьОбласть("ТекстАктаНачало");
	ОбластьТекстАктаКонец 	 = Макет.ПолучитьОбласть("ТекстАктаКонец");
	
	ОбластьОписанияАктаНач 	 = Макет.ПолучитьОбласть("ОписанияАктаНач");
	
	ОбластьПробел 			 = Макет.ПолучитьОбласть("Пробел");
	
	ОбластьОписанияАкта1 	 = Макет.ПолучитьОбласть("ОписанияАкта1");
	ОбластьДанныеСтрока  	 = Макет.ПолучитьОбласть("ОписанияАкта1Строка");
	
	ОбластьИтоги 		 	 = Макет.ПолучитьОбласть("ОписанияАкта1Итоги");
	
	ОбластьОписанияАкта2 	 = Макет.ПолучитьОбласть("ОписанияАкта2");
	ОбластьОписанияАкта3 	 = Макет.ПолучитьОбласть("ОписанияАкта3");
	ОбластьОписанияАкта4 	 = Макет.ПолучитьОбласть("ОписанияАкта4");

	ОбластьМестоСоставления  = Макет.ПолучитьОбласть("МестоСоставления");

	ОбластьПодписи			 = Макет.ПолучитьОбласть("Подписи");
	//...получение областей макета
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	
	//Заполнение параметров макета
	СтруктураПараметровДокуемнта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка,"Дата, Номер");
	
	ОбластьЗаголовок.Параметры.НомерДок = СтруктураПараметровДокуемнта.Номер;
	
	ТабДокумент.Вывести(ОБластьЗаголовок);
	
	ОбластьШапка.Параметры.МестоСотовленияАкта = "Місце складання";
	ОбластьШапка.Параметры.ДатаДока			   = Формат(СтруктураПараметровДокуемнта.Дата,"ДЛФ=DD");
	
	ТабДокумент.Вывести(ОбластьШапка);
	
	//...заполнение параметров макета
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабДокумент;
	
КонецФункции



#КонецОбласти
