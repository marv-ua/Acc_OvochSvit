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
	
	ИнициализироватьТабличныйДокумент();
	ерпсАктПриемкиПередачиСервер.ПостроитьДеревоКоличеств(ЭтаФорма);
	
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

	Пока ЗаполненаНоменклатураАртикул Цикл
		
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
			НоваяСтрока[СтрокаТЧ.ИмяКолонки] = КоличествоНоменклатуры;
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
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				МассивНоменклатуры.Добавить(НайденнаяСтрока);
			КонецЦикла;
						
		КонецЕсли;
	
				
		Если МассивНоменклатуры.Количество() = 1 Тогда
			
			НоваяСтрока.КоличествоНоменклатурыДляВыбора = 1;
			
			НоваяСтрока.Номенклатура = ПолучитьНоменклатуруИзПоследнегоРТУ(МассивНоменклатуры[0].Артикул);
			НоваяСтрока.НоменклатураСопоставленаАвтоматически = Истина;
			НоваяСтрока.Артикул		=  МассивНоменклатуры[0].Артикул;
			
			
			Если НоваяСтрока.АртикулПоиск <> МассивНоменклатуры[0].АртикулПоиск Тогда
				НоваяСтрока.АртикулОтличается = НЕ ПустаяСтрока(НоваяСтрока.АртикулПоиск);
			КонецЕсли;
			
		КонецЕсли;
		
		Если НоваяСтрока.НоменклатураСопоставленаАвтоматически
			И Не НоваяСтрока.НоменклатураНаименованиеОтличается
			И НЕ НоваяСтрока.АртикулОтличается Тогда
			 			  
			НоваяСтрока.СтрокаСопоставлена = Истина;
		Иначе
			НоваяСтрока.СтрокаСопоставлена = Ложь;
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
		
		Попытка
			ЗаполненаНоменклатураАртикул = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаАртикул).Текст)
	                               Или ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + КолонкаНоменклатура).Текст);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
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
			//Если Количество = 0 
			//	или СтрокаТЧ.Номенклатура = ПустаяНоменклатура Тогда
			//	//или СтрокаТЧ.Артикул = ПустойАртикул Тогда
			//	
			//	Продолжить;
			//	
			//КонецЕсли;
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

