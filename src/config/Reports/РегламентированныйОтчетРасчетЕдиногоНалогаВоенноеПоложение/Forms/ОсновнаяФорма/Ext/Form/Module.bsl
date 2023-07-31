﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура управляет показом в форме периода построения отчета.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	СтрПериодОтчета = ПредставлениеПериода( НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина; Л="+РегламентированнаяОтчетностьКлиентСервер.ПолучитьКодЯзыкаИнтерфейса());
	
	Форма.НадписьПериодСоставленияОтчета = СтрПериодОтчета;

	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);

	Если КоличествоФорм >= 1 Тогда

		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;

	Иначе
		
		Форма.ОписаниеНормативДок = "";
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
	КонецЕсли;
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);

КонецПроцедуры // ПоказатьПериод()

// Процедура устанавливает границы периода построения отчета.
//
// Параметры:
//  Шаг          - число, количество стандартных периодов, на которое необходимо
//                 сдвигать период построения отчета;
//
&НаКлиенте
Процедура ИзменитьПериод(Шаг)

	мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг)); 
	мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);

	//ОбработкаПериодичностьОтчета(ЭтаФорма);
	
	ПоказатьПериод(ЭтаФорма);

КонецПроцедуры // ИзменитьПериод()

//&НаКлиентеНаСервереБезКонтекста
//Процедура ОбработкаПериодичностьОтчета(Форма)
//	
//	Если Год(Форма.мДатаКонцаПериодаОтчета) >= 2008 Тогда
//		Если Форма.ПолеВыбораПериодичность <> Форма.ПеречислениеПериодичностьКвартал Тогда
//			// Если текущая периодичность отчета не Квартал, тогда установим Квартал.
//			Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал;
//			// Инициализируем переменную мПериодичность в Квартал.
//			Форма.мПериодичность = Форма.ПолеВыбораПериодичность;
//			// Обновим данные по датам начала и конца отчета.
//			Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(Форма.мДатаКонцаПериодаОтчета);
//			Форма.мДатаНачалаПериодаОтчета = НачалоКвартала(Форма.мДатаКонцаПериодаОтчета);
//		КонецЕсли;
//		Форма.Элементы.ПолеВыбораПериодичность.Доступность = Ложь;
//	Иначе
//		Форма.Элементы.ПолеВыбораПериодичность.Доступность = Истина;
//	КонецЕсли;
//		
//КонецПроцедуры

&НаКлиенте
Функция ПолучитьФормуДляПериода(НаДату)
	
	Для Каждого Строка Из мТаблицаФормОтчета Цикл
		Если (Строка.ДатаНачалоДействия > КонецДня(НаДату)) ИЛИ
			((Строка.ДатаКонецДействия > '00010101000000') И (Строка.ДатаКонецДействия < НачалоДня(НаДату))) Тогда

			Продолжить;
		КонецЕсли;

		Если (мПериодичность =  ПеречислениеПериодичностьМесяц)   Тогда
			Если Найти(Строка.ФормаОтчета, "Мес") > 0	Тогда
				мВыбраннаяФорма = Строка.ФормаОтчета;
			Иначе
				Продолжить;
			КонецЕсли;	   
		Иначе			
			Если Найти(Строка.ФормаОтчета, "Кв") > 0	Тогда
				мВыбраннаяФорма = Строка.ФормаОтчета;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;	

		мВыбраннаяФорма = Строка.ФормаОтчета;

		Возврат мВыбраннаяФорма;
	КонецЦикла;

	// Если не удалось найти форму, соответствующую выбранному периоду,
	// то по умолчанию выдаем текущую (действующую) форму.
	Если мВыбраннаяФорма = Неопределено Тогда
		мВыбраннаяФорма = мТаблицаФормОтчета[0].ФормаОтчета;
	КонецЕсли;
	
	Возврат мВыбраннаяФорма;
	
КонецФункции // ПолучитьФормуДляПериода()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере                                
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ИсточникОтчета = СтрЗаменить(СтрЗаменить(Строка(ЭтаФорма.ИмяФормы), "Отчет.", ""), ".Форма.ОсновнаяФорма", "");
	Если Найти(ИсточникОтчета, "Внешний") > 0 Тогда 
		ИсточникОтчета = СтрЗаменить(ИсточникОтчета, "Внешний", "");
		ОтчетОбъект = ВнешниеОтчеты.Создать(ИсточникОтчета);
	Иначе
		ОтчетОбъект = Отчеты[ИсточникОтчета];
	КонецЕсли;
	
	
	
	ЗначениеВДанныеФормы(ОтчетОбъект.ТаблицаФормОтчета(), мТаблицаФормОтчета);
	
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал);
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц);
    		
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;

	ОргПоУмолчанию       = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьМесяц   = Перечисления.Периодичность.Месяц;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;

	Если НЕ ЗначениеЗаполнено(мПериодичность) ИЛИ НЕ мПериодичность = ПеречислениеПериодичностьМесяц  Тогда
		мПериодичность = ПеречислениеПериодичностьМесяц;
	КонецЕсли;

	// Устнавливаем границы периода построения отчета как Квартал
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) ИЛИ НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		
		мДатаКонцаПериодаОтчета  = КонецМесяца(ТекущаяДатаСеанса());
		мДатаНачалаПериодаОтчета = НачалоМесяца(ТекущаяДатаСеанса());
		
	КонецЕсли;
	
	ПолеВыбораПериодичность = мПериодичность;
	//ОбработкаПериодичностьОтчета(ЭтаФорма);
	
	ПоказатьПериод(ЭтаФорма);


	Если НЕ ЗначениеЗаполнено(Организация) 
	   И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	// здесь отключаем стандартную обработку ПередЗакрытием формы
	// для подавления выдачи запроса на сохранение формы.
	СтандартнаяОбработка = Ложь;

КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ Отказ Тогда
	
		ТекстПредупреждения = НСтр("ru='Формирование отчета поддерживается только для ""FREDO Звіт""!';uk='Формування звіту підтримується тільки для ""FREDO Звіт""!'");
		ПоказатьПредупреждение( , ТекстПредупреждения, 5 );
		
		Если НЕ РегламентированнаяОтчетностьКлиент.ПодключитьМенеджерЗвит1С() 
			ИЛИ глМенеджерЗвит1С = Неопределено
			ИЛИ НЕ глМенеджерЗвит1С.ФлагОтладки = Истина Тогда
			Отказ = Истина;
		КонецЕсли;
	
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПолеВыбораПериодичностьПриИзменении(Элемент)
	
	мДатаКонцаПериодаОтчета  = КонецМесяца(мДатаКонцаПериодаОтчета);
	мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);

	мПериодичность = ПолеВыбораПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуОтчетаЗавершение", ЭтаФорма);
	РегламентированнаяОтчетностьКлиент.ПроверитьВозможностьОткрытияДочернейФормыРегламентиованногоОтчета(ЭтаФорма, ОписаниеОповещения)
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Не Результат = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопирован. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(, НСтр("ru='Форма отчета изменилась, копирование невозможно!';uk='Форма звіту змінилася, копіювання неможливо!'"));
			Возврат;
						
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
				
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1';uk='%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());

		Сообщение.Сообщить();
				
		Возврат;
		
	КонецЕсли;
	
	// устанавливаем дату представления отчета как рабочая дата
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения);

КонецПроцедуры // ВыбратьФорму()

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры
