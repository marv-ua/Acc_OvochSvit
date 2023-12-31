﻿Функция ПолучитьСписокМакетовОформления() Экспорт
	
	СписокМакетовОформления = Новый СписокЗначений;
	Для Каждого ОбщийМакет Из Метаданные.ОбщиеМакеты Цикл
		Если ОбщийМакет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.МакетОформленияКомпоновкиДанных Тогда
			СписокМакетовОформления.Добавить(ОбщийМакет.Имя, ОбщийМакет.Синоним);
		КонецЕсли;
	КонецЦикла;
	
	СписокМакетовОформления.Добавить("Основной", НСтр("ru='Основной';uk='Основний'"));
	СписокМакетовОформления.Добавить("Яркий", НСтр("ru='Яркий';uk='Яскравий'"));
	СписокМакетовОформления.Добавить("Море", НСтр("ru='Море';uk='Море'"));
	СписокМакетовОформления.Добавить("Арктика", НСтр("ru='Арктика';uk='Арктика'"));
	СписокМакетовОформления.Добавить("Зеленый", НСтр("ru='Зеленый';uk='Зелений'"));
	СписокМакетовОформления.Добавить("Античный", НСтр("ru='Античный';uk='Античний'"));
	
	Возврат СписокМакетовОформления;
	
КонецФункции

Функция ПолучитьТекстОбособленныхПодразделений(Организация) Экспорт
	
	ТекстОрганизации = "";
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация);
	ТекстОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	Если ПустаяСтрока(ТекстОрганизации) Тогда
		ТекстОрганизации = СведенияОбОрганизации.Представление;
	КонецЕсли;
	
	ТекстОрганизации = ТекстОрганизации + НСтр("ru=' с обособленными подразделениями';uk= ' з відокремленими підрозділами'");
	
	Возврат ТекстОрганизации;
	
КонецФункции

Функция ПолучитьТекстОрганизация(Организация = Неопределено, ВключатьОбособленныеПодразделения = Ложь) Экспорт
	
	ТекстОрганизации = "";
	Попытка
		Если ЗначениеЗаполнено(Организация) Тогда
			Если ВключатьОбособленныеПодразделения Тогда
				ТекстОрганизации = ПолучитьТекстОбособленныхПодразделений(Организация);
			Иначе
				СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация);
				ТекстОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
				Если ПустаяСтрока(ТекстОрганизации) Тогда
					ТекстОрганизации = СведенияОбОрганизации.Представление;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Исключение
		// Запись в журнал регистрации не требуется
	КонецПопытки;
	
	Возврат ТекстОрганизации;
	
КонецФункции

Функция ДоступностьУчетаПоПодразделениям() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает описание типов со справочниками, имеющими владельца организацию.
//
// Возвращаемое значение:
//	ОписаниеТипов - Содержит типы справочников, имеющими владельца организацию.
//
Функция ТипыСвязанныеСОрганизацией() Экспорт
	
	Возврат БухгалтерскийУчетПереопределяемый.ТипыСвязанныеСОрганизацией();
	
КонецФункции
