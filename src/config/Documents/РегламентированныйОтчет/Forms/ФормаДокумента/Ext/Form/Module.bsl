﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мСкопированаФорма = Неопределено;
	
	НеОтображатьПредупреждение = Параметры.НеОтображатьПредупреждение;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
		И ЗначениеЗаполнено(Объект.ВыбраннаяФорма) Тогда
		
		мСкопированаФорма = Объект.ВыбраннаяФорма;
		
	КонецЕсли;
	
	Если Не(РеквизитФормыВЗначение("Объект").ЭтоНовый()) ИЛИ (мСкопированаФорма <> Неопределено) Тогда
		
		ПравоДоступаКОтчету = РегламентированнаяОтчетностьВызовСервера.ПравоДоступаКРегламентированномуОтчету(
			Объект.ИсточникОтчета);
		
		Если ПравоДоступаКОтчету = Ложь Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Недостаточно прав!';uk='Недостатньо прав!'");
			Сообщение.Сообщить();
			
			Возврат;
			
		ИначеЕсли ПравоДоступаКОтчету = Неопределено Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не удалось открыть сохраненные данные! Отчет не найден!';uk='Не вдалося відкрити збережені дані! Звіт не знайдений!'");
			Сообщение.Сообщить();
			
			Возврат;
			
		КонецЕсли;
		
		// Возвращает типы ВнешнийОтчетОбъект.<Имя> и ОтчетМенеджер.<Имя>
		ВариантФормыОтчета = Неопределено;
		ОбъектОтчет = РегламентированнаяОтчетность.РеглОтчеты(Объект.ИсточникОтчета);
		
		Если ОбъектОтчет = Неопределено Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не удалось открыть сохраненные данные! Отчет не найден!';uk='Не вдалося відкрити збережені дані! Звіт не знайдений!'");
			Сообщение.Сообщить();
			
			Возврат;
			
		КонецЕсли;
		
		ОткрытьФормуОтчета = Истина;
		ВариантФормыОтчета = ?(Найти(ОбъектОтчет, "ОтчетМенеджер") > 0, "Отчет.", "ВнешнийОтчет.")
		
	ИначеЕсли РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
		
		ОткрытьФормуОтчета = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Истина;
	
	Если ОткрытьФормуОтчета Тогда
		
		СтандартнаяОбработка = Истина;
		
		ПараметрыФормы = Новый Структура;
		
		ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", НачалоДня(Объект.ДатаНачала));
		ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
		ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  КонецДня(Объект.ДатаОкончания));
		ПараметрыФормы.Вставить("мПериодичность",           Объект.Периодичность);
		ПараметрыФормы.Вставить("Организация",              Объект.Организация);
		ПараметрыФормы.Вставить("мВыбраннаяФорма",          Объект.ВыбраннаяФорма);
		ПараметрыФормы.Вставить("НеОтображатьПредупреждение", НеОтображатьПредупреждение);
		
			
		Если мСкопированаФорма = Неопределено Тогда
			
			ПараметрыФормы.Вставить("мСохраненныйДок", Объект.Ссылка);
			
			ВыбраннаяФорма = Объект.ВыбраннаяФорма;
			
			ЭтоВнешнийОтчет = (ВариантФормыОтчета = "ВнешнийОтчет.");
			
			Если НЕ РегламентированнаяОтчетностьВызовСервера.ФормаРегламентированногоОтчетаСуществует(ЭтоВнешнийОтчет, Объект.ИсточникОтчета, ВыбраннаяФорма) Тогда
				ТекстПредупреждения = НСтр("ru='Отчет не может быть открыт! Данная редакция формы отчета не поддерживается текущей версией конфигурации.';uk='Звіт не може бути відкритий! Дана редакція форми звіту не підтримується поточною версією конфігурації.'");
				ПоказатьПредупреждение(, ТекстПредупреждения, 5 );
				Возврат;
			Иначе
				Если  РегламентированнаяОтчетностьВызовСервера.ЭтоОбычнаяФормаРегламентированногоОтчета(ЭтоВнешнийОтчет, Объект.ИсточникОтчета, ВыбраннаяФорма) Тогда
					
					#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
						Если ЭтоВнешнийОтчет Тогда
							#Если ТолстыйКлиентУправляемоеПриложение Тогда
								ТекстПредупреждения = НСтр("ru='Вы пытаетесь открыть архивный регламентированный отчет, созданный в предыдущей редакции конфигурации ВНЕШНИМ (подключенным) отчетом.
|Данное действие можно осуществить запустив платформу в режиме ""Толстый клиент (обычное приложение)""! 
|Запустите платформу в указанном режиме и повторите попытку.';uk='Ви намагаєтеся відкрити архівний регламентований звіт, створений у попередній редакції конфігурації ЗОВНІШНІМ (підключеним) звітом.
|Дану дію можна виконати запустивши платформу в режимі ""Товстий клієнт (звичайний додаток)""! 
|Запустіть платформу в зазначеному режимі і повторіть спробу.'");
								ПоказатьПредупреждение(, ТекстПредупреждения, 5 );
								Возврат;
							#Иначе
								ВремОтчет = РегламентированнаяОтчетность.РеглОтчеты(Объект.ИсточникОтчета);
								ВыбФорма = ВремОтчет.ПолучитьФорму(ВыбраннаяФорма);	 
							#КонецЕсли
						Иначе	
							ВыбФорма = Отчеты[Объект.ИсточникОтчета].ПолучитьФорму(ВыбраннаяФорма);	 
						КонецЕсли;
						ВыбФорма.мСохраненныйДок 			= Объект.Ссылка;
						ВыбФорма.мДатаНачалаПериодаОтчета 	= Объект.ДатаНачала;
						ВыбФорма.мДатаКонцаПериодаОтчета  	= Объект.ДатаОкончания;
						ВыбФорма.Открыть();
					#Иначе
						ТекстПредупреждения = НСтр("ru='Вы пытаетесь открыть архивный регламентированный отчет, созданный в предыдущей редакции конфигурации.
|Данное действие можно осуществить запустив платформу в режиме ""Толстый клиент (управляемое приложение)""! 
|Запустите платформу в указанном режиме и повторите попытку.';uk='Ви намагаєтеся відкрити архівний регламентований звіт, створений у попередній редакції конфігурації.
|Дану дію можна виконати запустивши платформу в режимі ""Товстий клієнт (керований додаток)""! 
|Запустіть платформу в зазначеному режимі і повторіть спробу.'");
						ПоказатьПредупреждение(, ТекстПредупреждения, 5 );
						Возврат;
					#КонецЕсли
					
					Возврат;
				Иначе
					ФормаОтчета = ПолучитьФорму(ВариантФормыОтчета + Объект.ИсточникОтчета
						+ ".Форма." + ВыбраннаяФорма, ПараметрыФормы, , Объект.Ссылка);
					
					ФормаОтчета.СтруктураРеквизитовФормы.Организация = Объект.Организация;
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Если Владелецформы.Имя = "Отчеты" Тогда
				ПараметрыФормы.Вставить("мСохраненныйДок", Владелецформы.ТекущиеДанные.РегламентированныйОтчет);
			Иначе
				ПараметрыФормы.Вставить("мСохраненныйДок", Владелецформы.ТекущаяСтрока);
			КонецЕсли;
			
			ФормаОтчета = ПолучитьФорму(ВариантФормыОтчета + Объект.ИсточникОтчета
			+ ".Форма.ОсновнаяФорма", ПараметрыФормы, , Объект.Ссылка);
			
			ФормаОтчета.Организация = Объект.Организация;
			
		КонецЕсли;
			
		
		Если СтандартнаяОбработка Тогда
			
			ФормаОтчета.ЗакрыватьПриЗакрытииВладельца = Ложь;
			
			ФормаОтчета.Открыть();
			
		КонецЕсли;

		
	Иначе
		
		//ОткрытьФорму("Справочник.РегламентированныеОтчеты.Форма.ФормаСписка");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти