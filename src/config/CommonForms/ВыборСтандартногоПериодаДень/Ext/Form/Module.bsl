﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода  = Параметры.КонецПериода;
	
	Если НачалоДня(НачалоПериода) = НачалоДня(КонецПериода) Тогда
		День = НачалоПериода;
	Иначе
		День = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеньПриИзменении(Элемент)
	
	РезультатВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоДня(День), КонецДня(День));
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти