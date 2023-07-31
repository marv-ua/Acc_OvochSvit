﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоЭтотУзел = (Объект.Ссылка = ОбменСообщениямиВнутренний.ЭтотУзел());
	
	Элементы.ГруппаИнформационныхСообщений.Видимость = Не ЭтоЭтотУзел;
	
	Если Не ЭтоЭтотУзел Тогда
		
		Если Объект.Заблокирована Тогда
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru='Эта конечная точка заблокирована.';uk='Ця кінцева точка заблокована.'");
		ИначеЕсли Объект.Ведущая Тогда
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru='Эта конечная точка является ведущей, т.е. инициирует отправку и получение сообщений обмена для текущей информационной системы.';uk='Ця кінцева точка є ведучою, тобто ініціює відправлення та отримання повідомлень обміну для поточної інформаційної системи.'");
		Иначе
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru='Эта конечная точка является ведомой, т.е. выполняет отправку и получение сообщений обмена только по требованию текущей информационной системы.';uk='Ця кінцева точка є відомою, тобто виконує відправлення та отримання повідомлень обміну тільки на вимогу поточної інформаційної системи.'");
		КонецЕсли;
		
		Элементы.СделатьЭтуКонечнуюТочкуВедомой.Видимость = Объект.Ведущая И Не Объект.Заблокирована;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Оповестить(ОбменСообщениямиКлиент.ИмяСобытияЗакрытаФормаКонечнойТочки());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ОбменСообщениямиКлиент.ИмяСобытияУстановленаВедущаяКонечнаяТочка() Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СделатьЭтуКонечнуюТочкуВедомой(Команда)
	
	ПараметрыФормы = Новый Структура("КонечнаяТочка", Объект.Ссылка);
	
	ОткрытьФорму("ОбщаяФорма.УстановкаВедущейКонечнойТочки", ПараметрыФормы, ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти
