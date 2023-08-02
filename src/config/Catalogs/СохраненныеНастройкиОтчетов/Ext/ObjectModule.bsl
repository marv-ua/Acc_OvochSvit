﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУДЛЯ

Перем СтруктураРеквизитов Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Предопределенная и Автор.Пустая() Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	#Если Клиент Тогда
	Сообщение = "";
	
	//ПроверитьОбязательныеРеквизиты(ЭтотОбъект, Отказ, Сообщение);
	
	Если Отказ Тогда
//{{MRG[ <-> ]
		Сообщить("Настройка не может быть записана", СтатусСообщения.Важное);
//}}MRG[ <-> ]
//{{MRG[ <-> ]
//		Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Настройка ""%1"" не может быть записана:';uk='Настройка ""%1"" не може бути записана:'"), Наименование) + Сообщение, СтатусСообщения.Важное);
//}}MRG[ <-> ]
	КонецЕсли;
	
	// Если все же вариант отчета удаляем, нужно удалить все настройки пользователей панели пользователя
	Если ПометкаУдаления И Не Ссылка.ПометкаУдаления Тогда
		Выборка = ПолучитьВыборкуПодчиненныхСохраненныхНастроек();
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.УстановитьПометкуУдаления(Истина);
			Объект.Записать();
		КонецЦикла;
	КонецЕсли;
		
	#КонецЕсли

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБЪЕКТА

// Функция определяет набор реквизитов, которые должны быть заполнены обязательно.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Структура, в качестве ключей элементов содержит имена реквизитов.
//
Функция ОбязательныеРеквизиты() Экспорт

	СписокИмен = "Наименование, ";
	
	Если НЕ ЭтоГруппа Тогда
		СписокИмен = СписокИмен + "НастраиваемыйОбъект, "
	КонецЕсли;

	Возврат Новый Структура(СписокИмен);

КонецФункции

#Если Клиент Тогда
// Проверяет обязательные реквизиты объекта.
// У объекта должен быть определен экспортируемый метод ОбязательныеРеквизиты().
// У объекта должена быть определена экспортируемая переменная СтруктураРеквизитов.
//
// Параметры:
//  Объект    - объект, реквизиты которого проверяются.
//  Отказ     - Истина, если проверка выявила проблемы. В противном случае не меняется.
//              В параметр удобно передавать параметр Отказ обработчика ПередЗаписью.
//  Сообщение - строка, в которую будут дописаны "замечания", выявленные при проверке.
//              Сформированная таким образом строка может использоваться в вызывающей
//              процедуре в качестве сообщения или предупреждения.
//
Процедура ПроверитьОбязательныеРеквизиты(Объект, Отказ, Сообщение = "", ВлияющиеРеквизиты = "") Экспорт

	//Для каждого ЭлементСтруктуры Из Объект.ОбязательныеРеквизиты() Цикл
	//	ИмяРеквизита = ЭлементСтруктуры.Ключ;
	//		Если СохранениеНастроек.ПустоеЗначениеЗначения(Объект[ИмяРеквизита]) Тогда
	//			СохранениеНастроек.ОтказПриИзмененииРеквизитов(Объект, ИмяРеквизита + ", " + ВлияющиеРеквизиты, Отказ);
	//			Сообщение = Сообщение + Символы.ПС + НСтр("ru='- Не указано значение реквизита ""';uk='- Не зазначене значення реквізиту ""'") + Объект.СтруктураРеквизитов[ИмяРеквизита] + """.";
	//		КонецЕсли;
	//КонецЦикла;

КонецПроцедуры
#КонецЕсли

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//#Если Клиент Тогда	
		
	//Если ЭтотОбъект.ТипНастройки <> Перечисления.ТипыНастроек.НастройкиОтчета Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//// Проверим возможность удаления варианта пользователем
	//Если НЕ ДополнительныеСвойства.Свойство("ПрограммноеУдаление") Тогда
	//	СписокДоступныхВариантов = ТиповыеОтчеты.ПолучитьСписокДоступныхВариантов(ЭтотОбъект.НастраиваемыйОбъект,, Истина);
	//	ДоступныйВариант = СписокДоступныхВариантов.НайтиПоЗначению(ЭтотОбъект.Ссылка);
	//	Если ДоступныйВариант = Неопределено ИЛИ Не ДоступныйВариант.Пометка Тогда
	//		Отказ = Истина;
	//		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Текущему пользователю запрещено удалять вариант отчета: ';uk='Поточному користувачеві заборонено видаляти варіант звіту: '") + ЭтотОбъект);
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
	//
	//// Если все же вариант отчета удаляем, нужно удалить все настройки пользователей панели пользователя
	//Выборка = ПолучитьВыборкуПодчиненныхСохраненныхНастроек();
	//Пока Выборка.Следующий() Цикл
	//	Объект = Выборка.Ссылка.ПолучитьОбъект();
	//	Объект.Удалить();
	//КонецЦикла;
	//#КонецЕсли

КонецПроцедуры

Функция ПолучитьВыборкуПодчиненныхСохраненныхНастроек()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СохраненныеНастройкиОтчетов.Ссылка
	|ИЗ
	|	Справочник.СохраненныеНастройкиОтчетов КАК СохраненныеНастройкиОтчетов
	|ГДЕ
	//|	СохраненныеНастройкиОтчетов.ТипНастройки = ЗНАЧЕНИЕ(Перечисление.ТипыНастроек.НастройкиПользователяНастройкиОтчета)
	//|	И 
	|	СохраненныеНастройкиОтчетов.НастраиваемыйОбъект = &НастраиваемыйОбъект";
	
	Запрос.УстановитьПараметр("НастраиваемыйОбъект", ЭтотОбъект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат Выборка;
	
КонецФункции

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.Пользователи.Очистить();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ОСНОВНОЙ ПРОГРАММЫ


СтруктураРеквизитов = Новый Структура();

СтруктураРеквизитов.Вставить("ПометкаУдаления", НСтр("ru='Пометка удаления';uk='Позначка видалення'"));
СтруктураРеквизитов.Вставить("Владелец",        НСтр("ru='Пользователь-владелец';uk='Користувач-Власник'"));
СтруктураРеквизитов.Вставить("Родитель",        НСтр("ru='Группа настроек';uk='Група настройок'"));
СтруктураРеквизитов.Вставить("Наименование",    НСтр("ru='Наименование настройки';uk='Найменування настройки'"));

Для каждого Реквизит Из Метаданные.Справочники.СохраненныеНастройкиОтчетов.Реквизиты Цикл
	СтруктураРеквизитов.Вставить(Реквизит.Имя, Реквизит.Представление());
КонецЦикла;
