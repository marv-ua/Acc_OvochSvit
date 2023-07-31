﻿
#Область ПеременныеФормы


#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьОтборыПриСозданииНаСервере(Параметры);
	
	ИтогиВключены = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЖурналБанковскиеВыписки", "ИтогиВключены", Истина);
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.СписаниеСРасчетногоСчета)
		И ПравоДоступа("Редактирование", Метаданные.Документы.ПоступлениеНаРасчетныйСчет);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.ЗагрузитьИзКлиентБанк.Видимость    = МожноРедактировать;
	Элементы.СоздатьНаОсновании.Видимость       = МожноРедактировать;
	
	Если ИтогиВключены Тогда
		Элементы.ГруппаИтоги.Видимость = Истина;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СформироватьПараметрыИтогов(ЭтотОбъект));
	Иначе
		Элементы.ГруппаИтоги.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(ОтборыПриОткрытии) Тогда
		
		Если ОтборыПриОткрытии.Свойство("Организация") И ЗначениеЗаполнено(ОтборыПриОткрытии.Организация) Тогда
			ОтборОрганизация = ОтборыПриОткрытии.Организация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
		
		Если ОтборыПриОткрытии.Свойство("БанковскийСчет") И ЗначениеЗаполнено(ОтборыПриОткрытии.БанковскийСчет) Тогда
			ОтборБанковскийСчет = ОтборыПриОткрытии.БанковскийСчет;
			ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);	
		КонецЕсли;
		
		Если ОтборыПриОткрытии.Свойство("ДатаОтбора") И ЗначениеЗаполнено(ОтборыПриОткрытии.ДатаОтбора) Тогда
			ОтборДатаОтбора = ОтборыПриОткрытии.ДатаОтбора;
			ОтборДатаОтбораИспользование = ЗначениеЗаполнено(ОтборДатаОтбора);	
		КонецЕсли;
		
		Если ОтборОрганизация <> ОсновнаяОрганизация Тогда
			ОтборОрганизация = ОсновнаяОрганизация;
			
			// Предварительно сбросим сохраненный банковский счет, т.к. он не принадлежит текущей организации
			// и может быть проблема при RLS.
			ОтборБанковскийСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
			
			УстановитьСчетОрганизации(ОтборБанковскийСчет, ОтборОрганизация);
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
			ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);
		ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОсновнаяОрганизация = Параметр;
		Если ОсновнаяОрганизация <> ОтборОрганизация Тогда
			ОтборОрганизация                 = ОсновнаяОрганизация;
			УстановитьСчетОрганизации(ОтборБанковскийСчет, ОтборОрганизация);
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
			ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);
			
			УстановитьВосстановленныеОтборы(Истина);
			
		КонецЕсли;
		
		Если ИтогиВключены Тогда
			ВсегдаОбновлять = Истина;
			ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИтогиОбработчик", 0.2, Истина);
		КонецЕсли;
		
			
	ИначеЕсли ИмяСобытия = "ИзменениеВыписки" Тогда
		Если ИтогиВключены Тогда
			ВсегдаОбновлять = Истина;
			ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИтогиОбработчик", 0.2, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ЗначениеЗаполнено(ОтборДокумент) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыОткрытияДокумента = Неопределено;
		ПараметрыФормы.Вставить("Основание", ОтборДокумент);
		
		Если ПараметрыОткрытияДокумента <> Неопределено Тогда
			ВыбранноеЗначение = ПараметрыОткрытияДокумента.ИмяДокумента;
			ПараметрыФормы    = ПараметрыОткрытияДокумента.ПараметрыФормы;
		КонецЕсли;
		
		ОтборДокумент = Неопределено;
		ОткрытьФорму("Документ." + ВыбранноеЗначение + ".ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьИзКлиентБанк(Команда)
	
	ОткрытьФормуКлиентБанка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьНеоплаченныеПлатежныеПоручения(Команда)
	
	СтруктураОтбора = Новый Структура("Организация, БанковскийСчет, Дата", ОтборОрганизация, ОтборБанковскийСчет, ОтборДатаОтбора);
	ОткрытьФорму("Документ.ПлатежноеПоручение.Форма.ФормаПодбораНеоплаченных", Новый Структура("Отбор", СтруктураОтбора), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеНаРасчетныйСчет(Команда)
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	Если СтруктураОтбора.Свойство("ДатаОтбора") Тогда
		СтруктураОтбора.Вставить("Дата", СтруктураОтбора.ДатаОтбора);
	КонецЕсли;
	
	ОткрытьФорму("Документ.ПоступлениеНаРасчетныйСчет.ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеСРасчетногоСчета(Команда)
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	Если СтруктураОтбора.Свойство("ДатаОтбора") Тогда
		СтруктураОтбора.Вставить("Дата", СтруктураОтбора.ДатаОтбора);
	КонецЕсли;
	
	ОткрытьФорму("Документ.СписаниеСРасчетногоСчета.ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОсновании(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования",
		?(ПустаяСтрока(КлючНазначенияИспользования), "БанковскиеВыписки", КлючНазначенияИспользования));
	
	Если ТекущиеДанные <> Неопределено Тогда
		ОтборДокумент = ТекущиеДанные.Ссылка;
		ПараметрыФормы.Вставить("Основание", ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("ЖурналДокументов.Деньги.Форма.ВыборТипаДокумента", ПараметрыФормы, ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьИтоги(Команда)
	
	ИтогиВключены = НЕ ИтогиВключены;
	Элементы.ГруппаИтоги.Видимость = ИтогиВключены;
	Если ИтогиВключены тогда
		ВсегдаОбновлять = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИтогиОбработчик", 0.2, Истина);
	КонецЕсли;
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ЖурналБанковскиеВыписки", "ИтогиВключены", ИтогиВключены);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияПриИзмененииСервер();
	
	Если ИтогиВключены Тогда
		ВсегдаОбновлять = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИтогиОбработчик", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборБанковскийСчетПриИзменении(Элемент)
	
	ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);
	ОтборБанковскийСчетПриИзмененииСервер();
	
	ПересчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДатаОтбораПриИзменении(Элемент)
	
	ОтборДатаОтбораИспользование = ЗначениеЗаполнено(ОтборДатаОтбора);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "ДатаОтбора");
	
	ПересчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборБанковскийСчетИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "БанковскийСчет");
	
	ПересчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	Если ОтборОрганизацияИспользование Тогда
		Если НЕ ОтборБанковскийСчетИспользование И ЗначениеЗаполнено(ОтборБанковскийСчет) Тогда
			ОтборБанковскийСчетИспользование = Истина;
			ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "БанковскийСчет");
		КонецЕсли;
		
	ИначеЕсли ОтборБанковскийСчетИспользование Тогда
		ОтборБанковскийСчетИспользование = Ложь;
		ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "БанковскийСчет");
	КонецЕсли;
	
	ПересчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДатаИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "ДатаОтбора");
	
	ПересчитатьИтоги();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект);
		
		СписокСоздаваемыхДокументов = Новый СписокЗначений;
		СписокДоступныхПолей = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора;
		СписокДоступныхТипов = СписокДоступныхПолей.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип.Типы();
		Для каждого ДоступныйТип Из СписокДоступныхТипов Цикл
			СписокСоздаваемыхДокументов.Добавить(ДоступныйТип, Строка(ДоступныйТип));
		КонецЦикла; 
		СписокСоздаваемыхДокументов.СортироватьПоПредставлению();
		
		ПоказатьВыборИзМеню(ОписаниеОповещенияОЗавершении, СписокСоздаваемыхДокументов, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
	Если ИтогиВключены Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИтогиОбработчик", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	Оповестить("ИзменениеВыписки");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отборы

&НаСервере
Процедура УстановитьОтборыПриСозданииНаСервере(Параметры)
	
	ВходящийОтборПоОрганизации = Ложь;
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ТипЗнч(СтруктураОтбора) = Тип("Структура") Тогда
		ВходящийОтборПоОрганизации = СтруктураОтбора.Свойство("Организация", ОтборОрганизация);
		СтруктураОтбора.Свойство("БанковскийСчет", ОтборБанковскийСчет);
		СтруктураОтбора.Свойство("ДатаОтбора",     ОтборДатаОтбора);
		
		ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
		ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);
		ОтборДатаОтбораИспользование     = ЗначениеЗаполнено(ОтборДатаОтбора);
		
		ЗаполнитьОтборПриОткрытииИзПараметров(Параметры.Отбор);
		
	КонецЕсли;
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	Если НЕ ВходящийОтборПоОрганизации И ОтборОрганизация <> ОсновнаяОрганизация Тогда
		ОтборОрганизация                 = ОсновнаяОрганизация;
		УстановитьСчетОрганизации(ОтборБанковскийСчет, ОтборОрганизация);
		ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
		ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтборПриОткрытииИзПараметров(Отбор)
	
	// Нужно переложить отборы из параметров в отдельную структуру,
	// которую потом будем использовать в ПриЗагрузкеДанныхИзНастроекНаСервере
	// Так как мы устанавливаем отбор самостоятельно, то нужно очистить те поля
	// структуры "Параметры.Отбор", для которых установлен отбор из кода.
	// Если не очистить поля - то будет вызвана ошибка пересечения отборов.
	
	ОтборыПриОткрытии = Новый Структура;
	
	Если Отбор.Свойство("Организация")
		И ЗначениеЗаполнено(Отбор.Организация) Тогда
		
		ОтборыПриОткрытии.Вставить("Организация", Отбор.Организация);
		Отбор.Удалить("Организация");
		
	КонецЕсли;
	
	Если Отбор.Свойство("БанковскийСчет")
		И ЗначениеЗаполнено(Отбор.БанковскийСчет) Тогда
		
		ОтборыПриОткрытии.Вставить("БанковскийСчет", Отбор.БанковскийСчет);
		Отбор.Удалить("БанковскийСчет");
		
	КонецЕсли;
	
	Если Отбор.Свойство("ДатаОтбора")
		И ЗначениеЗаполнено(Отбор.ДатаОтбора) Тогда
		
		ОтборыПриОткрытии.Вставить("ДатаОтбора", Отбор.ДатаОтбора);
		Отбор.Удалить("ДатаОтбора");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаВыписки
	
&НаКлиенте
Процедура ОткрытьФормуКлиентБанка(ПараметрыФормы = Неопределено) Экспорт
	
	Если ПараметрыФормы = Неопределено Тогда
		ПараметрыФормы = Новый Структура;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("РежимПоУмолчанию", "ГруппаЗагрузка");
	Если ОтборОрганизацияИспользование И ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ПараметрыФормы.Вставить("Организация", ОтборОрганизация);
	КонецЕсли;
	
	Если ОтборБанковскийСчетИспользование И ЗначениеЗаполнено(ОтборБанковскийСчет) Тогда
		ПараметрыФормы.Вставить("БанковскийСчет", ОтборБанковскийСчет);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.КлиентБанк.Форма.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#Область НастройкаКлиентБанка

&НаКлиенте
Процедура НастройкаКлиентБанкаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Организация <> ОтборОрганизация Тогда
		ОтборОрганизация                 = Результат.Организация;
		ОтборБанковскийСчет              = Результат.БанковскийСчет;
		ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
		ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);
		
		УстановитьВосстановленныеОтборы(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти

#Область ПодключаемыеОбработчики

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	Если ВыбранныйЭлемент.Значение = Тип("ДокументСсылка.СписаниеСРасчетногоСчета") Тогда
		
		ИмяДокумента = "СписаниеСРасчетногоСчета";
			
	Иначе
		
		ИмяДокумента = "ПоступлениеНаРасчетныйСчет";
						
		Если СтруктураОтбора.Свойство("ДатаОтбора") Тогда
			СтруктураОтбора.Вставить("Дата", СтруктураОтбора.ДатаОтбора);
		КонецЕсли;
		
	КонецЕсли;
		
	ОткрытьФорму("Документ." + ИмяДокумента + ".ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьИтогиОбработчик()
	
	Если ИтогиВключены Тогда
		ОбновитьИтоги();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Команда.Имя = "ПодменюПечатьОбычное_Реестр" Тогда
		НастройкиДинамическогоСписка();
	КонецЕсли;
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	ОбновитьДоступностьКомандыСоздатьНаОсновании();
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область УправлениеФормой

&НаКлиенте
Процедура ОбновитьДоступностьКомандыСоздатьНаОсновании()
	
	Элементы.СоздатьНаОсновании.Доступность = Элементы.Список.ТекущаяСтрока <> Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Организация
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Организация");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборОрганизацияИспользование", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборОрганизация", ВидСравненияКомпоновкиДанных.Заполнено);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// БанковскийСчет
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "БанковскийСчет");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборБанковскийСчетИспользование", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборБанковскийСчет", ВидСравненияКомпоновкиДанных.Заполнено);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаКлиенте
// Обновление сумм остатков и оборотов за день в форме журнала
//
Процедура ОбновитьИтоги()
	
	Если НЕ ИтогиВключены Тогда
		ВсегдаОбновлять = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ТекОрганизация    = ?(ОтборОрганизацияИспользование,    ОтборОрганизация,    Неопределено);
		ТекБанковскийСчет = ?(ОтборБанковскийСчетИспользование, ОтборБанковскийСчет, Неопределено);
		Если ОтборДатаОтбора = '00010101' ИЛИ НЕ ОтборДатаОтбораИспользование Тогда
			ТекДата       = ТекущаяДата();
		Иначе
			ТекДата       = ОтборДатаОтбора;
		КонецЕсли;
	ИначеЕсли НЕ ТекДанные.Свойство("Ссылка") Тогда
		ВсегдаОбновлять = Ложь;
		Возврат;
	Иначе
		ТекДата           = ТекДанные.Дата;
		ТекОрганизация    = ТекДанные.Организация;
		ТекБанковскийСчет = ТекДанные.БанковскийСчет;
	КонецЕсли;
	
	Если ВсегдаОбновлять ИЛИ НачалоДня(ИтогиДата) <> НачалоДня(ТекДата) ИЛИ ИтогиБанковскийСчет  <> ТекБанковскийСчет Тогда
		СтруктураПараметров = Новый Структура("ТекДата, ТекОрганизация, ТекБанковскийСчет",
			ТекДата, ТекОрганизация, ТекБанковскийСчет);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СформироватьПараметрыИтогов(ЭтотОбъект, СтруктураПараметров));
	КонецЕсли;
	
	ВсегдаОбновлять = Ложь;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПараметрыИтогов(Форма, СтруктураПараметров = Неопределено)
	
	Если СтруктураПараметров = Неопределено Тогда
		ТекОрганизация    = ?(Форма.ОтборОрганизацияИспользование,    Форма.ОтборОрганизация,    Неопределено);
		ТекБанковскийСчет = ?(Форма.ОтборБанковскийСчетИспользование, Форма.ОтборБанковскийСчет, Неопределено);
		Если Форма.ОтборДатаОтбора = '00010101' ИЛИ НЕ Форма.ОтборДатаОтбораИспользование Тогда
			ТекДата = ТекущаяДата();
		Иначе
			ТекДата = Форма.ОтборДатаОтбора;
		КонецЕсли;
	Иначе
		ТекДата           = СтруктураПараметров.ТекДата;
		ТекОрганизация    = СтруктураПараметров.ТекОрганизация;
		ТекБанковскийСчет = СтруктураПараметров.ТекБанковскийСчет;
	КонецЕсли;
	
	СтруктураИтогов = ПолучитьИтоги(ТекДата, ТекОрганизация, ТекБанковскийСчет);
	
	Возврат Новый Структура(
		"ИтогиБанковскийСчет, ИтогиДата, ДатаИтогов, ИтогиНаНачалоДня, ИтогиНаКонецДня,
		|ИтогиПоступило, ИтогиСписано",
			ТекБанковскийСчет,
			ТекДата, Формат(ТекДата, "ДФ=dd.MM.yyyy"),
			СтруктураИтогов.НачальныйОстаток,
			СтруктураИтогов.КонечныйОстаток,
			СтруктураИтогов.ВсегоПоступило,
			СтруктураИтогов.ВсегоСписано);
	
КонецФункции

&НаСервереБезКонтекста
// Возвращает таблицу сумм остатков и оборотов за указанный день по указанному счету
//
Функция ПолучитьИтоги(Знач ТекДата, Знач ТекОрганизация, Знач ТекБанковскийСчет)
	
	СтруктураРезультат = Новый Структура("НаименованиеСчета,
		|НачальныйОстаток, ВсегоПоступило, ВсегоСписано, КонечныйОстаток"
		, ""
		, 0, 0, 0, 0);
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Ложь);
	// Если нет доступных организаций, то Итоги не вычисляем
	Если СписокДоступныхОрганизаций.Количество() = 0 Тогда
		Возврат СтруктураРезультат;
	ИначеЕсли ЗначениеЗаполнено(ТекОрганизация) Тогда
		// Если организация не числится в списке доступных, то Итоги не вычисляем
		Если СписокДоступныхОрганизаций.Найти(ТекОрганизация) = Неопределено Тогда
			Возврат СтруктураРезультат;
		КонецЕсли;
	КонецЕсли;
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ВТ_БИ.ЭтоВалютныйСчет
	|					ТОГДА ВТ_БИ.ВалютнаяСуммаНачальныйОстаток
	|				ИНАЧЕ ВТ_БИ.СуммаНачальныйОстаток
	|			КОНЕЦ), 0) КАК НачальныйОстаток,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ВТ_БИ.ЭтоВалютныйСчет
	|					ТОГДА ВТ_БИ.ВалютнаяСуммаОборотДт
	|				ИНАЧЕ ВТ_БИ.СуммаОборотДт
	|			КОНЕЦ), 0) КАК ВсегоПоступило,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ВТ_БИ.ЭтоВалютныйСчет
	|					ТОГДА ВТ_БИ.ВалютнаяСуммаОборотКт
	|				ИНАЧЕ ВТ_БИ.СуммаОборотКт
	|			КОНЕЦ), 0) КАК ВсегоСписано,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ВТ_БИ.ЭтоВалютныйСчет
	|					ТОГДА ВТ_БИ.ВалютнаяСуммаКонечныйОстаток
	|				ИНАЧЕ ВТ_БИ.СуммаКонечныйОстаток
	|			КОНЕЦ), 0) КАК КонечныйОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		БИ.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
	|		БИ.ВалютнаяСуммаНачальныйОстаток КАК ВалютнаяСуммаНачальныйОстаток,
	|		БИ.СуммаОборотДт КАК СуммаОборотДт,
	|		БИ.ВалютнаяСуммаОборотДт КАК ВалютнаяСуммаОборотДт,
	|		БИ.СуммаОборотКт КАК СуммаОборотКт,
	|		БИ.ВалютнаяСуммаОборотКт КАК ВалютнаяСуммаОборотКт,
	|		БИ.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
	|		БИ.ВалютнаяСуммаКонечныйОстаток КАК ВалютнаяСуммаКонечныйОстаток,
	|		ВЫБОР
	|			КОГДА БИ.ВалютнаяСуммаНачальныйОстаток <> 0
	|					ИЛИ БИ.ВалютнаяСуммаОборотДт <> 0
	|					ИЛИ БИ.ВалютнаяСуммаОборотКт <> 0
	|					ИЛИ БИ.ВалютнаяСуммаКонечныйОстаток <> 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ЭтоВалютныйСчет
	|	ИЗ
	|		РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаИтоговНачалоДня, &ДатаИтоговКонецДня, , ДвиженияИГраницыПериода, Счет В (&СчетаССубконтоБанковскиеСчета), &ВидСубконтоБанковскиеСчета, Организация В (&Организации) {(ВЫРАЗИТЬ(Субконто1 КАК Справочник.БанковскиеСчета)) КАК БанковскийСчетИтогов}) КАК БИ) КАК ВТ_БИ";
	
	Если ЗначениеЗаполнено(ТекОрганизация) Тогда
		СписокОрганизаций = Новый Массив;
		СписокОрганизаций.Добавить(ТекОрганизация);
	Иначе
		СписокОрганизаций = СписокДоступныхОрганизаций;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекБанковскийСчет) Тогда
		ЭлементОтбора = ПостроительЗапроса.Отбор.Добавить("БанковскийСчетИтогов");
		ЭлементОтбора.ВидСравнения  = ВидСравнения.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.Значение      = ТекБанковскийСчет;
		СтруктураРезультат.НаименованиеСчета = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекБанковскийСчет, "Наименование"));
	КонецЕсли;
	
	ПостроительЗапроса.Параметры.Вставить("Организации",         СписокОрганизаций);
	ПостроительЗапроса.Параметры.Вставить("ДатаИтоговНачалоДня", НачалоДня(ТекДата));
	ПостроительЗапроса.Параметры.Вставить("ДатаИтоговКонецДня",  КонецДня(ТекДата));
	ПостроительЗапроса.Параметры.Вставить("ВалютаРеглУчета",
		ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ПостроительЗапроса.Параметры.Вставить("ВидСубконтоБанковскиеСчета",
		ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.БанковскиеСчета);
	ПостроительЗапроса.Параметры.Вставить("СчетаССубконтоБанковскиеСчета",
		УчетДенежныхСредствПовтИсп.ПолучитьСчетаССубконтоБанковскиеСчета());
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатыЗапроса = ПостроительЗапроса.ПолучитьЗапрос().Выполнить();
	
	Если НЕ РезультатыЗапроса.Пустой() Тогда
		Выборка = РезультатыЗапроса.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(СтруктураРезультат, Выборка);
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

&НаКлиенте
Процедура ПересчитатьИтоги()
	
	// Вызовет пересчет итогов
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		Если ИтогиВключены Тогда
			ВсегдаОбновлять = Ложь;
			ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИтогиОбработчик", 0.2, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВосстановленныеОтборы(ТолькоОрганизацияИСчет = Ложь)
	
	// Из сохраненного отбора может прийти битая ссылка - счет в настройках сохранен, но был удален позже.
	// Проверим отбор и очистим его, если счет битый.
	Если ЗначениеЗаполнено(ОтборБанковскийСчет) Тогда
		Если ЗначениеЗаполнено(ОтборБанковскийСчет) И Не ОбщегоНазначения.СсылкаСуществует(ОтборБанковскийСчет) Тогда
			ОтборБанковскийСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
			ОтборБанковскийСчетИспользование = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "БанковскийСчет");
	
	Если НЕ ТолькоОрганизацияИСчет Тогда
		ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "ДатаОтбора");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСчетОрганизации(СчетОрганизации, Знач Организация)	
	
	Если Организация = Неопределено Тогда
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	УчетДенежныхСредствБП.УстановитьБанковскийСчет(СчетОрганизации, Организация,
		ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОтборБанковскийСчетПриИзмененииСервер()
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "БанковскийСчет");
	
КонецПроцедуры

&НаСервере
Процедура ОтборОрганизацияПриИзмененииСервер()

	УстановитьСчетОрганизации(ОтборБанковскийСчет, ОтборОрганизация);
	ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
	ОтборБанковскийСчетИспользование = ЗначениеЗаполнено(ОтборБанковскийСчет);

	УстановитьВосстановленныеОтборы(Истина);
	
КонецПроцедуры

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
