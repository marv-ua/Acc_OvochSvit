﻿ 
 
#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Печать
	//УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	УстановитьДоступностьЭлементовФормы();
	
	Элементы.Утвердить.Пометка = Объект.Утвержден;
	Элементы.ГруппаДатаНомер.ЦветФона = ?(Объект.Утвержден, WebЦвета.БледноЗеленый, WebЦвета.Белый);
	
	ЗаполнитьЗначенияПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыОбработки = ПодготовитьПараметрыОбработкиТоварыНоменклатураПриИзменении(ТекущиеДанные);

	ТоварыНоменклатураПриИзмененииНаСервере(ПараметрыОбработки.ДанныеСтрокиТаблицы);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПараметрыОбработки.ДанныеСтрокиТаблицы);
КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ТоварыНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы)

	Если НЕ ДанныеСтрокиТаблицы.Свойство("Номенклатура") тогда
		Возврат;
	КонецЕсли;  
	
	Если ДанныеСтрокиТаблицы.Свойство("ЕдиницаИзмерения") тогда
		
		ДанныеСтрокиТаблицы.ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеСтрокиТаблицы.Номенклатура,"БазоваяЕдиницаИзмерения");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеСтрокиТаблицы.Номенклатура) 
		И ДанныеСтрокиТаблицы.Свойство("ДополнительныеАртикулы") Тогда
		ДанныеСтрокиТаблицы.ДополнительныеАртикулы = НайтиАртикул(ДанныеСтрокиТаблицы.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиАртикул(Номенклатура)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДополнительныеАртикулы.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ДополнительныеАртикулы КАК ДополнительныеАртикулы
	               |ГДЕ
	               |	НЕ ДополнительныеАртикулы.ПометкаУдаления
	               |	И ДополнительныеАртикулы.НаименованиеНоменклатуры = &НаименованиеНоменклатуры";
	Запрос.УстановитьПараметр("НаименованиеНоменклатуры", Номенклатура.НаименованиеПолное);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.ДополнительныеАртикулы.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	ТоварыКоличествоПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПунктыРазгрузкиПунктРазгрузкиПриИзменении(Элемент)
	ЗаполнитьКонтактнымиДанными(Элементы.ПунктыРазгрузки.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ПунктыРазгрузкиВодительПриИзменении(Элемент)
	ЗаполнитьДаннымиСотрудника(Элементы.ПунктыРазгрузки.ТекущаяСтрока);
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьПунктыРазгрузки(Команда)
	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеВопросаОбновленияТаблицыПунктыРазгрузки", ЭтотОбъект),
		НСтр("ru = 'Обновить данные в таблице из таблицы Товары?'; uk = 'Оновити дані в таблиці з таблиці Товари?'"),
		РежимДиалогаВопрос.ДаНет,
	);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗаявку(Команда)

	СтруктураПараметров = Новый Структура;
	
	ЗаголовокВыбора = НСтр("ru = 'Выберите настройку загрузки'; uk = 'Оберіть налаштування завантаження'");
	ОповещениеВыбор = Новый ОписаниеОповещения("ОкончаниеВыбораНастройкиЗагрузки", ЭтотОбъект, СтруктураПараметров);
	
	ПоказатьВводЗначения(ОповещениеВыбор,
		ПредопределенноеЗначение("Справочник.а_НастройкиЗагрузкиЗаявок.ПустаяСсылка"),
		ЗаголовокВыбора,
		Тип("СправочникСсылка.а_НастройкиЗагрузкиЗаявок")
	);
	
КонецПроцедуры 

&НаКлиенте
Процедура Обработано(Команда)
	
	ВыделенныеСтроки = Неопределено;
	ТекТЧ = "ПунктыРазгрузки";	
	ТабЧасть = "Товары";
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПунктыРазгрузки Тогда
		ТекТЧ = "ПунктыРазгрузки";
		ТабЧасть = "Товары";
		ВыделенныеСтроки = Элементы.ПунктыРазгрузки.ВыделенныеСтроки;
	Иначе
		ТекТЧ = "Товары";
		ТабЧасть = "ПунктыРазгрузки";
		ВыделенныеСтроки = Элементы.Товары.ВыделенныеСтроки;
	КонецЕсли;
	
	Если ВыделенныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого С Из ВыделенныеСтроки Цикл
		ТекДанные = Объект[ТекТЧ].НайтиПоИдентификатору(С);
		Если Не ТекДанные = Неопределено Тогда
			УстановитьОбработаноНаСервере(ТабЧасть, ТекДанные.ПунктРазгрузки, ТекДанные.ДатаОтгрузки, ТекДанные.Идентификатор, Не ТекДанные.Обработано);
			ТекДанные.Обработано = Не ТекДанные.Обработано;
		КонецЕсли;
	КонецЦикла;


КонецПроцедуры

&НаКлиенте
Процедура ПечатьЗаявкиПоВодителю(Команда)
	
	ТекДанные = Элементы.ИтогиПоВодителям.ТекущиеДанные;
	ТабДок = ПечатьЗаявкиНаСервере(ТекДанные.Водитель, ТекДанные.Авто);
	ТабДок.Показать("Заявка_"+СокрЛП(ТекДанные.Водитель));
		
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЗаказНаСборку(Команда)
	
	ВыбранныеСтроки = Элементы.ПунктыРазгрузки.ВыделенныеСтроки;
	Массив = Новый Массив;
	Для Каждого Эл Из ВыбранныеСтроки Цикл
		ТекДанные = Объект.ПунктыРазгрузки.НайтиПоИдентификатору(Эл);
		Если Не ТекДанные = Неопределено Тогда
			Массив.Добавить(ТекДанные.ПунктРазгрузки);                    
		КонецЕсли;
	КонецЦикла;
	
	Если Массив.Количество() Тогда
		ТабДок = ПечатьЗаявкуНаСборкуНаСервере(Массив);
		ТабДок.Показать("Заказ на сборку");
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявки(Команда)
	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопросаСозданиеЗаявкиЗавершение", ЭтотОбъект),
		НСтр("ru = 'Создать заявку на основании текущей с распределением по датам вывоза?'; uk = 'Створити заявку на підставі поточної з розподіленням по датах вивозу?'"),
		РежимДиалогаВопрос.ДаНет,
		,
		КодВозвратаДиалога.Да,
		,
	);
КонецПроцедуры

#КонецОбласти

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

&НаКлиенте 
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект)
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти    //СлужебныеПроцедурыИФункцииБСП

#Область СлужебныеПроцедурыИФункции

&НаКлиенте 
Процедура ПослеЗакрытияВопросаСозданиеЗаявкиЗавершение(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Успешно = Ложь;
		СоздатьЗаявкиНаСервере(Успешно);
		ПоказатьОповещениеПользователя("Завершено",,, ?(Успешно, БиблиотекаКартинок.Успешно32, БиблиотекаКартинок.Ошибка32));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоздатьЗаявкиНаСервере(Успешно)
	
	Успешно = Истина;
	
	тзРодитель = Объект.ПунктыРазгрузки.Выгрузить();
	тзРодитель.Свернуть("ДатаОтгрузки, ПунктРазгрузки");
	
	тзТовары = Объект.Товары.Выгрузить();
	Для Каждого СтрокаТовары Из тзТовары Цикл
		Если Не ЗначениеЗаполнено(СтрокаТовары.ДатаОтгрузки) Тогда
			Попытка
				СтрокаТовары.ДатаОтгрузки = тзРодитель.НайтиСтроки(Новый Структура("ПунктРазгрузки", СтрокаТовары.ПунктРазгрузки))[0].ДатаОтгрузки;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	МассивСтрок = тзТовары.НайтиСтроки(Новый Структура("ДатаОтгрузки", Дата(1,1,1)));
	Если МассивСтрок.Количество() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось однозначно определить дату вывоза товара, документы созданы не будут'; uk = 'Не вдалося однозначно визначити дату вивозу товару, документи створені не будуть'"));
		Успешно = Ложь;
		Возврат;
	КонецЕсли;
	
	тзРодитель.Свернуть("ДатаОтгрузки");
	
	Для Каждого СтрокаРодитель Из тзРодитель Цикл
		Если Не ЗначениеЗаполнено(СтрокаРодитель.ДатаОтгрузки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана дата откгрузки, по данной строке документ создан не будет'; uk = 'Не вказано рядок, за данною трокою документ створено не буде'"));
			Успешно = Ложь;
			Продолжить;
		КонецЕсли;
		
		Об = Документы.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(Об, Объект,, "Номер");
		Об.ДокументОснования = Объект.Ссылка;
		Об.Дата = СтрокаРодитель.ДатаОтгрузки;
		
		Об.Товары.Загрузить(
			тзТовары.Скопировать(
				тзТовары.НайтиСтроки(
					Новый Структура("ДатаОтгрузки", СтрокаРодитель.ДатаОтгрузки)
				)
			)
		);
		
		тз = Объект.ПунктыРазгрузки.Выгрузить();
		Об.ПунктыРазгрузки.Загрузить(
			тз.Скопировать(
				тз.НайтиСтроки(
					Новый Структура("ДатаОтгрузки", СтрокаРодитель.ДатаОтгрузки)
				)
			)
		);
		
		Попытка
			Об.Записать();
		Исключение
			Успешно = Ложь;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Не удалось записать документ %1'; uk = 'Не вдалося записати документ %1'"), СтрокаРодитель.ДатаОтгрузки));	
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПечатьЗаявкуНаСборкуНаСервере(ПукнтыРазгрузки)
	
	М = Новый Массив;
	М.Добавить(Объект.Ссылка);	
	
	Возврат Документы.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.Печать_ОтчетПоЗаявкам(
		М,
		Неопределено,
		Новый Структура("ПунктыРазгрузки", ПукнтыРазгрузки),
		"СхемаКомпоновкиДанныхЗаказНаСборку"
	);
	
КонецФункции

&НаСервере
Функция ПечатьЗаявкиНаСервере(Водитель, Авто)
	
	М = Новый Массив;
	М.Добавить(Объект.Ссылка);
	
	Возврат Документы.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.Печать_ОтчетПоЗаявкам(
		М,
		Неопределено,
		Новый Структура("Водитель,Авто", Водитель, Авто),
		""
	); 	
	
КонецФункции

&НаКлиенте
Процедура УстановитьОбработаноНаСервере(ТабЧасть, ПунктРазгрузки, ДатаОтгрузки, Идентификатор, Значение)

	Если ТабЧасть = "ПунктыРазгрузки" Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Объект[ТабЧасть].НайтиСтроки(
		Новый Структура("ПунктРазгрузки,ДатаОтгрузки,Идентификатор", ПунктРазгрузки, ДатаОтгрузки, Идентификатор)
	);
	Для Каждого Стр Из МассивСтрок Цикл
		Стр.Обработано = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВыбораНастройкиЗагрузки(Результат, СтруктураПараметров) Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров.Вставить("НастройкиЗагрузки", НастройкиИмпорта(Результат));
	
	ВыбратьФайлыДляИмпортаДанных(СтруктураПараметров);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиИмпорта(Настройка)
	
	Вернуть = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка"	, Настройка);
	Запрос.Текст = "ВЫБРАТЬ *
					|ИЗ
	               	|	Справочник.а_НастройкиЗагрузкиЗаявок КАК Спр
	               	|ГДЕ
	               	|	Спр.Ссылка = &Ссылка";
	
	тзДанные = Запрос.Выполнить().Выгрузить();
	
	Если Не тзДанные.Количество() = 0 Тогда
		
		стр0 = тзДанные[0];
		
		Для Каждого Колонка из тзДанные.Колонки Цикл
			
			Вернуть.Вставить(Колонка.Имя, стр0[Колонка.Имя]);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Вернуть;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьФайлыДляИмпортаДанных(СтруктураПараметров) Экспорт
	
	ОповещениеВыбора = Новый ОписаниеОповещения("ИмпортДанных", ЭтотОбъект, СтруктураПараметров);
	
	ПарамДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПарамДиалога.МножественныйВыбор 	= Истина;
	ПарамДиалога.Заголовок 			= НСтр("ru = 'Выберите файлы'; uk = 'Оберіть файли'");
	
	Если СтруктураПараметров.НастройкиЗагрузки.ТипФайла = ПредопределенноеЗначение("Перечисление.а_ТипыФайловЗагрузки.Excel") Тогда
		ПарамДиалога.Фильтр			 	= "EXCEL|*.xlsx;*.xls";
	Иначе
		ПарамДиалога.Фильтр			 	= "CSV|*.csv";
	КонецЕсли;
	
	НачатьПомещениеФайловНаСервер(ОповещениеВыбора,,, ПарамДиалога, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортДанных(ПомещенныеФайлы, СтруктураПараметров) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Состояние(НСтр("ru = 'Данные загружаются...'; uk = 'Триває загрузка даних...'"));
	
	ПереданныеФайлы = Новый Массив;

	Для Каждого ПомещенныйФайл из ПомещенныеФайлы Цикл
		
		Если ПомещенныйФайл.ПомещениеФайлаОтменено Тогда
			Продолжить;
		КонецЕсли;
		
		структФайла = Новый Структура("Адрес,Имя,Расширение"
							, ПомещенныйФайл.Адрес
							, ПомещенныйФайл.СсылкаНаФайл.Имя
							, ПомещенныйФайл.СсылкаНаФайл.Расширение
		);
		
		ПереданныеФайлы.Добавить(структФайла);
		
	КонецЦикла;
	
	ИмпортДанныхНаСервере(ПереданныеФайлы, СтруктураПараметров);

	
КонецПроцедуры

&НаСервере
Процедура ИмпортДанныхНаСервере(ПереданныеФайлы, СтруктураПараметров)
	
	ВыбЗначение = "";
	
	Если ПереданныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТабРезультат = Объект.Товары.Выгрузить().СкопироватьКолонки();
	
	Для Каждого текПереданныйФайл Из ПереданныеФайлы Цикл
		
		ФайлИзХранилища = ПолучитьИзВременногоХранилища(текПереданныйФайл.Адрес);
		Файл = ПолучитьИмяВременногоФайла(текПереданныйФайл.Расширение);
		ФайлИзХранилища.Записать(Файл);
		
		ТабДок = Новый ТабличныйДокумент;
		ТабДок.Прочитать(Файл);
		
		КодСтроки = 0;
		Для НомСтроки = СтруктураПараметров.НастройкиЗагрузки.ПерваяСтрока По ТабДок.ВысотаТаблицы Цикл
			Если СтруктураПараметров.НастройкиЗагрузки.КолонкаКоличество <> 0 Тогда
				// реализовать
				
			Иначе
				Если СтруктураПараметров.НастройкиЗагрузки.КолонкаПунктРазгрузки = 0 И СтруктураПараметров.НастройкиЗагрузки.СтрокаПунктРазгрузки = 0 Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не верно указаны колонки загрузки для полей количество или пункт разгрузки'; uk = 'Не вірно вказано колонки завантаження для полів кількість або пунк розвантаження'"));
					Возврат;
				КонецЕсли;
				
				Для НомКолонки = СтруктураПараметров.НастройкиЗагрузки.КолонкаПунктРазгрузки По ТабДок.ШиринаТаблицы Цикл
					//сПунктРасгрузки = Новый Соответствие;
					//сПунктРасгрузки.Вставить(Справочники.ПунктыРазгрузки.НайтиПоНаименованию(СокрЛП(ТабДок.Область(СтруктураПараметров.НастройкиЗагрузки.СтрокаПунктРазгрузки, СтруктураПараметров.НастройкиЗагрузки.КолонкаПунктРазгрузки, СтруктураПараметров.НастройкиЗагрузки.СтрокаПунктРазгрузки, СтруктураПараметров.НастройкиЗагрузки.КолонкаПунктРазгрузки).Текст))
					//);
					
					
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОбновленияТаблицыПунктыРазгрузки(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОбновитьПунктыРазгрузкиНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьПунктыРазгрузкиНаСервере()
	тзНомен = Объект.Товары.Выгрузить();
	тзНомен.Свернуть("ПунктРазгрузки,Идентификатор,ДатаОтгрузки,Обработано", "Количество");
	
	Объект.ПунктыРазгрузки.Загрузить(тзНомен);
	ЗаполнитьЗначенияПунктыРазгрузкиПоУмолчанию();
	ОбновитьИнфоПоВодителям();
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнфоПоВодителям()
	тз = Объект.ПунктыРазгрузки.Выгрузить();
	тз.Свернуть("Водитель,Авто", "Количество");
	
	ИтогиПоВодителям.Загрузить(тз);
КонецПроцедуры

&НаСервере
Процедура ТоварыКоличествоПриИзмененииНаСервере()
	
	тзНомен = Объект.Товары.Выгрузить();
	Для Каждого Эл Из Объект.ПунктыРазгрузки Цикл
		тз = тзНомен.Скопировать(
			тзНомен.НайтиСтроки(Новый Структура("ПунктРазгрузки,Идентификатор,ДатаОтгрузки", Эл.ПунктРазгрузки, Эл.Идентификатор, Эл.ДатаОтгрузки))
		);
		Эл.Количество = тз.Итог("Количество");
	КонецЦикла;
	//тзНомен.Свернуть("ПунктРазгрузки,Идентификатор,ДатаОтгрузки", "Количество");
	
	//Объект.ПунктыРазгрузки.Загрузить(тзНомен);
	
	
	ЗаполнитьЗначенияПунктыРазгрузкиПоУмолчанию();
	ЗаполнитьКонтактнымиДанными();
	ЗаполнитьДаннымиСотрудника();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтактнымиДанными(НомерСтроки = Неопределено)
	
	Если НомерСтроки = Неопределено Тогда
		Для Каждого ТекДанные Из Объект.ПунктыРазгрузки Цикл
			Если ЗначениеЗаполнено(ТекДанные.ПунктРазгрузки) Тогда
				ТекПункт = ТекДанные.ПунктРазгрузки;
				Если ЗначениеЗаполнено(ТекДанные.КонтактноеЛицо) ИЛИ ЗначениеЗаполнено(ТекДанные.КонтактныеДанные) Тогда
				Иначе
					ТекДанные.КонтактноеЛицо = ТекПункт.КонтактноеЛицо;
					ТекДанные.КонтактныеДанные = ТекПункт.КонтактныеДанные;
				КонецЕсли;
				Если ЗначениеЗаполнено(ТекДанные.Контрагент) Тогда
				Иначе
					ТекДанные.Контрагент = ТекПункт.Контрагент;
					ТекДанные.Договор = ТекПункт.ДоговорКонтрагента;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ТекДанные = Объект.ПунктыРазгрузки.НайтиПоИдентификатору(НомерСтроки);
		Если ЗначениеЗаполнено(ТекДанные.ПунктРазгрузки) Тогда
			Если ЗначениеЗаполнено(ТекДанные.КонтактноеЛицо) ИЛИ ЗначениеЗаполнено(ТекДанные.КонтактныеДанные) Тогда
			Иначе
				ТекПункт = ТекДанные.ПунктРазгрузки;
				ТекДанные.КонтактноеЛицо = ТекПункт.КонтактноеЛицо;
				ТекДанные.КонтактныеДанные = ТекПункт.КонтактныеДанные;
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекДанные.Контрагент) Тогда
			Иначе
				ТекДанные.Контрагент = ТекПункт.Контрагент;
				ТекДанные.Договор = ТекПункт.ДоговорКонтрагента;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиСотрудника(НомерСтроки = Неопределено)
	
	Если НомерСтроки = Неопределено Тогда
		Для Каждого ТекДанные Из Объект.ПунктыРазгрузки Цикл
			Если ЗначениеЗаполнено(ТекДанные.Водитель) Тогда
				Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Авто) Тогда
					Если Не ЗначениеЗаполнено(ТекДанные.Авто) Тогда
						ТекДанные.Авто = ТекДанные.Водитель.а_Авто;
					КонецЕсли;
				КонецЕсли;
				Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Прицеп) Тогда
					Если Не ЗначениеЗаполнено(ТекДанные.Прицеп) Тогда
						ТекДанные.Прицеп = ТекДанные.Водитель.а_Прицеп;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ТекДанные = Объект.ПунктыРазгрузки.НайтиПоИдентификатору(НомерСтроки);
		Если ЗначениеЗаполнено(ТекДанные.Водитель) Тогда
			Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Авто) Тогда
				ТекДанные.Авто = ТекДанные.Водитель.а_Авто;
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекДанные.Водитель.а_Прицеп) Тогда
				ТекДанные.Прицеп = ТекДанные.Водитель.а_Прицеп;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	Если РольДоступна("епрсРазрешитьРедактированиеЗагруженныхКолонокАкта") Тогда
		Элементы.ТоварыЗагруженноеКоличество.ТолькоПросмотр = Ложь;
		Элементы.ТоварыЗагруженнаяНоменклатура.ТолькоПросмотр = Ложь; 
		Элементы.ТоварыЗагруженныйДополнительныеАртикулы.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПодготовитьПараметрыОбработкиТоварыНоменклатураПриИзменении(СтрокаТабличнойЧасти)
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, ЕдиницаИзмерения, ДополнительныеАртикулы 
		|");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
		
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("ДанныеСтрокиТаблицы", 	ДанныеСтрокиТаблицы);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)

	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Загрузка из Excel недоступна в Web-клиенте.';uk='Завантаження Excel недоступне у Web-клієнті.'"));
	#Иначе
		//ERPS_TASK_В.Головченко_28.02.2023 - додано параметр "Организация"
		//ДопПараметры = Новый Структура("Контрагент, Организация",Неопределено,Объект.Организация);
		// ек убран параметр организация
		ДопПараметры = Новый Структура("Контрагент",Неопределено);
		ОбработкаЗакрытия = Новый ОписаниеОповещения("ЗаркытиеОбработки_ЗагрузкаИзВнешнегоФайла",ЭтотОбъект);
		
		ОткрытьФорму("Обработка.ерпсСозданиеАктаПриемаПередачиТовара.Форма.Форма",
					ДопПараметры,
					ЭтаФорма,,,,
					ОбработкаЗакрытия,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
		);
	#КонецЕсли	

КонецПроцедуры


&НаКлиенте
Процедура ЗаркытиеОбработки_ЗагрузкаИзВнешнегоФайла(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Товары.Количество() > 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПоказатьВопросОчиститьДалее", ЭтотОбъект, Результат),
			НСтр("ru = 'В документе уже есть данные, очистить строки?'; uk = 'В документі вже є дані, очистити рядки?'"),
			РежимДиалогаВопрос.ДаНет
		);
	Иначе
		Объект.Товары.Очистить();
		ЗагрузкаИзВнешнегоФайлаНаСервере(Результат);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросОчиститьДалее(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ЗагрузкаИзВнешнегоФайлаНаСервере(ДопПараметры);
	Иначе
		ЗагрузкаИзВнешнегоФайлаНаСервере(ДопПараметры);
	КонецЕсли;		
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаИзВнешнегоФайлаНаСервере(АдресВременногоХранилища)
	
	ТЗНоменклатур = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
		
	КодСтроки = 0;
	Для каждого ТекущаяСтрока из ТЗНоменклатур Цикл
		
		НовСтр = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр,ТекущаяСтрока);
		НовСтр.КодСтроки = КодСтроки;
		
	КонецЦикла;
	
	ОбновитьПунктыРазгрузкиНаСервере();
	
	Если Объект.Товары.Количество() Тогда
		ЗаполнитьДопДанныеТоваров();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияПунктыРазгрузкиПоУмолчанию()
	
	Для Каждого Эл Из Объект.ПунктыРазгрузки Цикл
		Если Не ЗначениеЗаполнено(Эл.Организация) Тогда
			Эл.Организация = Справочники.Организации.НайтиПоКоду("00-000004");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Эл.Склад) И ЗначениеЗаполнено(СкладПоУмолчанию) Тогда
			Эл.Склад = СкладПоУмолчанию;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Эл.Склад) Тогда
			Эл.Склад = Справочники.Склады.НайтиПоКоду("00-000024");
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Эл.Перевозчик) Тогда
			Эл.Перевозчик = Справочники.Контрагенты.НайтиПоКоду("00-000510");
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПустоеОповещение(Р,П) Экспорт
КонецПроцедуры

&НаСервере
Функция ЕстьПустыеКонтрагенты()

	Возврат Объект.ПунктыРазгрузки.НайтиСтроки(Новый Структура("Контрагент",Справочники.Контрагенты.ПустаяСсылка())).Количество() > 0;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьВопросПредупреждение(ОписаниеОповещениеПослеОшибки, ТекстСообщения) 
	ПоказатьВопрос(ОписаниеОповещениеПослеОшибки,
	                    ТекстСообщения,
						РежимДиалогаВопрос.ОК,
						,
						,
						Нстр("ru='Внимание';uk='Увага'")
		);
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокВыбораКонтрагентов()

	Результат = Новый СписокЗначений;
	
	ТЗКонтрагенты = Объект.ПунктыРазгрузки.Выгрузить();
	ТЗКонтрагенты.Свернуть("Контрагент");
	
	Для каждого ТекКонтрагент из ТЗКонтрагенты Цикл
		Результат.Добавить(ТекКонтрагент.Контрагент,ТекКонтрагент.Контрагент);	
	КонецЦикла;                                    
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПроверкаЗаполненияДокументаНеПройдена()

	Если Объект.ПунктыРазгрузки.Количество() = 0 тогда
		ОписаниеОповещениеПослеОшибки = Новый ОписаниеОповещения("ПустоеОповещение",ЭтотОбъект);
		ПоказатьВопросПредупреждение(ОписаниеОповещениеПослеОшибки,Нстр("ru='Сначала заполните таблицу пунктов разгрузки';uk='Спочатку заповніть таблицю пунктів розвантаження'"));
		Возврат Истина;
	КонецЕсли;
	
	Если ЕстьПустыеКонтрагенты() Тогда
		ОписаниеОповещениеПослеОшибки = Новый ОписаниеОповещения("ПустоеОповещение",ЭтотОбъект);
		ПоказатьВопросПредупреждение(ОписаниеОповещениеПослеОшибки, Нстр("ru='Сначала заполните контрагентов в таблице пунктов разгрузки';uk='Спочатку заповніть контрагентів в таблиці пунктів розвантаження'"));
		Возврат Истина;
	КонецЕсли;
	
	Если Объект.Товары.Количество() = 0 тогда
		ОписаниеОповещениеПослеОшибки = Новый ОписаниеОповещения("ПустоеОповещение",ЭтотОбъект);
		ПоказатьВопросПредупреждение(ОписаниеОповещениеПослеОшибки,Нстр("ru='Сначала заполните таблицу товаров';uk='Спочатку заповніть таблицю товарів'"));
		Возврат Истина;
	КонецЕсли;         
	
	Возврат Ложь;

КонецФункции


#КонецОбласти

#Область СозданиеАктов

&НаКлиенте
Процедура СоздатьАкты(Команда)
		
	Если ПроверкаЗаполненияДокументаНеПройдена() тогда
		Возврат;
	КонецЕсли;
	
	//СоздатьАктыНаСервере();
	//ек++
	СоздатьАктыНаСервереНовый();
	
КонецПроцедуры

&НаСервере
Процедура СоздатьАктыНаСервереНовый()
	
	Для каждого Пункт из ОБъект.ПунктыРазгрузки Цикл
		
		Если АктУжеСозданРаннее(Пункт.Контрагент,Пункт.ПунктРазгрузки,Объект.Ссылка) тогда
			Продолжить;
		КонецЕсли;
		
		НовДок = Документы.ерпсАктПриемкиПередачиТоваров.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовДок,Объект,,"Номер");
		
		НовДок.ЗаявкаНаСозданиеАктовПриемкиПередачи = ОБъект.Ссылка;
		НовДок.Контрагент 		= Пункт.Контрагент;
		НовДок.Договор 			= Пункт.Договор;
		НовДок.Ответственный	= Пользователи.ТекущийПользователь();
		НовДок.ПунктРазгрузки	= Пункт.ПунктРазгрузки;
		НовДок.Дата 			= ?(ЗначениеЗаполнено(Пункт.ДатаОтгрузки),Пункт.ДатаОтгрузки,ТекущаяДата()); 
		//ек++
		//НовДок.Склад			= Объект.Склад;
		НовДок.Организация		= Пункт.Организация;
		НовДок.Склад			= Пункт.Склад;
		НовДок.ПериодОтгрузки	= Объект.ПериодОтгрузки;
		
		СтрокиКПереносу = Объект.Товары.НайтиСтроки(Новый Структура("ПунктРазгрузки",Пункт.ПунктРазгрузки));
		НовДок.Товары.Загрузить(Объект.Товары.Выгрузить(СтрокиКПереносу));
		
		НовДок.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЦикла;
	
	
КонецПроцедуры


&НаСервере
Процедура СоздатьАктыНаСервере()
	Для каждого Пункт из ОБъект.ПунктыРазгрузки Цикл
		
		Если АктУжеСозданРаннее(Пункт.Контрагент,Пункт.ПунктРазгрузки,Объект.Ссылка) тогда
			Продолжить;
		КонецЕсли;
		
		НовДок = Документы.ерпсАктПриемкиПередачиТоваров.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовДок,Объект,,"Номер");
		
		НовДок.ЗаявкаНаСозданиеАктовПриемкиПередачи = ОБъект.Ссылка;
		НовДок.Контрагент 		= Пункт.Контрагент;
		НовДок.Договор 			= Пункт.Договор;
		НовДок.Ответственный	= Пользователи.ТекущийПользователь();
		НовДок.ПунктРазгрузки	= Пункт.ПунктРазгрузки;
		НовДок.Дата 			= ТекущаяДата(); 
		НовДок.Склад			= Объект.Склад;
		
		СтрокиКПереносу = Объект.Товары.НайтиСтроки(Новый Структура("ПунктРазгрузки",Пункт.ПунктРазгрузки));
		НовДок.Товары.Загрузить(Объект.Товары.Выгрузить(СтрокиКПереносу));
		
		НовДок.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЦикла;
	
	
КонецПроцедуры

Функция АктУжеСозданРаннее(Контрагент,ПунктРазгрузки,ДокументСсылка, Организация = Неопределено)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ерпсАктПриемкиПередачиТоваров.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ерпсАктПриемкиПередачиТоваров КАК ерпсАктПриемкиПередачиТоваров
		|ГДЕ
		|	НЕ ерпсАктПриемкиПередачиТоваров.ПометкаУдаления
		|	И ерпсАктПриемкиПередачиТоваров.ПунктРазгрузки = &ПунктРазгрузки
		|	И ерпсАктПриемкиПередачиТоваров.Контрагент = &Контрагент
		|	И ерпсАктПриемкиПередачиТоваров.ЗаявкаНаСозданиеАктовПриемкиПередачи = &ЗаявкаНаСозданиеАктовПриемкиПередачи";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ПунктРазгрузки", ПунктРазгрузки);
	Запрос.УстановитьПараметр("ЗаявкаНаСозданиеАктовПриемкиПередачи",ДокументСсылка);
	Если Не Организация = Неопределено Тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС + "	И ерпсАктПриемкиПередачиТоваров.Организация = &Организация";
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

&НаКлиенте
Процедура Утвердить(Команда)
	Объект.Утвержден = Не Объект.Утвержден;
	Элементы.Утвердить.Пометка = Объект.Утвержден;
	Элементы.ГруппаДатаНомер.ЦветФона = ?(Объект.Утвержден, WebЦвета.БледноЗеленый, WebЦвета.Белый);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияПоУмолчанию()
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ерпсЗаявкаНаСозданиеАктовПриемкиПередачи", 
		"ЗначенияРеквизитовПоУмолчанию",
		,
		,
		Пользователи.ТекущийПользователь()
	);
	
	Если Не Настройки = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Настройки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначенияПоУмолчаниюНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ерпсЗаявкаНаСозданиеАктовПриемкиПередачи", 
		"ЗначенияРеквизитовПоУмолчанию",
		Новый Структура("СкладПоУмолчанию", СкладПоУмолчанию),
		,
		Пользователи.ТекущийПользователь()
	);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗначенияПоУмолчанию(Команда)
	ОткрытьФорму("Документ.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.Форма.ФормаУстановкиРеквизитовПоУмолчанию",
		Новый Структура("СкладПоУмолчанию", СкладПоУмолчанию),
		ЭтаФорма, УникальныйИдентификатор,
		,
		,
		Новый ОписаниеОповещения("УстановкаРеквизитовПоУмолчаниюДалее", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);  
КонецПроцедуры

&НаКлиенте
Процедура УстановкаРеквизитовПоУмолчаниюДалее(Результат, ДопПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Результат);
	СохранитьЗначенияПоУмолчаниюНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПунктыРазгрузкиПриИзменении(Элемент)
	ОбновитьИнфоПоВодителям();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	ОбновитьИнфоПоВодителям();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ОбновитьИнфоПоВодителям();
	
	Если ЗначениеЗаполнено(Объект.ДокументОснования) Тогда
		ДокументОснованиеНадпись = СтрШаблон("Документ підстава: %1", Объект.ДокументОснования);
	КонецЕсли;
	
	Если Объект.Товары.Количество() Тогда
		ЗаполнитьДопДанныеТоваров();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНадписьНажатие(Элемент, СтандартнаяОбработка)
	ОткрытьЗначение(Объект.ДокументОснования);
КонецПроцедуры

// Test{20230830
//колокнка в которой сумма всех заказанных "Апельсинов" на дату документа и исключать основной документ
&НаСервере
Процедура ЗаполнитьДопДанныеТоваров()
	
	тз = Объект.Товары.Выгрузить();
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таб", тз);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.Текст = "ВЫБРАТЬ * 
	|ПОМЕСТИТЬ ВТТаб
	|ИЗ &Таб КАК Т
	|;
	|ВЫБРАТЬ 
	|	Т.КодСтроки,
	|	Т.Номенклатура,
	|	Т.ДополнительныеАртикулы,
	|	Т.ЕдиницаИзмерения,
	|	Т.Количество,
	|	Т.Примечание,
	|	Т.ПунктРазгрузки,
	|	Т.Идентификатор,
	|	Т.ДатаОтгрузки,
	|	Т.ЗагруженнаяНоменклатура,
	|	Т.ЗагруженноеКоличество,
	|	Т.ЗагруженныйДополнительныеАртикулы,
	|	Т.Обработано,
	|	ТТ.Кво КАК ЗаказаноВЭтотДень
	|ИЗ ВТТаб КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ (
	|	ВЫБРАТЬ
	|		ТЧ.Номенклатура,
	|		ТЧ.ДатаОтгрузки,
	|		СУММА(ТЧ.Количество) КАК Кво 
	|	ИЗ
	|		Документ.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи.Товары КАК ТЧ
	|	ГДЕ 
	|		НЕ ТЧ.Ссылка.ПометкаУдаления
	|       И ТЧ.ДатаОтгрузки = НАЧАЛОПЕРИОДА(&Период, ДЕНЬ)
	|       И НЕ ТЧ.Ссылка.ДокументОснования = НЕОПРЕДЕЛЕНО
	|	СГРУППИРОВАТЬ ПО
	|		ТЧ.Номенклатура,
	|		ТЧ.ДатаОтгрузки) КАК ТТ
	|ПО ТТ.Номенклатура = Т.Номенклатура
	|	И ТТ.ДатаОтгрузки = Т.ДатаОтгрузки";
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
// Test}
#КонецОбласти

