﻿Процедура ВыполнитьДействие(ОписаниеДействия) Экспорт
	
	Если ОписаниеДействия.Свойство("ИмяФормы") Тогда
		
		ОткрытьФорму(ОписаниеДействия.ИмяФормы, ОписаниеДействия.ПараметрыФормы);
		
	ИначеЕсли ОписаниеДействия.Свойство("Предупреждение") Тогда
		
		ПоказатьПредупреждение( , ОписаниеДействия.Предупреждение);
		
	ИначеЕсли ОписаниеДействия.Свойство("Вопрос") Тогда
		
		Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ОписаниеДействия);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Да",  ОписаниеДействия.ВариантДа);
		Кнопки.Добавить("Нет", ОписаниеДействия.ВариантНет);
		Кнопки.Добавить("Отмена");
		ПоказатьВопрос(Оповещение, ОписаниеДействия.Вопрос, Кнопки, , "Да");
		
	КонецЕсли;

КонецПроцедуры

Процедура ВопросЗавершение(Ответ, ОписаниеДействия) Экспорт
	
	Если Ответ = "Да" Тогда
		ОткрытьФорму(ОписаниеДействия.ДействиеДа.ИмяФормы, ОписаниеДействия.ДействиеДа.ПараметрыФормы);
	ИначеЕсли Ответ = "Нет" Тогда
		ОткрытьФорму(ОписаниеДействия.ДействиеНет.ИмяФормы, ОписаниеДействия.ДействиеНет.ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры