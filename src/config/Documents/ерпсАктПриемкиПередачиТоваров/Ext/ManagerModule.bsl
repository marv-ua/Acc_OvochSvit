﻿
#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Акт об оказании услуг
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Акт";
	КомандаПечати.Представление = НСтр("ru='Акт прийому передачі товару';uk='Акт прийому передачі товару'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаДокумента";
	
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Акт", НСтр("ru='Акт прийому передачі товару';uk='Акт прийому передачі товару'"), 
			ПолучитьТабличныйДокумент_Акт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ерпсАктПриемкиПередачиТоваров.Макет", , Истина);
	КонецЕсли;
		
КонецПроцедуры 

Функция ПолучитьТабличныйДокумент_Акт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)

	УстановитьПривилегированныйРежим(Истина);
	

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ерпсАктПриемкиПередачиТоваров.Макет");	
	// печать производится на языке, указанном в настройках
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	УстановитьПривилегированныйРежим(Истина);

	
	
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
	//ОбластьОписанияАкта3 	 = Макет.ПолучитьОбласть("ОписанияАкта3");
	ОбластьОписанияАкта4 	 = Макет.ПолучитьОбласть("ОписанияАкта4");

	//ОбластьМестоСоставления  = Макет.ПолучитьОбласть("МестоСоставления");

	ОбластьПодписи			 = Макет.ПолучитьОбласть("Подписи");
	//...получение областей макета
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	
	//Заполнение параметров макета
	СтруктураПараметровДокуемнта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(МассивОбъектов[0],"Дата, Номер, Договор,Склад, Контрагент, Организация,АдрессДоставки, ПредставительОрганизации,ПредставительКонтрагента,ПериодОтгрузки");
	
	ОбластьЗаголовок.Параметры.НомерДок = СтруктураПараметровДокуемнта.Номер;
	
	ТабДокумент.Вывести(ОБластьЗаголовок);
	
	ОбластьШапка.Параметры.МестоСотовленияАкта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураПараметровДокуемнта.Склад,"Местонахождение");
	ОбластьШапка.Параметры.ДатаДока			   = Формат(СтруктураПараметровДокуемнта.Дата,"ДЛФ=DD;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
	ОбластьШапка.Параметры.ПериодОтгрузки	   = СокрЛП(СтрШаблон("%1 (%2)", СтруктураПараметровДокуемнта.ПериодОтгрузки.ПредставлениеПериода, СтруктураПараметровДокуемнта.ПериодОтгрузки));
	
	ТабДокумент.Вывести(ОбластьШапка);
	СтруктураДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктураПараметровДокуемнта.Договор,"Номер,Дата");
	
	ОбластьТекстАктаПред.Параметры.ДатаДоговора =  Формат(СтруктураДоговора.Дата,"ДЛФ=DD;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
	ОбластьТекстАктаПред.Параметры.ТекстДоговор = "Договору поставки №"+СтруктураДоговора.Номер+" від";  
	ТабДокумент.Вывести(ОбластьТекстАктаПред);
	ТабДокумент.Вывести(ОбластьПробел);
	
	РеквизитыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктураПараметровДокуемнта.Контрагент ,"НаименованиеПолное,КодПоЕДРПОУ");
	
	ОбластьТекстАктаНачало.Параметры.ПолноеНаименованиеПокупателя = РеквизитыКонтрагента.НаименованиеПолное;
	ОбластьТекстАктаНачало.Параметры.КодЭРДПОУПокупателя		  = РеквизитыКонтрагента.КодПоЕДРПОУ;
	ОбластьТекстАктаНачало.Параметры.АдрессПокупателя			  = ПолучитьАдрес(СтруктураПараметровДокуемнта.Контрагент); 
	ТабДокумент.Вывести(ОбластьТекстАктаНачало);
	ТабДокумент.Вывести(ОбластьПробел);
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктураПараметровДокуемнта.Организация ,"НаименованиеПолное,КодПоЕДРПОУ");
	
	ОбластьТекстАктаКонец.Параметры.ПолноеНаименованиеОрг = РеквизитыОрганизации.НаименованиеПолное;
	ОбластьТекстАктаКонец.Параметры.КодЭРДПОУОрг		  = РеквизитыОрганизации.КодПоЕДРПОУ;
	ОбластьТекстАктаКонец.Параметры.АдрессОрг			  = ПолучитьАдрес(СтруктураПараметровДокуемнта.Организация);
	ТабДокумент.Вывести(ОбластьТекстАктаКонец);
	ТабДокумент.Вывести(ОбластьПробел);
	ТабДокумент.Вывести(ОбластьОписанияАктаНач);
	
	
	ОбластьОписанияАкта1.Параметры.АдрессДоставки = СтруктураПараметровДокуемнта.АдрессДоставки;
	ОбластьОписанияАкта1.Параметры.ДатаДоговора   = Формат(СтруктураДоговора.Дата,"ДЛФ=DD;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
	ОбластьОписанияАкта1.Параметры.ТекстДоговор	  = "Договору поставки №"+СтруктураДоговора.Номер+" від";
	ТабДокумент.Вывести(ОбластьОписанияАкта1);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ерпсАктПриемкиПередачиТоваровТовары.Номенклатура.НаименованиеПолное КАК Номенклатура,
		|	СУММА(ерпсАктПриемкиПередачиТоваровТовары.Количество) КАК Количество,
		|	ерпсАктПриемкиПередачиТоваровТовары.Примечание КАК Примечание,
		|	ерпсАктПриемкиПередачиТоваровТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|ИЗ
		|	Документ.ерпсАктПриемкиПередачиТоваров.Товары КАК ерпсАктПриемкиПередачиТоваровТовары
		|ГДЕ
		|	ерпсАктПриемкиПередачиТоваровТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ерпсАктПриемкиПередачиТоваровТовары.Номенклатура.НаименованиеПолное,
		|	ерпсАктПриемкиПередачиТоваровТовары.ЕдиницаИзмерения,
		|	ерпсАктПриемкиПередачиТоваровТовары.Примечание";
	
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов[0]);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Номер = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ОбластьДанныеСтрока.Параметры,ВыборкаДетальныеЗаписи);
		ОбластьДанныеСтрока.Параметры.НомерСтроки = Номер;
		ТабДокумент.Вывести(ОбластьДанныеСтрока);
		Номер = Номер+1;
	КонецЦикла;
	ТабДокумент.Вывести(ОбластьПробел);
	
	ОбластьИтоги.Параметры.ВсегоТоваров = ВыборкаДетальныеЗаписи.Количество();
	ОбластьИтоги.Параметры.ОбщийВес = Запрос.Выполнить().Выгрузить().Итог("Количество"); 
	ТабДокумент.Вывести(ОбластьИтоги); 
	
	ТабДокумент.Вывести(ОбластьПробел);
	
	ОбластьОписанияАкта2.Параметры.ТекстДоговор = "Договору поставки №"+СтруктураДоговора.Номер+" від";
	ОбластьОписанияАкта2.Параметры.ДатаДоговора = Формат(СтруктураДоговора.Дата,"ДЛФ=DD;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
	
	ТабДокумент.Вывести(ОбластьОписанияАкта2);
	//ТабДокумент.Вывести(ОбластьОписанияАкта3);
	ТабДокумент.Вывести(ОбластьОписанияАкта4);  
	
	ДанныеПредставителя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(СтруктураПараметровДокуемнта.Организация,СтруктураПараметровДокуемнта.ПредставительОрганизации, СтруктураПараметровДокуемнта.Дата);
	ДолжностьПредставителя = СокрЛП(ДанныеПредставителя.Должность);
	
	ДолжностьФИОПредставителя = ?(ЗначениеЗаполнено(ДолжностьПредставителя),ДолжностьПредставителя + " ","") + 
								?(ДанныеПредставителя.Фамилия = Неопределено,"",ДанныеПредставителя.Фамилия + " ") + 
								?(ДанныеПредставителя.Имя = Неопределено,"",ДанныеПредставителя.Имя + " ") +
								?(ДанныеПредставителя.Отчество = Неопределено,"",ДанныеПредставителя.Отчество);
	
	ОбластьПодписи.Параметры.ПредставительПоставщика = ДолжностьФИОПредставителя;
	
	//ДанныеПредставителя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(СтруктураПараметровДокуемнта.Организация,СтруктураПараметровДокуемнта.ПредставительКонтрагента, СтруктураПараметровДокуемнта.Дата);
	//ДолжностьПредставителя = СокрЛП(ДанныеПредставителя.Должность);
	//
	//ДолжностьФИОПредставителя = ?(ЗначениеЗаполнено(ДолжностьПредставителя),ДолжностьПредставителя + " ","") + 
	//							?(ДанныеПредставителя.Фамилия = Неопределено,"",ДанныеПредставителя.Фамилия + " ") + 
	//							?(ДанныеПредставителя.Имя = Неопределено,"",ДанныеПредставителя.Имя + " ") +
	//							?(ДанныеПредставителя.Отчество = Неопределено,"",ДанныеПредставителя.Отчество);

	//
	//ОбластьПодписи.Параметры.ПредставительПокупателя = ДанныеПредставителя;
	ТабДокумент.Вывести(ОбластьПробел);
	ТабДокумент.Вывести(ОбластьПодписи);
	//...заполнение параметров макета               
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабДокумент;
	

КонецФункции 

Функция ПолучитьАдрес(ЭлементСправочника)
    ИмяОбъекта = ЭлементСправочника.Метаданные().Имя;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОрганизацииКонтактнаяИнформация.Представление КАК Представление
		|ИЗ
		|	Справочник."+ИмяОбъекта+".КонтактнаяИнформация КАК ОрганизацииКонтактнаяИнформация
		|ГДЕ
		|	ОрганизацииКонтактнаяИнформация.Ссылка = &Ссылка
		|	И ОрганизацииКонтактнаяИнформация.Тип = &Тип";
	
	Запрос.УстановитьПараметр("Ссылка", ЭлементСправочника);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Представление;
	Иначе
		Возврат "Адреса не вказана";
	КонецЕсли;
	
КонецФункции



#КонецОбласти
