﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мДействияПередЗаписьюВыполнены Экспорт;
Перем мКолвоПроводокЗаписанныхВИБ Экспорт;
Перем мОчищатьДанныеНУДо2015 Экспорт;

Процедура ПроверитьПроводку(Проводка)

	СчетДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
	СчетКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
	
	// Проверим и почистим небалансовые реквизиты
	Если НЕ СчетДт.Количественный И Проводка.КоличествоДт <> 0 Тогда
	    Проводка.КоличествоДт = Неопределено;
	КонецЕсли; 

	Если НЕ СчетДт.Валютный И Проводка.ВалютаДт <> Неопределено Тогда
	    Проводка.ВалютаДт = Неопределено;
	КонецЕсли; 

	Если НЕ СчетДт.Валютный И Проводка.ВалютнаяСуммаДт <> 0 Тогда
	    Проводка.ВалютнаяСуммаДт = Неопределено;
	КонецЕсли; 

	Если НЕ СчетКт.Количественный И Проводка.КоличествоКт <> 0 Тогда
	    Проводка.КоличествоКт = Неопределено;
	КонецЕсли; 

	Если НЕ СчетКт.Валютный И Проводка.ВалютаКт <> Неопределено Тогда
	    Проводка.ВалютаКт = Неопределено;
	КонецЕсли; 

	Если НЕ СчетКт.Валютный И Проводка.ВалютнаяСуммаКт <> 0 Тогда
	    Проводка.ВалютнаяСуммаКт = Неопределено;
	КонецЕсли; 

	// Проверим сочетание баланса и забаланса
	Если СчетДт.Забалансовый И НЕ СчетКт.Забалансовый Тогда
		Проводка.СчетКт          = Неопределено;
		Проводка.ВалютаКт        = Неопределено;
		Проводка.КоличествоКт    = 0;
		Проводка.ВалютнаяСуммаКт = 0;
		Проводка.СубконтоКт.Очистить();
		Проводка.НалоговоеНазначениеКт = Неопределено;
		Проводка.СуммаНУКт = 0;
	КонецЕсли; 

	Если СчетКт.Забалансовый И НЕ СчетДт.Забалансовый Тогда
		Проводка.СчетДт          = Неопределено;
		Проводка.ВалютаДт        = Неопределено;
		Проводка.КоличествоДт    = 0;
		Проводка.ВалютнаяСуммаДт = 0;
		Проводка.СубконтоДт.Очистить();
		Проводка.НалоговоеНазначениеДт = Неопределено;
		Проводка.СуммаНУДт = 0;
	КонецЕсли; 

	Если НЕ СчетКт.НалоговыйУчет И Проводка.НалоговоеНазначениеКт <> Неопределено Тогда
	    Проводка.НалоговоеНазначениеКт = Неопределено;
	КонецЕсли; 

	Если НЕ СчетКт.НалоговыйУчет И Проводка.СуммаНУКт <> 0 Тогда
	    Проводка.СуммаНУКт = 0;
	КонецЕсли; 

	Если НЕ СчетДт.НалоговыйУчет И Проводка.НалоговоеНазначениеДт <> Неопределено Тогда
	    Проводка.НалоговоеНазначениеДт = Неопределено;
	КонецЕсли; 

	Если НЕ СчетДт.НалоговыйУчет И Проводка.СуммаНУДт <> 0 Тогда
	    Проводка.СуммаНУДт = 0;
	КонецЕсли; 
	
	Если (мОчищатьДанныеНУДо2015 = Истина) И (Проводка.Период >= '2015 01 01') Тогда
	
		Если ЗначениеЗаполнено(Проводка.НалоговоеНазначениеКт) 
			И (НЕ СчетКт.УчетПоНалоговымНазначениямНДС 
			ИЛИ НЕ НалоговыйУчетПовтИсп.ЭтоНалоговоеНазначениеНДС(Проводка.НалоговоеНазначениеКт)) Тогда
		    Проводка.НалоговоеНазначениеКт = Справочники.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка();
		КонецЕсли; 

		Если Проводка.СуммаНУКт <> 0 И НЕ СчетКт.УчетСуммНУ Тогда
		    Проводка.СуммаНУКт = 0;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Проводка.НалоговоеНазначениеДт) 
			И (НЕ СчетДт.УчетПоНалоговымНазначениямНДС 
			ИЛИ НЕ НалоговыйУчетПовтИсп.ЭтоНалоговоеНазначениеНДС(Проводка.НалоговоеНазначениеДт)) Тогда
		    Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка();
		КонецЕсли; 

		Если Проводка.СуммаНУДт <> 0 И НЕ СчетДт.УчетСуммНУ Тогда
		    Проводка.СуммаНУДт = 0;
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

 
Функция ПровестиПоЗатратам(Проводка, Индекс, СтруктураПараметров)
	
	Организация = Проводка.Организация;
	
	Если СтруктураПараметров.Свойство("СоответствиеИспользуемыеКлассыСчетовРасходов") = Истина Тогда
		СоответствиеИспользуемыеКлассыСчетовРасходов = СтруктураПараметров.СоответствиеИспользуемыеКлассыСчетовРасходов;
		ИспользуемыеКлассыСчетовРасходов = СоответствиеИспользуемыеКлассыСчетовРасходов[Организация];
		Если ИспользуемыеКлассыСчетовРасходов = Неопределено Тогда
			ИспользуемыеКлассыСчетовРасходов = УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(Организация, Проводка.Период);
			СоответствиеИспользуемыеКлассыСчетовРасходов.Вставить(Организация, ИспользуемыеКлассыСчетовРасходов);
		КонецЕсли;
	Иначе	
		СтруктураПараметров.Вставить("СоответствиеИспользуемыеКлассыСчетовРасходов", Новый Соответствие);
		СоответствиеИспользуемыеКлассыСчетовРасходов = СтруктураПараметров.СоответствиеИспользуемыеКлассыСчетовРасходов;
		ИспользуемыеКлассыСчетовРасходов = УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(Организация, Проводка.Период);
		СоответствиеИспользуемыеКлассыСчетовРасходов.Вставить(Организация, ИспользуемыеКлассыСчетовРасходов);
	КонецЕсли; 

	Если СтруктураПараметров.Свойство("СоответствиеНужноДелитьПроводку") = Ложь Тогда
		СтруктураПараметров.Вставить("СоответствиеНужноДелитьПроводку", Новый Соответствие);
	КонецЕсли;
	СоответствиеНужноДелитьПроводку = СтруктураПараметров.СоответствиеНужноДелитьПроводку;
	
	Если СтруктураПараметров.Свойство("ИспользоватьКлассыСчетовВКачествеГрупп") = Ложь Тогда
		СтруктураПараметров.Вставить("ИспользоватьКлассыСчетовВКачествеГрупп", БухгалтерскийУчетПереопределяемый.ПолучитьИспользоватьКлассыСчетовВКачествеГрупп());
	КонецЕсли;
	ИспользоватьКлассыСчетовВКачествеГрупп = СтруктураПараметров.ИспользоватьКлассыСчетовВКачествеГрупп;
	
	КлассыСчетов = Перечисления.КлассыСчетовРасходов;
	
	Если ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс9 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СчетДт         = Проводка.СчетДт;
	СчетДтСвойства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
	
	СчетКт         = Проводка.СчетКт;
	СчетКтСвойства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
	
	Ключ = Строка(СчетДт) + "|" + Строка(СчетКт) + "|" + Строка(ИспользуемыеКлассыСчетовРасходов);
	//Проверм, не определяли ли мы уже для этого сочетания параметров
	СтруктураЗначение = СоответствиеНужноДелитьПроводку[Ключ];
	Если СтруктураЗначение = Неопределено Тогда
	
		СчетЗатратыБудущихПериодов 	= ПланыСчетов.Хозрасчетный.ЗатратыБудущихПериодов;
		СчетПолуфабрикаты 			= ПланыСчетов.Хозрасчетный.Полуфабрикаты;
		СчетГотоваяПродукция 		= ПланыСчетов.Хозрасчетный.ГотоваяПродукция;
		СчетПроизводство 			= ПланыСчетов.Хозрасчетный.Производство;
		СчетБракВПроизводстве 		= ПланыСчетов.Хозрасчетный.БракВПроизводстве;
		СчетСебестоимостьРеализации = ПланыСчетов.Хозрасчетный.СебестоимостьРеализации;
		СчетСебестоимостьРеализованныхПроизводственныхЗапасов = ПланыСчетов.Хозрасчетный.СебестоимостьРеализованныхПроизводственныхЗапасов;
		
		Если ИспользоватьКлассыСчетовВКачествеГрупп Тогда
			СчетЗатратыПоЭлементам 		= ПланыСчетов.Хозрасчетный.ЗатратыПоЭлементам;
			СчетЗатратыДеятельности 	= ПланыСчетов.Хозрасчетный.ЗатратыДеятельности;
			
		Иначе
			СчетЗатратыПоЭлементам	= Новый Массив;
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.МатериальныеЗатраты);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ЗатратыНаОплатуТруда);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ОтчисленияНаСоциальныеМероприятия);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.Амортизация);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам);
			
			СчетЗатратыДеятельности	= Новый Массив;
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.СебестоимостьРеализации);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеЗатраты);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ПотериОтУчастияВКапитале);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыДеятельности);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.НалогНаПрибыль);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ЧрезвычайныеЗатраты);
		
		КонецЕсли;
		
		
		СчетДругиеЗатратыПоЭлементам = ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам;
		
		Если    // Счет дебета не указан
			    СчетДт.Пустая()
				// Счет кредита не указан
			ИЛИ СчетКт.Пустая()
			    // Списание на затраты будущих периодов
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетЗатратыБудущихПериодов)
				// Себестоимость реализации 
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетСебестоимостьРеализации)
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетСебестоимостьРеализованныхПроизводственныхЗапасов)
				// Списание полуфабриката на затраты 
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетПолуфабрикаты)
			    // Списание продукции на затраты
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетГотоваяПродукция)
			    // Списание затрат из производства в производство или на брак (перераспределение затрат)
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетПроизводство)
			    // Списание затрат на брак в производство или на брак (перераспределение затрат)
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетБракВПроизводстве) 
			    // Списание со счета 8 класса
			ИЛИ БухгалтерскийУчетПереопределяемый.СчетВИерархииВМассиве(СчетКт, СчетЗатратыПоЭлементам)
			    // Списание со счета 9 класса
			ИЛИ БухгалтерскийУчетПереопределяемый.СчетВИерархииВМассиве(СчетКт, СчетЗатратыДеятельности)
			    // проводка только по налоговому учету
			ИЛИ ( БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, ПланыСчетов.Хозрасчетный.Вспомогательный)
			     И Проводка.Сумма = 0) Тогда
			
			ИзменятьПроводку = Ложь;
			ДелитьПроводку   = Ложь;
			
		Иначе
			
			ИзменятьПроводку = Ложь;
			ДелитьПроводку   = Ложь;
			
			Если БухгалтерскийУчетПереопределяемый.СчетВИерархииВМассиве(СчетДт, СчетЗатратыДеятельности)
				И (ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9
				  ИЛИ  ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8)  Тогда
				// Списание на счета 9 класса
				ИзменятьПроводку = Истина;
				ДелитьПроводку   = (ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9);
			КонецЕсли;
			
			Если (БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетПроизводство) ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетБракВПроизводстве))
				И (ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9 ИЛИ  ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8)  Тогда
				// Списание на счета 23 или 24 и используется 8 класс или 8 и 9 классы одновременно
				ИзменятьПроводку = Истина;
				ДелитьПроводку   = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		//Для того чтобы во второй раз не проверять, запишем в соответсвие результат проверки
		СтруктураЗначение = Новый Структура("ИзменятьПроводку,ДелитьПроводку",ИзменятьПроводку,ДелитьПроводку);
	    СоответствиеНужноДелитьПроводку.Вставить(Ключ, СтруктураЗначение);
		
	КонецЕсли;
	
	ИзменятьПроводку = СтруктураЗначение.ИзменятьПроводку;
	ДелитьПроводку   = СтруктураЗначение.ДелитьПроводку;
	
	Если НЕ ИзменятьПроводку Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТипСтатьиЗатрат = Тип("СправочникСсылка.СтатьиЗатрат");
	ЕстьСчет8Класса = Ложь;
	
	Для К = 1 По СчетДтСвойства.КоличествоСубконто Цикл
		

		Если СчетДтСвойства["ВидСубконто"+К+"ТипЗначения"].СодержитТип(ТипСтатьиЗатрат) Тогда
			
			ЗначениеСубконто = Проводка.СубконтоДт[СчетДтСвойства["ВидСубконто"+К]];
			
			Если ЗначениеЗаполнено(ЗначениеСубконто) Тогда
				Счет8Класса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеСубконто, "Счет8Класса");
			Иначе
				Счет8Класса = Неопределено;
			КонецЕсли; 
			СчетДругиеЗатратыПоЭлементам = ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам;
			
			Если    НЕ ЗначениеЗаполнено(Счет8Класса)
				ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетДругиеЗатратыПоЭлементам)
				    И ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9 Тогда
				// Счет неопределен или это 85 счет и используются 8 и 9 классы одновременно
				ЕстьСчет8Класса = Ложь;
			Иначе
				ЕстьСчет8Класса = Истина;
				Счет8КлассаСвойства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет8Класса);
			КонецЕсли;
			
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
		
	Если НЕ ЕстьСчет8Класса Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ДелитьПроводку Тогда
		// новая проводка
		НоваяПроводка = ЭтотОбъект.Вставить(Индекс);
		
		ЗаполнитьЗначенияСвойств(НоваяПроводка, Проводка);
		Для К = 1 По СчетКтСвойства.КоличествоСубконто Цикл
			НоваяПроводка.СубконтоКт[СчетКтСвойства["ВидСубконто"+К]] = Проводка.СубконтоКт[СчетКтСвойства["ВидСубконто"+К]];
		КонецЦикла;
		НоваяПроводка.СчетДт = Счет8Класса;
		Для К = 1 По Счет8КлассаСвойства.КоличествоСубконто Цикл
			НоваяПроводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]] = Проводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]];
		КонецЦикла;
		
		// исправим кредитовую сторону проводки
		Проводка.СчетКт             = Счет8Класса;
		Проводка.СубконтоКт.Очистить();
		Для К = 1 По Счет8КлассаСвойства.КоличествоСубконто Цикл
			Проводка.СубконтоКт[Счет8КлассаСвойства["ВидСубконто"+К]] = Проводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]];
		КонецЦикла; 		
		Проводка.ВалютаКт        = Проводка.ВалютаДт;
		Проводка.ВалютнаяСуммаКт = Проводка.ВалютнаяСуммаДт;
		Проводка.КоличествоКт    = Проводка.КоличествоДт;
		
		Проводка.НалоговоеНазначениеКт = Проводка.НалоговоеНазначениеДт;
		Проводка.СуммаНУКт = Проводка.СуммаНУДт;
		
		
		// сохраним значение счета дебета в реквизите проводки
		Проводка.СчетДополнительный = СчетКт;
		
		Проводка.НомерИсходнойПроводки = Индекс + мКолвоПроводокЗаписанныхВИБ;

		ПроверитьПроводку(НоваяПроводка);
		ПроверитьПроводку(Проводка);
		
		Возврат Истина;
		
	Иначе
		// исправим дебетовый счет проводки
		Проводка.СчетДт = Счет8Класса;
		СоответсвиеСубконто = Новый Соответствие;
		Для К = 1 По СчетДтСвойства.КоличествоСубконто Цикл
			СоответсвиеСубконто.Вставить(СчетДтСвойства["ВидСубконто"+К], Проводка.СубконтоДт[СчетДтСвойства["ВидСубконто"+К]]);
		КонецЦикла;
		Проводка.СубконтоДт.Очистить();
		Для К = 1 По Счет8КлассаСвойства.КоличествоСубконто Цикл
			Проводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]] = СоответсвиеСубконто.Получить(Счет8КлассаСвойства["ВидСубконто"+К]);
		КонецЦикла; 		
		
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции // ПровестиПоЗатратам()

//Процедура обрабатывает проводки, в котрых Дт и Кт отличаются только аналитикой ДокументыРасчетовСКонтрагентами ("Зачет авансов" когда счет взаиморасчетов = счет авансов)
//сумма такой проводки распределяется между 
Процедура ОбработатьПроводкиПерезачетВнутриСчета()

	//Расчеты
	Если НЕ БухгалтерскийУчетВызовСервераПовтИсп.НаСчетеВедетсяУчетПоДокументамРасчетов(ПланыСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками) Тогда
		Возврат;
	КонецЕсли;
	
	ВидКонтрагенты = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты;
	ВидДоговоры = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры;
	ВидДокРасч = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами;

	ПроводкиПерезачетВнутриСчета = Новый Массив;
	ПроводкиВзаиморасчетов = Новый Массив;
	Для Каждого Проводка Из ЭтотОбъект Цикл
		Если (Проводка.СчетДт = Проводка.СчетКт) И 
			(НЕ Проводка.СубконтоДт[ВидДокРасч]=Неопределено) И
			(НЕ Проводка.СубконтоДт[ВидКонтрагенты]=Неопределено И Проводка.СубконтоДт[ВидКонтрагенты]=Проводка.СубконтоКт[ВидКонтрагенты]) И 
			(НЕ Проводка.СубконтоДт[ВидДоговоры]=Неопределено И Проводка.СубконтоДт[ВидДоговоры]=Проводка.СубконтоКт[ВидДоговоры]) 
			 Тогда
			
			ПроводкиПерезачетВнутриСчета.Добавить(Проводка);
		ИначеЕсли 
			((НЕ Проводка.СубконтоДт[ВидДокРасч]=Неопределено) И (НЕ Проводка.СубконтоДт[ВидКонтрагенты]=Неопределено) И (НЕ Проводка.СубконтоДт[ВидДоговоры]=Неопределено)) ИЛИ
			((НЕ Проводка.СубконтоКт[ВидДокРасч]=Неопределено) И (НЕ Проводка.СубконтоКт[ВидКонтрагенты]=Неопределено) И (НЕ Проводка.СубконтоКт[ВидДоговоры]=Неопределено)) Тогда
			
			ПроводкиВзаиморасчетов.Добавить(Проводка);
		КонецЕсли; 
	КонецЦикла; 
	
	Для каждого ПроводкаЗачета Из ПроводкиПерезачетВнутриСчета Цикл
		
		ВалютныйСчет = ПроводкаЗачета.СчетКт.Валютный;
		Для Каждого Проводка Из ПроводкиВзаиморасчетов Цикл
			МожноЗачесть = Ложь;
			Если (Проводка.СчетДт = ПроводкаЗачета.СчетКт) И 
				(Проводка.СубконтоДт[ВидДокРасч]=ПроводкаЗачета.СубконтоКт[ВидДокРасч]) И
				(Проводка.СубконтоДт[ВидКонтрагенты]=ПроводкаЗачета.СубконтоКт[ВидКонтрагенты]) И 
				(Проводка.СубконтоДт[ВидДоговоры]=ПроводкаЗачета.СубконтоКт[ВидДоговоры]) 
				И ((Проводка.Сумма>0) = (ПроводкаЗачета.Сумма>0))
				 Тогда
				 
				// зачет по дебету
				МожноЗачесть = Истина;
				СторонаЗачета = "Дт";
				СторонаКор = "Кт";
				СторонаАналитики = "Дт"; // Совпадает с СторонаЗачета
				ЗнакСуммы = 1;
				
			ИначеЕсли (Проводка.СчетКт = ПроводкаЗачета.СчетДт) И 
				(Проводка.СубконтоКт[ВидКонтрагенты]=ПроводкаЗачета.СубконтоДт[ВидКонтрагенты]) И 
				(Проводка.СубконтоКт[ВидДоговоры]=ПроводкаЗачета.СубконтоДт[ВидДоговоры]) И 
				(Проводка.СубконтоКт[ВидДокРасч]=ПроводкаЗачета.СубконтоДт[ВидДокРасч]) 
				И ((Проводка.Сумма>0) = (ПроводкаЗачета.Сумма>0))
				Тогда
				
				// зачет по кредиту
				МожноЗачесть = Истина;
				СторонаЗачета = "Кт";
				СторонаКор = "Дт";
				СторонаАналитики = "Кт"; // Совпадает с СторонаЗачета
				ЗнакСуммы = 1;
				
			ИначеЕсли (Проводка.СчетКт = ПроводкаЗачета.СчетКт) И 
				(Проводка.СубконтоКт[ВидКонтрагенты]=ПроводкаЗачета.СубконтоКт[ВидКонтрагенты]) И 
				(Проводка.СубконтоКт[ВидДоговоры]=ПроводкаЗачета.СубконтоКт[ВидДоговоры]) И 
				(Проводка.СубконтоКт[ВидДокРасч]=ПроводкаЗачета.СубконтоКт[ВидДокРасч]) И 
// Суммы разного знака
				((Проводка.Сумма<0) = (ПроводкаЗачета.Сумма>0)) Тогда
				
				// зачет по кредиту
				МожноЗачесть = Истина;
				СторонаЗачета = "Кт";
				СторонаКор = "Кт";
				СторонаАналитики = "Дт"; // НЕ совпадает с СторонаЗачета
				ЗнакСуммы = -1;
				
			КонецЕсли; 
			
			Если МожноЗачесть Тогда
			
				СуммаПереброски = Мин(ЗнакСуммы*Проводка.Сумма, ПроводкаЗачета.Сумма);
				Если ВалютныйСчет Тогда
					СуммаПереброскиВалютная = Мин(ЗнакСуммы*Проводка["ВалютнаяСумма"+СторонаЗачета], ПроводкаЗачета["ВалютнаяСумма"+СторонаЗачета]);
				Иначе
					СуммаПереброскиВалютная = 0;
				КонецЕсли;
				Если СуммаПереброски=0 И СуммаПереброскиВалютная = 0 Тогда
					Продолжить;
				КонецЕсли; 
				
				Если (СуммаПереброски = ЗнакСуммы*Проводка.Сумма) И (НЕ ВалютныйСчет ИЛИ (СуммаПереброскиВалютная = ЗнакСуммы*Проводка["ВалютнаяСумма"+СторонаЗачета])) Тогда
					// сумма переброски совпадает с суммой найденной проводки по взаиморасчетам
					// просто заменяем аналитику в проводке взаиморасчетов
					Проводка["Субконто"+СторонаЗачета][ВидДокРасч] = ПроводкаЗачета["Субконто"+СторонаАналитики][ВидДокРасч];
					
					Проводка.Содержание = Проводка.Содержание + " ("+ ПроводкаЗачета.Содержание+")";
					
					//корректируем проводку зачета
					ПроводкаЗачета.Сумма = ПроводкаЗачета.Сумма - СуммаПереброски;
					Если ВалютныйСчет Тогда
						ПроводкаЗачета.ВалютнаяСуммаДт = ПроводкаЗачета.ВалютнаяСуммаДт - СуммаПереброскиВалютная;
						ПроводкаЗачета.ВалютнаяСуммаКт = ПроводкаЗачета.ВалютнаяСуммаКт - СуммаПереброскиВалютная;
					КонецЕсли;
					
				Иначе 
					// сумма переброски меньше суммы найденной проводки по взаиморасчетам
					
					КорСчетКоличественный = Проводка["Счет"+СторонаКор].Количественный;
					КорСчетВалютный = Проводка["Счет"+СторонаКор].Валютный;
					КорСчетНалоговый = Проводка["Счет"+СторонаКор].НалоговыйУчет;
					
					// новая проводка
					НоваяПроводка = ЭтотОбъект.Вставить(ЭтотОбъект.Индекс(Проводка)+1);
					
					// копируем все свойства от старой идентично
					ЗаполнитьЗначенияСвойств(НоваяПроводка,Проводка);
					ВидыСубконтоКт = Проводка.СчетКт.ВидыСубконто;
					Для К = 1 По ВидыСубконтоКт.Количество() Цикл
						НоваяПроводка.СубконтоКт[ВидыСубконтоКт[К-1].ВидСубконто] = Проводка.СубконтоКт[ВидыСубконтоКт[К-1].ВидСубконто];
					КонецЦикла; 	
					ВидыСубконтоДт = Проводка.СчетДт.ВидыСубконто;
					Для К = 1 По ВидыСубконтоДт.Количество() Цикл
						НоваяПроводка.СубконтоДт[ВидыСубконтоДт[К-1].ВидСубконто] = Проводка.СубконтоДт[ВидыСубконтоДт[К-1].ВидСубконто];
					КонецЦикла; 		
					
					//корректируем аналитику по ДокументыРасчетовСКонтрагентами, Суммы и Содержание
					НоваяПроводка["Субконто"+СторонаЗачета][ВидДокРасч] = ПроводкаЗачета["Субконто"+СторонаАналитики][ВидДокРасч];
					НоваяПроводка.Сумма = ЗнакСуммы*СуммаПереброски;
					Если ВалютныйСчет Тогда
						НоваяПроводка["ВалютнаяСумма"+СторонаЗачета] = ЗнакСуммы*СуммаПереброскиВалютная;
					КонецЕсли;
					
					Если КорСчетКоличественный Тогда
						КорКоличествоПереброски = ?(Проводка.Сумма = 0, 0, Окр(Проводка["Количество"+СторонаКор]* СуммаПереброски / Проводка.Сумма,3,РежимОкругления.Окр15как20));
						НоваяПроводка["Количество"+СторонаКор] = КорКоличествоПереброски;
					КонецЕсли;
					Если КорСчетВалютный Тогда
						КорВалютнаяСуммаПереброски = ?(Проводка.Сумма = 0, 0, Окр(Проводка["ВалютнаяСумма"+СторонаКор]* СуммаПереброски / Проводка.Сумма,3,РежимОкругления.Окр15как20));
						НоваяПроводка["ВалютнаяСумма"+СторонаКор] = ЗнакСуммы*КорВалютнаяСуммаПереброски;
					КонецЕсли;
					Если КорСчетНалоговый Тогда
						КорСуммаНУПереброски = ?(Проводка.Сумма = 0, 0, Окр(Проводка["СуммаНУ"+СторонаКор]* СуммаПереброски / Проводка.Сумма,3,РежимОкругления.Окр15как20));
						НоваяПроводка["СуммаНУ"+СторонаКор] = ЗнакСуммы*КорСуммаНУПереброски;
					КонецЕсли;
					
					НоваяПроводка.Содержание = НоваяПроводка.Содержание + " ("+ ПроводкаЗачета.Содержание+")";
					
					//корректируем исходную проводку взаиморасчетов
					Проводка.Сумма = Проводка.Сумма - ЗнакСуммы*СуммаПереброски;
					Если ВалютныйСчет Тогда
						Проводка["ВалютнаяСумма"+СторонаЗачета] = Проводка["ВалютнаяСумма"+СторонаЗачета] - ЗнакСуммы*СуммаПереброскиВалютная;
					КонецЕсли;
					Если КорСчетКоличественный Тогда
						Проводка["Количество"+СторонаКор] = Проводка["Количество"+СторонаКор] - КорКоличествоПереброски;
					КонецЕсли;
					Если КорСчетВалютный Тогда
						Проводка["ВалютнаяСумма"+СторонаКор] = Проводка["ВалютнаяСумма"+СторонаКор] - ЗнакСуммы*КорВалютнаяСуммаПереброски;
					КонецЕсли;
					Если КорСчетНалоговый Тогда
						Проводка["СуммаНУ"+СторонаКор] = Проводка["СуммаНУ"+СторонаКор] - ЗнакСуммы*КорСуммаНУПереброски;
					КонецЕсли;
					
					//корректируем проводку зачета
					ПроводкаЗачета.Сумма = ПроводкаЗачета.Сумма - СуммаПереброски;
					Если ВалютныйСчет Тогда
						ПроводкаЗачета.ВалютнаяСуммаДт = ПроводкаЗачета.ВалютнаяСуммаДт - СуммаПереброскиВалютная;
						ПроводкаЗачета.ВалютнаяСуммаКт = ПроводкаЗачета.ВалютнаяСуммаКт - СуммаПереброскиВалютная;
					КонецЕсли;
					
				КонецЕсли; 
			КонецЕсли; 
			Если (ПроводкаЗачета.Сумма = 0) И (НЕ ВалютныйСчет ИЛИ (ПроводкаЗачета.ВалютнаяСуммаДт = 0)) Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла;
	
	// удаляем проводки зачета, суммы которых удалось распределить полностью
	Для каждого ПроводкаЗачета Из ПроводкиПерезачетВнутриСчета Цикл
		ВалютныйСчет = ПроводкаЗачета.СчетДт.Валютный;
		Если (ПроводкаЗачета.Сумма = 0) И (НЕ ВалютныйСчет ИЛИ (ПроводкаЗачета.ВалютнаяСуммаДт = 0)) Тогда
			ЭтотОбъект.Удалить(ПроводкаЗачета);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
 
Процедура ВыполнитьДействияПередЗаписьюДвижений() Экспорт

	КвоПроводок    = ЭтотОбъект.Количество();
	КвоДобавленных = 0;
	
	Если мКолвоПроводокЗаписанныхВИБ = Неопределено Тогда
		мКолвоПроводокЗаписанныхВИБ = 0;
	КонецЕсли;	
	
	Если КвоПроводок = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	ОбработатьПроводкиПерезачетВнутриСчета();
	КвоПроводок    = ЭтотОбъект.Количество();
	
	СтруктураПараметров = Новый Структура;
	
	Для К = 1 По КвоПроводок Цикл
		
		Индекс = К - 1 + КвоДобавленных;
		Проводка = ЭтотОбъект[Индекс];
		
		Если ПровестиПоЗатратам(Проводка, Индекс, СтруктураПараметров) Тогда
			КвоДобавленных = КвоДобавленных + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	мДействияПередЗаписьюВыполнены = Истина;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ мДействияПередЗаписьюВыполнены = Истина Тогда
		ОбработатьПроводкиПерезачетВнутриСчета()
	КонецЕсли;

	КвоПроводок    = ЭтотОбъект.Количество();
	КвоДобавленных = 0;
	
	Если мКолвоПроводокЗаписанныхВИБ = Неопределено Тогда
		мКолвоПроводокЗаписанныхВИБ = 0;
	КонецЕсли;	
	
	Если КвоПроводок > 0 Тогда
	    Заголовок = СокрЛП(ЭтотОбъект.Отбор.Регистратор.Значение);
	Иначе
		Возврат;
	КонецЕсли; 
	
	СтруктураПараметров = Новый Структура;
	
	Для К = 1 По КвоПроводок Цикл
		
		Индекс = К - 1 + КвоДобавленных;
		Проводка = ЭтотОбъект[Индекс];
		
		
		Если Не Отказ Тогда
			Если мДействияПередЗаписьюВыполнены = Истина Тогда
				ПроверитьПроводку(Проводка);
			Иначе
				Если ПровестиПоЗатратам(Проводка, Индекс, СтруктураПараметров) Тогда
					КвоДобавленных = КвоДобавленных + 1;
				Иначе
					ПроверитьПроводку(Проводка);
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
		
	КонецЦикла;
		
	КвоПроводокОбщее    = ЭтотОбъект.Количество();
	Для К = 1 По КвоПроводокОбщее Цикл
		
		Индекс = К - 1;
		Проводка = ЭтотОбъект[Индекс];
		
		// Приведение пустых значений субконто составного типа.
		Для Каждого Субконто Из Проводка.СубконтоДт Цикл
			ТипыСубконто = Субконто.Ключ.ТипЗначения.Типы();
			Если ТипыСубконто.Количество() > 1
			   И НЕ ЗначениеЗаполнено(Субконто.Значение) 
			   И НЕ (Субконто.Значение = Неопределено) Тогда
				Проводка.СубконтоДт.Вставить(Субконто.Ключ, Неопределено);
			ИначеЕсли ТипыСубконто.Количество() = 1	И Субконто.Значение = Неопределено Тогда
				Проводка.СубконтоДт.Вставить(Субконто.Ключ, ОбщегоНазначенияБПКлиентСервер.ПустоеЗначениеТипа(ТипыСубконто[0]));
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Субконто Из Проводка.СубконтоКт Цикл
			ТипыСубконто = Субконто.Ключ.ТипЗначения.Типы();
			Если ТипыСубконто.Количество() > 1
			   И НЕ ЗначениеЗаполнено(Субконто.Значение) 
			   И НЕ (Субконто.Значение = Неопределено) Тогда
				Проводка.СубконтоКт.Вставить(Субконто.Ключ, Неопределено);
			ИначеЕсли ТипыСубконто.Количество() = 1	И Субконто.Значение = Неопределено Тогда	
				Проводка.СубконтоКт.Вставить(Субконто.Ключ, ОбщегоНазначенияБПКлиентСервер.ПустоеЗначениеТипа(ТипыСубконто[0]));
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Если РежимЗаписи = Ложь Тогда
		мКолвоПроводокЗаписанныхВИБ = мКолвоПроводокЗаписанныхВИБ + КвоПроводокОбщее;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
