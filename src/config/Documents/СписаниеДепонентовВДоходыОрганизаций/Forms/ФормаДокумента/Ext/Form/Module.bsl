﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// первоначальное заполнение объекта
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Организация",	"Объект.Организация");
		ЗначенияДляЗаполнения.Вставить("Ответственный",	"Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		УстановитьДоступностьЭлементов(ЭтаФорма);
		
		УстановитьФункциональныеОпцииФормы();
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СчетУчетаРасходов) Тогда
		УстановитьВидимостьСубконто(0)
	Иначе
		УстановитьВидимостьСубконто(Объект.СчетУчетаРасходов.ВидыСубконто.Количество());
	КонецЕсли;


	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьДоступностьЭлементов(ЭтаФорма);

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаРасходовПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементовНаСервере();
		
КонецПроцедуры // СчетУчетаРасходовПриИзменении()

&НаКлиенте
Процедура Субконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОписаниеТипа = Элемент.ОграничениеТипа;
	Если ОписаниеТипа.СодержитТип(Тип("СправочникСсылка.ПодразделенияОрганизаций")) или
		ОписаниеТипа.СодержитТип(Тип("СправочникСсылка.БанковскиеСчета")) Тогда
		Элемент.ВыборПоВладельцу = ЭтаФорма.Объект.Организация;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Субконто1АвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ОписаниеТипа = Элемент.ОграничениеТипа;
	Если ОписаниеТипа.СодержитТип(Тип("СправочникСсылка.ПодразделенияОрганизаций")) или
		ОписаниеТипа.СодержитТип(Тип("СправочникСсылка.БанковскиеСчета")) Тогда
		Элемент.ВыборПоВладельцу = ЭтаФорма.Объект.Организация;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1ОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ОписаниеТипа = Элемент.ОграничениеТипа;
	Если ОписаниеТипа.СодержитТип(Тип("СправочникСсылка.ПодразделенияОрганизаций")) или
		ОписаниеТипа.СодержитТип(Тип("СправочникСсылка.БанковскиеСчета")) Тогда
		Элемент.ВыборПоВладельцу = ЭтаФорма.Объект.Организация;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;

	ЗаполнитьНаСервере();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы() 
	
	ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Объект.Организация);
	
	ПараметрыФО = Новый Структура("Организация", ГоловнаяОрганизация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСубконто(КоличествоСубконто)

	
	Для Ном = 1 По 3 Цикл
		
		Если ЗначениеЗаполнено(Объект.СчетУчетаРасходов) И (Ном <= КоличествоСубконто) Тогда
			Элементы["Субконто"+Ном].Заголовок = Объект.СчетУчетаРасходов.ВидыСубконто[Ном-1].ВидСубконто.Наименование;
			Элементы["Субконто"+Ном].Видимость   = Истина;
		Иначе
			Элементы["Субконто"+Ном].Видимость   = Ложь;
		КонецЕсли;

	КонецЦикла;
    	
КонецПроцедуры // УстановитьВидимостьСубконто()

&НаСервере
Процедура УстановитьВидимостьЭлементовНаСервере()
	
	КоличествоСубконто = Объект.СчетУчетаРасходов.ВидыСубконто.Количество();
	УстановитьВидимостьСубконто(КоличествоСубконто);

	Если КоличествоСубконто > 0 Тогда
		Объект.Субконто1 = Объект.СчетУчетаРасходов.ВидыСубконто[0].ВидСубконто.ТипЗначения.ПривестиЗначение(ЭтаФорма.Элементы.Субконто1);
	КонецЕсли;

	Если КоличествоСубконто > 1 Тогда
		Объект.Субконто2 = Объект.СчетУчетаРасходов.ВидыСубконто[1].ВидСубконто.ТипЗначения.ПривестиЗначение(ЭтаФорма.Элементы.Субконто2);
	КонецЕсли;

	Если КоличествоСубконто > 2 Тогда
		Объект.Субконто3 = Объект.СчетУчетаРасходов.ВидыСубконто[2].ВидСубконто.ТипЗначения.ПривестиЗначение(ЭтаФорма.Элементы.Субконто3);
	КонецЕсли;
	
	//Для Ном = 1 По 3 Цикл
	//	
	//	Если ЗначениеЗаполнено(Объект.СчетУчетаРасходов) И (Ном <= КоличествоСубконто) Тогда
	//		Элементы["Субконто"+Ном].Заголовок = Объект.СчетУчетаРасходов.ВидыСубконто[Ном-1].ВидСубконто.Наименование;
	//		Элементы["Субконто"+Ном].Видимость   = Истина;
	//	Иначе
	//		Элементы["Субконто"+Ном].Видимость   = Ложь;
	//	КонецЕсли;

	//КонецЦикла;
	
	
КонецПроцедуры // УстановитьВидимостьЭлементовНаСервере()

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	ОрганизацияВыбрана	= ЗначениеЗаполнено(Форма.Объект.Организация);

	Форма.Элементы.ПанельДепоненты.Доступность = ОрганизацияВыбрана;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	КадровыйУчетФормы.ЗаполнитьОтветственныхЛицПоОрганизации(ЭтаФорма);
	УстановитьФункциональныеОпцииФормы();
	УстановитьДоступностьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.Автозаполнение();
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект")
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
