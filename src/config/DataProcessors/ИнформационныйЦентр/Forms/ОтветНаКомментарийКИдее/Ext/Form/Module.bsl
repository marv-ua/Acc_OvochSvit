﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторИдеи = Параметры.ИдентификаторИдеи;
	ИдентификаторКомментария = Параметры.ИдентификаторКомментария;
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	
	Если ПустаяСтрока(Текст) Тогда 
		ВызватьИсключение НСтр("ru='Поле комментарий должно быть заполнено';uk='Поле коментар має бути заповнено'");
	КонецЕсли;
	ДобавитьКомментарий();
	Оповестить("ДобавленКомментарийКИдее");
	Закрыть();
	
	ПоказатьОповещениеПользователя("ru = 'Комментарий добавлен'");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьКомментарий()
	
	Попытка
		WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиЦентраИдей();
		WSПрокси.addIdeaComment(ИдентификаторИдеи, Строка(ИдентификаторПользователя), ИдентификаторКомментария, Текст);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВЦентреИдей();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти