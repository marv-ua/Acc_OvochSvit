﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	УстановитьВидимостьЭлементовФормы();
	
	Попытка
		//ЗаблокироватьДанныеФормыДляРедактирования();
		ЗаблокироватьДокументНаСервере();
	Исключение
		ОписаниеБлокировки = ОписаниеОшибки();
		ЭтаФорма.ТолькоПросмотр = Истина;
		Элементы.Группа2.ЦветФона = WebЦвета.Красный;
	КонецПопытки;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтаФорма.ТолькоПросмотр Тогда
		ПоказатьОповещениеПользователя(
			Сред(ОписаниеБлокировки, СтрНайти(ОписаниеБлокировки, НСтр("ru = 'Объект уже заблокирован'; uk = 'Об’єкт вже заблокований'")), СтрДлина(ОписаниеБлокировки))
			,,, БиблиотекаКартинок.Внимание48, СтатусОповещенияПользователя.Важное, УникальныйИдентификатор
		);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    Элементы.Группа2.ЦветФона = ?(Объект.Собран, WebЦвета.БледноЗеленый, Элементы.Группа2.ЦветФона);
	
	Если Объект.Собран Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросВыУвереныЗавершение", ЭтотОбъект),
			НСтр("ru = 'Уже собран!
                  |Вы уверены что хотите работать с этой заявкой?'; uk = 'Уже зібрано!
                  |Ви впевнені що хочете працювати з цією заявкою?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			КодВозвратаДиалога.Нет,
			Нстр("ru = 'Уже собран!'; uk = 'Уже зібрано!'")
		);
	КонецЕсли;
	
	УстановитьДоступностьКнопкиСобран();
	
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
	
	//ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьЗаголовокФормыНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Попытка
		РазблокироватьДокументНаСервере();
	Исключение
	КонецПопытки;
	
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
Процедура Собран(Команда)
	
	Объект.Собран = Не Объект.Собран;
	Элементы.Группа2.ЦветФона = ?(Объект.Собран, WebЦвета.БледноЗеленый, WebЦвета.Белый);
	Модифицированность = Истина;
	
	Объект.ДатаСборки = ТекущаяДата();
	
	Попытка
		Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	УстановитьСтатусНаСервере(Объект.Собран, Объект.Идентификатор, Объект.ДокументОснование);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоСобраноПриИзменении(Элемент)
	
	Элементы.Товары.ТекущиеДанные.Собран = Истина;
	
	УстановитьДоступностьКнопкиСобран();
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьКнопкиСобран()
	
	ВсеСобраны = Истина;
	
	Для Каждого Стр Из Объект.Товары Цикл
		Если Не Стр.Собран Тогда
			ВсеСобраны = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ФормаСобран.Доступность = ВсеСобраны;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСтатусНаСервере(Собран, Идентификатор, ДокументОснование)
	
	Менеджер = РегистрыСведений.а_СтатусыЗаявок.СоздатьМенеджерЗаписи();
	Менеджер.Объект = ДокументОснование;
	Менеджер.Идентификатор = Идентификатор;
	Менеджер.ТипСтатуса = Перечисления.а_ТипыСтатусов.СтатусСобрано;
	Менеджер.СтатусСобран = Собран; 
	
	Попытка
		Менеджер.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	Если Документы.а_ЗаказНаСборку.ПользовательКладовщик() Тогда
		Элементы.Организация.Видимость = Ложь;
		Элементы.Идентификатор.Видимость = Ложь;
		Элементы.Склад.ТолькоПросмотр = Истина;
		Элементы.Группа6.ТолькоПросмотр = Истина;
		Элементы.Кладовщик.ТолькоПросмотр = Истина;
		Элементы.ТоварыКоличество.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормыНаСервере()
	
	Заголовок = СтрШаблон("%1", Объект.ПунктРазгрузки);
	
КонецПроцедуры

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

&НаКлиенте
Процедура ВопросВыУвереныЗавершение(Результат, ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Закрыть();

КонецПроцедуры

#КонецОбласти




