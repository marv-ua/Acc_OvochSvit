﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры") Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли; 
	
	Если ТолькоПросмотр Тогда
		
		Элементы.НаборЗаписей.ТолькоПросмотр = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ФормаКомандаОК",
			"Доступность",
			Ложь);
			
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
		
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период");
	

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
&НаКлиенте
Процедура КомандаОК(Команда)
	
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтаФорма, "СведенияОЛицахСДополнительнымиГарантиями", ОбъектВладелец);

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
    
КонецПроцедуры
