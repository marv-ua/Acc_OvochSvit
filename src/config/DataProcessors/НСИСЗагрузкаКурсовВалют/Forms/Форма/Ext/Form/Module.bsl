﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Валюты.Ссылка КАК Валюта,
				   |	Валюты.Код КАК Код,
				   |	Валюты.НаименованиеПолное КАК НаименованиеПолное,
				   |    ВЫБОР
				   |    	КОГДА Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
				   |        ТОГДА ИСТИНА
				   |        ИНАЧЕ ЛОЖЬ
				   |    КОНЕЦ КАК Пометка
	               |ИЗ
	               |	Справочник.Валюты КАК Валюты";
	Объект.Валюты.Загрузить(Запрос.Выполнить().Выгрузить());
	Объект.ДатаС = ТекущаяДата();
	Объект.ДатаПо = ТекущаяДата();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьКурсыНаСервере()
	Обработки.НСИСЗагрузкаКурсовВалют.ЗагрузитьКурсы(Объект, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКурсы(Команда)
	ОчиститьСообщения();
	ЗагрузитьКурсыНаСервере();
КонецПроцедуры

&НаСервере
Функция ВыполнитьЗагрузку()
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаименованиеФоновогоЗадания = НСтр("ru='Загрузка курсов валют';uk='Завантаження курсів валют'");
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДатаС", Объект.ДатаС);
	ПараметрыФормы.Вставить("ДатаПо", Объект.ДатаПо);
	ПараметрыФормы.Вставить("Валюты", Объект.Валюты.Выгрузить());
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеФоновогоЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.НСИСЗагрузкаКурсовВалют.ЗагрузитьКурсы", ПараметрыФормы, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьКурсыВФоне(Команда)
	
	ОчиститьСообщения();
	
	Элементы.ГруппаВыполнение.Видимость = Истина;
	Элементы.ФормаКоманднаяПанель.Доступность = Ложь;

	ОперацияЗагрузки = ВыполнитьЗагрузку();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииЗагрузки", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ОперацияЗагрузки, ОписаниеОповещения, ПараметрыОжидания);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииЗагрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.ГруппаВыполнение.Видимость = Ложь;
	Элементы.ФормаКоманднаяПанель.Доступность = Истина;
	
	ОбщегоназначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Загрузка завершена, протокол сохранен в журнале регистрации';uk='Завантаження завершено, протокол збережено в журналі реєстрації'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ГруппаВыполнение.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСсылкаНажатие(Элемент)
	ЗапуститьПриложение("https://portal.bas-soft.eu/applications/84");
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеВалюты(Команда)
	УстановитьВыбор(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыбор(Команда)
	УстановитьВыбор(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбор(Выбор)
	Для Каждого Валюта Из Объект.Валюты Цикл
		Валюта.Пометка = Выбор;
	КонецЦикла;
КонецПроцедуры
