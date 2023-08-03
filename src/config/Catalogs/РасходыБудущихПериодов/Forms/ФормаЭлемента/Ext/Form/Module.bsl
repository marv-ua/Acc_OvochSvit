﻿/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МОДУЛЯ ФОРМЫ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетБУ);
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
	                            "СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3");
	
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
	                                 "ЗаголовокСубконтоБУ1", "ЗаголовокСубконтоБУ2", "ЗаголовокСубконтоБУ3"); 
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(Форма, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)

	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора().СодержитТип(ТипЗнч(ПараметрыОбъекта[ИмяПоля])) Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", Форма.Объект[ИмяСчета]);
	СписокПараметров.Вставить("Организация", ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));

	Возврат СписокПараметров;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета)

	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
		Форма, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента);

КонецПроцедуры
	
&НаСервереБезКонтекста
Функция ПолучитьЗначениеПоУмолчанию(Настройка)

	Возврат БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию(Настройка);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ХарактерЗатрат = УправлениеПроизводствомВызовСервера.ПолучитьХарактерЗатратПоСчетуЗатрат(Объект.СчетБУ, Неопределено);
	
	Элементы.НалоговоеНазначение.Видимость = (ХарактерЗатрат = "Производство" ИЛИ ХарактерЗатрат = "Строительство" ИЛИ ХарактерЗатрат = "ОПЗ");
	Элементы.НалоговоеНазначениеДоходовИЗатрат.Видимость = (ХарактерЗатрат = "Затраты" ИЛИ ХарактерЗатрат = "ОПЗ");
	Элементы.ДекорацияНадписьТЗР.Видимость = (ХарактерЗатрат = "ТЗР");
	
	Если ХарактерЗатрат = "ОПЗ" Тогда
		Элементы.НалоговоеНазначениеДоходовИЗатрат.Заголовок = НСтр("ru='Нал. назн. затрат до 01.08.2011 для ОПЗ';uk='Нал. призн. витрат до 01.08.2011 для ЗВВ'");
	Иначе
		Элементы.НалоговоеНазначениеДоходовИЗатрат.Заголовок = НСтр("ru='Нал. назн. затрат';uk='Подат. призн. витрат'");
	КонецЕсли;
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
Процедура СчетЗатратПриИзменении(Элемент)
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетБУ);
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3", 
	                              "СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3");
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетБУ, Объект, ПоляОбъекта);
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоПриИзменении(Элемент)

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");

КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = СписокПараметровВыбораСубконто(ЭтаФорма, Объект, "СубконтоБУ%Индекс%", "СчетБУ");
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

// Для статей РПБ по договорам добровольного страхования предлагается автоматическая
// установка способа признания расходов по календарным дням соответственно статье 272 гл.25 НК

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		Объект.МетодРаспределения = Перечисления.МетодыРаспределенияРБП.ПоДням;
	КонецЕсли;

	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры
