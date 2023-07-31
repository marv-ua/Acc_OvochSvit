﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// первоначальное заполнение объекта
	Если Параметры.Ключ.Пустой() Тогда
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Запись.Период", "ПериодСтрокой");
	КонецЕсли;
	
	Если Не ДоступностьИзмененияЗаписи() Тогда
		ТолькоПросмотр = Истина;
		Элементы.Месяц.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ФизическоеЛицоЛСВведенДокументом = ЗначениеЗаполнено(Запись.Документ)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ЗарплатныйПроект, "ИспользоватьЭлектронныйДокументооборотСБанком");
	
	ЦветСтиляЦветТекстаПоля = ЦветаСтиля.ЦветТекстаПоля;
	УстановитьНадписьПояснения(ЭтаФорма, Запись);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Запись.Период", "ПериодСтрокой");
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Запись");
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Сообщения = ПолучитьСообщенияПользователю(Ложь);
		
		Для Каждого Сообщение Из Сообщения Цикл
			Если Найти(Сообщение.Поле, "Период") Тогда
				Сообщение.Поле = "";
				Сообщение.ПутьКДанным = "ПериодСтрокой";
				Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "Период", "Месяц");
			КонецЕсли;
		КонецЦикла;
		Отказ = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Запись");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ЗарплатныйПроектПриИзменении(Элемент)
	УстановитьНадписьПояснения(ЭтаФорма, Запись);
КонецПроцедуры

&НаКлиенте
Процедура НомерЛицевогоСчетаПриИзменении(Элемент)
	УстановитьНадписьПояснения(ЭтаФорма, Запись);
КонецПроцедуры

///////////////////////////////////////////////////////
// редактирование месяца строкой

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Запись.Период", "ПериодСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Запись.Период", "ПериодСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Запись.Период", "ПериодСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ДоступностьИзмененияЗаписи()
	
	Если Не ЗначениеЗаполнено(Запись.Документ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ЗарплатныйПроект, "ИспользоватьЭлектронныйДокументооборотСБанком");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНадписьПояснения(Форма, Запись)
	
	Если НЕ ПустаяСтрока(Запись.НомерЛицевогоСчета) Тогда
		СтруктураЛицевыеСчета = Новый Структура("Документ, ЗарплатныйПроект, НомерЛицевогоСчета, Организация, МесяцОткрытия, ФизическоеЛицо");
		ЗаполнитьЗначенияСвойств(СтруктураЛицевыеСчета, Запись);
		СтруктураПояснения = СтруктураПоясненияКНомеруЛицевогоСчета(
			СтруктураЛицевыеСчета.ФизическоеЛицо,
			Запись.ЗарплатныйПроект,
			СтруктураЛицевыеСчета.НомерЛицевогоСчета,
			СтруктураЛицевыеСчета,
			СтруктураЛицевыеСчета);
		
		ФизическоеЛицоЛСВведенДокументом = СтруктураПояснения.ВведенДокументом;
		
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(Форма, СтруктураПояснения);
	Иначе
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтруктураПоясненияКНомеруЛицевогоСчета(ФизическоеЛицо, ЗарплатныйПроект, НомерЛицевогоСчета, Знач ЛицевыеСчета, ЛицевыеСчетаПрежняя)
	
	СтруктураПояснения = ЗарплатныеПроекты.СтруктураПоясненияКНомеруЛицевогоСчета(
			ФизическоеЛицо,
			ЗарплатныйПроект,
			НомерЛицевогоСчета,
			ЛицевыеСчета,
			ЛицевыеСчетаПрежняя);
	
	Возврат СтруктураПояснения;
	
КонецФункции
