﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
						
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Ввод новых документов ""Платежный ордер на списание денежных средств"" запрещен.
|Для отражения операций используйте документы ""Списание с банковского счета""!';uk='Введення нових документів ""Платіжний ордер на списання коштів"" заборонене.
|Для відображення операцій використовуйте документи ""Списання з банківського рахунку""!'");
		Сообщение.Сообщить();
		
		Отказ = Истина;
		
		Возврат;
			
	КонецЕсли;

	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры
