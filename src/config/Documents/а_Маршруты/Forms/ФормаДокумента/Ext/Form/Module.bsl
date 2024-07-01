﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//Попытка
	//	//ЗаблокироватьДанныеФормыДляРедактирования();
	//	ЗаблокироватьДокументНаСервере();
	//Исключение
	//	ОписаниеБлокировки = ОписаниеОшибки();
	//	ЭтаФорма.ТолькоПросмотр = Истина;
	//	//Элементы.Группа2.ЦветФона = WebЦвета.Красный;
	//КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Если ЭтаФорма.ТолькоПросмотр Тогда
	//	ПоказатьОповещениеПользователя(
	//		Сред(ОписаниеБлокировки, СтрНайти(ОписаниеБлокировки, НСтр("ru = 'Объект уже заблокирован'; uk = 'Об’єкт вже заблокований'")), СтрДлина(ОписаниеБлокировки))
	//		,,, БиблиотекаКартинок.Внимание48, СтатусОповещенияПользователя.Важное, УникальныйИдентификатор
	//	);
	//КонецЕсли;	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеВопросаЗаполнитьЗавершение", ЭтотОбъект),
		Нстр("ru = 'Заполнить?
	          |Данные будут перезаполнены.'; uk = 'Заповнити?
	          |Дані буде перезаповнено.'"),
		РежимДиалогаВопрос.ДаНет,
		,
		,
		Нстр("ru = 'Заполнить?'; uk = 'Заповнити?'"),
	);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПунктыРазгрузкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекСтрока = Элементы.ПунктыРазгрузки.ТекущиеДанные;
	
	Если Поле = Элементы.ПунктыРазгрузкиЗаявка Тогда
		
		Если ЗначениеЗаполнено(ТекСтрока.Заявка) Тогда
			
			ПоказатьЗначение(,ТекСтрока.Заявка);
			
		КонецЕсли;
		
	ИначеЕсли Поле = Элементы._ПунктыРазгрузкиПунктРазгрузки Или Поле = Элементы.ПунктыРазгрузкиПунктРазгрузки Тогда
		
		ПоказатьЗначение(,ТекСтрока.ПунктРазгрузки);
		
	ИначеЕсли Поле = Элементы.ПунктыРазгрузкиМаршрут Тогда
		
		ПоказатьЗначение(,ТекСтрока.Маршрут);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обработан(Команда)

	ТекТЧ = "ПунктыРазгрузки";
	ВыделенныеСтроки = Элементы.ПунктыРазгрузки.ВыделенныеСтроки;
	
	Для Каждого С Из ВыделенныеСтроки Цикл
		ТекДанные = Объект[ТекТЧ].НайтиПоИдентификатору(С);
		Если Не ТекДанные = Неопределено Тогда
			ТекДанные.СтатусОбработан = Не ТекДанные.СтатусОбработан;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработанПоВодителю(Команда)

	ВыделенныеСтроки = Элементы.ИтогиПоВодителям.ВыделенныеСтроки;
	
	Для Каждого С Из ВыделенныеСтроки Цикл
		ТекДанные = ИтогиПоВодителям.НайтиПоИдентификатору(С);
		Если Не ТекДанные = Неопределено Тогда
			Для Каждого СтрПункты Из Объект.ПунктыРазгрузки Цикл
			    Если СтрПункты.Водитель = ТекДанные.Водитель И СтрПункты.ДатаОтгрузки = ТекДанные.ДатаОтгрузки Тогда 
					СтрПункты.СтатусОбработан = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменаВодителя(Команда)
	Сп = ПолучитьСписокЗначенийВодителей();
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ПослеЗакрытияВыбораИзСпискаВодителей", ЭтотОбъект),
		Сп,
		Элементы.ПунктыРазгрузкиВодитель,
		Сп.НайтиПоЗначению(Элементы.ПунктыРазгрузки.ТекущиеДанные.Водитель)
	);
КонецПроцедуры

&НаКлиенте
Процедура СортировкаГрупповая1(Команда)
	СортировкаГрупповая();
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЗаявкиПоВодителю(Команда)
	
	ТекДанные = Элементы.ИтогиПоВодителям.ТекущиеДанные;
	ТабДок = ПечатьЗаявкиНаСервере(ТекДанные.Водитель, ТекДанные.Авто, ТекДанные.ДатаОтгрузки);
	ТабДок.Показать("Заявка_"+СокрЛП(ТекДанные.Водитель));

КонецПроцедуры

&НаКлиенте
Процедура ПунктыРазгрузкиВодительПриИзменении(Элемент)
	ПунктыРазгрузкиВодительПриИзмененииНаСервере(Элементы.ПунктыРазгрузки.ТекущаяСтрока);
	
	Док = ерпсАктПриемкиПередачиСервер.ПолучитьРТУ(Элементы.ПунктыРазгрузки.ТекущиеДанные.Идентификатор, Элементы.ПунктыРазгрузки.ТекущиеДанные.Заявка, Истина);
	Если ЗначениеЗаполнено(Док) Тогда
		Если Не Док.Водитель = Элементы.ПунктыРазгрузки.ТекущиеДанные.Водитель Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("ПослеВопросаЗаменаВодителяВРеализации", ЭтотОбъект, Док)
				, СтрШаблон(Нстр("ru = 'Заменить водителя в реализации %1?'; uk = 'Замінити водія в реалізації %1?'"), Док)
				, РежимДиалогаВопрос.ДаНет
				,
				,
				, Нстр("ru = 'Заменить водителя в реализации?'; uk = 'Замінити водія в реалізації?'") 
			);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктыРазгрузкиПриИзменении(Элемент)
	ОбновитьИтогиПоВодителям();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	//Попытка
	//	РазблокироватьДокументНаСервере();
	//Исключение
	//КонецПопытки;		
КонецПроцедуры

&НаКлиенте
Процедура СортироватьВывезено(Команда)
	Объект.ПунктыРазгрузки.Сортировать("СтатусОбработан");
КонецПроцедуры

&НаКлиенте
Процедура ПунктыРазгрузкиДатаОтгрузкиПриИзменении(Элемент)
	ТекДанные = Элементы.ПунктыРазгрузки.ТекущиеДанные;
	
	ерпсАктПриемкиПередачиСервер.ЗаписатьДатуВывоза(ТекДанные.ПунктРазгрузки, ТекДанные.ДатаОтгрузки);
	
	ИзменитьДатуЗаказаНаСборкуНаСервере(ТекДанные.Заявка, ТекДанные.Идентификатор, ТекДанные.ДатаОтгрузки);
	
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктыРазгрузкиМаршрутПриИзменении(Элемент)
	ТекДанные = Элементы.ПунктыРазгрузки.ТекущиеДанные;
	ИзменитьМаршрутНаСервере(ТекДанные.ПунктРазгрузки, ТекДанные.кМаршрут);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьДанныеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

КонецПроцедуры

&НаКлиенте
Процедура ПоискОчистка(Элемент, СтандартнаяОбработка)
	УстановитьОтбор("Водитель", "");
КонецПроцедуры

&НаКлиенте
Процедура ПоискИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	УстановитьОтбор("Водитель", Текст);
КонецПроцедуры

&НаКлиенте
Процедура ПоискПунктРазгрузкиОчистка(Элемент, СтандартнаяОбработка)
	УстановитьОтбор("ПунктРазгрузки", "");
КонецПроцедуры

&НаКлиенте
Процедура ПоискПунктРазгрузкиИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	УстановитьОтбор("ПунктРазгрузки", Текст);
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтправленоПриИзменении(Элемент)
	
	УстановитьОтборОтправлено("СтатусОбработан", ?(ОтборОтправлено = 2, Ложь, ?(ОтборОтправлено = 1, Истина, "")));

КонецПроцедуры


#Область СлужебныеПроцедурыИФункцииБСП

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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

&НаКлиенте
Процедура ПослеВопросаЗаменаВодителяВРеализации(Результат, Док) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Водитель = Элементы.ПунктыРазгрузки.ТекущиеДанные.Водитель;
		Если Не Док.Водитель = Водитель Тогда	
			ЗаменитьВодителяВРеализацииНаСервере(Док, Водитель);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаменитьВодителяВРеализацииНаСервере(Док, Водитель)
	
	Об = Док.ПолучитьОбъект();
	Если Об <> Неопределено Тогда
				
		Об.Водитель = Водитель;
		
		Попытка
			Об.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборОтправлено(ТекЭлементОтбора, ТекЗначениеОтбора)
	
    СтруктураПоиска = Новый Структура;
	Если Элементы.ПунктыРазгрузки.ОтборСтрок = Неопределено Тогда
		Перейти ~Метка;
	КонецЕсли;
	Для Каждого Эл Из Элементы.ПунктыРазгрузки.ОтборСтрок Цикл
		Если Эл.Ключ = ТекЭлементОтбора Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска.Вставить(Эл.Ключ, Эл.Значение);
	КонецЦикла;
	
	~Метка:
	
	Если ТекЗначениеОтбора <> "" Тогда
		СтруктураПоиска.Вставить(ТекЭлементОтбора, ТекЗначениеОтбора);
	КонецЕсли;
	
	Элементы.ПунктыРазгрузки.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтбор(ТекЭлементОтбора, ТекЗначениеОтбора)
	
	ВторойЭлементОтбора = ""; ТретийЭлементОтбора = "";
	Если ТекЭлементОтбора = "Водитель" Тогда
		ВторойРеквизитыФормы = "ПоискПунктРазгрузки";
		ВторойЭлементОтбора = "ПунктРазгрузки";
		//ТретийРеквизитыФормы = "ОтборОтправлено";
		//ТретийЭлементОтбора = "СтатусОбработан";
	Иначе
		ВторойРеквизитыФормы = "ПоискВодитель";
		ВторойЭлементОтбора = "Водитель";
		//ТретийРеквизитыФормы = "ОтборОтправлено";
		//ТретийЭлементОтбора = "СтатусОбработан";
	КонецЕсли;
	
	//Если ТекЭлементОтбора = "СтатусОбработан" Тогда
	//	ТретийРеквизитыФормы = "ОтборОтправлено";
	//	ТретийЭлементОтбора = "СтатусОбработан";
	//КонецЕсли;
	
	СтруктураПоиска = Новый Структура;
	Если ТекЗначениеОтбора <> "" Тогда
		СтруктураПоиска.Вставить(ТекЭлементОтбора, ТекЗначениеОтбора);
	КонецЕсли;
	
	Если ЭтотОбъект[ВторойРеквизитыФормы] <> "" Тогда
		СтруктураПоиска.Вставить(ВторойЭлементОтбора,ЭтотОбъект[ВторойРеквизитыФормы]);
	КонецЕсли;
	
	//Если ЭтотОбъект[ТретийРеквизитыФормы] <> "" Тогда
	//	СтруктураПоиска.Вставить(ТретийЭлементОтбора,ТекЗначениеОтбора);
	//КонецЕсли;

	Элементы.ПунктыРазгрузки.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураПоиска);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьДатуЗаказаНаСборкуНаСервере(Заявка, Идентификатор, ДатаОтгрузки)
	
	ТекЗаказ = Документы.а_ЗаказНаСборку.ЕстьЗаказнаСборку(Заявка, Идентификатор);
	
	Если ТекЗаказ = Неопределено Тогда
		Возврат;
	КонецЕсли;
			
	Если НачалоДня(ТекЗаказ.Дата) = НачалоДня(ДатаОтгрузки) Тогда
		Возврат;
	КонецЕсли;
	
	Об = ТекЗаказ.ПолучитьОбъект();

	Об.Дата = ДатаОтгрузки;
	Об.ДополнительныеСвойства.Вставить("ПроверятьБлокировку", Истина);
	
	Попытка
		Об.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Не вдалося змінити дату замовлення на збірку " + ТекЗаказ + Символы.ПС + ОписаниеОшибки(),
			ТекЗаказ
		);
	КонецПопытки;
	
КонецПроцедуры


&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ОбновитьИтогиПоВодителям();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаЗаполнитьЗавершение(Результат, ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Об = РеквизитФормыВЗначение("Объект");
	
	Об.ЗаполнитьМаршруты();
	
	ЗначениеВРеквизитФормы(Об, "Объект");
	
	ОбновитьИтогиПоВодителям();
	
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтогиПоВодителям()
	
	Т = Объект.ПунктыРазгрузки.Выгрузить();
	Т.Свернуть("ДатаОтгрузки,Водитель,Авто", "Количество");
	ИтогиПоВодителям.Загрузить(Т);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокЗначенийВодителей()
	Сп = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
				   //|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних КАК КадроваяИсторияСотрудниковСрезПоследних
				   //|		ПО Сотрудники.Ссылка = КадроваяИсторияСотрудниковСрезПоследних.Сотрудник
	               |ГДЕ
	               |	НЕ Сотрудники.ВАрхиве
				   |	И Сотрудники.а_Авто <> ЗНАЧЕНИЕ(Справочник.Авто.ПустаяСсылка)";
				   //|	И КадроваяИсторияСотрудниковСрезПоследних.Должность.Наименование = ""Водій""
				   //|	И НЕ КадроваяИсторияСотрудниковСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)";
	Т = Запрос.Выполнить().Выгрузить();
	Сп.ЗагрузитьЗначения(Т.ВыгрузитьКолонку("Ссылка"));
	Возврат Сп;
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВыбораИзСпискаВодителей(Результат, Парам2) Экспорт
	Если НЕ Результат = Неопределено Тогда
		Для Каждого Элемент Из Элементы.ПунктыРазгрузки.ВыделенныеСтроки Цикл
			ТекСтрока = Объект.ПунктыРазгрузки.НайтиПоИдентификатору(Элемент);
			ТекСтрока.Водитель = Результат.Значение;
			
			Если ЗначениеЗаполнено(ЗначениеРеквизитаОбъекта(Результат.Значение, "а_Авто")) Тогда
				ТекСтрока.Авто = ЗначениеРеквизитаОбъекта(Результат.Значение, "а_Авто");
			КонецЕсли;
			Если ЗначениеЗаполнено(ЗначениеРеквизитаОбъекта(Результат.Значение, "а_Прицеп")) Тогда
				ТекСтрока.Прицеп = ЗначениеРеквизитаОбъекта(Результат.Значение, "а_Прицеп");
			КонецЕсли;
			
			Док = ерпсАктПриемкиПередачиСервер.ПолучитьРТУ(ТекСтрока.Идентификатор, ТекСтрока.Заявка, Истина);
			Если ЗначениеЗаполнено(Док) Тогда
				Если Не Док.Водитель = ТекСтрока.Водитель Тогда
					ПоказатьВопрос(Новый ОписаниеОповещения("ПослеВопросаЗаменаВодителяВРеализации", ЭтотОбъект, Док)
						, СтрШаблон(Нстр("ru = 'Заменить водителя в реализации %1?'; uk = 'Замінити водія в реалізації %1?'"), Док)
						, РежимДиалогаВопрос.ДаНет
						,
						,
						, Нстр("ru = 'Заменить водителя в реализации?'; uk = 'Замінити водія в реалізації?'") 
					);
				КонецЕсли;
			КонецЕсли;			
			
		КонецЦикла;
	КонецЕсли;
	Элементы.ПунктыРазгрузки.Обновить();
	ОбновитьДанныеНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные);
КонецФункции

&НаСервере
Процедура ПунктыРазгрузкиВодительПриИзмененииНаСервере(Эл)
	Об = РеквизитФормыВЗначение("Объект"); 
	Попытка
		ИдентификаторСтроки = Объект.ПунктыРазгрузки.НайтиПоИдентификатору(Эл).Идентификатор;
	Исключение
	КонецПопытки;
	ЗаполнитьДаннымиСотрудника(Эл, Об, ИдентификаторСтроки);                                                 

	ЗначениеВРеквизитФормы(Об, "Объект");
	
	ОбновитьДанныеНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДаннымиСотрудника(НомерСтроки = Неопределено, Об, ИдентификаторСтроки = "")
	
	Если НомерСтроки = Неопределено Тогда
		Для Каждого ТекДанные Из Об.ПунктыРазгрузки Цикл
			Если ЗначениеЗаполнено(ТекДанные.Водитель) Тогда
				Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Авто) Тогда
					//Если Не ЗначениеЗаполнено(ТекДанные.Авто) Тогда
						ТекДанные.Авто = ТекДанные.Водитель.а_Авто;
					//КонецЕсли;
				КонецЕсли;
				Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Прицеп) Тогда
					//Если Не ЗначениеЗаполнено(ТекДанные.Прицеп) Тогда
						ТекДанные.Прицеп = ТекДанные.Водитель.а_Прицеп;
					//КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Попытка
			ТекДанныеМассив = Об.ПунктыРазгрузки.НайтиСтроки(Новый Структура("Идентификатор", ИдентификаторСтроки));
			ТекДанные = ТекДанныеМассив[0];		
		Исключение
			ТекДанные = Об.ПунктыРазгрузки[НомерСтроки];
		КонецПопытки;
		
		Если ЗначениеЗаполнено(ТекДанные.Водитель) Тогда
			Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Авто) Тогда
				ТекДанные.Авто = ТекДанные.Водитель.а_Авто;
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Прицеп) Тогда
				ТекДанные.Прицеп = ТекДанные.Водитель.а_Прицеп;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПечатьЗаявкиНаСервере(Водитель, Авто, ДатаОтгрузки)
	
	М = Новый Массив;
	Для Каждого С Из Объект.ПунктыРазгрузки Цикл
		Если С.Авто = Авто и С.Водитель = Водитель Тогда
			М.Добавить(С.Заявка);
		КонецЕсли;
	КонецЦикла;
	
	М = ОбщегоНазначенияКлиентСервер.СвернутьМассив(М);
	ПунктыРазгрузкиДокумента = Объект.ПунктыРазгрузки.Выгрузить(,"ПунктРазгрузки").ВыгрузитьКолонку("ПунктРазгрузки");
	
	ОтборыПФ = Новый Структура("Водитель,Авто,ДатаВывоза", Водитель, Авто, ДатаОтгрузки);
	Если ПунктыРазгрузкиДокумента.Количество() Тогда
		ОтборыПФ.Вставить("ПунктыРазгрузки", ПунктыРазгрузкиДокумента);
	КонецЕсли;
	ОтборыПФ.Вставить("Количество", 0);
	
	Возврат Документы.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.Печать_ОтчетПоЗаявкам(
		М,
		Неопределено,
		ОтборыПФ,
		"ОсновнаяСхемаКомпоновкиДанных1"
	); 	
	
КонецФункции

&НаСервере
Процедура ЗаблокироватьДокументНаСервере()
	
	Если объект.Ссылка.Пустая() тогда
		возврат;
	КонецЕсли;
	
	ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка,, УникальныйИдентификатор);

КонецПроцедуры


&НаСервере
Процедура РазблокироватьДокументНаСервере()

	РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеНаСервере()
	                                                              
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регион", Объект.Регион);
	Запрос.УстановитьПараметр("Таб", Объект.ПунктыРазгрузки.Выгрузить());
	Запрос.Текст = "ВЫБРАТЬ
	               |	Т.ПунктРазгрузки КАК ПунктРазгрузки,
	               |	Т.Идентификатор КАК Идентификатор,
	               |	Т.Заявка КАК Заявка,
	               |	Т.ДатаОтгрузки КАК ДатаОтгрузки
	               |ПОМЕСТИТЬ ВТТаб
	               |ИЗ
	               |	&Таб КАК Т
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	&Регион КАК Регион,
	               |	Т.ПунктРазгрузки КАК ПунктРазгрузки,
	               |	ДЕНЬНЕДЕЛИ(Т.ДатаОтгрузки) КАК ДеньНедели,
	               |	Т.ДатаОтгрузки КАК ДатаОтгрузки,
	               |	Т.Идентификатор КАК Идентификатор,
	               |	Маршруты.Ссылка КАК кМаршрут,
	               |	Маршруты.Ссылка КАК Маршрут,
	               |	МАКСИМУМ(Товары.Примечание) КАК Пометка,
	               |	ПунктыРазгрузки.Обработано КАК ЗаявкаОбработана,
				   |	ПунктыРазгрузки.ДатаОтгрузки КАК ДатаЗаявка
	               |ИЗ
	               |	ВТТаб КАК Т
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.а_Маршруты.ПунктыРазгрузки КАК Маршруты
	               |		ПО (&Регион = Маршруты.Ссылка.Владелец)
	               |			И Т.ПунктРазгрузки = Маршруты.ПунктРазгрузки
				   //|			И (ДЕНЬНЕДЕЛИ(Т.ДатаОтгрузки) = Маршруты.Ссылка.ДеньВывоза)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.Товары КАК Товары
	               |		ПО Т.Заявка = Товары.Ссылка
	               |			И Т.Идентификатор = Товары.Идентификатор
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.ПунктыРазгрузки КАК ПунктыРазгрузки
	               |		ПО Т.Заявка = ПунктыРазгрузки.Ссылка
	               |			И Т.Идентификатор = ПунктыРазгрузки.Идентификатор
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Т.ПунктРазгрузки,
	               |	Т.ДатаОтгрузки,
	               |	Т.Идентификатор,
	               |	Маршруты.Ссылка,
	               |	Маршруты.Ссылка,
	               |	ПунктыРазгрузки.Обработано,
				   |	ПунктыРазгрузки.ДатаОтгрузки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		М = Объект.ПунктыРазгрузки.НайтиСтроки(Новый Структура("Идентификатор", Выборка.Идентификатор));		
		
		Для Каждого Эл Из М Цикл
			ЗаполнитьЗначенияСвойств(Эл, Выборка, "кМаршрут,Маршрут,Пометка,ЗаявкаОбработана,ДатаЗаявка",);
		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СортировкаГрупповая()
	
	Объект.ПунктыРазгрузки.Сортировать("ДатаОтгрузки,ПунктРазгрузки,Количество,Водитель");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьМаршрутНаСервере(ПунктРазгрузки, Маршрут)
	
	Справочники.а_Маршруты.ЗаписатьПунктРазгрузкиВМаршрут(ПунктРазгрузки, Маршрут);
	
КонецПроцедуры









