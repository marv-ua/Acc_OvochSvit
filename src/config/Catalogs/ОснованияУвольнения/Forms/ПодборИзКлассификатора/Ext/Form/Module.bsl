﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Заполнение списка из классификатор
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуОснований();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокОснований

&НаКлиенте
Процедура СписокОснованийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСписке(СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ОбработатьВыборВСписке();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьТаблицуОснований()
	
	Если Локализация.КодЯзыкаИнтерфейса() = "uk" Тогда
		Язык = "Ukr";
	Иначе
	    Язык = "";
	КонецЕсли; 
	
	// Заполняет список из макета
	
	Макет = НСИССервер.ПолучитьМакет("ОснованияУвольненияПоКЗОТ", Справочники.ОснованияУвольнения.ПолучитьМакет("ОснованияУвольненияПоКЗОТ"));
	КлассификаторXML = Макет.ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого ЗаписьКВ Из КлассификаторТаблица Цикл
		НоваяСтрока = Основания.Добавить();
		НоваяСтрока.Наименование              = ЗаписьКВ["Title"+Язык];
		НоваяСтрока.ТекстОснования            = ЗаписьКВ["Reason"+Язык];
		НоваяСтрока.СтатьяЗакона              = ЗаписьКВ["Title"+Язык];
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки)
	
	ТекущаяСсылка = Неопределено;
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Основания[НомерСтроки];
		
		НоваяСтрока = Справочники.ОснованияУвольнения.СоздатьЭлемент();
		НоваяСтрока.Наименование          = ТекущиеДанные.Наименование;
		НоваяСтрока.ТекстОснования        = ТекущиеДанные.ТекстОснования;
		НоваяСтрока.СтатьяЗакона          = ТекущиеДанные.СтатьяЗакона;
		НоваяСтрока.Записать();
		
		Если НомерСтроки = Элементы.СписокОснований.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяСтрока.Ссылка;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТекущаяСсылка;

КонецФункции

&НаКлиенте
Процедура ОбработатьВыборВСписке(СтандартнаяОбработка = Неопределено)
	
	// Добавление элемента справочника и вывод результата пользователю
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСсылка = СохранитьВыбранныеСтроки(Элементы.СписокОснований.ВыделенныеСтроки);
	
	ОповеститьОВыборе(ТекущаяСсылка);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Основания увольнения добавлены.';uk='Підстави звільнення додані.'"), ,,БиблиотекаКартинок.Информация32);
	Закрыть();
	
КонецПроцедуры

