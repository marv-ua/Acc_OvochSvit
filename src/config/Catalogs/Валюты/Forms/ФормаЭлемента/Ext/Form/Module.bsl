﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если Параметры.Свойство("КодВалюты") Тогда
			Объект.Код = Параметры.КодВалюты;
		КонецЕсли;
		
		Если Параметры.Свойство("НаименованиеКраткое") Тогда
			Объект.Наименование = Параметры.НаименованиеКраткое;
		КонецЕсли;
		
		Если Параметры.Свойство("НаименованиеПолное") Тогда
			Объект.НаименованиеПолное = Параметры.НаименованиеПолное;
		КонецЕсли;
		
		Если Параметры.Свойство("Загружается") И Параметры.Загружается Тогда
			Объект.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		Иначе 
			Объект.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
		КонецЕсли;
		
		Если Параметры.Свойство("ПараметрыПрописиНаРусском") Тогда
			Объект.ПараметрыПрописиНаРусском = Параметры.ПараметрыПрописиНаРусском;
		КонецЕсли;
		
		Если Параметры.Свойство("ПараметрыПрописиНаУкраинском") Тогда
			Объект.ПараметрыПрописиНаУкраинском = Параметры.ПараметрыПрописиНаУкраинском;
		КонецЕсли;
		
	КонецЕсли;
	
	ЕстьФормаПрописей = Истина;
	
	УстановитьДоступностьЭлементов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница "Основные сведения".

&НаКлиенте
Процедура ОсновнаяВалютаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПодготовитьДанныеВыбораПодчиненнойВалюты(ДанныеВыбора, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура КурсВалютыПриИзменении(Элемент)
	УстановитьДоступностьЭлементов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПрописиВалютыНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриИзмененииПараметровПрописиВалюты", ЭтотОбъект);
	Если ЕстьФормаПрописей Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ПараметрыОткрытия.Вставить("ПараметрыПрописиНаУкраинском", 	Объект.ПараметрыПрописиНаУкраинском);
		ПараметрыОткрытия.Вставить("ПараметрыПрописиНаРусском", 	Объект.ПараметрыПрописиНаРусском);
		ИмяФормыРедактированияПрописей = "Справочник.Валюты.Форма.ПараметрыПрописиВалюты";
		ОткрытьФорму(ИмяФормыРедактированияПрописей, ПараметрыОткрытия, ЭтотОбъект, , , , ОписаниеОповещения);
	Иначе
		ПоказатьВводСтроки(ОписаниеОповещения, Объект.ПараметрыПрописиНаРусском, НСтр("ru='Параметры прописи валюты';uk='Параметри пропису валюти'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ПодготовитьДанныеВыбораПодчиненнойВалюты(ДанныеВыбора, Ссылка)
	
	// Подготавливает список выбора для подчиненной валюты таким образом,
	// чтобы в список не попала сама подчиненная валюта.
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка,
	|	Валюты.НаименованиеПолное КАК НаименованиеПолное,
	|	Валюты.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Ссылка <> &Ссылка
	|	И Валюты.ОсновнаяВалюта = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюты.НаименованиеПолное";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.НаименованиеПолное + " (" + Выборка.Наименование + ")");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	Элементы.ГруппаНаценкаНаКурсДругойВалюты.Доступность = Объект.СпособУстановкиКурса = ПредопределенноеЗначение("Перечисление.СпособыУстановкиКурсаВалюты.НаценкаНаКурсДругойВалюты");
	Элементы.ФормулаРасчетаКурса.Доступность = Объект.СпособУстановкиКурса = ПредопределенноеЗначение("Перечисление.СпособыУстановкиКурсаВалюты.РасчетПоФормуле");
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровПрописиВалюты(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Объект.ПараметрыПрописиНаРусском 	= Результат;
		Возврат;
	КонецЕсли; 
	
	Объект.ПараметрыПрописиНаРусском 	= Результат.ПараметрыПрописиНаРусском;
	Объект.ПараметрыПрописиНаУкраинском = Результат.ПараметрыПрописиНаУкраинском;
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти
