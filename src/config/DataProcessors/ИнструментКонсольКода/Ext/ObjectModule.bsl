﻿Перем Связи;
Перем ОпределятьСвязи;

Функция ИмяМетаданных(ПолноеИмя)
	
	Возврат СтрПолучитьСтроку(СтрЗаменить(ПолноеИмя, ".", Символы.ПС), 1);
	
КонецФункции

Функция ОбъектМетаданныхИмеетСтандартныеРеквизиты(ПолноеИмя)
	
	Объекты = Новый Массив();
	Объекты.Добавить("Справочник");
	Объекты.Добавить("Документ");
	Объекты.Добавить("БизнесПроцесс");
	Объекты.Добавить("Задача");
	
	Возврат Объекты.Найти(ИмяМетаданных(ПолноеИмя)) <> Неопределено;
	
КонецФункции

Функция ОбъектМетаданныхИмеетИзмерения(ПолноеИмя)
	
	Объекты = Новый Массив();
	Объекты.Добавить("РегистрСведений");
	Объекты.Добавить("РегистрНакопления");
	Объекты.Добавить("РегистрБухгалетрии");
	Объекты.Добавить("РегистрРасчета");
	
	Возврат Объекты.Найти(ИмяМетаданных(ПолноеИмя)) <> Неопределено;
	
КонецФункции

Функция ОбъектМетаданныхИмеетТЧ(ПолноеИмя)
	
	Объекты = Новый Массив();
	Объекты.Добавить("Справочник");
	Объекты.Добавить("Документ");
	Объекты.Добавить("Отчет");
	Объекты.Добавить("Обработка");
	Объекты.Добавить("БизнесПроцесс");
	Объекты.Добавить("Задача");
	
	Возврат Объекты.Найти(ИмяМетаданных(ПолноеИмя)) <> Неопределено;
	
КонецФункции

Функция ОбъектМетаданныхИмеетПредопределенные(ПолноеИмя)
	
	Объекты = Новый Массив();
	Объекты.Добавить("Справочник");
	Объекты.Добавить("ПланСчетов");	
	Объекты.Добавить("ПланВидовХарактеристик");
	Объекты.Добавить("ПланВидовРасчета");
	
	Возврат Объекты.Найти(ИмяМетаданных(ПолноеИмя)) <> Неопределено;
	
КонецФункции

Функция ОписатьОбщиеМодули(Коллекция)
	
	ОписаниеКоллекции = Новый Структура();
	
	Для НомерОбъекта = 0 По Коллекция.Количество() - 1 Цикл
		ОбъектМетаданных = Коллекция.Получить(НомерОбъекта);
		ОписаниеКоллекции.Вставить(ОбъектМетаданных.Имя, Новый Структура());
	КонецЦикла;
	
	Возврат ОписаниеКоллекции
	
КонецФункции

Процедура ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, Реквизит, ПолучатьСвязиРеквизита)
	
	Связь = ?(ОпределятьСвязи И ПолучатьСвязиРеквизита, ПолучитьСвязьСОбъектомМетаданных(Реквизит), "");
				
	ОписаниеРеквизита = Новый Структура("name", Реквизит.Синоним);
	
	Если ЗначениеЗаполнено(Связь) Тогда
		ОписаниеРеквизита.Вставить("ref", Связь);
	КонецЕсли;
	
	ОписаниеРеквизитов.Вставить(Реквизит.Имя, ОписаниеРеквизита);
	
КонецПроцедуры

Процедура ЗаполнитьТипРегистра(ДополнительныеСвойства, ОбъектМетаданных, ПолноеИмя)
	
	ТипРегистра = "";
	
	Если ИмяМетаданных(ПолноеИмя) = "РегистрСведений" Тогда
		
		Если ОбъектМетаданных.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			ТипРегистра = "nonperiodical";
		Иначе
			ТипРегистра = "periodical";
		КонецЕсли;
		
	ИначеЕсли ИмяМетаданных(ПолноеИмя) = "РегистрНакопления" Тогда
		
		Если ОбъектМетаданных.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
			ТипРегистра = "balance";
		Иначе
			ТипРегистра = "turnovers";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипРегистра) Тогда
		ДополнительныеСвойства.Вставить("type", ТипРегистра);
	КонецЕсли;
	
КонецПроцедуры

Функция ОписатьКоллекциюОбъектовМетаданых(Коллекция)
	
	ОписаниеКоллекции = Новый Структура();
	
	Для НомерОбъекта = 0 По Коллекция.Количество() - 1 Цикл
		
		ОписаниеРеквизитов = Новый Структура();
		ОписаниеРесурсов = Новый Структура();
		ОписаниеПредопределенных = Новый Структура();
		ОписаниеТабличныхЧастей = Новый Структура();
		ДополнительныеСвойства = Новый Структура();
		
		ОбъектМетаданных = Коллекция.Получить(НомерОбъекта);		
		ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
				
		Если ИмяМетаданных(ПолноеИмя) = "Перечисление" Тогда
			
			Для НомерРеквизита = 0 По ОбъектМетаданных.ЗначенияПеречисления.Количество() - 1 Цикл
				Реквизит = ОбъектМетаданных.ЗначенияПеречисления.Получить(НомерРеквизита);
				ОписаниеРеквизитов.Вставить(Реквизит.Имя, Новый Структура("name", Реквизит.Синоним));
			КонецЦикла;
			
		Иначе
			             
			Для НомерРеквизита = 0 По ОбъектМетаданных.Реквизиты.Количество() - 1 Цикл								
				Реквизит = ОбъектМетаданных.Реквизиты.Получить(НомерРеквизита);				
				ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, Реквизит, Истина);
			КонецЦикла;
			
			Если ОбъектМетаданныхИмеетСтандартныеРеквизиты(ПолноеИмя) Тогда
					
				Для Каждого Реквизит ИЗ ОбъектМетаданных.СтандартныеРеквизиты Цикл
					ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, Реквизит, Истина);
				КонецЦикла;
				
			КонецЕсли;
			
			Если ОбъектМетаданныхИмеетПредопределенные(ПолноеИмя) Тогда
					
				Предопределенные = ОбъектМетаданных.ПолучитьИменаПредопределенных();
				
				Для Каждого Имя ИЗ Предопределенные Цикл
					ОписаниеПредопределенных.Вставить(Имя, "");
				КонецЦикла;
				
			КонецЕсли;
										
			Если ОбъектМетаданныхИмеетИзмерения(ПолноеИмя) Тогда
								
				Для НомерРеквизита = 0 По ОбъектМетаданных.Измерения.Количество() - 1 Цикл
					Реквизит = ОбъектМетаданных.Измерения.Получить(НомерРеквизита);
					ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, Реквизит, Истина);
				КонецЦикла;
				
				Для НомерРеквизита = 0 По ОбъектМетаданных.Ресурсы.Количество() - 1 Цикл
					Реквизит = ОбъектМетаданных.Ресурсы.Получить(НомерРеквизита);					
					ДобавитьОписаниеРеквизита(ОписаниеРесурсов, Реквизит, Ложь);
				КонецЦикла;
				
				ЗаполнитьТипРегистра(ДополнительныеСвойства, ОбъектМетаданных, ПолноеИмя);				
				
			КонецЕсли;
			
			Если ОбъектМетаданныхИмеетТЧ(ПолноеИмя) Тогда
				
				Для НомерРеквизита = 0 По ОбъектМетаданных.ТабличныеЧасти.Количество() - 1 Цикл					
					
					ТабличнаяЧасть = ОбъектМетаданных.ТабличныеЧасти.Получить(НомерРеквизита);
					ОписаниеРеквизитов.Вставить(ТабличнаяЧасть.Имя, Новый Структура("name", "ТЧ: " + ТабличнаяЧасть.Синоним));
					
					ОписаниеТабличнойЧасти = Новый Структура();
					
					Для Каждого РеквизитТЧ ИЗ ТабличнаяЧасть.СтандартныеРеквизиты Цикл
						ОписаниеТабличнойЧасти.Вставить(РеквизитТЧ.Имя, РеквизитТЧ.Синоним);
					КонецЦикла;
										
					Для НомерРеквизитаТЧ = 0 По ТабличнаяЧасть.Реквизиты.Количество() - 1 Цикл
						РеквизитТЧ = ТабличнаяЧасть.Реквизиты.Получить(НомерРеквизитаТЧ);
						ДобавитьОписаниеРеквизита(ОписаниеТабличнойЧасти, РеквизитТЧ, Истина);
					КонецЦикла;
					
					Если 0 < ОписаниеТабличнойЧасти.Количество() Тогда
						ОписаниеТабличныхЧастей.Вставить(ТабличнаяЧасть.Имя, ОписаниеТабличнойЧасти);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		СтруктураОбъекта = Новый Структура();
		СтруктураОбъекта.Вставить("properties", ОписаниеРеквизитов);
		
		Для Каждого Обход Из ДополнительныеСвойства Цикл
			СтруктураОбъекта.Вставить(Обход.Ключ, Обход.Значение);
		КонецЦикла;
		
		Если 0 < ОписаниеРесурсов.Количество() Тогда
			СтруктураОбъекта.Вставить("resources", ОписаниеРесурсов);
		КонецЕсли;
		
		Если 0 < ОписаниеПредопределенных.Количество() Тогда
			СтруктураОбъекта.Вставить("predefined", ОписаниеПредопределенных); 
		КонецЕсли;
		
		Если 0 < ОписаниеТабличныхЧастей.Количество() Тогда
			СтруктураОбъекта.Вставить("tabulars", ОписаниеТабличныхЧастей); 
		КонецЕсли;
		
		ОписаниеКоллекции.Вставить(ОбъектМетаданных.Имя, СтруктураОбъекта);
		
	КонецЦикла;
	
	Возврат ОписаниеКоллекции;
	
КонецФункции

Функция ПолучитьСвязьСОбъектомМетаданных(Реквизит)
	
	Связь = "";
	
	Типы = Реквизит.Тип.Типы();
	
	Индекс = 0;
	
	Пока Индекс < Типы.Количество() И НЕ ЗначениеЗаполнено(Связь) Цикл
	
		Тип = Типы[Индекс];
		
		СвязьТипа = Связи[Тип];
		
		Если СвязьТипа = Неопределено Тогда
			
			ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
			
			Если ОбъектМетаданных <> Неопределено Тогда
				
				// Сейчас связи описыватьются только для справочников и документов.
				// При желании, пожертвовав скоростью получения описания всех метаданных
				// сюда же можно добавить следующие элементы:
				// Метаданные.БизнесПроцессы businessProcesses
				// Метаданные.Задачи tasks
				// Метаданные.ПланыВидовРасчета chartsOfCalculationTypes
				// Метаданные.ПланыВидовХарактеристик chartsOfCharacteristicTypes
				// Метаданные.ПланыОбмена exchangePlans
				// Метаданные.ПланыСчетов сhartsOfAccounts								
				Если Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
				    Связь = "catalogs." + ОбъектМетаданных.Имя;
				ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
				    Связь = "documents." + ОбъектМетаданных.Имя;
				КонецЕсли;
				
			КонецЕсли;
			
			Связи[Тип] = Связь;
			
		Иначе
			
			Связь = СвязьТипа;
			
		КонецЕсли;
				
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Возврат Связь;
	
КонецФункции

Функция ЗаполнитьКоллекциюМетаданных(Параметры = Неопределено, АдресРезультата = Неопределено) Экспорт
		
	КоллекцияМетаданных = Новый Структура();
	КоллекцияМетаданных.Вставить("catalogs"						, ОписатьКоллекциюОбъектовМетаданых(Метаданные.Справочники));
	КоллекцияМетаданных.Вставить("documents"					, ОписатьКоллекциюОбъектовМетаданых(Метаданные.Документы));
	КоллекцияМетаданных.Вставить("infoRegs"						, ОписатьКоллекциюОбъектовМетаданых(Метаданные.РегистрыСведений));
	КоллекцияМетаданных.Вставить("accumRegs"					, ОписатьКоллекциюОбъектовМетаданых(Метаданные.РегистрыНакопления));
	КоллекцияМетаданных.Вставить("accountRegs"					, ОписатьКоллекциюОбъектовМетаданых(Метаданные.РегистрыБухгалтерии));
	КоллекцияМетаданных.Вставить("dataProc"						, ОписатьКоллекциюОбъектовМетаданых(Метаданные.Обработки));
	КоллекцияМетаданных.Вставить("reports"						, ОписатьКоллекциюОбъектовМетаданых(Метаданные.Отчеты));
	КоллекцияМетаданных.Вставить("enums"						, ОписатьКоллекциюОбъектовМетаданых(Метаданные.Перечисления));
	КоллекцияМетаданных.Вставить("commonModules"				, ОписатьОбщиеМодули(Метаданные.ОбщиеМодули));
	КоллекцияМетаданных.Вставить("сhartsOfAccounts"				, ОписатьКоллекциюОбъектовМетаданых(Метаданные.ПланыСчетов));
	КоллекцияМетаданных.Вставить("businessProcesses"			, ОписатьКоллекциюОбъектовМетаданых(Метаданные.БизнесПроцессы));
	КоллекцияМетаданных.Вставить("tasks"						, ОписатьКоллекциюОбъектовМетаданых(Метаданные.Задачи));
	КоллекцияМетаданных.Вставить("exchangePlans"				, ОписатьКоллекциюОбъектовМетаданых(Метаданные.ПланыОбмена));
	КоллекцияМетаданных.Вставить("chartsOfCharacteristicTypes"	, ОписатьКоллекциюОбъектовМетаданых(Метаданные.ПланыВидовХарактеристик));	
	КоллекцияМетаданных.Вставить("chartsOfCalculationTypes"		, ОписатьКоллекциюОбъектовМетаданых(Метаданные.ПланыВидовРасчета));	
		
	Файл = Новый ЗаписьJSON();
	Файл.УстановитьСтроку();
	Попытка
		ЗаписатьJSON(Файл, КоллекцияМетаданных);
	Исключение
		ВызватьИсключение("Не удалось сохранить коллекцию метаданных:" + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	
	ЗначениеКоллекции = Файл.Закрыть();
		
	Адрес = ?(АдресРезультата <> Неопределено, АдресРезультата, Новый УникальныйИдентификатор());
	
	АдресРезультата = ПоместитьВоВременноеХранилище(ЗначениеКоллекции, Адрес);	
		
	Возврат АдресРезультата;
	
КонецФункции

// Процедура добавляет команду обработки в таблицу
//
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

// Функция предоставляет сведения об обработке для
// подключения к кофигурации
//
Функция СведенияОВнешнейОбработке() Экспорт
		
	РегистрационныеДанные = Новый Структура;
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	ДобавитьКоманду(Команды, "Консоль кода", "ИнструментКонсольКода", "ОткрытиеФормы");	
	
	//Инициализация сведений об обработке 
	РегистрационныеДанные.Вставить("Вид"			, "ДополнительнаяОбработка");
	РегистрационныеДанные.Вставить("Назначение"		, Неопределено);
	РегистрационныеДанные.Вставить("Наименование"	, "Консоль кода");
	РегистрационныеДанные.Вставить("Версия"			, "20201230");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Информация"		, "Консоль кода для управляемых форм");
	РегистрационныеДанные.Вставить("Команды"		, Команды);
	
	Возврат РегистрационныеДанные;
	
КонецФункции

Связи = Новый Соответствие();
ОпределятьСвязи = Истина; // Если поменять на Ложь, то получение структуры метаданных будет происходить примерно в 2 раза быстрее,
// но не будет работать подсказка через . для реквизитов ссылочного типа