﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	//Список.Параметры.УстановитьЗначениеПараметра(
	//	"ПредставлениеОбособленногоПодразделения", НСтр("ru='Обособленное подразделение';uk='Відокремлений підрозділ'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"РабочаяДата", БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));

	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Не Пактум_Сервер.Пактум_Права(Ложь) Тогда
		Элементы.ПактумСоздатьПоСпискуЕДРПОУ.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаСоздать(Команда)
	
	КлючеваяОперация = "СозданиеФормыКонтрагенты";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПКлиентСервер.ПолучитьСтруктуруОтбораСписка(Список.Отбор.Элементы);
	
	Если Элементы.Список.ТекущийРодитель <> Неопределено Тогда
		ЗначенияЗаполнения.Вставить("Родитель", Элементы.Список.ТекущийРодитель);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", 
		Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтаФорма)
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если НЕ ПустаяСтрока(Элемент.ТекущиеДанные.Вид) Тогда
		КлючеваяОперация = "ОткрытиеФормыКонтрагенты";
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура Аутентификация_Завершение(Результат, ДополнительныеПараметры) Экспорт
	Пактум_КлиентПереопределяемый.Аутентификация_Завершение(ЭтаФорма, Результат);	
КонецПроцедуры

&НаКлиенте
Процедура ПактумСоздатьПоСпискуЕДРПОУ(Команда)
	Пактум_КлиентПереопределяемый.ПактумСоздатьПоСпискуЕДРПОУ(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПактумСоздатьПоСпискуЕДРПОУ_Завершение(Результат, ДополнительныеПараметры) Экспорт
	Пактум_КлиентПереопределяемый.СоздатьПоСпискуЕДРПОУ_Завершение(ЭтаФорма, Результат);
КонецПроцедуры

&НаКлиенте
Процедура НайтиИСоздатьПоСписку_Пактум()
	Пактум_КлиентПереопределяемый.НайтиИСоздатьПоСписку(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаЗавершенияФоновогоЗадания()
	Пактум_КлиентПереопределяемый.ПроверкаЗавершенияФоновогоЗадания(ЭтаФорма);
КонецПроцедуры

#КонецОбласти
