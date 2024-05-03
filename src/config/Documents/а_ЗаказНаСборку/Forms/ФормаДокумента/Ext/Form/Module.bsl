﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	УстановитьВидимостьЭлементовФормы();
	
	Попытка
		//ЗаблокироватьДанныеФормыДляРедактирования();
		ЗаблокироватьДокументНаСервере();
	Исключение
		ОписаниеБлокировки = ОписаниеОшибки();
		ЭтаФорма.ТолькоПросмотр = Истина;
		Элементы.Группа2.ЦветФона = WebЦвета.Красный;
	КонецПопытки;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтаФорма.ТолькоПросмотр Тогда
		ПоказатьОповещениеПользователя(
			Сред(ОписаниеБлокировки, СтрНайти(ОписаниеБлокировки, НСтр("ru = 'Объект уже заблокирован'; uk = 'Об’єкт вже заблокований'")), СтрДлина(ОписаниеБлокировки))
			,,, БиблиотекаКартинок.Внимание48, СтатусОповещенияПользователя.Важное, УникальныйИдентификатор
		);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    Элементы.Группа2.ЦветФона = ?(Объект.Собран, WebЦвета.БледноЗеленый, Элементы.Группа2.ЦветФона);
	
	Если Объект.Собран Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросВыУвереныЗавершение", ЭтотОбъект),
			НСтр("ru = 'Уже собран!
                  |Вы уверены что хотите работать с этой заявкой?'; uk = 'Уже зібрано!
                  |Ви впевнені що хочете працювати з цією заявкою?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			КодВозвратаДиалога.Нет,
			Нстр("ru = 'Уже собран!'; uk = 'Уже зібрано!'")
		);
	КонецЕсли;
	
	УстановитьДоступностьКнопкиСобран();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьТаблицуМаршрут();
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
	
	//ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьЗаголовокФормыНаСервере();
	
	ОбновитьТаблицуМаршрут();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Попытка
		РазблокироватьДокументНаСервере();
	Исключение
	КонецПопытки;
	
КонецПроцедуры


#Область СлужебныеПроцедурыИФункцииБСП

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

&НаКлиенте
Процедура РазделитьПалеты(Команда)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопросаРазделениеЗавершение", ЭтотОбъект, ТекДанные), 
		"Розділити " + ?(ЗначениеЗаполнено(ТекДанные.Номенклатура), ТекДанные.Номенклатура, ТекДанные.НоменклатураЗаявка) + " по палетах?",
		РежимДиалогаВопрос.ДаНет
	);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаРазделениеЗавершение(Результат, ДопПараметры) Экспорт
	
	НоваяСтрока = Объект.Товары.Вставить(ДопПараметры.НомерСтроки);
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДопПараметры,, "КоличествоСобрано,Собран,Палета,ДатаПалеты");
	Элементы.Товары.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	//СформироватьПалетуНаКлиенте(Элементы.Товары.ВыделенныеСтроки);

	
КонецПроцедуры

&НаКлиенте
Процедура Собран(Команда)
	
	Объект.Собран = Не Объект.Собран;
	Элементы.Группа2.ЦветФона = ?(Объект.Собран, WebЦвета.БледноЗеленый, WebЦвета.Белый);
	Модифицированность = Истина;
	
	Объект.ДатаСборки = ТекущаяДата();
	
	Попытка
		Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	УстановитьСтатусНаСервере(Объект.Собран, Объект.Идентификатор, Объект.ДокументОснование);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СобранБезИзмененияДатыСборки(Команда)
	Объект.Собран = Истина;
	Элементы.Группа2.ЦветФона = ?(Объект.Собран, WebЦвета.БледноЗеленый, WebЦвета.Белый);
	Модифицированность = Истина;
	
	Попытка
		Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	УстановитьСтатусНаСервере(Объект.Собран, Объект.Идентификатор, Объект.ДокументОснование);
	
	Закрыть();
КонецПроцедуры


&НаКлиенте
Процедура ТоварыКоличествоСобраноПриИзменении(Элемент)
	
	Элементы.Товары.ТекущиеДанные.Собран = Истина;
	
	УстановитьДоступностьКнопкиСобран();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

КонецПроцедуры

&НаКлиенте
Процедура СформироватьПалету(Команда)
	СформироватьПалетуНаКлиенте(Элементы.Товары.ВыделенныеСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЭтикеткиНаПалету(Команда)
	
	ПоказатьВводЧисла(Новый ОписаниеОповещения("ПослеВыбораНомераПалеты", ЭтотОбъект),
		1,
		"Введіть ономер палети",
		2,
		0
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБирки(Команда)
	
	ТабДок = ПечатьБиркиНаСервере();
	Если ТабДок = Неопределено Тогда
		ПоказатьПредупреждение(, "Немає декларації постачальника на цей тиждень");
		Возврат;
	КонецЕсли;
	ТабДок.Показать();
	ТабДок.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция ПечатьБиркиНаСервере()
	штПоШирине = 5;
	штПоВысоте = 3;
	
	ТабДок = Новый ТабличныйДокумент;
	//	ТабДок.АвтоМасштаб = Истина;
	ТабДок.МасштабПечати = 44;
	ТабДок.ПолеСверху = 4;
	ТабДок.ПолеСнизу = 4; 
	ТабДок.РазмерСтраницы = "A4";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ИмяПараметровПечати = "ПЕЧАТЬ_БИРКИ_"+Объект.Идентификатор; 
	
	МассивОбластей = Новый Массив;
		
	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		ТекНоменклатура = СтрокаТовары.НоменклатураЗаявка;
		Если ЗначениеЗаполнено(СтрокаТовары.Номенклатура) Тогда
			ТекНоменклатура = СтрокаТовары.Номенклатура;
		КонецЕсли;
		СтрокаДекларации = Документы.а_ДекларацияПоставщика.ПолучитьДокДеларацияТовары(Объект.Дата, Объект.Организация,, СтрокаТовары.ДополнительныеАртикулы);
		
		Если СтрокаДекларации = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("За рядком товару "+ТекНоменклатура+" не знайдено декларацію постачальника");
			Возврат Неопределено;
		Иначе
			Бирка = Документы.а_ДекларацияПоставщика.ПолучитьБиркуНаТоварНаСервере(СтрокаДекларации, СтрокаДекларации.Ссылка);
			МассивДоп = СтрокаДекларации.Ссылка.ТоварыДоп.НайтиСтроки(Новый Структура("Идентификатор", СтрокаДекларации.Идентификатор));
			КвоБирок = 1;
			Если МассивДоп.Количество() Тогда
				Кво = ?(МассивДоп[0].МассаНетто = 0, 1, МассивДоп[0].МассаНетто);
				ТекКво = ?(СтрокаТовары.Собран, СтрокаТовары.КоличествоСобрано, СтрокаТовары.Количество); 
				Если СтрокаТовары.Количество % Кво = 0 Тогда
					КвоБирок = ТекКво / Кво;
				Иначе
					КвоБирок = Цел(ТекКво / Кво) + 1;
				КонецЕсли;
			КонецЕсли;
			Бирка.ШиринаСтраницы = 61; 
			Бирка.ВысотаСтраницы = 80;
			
			Для Сч = 0 По КвоБирок Цикл
				МассивОбластей.Добавить(Бирка.Область(1,1,Бирка.ВысотаТаблицы,Бирка.ШиринаТаблицы));
			КонецЦикла;
				
			
		КонецЕсли;
		
	КонецЦикла;
	
	СчВертикальныйСдвигов = 0;
	НомерСтроки = 1;
	Для Каждого Область Из МассивОбластей Цикл
		ТабДок.ВставитьОбласть(Область,
			ТабДок.Область(НомерСтроки, 1 + СчВертикальныйСдвигов, НомерСтроки, 1 + СчВертикальныйСдвигов),
			ТипСмещенияТабличногоДокумента.ПоВертикали
		);
		
		Если НомерСтроки = штПоВысоте Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		Если СчВертикальныйСдвигов >= штПоШирине-1 Тогда
			СчВертикальныйСдвигов = 0;
			НомерСтроки = НомерСтроки + 1 + 14;
		Иначе
			
			СчВертикальныйСдвигов = СчВертикальныйСдвигов + 1;
			
		КонецЕсли;
		 
	КонецЦикла;
	
	Для Сч = 1 По ТабДок.ШиринаТаблицы Цикл
		ТабДок.Область(1, Сч).ШиринаКолонки = 61;
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

&НаКлиенте
Процедура СформироватьПалетуНаКлиенте(ВыделенныеСтроки)
	
	Если ПроверитьСтрокиДляФормированияПакета(ВыделенныеСтроки) Тогда
		НомерПалеты = УстановитьНомерПалетыНаСервере(ВыделенныеСтроки);
		ПослеВыбораНомераПалеты(НомерПалеты, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьСтрокиДляФормированияПакета(ВыделенныеСтроки)
	
	Результат = Истина;
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ТекДанные = Объект.Товары.НайтиПоИдентификатору(Строка);
		Если ЗначениеЗаполнено(ТекДанные.Палета) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("По поточному рядку палета вже назначена",, "Товары["+Строка(ТекДанные.НомерСтроки-1)+"].НоменклатураЗаявка", "Объект");
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция УстановитьНомерПалетыНаСервере(Знач ВыделенныеСтроки)
	
	НомерПалеты = 1;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Т.Палета КАК Палета
	|ПОМЕСТИТЬ ВТТаб
	|ИЗ &Таб КАК Т
	|;
	|ВЫБРАТЬ МАКСИМУМ(Т.Палета) КАК НомерПалеты
	|ИЗ ВТТаб КАК Т";
	Запрос.УстановитьПараметр("Таб", Объект.Товары.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		НомерПалеты = Выборка.НомерПалеты+1;
	КонецЕсли;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ТекДанные = Объект.Товары[Строка];
		ТекДанные.Палета = НомерПалеты;
		ТекДанные.ДатаПалеты = ТекущаяДатаСеанса();
	КонецЦикла;
	
	Возврат НомерПалеты;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьКнопкиСобран()
	
	ВсеСобраны = Истина;
	
	Для Каждого Стр Из Объект.Товары Цикл
		Если Не Стр.Собран Тогда
			ВсеСобраны = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ФормаСобран.Доступность = ВсеСобраны;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусНаСервере(Собран, Идентификатор, ДокументОснование)
	
	Об = РеквизитФормыВЗначение("Объект");
	Об.УстановитьСтатус();
	ЗначениеВРеквизитФормы(Об, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	Если Документы.а_ЗаказНаСборку.ПользовательКладовщик() Тогда
		Элементы.Организация.Видимость = Ложь;
		Элементы.Идентификатор.Видимость = Ложь;
		Элементы.Склад.ТолькоПросмотр = Истина;
		Элементы.Группа6.ТолькоПросмотр = Истина;
		Элементы.Кладовщик.ТолькоПросмотр = Истина;
		Элементы.ТоварыКоличество.ТолькоПросмотр = Истина;
		Элементы.СобранБезИзмененияДатыСборки.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормыНаСервере()
	
	Заголовок = СтрШаблон("%1", Объект.ПунктРазгрузки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьДокументНаСервере()
	
	Если объект.Ссылка.Пустая() тогда
		возврат;
	КонецЕсли;
	
	ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка,, УникальныйИдентификатор);

КонецПроцедуры


&НаСервере
Процедура РазблокироватьДокументНаСервере()

	РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ВопросВыУвереныЗавершение(Результат, ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Закрыть();

КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуМаршрут()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	а_ДатаВывозаФакт1.Идентификатор КАК Идентификатор,
	               |	а_ДатаВывозаФакт1.Объект КАК Объект,
	               |	а_ДатаВывозаФакт.ДатаОтгрузки КАК ДатаОтгрузки,
	               |	а_ДатаВывозаФакт.Водитель КАК Водитель,
	               |	а_ДатаВывозаФакт.Авто КАК Авто
	               |ПОМЕСТИТЬ ВТИдентификаторы
	               |ИЗ
	               |	РегистрСведений.а_ДатаВывозаФакт КАК а_ДатаВывозаФакт
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.а_ДатаВывозаФакт КАК а_ДатаВывозаФакт1
	               |		ПО а_ДатаВывозаФакт.Водитель = а_ДатаВывозаФакт1.Водитель
	               |			И а_ДатаВывозаФакт.Авто = а_ДатаВывозаФакт1.Авто
	               |			И а_ДатаВывозаФакт.ДатаОтгрузки = а_ДатаВывозаФакт1.ДатаОтгрузки
	               |ГДЕ
	               |	а_ДатаВывозаФакт.ДатаОтгрузки = &ДатаОтгрузки
	               |	И а_ДатаВывозаФакт.Идентификатор = &Идентификатор
	               |	И а_ДатаВывозаФакт.Объект = &Заявка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(ВЫБОР
	               |			КОГДА а_ЗаказНаСборкуТовары.Собран
	               |				ТОГДА а_ЗаказНаСборкуТовары.КоличествоСобрано
	               |			ИНАЧЕ а_ЗаказНаСборкуТовары.Количество
	               |		КОНЕЦ) КАК Вес,
	               |	ВТИдентификаторы.Водитель КАК Водитель,
	               |	ВТИдентификаторы.Авто КАК Авто,
	               |	а_ЗаказНаСборкуТовары.Ссылка КАК Ссылка,
	               |	ВЫБОР
	               |		КОГДА а_ЗаказНаСборкуТовары.Ссылка = &Ссылка
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК Текущий,
	               |	а_ЗаказНаСборкуТовары.Ссылка.ПунктРазгрузки КАК ПунктРазгрузки
	               |ИЗ
	               |	Документ.а_ЗаказНаСборку.Товары КАК а_ЗаказНаСборкуТовары
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТИдентификаторы КАК ВТИдентификаторы
	               |		ПО а_ЗаказНаСборкуТовары.Ссылка.Идентификатор = ВТИдентификаторы.Идентификатор
	               |			И а_ЗаказНаСборкуТовары.Ссылка.ДокументОснование = ВТИдентификаторы.Объект
	               |			И (НАЧАЛОПЕРИОДА(а_ЗаказНаСборкуТовары.Ссылка.Дата, ДЕНЬ) = ВТИдентификаторы.ДатаОтгрузки)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТИдентификаторы.Водитель,
	               |	ВТИдентификаторы.Авто,
	               |	а_ЗаказНаСборкуТовары.Ссылка,
	               |	ВЫБОР
	               |		КОГДА а_ЗаказНаСборкуТовары.Ссылка = &Ссылка
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ,
	               |	а_ЗаказНаСборкуТовары.Ссылка.ПунктРазгрузки";
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ДатаОтгрузки", Объект.Дата);
	Запрос.УстановитьПараметр("Идентификатор", Объект.Идентификатор);
	Запрос.УстановитьПараметр("Заявка", Объект.ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Макет = Документы.а_ЗаказНаСборку.ПолучитьМакет("МакетМаршрут");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьТек = Макет.ПолучитьОбласть("СтрокаТекущее");
	ОбластьИтог = Макет.ПолучитьОбласть("Итого"); 
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	
	ОбластьШапка.Параметры.Водитель = Выборка.Водитель;
	ОбластьШапка.Параметры.Авто = Выборка.Авто;
	
	ИтогоКво = 0; ВывестиШапку = Истина; 
	Пока Выборка.Следующий() Цикл
		Если ВывестиШапку Тогда
			ОбластьШапка.Параметры.Водитель = Выборка.Водитель;
			ОбластьШапка.Параметры.Авто = Выборка.Авто;
			Маршрут.Вывести(ОбластьШапка);
			ВывестиШапку = Ложь;
		КонецЕсли;

		Если Выборка.Текущий Тогда
			ОбластьТек.Параметры.Заполнить(Выборка);
			Маршрут.Вывести(ОбластьТек);
		Иначе
			ОбластьСтрока.Параметры.Заполнить(Выборка);
			Маршрут.Вывести(ОбластьСтрока);
		КонецЕсли;
		ИтогоКво = ИтогоКво + ?(ЗначениеЗаполнено(Выборка.Вес), Выборка.Вес, 0);
	КонецЦикла;
	ОбластьИтог.Параметры.Вес = ИтогоКво;
	Маршрут.Вывести(ОбластьИтог);
 	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНомераПалеты(Результат, ДопПараметры) Экспорт
	
	НомераПалет = ПолучитьНомераПалетНаСервере();
	
	Если Результат = 0 ИЛИ НомераПалет.Найти(Результат) = Неопределено Тогда
		ПоказатьПредупреждение(, "Не можна обирати пустий номер палети або такий якого нема в документі");
		Возврат;
	КонецЕсли;
	
	ТабДок = ПечатьЭтикеткиНаПалетуНаСервере(Результат);
	ТабДок.Показать();
	
КонецПроцедуры

&НаСервере
Функция ПечатьЭтикеткиНаПалетуНаСервере(Результат)
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.РазмерСтраницы = Неопределено;
	ТабДок.ШиринаСтраницы = 100;
	ТабДок.ВысотаСтраницы = 70;
	
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ИмяПараметровПечати = "ПЕЧАТЬ_ЭТИКЕТКИ_НА_ПАЛЕТУ"; 
	
	Макет = Документы.а_ЗаказНаСборку.ПолучитьМакет("МакетЭтикеткаПалета");
	Область = Макет.ПолучитьОбласть("ОбластьПечати");
	
	#Область Подключение_Печати_QR
	ПечатьQRДоступна = Ложь;
	ГенераторQRКода = Неопределено;
	ТекстОшибки = НСтр("ru='Не удалось подключить внешнюю компоненту для генерации QR-кода';uk='Не вдалося підключити зовнішній компонент для генерації QR-коду'");
	Попытка
		Если ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПечатиQRКода", "QR") Тогда
			ГенераторQRКода = Новый("AddIn.QR.QRCodeExtension");
			ПечатьQRДоступна = Истина;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , , );
		КонецЕсли;
	Исключение
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки, , , ,);
	КонецПопытки;
	#КонецОбласти
	
	СтрокаКод = СтрШаблон("%1;%2;%3;%4",
		Объект.Дата,
		Объект.Номер,
		Объект.Идентификатор,
		Результат
	);
	
	Если ПечатьQRДоступна Тогда
		РисунокДвоичный = ГенераторQRКода.GenerateQRCode(СтрокаКод, 0, 300);
		Область.Рисунки.Код.Картинка = Новый Картинка(РисунокДвоичный);
	КонецЕсли;
	
	Область.Параметры.Организация = Объект.Организация.Наименование;
	//Область.Параметры.Контрагент = Документы.а_ЗаказНаСборку.ПолучитьКонтрагента(Объект.ДокументОснование, Объект.Идентификатор);
	Область.Параметры.ПунктРазгрузки = Объект.ПунктРазгрузки;
	//Область.Параметры.Склад = Объект.Склад;
	Область.Параметры.Кладовщик = Объект.Кладовщик;
	Область.Параметры.ДатаСборки = Объект.Товары.Выгрузить(Новый Структура("Палета", Результат))[0].ДатаПалеты;
	//Область.Параметры.КоличествоСобрано = Объект.Товары.Выгрузить(Новый Структура("Палета", Результат)).Итог("КоличествоСобрано");
	
	ТабДок.Вывести(Область);
	
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Функция ПолучитьНомераПалетНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таб", Объект.Товары.Выгрузить());
	Запрос.Текст = "ВЫБРАТЬ
	               |	Т.Палета КАК Палета
	               |ПОМЕСТИТЬ ВТТаб
	               |ИЗ
	               |	&Таб КАК Т
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	Т.Палета КАК Палета
	               |ИЗ
	               |	ВТТаб КАК Т
	               |ГДЕ
	               |	Т.Палета <> 0";

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Палета");	
	
КонецФункции



#КонецОбласти




