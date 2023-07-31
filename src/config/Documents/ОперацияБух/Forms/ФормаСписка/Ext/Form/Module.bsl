﻿&НаКлиенте
Перем мСтруктураПараметров;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКнопкиКоманднойПанели;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы("Вручную");
	Если Копирование Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	КлючеваяОперация = "ОткрытиеФормыОперацияБух";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);

КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)

	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьСторноДокумента(Команда)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы("Сторно");
	ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОперацию(Команда)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы("Вручную");
	ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьТиповуюОперацию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьТиповуюОперациюЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ТиповыеОперации.ФормаВыбора",,ЭтаФорма,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
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
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(СпособЗаполнения = "")

	КлючеваяОперация = "СозданиеФормыОперацияБух";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	СпособыЗаполнения = Новый Массив;
	СпособыЗаполнения.Добавить("Вручную");
	СпособыЗаполнения.Добавить("Сторно");
	СпособыЗаполнения.Добавить("ТиповаяОперация");
	
	Если СпособыЗаполнения.Найти(СпособЗаполнения) <> Неопределено Тогда
		ЗначенияЗаполнения.Вставить("СпособЗаполнения", СпособЗаполнения);
	ИначеЕсли НЕ ЗначенияЗаполнения.Свойство("СпособЗаполнения")
		ИЛИ СпособыЗаполнения.Найти(ЗначенияЗаполнения.СпособЗаполнения) = Неопределено Тогда
		ЗначенияЗаполнения.Вставить("СпособЗаполнения", СпособыЗаполнения[0]);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура СоздатьТиповуюОперациюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мСтруктураПараметров = ПолучитьСтруктуруПараметровФормы("ТиповаяОперация");
		мСтруктураПараметров.ЗначенияЗаполнения.Вставить("ТиповаяОперация", Результат);
		ПодключитьОбработчикОжидания("Подключаемый_СоздатьТиповуюОперацию", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьТиповуюОперацию()
	
	ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", мСтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
