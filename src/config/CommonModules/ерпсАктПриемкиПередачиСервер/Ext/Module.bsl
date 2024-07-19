﻿
Процедура УстановитьКлючВСтрокахТабличнойЧасти(Объект, ИмяТабЧасти, РеквизитМаксимальныйКодСтроки = "МаксимальныйКодСтроки") Экспорт
	
	СтрокиБезКлюча = Объект[ИмяТабЧасти].Найтистроки(Новый Структура("КодСтроки",0));
	
	Если СтрокиБезКлюча.Количество() > 0 тогда
		
		ТекущийКод = Объект[РеквизитМаксимальныйКодСтроки];
		
		Для каждого Стр из СтрокиБезКлюча Цикл
			ТекущийКод = ТекущийКод + 1;
			Стр.КодСтроки = ТекущийКод;
		КонецЦикла;  
		
		Объект[РеквизитМаксимальныйКодСтроки] = ТекущийКод;
		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПостроитьДеревоКоличеств(Форма, ИмяТаблицы = "ДеревоКоличеств", ДополнительныеАртикулы = Истина) Экспорт

	ДобавляемыеКолонкиТаблицы = Новый Массив();
	УдаляемыеКолонкиТаблицы   = Новый Массив();
	УдаляемыеЭлементы            = Новый Массив();
	УсловныеОформления           = Новый Массив();
	
	Если ТипЗнч(Форма.ДеревоКоличеств) = Тип("ДанныеФормыКоллекция") Тогда
		ДеревоЗначений = Новый ТаблицаЗначений;
	Иначе
		ДеревоЗначений = Новый ДеревоЗначений;
	КонецЕсли;
	
	ДеревоЗначений.Колонки.Добавить("Номенклатура",               Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДеревоЗначений.Колонки.Добавить("ИндексКартинки",             Новый ОписаниеТипов("Число"));
	
	Если ДополнительныеАртикулы тогда
		ДеревоЗначений.Колонки.Добавить("Артикул",                    Новый ОписаниеТипов("СправочникСсылка.ДополнительныеАртикулы"));
	Иначе
		ДеревоЗначений.Колонки.Добавить("Артикул",                    Новый ОписаниеТипов("Строка"));		
	КонецЕсли;
	
	Если ЭтоЗагрузкаАктовПриемаПередачи(Форма) Тогда
		
		ДеревоЗначений.Колонки.Добавить("НаименованиеПоиск",	                 Новый ОписаниеТипов("Строка"));
		ДеревоЗначений.Колонки.Добавить("АртикулПоиск",			                 Новый ОписаниеТипов("Строка"));
		ДеревоЗначений.Колонки.Добавить("НоменклатураСопоставленаАвтоматически", Новый ОписаниеТипов("Булево"));
		ДеревоЗначений.Колонки.Добавить("СтрокаСопоставлена",                    Новый ОписаниеТипов("Булево"));
		ДеревоЗначений.Колонки.Добавить("КоличествоНоменклатурыДляВыбора",       Новый ОписаниеТипов("Число"));
		ДеревоЗначений.Колонки.Добавить("АртикулОтличается",                     Новый ОписаниеТипов("Булево"));
		ДеревоЗначений.Колонки.Добавить("НоменклатураНаименованиеОтличается",    Новый ОписаниеТипов("Булево"));

	КонецЕсли;
	
	Для Каждого АдресДоставки Из Форма.ВыбранныеМестаДоставки Цикл
		
		Если АдресДоставки.Выбрана Тогда
			
			ИмяКолонки = АдресДоставки.ИмяКолонки;
			
			ДеревоЗначений.Колонки.Добавить(                          ИмяКолонки, Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный)), АдресДоставки.Наименование);
			//ДеревоЗначений.Колонки.Добавить("Упаковка" + ИмяКолонки, Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"), "Упаковка");

		КонецЕсли;
		
	КонецЦикла;
	
	КолонкаОтступ = ДеревоЗначений.Колонки.Добавить("Отступ", Новый ОписаниеТипов("Строка"), НСтр("ru='Отступ';uk='Відступ'"));
	
	РеквизитыТаблицы = Форма.ПолучитьРеквизиты(ИмяТаблицы);
	Для Каждого Реквизит Из РеквизитыТаблицы Цикл
		Если СтрНайти(Реквизит.Имя, "ДопКол") ИЛИ СтрНайти(Реквизит.Имя, "Отступ") Тогда
			УдаляемыеКолонкиТаблицы.Добавить(ИмяТаблицы + "." + Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Колонка Из ДеревоЗначений.Колонки Цикл
		Если СтрНайти(Колонка.Имя, "ДопКол") Тогда
			УдаляемаяКолонка = УдаляемыеКолонкиТаблицы.Найти(ИмяТаблицы + "." + Колонка.Имя);
			Если УдаляемаяКолонка <> Неопределено Тогда
				УдаляемыеКолонкиТаблицы.Удалить(УдаляемаяКолонка);
			Иначе
				ДобавляемыеКолонкиТаблицы.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, ИмяТаблицы, Колонка.Заголовок, Истина));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ДобавляемыеКолонкиТаблицы.Добавить(Новый РеквизитФормы(КолонкаОтступ.Имя, КолонкаОтступ.ТипЗначения, ИмяТаблицы, КолонкаОтступ.Заголовок, Истина));
	
	Если УдаляемыеКолонкиТаблицы.Количество() > 0 Или ДобавляемыеКолонкиТаблицы.Количество() > 0 Тогда
		Форма.ИзменитьРеквизиты(ДобавляемыеКолонкиТаблицы, УдаляемыеКолонкиТаблицы);
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из Форма.Элементы[ИмяТаблицы].ПодчиненныеЭлементы Цикл
		Если СтрНайти(ТекЭлемент.Имя, "ДопКол") ИЛИ СтрНайти(ТекЭлемент.Имя, "Отступ") Тогда
			УдаляемыеЭлементы.Добавить(ТекЭлемент);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		Форма.Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	Для Каждого Оформление Из Форма.УсловноеОформление.Элементы Цикл
		Если Оформление.Представление = "СозданоПрограммно" Тогда
			УсловныеОформления.Добавить(Оформление);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Оформление Из УсловныеОформления Цикл
		Форма.УсловноеОформление.Элементы.Удалить(Оформление);
	КонецЦикла;
	КартинкаШапки = БиблиотекаКартинок.Калькулятор;

	Для Каждого АдресДоставки Из Форма.ВыбранныеМестаДоставки Цикл
		
		ИмяКолонки = АдресДоставки.ИмяКолонки;
		
		Если АдресДоставки.Выбрана Тогда
			
			ЦветЗаголовка = Неопределено;
			ЦветФона      = Неопределено;
			
			НоваяГруппа = ДобавитьГруппуФормы(Форма, "ГруппаКоличеств" + ИмяКолонки, Строка(АдресДоставки.Ссылка), Истина, КартинкаШапки, ГруппировкаКолонок.Горизонтальная);
			
			//ДеревоЗначений.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный)), АдресДоставки.Наименование);
			
			НовоеПоле = ДобавитьПолеФормы(Форма,ИмяКолонки, НСтр("ru='Количество';uk='Кількість'"), "Подключаемый_ДеревоКоличествКоличествоПриИзменении", , 12, ЦветФона, ЦветЗаголовка, НоваяГруппа);
			
			ДобавитьПолеФормы(Форма,"ЕдиницаИзмерения" + ИмяКолонки, НСтр("ru='Ед. изм.';uk='Од. вим.'"), , , 8, ЦветФона, ЦветЗаголовка, НоваяГруппа, , ИмяТаблицы + ".Номенклатура.БазоваяЕдиницаИзмерения", Истина);
			
			// Условное оформление единиц измерения
			УстановитьУсловноеОформлениеЕдиницИзмерения(Форма, ИмяТаблицы+"ЕдиницаИзмерения" + ИмяКолонки, ИмяТаблицы+".Упаковка" + ИмяКолонки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НовоеПоле = ДобавитьПолеФормы(Форма,"Отступ",,,,30,,,,,,Истина);
	НовоеПоле.ЦветТекста = WebЦвета.Серый;
	НовоеПоле.Видимость  = Истина;
	НовоеПоле.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	НовоеПоле.РастягиватьПоГоризонтали = Истина;
	
	ДеревоКоличествЗначение = Форма.РеквизитФормыВЗначение(ИмяТаблицы);
	ДеревоКоличествЗначение.Колонки.Очистить();
	
	Для Каждого Колонка Из ДеревоЗначений.Колонки Цикл
		ДеревоКоличествЗначение.Колонки.Добавить(Колонка.Имя);
	КонецЦикла;
	
	Форма.ЗначениеВРеквизитФормы(ДеревоКоличествЗначение, ИмяТаблицы);

КонецПроцедуры

Функция ДобавитьПолеФормы(Форма,
	                      Имя,
						  Заголовок = Неопределено,
						  ОбработчикПриИзменении = "",
						  ОбработчикНачалоВыбора = "",
						  ШиринаПоля,
						  ЦветФона = Неопределено,
						  ЦветФонаЗаголовка = Неопределено,
						  Родитель = Неопределено,
						  КартинкаШапки = Неопределено,
						  ПутьКДанным = Неопределено,
						  ТолькоПросмотрПоля = Ложь,
						  СвязиПараметровВыбора = Неопределено,
						  ОтображатьВШапке = Истина)
	
	НовоеПоле                     = Форма.Элементы.Добавить("ДеревоКоличеств" + Имя, Тип("ПолеФормы"), ?(Родитель = Неопределено, Форма.Элементы.ДеревоКоличеств, Родитель));
	НовоеПоле.ПутьКДанным         = ?(ЗначениеЗаполнено(ПутьКДанным), ПутьКДанным, "ДеревоКоличеств." + Имя);
	НовоеПоле.Заголовок           = ?(ЗначениеЗаполнено(Заголовок), Заголовок, Имя);
	НовоеПоле.РежимРедактирования = РежимРедактированияКолонки.ВходПриВводе;
	НовоеПоле.Вид                 = ВидПоляФормы.ПолеВвода;
	НовоеПоле.ТолькоПросмотр      = ТолькоПросмотрПоля;
	НовоеПоле.Ширина              = ШиринаПоля;
	НовоеПоле.ОтображатьВШапке    = ОтображатьВШапке;
	
	НовоеПоле.РастягиватьПоГоризонтали = Ложь;
	
	Если СвязиПараметровВыбора <> Неопределено Тогда
		НовоеПоле.СвязиПараметровВыбора = СвязиПараметровВыбора;
	КонецЕсли;
	
	Если ЦветФонаЗаголовка <> Неопределено Тогда
		НовоеПоле.ЦветФонаЗаголовка = ЦветФонаЗаголовка;
	КонецЕсли;
	
	Если ЦветФона <> Неопределено Тогда
		НовоеПоле.ЦветФона = ЦветФона;
	КонецЕсли;
		
	Если КартинкаШапки <> Неопределено Тогда
		НовоеПоле.КартинкаШапки = КартинкаШапки;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ОбработчикПриИзменении) Тогда
		НовоеПоле.УстановитьДействие("ПриИзменении", ОбработчикПриИзменении);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбработчикНачалоВыбора) Тогда
		НовоеПоле.УстановитьДействие("НачалоВыбора", ОбработчикНачалоВыбора);
	КонецЕсли;
	
	Возврат НовоеПоле;
	
КонецФункции

Функция ДобавитьГруппуФормы(Форма,
	                        Имя,
	                        Заголовок = Неопределено,
	                        ОтображатьВШапке = Ложь, 
	                        КартинкаШапки = Неопределено,
	                        ГруппировкаКолонок,
	                        Родитель = Неопределено)
	
	НоваяГруппа                  = Форма.Элементы.Добавить("ДеревоКоличеств" + Имя, Тип("ГруппаФормы"), ?(Родитель = Неопределено, Форма.Элементы.ДеревоКоличеств, Родитель));
	НоваяГруппа.Заголовок        = ?(ЗначениеЗаполнено(Заголовок), Заголовок, Имя);
	НоваяГруппа.Вид              = ВидГруппыФормы.ГруппаКолонок;
	НоваяГруппа.Группировка      = ГруппировкаКолонок;
	НоваяГруппа.ОтображатьВШапке = ОтображатьВШапке;
	
	Если ОтображатьВШапке И КартинкаШапки <> Неопределено Тогда
		НоваяГруппа.КартинкаШапки = КартинкаШапки;
	КонецЕсли;
	
	Возврат НоваяГруппа;
	
КонецФункции

Функция ЭтоЗагрузкаАктовПриемаПередачи(Форма)
	
	Возврат (Форма.КодФормы = "ЗагрузкаАктовПриемаПередачи");
	
КонецФункции

// Устанавливаем условное оформление для единиц измерения номенклатуры
//
// Параметры:
// 		Форма - Форма - Содержит данную форму
// 		ИмяПоляВводаЕдиницИзмерения - Строка - Наименование элемента формы, содержащего ед. измерения номенклатуры,
//									   			если оно отличается от "ТоварыНоменклатураЕдиницаИзмерения"
// 		ПутьКПолюОтбора - Строка - Полный путь к реквизиту "Упаковка",
//									если он отличается от "Объект.Товары.Упаковка"
//
Процедура УстановитьУсловноеОформлениеЕдиницИзмерения(Форма,
													  ИмяПоляВводаЕдиницИзмерения = "ТоварыНоменклатураБазоваяЕдиницаИзмерения",
													  ПутьКПолюОтбора = "Объект.Товары.Упаковка") Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляВводаЕдиницИзмерения].Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюОтбора);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);	
	
КонецПроцедуры 

#Область ОбновлениеРеализаций

Процедура ОбновитьРеализациюТоваровУслуг(АктСсылка) Экспорт

	ВыборкаРеализаций = ПолучитьВыборкуПоАктам(АктСсылка);
	
	Пока ВыборкаРеализаций.Следующий() Цикл
		
		Если ТЧРеализацииОтличаетсяОтТЧАктаПоКодуРядка(АктСсылка, ВыборкаРеализаций.Ссылка) Тогда
			ОбновитьТабличнуюЧастьРеализации(АктСсылка, ВыборкаРеализаций.Ссылка);
		КонецЕсли;

		//ERPS_TASK_В.Головченко_28.02.2023
		Если ЕстьОтличияПоРеквизитамЧтоОбновляются(АктСсылка, ВыборкаРеализаций.Ссылка) ТОгда
			ОбновитьРеквизитыЧтоОбновляются(АктСсылка, ВыборкаРеализаций.Ссылка)
		КонецЕсли;
		//...ERPS_TASK_В.Головченко_28.02.2023
		
	КонецЦикла;
	
КонецПроцедуры                                           

Функция ПолучитьВыборкуПоАктам(АктСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	НЕ РеализацияТоваровУслуг.ПометкаУдаления
		|	И (РеализацияТоваровУслуг.Сделка = &АктСсылка
		|			ИЛИ РеализацияТоваровУслуг.ерпсАктПриемкиПередачи = &АктСсылка)";
	
	Запрос.УстановитьПараметр("АктСсылка", АктСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции
Функция ТЧРеализацииОтличаетсяОтТЧАктаПоКодуРядка(АктСсылка, РеализацияСсылка)
		
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапроса_ОтличиеАктаОтРТУ();
		
	
	Запрос.УстановитьПараметр("РТУ", РеализацияСсылка);
	Запрос.УстановитьПараметр("Акт", АктСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();

КонецФункции 
Функция ПолучитьТекстЗапроса_ОтличиеАктаОтРТУ()
	
	Возврат "ВЫБРАТЬ
		|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
		|	РеализацияТоваровУслугТовары.Количество КАК Количество,
		|	РеализацияТоваровУслугТовары.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВТРТУ
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|ГДЕ
		|	РеализацияТоваровУслугТовары.Ссылка = &РТУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ерпсАктПриемкиПередачиТоваровТовары.Номенклатура КАК Номенклатура,
		|	ерпсАктПриемкиПередачиТоваровТовары.Количество КАК Количество,
		|	ерпсАктПриемкиПередачиТоваровТовары.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВТ_Акт
		|ИЗ
		|	Документ.ерпсАктПриемкиПередачиТоваров.Товары КАК ерпсАктПриемкиПередачиТоваровТовары
		|ГДЕ
		|	ерпсАктПриемкиПередачиТоваровТовары.Ссылка = &Акт
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Акт.Номенклатура КАК Номенклатура,
		|	ВТРТУ.Количество КАК КоличествоРТУ,
		|	ВТ_Акт.Количество КАК КоличествоАкт,
		|	ВТ_Акт.КодСтроки КАК КодСтрокиАКТ
		|ИЗ
		|	ВТРТУ КАК ВТРТУ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Акт КАК ВТ_Акт
		|		ПО ВТРТУ.Номенклатура = ВТ_Акт.Номенклатура
		|			И ВТРТУ.КодСтроки = ВТ_Акт.КодСтроки
		|ГДЕ
		|	ЕСТЬNULL(ВТ_Акт.Количество, 0) <> ЕСТЬNULL(ВТРТУ.Количество, 0)";

КонецФункции
Процедура ОбновитьТабличнуюЧастьРеализации(АктСсылка, РеализацияСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапроса_ОтличиеАктаОтРТУ();
	
	
	Запрос.УстановитьПараметр("РТУ", РеализацияСсылка);
	Запрос.УстановитьПараметр("Акт", АктСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	РТУОбъект = РеализацияСсылка.ПолучитьОбъект();
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, ЭтоКомиссия, Реализация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, РТУОбъект);
	ДанныеОбъекта.Реализация	= Истина;
	ДанныеОбъекта.ЭтоКомиссия	= (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РТУОбъект.ДоговорКонтрагента, "ВидДоговора") = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);

	
	Записывать = Ложь;
	Пока Выборка.Следующий() Цикл
		
		СтрокаТоваров = РТУОбъект.Товары.НайтиСтроки(Новый Структура("КодСтроки,Номенклатура",Выборка.КодСтрокиАКТ,Выборка.Номенклатура));
		
		Если СтрокаТоваров.Количество() > 0 тогда
			
			СтрокаТаблицы = СтрокаТоваров[0];
			
			СтрокаТаблицы.Количество = Выборка.КоличествоАКТ;
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТаблицы, 0);
			
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, РТУОбъект.СуммаВключаетНДС);
		Иначе
			Записывать = Истина;
			СтрокаТабличнойЧасти = РТУОбъект.Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;
			СтрокаТабличнойЧасти.КодСтроки    = Выборка.КодСтрокиАКТ;
			СтрокаТабличнойЧасти.Количество	  = Выборка.КоличествоАкт; 
			
		КонецЕсли;
		
		
	КонецЦикла;            
	
	Если РТУОбъект.Проведен и НЕ Записывать тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	Иначе
		РежимЗаписи = РежимЗаписиДокумента.Запись;
	КонецЕсли;
	
	
	Попытка
		РТУОбъект.Записать(РежимЗаписи);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

//ERPS_TASK_В.Головченко_28.02.2023
Функция ЕстьОтличияПоРеквизитамЧтоОбновляются(ДокументОснование, ПодчиненныйДокумент)
	МассивРеквизитов = ПолучитьМассивРеквизитовЧтоОбновляются();
	ЕстьОтличие = Ложь; 
	ЭтоРеализация = ТипЗнч(ПодчиненныйДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг");
	Для каждого Реквизит из МассивРеквизитов Цикл
		ЗначениеОснования  = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование   , Реквизит);
		
		Если Реквизит = "Перевозчик" и ЭтоРеализация Тогда
			ЗначениеПодчинения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодчиненныйДокумент , "ЕРПСПеревозчик");
		ИНаче
			ЗначениеПодчинения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодчиненныйДокумент , Реквизит);
		КонецЕсли;

		Если ЗначениеОснования <> ЗначениеПодчинения Тогда
			 ЕстьОтличие = Истина;
			 Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЕстьОтличие;
	
КонецФункции
Функция ПолучитьМассивРеквизитовЧтоОбновляются()
	
	Результат = Новый Массив;
	Результат.Добавить("Водитель");
	Результат.Добавить("Перевозчик");
	Результат.Добавить("Авто");
	Результат.Добавить("Прицеп");
	Результат.Добавить("ПунктРазгрузки");
	Результат.Добавить("АдрессДоставки");
	
	Возврат Результат;
	
КонецФункции
Процедура ОбновитьРеквизитыЧтоОбновляются(ДокументОснование, ПодчиненныйДокумент)
	МассивРеквизитов = ПолучитьМассивРеквизитовЧтоОбновляются();
    ДокОбъект = ПодчиненныйДокумент.ПолучитьОбъект();
	ЭтоРеализация = ТипЗнч(ПодчиненныйДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг");
	Для каждого Реквизит из МассивРеквизитов Цикл
		
		Если Реквизит = "Перевозчик" и ЭтоРеализация Тогда
			ДокОбъект.ЕРПСПеревозчик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование   , Реквизит);
		ИНачеЕсли Реквизит = "АдрессДоставки" и ЭтоРеализация Тогда
			ДокОбъект.АдресДоставки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование   , Реквизит);
		Иначе
			ДокОбъект[Реквизит] = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование   , Реквизит);
		КонецЕсли;
		
	КонецЦикла;
	ДокОбъект.Записать(?(ДокОбъект.Проведен,РежимЗаписиДокумента.Проведение,РежимЗаписиДокумента.Запись));
	
КонецПроцедуры
//...ERPS_TASK_В.Головченко_28.02.2023

#КонецОбласти

Функция ТабличныеЧастыСоответствуютПолностью(РеализацияТоваров,АктПриемкиПередачи) Экспорт
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АктПриемкиПередачи,"Статус") = Перечисления.ерпсСтатусыАктовПриемкиПередачи.Отгружено тогда
		Возврат Ложь;
	КонецЕсли;
	
	РазличияВТч = ПолучитьРазличияРеализацияТоваровАктПриемкиПередачи(РеализацияТоваров, АктПриемкиПередачи); 			
	
	Возврат РазличияВТч.КОличество() = 0;
	
КонецФункции
Функция ПолучитьРазличияРеализацияТоваровАктПриемкиПередачи(РеализацияТоваров, АктПриемкиПередачи)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ерпсАктПриемкиПередачиТоваровТовары.Номенклатура КАК Номенклатура,
	|	СУММА(ерпсАктПриемкиПередачиТоваровТовары.Количество) КАК Количество
	|ПОМЕСТИТЬ ВТ_АктПриемкиПередачи
	|ИЗ
	|	Документ.ерпсАктПриемкиПередачиТоваров.Товары КАК ерпсАктПриемкиПередачиТоваровТовары
	|ГДЕ
	|	ерпсАктПриемкиПередачиТоваровТовары.Ссылка = &АктПриемкиПередачи
	|	И НЕ ерпсАктПриемкиПередачиТоваровТовары.Ссылка.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	ерпсАктПриемкиПередачиТоваровТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
	|	СУММА(РеализацияТоваровУслугТовары.Количество) КАК Количество
	|ПОМЕСТИТЬ ВТ_РеализацияТоваров
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	(РеализацияТоваровУслугТовары.Ссылка.Сделка = &АктПриемкиПередачи
	|			ИЛИ РеализацияТоваровУслугТовары.Ссылка.ерпсАктПриемкиПередачи = &АктПриемкиПередачи)
	|	И РеализацияТоваровУслугТовары.Ссылка.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияТоваровУслугТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_РеализацияТоваров.Номенклатура КАК НоменклатураРеализация,
	|	ВТ_АктПриемкиПередачи.Номенклатура КАК НоменклатураПриемкиПередачи,
	|	ЕСТЬNULL(ВТ_РеализацияТоваров.Количество, 0) КАК КоличествоРеализация,
	|	ЕСТЬNULL(ВТ_АктПриемкиПередачи.Количество, 0) КАК КоличествоПриемкиПередачи
	|ИЗ
	|	ВТ_АктПриемкиПередачи КАК ВТ_АктПриемкиПередачи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РеализацияТоваров КАК ВТ_РеализацияТоваров
	|		ПО (ВТ_РеализацияТоваров.Номенклатура = ВТ_АктПриемкиПередачи.Номенклатура)";
	
	Запрос.УстановитьПараметр("РеализацияТоваров", РеализацияТоваров);
	Запрос.УстановитьПараметр("АктПриемкиПередачи", АктПриемкиПередачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	МассивРезультатов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		
		Если ВЫборка.КоличествоРеализация > ВЫборка.КоличествоПриемкиПередачи тогда
			
			МассивРезультатов.Добавить(ВЫборка.НоменклатураПриемкиПередачи);	
			
		ИначеЕсли ВЫборка.КоличествоРеализация < ВЫборка.КоличествоПриемкиПередачи тогда
			
			МассивРезультатов.Добавить(ВЫборка.НоменклатураРеализация);
			
		КонецЕсли;
		
	КонецЦикла;
	Возврат МассивРезультатов;
	
КонецФункции

Процедура ОбновитьСтатусАктаПриемкиПередачиТоваров(АктПриемкиПередачи, ИмяСтатуса) Экспорт
	АктПриемкиПередачиОбъект = АктПриемкиПередачи.ПолучитьОбъект();
	АктПриемкиПередачиОбъект.Статус = Перечисления.ерпсСтатусыАктовПриемкиПередачи[ИмяСтатуса];
	Попытка
		АктПриемкиПередачиОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры
	
Функция ПолучитьРТУ(Знач Идентификатор, Заявка, ПолучатьСсылку = Ложь) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("Заявка", Заявка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	а_ДокументыРеализацииЗаявок.Реализация.Ссылка КАК Ссылка
	               |ИЗ
	               |	РегистрСведений.а_ДокументыРеализацииЗаявок КАК а_ДокументыРеализацииЗаявок
	               |ГДЕ
	               |	а_ДокументыРеализацииЗаявок.Идентификатор = &Идентификатор
	               |	И а_ДокументыРеализацииЗаявок.Заявка = &Заявка";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если ПолучатьСсылку Тогда
			Возврат Выборка.Ссылка;
		Иначе
			Возврат Выборка.Ссылка.ПолучитьОбъект();
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучатьСсылку Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Об = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
	
	Возврат Об;
	
КонецФункции

Функция ПолучитьТипЦен(Контрагент, Период, Склад) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ТипыЦенНоменклатуры.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ТипыЦенНоменклатуры КАК ТипыЦенНоменклатуры
	               |ГДЕ
	               |	ТипыЦенНоменклатуры.а_Период = &Период
	               |	И ТипыЦенНоменклатуры.а_Контрагент = &Контрагент
	               |	И ТипыЦенНоменклатуры.а_Склад = &Склад";

	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	РеализацияТоваровУслуг.ТипЦен КАК Ссылка
		               |ИЗ
		               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		               |			МАКСИМУМ(РеализацияТоваровУслуг.Дата) КАК Дата,
		               |			РеализацияТоваровУслуг.Контрагент КАК Контрагент,
		               |			РеализацияТоваровУслуг.Склад КАК Склад
		               |		ИЗ
		               |			Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		               |		ГДЕ
		               |			РеализацияТоваровУслуг.Контрагент = &Контрагент
		               |			И РеализацияТоваровУслуг.Дата < &Период
		               |			И РеализацияТоваровУслуг.Проведен
		               |			И РеализацияТоваровУслуг.ТипЦен <> ЗНАЧЕНИЕ(Справочник.ТипыЦенНоменклатуры.ПустаяСсылка)
		               |			И РеализацияТоваровУслуг.Склад = &Склад
		               |		
		               |		СГРУППИРОВАТЬ ПО
		               |			РеализацияТоваровУслуг.Контрагент,
		               |			РеализацияТоваровУслуг.Склад) КАК Вл
		               |		ПО РеализацияТоваровУслуг.Дата = Вл.Дата
		               |			И РеализацияТоваровУслуг.Контрагент = Вл.Контрагент
		               |			И РеализацияТоваровУслуг.Склад = Вл.Склад";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Процедура ОбнЦ_ОбновитьЦеныНаСервере(Ссылка, ТипЦен, Об = Неопределено, НеЗаписывать = Ложь, СтавитьЦенуЕслиНеНайдено = Ложь) Экспорт
	
	Если Об = Неопределено тогда
		Об = Ссылка.ПолучитьОбъект();
	КонецЕсли;
	Об.ТипЦен = ?(не ТипЦен = Неопределено, ТипЦен, Об.ТипЦен);
	
	Для Каждого ТекущаяСтрока из Об.Товары Цикл
		Если Не ЗначениеЗаполнено(Об.ТипЦен) Тогда
			Попытка 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(
					НСтр("ru = 'Не заполнен тип цен в документе %1'; uk = 'Не заповнено тип цін в документі %1'"),
					Об.Ссылка)
				);
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не заполнен тип цен в документе '; uk = 'Не заповнено тип цін в документі '")
				);
			КонецПопытки;
			Продолжить;
		КонецЕсли;
		
		СрезЦен = РегистрыСведений.ЦеныНоменклатуры.ПолучитьПоследнее(Об.Дата,
			Новый Структура("ТипЦен, Номенклатура",
				Об.ТипЦен,
				ТекущаяСтрока.Номенклатура)
		);
		
		Если Не ЗначениеЗаполнено(СрезЦен.Цена) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяСтрока.Цена = СрезЦен.Цена;
		Если СтавитьЦенуЕслиНеНайдено И ТекущаяСтрока.Цена = 0 Тогда
			ТекущаяСтрока.Цена = 0.01;
		КонецЕсли;
		
		
		СтрокаТаблицы = ТекущаяСтрока;
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТаблицы, 0);

		Попытка
			Если СтрокаТаблицы.СуммаНДС Или СтрокаТаблицы.СуммаНДС = 0 Тогда
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Об.СуммаВключаетНДС);
			КонецЕсли;
		Исключение
		КонецПопытки;

		Попытка
			Если СтрокаТаблицы.СуммаВРознице Или СтрокаТаблицы.СуммаВРознице = 0 Тогда
				СтрокаТаблицы.СуммаВРознице = СтрокаТаблицы.Количество * СтрокаТаблицы.ЦенаВРознице;
			КонецЕсли;
		Исключение
		КонецПопытки;		

		Попытка
			Если СтрокаТаблицы.Всего Или СтрокаТаблицы.Всего = 0 Тогда
				//Если УчитыватьНДС Тогда
					СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Об.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
				//Иначе
				//	СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма;	
				//КонецЕсли; 
			КонецЕсли;
		Исключение
		КонецПопытки;
		
		Попытка
			Если СтрокаТаблицы.СуммаНУ Или СтрокаТаблицы.СуммаНУ = 0 Тогда
				СтрокаТаблицы.СуммаНУ = СтрокаТаблицы.Сумма;		
			КонецЕсли;
		Исключение
		КонецПопытки;
		
		
		
	КонецЦикла;
	
	Если НеЗаписывать Тогда
		Возврат;
	КонецЕсли;
	
	Попытка 
		Об.Записать(
			?(Об.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись),
			?(Об.Проведен, РежимПроведенияДокумента.Неоперативный, Неопределено)
		);
	Исключение
		Сообщить(СтрШаблон(НСтр("ru = 'обшика записи документа %1, %2'; uk = 'помилка запису документу %1, %2'")
			, Об.Ссылка, ОписаниеОшибки())
		);
	КонецПопытки;
	
КонецПроцедуры

Функция ОпределитьПунктРазгрузки(Стр, ОТГ = "") Экспорт
	
    Если Не ЗначениеЗаполнено(ОТГ) Тогда
		Спр = Справочники.ПунктыРазгрузки.НайтиПоНаименованию(Стр); 
		Если ЗначениеЗаполнено(Спр) Тогда
			Возврат Спр;
		КонецЕсли;
	КонецЕсли;
	
	Возврат РегистрыСведений.а_СвязьОбъектов.ПолучитьПунктРазгрузки(Стр, ОТГ);
	
КонецФункции

Функция ПолучитьДопАртикул(Стр) Экспорт
	
	Возврат Справочники.ДополнительныеАртикулы.НайтиПоНаименованию(Стр);
	
КонецФункции

Функция ПолучитьДатуВывоза(Знач Дата, ДеньВывоза) Экспорт
	
	Если ДеньВывоза = 0 Тогда
		Возврат Дата(1,1,1);
	КонецЕсли;
	
	Если ДеньНедели(Дата) = ДеньВывоза Тогда
		Возврат Дата;
	КонецЕсли;
	
	Возврат ПолучитьДатуВывоза(КонецДня(Дата) + 1, ДеньВывоза);
	
КонецФункции

Процедура ЗаписатьДатуВывоза(ПунктРазгрузки, Дата) Экспорт
	
	
	Если Не ЗначениеЗаполнено(ПунктРазгрузки) Тогда
		Возврат;
	КонецЕсли;
	ДеньНедели = ДеньНедели(Дата);
	
	Если ДеньНедели = ПунктРазгрузки.ДеньВывоза Тогда
		Возврат;
	КонецЕсли;
	
	Об = ПунктРазгрузки.ПолучитьОбъект();
	
	Об.ДеньВывоза = ДеньНедели;

	Попытка
		Об.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры
