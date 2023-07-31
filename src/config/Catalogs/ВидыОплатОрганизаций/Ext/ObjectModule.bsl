﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа 
		И ТипОплаты = Перечисления.ТипыОплат.Наличные Тогда
		
		Если ЗначениеЗаполнено(Организация) Тогда
			Организация = Справочники.Организации.ПустаяСсылка();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Контрагент) Тогда
			Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
			ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетДеньгиВПути) Тогда
			СчетДеньгиВПути = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если НЕ ЭтоГруппа Тогда
		
		МассивНепроверяемыхРеквизитов = Новый Массив;
		
		Если ТипОплаты = Перечисления.ТипыОплат.Наличные Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Организация"); 
			МассивНепроверяемыхРеквизитов.Добавить("Контрагент"); 
			МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента"); 
			МассивНепроверяемыхРеквизитов.Добавить("СчетДеньгиВПути"); 
		КонецЕсли;
		
		// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	КонецЕсли;

КонецПроцедуры


#КонецЕсли