﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	КодФормы = "ЗагрузкаАктовПриемаПередачи";
	
	Объект.Дата = ТекущаяДатаСеанса();
	
	Если Параметры.Свойство("Контрагент") тогда
		Объект.Контрагент = Параметры.Контрагент;     
	КонецЕсли;
	//ERPS_TASK_В.Головченко_28.02.2023
	Если Параметры.Свойство("Организация") тогда
		ЭтоФОП = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Организация,"ЮридическоеФизическоеЛицо") = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;     
	КонецЕсли;    
	//...ERPS_TASK_В.Головченко_28.02.2023
	Если Параметры.Свойство("БлокироватьИзменениеОтбораПоКонтрагенту") Тогда 
		Если Параметры.БлокироватьИзменениеОтбораПоКонтрагенту тогда
			Элементы.Контрагент.ТолькоПросмотр = Параметры.БлокироватьИзменениеОтбораПоКонтрагенту;
		КонецЕсли;
	КонецЕсли;
		
	ЗаполнитьСлужебныеКолонки();
	
	ИнициализироватьТабличныйДокумент();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКолонки(ВыбранноеЗначение)

	ВыбранныеМестаДоставки.Очистить();
	
	ТЗ = ПолучитьИзВременногоХранилища(ВыбранноеЗначение);
	Для Каждого СтрокаТЧ Из ТЗ Цикл
		НовСтр = ВыбранныеМестаДоставки.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр,СтрокаТЧ);
		НовСтр.ИмяКолонки = "ДопКол"+СтрЗаменить(Новый УникальныйИдентификатор(),"-","");
		НовСтр.Наименование = НовСтр.Наименование + " ("+Формат(НовСтр.ДатаОтгрузки,"ДФ=dd.MM.yyyy")+")";
	КонецЦикла;
	
	ЗаполнитьСлужебныеКолонки();
	
	Если ЗагрузкаСФайла Тогда
		ИнициализироватьТабличныйДокумент1();
	Иначе
		ИнициализироватьТабличныйДокумент();
	КонецЕсли;
	ерпсАктПриемкиПередачиСервер.ПостроитьДеревоКоличеств(ЭтаФорма);
	
	ЗагрузкаСФайла = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеКолонки()
	
	НомерКолонки = 3;
	Для Каждого СтрокаТЧ Из ВыбранныеМестаДоставки Цикл
		
		СтрокаТЧ.НаименованиеПоиск = ВРег(СтрЗаменить(СтрокаТЧ.Наименование, " ", ""));
		Если СтрокаТЧ.Выбрана Тогда
			СтрокаТЧ.ИмяКолонкиMXL = НомерКолонки;
			НомерКолонки = НомерКолонки + 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьТабличныйДокумент1()
	
	Т = ПолучитьИзВременногоХранилища(АдресЗагруженныхДанных);
	
	Макет = Обработки.ерпсСозданиеАктаПриемаПередачиТовара.ПолучитьМакет("ЗагрузкаАктов1");
	
	ТабличныйДокумент.Очистить();
	
	ОбластьТовар = Макет.ПолучитьОбласть("Шапка|Товар");
	ТабличныйДокумент.Вывести(ОбластьТовар);
	
	ОбластьТовар = Макет.ПолучитьОбласть("Строка|Товар");
	ОбластьМесто = Макет.ПолучитьОбласть("Строка|МестаДоставки");
	ОбластьПустая = Макет.ПолучитьОбласть("Пустая|МестаДоставки");
	ТекПункты = Новый Массив;
	
	Для Каждого СтрокаТЧ Из ВыбранныеМестаДоставки Цикл
		Если Не СтрокаТЧ.Выбрана Тогда
			Продолжить;
		КонецЕсли;
		ОбластьМестаДоставки = Макет.ПолучитьОбласть("Шапка|МестаДоставки");
		ОбластьМестаДоставки.Параметры.МестоДоставки = СтрокаТЧ.Наименование;
		ТабличныйДокумент.Присоединить(ОбластьМестаДоставки);
		
		ТекПункты.Добавить(СтрокаТЧ.Ссылка);
	КонецЦикла;
	
	ТабличныйДокумент.ФиксацияСверху = 1;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таб", Т);
	Запрос.УстановитьПараметр("Пункты", ТекПункты);
	Запрос.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ ВТТаб ИЗ &Таб КАК Т
	|;
	|ВЫБРАТЬ * ИЗ ВТТаб КАК Т
	|ГДЕ Т.ПунктРазгрузки В (&Пункты)";
	
	ТекТовары = Запрос.Выполнить().Выгрузить();
	
	//
	НомерПункта = 0;
	Для Каждого СтрокаТЧ Из ВыбранныеМестаДоставки Цикл
		Если Не СтрокаТЧ.Выбрана Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСтрок = ТекТовары.НайтиСтроки(
			Новый Структура("ПунктРазгрузки,ИДЗаявкиКлиента"
				, СтрокаТЧ.Ссылка
				, СтрокаТЧ.ИДЗаявкиКлиента)
		);
		
		Для Каждого Эл Из МассивСтрок Цикл
			
			ОбластьТовар.Параметры.Заполнить(Эл);
			ТабличныйДокумент.Вывести(ОбластьТовар);
			
			Для Сч = 1 По НомерПункта Цикл
				ТабличныйДокумент.Присоединить(ОбластьПустая);
			КонецЦикла;
			
			ОбластьМесто.Параметры.Количество = Эл.ЗагруженноеКоличество;
			ТабличныйДокумент.Присоединить(ОбластьМесто);
		КонецЦикла;
		
		НомерПункта = НомерПункта + 1;		
		
	КонецЦикла;
	
	//Для Каждого СтрокаТовары Из ТекТовары Цикл
	//	
	//	НомерПункта = 0;
	//	Для Каждого СтрокаТЧ Из ВыбранныеМестаДоставки Цикл
	//		Если Не СтрокаТЧ.Выбрана Тогда
	//			Продолжить;
	//		КонецЕсли;

	//		МассивСтрок = ТекТовары.НайтиСтроки(
	//			Новый Структура("ПунктРазгрузки,ЗагруженнаяНоменклатура,ЗагруженныйДополнительныеАртикулы,ИДЗаявкиКлиента"
	//				, СтрокаТЧ.Ссылка
	//				, СтрокаТовары.ЗагруженнаяНоменклатура
	//				, СтрокаТовары.ЗагруженныйДополнительныеАртикулы
	//				, СтрокаТЧ.ИДЗаявкиКлиента)
	//		);
	//		
	//		Для Каждого Эл Из МассивСтрок Цикл
	//			
	//			ОбластьТовар.Параметры.Заполнить(СтрокаТовары);
	//			ТабличныйДокумент.Вывести(ОбластьТовар);
	//			
	//			Для Сч = 1 По НомерПункта Цикл
	//				ТабличныйДокумент.Присоединить(ОбластьПустая);
	//			КонецЦикла;
	//			
	//			ОбластьМесто.Параметры.Количество = Эл.ЗагруженноеКоличество;
	//			ТабличныйДокумент.Присоединить(ОбластьМесто);
	//		КонецЦикла;
	//		
	//		НомерПункта = НомерПункта + 1;
	//	
	//	КонецЦикла;	
	//КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьТабличныйДокумент()
	
	Макет = Обработки.ерпсСозданиеАктаПриемаПередачиТовара.ПолучитьМакет("ЗагрузкаАктов");
	
	ТабличныйДокумент.Очистить();
	
	ОбластьТовар = Макет.ПолучитьОбласть("Товар");
	ТабличныйДокумент.Присоединить(ОбластьТовар);
	
	Для Каждого СтрокаТЧ Из ВыбранныеМестаДоставки Цикл
		Если Не СтрокаТЧ.Выбрана Тогда
			Продолжить;
		КонецЕсли;
		ОбластьМестаДоставки = Макет.ПолучитьОбласть("МестаДоставки");
		ОбластьМестаДоставки.Параметры.МестоДоставки = СтрокаТЧ.Наименование;
		ТабличныйДокумент.Присоединить(ОбластьМестаДоставки);
	КонецЦикла;
	
	ТабличныйДокумент.ФиксацияСверху = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМестоДоставки(Команда)
	
	ПараметрыОткрытия = Новый Структура("Контрагент,МестаДоставки", Объект.Контрагент, ПолучитьМассивВыбранныхМестДоставки());
	
	ОткрытьФорму(
		"Обработка.ерпсСозданиеАктаПриемаПередачиТовара.Форма.ФормаВыбораМестДоставки",
		ПараметрыОткрытия,
		ЭтаФорма);
	
КонецПроцедуры
	
&НаСервере
Функция ПолучитьМассивВыбранныхМестДоставки()
	Возврат ВыбранныеМестаДоставки.Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбновитьКолонки(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	ОткрытьСправкуФормы();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	Если Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг1 Тогда
		
		Попытка

			ЗаполненаНоменклатураАртикул = ЗначениеЗаполнено(ТабличныйДокумент.Область("R2C1").Текст)//Артикул
				                           Или ЗначениеЗаполнено(ТабличныйДокумент.Область("R2C2").Текст)//Номенклатура
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если Не ЗаполненаНоменклатураАртикул Тогда
			ПоказатьПредупреждение(Неопределено, НСтр("ru='Необходимо скопировать колонки в таблицу из внешнего файла.';uk='Необхідно скопіювати колонки у таблицю із зовнішнього файлу.'"));
			Возврат;
		КонецЕсли;
		
		ОчиститьСообщения();
		Состояние(НСтр("ru='Осуществляется сопоставление введенных данных
						|с данными информационной базы. Пожалуйста подождите...'
						|;uk='Здійснюється співставлення введених даних
						|з даними інформаційної бази. Будь ласка, зачекайте...'"),,,БиблиотекаКартинок.Информация32);
		
		СопоставитьДанныеТабличногоДокументаСНоменклатурой();
		
		Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг2;
		
	ИначеЕсли Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг2 Тогда
		
		
		АдресТабличныйЧасти = ПолучитьВременноеХранилищеТЧ();
		Закрыть(АдресТабличныйЧасти);
	//	ОчиститьСообщения();
	//
	//	Если ПроверитьЗаполнение() Тогда
	//		Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг3;
	//	КонецЕсли;
		
	КонецЕсли;
	
	УстановитьТекущуюСтраницуПанелиНавигации();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДеревоКоличествКоличествоПриИзменении(Элемент)
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьТекущуюСтраницуПанелиНавигации()
	
	Если Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг1 Тогда
		Элементы.Навигация.ТекущаяСтраница = Элементы.НавигацияНачало;
		Элементы.НачалоДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг2 Тогда
		Элементы.Навигация.ТекущаяСтраница = Элементы.НавигацияОкончание;
		Элементы.ОкончаниеГотово.КнопкаПоУмолчанию = Истина;
	//Иначе
	//	Элементы.Навигация.ТекущаяСтраница = Элементы.НавигацияПродолжение;
	//	Элементы.ПродолжениеДалее.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг2 Тогда
		
		Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг1;
		
	ИначеЕсли Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг3 Тогда
		
		Элементы.Шаги.ТекущаяСтраница = Элементы.Шаг2;
		
	КонецЕсли;
	
	УстановитьТекущуюСтраницуПанелиНавигации();
	
КонецПроцедуры

&НаСервере
Процедура СопоставитьДанныеТабличногоДокументаСНоменклатурой()

	ДеревоКоличеств.Очистить();
		
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДополнительныеАртикулы.Наименование КАК АртикулПоиск,
	                      |	ДополнительныеАртикулы.Ссылка КАК Артикул,
	                      |	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
	                      |	ДополнительныеАртикулы.НаименованиеНоменклатуры КАК НаименованиеПоиск
	                      |ИЗ
	                      |	Справочник.ДополнительныеАртикулы КАК ДополнительныеАртикулы
	                      |ГДЕ
	                      |	НЕ ДополнительныеАртикулы.ПометкаУдаления");
	 
	
	ТЗНоменклатур.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Для Каждого ТекСтрока Из ТЗНоменклатур Цикл
		
		ТекСтрока.АртикулПоиск = ВРег(СтрЗаменить(ТекСтрока.Артикул, " ", ""));
		ТекСтрока.НаименованиеПоиск = ВРег(СтрЗаменить(ТекСтрока.НаименованиеПоиск, " ", ""));
		
	КонецЦикла;
	
	// Сопоставление данных с данными информационной базы
	
	КолонкаАртикул 				= "C1";
	КолонкаНоменклатура		 	= "C2";
	НомерСтроки = 2;
	СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
	
	ЗаполненаНоменклатураАртикул = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаАртикул).Текст)
	                               Или ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаНоменклатура).Текст);

	// Test{20230824
	// меняем принцип работы: перебираем все строки табдока, пустые пропускаем
	//Пока ЗаполненаНоменклатураАртикул Цикл
	Для НомерСтроки = 2 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Попытка
			ЗаполненаНоменклатураАртикул = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаАртикул).Текст)
                               Или ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаНоменклатура).Текст);					   
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если Не ЗаполненаНоменклатураАртикул Тогда
			Продолжить;
		КонецЕсли;
		
		СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
	// Test}
		
		НоваяСтрока = ДеревоКоличеств.Добавить();
		
		Попытка
			// 150 - Длина наименования номенклатуры;
			НоваяСтрока.АртикулПоиск = ТабличныйДокумент.Область("R" + СтроковыйНомер + КолонкаАртикул).Текст;
			НоваяСтрока.НаименованиеПоиск = Лев(ТабличныйДокумент.Область("R" + СтроковыйНомер + КолонкаНоменклатура).Текст, 150);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Для Каждого СтрокаТЧ Из ЭтотОбъект.ВыбранныеМестаДоставки Цикл
			КоличествоНоменклатуры = ТабличныйДокумент.Область("R" + СтроковыйНомер + "C" + СтрокаТЧ.ИмяКолонкиMXL).Текст;
			НоваяСтрока[СтрокаТЧ.ИмяКолонки] = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(КоличествоНоменклатуры);
		КонецЦикла;
		
		МассивНоменклатуры = Новый Массив();

		Если  ЗначениеЗаполнено(НоваяСтрока.АртикулПоиск)                     
			И ЗначениеЗаполнено(НоваяСтрока.НаименованиеПоиск) тогда
			
			НайденныеСтроки = ТЗНоменклатур.НайтиСтроки(
				Новый Структура(
					"АртикулПоиск, НаименованиеПоиск",
					ВРег(СтрЗаменить(НоваяСтрока.АртикулПоиск, " ", "")),
					ВРег(СтрЗаменить(НоваяСтрока.НаименованиеПоиск, " ", ""))
					)
			);
			
			// Test{20230824
			// если ничего не найдено то пробуем убрать 1 из начала номенклатуры
			Если НайденныеСтроки.Количество() = 0 И Лев(ВРег(СтрЗаменить(НоваяСтрока.НаименованиеПоиск, " ", "")), 1) = "1" Тогда
				НайденныеСтроки = ТЗНоменклатур.НайтиСтроки(
					Новый Структура(
						"АртикулПоиск, НаименованиеПоиск",
						ВРег(СтрЗаменить(НоваяСтрока.АртикулПоиск, " ", "")),
						ВРег(Сред(СтрЗаменить(НоваяСтрока.НаименованиеПоиск, " ", ""), 2))
						)
				);
			КонецЕсли;
			// Test}			
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				МассивНоменклатуры.Добавить(НайденнаяСтрока);
			КонецЦикла;
			
			Если МассивНоменклатуры.Количество() = 0 тогда
				НайденныеСтроки = ТЗНоменклатур.НайтиСтроки(
					Новый Структура(
						"АртикулПоиск",
						ВРег(СтрЗаменить(НоваяСтрока.АртикулПоиск, " ", ""))
						)
					);
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					МассивНоменклатуры.Добавить(НайденнаяСтрока);
				КонецЦикла;	
			КонецЕсли;
			
		ИначеЕсли  ЗначениеЗаполнено(НоваяСтрока.АртикулПоиск)
			И НЕ ЗначениеЗаполнено(НоваяСтрока.НаименованиеПоиск) тогда
			
			НайденныеСтроки = ТЗНоменклатур.НайтиСтроки(
				Новый Структура(
					"АртикулПоиск",
					ВРег(СтрЗаменить(НоваяСтрока.АртикулПоиск, " ", ""))
					)
			);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				МассивНоменклатуры.Добавить(НайденнаяСтрока);
			КонецЦикла;
			
		ИначеЕсли ЗначениеЗаполнено(НоваяСтрока.НаименованиеПоиск)
			И НЕ ЗначениеЗаполнено(НоваяСтрока.АртикулПоиск) тогда
			
			НайденныеСтроки = ТЗНоменклатур.НайтиСтроки(
				Новый Структура(
					"НаименованиеПоиск",
					ВРег(СтрЗаменить(НоваяСтрока.НаименованиеПоиск, " ", ""))
					)
			);
			// Test{20230824
			// если ничего не найдено то пробуем убрать 1 из начала номенклатуры
			Если НайденныеСтроки.Количество() = 0 И Лев(ВРег(СтрЗаменить(НоваяСтрока.НаименованиеПоиск, " ", "")), 1) = "1" Тогда
				НайденныеСтроки = ТЗНоменклатур.НайтиСтроки(
					Новый Структура(
						"НаименованиеПоиск",
						ВРег(Сред(СтрЗаменить(НоваяСтрока.НаименованиеПоиск, " ", ""), 2))
						)
				);
			КонецЕсли;
			// Test}
			// Test{20230830
			// кейс: 1002, Баклажани свіжі сезонні, кг
			Если НайденныеСтроки.Количество() = 0 И СтрНайти(НоваяСтрока.НаименованиеПоиск, ", ") > 0 Тогда
				МассивСтроки = СтрРазделить(НоваяСтрока.НаименованиеПоиск, ",", Ложь);
				
				НайденныеСтроки = ТЗНоменклатур.НайтиСтроки(
					Новый Структура(
						"АртикулПоиск, НаименованиеПоиск",
						ВРег(СтрЗаменить(СокрЛП(МассивСтроки[0]), " ", "")),
						ВРег(СтрЗаменить(СокрЛП(МассивСтроки[1]), " ", ""))
						)
				);
				
			КонецЕсли;			
			// Test}
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				МассивНоменклатуры.Добавить(НайденнаяСтрока);
			КонецЦикла;
						
		КонецЕсли;
	
				
		Если МассивНоменклатуры.Количество() = 1 Тогда
			
			НоваяСтрока.КоличествоНоменклатурыДляВыбора = 1;
			
			а_Номенклатура = МассивНоменклатуры[0].Артикул.Номенклатура;
			Если ЗначениеЗаполнено(а_Номенклатура) Тогда
				НоваяСтрока.Номенклатура = а_Номенклатура;
			Иначе
				НоваяСтрока.Номенклатура = ПолучитьНоменклатуруИзПоследнегоРТУ(МассивНоменклатуры[0].Артикул);
			КонецЕсли;
			НоваяСтрока.НоменклатураСопоставленаАвтоматически = Истина;
			НоваяСтрока.Артикул		=  МассивНоменклатуры[0].Артикул;
			
			
			Если НоваяСтрока.АртикулПоиск <> МассивНоменклатуры[0].АртикулПоиск Тогда
				НоваяСтрока.АртикулОтличается = НЕ ПустаяСтрока(НоваяСтрока.АртикулПоиск);
			КонецЕсли;
			
			// Администратор{20240625 dev-35
			Если Не ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
				НоваяСтрока.Номенклатура = Справочники.ДополнительныеАртикулы.НайтиНоменклатуруПоАртикулу(МассивНоменклатуры[0].Артикул);
			КонецЕсли;
			// Администратор}
			
		КонецЕсли;
		
		Если НоваяСтрока.НоменклатураСопоставленаАвтоматически
			И Не НоваяСтрока.НоменклатураНаименованиеОтличается
			И НЕ НоваяСтрока.АртикулОтличается Тогда
			 			  
			НоваяСтрока.СтрокаСопоставлена = Истина;
		Иначе
			НоваяСтрока.СтрокаСопоставлена = Ложь;
		КонецЕсли;
		
		// Test{20230824
		//НомерСтроки = НомерСтроки + 1;
		//СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
		//	
		//Попытка
		//	ЗаполненаНоменклатураАртикул = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаАртикул).Текст)
		//	                         Или ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаНоменклатура).Текст);
		//Исключение
		//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		//КонецПопытки;
		// Test}
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьНоменклатуруИзПоследнегоРТУ(ДополнительныйАртикул)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
		|	МАКСИМУМ(РеализацияТоваровУслугТовары.Ссылка.Дата) КАК Дата
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|ГДЕ
		|	РеализацияТоваровУслугТовары.ДополнительныйАртикул = &ДополнительныйАртикул
		|	И НЕ РеализацияТоваровУслугТовары.Ссылка.ПометкаУдаления
		//ERPS_TASK_В.Головченко_28.02.2023
		|	И РеализацияТоваровУслугТовары.Номенклатура В ИЕРАРХИИ(&ПапкаНоменклатуры)
		//...ERPS_TASK_В.Головченко_28.02.2023
		|
		|СГРУППИРОВАТЬ ПО
		|	РеализацияТоваровУслугТовары.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";
	//ERPS_TASK_В.Головченко_28.02.2023
	Если ЭтоФОП ТОгда
		ТекПапкаНоменклатуры = Константы.ерпсПапкаТоваровФОП.Получить();	
	Иначе
		ТекПапкаНоменклатуры = Константы.ерпсПапкаТоваровТОВ.Получить();
	КонецЕсли;
	Запрос.УстановитьПараметр("ПапкаНоменклатуры",ТекПапкаНоменклатуры);
	//...ERPS_TASK_В.Головченко_28.02.2023
	
	Запрос.УстановитьПараметр("ДополнительныйАртикул", ДополнительныйАртикул);
	
	РезультатЗапроса = Запрос.Выполнить();              
	
	Если РезультатЗапроса.Пустой() тогда
		// sklad{20231107
		Если СтрНайти(СтрокаСоединенияИнформационнойБазы(), "Ref=""sklad""") > 0 Тогда
			Спр = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", СокрЛП(ДополнительныйАртикул));
			Если ЗначениеЗаполнено(Спр) Тогда
				Возврат Спр;
			КонецЕсли;
		КонецЕсли;
		// sklad}	
		
		
		Возврат справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.Номенклатура;
	
КонецФункции


&НаКлиенте
Процедура ВариантОтображенияНоменклатурыПриИзменении(Элемент)
	
	УстановитьОтборПоТоварам();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоТоварам()
	
	Элементы.ДеревоКоличеств.ОтборСтрок = Неопределено;
	
	Если ВариантОтображенияНоменклатуры = 1 Тогда
		Элементы.ДеревоКоличеств.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаСопоставлена", Ложь);
	Иначе
		Элементы.ДеревоКоличеств.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКоличествНоменклатураПриИзменении(Элемент)                          
	
	ТекущаяСтрока = Элементы.ДеревоКоличеств.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока.СтрокаСопоставлена = ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура);  
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВременноеХранилищеТЧ()
	
	Объект.ТоварыКПереносу.Очистить();
	
	ПустаяНоменклатура  = Справочники.Номенклатура.ПустаяСсылка();
	ПустойАртикул		= Справочники.ДополнительныеАртикулы.ПустаяСсылка();
	
	Для Каждого СтрокаТЧ Из ДеревоКоличеств Цикл
		
		Для Каждого АдресДоставки Из ВыбранныеМестаДоставки Цикл
			
			Количество = СтрокаТЧ[АдресДоставки.ИмяКолонки];
			
			// Test{20230822
			// не сопоставленные не пропускаем а также грузим в заявку
			//Если Количество = 0 
			//	или СтрокаТЧ.Номенклатура = ПустаяНоменклатура Тогда
			//	//или СтрокаТЧ.Артикул = ПустойАртикул Тогда
			//	
			//	Продолжить;
			//	
			//КонецЕсли;
			
			// если нет количесвтва - пропускаем. Зачем строка с 0 количеством по пункту разгрузки?
			Если Не ЗначениеЗаполнено(Количество) Тогда
				Продолжить;
			КонецЕсли;
			// Test}
				
			НоваяСтрока = Объект.ТоварыКПереносу.Добавить();
            НоваяСтрока.Номенклатура 			= СтрокаТЧ.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения 		= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.Номенклатура,"БазоваяЕдиницаИзмерения");
			НоваяСтрока.Примечание				= "";
			НоваяСтрока.ДополнительныеАртикулы 	= СтрокаТЧ.Артикул;
			НоваяСтрока.Количество 				= Количество;
			НоваяСтрока.ПунктРазгрузки 			= АдресДоставки.Ссылка;
			НоваяСтрока.Идентификатор 			= АдресДоставки.ИмяКолонки;
			НоваяСтрока.ДатаОтгрузки			= АдресДоставки.ДатаОтгрузки;
			
			// Test{20230824
			НоваяСтрока.ЗагруженнаяНоменклатура = СтрокаТЧ.НаименованиеПоиск;
			НоваяСтрока.ЗагруженноеКоличество   = Количество;
			НоваяСтрока.ЗагруженныйДополнительныеАртикулы = ?(ПустаяСтрока(СтрокаТЧ.АртикулПоиск), СокрЛП(СтрокаТЧ.Артикул), СтрокаТЧ.АртикулПоиск);
			НоваяСтрока.ИДЗаявкиКлиента = АдресДоставки.ИДЗаявкиКлиента;
			// Test}
		КонецЦикла;
		
		НаименованиеНоменклатурыАрт = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.Артикул,"НаименованиеНоменклатуры");
		
		Если ПустаяСтрока(НаименованиеНоменклатурыАрт) И не ПустаяСтрока(СтрокаТЧ.НаименованиеПоиск) тогда
			Если СтрокаТЧ.Артикул <> СПравочники.ДополнительныеАртикулы.ПустаяСсылка() тогда
				ДопАртОб = СтрокаТЧ.Артикул.ПолучитьОбъект();
				ДопАртОб.НаименованиеНоменклатуры = СтрокаТЧ.НаименованиеПоиск;
				ДопАртОб.Записать();                                                               
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище( Объект.ТоварыКПереносу.Выгрузить() );
	
КонецФункции


//ERPS_TASK_В.Головченко_28.02.2023
&НаКлиенте
Процедура ОткрытьНастройки(Команда)
	ОткрытьФорму("ОбщаяФорма.ерпсНастройкиЗагрузкиДляАктов");
КонецПроцедуры    
//...ERPS_TASK_В.Головченко_28.02.2023

// Test{20230824
&НаКлиенте
Процедура ДеревоКоличествАртикулПриИзменении(Элемент)
	ДанныеСтроки = Элементы.ДеревоКоличеств.ТекущиеДанные;
	ДанныеСтроки.Номенклатура = ПолучитьНоменклатуруПоАртикулуНаСервере(ДанныеСтроки.Артикул);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНоменклатуруПоАртикулуНаСервере(Артикул)
	Возврат Справочники.ДополнительныеАртикулы.НайтиНоменклатуруПоАртикулу(Артикул);
КонецФункции


&НаКлиенте
Процедура ЗагрузитьСФайла(Команда)
	
    ОбработкаОкончанияПомещения = Новый ОписаниеОповещения("ОбработчикОкончанияПомещения", ЭтотОбъект);

    НачатьПомещениеФайла(ОбработкаОкончанияПомещения, , , Истина,     
        ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОбработчикОкончанияПомещения(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
		
	Если Результат Тогда
        //Сообщить(Адрес); 
		
		ЗагрузкаСФайла = Истина;
		
		АдресЗагруженныхДанных = ПолучитьТаблицуФайла(Адрес
			, УникальныйИдентификатор
			, Новый Структура("Колонка_ИДЗаявкиКлиента,Колонка_ДатаОтгрузки,Колонка_ПунктРазгрузкиПоиск,Колонка_ЗагруженныйДополнительныеАртикулы,Колонка_ЗагруженнаяНоменклатура,Колонка_ЗагруженноеКоличество,НомерПервойСтроки",
				Колонка_ИДЗаявкиКлиента, Колонка_ДатаОтгрузки, Колонка_ПунктРазгрузкиПоиск, Колонка_ЗагруженныйДополнительныеАртикулы, Колонка_ЗагруженнаяНоменклатура, Колонка_ЗагруженноеКоличество, НомерПервойСтроки)
			, Объект.Дата
			
		);
		
		ПараметрыОткрытия = Новый Структура("АдресЗагруженыхДанных", АдресЗагруженныхДанных);
		
		ОткрытьФорму(
			"Обработка.ерпсСозданиеАктаПриемаПередачиТовара.Форма.ФормаВыбораСопоставленияМестДоставки",
			ПараметрыОткрытия,
			ЭтаФорма,
			,
			,
			,
			//Новый ОписаниеОповещения("СопоставлениеПунктовРазгрузки_Завершение", ЭтотОбъект)
		);

    Иначе
        Сообщить(Нстр("ru = 'Файл не был помещен.'; uk = 'Файл не було поміщено.'"));
	КонецЕсли;

КонецПроцедуры

//&НаКлиенте
//Процедура СопоставлениеПунктовРазгрузки_Завершение(Результат, ДопПараметры) Экспорт
//	
//	
//	
//КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТаблицуФайла(Адрес, УникальныйИдентификатор, Парам, ДатаДокумента = Неопределено)

	Т = Новый ТаблицаЗначений;
	
	ТабДок = Новый ТабличныйДокумент;
	
	Данные = ПолучитьИзВременногоХранилища(Адрес);
	ИмяФайла = ПолучитьИмяВременногоФайла("xlsx");
	Данные.Записать(ИмяФайла);
	
	Попытка
		ТабДок.Прочитать(ИмяФайла, СпособЧтенияЗначенийТабличногоДокумента.Значение);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'не удалось прочитать файл'; uk = 'не вдалося прочитати файл'") +Символы.ПС+ ОписаниеОшибки());
	КонецПопытки;
	
	СтрокаЗаголовка = 1;
	Для Сч = 1 По ТабДок.ВысотаТаблицы Цикл
		
		Значение = ТабДок.Область(Сч, Парам.Колонка_ИДЗаявкиКлиента, Сч, Парам.Колонка_ИДЗаявкиКлиента).Текст;
		Если СтрНайти(ВРег(Значение), "ID ЗАЯВКИ") ИЛИ СтрНайти(ВРег(Значение), "ORDER_ID") Тогда
			СтрокаЗаголовка = Сч;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ПоследняяСтрока = ТабДок.ВысотаТаблицы;
	Для Сч = (СтрокаЗаголовка+1) По ТабДок.ВысотаТаблицы Цикл
		
		Значение = ТабДок.Область(Сч, Парам.Колонка_ПунктРазгрузкиПоиск, Сч, Парам.Колонка_ПунктРазгрузкиПоиск).Текст;
		Если ПустаяСтрока(Значение) Тогда
			ПоследняяСтрока = Сч;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;

	
	ПО_данные = Новый ПостроительОтчета;
	ПО_данные.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТабДок.Область(СтрокаЗаголовка, 1, ПоследняяСтрока, ТабДок.ШиринаТаблицы));
	ПО_данные.Выполнить();

	Т = ПО_данные.Результат.Выгрузить();
	
//	Т.Колонки.Добавить("ПунктРазгрузки", Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Тип("СправочникСсылка.ПунктыРазгрузки"))));



	Т.Колонки[Парам.Колонка_ИДЗаявкиКлиента-1].Имя = "ИДЗаявкиКлиента";
	Т.Колонки[Парам.Колонка_ДатаОтгрузки-1].Имя = "ДатаОтгрузки";
	Т.Колонки[Парам.Колонка_ПунктРазгрузкиПоиск-1].Имя = "ПунктРазгрузкиПоиск";
	Т.Колонки[Парам.Колонка_ЗагруженныйДополнительныеАртикулы-1].Имя = "ЗагруженныйДополнительныеАртикулы";
	Т.Колонки[Парам.Колонка_ЗагруженнаяНоменклатура-1].Имя = "ЗагруженнаяНоменклатура";
	Т.Колонки[Парам.Колонка_ЗагруженноеКоличество-1].Имя = "ЗагруженноеКоличество";
		
	//ТПунктов = Т.Скопировать();
	//ТПунктов.Свернуть("ПунктРазгрузкиПоиск,ИДЗаявкиКлиента,ДатаОтгрузки");
	
	// сопоставление 
	Запрос = Новый запрос;
	Запрос.УстановитьПараметр("Таб", Т);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ Т.*
	|ПОМЕСТИТЬ ВТТаб
	|ИЗ &Таб КАК Т
	|;
	|ВЫБРАТЬ 
	|	Т.*
	|	, ТТ.Объект КАК ПунктРазгрузки
	|ИЗ ВТТаб КАК Т
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.а_СвязьОбъектов КАК ТТ
	|	ПО Т.ПунктРазгрузкиПоиск = ТТ.ИД
	|		И ТТ.ТипОбъекта = ЗНАЧЕНИЕ(Перечисление.а_ТипыОбъектов.ПунктРазгрузки)
	|ГДЕ Т.ПунктРазгрузкиПоиск <> """"";
	
	Т = Запрос.Выполнить().Выгрузить();
	
	ТТ = Новый ТаблицаЗначений;
	Для Каждого Колонка Из Т.Колонки Цикл
		Если НРег(Колонка.Имя) = НРег("ЗагруженныйДополнительныеАртикулы") ИЛИ НРег(Колонка.Имя) = НРег("ИДЗаявкиКлиента") Тогда
			ТТ.Колонки.Добавить(Колонка.Имя, Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));
		ИначеЕсли НРег(Колонка.Имя) = НРег("ЗагруженноеКоличество") Тогда
			ТТ.Колонки.Добавить(Колонка.Имя, Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15,3,ДопустимыйЗнак.Неотрицательный)));
		ИначеЕсли НРег(Колонка.Имя) = НРег("ДатаОтгрузки") Тогда
			ТТ.Колонки.Добавить(Колонка.Имя, Новый ОписаниеТипов("Дата"));
		ИначеЕсли НРег(Колонка.Имя) = НРег("ПунктРазгрузки") Тогда
			ТТ.Колонки.Добавить(Колонка.Имя, Новый ОписаниеТипов("СправочникСсылка.ПунктыРазгрузки"));	
		Иначе	
			ТТ.Колонки.Добавить(Колонка.Имя, Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200)));
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из Т Цикл
		НоваяСтрока = ТТ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр,, "ЗагруженныйДополнительныеАртикулы,ИДЗаявкиКлиента");
		НоваяСтрока.ЗагруженныйДополнительныеАртикулы = СтрЗаменить(СтрЗаменить(СокрЛП(Стр.ЗагруженныйДополнительныеАртикулы), " ", ""), Символы.НПП, "");
		НоваяСтрока.ИДЗаявкиКлиента = СокрЛП(Стр.ИДЗаявкиКлиента);
		
		времДата = НоваяСтрока.ДатаОтгрузки;
		Если ЗначениеЗаполнено(НоваяСтрока.ПунктРазгрузкиПоиск) И ЗначениеЗаполнено(ДатаДокумента) Тогда
			НоваяСтрока.ДатаОтгрузки = ерпсАктПриемкиПередачиСервер.ПолучитьДатуВывоза(ДатаДокумента, НоваяСтрока.ПунктРазгрузки.ДеньВывоза);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(НоваяСтрока.ДатаОтгрузки) Тогда
			НоваяСтрока.ДатаОтгрузки = времДата;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ТТ, УникальныйИдентификатор);	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Колонка_ДатаОтгрузки = 0 Тогда
		Колонка_ДатаОтгрузки = 3;
	КонецЕсли;
	Если Колонка_ИДЗаявкиКлиента = 0 Тогда
		Колонка_ИДЗаявкиКлиента = 1;
	КонецЕсли;
	Если Колонка_ПунктРазгрузкиПоиск = 0 Тогда
		Колонка_ПунктРазгрузкиПоиск = 5;
	КонецЕсли;
	Если Колонка_ЗагруженныйДополнительныеАртикулы = 0 Тогда
		Колонка_ЗагруженныйДополнительныеАртикулы = 14;
	КонецЕсли;
	Если Колонка_ЗагруженнаяНоменклатура = 0 Тогда
		Колонка_ЗагруженнаяНоменклатура = 15;
	КонецЕсли;
	Если Колонка_ЗагруженноеКоличество = 0 Тогда
		Колонка_ЗагруженноеКоличество = 16;
	КонецЕсли;
	Если НомерПервойСтроки = 0 Тогда
		НомерПервойСтроки = 7;
	КонецЕсли;
	
КонецПроцедуры
// Test}