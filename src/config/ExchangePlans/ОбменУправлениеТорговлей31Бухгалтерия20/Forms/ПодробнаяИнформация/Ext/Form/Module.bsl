﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Макет = ПланыОбмена.ОбменУправлениеТорговлей31Бухгалтерия20.ПолучитьМакет("ПодробнаяИнформация");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru='Информация о синхронизации данных конфигураций BAS Управление торговлей ред. 3.2 и Бухгалтерия ред. 2.1';uk='Інформація про синхронізацію даних конфігурацій BAS Управління торгівлею ред. 3.2 і Бухгалтерія ред. 2.1'");

КонецПроцедуры
