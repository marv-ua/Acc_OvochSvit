﻿
// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
	
	Организация = Параметры.Организация;
	
	ДатаНачалаИспользованияЗвит1С = Организация.ДатаНачалаИспользованияЗвит1С;
	
	ПолучениеДанныхДляЗвит1С = Параметры.ПолучениеДанныхДляЗвит1С;
	
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	
	
	ОтчетЗаДваПериода  			   = Параметры.ОтчетЗаДваПериода;	
	ВидФинОтчетности  			   = Параметры.ВидФинОтчетности;	
	ОблагаемаяПрибыльПрошлогоГода  = Параметры.ОблагаемаяПрибыльПрошлогоГода;	
	РИАмортизацияБУБиблФондовМНМА  = Параметры.РИАмортизацияБУБиблФондовМНМА;	
	ЛимитСуммыДоходаНалоговыеРазницы  = Параметры.ЛимитСуммыДоходаНалоговыеРазницы;	
	ИДКонфигурации = РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации();
	
	Если РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации()  =  "ЕРП" Тогда
		ОписаниеТипа = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов");
		
		Элементы.ПередачаНеприбыльным_СтатьиПодборНеоперационные.Видимость 				 = Ложь;
		Элементы.СписаниеНеБезнадежнойЗадолженности_СтатьиПодборНеоперационные.Видимость = Ложь;
		Элементы.Штрафы_СтатьиПодборНеоперационныеШтрафы.Видимость 						 = Ложь;
		
	Иначе
		ОписаниеТипа = Новый ОписаниеТипов("СправочникСсылка.СтатьиЗатрат, СправочникСсылка.СтатьиНеоперационныхРасходов");
	КонецЕсли;
	Элементы.ДляФредоТипПериода.Видимость = ПолучениеДанныхДляЗвит1С;
	
	Элементы.СписаниеНеБезнадежнойЗадолженности_Статьи.ПодчиненныеЭлементы.СписаниеНеБезнадежнойЗадолженности_СтатьиСтатьяЗатрат.ОграничениеТипа = ОписаниеТипа;
	Элементы.СписаниеНеБезнадежнойЗадолженности_Статьи.ПодчиненныеЭлементы.СписаниеНеБезнадежнойЗадолженности_СтатьиСтатьяЗатрат.ВыбиратьТип = Ложь;
	Элементы.ПередачаНеприбыльным_СтатьиЗатрат.ПодчиненныеЭлементы.ПередачаНеприбыльным_СтатьиЗатратСтатьяЗатрат.ОграничениеТипа = ОписаниеТипа;
	Элементы.ПередачаНеприбыльным_СтатьиЗатрат.ПодчиненныеЭлементы.ПередачаНеприбыльным_СтатьиЗатратСтатьяЗатрат.ВыбиратьТип = Ложь;
	Элементы.Штрафы_Статьи.ПодчиненныеЭлементы.Штрафы_СтатьиСтатьяЗатрат.ОграничениеТипа = ОписаниеТипа;
	Элементы.Штрафы_Статьи.ПодчиненныеЭлементы.Штрафы_СтатьиСтатьяЗатрат.ВыбиратьТип = Ложь;
	
	Если НЕ Параметры.СписаниеНеБезнадежнойЗадолженности_Статьи = Неопределено Тогда
		Для каждого Эл Из Параметры.СписаниеНеБезнадежнойЗадолженности_Статьи Цикл
			Строка = СписаниеНеБезнадежнойЗадолженности_Статьи.Добавить();
			Строка.СтатьяЗатрат = Эл; 
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ Параметры.ПередачаНеприбыльным_СтатьиЗатрат = Неопределено Тогда
		Для каждого Эл Из Параметры.ПередачаНеприбыльным_СтатьиЗатрат Цикл
			Строка = ПередачаНеприбыльным_СтатьиЗатрат.Добавить();
			Строка.СтатьяЗатрат = Эл; 
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ Параметры.Штрафы_Статьи = Неопределено Тогда
		Для каждого Эл Из Параметры.Штрафы_Статьи Цикл
			Строка = Штрафы_Статьи.Добавить();
			Строка.СтатьяЗатрат = Эл; 
		КонецЦикла;
	КонецЕсли;	
	
	Если НЕ Параметры.Контрагенты_Неприбыльные = Неопределено Тогда
		Для каждого Эл Из Параметры.Контрагенты_Неприбыльные Цикл
			Строка = Контрагенты_Неприбыльные.Добавить();
			Строка.Контрагент = Эл; 
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ Параметры.Контрагенты_Оффшоры = Неопределено Тогда
		Для каждого Эл Из Параметры.Контрагенты_Оффшоры Цикл
			Строка = Контрагенты_Оффшоры.Добавить();
			Строка.Контрагент = Эл; 
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ Параметры.Контрагенты_ОффшорыОргформа = Неопределено Тогда
		Для каждого Эл Из Параметры.Контрагенты_ОффшорыОргформа Цикл
			Строка = Контрагенты_ОффшорыОргформа.Добавить();
			Строка.Контрагент = Эл; 
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Сохранить()
//
&НаКлиенте
Процедура Сохранить(Команда)
	
	мСпрашиватьОСохранении = Ложь;
	Закрыть();
	
КонецПроцедуры // Сохранить()

// ПередЗакрытием()
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы <> Неопределено Тогда 
		
		Если ЗавершениеРаботы И Модифицированность Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	Если мПрограммноеЗакрытие = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если мСпрашиватьОСохранении <> Ложь И Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?';uk='Настройки були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Возврат;
		
	ИначеЕсли мСпрашиватьОСохранении <> Ложь И НЕ Модифицированность Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриЗакрытии()
	
	ВладелецФормы.СтруктураРеквизитовФормы.ОтчетЗаДваПериода 			 = ОтчетЗаДваПериода;
	ВладелецФормы.СтруктураРеквизитовФормы.ВидФинОтчетности 			 = ВидФинОтчетности;
	ВладелецФормы.СтруктураРеквизитовФормы.ОблагаемаяПрибыльПрошлогоГода = ОблагаемаяПрибыльПрошлогоГода;
	ВладелецФормы.СтруктураРеквизитовФормы.РИАмортизацияБУБиблФондовМНМА = РИАмортизацияБУБиблФондовМНМА;
	ВладелецФормы.СтруктураРеквизитовФормы.ЛимитСуммыДоходаНалоговыеРазницы = ЛимитСуммыДоходаНалоговыеРазницы;
	Если  ПолучениеДанныхДляЗвит1С Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.ДляФредоТипПериода = ДляФредоТипПериода;
	КонецЕсли;	
	
	Массив = Новый Массив;
	Для каждого Элемент Из СписаниеНеБезнадежнойЗадолженности_Статьи Цикл
		Массив.Добавить(Элемент.СтатьяЗатрат);
	КонецЦикла;
	ВладелецФормы.СтруктураРеквизитовФормы.СписаниеНеБезнадежнойЗадолженности_Статьи 	= Массив;	
	
	Массив = Новый Массив;
	Для каждого Элемент Из ПередачаНеприбыльным_СтатьиЗатрат Цикл
		Массив.Добавить(Элемент.СтатьяЗатрат);
	КонецЦикла;
	ВладелецФормы.СтруктураРеквизитовФормы.ПередачаНеприбыльным_СтатьиЗатрат 	= Массив;	
	
	Массив = Новый Массив;
	Для каждого Элемент Из Штрафы_Статьи Цикл
		Массив.Добавить(Элемент.СтатьяЗатрат);
	КонецЦикла;
	ВладелецФормы.СтруктураРеквизитовФормы.Штрафы_Статьи 	= Массив;	
	
	
	Массив = Новый Массив;
	Для каждого Элемент Из Контрагенты_Неприбыльные Цикл
		Массив.Добавить(Элемент.Контрагент);
	КонецЦикла;
	ВладелецФормы.СтруктураРеквизитовФормы.Контрагенты_Неприбыльные 	= Массив;	
	
	Массив = Новый Массив;
	Для каждого Элемент Из Контрагенты_Оффшоры Цикл
		Массив.Добавить(Элемент.Контрагент);
	КонецЦикла;
	ВладелецФормы.СтруктураРеквизитовФормы.Контрагенты_Оффшоры 	= Массив;
	
	Массив = Новый Массив;
	Для каждого Элемент Из Контрагенты_ОффшорыОргформа Цикл
		Массив.Добавить(Элемент.Контрагент);
	КонецЦикла;
	ВладелецФормы.СтруктураРеквизитовФормы.Контрагенты_ОффшорыОргформа 	= Массив;
	
	мПрограммноеЗакрытие = Истина;
	Отказ = Истина;
	
	ПараметрыВозврата = Новый Структура();
	
	Закрыть(ПараметрыВозврата);
	
КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры)Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		мПрограммноеЗакрытие = Истина;
		Закрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПрибыльПрошлогоГода(Команда)
	
	ОблагаемаяПрибыльПрошлогоГода = 0;
	
	ДатаПрошлогоГода = КонецГода(ДобавитьМесяц(мДатаКонцаПериодаОтчета, -12));
	
	ПолучениеДанныхИз1С = Истина;
	
	Если ПолучениеДанныхДляЗвит1С = Истина Тогда
		Если ЗначениеЗаполнено(ДатаНачалаИспользованияЗвит1С) Тогда
			ПолучениеДанныхИз1С = ДатаПрошлогоГода  < ДатаНачалаИспользованияЗвит1С;
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучениеДанныхИз1С Тогда
	
		ЗаполнитьПрибыльПрошлогоГодаНаСервере();
		
	Иначе
		
		Если НЕ РегламентированнаяОтчетностьКлиент.ПодключитьМенеджерЗвит1С(Истина) Тогда
			Возврат;
		КонецЕсли;
		
		Если Не глМенеджерЗвит1С.ЗапуститьЗвит1С(Ложь, Организация) Тогда
			ПоказатьПредупреждение(,НСтр("ru='Не удалось запустить ""FREDO Звіт""';uk='Не вдалося запустити ""FREDO Звіт""'"));
			Возврат;
		КонецЕсли;
		
		глКомпонентаЗвит1С.Bring1CToFront();
		
		// данные прошлого года
		ИмяСхемы1 = "J01001";	
		
		ГодПериода   = Год(НачалоГода(мДатаНачалаПериодаОтчета)-1);
		
		Если ГодПериода = 2021 Тогда 
			ИмяСхемы1 = ИмяСхемы1 + "20";
			//может быть с/х
			ИмяСхемы2 = "J0100520"; 
		Иначе  //c 2022
			ИмяСхемы1 = ИмяСхемы1 + "21";
			//может быть с/х
			ИмяСхемы2 = "J0100521"; 
		КонецЕсли;
		
		ТипПериода   = 30;          
		НомерПериода = 1;
		ПредставлениеПериодаЗвит1С = ПредставлениеПериода(НачалоГода(НачалоГода(мДатаНачалаПериодаОтчета)-1), НачалоГода(мДатаНачалаПериодаОтчета)-1, "Л=uk_UA");
			
		Попытка
			
			Данные = глКомпонентаЗвит1С.GetReport(ИмяСхемы1, ТипПериода, НомерПериода, ГодПериода);
			Если Данные = Неопределено и ЗначениеЗаполнено(ИмяСхемы2) Тогда
				Данные = глКомпонентаЗвит1С.GetReport(ИмяСхемы2, ТипПериода, НомерПериода, ГодПериода);
			КонецЕсли;
			
			Если Данные = Неопределено Тогда
				
				// Выводим только связанные с заполняемым отчетом сообщения
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				    "В ""FREDO Звіт"" "
				    + НСтр("ru='сохраненная декларация о прибыли за %1 не обнаружена!';uk='збережену декларацію про прибуток за %1 не виявлено!'")
					+ Символы.ПС 
					+ НСтр("ru='Невозможно автоматическое заполнение параметра %2 !';uk='Неможливе автоматичне заповнення параметру %2 !'"),
					                                   ПредставлениеПериода( НачалоГода(НачалоГода(мДатаНачалаПериодаОтчета)-1), НачалоГода(мДатаНачалаПериодаОтчета)-1 , "Л = ""uk_UA""; ФП = Истина" ),
													   НСтр("ru='""Облагаемая прибыль прошлого года""';uk='""Оподатковуваний прибуток минулого року""'"));
													   
				ПоказатьПредупреждение(,ТекстСообщения);
				
			Иначе
				
				// по декларации прошлого года
				ОблагаемаяПрибыльПрошлогоГода = ПолучитьЗначениеПоказателяЗвит1С(Данные, "A04"); // рядок 4 Декларації
				
			КонецЕсли;
			
		Исключение
			
			ТекстСообщения = 
			      НСтр("ru='Ошибка получения данных из ""FREDO Звіт"" ';uk='Помилка отримання даних з ""FREDO Звіт"" '")
				+ Символы.ПС 
				+ НСтр("ru='Невозможно автоматическое заполнение параметра ""Облагаемая прибыль прошлого года""!';uk='Неможливе автоматичне заповнення параметра ""Оподатковуваний прибуток минулого року""!'");
												   
			ПоказатьПредупреждение(,ТекстСообщения);
			
		КонецПопытки;
		 		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрибыльПрошлогоГодаНаСервере()
	
	ДекларацияПоПрибылиЗаПрошлыйГод = Новый Запрос;
	
	ДекларацияПоПрибылиЗаПрошлыйГод.Текст = "
	|ВЫБРАТЬ
	| РегламентированныйОтчет.ДанныеОтчета
	|ИЗ
	|	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	|
	|ГДЕ
	|	НЕ РегламентированныйОтчет.ПометкаУдаления И
	|	РегламентированныйОтчет.Организация = &Организация И
	|	РегламентированныйОтчет.ИсточникОтчета = &ИсточникОтчета И
	|	РегламентированныйОтчет.ДатаОкончания = &ДатаОкончания";
	
	
	
	ДекларацияПоПрибылиЗаПрошлыйГод.УстановитьПараметр ("ДатаОкончания", НачалоГода(мДатаНачалаПериодаОтчета) - 1);
	ДекларацияПоПрибылиЗаПрошлыйГод.УстановитьПараметр ("Организация",	 Организация);
	ДекларацияПоПрибылиЗаПрошлыйГод.УстановитьПараметр ("ИсточникОтчета","РегламентированныйОтчетДекларацияОПрибыли");
	
	РезультатЗапроса   = ДекларацияПоПрибылиЗаПрошлыйГод.Выполнить();
	
	ТаблицаРезультатов = РезультатЗапроса.Выгрузить();
	
	Если  ТаблицаРезультатов.Количество() = 0 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Сохраненная декларация о прибыли за %1 не обнаружена!';uk='Збережену декларацію про прибуток за %1 не виявлено!'")
			+ Символы.ПС 
			+ НСтр("ru='Невозможно автоматическое заполнение параметра %2 !';uk='Неможливе автоматичне заповнення параметру %2 !'"),
			                                   ПредставлениеПериода( НачалоГода(НачалоГода(мДатаНачалаПериодаОтчета)-1), НачалоГода(мДатаНачалаПериодаОтчета)-1 , "Л = ""uk_UA""; ФП = Истина" ),
											   НСтр("ru='""Облагаемая прибыль прошлого года""';uk='""Оподатковуваний прибуток минулого року""'"));
											   
		Сообщить(ТекстСообщения);
		
	ИначеЕсли  ТаблицаРезультатов.Количество() > 1 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='За %1 обнаружено более одной сохраненной декларации о прибыли!';uk='За %1 виявлено більше однієї збереженої декларації про прибуток!'")
			+ Символы.ПС 
			+ НСтр("ru='Невозможно автоматическое заполнение параметра %2 !';uk='Неможливе автоматичне заповнення параметру %2 !'"),
			                                   ПредставлениеПериода( НачалоГода(НачалоГода(мДатаНачалаПериодаОтчета)-1), НачалоГода(мДатаНачалаПериодаОтчета)-1 , "Л = ""uk_UA""; ФП = Истина" ),
											   НСтр("ru='""Облагаемая прибыль прошлого года""';uk='""Оподатковуваний прибуток минулого року""'"));
											   
		Сообщить(ТекстСообщения);
		
	Иначе	
		
		ПоказателиОтчета = Неопределено;
		ПоказателиПоля   = Неопределено;
		
		ДанныеОтчета = ТаблицаРезультатов[0].ДанныеОтчета.Получить();
		ДанныеОтчета.Свойство("ПоказателиОтчета", ПоказателиОтчета);
		ПоказателиОтчета.Свойство("ПолеТабличногоДокументаДекларация", ПоказателиПоля);
		
		ОблагаемаяПрибыльПрошлогоГода = ПоказателиПоля.R004G3; // рядок 4 Декларації
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначениеПоказателяЗвит1С(ОтчетЗвит1С, ИмяПоляЗвит1С)
	
	// Функция предназначена только для получения числовых показателей.
	
	// У каждорго поля в FREDO Звіт есть состояние "Неопределено". Что 
	// говорит о том что значение не устанавливалось пользователем
	Результат = ОтчетЗвит1С.GetValue("MAIN", ИмяПоляЗвит1С);
	Если Результат = Неопределено Тогда
		Результат = 0
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


&НаКлиенте
Процедура ПодборКонтрагнетыНеприбыльные(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Форма = ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"Контрагенты_Неприбыльные");
	Форма.КлючУникальности = "Контрагенты_Неприбыльные";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборКонтрагнетыОффшоры(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Форма = ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"Контрагенты_Оффшоры");
	Форма.КлючУникальности = "Контрагенты_Оффшоры";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборКонтрагнетыОффшорыОргформа(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Форма = ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"Контрагенты_ОффшорыОргформа");
	Форма.КлючУникальности = "Контрагенты_ОффшорыОргформа";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборНеоперационныеПередачаНеприбыльным(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Форма = ОткрытьФорму("Справочник.СтатьиНеоперационныхРасходов.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"ПередачаНеприбыльным_СтатьиЗатрат");
	Форма.КлючУникальности = "ПередачаНеприбыльным_СтатьиЗатрат";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборНеоперационныеСписание(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Форма = ОткрытьФорму("Справочник.СтатьиНеоперационныхРасходов.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"СписаниеНеБезнадежнойЗадолженности_Статьи");
	Форма.КлючУникальности = "СписаниеНеБезнадежнойЗадолженности_Статьи";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборОперационныеПередачаНеприбыльным(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Если ИДКонфигурации  =  "ЕРП" Тогда
		Форма = ОткрытьФорму("ПланВидовХарактеристик.СтатьиРасходов.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"ПередачаНеприбыльным_СтатьиЗатрат");
	Иначе
		Форма = ОткрытьФорму("Справочник.СтатьиЗатрат.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"ПередачаНеприбыльным_СтатьиЗатрат");
	КонецЕсли;
	Форма.КлючУникальности = "ПередачаНеприбыльным_СтатьиЗатрат";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборОперационныеСписание(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Если ИДКонфигурации  =  "ЕРП" Тогда
		Форма = ОткрытьФорму("ПланВидовХарактеристик.СтатьиРасходов.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"СписаниеНеБезнадежнойЗадолженности_Статьи");
	Иначе
		Форма = ОткрытьФорму("Справочник.СтатьиЗатрат.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"СписаниеНеБезнадежнойЗадолженности_Статьи");
	КонецЕсли;
	Форма.КлючУникальности = "СписаниеНеБезнадежнойЗадолженности_Статьи";
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Таблица = ИсточникВыбора.КлючУникальности;
	Если Элементы.Найти(Таблица) = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ЭлементФормы = ЭтотОбъект[Таблица];
	Если    Таблица = "СписаниеНеБезнадежнойЗадолженности_Статьи"
		ИЛИ Таблица = "ПередачаНеприбыльным_СтатьиЗатрат"
		ИЛИ Таблица = "Штрафы_Статьи" Тогда
	    ИмяКолонки = "СтатьяЗатрат";
	Иначе	
		ИмяКолонки = "Контрагент";
	КонецЕсли;
	
	Для каждого ТекЗначение Из ВыбранноеЗначение Цикл

		Если ЭлементФормы.НайтиСтроки(Новый Структура(ИмяКолонки, ТекЗначение)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Строка = ЭлементФормы.Добавить();
		Строка[ИмяКолонки] = ТекЗначение;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборОперационныеШтрафы(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Если ИДКонфигурации  =  "ЕРП" Тогда
		Форма = ОткрытьФорму("ПланВидовХарактеристик.СтатьиРасходов.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"Штрафы_Статьи");
	Иначе
		Форма = ОткрытьФорму("Справочник.СтатьиЗатрат.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"Штрафы_Статьи");
	КонецЕсли;
	Форма.КлючУникальности = "Штрафы_Статьи";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборНеоперационныеШтрафы(Команда)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	Форма = ОткрытьФорму("Справочник.СтатьиНеоперационныхРасходов.ФормаВыбора", ПараметрыВыбора,ЭтаФорма,"Штрафы_Статьи");
	Форма.КлючУникальности = "Штрафы_Статьи";
	
КонецПроцедуры
