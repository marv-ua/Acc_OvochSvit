﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	    	
	ПараметрыУчета = ОбщегоНазначенияБПВызовСервера.ОпределитьПараметрыУчета();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыУчета);
	
	Если КадровыйУчет Тогда
		КадровыйУчетПолный = 1;
		КадровыйУчетУпрощенный = 0;
	Иначе
		КадровыйУчетПолный = 0;
		КадровыйУчетУпрощенный = 1;
	КонецЕсли;
	
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
	ВестиУчетПоСкладам = СкладскойУчет <> 0;
	
	
	НадписьКадровыйУчет = НСтр("ru='Кадровый учет:';uk='Кадровий облік:'");
	
    РасширеннаяЗиК = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы");
	
	ТолькоПросмотр = НЕ РольДоступна("ПолныеПрава");
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПараметрыУчета = ПолучитьСтруктуруПараметровУчета(ЭтаФорма);
	ТекстВопроса = ПолучитьТекстВопросаПродолжитьЗапись(ПараметрыУчета);
	Если ПустаяСтрока(ТекстВопроса) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("ПропуститьПроверку") 
		И ПараметрыЗаписи.ПропуститьПроверку Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПередЗаписьюЗавершение", ЭтотОбъект, ПараметрыЗаписи);
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаписьюЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПараметрыЗаписи.Вставить("ПропуститьПроверку", Истина);
		Записать(ПараметрыЗаписи);
		Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыУчета = ПолучитьСтруктуруПараметровУчета(ЭтаФорма);
	ОбщегоНазначенияБПВызовСервера.ПрименитьПараметрыУчета(ПараметрыУчета, ИзмененыПараметрыСубконто, Отказ);
	
	
	Константы.ИспользоватьПодсистемуПроизводство.Установить(ТекущийОбъект.ВедетсяПроизводственнаяДеятельность);
	
	Константы.ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениям.Установить(КассыОбособленныхПодразделений);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеНастроекПараметровУчета");
	
	Если ИзмененыПараметрыСубконто Тогда
		ПоказатьОповещениеПользователя(НСтр("ru='Изменены параметры субконто';uk='Змінені параметри субконто'"), 
			"e1cib/app/Обработка.ЖурналРегистрации", "Журнал регистрации");
	КонецЕсли;
	
	ОбновитьИсходныеЗначения(ЭтаФорма);	
	УправлениеФормой(ЭтаФорма);
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Установить текущую страницу
	Если ТипЗнч(ПараметрыОткрытия) = Тип("Структура") Тогда
		АктивныйЭлемент = Неопределено;
		ПараметрыОткрытия.Свойство("АктивныйЭлемент", АктивныйЭлемент);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ


&НаКлиенте
Процедура ИспользоватьВалютныйУчетПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВедетсяРозничнаяТорговляПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОборотнуюНоменклатуруПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазделятьПоСтавкамНДСПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиПартионныйУчетПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетПоСкладамПриИзменении(Элемент)
	
	СкладскойУчет = Число(ВестиУчетПоСкладам);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкладскойУчетПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СкладскойУчет) Тогда
		СкладскойУчет = 1;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВедетсяПроизводственнаяДеятельностьПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетПоРаботникамПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УчетЗарплатыИКадровВоВнешнейПрограммеПриИзменении(Элемент)
	
	Если УчетЗарплатыИКадровВоВнешнейПрограмме = 0 Тогда
		Элементы.СтраницыКадровыйУчет.ТекущаяСтраница = Элементы.КадровыйУчетВЭтойПрограмме;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтаФорма.Элементы, "СформироватьКадровыеДокументы", "Доступность", КадровыйУчет);
	Иначе
		Элементы.СтраницыКадровыйУчет.ТекущаяСтраница = Элементы.КадровыйУчетВоВнешнейПрограмме;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура КассыОбособленныхПодразделенийПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиРасчетыПоДокументамПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ ТолькоПросмотр Тогда
		ПараметрыЗаписи = Новый Структура("Закрыть", Истина);
		Если НЕ Записать(ПараметрыЗаписи) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Если Окно.Основное Тогда
		ПерейтиПоНавигационнойСсылке("e1cib/navigationpoint/СправочникиИНастройкиУчета");
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Валюты(Команда)
	
	Если Модифицированность И НЕ ТолькоПросмотр Тогда
		Если НЕ ЗаписатьНайстройкиПараметров("ИспользоватьВалютныйУчет") Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Валюты.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьНумерациюСтраницКассовойКниги(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиПечатиКассовойКниги.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыУчетаКурсовыхРазниц(Команда)
	
	Если Модифицированность И НЕ ТолькоПросмотр Тогда
		Если НЕ ЗаписатьНайстройкиПараметров("ИспользоватьВалютныйУчет") Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ПараметрыУчетаКурсовыхРазниц.ФормаСписка");
	
КонецПроцедуры


&НаКлиенте
Процедура СоздатьКадровыеДокументы(Команда)
	
	Если НЕ ТолькоПросмотр Тогда
		Если НЕ Записать() Тогда
			Возврат;
		Иначе
			СформироватьКадровыеПриказы();			
			ПоказатьОповещениеПользователя(НСтр("ru='Формирование кадровых документов завершено.';uk='Формування кадрових документів завершено.'"), "e1cib/navigationpoint/ЗарплатаИКадры.КадровыйУчет/ЖурналДокументов.КадровыеДокументы.Команда.ОткрытьСписок", "Журнал ""Приемы, увольнения, переводы""");
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура КадровыйУчетУпрощенныйПриИзменении(Элемент)
	Если КадровыйУчетУпрощенный = 1 Тогда
		КадровыйУчетПолный = 0;
		КадровыйУчет = Ложь;
	КонецЕсли;	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтаФорма.Элементы, "СформироватьКадровыеДокументы", "Доступность", КадровыйУчет);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтаФорма.Элементы, "ИспользоватьУпрощенныйУчетНачислений", "Доступность", НЕ КадровыйУчет);
КонецПроцедуры

&НаКлиенте
Процедура КадровыйУчетПолныйПриИзменении(Элемент)
	Если КадровыйУчетПолный = 1 Тогда
		КадровыйУчетУпрощенный = 0;
		КадровыйУчет = Истина;
		ЭтаФорма.НаборКонстант.ИспользоватьУпрощенныйУчетНачислений = Ложь;
	КонецЕсли;	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтаФорма.Элементы, "СформироватьКадровыеДокументы", "Доступность", КадровыйУчет);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтаФорма.Элементы, "ИспользоватьУпрощенныйУчетНачислений", "Доступность",НЕ КадровыйУчет);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ЗаписатьНайстройкиПараметров(ИмяКонстанты)
	Перем Результат;
	
	ЗначениеКонстанты	= Константы[ИмяКонстанты].Получить();
	Если НЕ НаборКонстант[ИмяКонстанты] = ЗначениеКонстанты Тогда
		Результат	= Записать();
	Иначе
		// Запись не требуется, значение константы совпадает с значением набора
		Результат	= Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Параметры.Свойство("ПараметрыОткрытия", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСтруктуруПараметровУчета(Форма)
	
	ПараметрыУчета = ОбщегоНазначенияБПКлиентСервер.СтруктураПараметровУчета();
	ЗаполнитьЗначенияСвойств(ПараметрыУчета, Форма);
	
	Возврат ПараметрыУчета;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстВопросаПродолжитьЗапись(Знач СтруктураПараметровУчета)
	
	ДействияИзмененияСубконто = ОбщегоНазначенияБПВызовСервера.ПолучитьДействияИзмененияСубконто(СтруктураПараметровУчета);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДействий", ДействияИзмененияСубконто);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Счет КАК Счет,
	|	ВЫРАЗИТЬ(Таблица.Субконто КАК ПланВидовХарактеристик.ВидыСубконтоХозрасчетные) КАК Субконто,
	|	-Таблица.Действие КАК Действие,
	|	-Таблица.Количественный КАК Количественный,
	|	-Таблица.Суммовой КАК Суммовой,
	|	Таблица.ТолькоОбороты КАК ТолькоОбороты,
	|	-Таблица.Валютный КАК Валютный
	|ПОМЕСТИТЬ СчетаСубконто
	|ИЗ
	|	&ТаблицаДействий КАК Таблица
	|ГДЕ
	|	(Таблица.Действие = -1
	|			ИЛИ Таблица.Количественный = -1
	|			ИЛИ Таблица.Суммовой = -1
	|			ИЛИ Таблица.ТолькоОбороты = 1
	|			ИЛИ Таблица.Валютный = -1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаСубконто.Субконто.Наименование КАК Субконто,
	|	МАКСИМУМ(СчетаСубконто.Действие) КАК Действие,
	|	МАКСИМУМ(СчетаСубконто.Количественный) КАК Количественный,
	|	МАКСИМУМ(СчетаСубконто.Суммовой) КАК Суммовой,
	|	МАКСИМУМ(СчетаСубконто.ТолькоОбороты) КАК ТолькоОбороты,
	|	МАКСИМУМ(СчетаСубконто.Валютный) КАК Валютный
	|ИЗ
	|	СчетаСубконто КАК СчетаСубконто
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетаСубконто.Субконто.Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Субконто";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	ТаблицаДействий = РезультатЗапроса.Выгрузить();
	
	ВидыДействий = Новый Структура;
	ВидыДействий.Вставить("Действие", НСтр("ru='Будут удалены следующие субконто: %1';uk='Будуть вилучені наступні субконто: %1'"));
	ВидыДействий.Вставить("Количественный", НСтр("ru='Будут очищены количественные обороты по следующим субконто: %1';uk='Будуть очищені кількісні обороти за наступними субконто: %1'"));
	ВидыДействий.Вставить("Суммовой", НСтр("ru='Будут очищены суммовые обороты по следующим субконто: %1';uk='Будуть очищені сумові обороти за наступними субконто: %1'"));
	ВидыДействий.Вставить("ТолькоОбороты", НСтр("ru='Будут очищены остатки по следующим субконто: %1';uk='Будуть очищені залишки за наступними субконто: %1'"));
	ВидыДействий.Вставить("Валютный", НСтр("ru='Будут очищены валютные обороты по следующим субконто: %1';uk='Будуть очищені валютні обороти за наступними субконто: %1'"));
	
	ТекстВопроса = "";
	Для каждого ВидДействия Из ВидыДействий Цикл
		ИзменениеПризнакаСубконто = ВидДействия.Ключ <> "Действие";
		
		СписокСубконто = "";
		СтрокиСубконто = ТаблицаДействий.НайтиСтроки(Новый Структура(ВидДействия.Ключ, 1));
		Для каждого СтрокаСубконто Из СтрокиСубконто Цикл
			Если ИзменениеПризнакаСубконто И СтрокаСубконто.Действие <> 0 Тогда
				// При добавлении / удалении субконто других сообщений выводить не нужно
				Продолжить;
			КонецЕсли;
			
			СписокСубконто = СписокСубконто + ", " + СтрокаСубконто.Субконто;
		КонецЦикла;
		
		Если ПустаяСтрока(СписокСубконто) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ТекстВопроса) Тогда
			ТекстВопроса = ТекстВопроса + Символы.ПС;
		КонецЕсли;
		
		ТекстДействия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ВидДействия.Значение,
			Сред(СписокСубконто, 3));
		ТекстВопроса = ТекстВопроса + ТекстДействия;
	КонецЦикла;
	
	Если ПустаяСтрока(ТекстВопроса) Тогда
		Возврат "";
	КонецЕсли;
	
	ШаблонТекста = НСтр("ru='%1
|Продолжить?';uk='%1
|Продовжити?'");
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, ТекстВопроса);
	
	Возврат ТекстВопроса;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсходныеЗначения(Форма);

	Форма.РазделятьПоСтавкамНДСИсходноеЗначение = Форма.РазделятьПоСтавкамНДС;
	Форма.ИспользоватьОборотнуюНоменклатуруИсходноеЗначение = Форма.ИспользоватьОборотнуюНоменклатуру;
	Форма.ВестиПартионныйУчетИсходноеЗначение = Форма.ВестиПартионныйУчет;
	Форма.СкладскойУчетИсходноеЗначение = Форма.СкладскойУчет;

	Форма.ВестиРасчетыПоДокументамИсходноеЗначение = Форма.ВестиРасчетыПоДокументам;
	Форма.КассыОбособленныхПодразделенийИсходноеЗначение = Форма.КассыОбособленныхПодразделений;
	
	Форма.ВестиУчетПоРаботникамИсходноеЗначение = Форма.ВестиУчетПоРаботникам;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
		
	Форма.Элементы.ГруппаУчетОперацийВВалюте.Доступность = Форма.НаборКонстант.ИспользоватьВалютныйУчет;
	Форма.Элементы.ГруппаВедетсяРозничнаяТорговля.Доступность = Форма.НаборКонстант.ВедетсяРозничнаяТорговля;
	Форма.Элементы.ГруппаНастройкиПроизводственногоУчета.Доступность = Форма.НаборКонстант.ВедетсяПроизводственнаяДеятельность;

	Если (Форма.ИспользоватьОборотнуюНоменклатуру <> Форма.ИспользоватьОборотнуюНоменклатуруИсходноеЗначение) И Форма.ИспользоватьОборотнуюНоменклатуруИсходноеЗначение = Истина Тогда
		Форма.Элементы.ГруппаИспользоватьОборотнуюНоменклатуруПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаИспользоватьОборотнуюНоменклатуруПредупреждениеАктивно;
	Иначе
		Форма.Элементы.ГруппаИспользоватьОборотнуюНоменклатуруПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаИспользоватьОборотнуюНоменклатуруПредупреждениеОтсутствует;
	КонецЕсли;
	
	Если (Форма.РазделятьПоСтавкамНДС <> Форма.РазделятьПоСтавкамНДСИсходноеЗначение) И Форма.РазделятьПоСтавкамНДСИсходноеЗначение = Истина Тогда
		Форма.Элементы.ГруппаРазделятьПоСтавкамНДСПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаРазделятьПоСтавкамНДСПредупреждениеАктивно;
	Иначе
		Форма.Элементы.ГруппаРазделятьПоСтавкамНДСПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаРазделятьПоСтавкамНДСПредупреждениеОтсутствует;
	КонецЕсли;
	
	Если (Форма.ВестиПартионныйУчет <> Форма.ВестиПартионныйУчетИсходноеЗначение) И Форма.ВестиПартионныйУчетИсходноеЗначение = Истина Тогда
		Форма.Элементы.ГруппаВестиПартионныйУчетПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаВестиПартионныйУчетПредупреждениеАктивно;
	Иначе
		Форма.Элементы.ГруппаВестиПартионныйУчетПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаВестиПартионныйУчетПредупреждениеОтсутствует;
	КонецЕсли;
	
	Форма.Элементы.СкладскойУчет.Доступность = Форма.ВестиУчетПоСкладам;
	
	Если Форма.СкладскойУчет < Форма.СкладскойУчетИсходноеЗначение Тогда
		Форма.Элементы.ГруппаСкладскойУчетПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаСкладскойУчетПредупреждениеАктивно;
	Иначе
		Форма.Элементы.ГруппаСкладскойУчетПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаСкладскойУчетПредупреждениеОтсутствует;
	КонецЕсли;
	
	Если (Форма.ВестиРасчетыПоДокументам <> Форма.ВестиРасчетыПоДокументамИсходноеЗначение) И Форма.ВестиРасчетыПоДокументамИсходноеЗначение = Истина Тогда
		Форма.Элементы.ГруппаВестиРасчетыПоДокументамПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаВестиРасчетыПоДокументамПредупреждениеАктивно;
	Иначе
		Форма.Элементы.ГруппаВестиРасчетыПоДокументамПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаВестиРасчетыПоДокументамПредупреждениеОтсутствует;
	КонецЕсли;
	Если (Форма.КассыОбособленныхПодразделений <> Форма.КассыОбособленныхПодразделенийИсходноеЗначение) И Форма.КассыОбособленныхПодразделенийИсходноеЗначение = Истина Тогда
		Форма.Элементы.ГруппаКассыОбособленныхПодразделенийПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаКассыОбособленныхПодразделенийПредупреждениеАктивно;
	Иначе
		Форма.Элементы.ГруппаКассыОбособленныхПодразделенийПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаКассыОбособленныхПодразделенийПредупреждениеОтсутствует;
	КонецЕсли;
	
	Если (Форма.ВестиУчетПоРаботникам <> Форма.ВестиУчетПоРаботникамИсходноеЗначение) И Форма.ВестиУчетПоРаботникамИсходноеЗначение = 1 Тогда
		Форма.Элементы.ГруппаАналитическийУчетРасчетовСПерсоналомПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаАналитическийУчетРасчетовСПерсоналомПредупреждениеАктивно;
	Иначе
		Форма.Элементы.ГруппаАналитическийУчетРасчетовСПерсоналомПредупреждение.ТекущаяСтраница = Форма.Элементы.ГруппаАналитическийУчетРасчетовСПерсоналомПредупреждениеОтсутствует;
	КонецЕсли;
	
	Если Форма.УчетЗарплатыИКадровВоВнешнейПрограмме = 0 Тогда
		Форма.Элементы.СтраницыКадровыйУчет.ТекущаяСтраница = Форма.Элементы.КадровыйУчетВЭтойПрограмме;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СформироватьКадровыеДокументы", "Доступность", Форма.КадровыйУчет);
				
	Иначе
		Форма.Элементы.СтраницыКадровыйУчет.ТекущаяСтраница = Форма.Элементы.КадровыйУчетВоВнешнейПрограмме;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ИспользоватьУпрощенныйУчетНачислений", "Доступность", НЕ Форма.КадровыйУчет);	
	
	Если Форма.РасширеннаяЗиК Тогда
		Форма.Элементы.НадписьУчетЗарплатыИКадровВоВнешнейПрограмме.Видимость = Ложь;
		Форма.Элементы.ГруппаНастройкаУчетаЗарплатыИКадров.Видимость = Ложь;
		Форма.Элементы.СтраницыКадровыйУчет.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СформироватьКадровыеПриказы()
	
	УчетЗарплаты.СформироватьКадровыеПриказы();
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПартионныйУчет()
	
	
КонецПроцедуры
