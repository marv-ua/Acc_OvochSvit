﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Дата = НачалоДня(КонецМесяца(Объект.Дата));
		ВключитьВыключитьФлажки(Истина);    
		ВключитьВыполняемыеОперацииПоУмолчанию(Объект.Организация, Объект.Дата);
		УстановитьСостояниеДокумента();	
	КонецЕсли;
	
	ФормированиеДереваВыполняемыхОпераций(Объект.Организация, Объект.Дата);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПередЗаписьюНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УстановитьСостояниеДокумента();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоВыполняемыхОперацийБУПриИзменении(Элемент)
	
	ДеревоВыполняемыхОперацийПриИзменении("БУ");
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыполняемыхОперацийНУПриИзменении(Элемент)
	
	ДеревоВыполняемыхОперацийПриИзменении("НУ");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) <> НачалоДня(КонецМесяца(Объект.Дата)) Тогда
		Объект.Дата = НачалоДня(КонецМесяца(Объект.Дата));
	КонецЕсли;
	ЗаписатьСостояниеСпискаВыполняемыхДействий(); 
	ВключитьВыполняемыеОперацииПоУмолчанию(Объект.Организация, Объект.Дата);
	ФормированиеДереваВыполняемыхОпераций(Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОрганизацияОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДеревоВыполняемыхОперацийВключитьВсе(Команда)
	
	ВключитьВыключитьФлажки(Истина); 
	ВключитьВыполняемыеОперацииПоУмолчанию(Объект.Организация, Объект.Дата);
	ФормированиеДереваВыполняемыхОпераций(Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыполняемыхОперацийВыключитьВсе(Команда)
	
	ВключитьВыключитьФлажки(Ложь);
	ФормированиеДереваВыполняемыхОпераций(Объект.Организация, Объект.Дата);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Функция ФормированиеДереваВыполняемыхОпераций(УказаннаяОрганизация, УказаннаяДата) Экспорт
	
	ДатаНКУ2015 = '2015 01 01';

	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(УказаннаяОрганизация, УказаннаяДата);
	ПлательщикНДС 			  = УчетнаяПолитика.ПлательщикНДС(УказаннаяОрганизация, УказаннаяДата);
	ПлательщикНалогаНаПрибыльДо2015 = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(УказаннаяОрганизация, УказаннаяДата);
	
	СтрокиДерева = ДеревоВыполняемыхОпераций.ПолучитьЭлементы();
	СтрокиДерева.Очистить();
	
	// АМОРТИЗАЦИЯ       
	ВозможноНачислениеАмортизацииНУ = Истина;
	
	// Амортизация ОС
	СтрокаГруппаДействий             = СтрокиДерева.Добавить();
	СтрокаГруппаДействий.Действие    = НСтр("ru='Начисление амортизации';uk='Нарахування амортизації'");
	СтрокаГруппаДействий.УправлятьБУ = Истина;
	СтрокаГруппаДействий.УправлятьНУ = ВозможноНачислениеАмортизацииНУ;
	ВсеБУ                            = ?(Объект.АмортизацияОС,1,0) 
	                                 + ?(Объект.АмортизацияНМА,1,0);
									 
	НачислениеАмортизации2015 = УказаннаяДата >= ДатаНКУ2015;
									 
	Если НачислениеАмортизации2015 Тогда 
		ВсеНУ                            = ?(ВозможноНачислениеАмортизацииНУ И Объект.АмортизацияОСНУ,1,0) 
		                                 + ?(ВозможноНачислениеАмортизацииНУ И Объект.АмортизацияНМАНУ,1,0); 
	Иначе
		ВсеНУ                            = ?(ПлательщикНалогаНаПрибыль И Объект.АмортизацияОС,1,0) 
		                                 + ?(ПлательщикНалогаНаПрибыль И Объект.АмортизацияНМА,1,0);
	КонецЕсли;								 
	СтрокаГруппаДействий.БУ          = ?(ВсеБУ = 0,0,?(ВсеБУ=2,1,2));
	СтрокаГруппаДействий.НУ          = ?(ВсеНУ = 0,0,?(ВсеНУ=2,1,2));
	
	Если НачислениеАмортизации2015 Тогда 
		СтрокаГруппаДействий.НУЗависитОтБУ = Ложь;
	Иначе
		СтрокаГруппаДействий.НУЗависитОтБУ = Истина;
	КонецЕсли;
	
	Строка = СтрокаГруппаДействий.ПолучитьЭлементы().Добавить();
	Строка.Действие      = НСтр("ru='Начисление амортизации ОС';uk='Нарахування амортизації ОЗ'");
	Строка.БУ            = ?(Объект.АмортизацияОС,1,0);
	Если НачислениеАмортизации2015 Тогда 
		Строка.НУ        = ?(Объект.АмортизацияОСНУ,1,0);
	Иначе
		Строка.НУ        = Строка.БУ;
	КонецЕсли;
	Строка.УправлятьБУ   = Истина;     
	Строка.УправлятьНУ   = ВозможноНачислениеАмортизацииНУ;
	Если НачислениеАмортизации2015 Тогда 
		Строка.НУЗависитОтБУ = Ложь;
	Иначе
		Строка.НУЗависитОтБУ = Истина;
	КонецЕсли;
	
	// Амортизация НМА
	Строка = СтрокаГруппаДействий.ПолучитьЭлементы().Добавить();
	Строка.Действие      = НСтр("ru='Начисление амортизации НМА';uk='Нарахування амортизації НМА'");
	Строка.БУ            = ?(Объект.АмортизацияНМА,1,0);
	Если НачислениеАмортизации2015 Тогда 
		Строка.НУ        = ?(Объект.АмортизацияНМАНУ,1,0);
	Иначе
		Строка.НУ        = Строка.БУ;
	КонецЕсли;
	Строка.УправлятьБУ   = Истина;
	Строка.УправлятьНУ   = ВозможноНачислениеАмортизацииНУ;
	Если НачислениеАмортизации2015 Тогда 
		Строка.НУЗависитОтБУ = Ложь;
	Иначе
		Строка.НУЗависитОтБУ = Истина;
	КонецЕсли;
	
	// ПЕРЕОЦЕНКА ВАЛЮТНЫХ СРЕДСТВ
	Строка               = СтрокиДерева.Добавить();
	Строка.Действие      = НСтр("ru='Переоценка валютных средств';uk='Переоцінка валютних коштів'");
	Строка.БУ            = ?(Объект.ПереоценкаВалютныхСредств,1,0);
	Строка.НУ            = Строка.БУ;
	Строка.УправлятьБУ   = Истина;
	Строка.УправлятьНУ   = ПлательщикНалогаНаПрибыльДо2015;
	Строка.НУЗависитОтБУ = Истина;
	
	//РАСПРЕДЕЛЕНИЕ ТЗР
	Строка               = СтрокиДерева.Добавить();
	Строка.Действие      = НСтр("ru='Распределение ТЗР';uk='Розподіл ТЗВ'");
	Строка.БУ            = ?(Объект.РаспределениеТЗР,1,0);
	Строка.НУ            = Строка.БУ;
	Строка.УправлятьБУ   = Истина;
	Строка.УправлятьНУ   = ПлательщикНалогаНаПрибыльДо2015;
	Строка.НУЗависитОтБУ = Истина;
	
		
	// КОРРЕКТИРОВКА СТОИМОСТИ НОМЕНКЛАТУРЫ БУ/НУ
	Строка = СтрокиДерева.Добавить();
	Строка.Действие    	 = НСтр("ru='Корректировка фактической стоимости номенклатуры';uk='Коригування фактичної вартості номенклатури'");
	Строка.БУ            = ?(Объект.КорректировкаСтоимостиНоменклатуры,1,0);
	Строка.НУ            = Строка.БУ;
	Строка.УправлятьБУ   = Истина;
	Строка.УправлятьНУ   = ПлательщикНалогаНаПрибыльДо2015;
	Строка.НУЗависитОтБУ = Истина;
	
	// СПИСАНИЕ РБП БУ/НУ
	Строка = СтрокиДерева.Добавить();
	Строка.Действие      = НСтр("ru='Списание расходов будущих периодов';uk='Списання витрат майбутніх періодів'");
	Строка.БУ     	     = ?(Объект.СписаниеРБП,1,0);
	Строка.НУ            = Строка.БУ;
	Строка.УправлятьБУ   = Истина;
	Строка.УправлятьНУ   = ПлательщикНалогаНаПрибыльДо2015;
	Строка.НУЗависитОтБУ = Истина;
	
	// ПРОИЗВОДСТВО БУ/НУ
	Строка = СтрокиДерева.Добавить();
	Строка.Действие    	= НСтр("ru='Расчет и корректировка себестоимости продукции (услуг)';uk='Розрахунок і коригування собівартості продукції (послуг)'");
	Строка.БУ			= ?(Объект.РасчетСтоимостиПродукции,1,0);
	Строка.НУ           = Строка.БУ;
	Строка.УправлятьБУ  = Истина;
	Строка.УправлятьНУ   = ПлательщикНалогаНаПрибыльДо2015;
	Строка.НУЗависитОтБУ= Истина;
	
	// РЕГЛАМЕНТНЫЕ ОПЕРАЦИИ ПО БУХГАЛТЕРСКОМУ УЧЕТУ
	
	СтрокаГруппаДействий = СтрокиДерева.Добавить();
	СтрокаГруппаДействий.Действие    = НСтр("ru='Регламентные операции по бухгалтерскому учету';uk='Регламентні операції по бухгалтерському обліку'");
	СтрокаГруппаДействий.УправлятьБУ = Истина;
	СтрокаГруппаДействий.УправлятьНУ = Ложь;
		
	ВсеБУ = ?(Объект.ПереоценкаСтоимостиЗапасовБУ,1,0);
	СтрокаГруппаДействий.БУ = ?(ВсеБУ = 0, 0, ?(ВсеБУ = 1, 1, 2));
	
	// ПЕРЕОЦЕНКА ЗАПАСОВ БУ
	Строка = СтрокаГруппаДействий.ПолучитьЭлементы().Добавить();
	Строка.Действие    = НСтр("ru='Переоценка стоимости запасов';uk='Переоцінка вартості запасів'");
	Строка.БУ                        = ?(Объект.ПереоценкаСтоимостиЗапасовБУ,1,0);
	Строка.УправлятьБУ = Истина;
	Строка.УправлятьНУ = Ложь;
	
	
	// ТОРГОВЛЯ
	Если УчетВПродажныхЦенах(УказаннаяОрганизация) Тогда
		Строка = СтрокиДерева.Добавить();
		Строка.Действие      = НСтр("ru='Расчет торговой наценки по проданным товарам';uk='Розрахунок торгової націнки по проданих товарах'");
		Строка.БУ            = ?(Объект.РасчетТорговойНаценкиПоПроданнымТоварам,1,0);
		Строка.НУ            = Строка.БУ;
		Строка.УправлятьБУ   = Истина;
		Строка.УправлятьНУ   = ПлательщикНалогаНаПрибыльДо2015;
		Строка.НУЗависитОтБУ = Истина;
	КонецЕсли;
	
	
	// РЕГЛАМЕНТНЫЕ ОПЕРАЦИИ ПО НАЛОГОВОМУ УЧЕТУ
	
	
	// технологические операции по налоговому учете
	Если ПлательщикНДС Тогда
    	СтрокаГруппаДействий = СтрокиДерева.Добавить();
		СтрокаГруппаДействий.Действие    = НСтр("ru='Технологические операции по налоговому учету';uk='Технологічні операції по податковому обліку'");
		СтрокаГруппаДействий.УправлятьБУ = Ложь;
		СтрокаГруппаДействий.УправлятьНУ = Истина;
		
		ВсеНУ =  ?(Объект.ЗакрытиеНалоговыхРегистровНУ,1,0); 
		СтрокаГруппаДействий.НУ = ?(ВсеНУ = 0, 0, ?(ВсеНУ = 1, 1, 2));
		
		Строка = СтрокаГруппаДействий.ПолучитьЭлементы().Добавить();
		Строка.Действие      = НСтр("ru='Закрытие регистров налогового учета';uk='Закриття регістрів податкового обліку'");
		Строка.НУ            = ?(Объект.ЗакрытиеНалоговыхРегистровНУ,1,0);
		Строка.УправлятьБУ   = Ложь;
		Строка.УправлятьНУ   = Истина;
	КонецЕсли; 
	
	Если ПлательщикНалогаНаПрибыль Тогда
		Строка = СтрокиДерева.Добавить();
		Строка.Действие      = НСтр("ru='Расчет налоговых разниц после перехода с ЕН';uk='Розрахунок податкових різниць після переходу з ЄП'");
		Строка.НУ            = Объект.РасчетНалоговыхРазниц;
		Строка.УправлятьБУ   = Ложь;
		Строка.УправлятьНУ   = Истина;
	КонецЕсли;
	
КонецФункции // ФормированиеДереваВыполняемыхОпераций()

&НаСервере
Функция УчетВПродажныхЦенах(УказаннаяОрганизация)
	
	Применяется = Ложь;
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(УказаннаяОрганизация) Тогда
	Иначе
		СпособОценкиТоваровВРознице = ПолучитьФункциональнуюОпцию("СпособОценкиТоваровВРознице", Новый Структура("Организация, Период", УказаннаяОрганизация, НачалоМесяца(Объект.Дата)));
		Применяется = (СпособОценкиТоваровВРознице = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости);
	КонецЕсли;
	
	Возврат Применяется;

КонецФункции // ПрименяетсяДиректКостинг()

&НаСервере
Процедура ПередЗаписьюНаСервере()
	
	ЗаписатьСостояниеСпискаВыполняемыхДействий();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСостояниеСпискаВыполняемыхДействий()

	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	
	ДеревоОпераций = ДанныеФормыВЗначение(ДеревоВыполняемыхОпераций, Тип("ДеревоЗначений"));
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Начисление амортизации ОС';uk='Нарахування амортизації ОЗ'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.АмортизацияОС 	= Ложь;
		Объект.АмортизацияОСНУ 	= Ложь;
	Иначе
		Объект.АмортизацияОС 	= НайденнаяСтрока.БУ;
		Объект.АмортизацияОСНУ 	= НайденнаяСтрока.НУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Начисление амортизации НМА';uk='Нарахування амортизації НМА'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.АмортизацияНМА 	= Ложь;
		Объект.АмортизацияНМАНУ = Ложь;
	Иначе
		Объект.АмортизацияНМА 	= НайденнаяСтрока.БУ;
		Объект.АмортизацияНМАНУ = НайденнаяСтрока.НУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Переоценка валютных средств';uk='Переоцінка валютних коштів'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.ПереоценкаВалютныхСредств = Ложь;
	Иначе
		Объект.ПереоценкаВалютныхСредств = НайденнаяСтрока.БУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Корректировка фактической стоимости номенклатуры';uk='Коригування фактичної вартості номенклатури'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.КорректировкаСтоимостиНоменклатуры = Ложь;
	Иначе
		Объект.КорректировкаСтоимостиНоменклатуры = НайденнаяСтрока.БУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Списание расходов будущих периодов';uk='Списання витрат майбутніх періодів'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.СписаниеРБП = Ложь;
	Иначе
		Объект.СписаниеРБП = НайденнаяСтрока.БУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Расчет и корректировка себестоимости продукции (услуг)';uk='Розрахунок і коригування собівартості продукції (послуг)'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.РасчетСтоимостиПродукции = Ложь;
	Иначе
		Объект.РасчетСтоимостиПродукции = НайденнаяСтрока.БУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Переоценка стоимости запасов';uk='Переоцінка вартості запасів'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.ПереоценкаСтоимостиЗапасовБУ = Ложь;
	Иначе
		Объект.ПереоценкаСтоимостиЗапасовБУ = НайденнаяСтрока.БУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Расчет торговой наценки по проданным товарам';uk='Розрахунок торгової націнки по проданих товарах'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.РасчетТорговойНаценкиПоПроданнымТоварам= Ложь;
	Иначе
		Объект.РасчетТорговойНаценкиПоПроданнымТоварам = НайденнаяСтрока.БУ;
	КонецЕсли;
	
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Закрытие регистров налогового учета';uk='Закриття регістрів податкового обліку'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.ЗакрытиеНалоговыхРегистровНУ = Ложь;
		
	Иначе
		Объект.ЗакрытиеНалоговыхРегистровНУ = НайденнаяСтрока.НУ;
	КонецЕсли;	
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Распределение ТЗР';uk='Розподіл ТЗВ'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.РаспределениеТЗР = Ложь;
	Иначе
		Объект.РаспределениеТЗР = НайденнаяСтрока.БУ;
	КонецЕсли;
	
	НайденнаяСтрока = ДеревоОпераций.Строки.Найти(НСтр("ru='Расчет налоговых разниц после перехода с ЕН';uk='Розрахунок податкових різниць після переходу з ЄП'"), "Действие", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		Объект.РасчетНалоговыхРазниц = Ложь;
	Иначе
		Объект.РасчетНалоговыхРазниц = НайденнаяСтрока.НУ;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ВключитьВыключитьФлажки(Параметр) Экспорт
	
		Объект.АмортизацияОС                                 = Параметр;
		Объект.АмортизацияНМА                                = Параметр;
		
		Объект.АмортизацияОСНУ                         		 = Параметр;
		Объект.АмортизацияНМАНУ                        		 = Параметр;
		
		Объект.ПереоценкаВалютныхСредств                     = Параметр;
		Объект.КорректировкаСтоимостиНоменклатуры            = Параметр;
		Объект.СписаниеРБП                                   = Параметр;
		Объект.РасчетСтоимостиПродукции                      = Параметр;
		Объект.ПереоценкаСтоимостиЗапасовБУ                  = Параметр;
	
		Если УчетВПродажныхЦенах(Объект.Организация) Тогда
			Объект.РасчетТорговойНаценкиПоПроданнымТоварам 	 = Параметр;
		КонецЕсли;
		Объект.ЗакрытиеНалоговыхРегистровНУ					 = Параметр;

		Объект.РаспределениеТЗР                              = Параметр;
		
		Объект.РасчетНалоговыхРазниц						 = Параметр;
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыполняемыхОперацийПриИзменении(ИзменяемоеЗначение)
	
	ТекущаяСтрока = ДеревоВыполняемыхОпераций.НайтиПоИдентификатору(Элементы.ДеревоВыполняемыхОпераций.ТекущаяСтрока);
	
	Модифицированность = Истина; 
	
	Если ИзменяемоеЗначение = "БУ" Тогда
		Если ТекущаяСтрока.НУЗависитОтБУ Тогда
			ТекущаяСтрока.НУ = ТекущаяСтрока.БУ;
		КонецЕсли;
		ПодчиненныеСтроки = ТекущаяСтрока.ПолучитьЭлементы();
		Для каждого Строка из ПодчиненныеСтроки Цикл
			Строка.БУ = ТекущаяСтрока.БУ;
			Если Строка.НУЗависитОтБУ Тогда
				Строка.НУ = Строка.БУ;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ИзменяемоеЗначение = "НУ" Тогда
		Если ТекущаяСтрока.НУЗависитОтБУ Тогда
			ТекущаяСтрока.НУ = ТекущаяСтрока.БУ;
		Иначе
			ПодчиненныеСтроки = ТекущаяСтрока.ПолучитьЭлементы();
			Для каждого Строка из ПодчиненныеСтроки Цикл
				Строка.НУ = ТекущаяСтрока.НУ;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	СтрокаРодитель = ТекущаяСтрока.ПолучитьРодителя();
	Если СтрокаРодитель <> Неопределено Тогда
		ВсеБУВключены = Истина;
		ВсеНУВключены = Истина;
		ПодчиненныеСтроки = СтрокаРодитель.ПолучитьЭлементы();
		Для каждого Строка из ПодчиненныеСтроки Цикл
			Если НЕ Строка.БУ Тогда
				ВсеБУВключены = Ложь;
			КонецЕсли;
			Если НЕ Строка.НУ Тогда
				ВсеНУВключены = Ложь;
			КонецЕсли;
		КонецЦикла;
		СтрокаРодитель.БУ = ВсеБУВключены;
		СтрокаРодитель.НУ = ВсеНУВключены;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере                                  
Процедура ВключитьВыполняемыеОперацииПоУмолчанию(УказаннаяОрганизация, УказаннаяДата)
	
	Если КонецМесяца(УказаннаяДата) = КонецКвартала(УказаннаяДата) Тогда
		Объект.ПереоценкаВалютныхСредств = Истина;
		Объект.ПереоценкаСтоимостиЗапасовБУ = Истина;
	Иначе
		Объект.ПереоценкаВалютныхСредств = Ложь;
		Объект.ПереоценкаСтоимостиЗапасовБУ = Ложь;
	КонецЕсли;
	Если НЕ УчетнаяПолитика.ПлательщикНалогаНаПрибыль(УказаннаяОрганизация, УказаннаяДата) = Истина Тогда
		Объект.АмортизацияОСНУ = Ложь;
		Объект.АмортизацияНМАНУ = Ложь;
	Иначе
		Объект.АмортизацияОСНУ = Истина;
		Объект.АмортизацияНМАНУ = Истина;
	КонецЕсли;     
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	ПлательщикНалогаНаПрибыль 					= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ПлательщикНалогаНаПрибыльВыбранноеЗначение	= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(ВыбранноеЗначение, Объект.Дата);
	УчетВПродажныхЦенах = УчетВПродажныхЦенах(Объект.Организация);
	УчетВПродажныхЦенахВыбранноеЗначение = УчетВПродажныхЦенах(ВыбранноеЗначение);
	
	Если (ПлательщикНалогаНаПрибыль <> ПлательщикНалогаНаПрибыльВыбранноеЗначение) 
		ИЛИ (УчетВПродажныхЦенах <> УчетВПродажныхЦенахВыбранноеЗначение)Тогда
		
		ЗаписатьСостояниеСпискаВыполняемыхДействий();
		ВключитьВыполняемыеОперацииПоУмолчанию(ВыбранноеЗначение, Объект.Дата);
		ФормированиеДереваВыполняемыхОпераций(ВыбранноеЗначение, Объект.Дата);
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти