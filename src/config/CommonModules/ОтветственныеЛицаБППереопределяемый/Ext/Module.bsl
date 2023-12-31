﻿////////////////////////////////////////////////////////////////////////////////
// Ответственные лица: процедуры и функции для работы с ответственным лицами.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция возвращает структуру с реквизитами ответственных лиц.
//
// Параметры:
//  Организация - организация, для которой нужно определить руководящих лиц.
//	ДатаСреза - дата со временем, на которые необходимо определить сведения.
//	Подразделение - подразделение, для которого необходимо определить ответственных лиц.
//
Функция ОтветственныеЛица(Организация, ДатаСреза, Подразделение = Неопределено) Экспорт

	ДанныеОтветственныхЛиц = ОтветственныеЛицаБП.ПустаяСтруктураОтветственныхЛиц();

	СобиратьПоОрганизации = НЕ ЗначениеЗаполнено(Подразделение);

	Если Организация <> Неопределено тогда

		Если ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда
			РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, 
				"ИндивидуальныйПредприниматель, ЮридическоеФизическоеЛицо");
		Иначе
			РеквизитыОрганизации = Новый Структура();
			РеквизитыОрганизации.Вставить("ИндивидуальныйПредприниматель");
			РеквизитыОрганизации.Вставить("ЮридическоеФизическоеЛицо");
		КонецЕсли;

		ЗапросПоЛицам = Новый Запрос();
		ЗапросПоЛицам.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		ЗапросПоЛицам.УстановитьПараметр("ДатаСреза",   ДатаСреза);
		ЗапросПоЛицам.УстановитьПараметр("Организация", Организация);

		Если РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
			
			ДанныеФизическогоЛица = УчетЗарплаты.ДанныеФизическихЛиц(Организация, РеквизитыОрганизации.ИндивидуальныйПредприниматель, ДатаСреза, Истина);
			ФИО = Новый Структура("Фамилия, Имя, Отчество, Представление",
			ДанныеФизическогоЛица.Фамилия,
			ДанныеФизическогоЛица.Имя,
			ДанныеФизическогоЛица.Отчество,
			ДанныеФизическогоЛица.Представление);
			
			ДанныеОтветственныхЛиц.Руководитель               = РеквизитыОрганизации.ИндивидуальныйПредприниматель;
			ДанныеОтветственныхЛиц.РуководительДолжность      = "";
			ДанныеОтветственныхЛиц.РуководительФИО            = ФИО;
			ДанныеОтветственныхЛиц.РуководительПредставление  = ДанныеФизическогоЛица.Представление;
			
		КонецЕсли;

		Если СобиратьПоОрганизации Тогда

			ЗапросПоЛицам.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо.Наименование КАК ФизическоеЛицоПредставление,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность.Наименование КАК ДолжностьПредставление
			|ИЗ
			|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ДатаСреза, СтруктурнаяЕдиница = &Организация) КАК ОтветственныеЛицаОрганизацийСрезПоследних";
			
			Руководители = ЗапросПоЛицам.Выполнить().Выбрать();
		Иначе

			// Создание таблицы иерархии подразделения.
			ТаблицаСтруктурныхЕдиниц = Новый ТаблицаЗначений;
			ТаблицаСтруктурныхЕдиниц.Колонки.Добавить("Порядок",            ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15));
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(Тип("СправочникСсылка.Организации"));
			МассивТипов.Добавить(БухгалтерскийУчетКлиентСерверПереопределяемый.ТипПодразделения());
			
			ТаблицаСтруктурныхЕдиниц.Колонки.Добавить("СтруктурнаяЕдиница", Новый ОписаниеТипов(МассивТипов));

			Порядок = 1;

			// Добавление подразделения.
			НоваяСтрока = ТаблицаСтруктурныхЕдиниц.Добавить();
			НоваяСтрока.Порядок            = Порядок;
			НоваяСтрока.СтруктурнаяЕдиница = Подразделение;

			// Добавление родителей подразделения.
			МассивПодразделений = ОбщегоНазначенияБПВызовСервера.ПолучитьСписокВышеСтоящихГрупп(Подразделение);
			Для Каждого РодительПодразделения Из МассивПодразделений Цикл

				Порядок = Порядок + 1;

				НоваяСтрока = ТаблицаСтруктурныхЕдиниц.Добавить();
				НоваяСтрока.Порядок            = Порядок;
				НоваяСтрока.СтруктурнаяЕдиница = РодительПодразделения;

			КонецЦикла;

			// Добавление организации.
			НоваяСтрока = ТаблицаСтруктурныхЕдиниц.Добавить();
			НоваяСтрока.Порядок            = Порядок + 1;
			НоваяСтрока.СтруктурнаяЕдиница = Организация;

			// Поиск наименьшей структурной единицы, для которой задано ответственное лицо.
			ЗапросПоЛицам.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			ЗапросПоЛицам.УстановитьПараметр("ВнешнийИсточник", ТаблицаСтруктурныхЕдиниц);
			ЗапросПоЛицам.Текст =
			"ВЫБРАТЬ
			|	ВнешнийИсточник.Порядок,
			|	ВнешнийИсточник.СтруктурнаяЕдиница
			|ПОМЕСТИТЬ ТаблицаСтруктурныхЕдиниц
			|ИЗ
			|	&ВнешнийИсточник КАК ВнешнийИсточник
			|ИНДЕКСИРОВАТЬ ПО
			|	СтруктурнаяЕдиница
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо КАК ОтветственноеЛицо,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность
			|ПОМЕСТИТЬ ОтветственныеЛицаОрганизацийСрезПоследних
			|ИЗ
			|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ДатаСреза, ) КАК ОтветственныеЛицаОрганизацийСрезПоследних
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	СтруктурнаяЕдиница,
			|	ОтветственноеЛицо
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	МИНИМУМ(ТаблицаСтруктурныхЕдиниц.Порядок) КАК Порядок,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо
			|ПОМЕСТИТЬ ОтветственныеЛица
			|ИЗ
			|	ТаблицаСтруктурныхЕдиниц КАК ТаблицаСтруктурныхЕдиниц
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтветственныеЛицаОрганизацийСрезПоследних КАК ОтветственныеЛицаОрганизацийСрезПоследних
			|		ПО ТаблицаСтруктурныхЕдиниц.СтруктурнаяЕдиница = ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница
			|
			|СГРУППИРОВАТЬ ПО
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо
			|;
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо
			|ИЗ
			|	ОтветственныеЛицаОрганизацийСрезПоследних
			|";
			МассивФизЛиц = ЗапросПоЛицам.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
			ЗапросПоЛицам.УстановитьПараметр("МассивФизЛиц", МассивФизЛиц);

			// Получение информации о должностях и ФИО ответственных лиц.
			ЗапросПоЛицам.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОтветственныеЛица.ОтветственноеЛицо,
			|	ТаблицаСтруктурныхЕдиниц.СтруктурнаяЕдиница,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо.Наименование КАК ФизическоеЛицоПредставление,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность КАК Должность,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность.Наименование КАК ДолжностьПредставление
			|ИЗ
			|	ОтветственныеЛица КАК ОтветственныеЛица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСтруктурныхЕдиниц КАК ТаблицаСтруктурныхЕдиниц
			|		ПО ОтветственныеЛица.Порядок = ТаблицаСтруктурныхЕдиниц.Порядок
			|		ЛЕВОЕ СОЕДИНЕНИЕ ОтветственныеЛицаОрганизацийСрезПоследних КАК ОтветственныеЛицаОрганизацийСрезПоследних
			|		ПО (ТаблицаСтруктурныхЕдиниц.СтруктурнаяЕдиница = ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница)
			|			И ОтветственныеЛица.ОтветственноеЛицо = ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо";
			Руководители = ЗапросПоЛицам.Выполнить().Выбрать();
		КонецЕсли;

		Пока Руководители.Следующий() Цикл

			Фамилия       = " ";
			Имя           = " ";
			Отчество      = " ";
			Представление = ОбщегоНазначенияБПВызовСервера.ФамилияИнициалыФизЛица(Руководители.ФизическоеЛицо, Фамилия, Имя, Отчество);

			ФИО = Новый Структура("Фамилия, Имя, Отчество, Представление", Фамилия, Имя, Отчество, Представление);

			Если Руководители.ОтветственноеЛицо      = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель Тогда
				ДанныеОтветственныхЛиц.Руководитель               			= Руководители.ФизическоеЛицо;
				ДанныеОтветственныхЛиц.РуководительДолжность      			= Руководители.Должность;
				ДанныеОтветственныхЛиц.РуководительДолжностьПредставление  	= Руководители.ДолжностьПредставление;
				ДанныеОтветственныхЛиц.РуководительФИО            			= ФИО;
				ДанныеОтветственныхЛиц.РуководительПредставление  			= Представление;

			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер Тогда
				ДанныеОтветственныхЛиц.ГлавныйБухгалтер           			= Руководители.ФизическоеЛицо;
				ДанныеОтветственныхЛиц.ГлавныйБухгалтерДолжность  			= Руководители.Должность;
				ДанныеОтветственныхЛиц.ГлавныйБухгалтерДолжностьПредставление= Руководители.ДолжностьПредставление;
				ДанныеОтветственныхЛиц.ГлавныйБухгалтерФИО        			= ФИО;
				ДанныеОтветственныхЛиц.ГлавныйБухгалтерПредставление  		= Представление;

			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы Тогда
				ДанныеОтветственныхЛиц.РуководительКадровойСлужбы						= Руководители.ФизическоеЛицо;
				ДанныеОтветственныхЛиц.РуководительКадровойСлужбыДолжность  			= Руководители.Должность;
				ДанныеОтветственныхЛиц.РуководительКадровойСлужбыДолжностьПредставление = Руководители.ДолжностьПредставление;
				ДанныеОтветственныхЛиц.РуководительКадровойСлужбыФИО        			= ФИО;
				ДанныеОтветственныхЛиц.РуководительКадровойСлужбыПредставление	  		= Представление;

			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Кассир Тогда
				ДанныеОтветственныхЛиц.Кассир                     			= Руководители.ФизическоеЛицо;
				ДанныеОтветственныхЛиц.КассирДолжность      		 		= Руководители.Должность;
				ДанныеОтветственныхЛиц.КассирДолжностьПредставление	 		= Руководители.ДолжностьПредставление;
				ДанныеОтветственныхЛиц.КассирФИО            		 		= ФИО;
				ДанныеОтветственныхЛиц.КассирПредставление  				= Представление;

			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры Тогда
				ДанныеОтветственныхЛиц.ОтветственныйЗаБухгалтерскиеРегистры    				= Руководители.ФизическоеЛицо;
				ДанныеОтветственныхЛиц.ОтветственныйЗаБухгалтерскиеРегистрыДолжность     	= Руководители.Должность;
				ДанныеОтветственныхЛиц.ОтветственныйЗаБухгалтерскиеРегистрыДолжностьПредставление = Руководители.ДолжностьПредставление;
				ДанныеОтветственныхЛиц.ОтветственныйЗаБухгалтерскиеРегистрыФИО 				= ФИО;
				ДанныеОтветственныхЛиц.ОтветственныйЗаБухгалтерскиеРегистрыПредставление 	= Представление;

			КонецЕсли;

		КонецЦикла;
		
		ЗапросПоЛицам.МенеджерВременныхТаблиц.Закрыть();

	КонецЕсли;

	Возврат ДанныеОтветственныхЛиц;

КонецФункции

// Функция возвращает массив с датами изменения в ответственных лицах.
//
Функция ДатыИзмененияОтветственныхЛицОрганизаций(Организация) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", 	Организация);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтветственныеЛицаОрганизаций.Период КАК Период
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|ГДЕ
	|	ОтветственныеЛицаОрганизаций.СтруктурнаяЕдиница = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтветственныеЛицаОрганизаций.Период
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|		ПО ОтветственныеЛицаОрганизаций.СтруктурнаяЕдиница = ПодразделенияОрганизаций.Ссылка
	|			И ПодразделенияОрганизаций.Владелец = &Организация
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Период
	|";
	
	МассивДат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Период");

	ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(МассивДат);

	Возврат МассивДат;

КонецФункции

// Функция собирает сведения о 
//
// Параметры:
//  Контрагент - контрагент, для которой нужно определить руководящих лиц.
//
Функция ОтветственныеЛицаКонтрагента(Контрагент, ДатаСреза) Экспорт

	Результат = Новый Структура("Руководитель, РуководительДолжность, РуководительФИО, РуководительПредставление, 
								|ГлавныйБухгалтер, ГлавныйБухгалтерДолжность, ГлавныйБухгалтерФИО, ГлавныйБухгалтерПредставление, 
								|Кассир, КассирДолжность, КассирФИО, КассирПредставление");

	Если ЗначениеЗаполнено(Контрагент) тогда

		ЗапросПоЛицам = Новый Запрос();
		ЗапросПоЛицам.УстановитьПараметр("ДатаСреза",   ДатаСреза);
		ЗапросПоЛицам.УстановитьПараметр("Контрагент", Контрагент);
		ЗапросПоЛицам.УстановитьПараметр("ПризнакФизЛица",   Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
		
		ЗапросПоЛицам.Текст = "ВЫБРАТЬ
		                      |	ФИОФизЛицСрезПоследних.Фамилия,
		                      |	ФИОФизЛицСрезПоследних.Имя,
		                      |	ФИОФизЛицСрезПоследних.Отчество,
		                      |	ФИОФизЛицСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо
		                      |ИЗ
		                      |	РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&ДатаСреза, ФизическоеЛицо = &Контрагент) КАК ФИОФизЛицСрезПоследних
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		                      |		ПО ФИОФизЛицСрезПоследних.ФизическоеЛицо = Контрагенты.Ссылка
		                      |			И (Контрагенты.ЮридическоеФизическоеЛицо = &ПризнакФизЛица)";
		
		Руководители = ЗапросПоЛицам.Выполнить().Выбрать();
		
		Пока Руководители.Следующий() Цикл
			
			ФИО = Новый Структура("Фамилия, Имя, Отчество, Представление", "", "", "", "");
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Фамилия) или Руководители.Фамилия = NULL) Тогда
				ФИО.Фамилия = Руководители.Фамилия;
			КонецЕсли;
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Имя) или Руководители.Имя = NULL) Тогда
				ФИО.Имя = Руководители.Имя;
			КонецЕсли;
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Отчество) или Руководители.Отчество = NULL) Тогда
				ФИО.Отчество = Руководители.Отчество;
			КонецЕсли;
			Представление = ОбщегоНазначенияБПВызовСервера.ФамилияИнициалыФизЛица(Руководители.ФизическоеЛицо, ФИО.Фамилия, ФИО.Имя, ФИО.Отчество);
			
			Результат.Руководитель               = Руководители.ФизическоеЛицо;
			Результат.РуководительДолжность      = "";
			Результат.РуководительФИО            = ФИО;
			Результат.РуководительПредставление  = Представление;
			
		КонецЦикла;
		
		ЗапросПоЛицам.Текст = 
		"ВЫБРАТЬ
		|	ОтветственныеЛицаКонтрагентовСрезПоследних.ОтветственноеЛицо,
		|	ОтветственныеЛицаКонтрагентовСрезПоследних.КонтактноеЛицо,
		|	ОтветственныеЛицаКонтрагентовСрезПоследних.КонтактноеЛицо.Должность КАК Должность,
		|	ОтветственныеЛицаКонтрагентовСрезПоследних.КонтактноеЛицо.Фамилия КАК Фамилия,
		|	ОтветственныеЛицаКонтрагентовСрезПоследних.КонтактноеЛицо.Имя КАК Имя,
		|	ОтветственныеЛицаКонтрагентовСрезПоследних.КонтактноеЛицо.Отчество КАК Отчество
		|ИЗ
		|	РегистрСведений.ОтветственныеЛицаКонтрагентов.СрезПоследних(&ДатаСреза, Контрагент = &Контрагент) КАК ОтветственныеЛицаКонтрагентовСрезПоследних";
		
		Руководители = ЗапросПоЛицам.Выполнить().Выбрать();

		Пока Руководители.Следующий() Цикл

			ФИО = Новый Структура("Фамилия, Имя, Отчество, Представление", "", "", "", "");
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Фамилия) или Руководители.Фамилия = NULL) Тогда
				ФИО.Фамилия = Руководители.Фамилия;
			КонецЕсли;
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Имя) или Руководители.Имя = NULL) Тогда
				ФИО.Имя = Руководители.Имя;
			КонецЕсли;
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Отчество) или Руководители.Отчество = NULL) Тогда
				ФИО.Отчество = Руководители.Отчество;
			КонецЕсли;
			Представление = ОбщегоНазначенияБПВызовСервера.ФамилияИнициалыФизЛица(Руководители.КонтактноеЛицо, ФИО.Фамилия, ФИО.Имя, ФИО.Отчество);
			
			Если Руководители.ОтветственноеЛицо      = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель Тогда
				Результат.Руководитель               = Руководители.КонтактноеЛицо;
				Результат.РуководительДолжность      = Руководители.Должность;
				Результат.РуководительФИО            = ФИО;
				Результат.РуководительПредставление  = Представление;

			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер Тогда
				Результат.ГлавныйБухгалтер           = Руководители.КонтактноеЛицо;
				Результат.ГлавныйБухгалтерДолжность  = Руководители.Должность;
                Результат.ГлавныйБухгалтерФИО        = ФИО;
				Результат.ГлавныйБухгалтерПредставление  = Представление;
				
			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Кассир Тогда
				Результат.Кассир                     = Руководители.КонтактноеЛицо;
				Результат.КассирДолжность      		 = Руководители.Должность;
                Результат.КассирФИО            		 = ФИО;
				Результат.КассирПредставление  = Представление;
				
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает массив с датами изменения в ответственных лицах контрагента.
//
Функция ДатыИзмененияОтветственныхЛицКонтрагента(Контрагент) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтветственныеЛицаКонтрагентов.Период КАК Период
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаКонтрагентов КАК ОтветственныеЛицаКонтрагентов
	|ГДЕ
	|	ОтветственныеЛицаКонтрагентов.Контрагент = &Контрагент
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Период
	|";
	
	МассивДат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Период");

	ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(МассивДат);

	Возврат МассивДат;

КонецФункции

// Функция возвращает структуру со сведениями об ответственных лицах.
//
// Параметры:
//  Организация - организация, для которой нужно определить ответственных лиц.
//	ДатаСреза - дата со временем, на которые необходимо определить сведения.
//	Подразделение - подразделение, для которого необходимо определить ответственных лиц.
//
// Возвращаемое значение:
//	Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида
//		"Руководитель" - СправочникСсылка.ФизическиеЛица
//		"РуководительФИО" - структура (Фамилия, Имя, Отчество, Представление)
//		"РуководительПредставление" - строка, Фамилия И.О.
//		"РуководительДолжность" - СправочникСсылка.Должности
//		"РуководительДолжностьПредставление" - строка, название должности
//
Функция ОтветственныеЛицаОбособленногоПодразделения(ОбособленноеПодразделениеОрганизации, ДатаСреза) Экспорт

	Результат = Новый Структура("Руководитель, РуководительДолжность, РуководительФИО, РуководительПредставление, 
								|ГлавныйБухгалтер, ГлавныйБухгалтерДолжность, ГлавныйБухгалтерФИО, ГлавныйБухгалтерПредставление, 
								|Кассир, КассирДолжность, КассирФИО, КассирПредставление");

	Если ЗначениеЗаполнено(ОбособленноеПодразделениеОрганизации) тогда

		ЗапросПоЛицам = Новый Запрос();
		ЗапросПоЛицам.УстановитьПараметр("ДатаСреза",   ДатаСреза);
		ЗапросПоЛицам.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", ОбособленноеПодразделениеОрганизации);
		
		ЗапросПоЛицам.Текст = 
		"ВЫБРАТЬ
		|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо,
		|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо,
		|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность,
		|	ФИОФизЛицСрезПоследних.Фамилия,
		|	ФИОФизЛицСрезПоследних.Имя,
		|	ФИОФизЛицСрезПоследних.Отчество
		|ИЗ
		|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ДатаСреза, СтруктурнаяЕдиница = &ОбособленноеПодразделениеОрганизации) КАК ОтветственныеЛицаОрганизацийСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&ДатаСреза) КАК ФИОФизЛицСрезПоследних
		|		ПО ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо = ФИОФизЛицСрезПоследних.ФизическоеЛицо";
		Руководители = ЗапросПоЛицам.Выполнить().Выбрать();

		Пока Руководители.Следующий() Цикл

			ФИО = Новый Структура("Фамилия, Имя, Отчество, Представление", "", "", "", "");
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Фамилия) или Руководители.Фамилия = NULL) Тогда
				ФИО.Фамилия = Руководители.Фамилия;
			КонецЕсли;
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Имя) или Руководители.Имя = NULL) Тогда
				ФИО.Имя = Руководители.Имя;
			КонецЕсли;
			Если НЕ ( НЕ ЗначениеЗаполнено(Руководители.Отчество) или Руководители.Отчество = NULL) Тогда
				ФИО.Отчество = Руководители.Отчество;
			КонецЕсли;
			Представление = ОбщегоНазначенияБПВызовСервера.ФамилияИнициалыФизЛица(Руководители.ФизическоеЛицо, ФИО.Фамилия, ФИО.Имя, ФИО.Отчество);
			
			Если Руководители.ОтветственноеЛицо      = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель Тогда
				Результат.Руководитель               = Руководители.ФизическоеЛицо;
				Результат.РуководительДолжность      = Руководители.Должность;
				Результат.РуководительФИО            = ФИО;
				Результат.РуководительПредставление  = Представление;

			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер Тогда
				Результат.ГлавныйБухгалтер           = Руководители.ФизическоеЛицо;
				Результат.ГлавныйБухгалтерДолжность  = Руководители.Должность;
                Результат.ГлавныйБухгалтерФИО        = ФИО;
				Результат.ГлавныйБухгалтерПредставление  = Представление;
				
			ИначеЕсли Руководители.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Кассир Тогда
				Результат.Кассир                     = Руководители.ФизическоеЛицо;
				Результат.КассирДолжность            = Руководители.Должность;
                Результат.КассирФИО            		 = ФИО;
				Результат.КассирПредставление  = Представление;
				
			КонецЕсли;

		КонецЦикла;
		
		Если НЕ ЗначениеЗаполнено(Результат.Кассир) ИЛИ НЕ ЗначениеЗаполнено(Результат.ГлавныйБухгалтер) ИЛИ НЕ ЗначениеЗаполнено(Результат.Руководитель) Тогда
			// Возможно, нужновзять информацию по организации
			Руководители = ОтветственныеЛица(ОбособленноеПодразделениеОрганизации.Владелец, ДатаСреза);
			
			Если НЕ ЗначениеЗаполнено(Результат.Руководитель) Тогда
				
				Результат.Руководитель               = Руководители.Руководитель;
				Результат.РуководительДолжность      = Руководители.РуководительДолжность;
				Результат.РуководительФИО            = Руководители.РуководительФИО;
				Результат.РуководительПредставление  = Руководители.РуководительПредставление;
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Результат.ГлавныйБухгалтер) Тогда
				
				Результат.ГлавныйБухгалтер           = Руководители.ГлавныйБухгалтер;
				Результат.ГлавныйБухгалтерДолжность  = Руководители.ГлавныйБухгалтерДолжность;
                Результат.ГлавныйБухгалтерФИО        = Руководители.ГлавныйБухгалтерФИО;
				Результат.ГлавныйБухгалтерПредставление  = Руководители.ГлавныйБухгалтерПредставление;
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Результат.Кассир) Тогда
				
				Результат.Кассир                     = Руководители.Кассир;
                Результат.КассирДолжность            = Руководители.КассирДолжность;
                Результат.КассирФИО            		 = Руководители.КассирФИО;
				Результат.КассирПредставление  		 = Руководители.КассирПредставление;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает массив с датами изменения в ответственных лицах обособленного подразделения.
//
Функция ДатыИзмененияОтветственныхЛицОбособленногоПодразделения(ОбособленноеПодразделениеОрганизации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", 	ОбособленноеПодразделениеОрганизации);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтветственныеЛицаОрганизаций.Период КАК Период
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|ГДЕ
	|	ОтветственныеЛицаОрганизаций.СтруктурнаяЕдиница = &ОбособленноеПодразделениеОрганизации
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Период
	|";
	
	МассивДат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Период");

	ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(МассивДат);

	Возврат МассивДат;

КонецФункции

// Возвращает ответственное лицо на складе на указанную дату.
//
Функция ОтветственноеЛицоНаСкладе(Склад, Дата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтветственныеЛицаСрезПоследних.ФизическоеЛицо КАК МОЛ
	|ИЗ
	|	РегистрСведений.ОтветственныеЛица.СрезПоследних(&Дата, СтруктурнаяЕдиница = &Склад) КАК ОтветственныеЛицаСрезПоследних";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() = 0 Тогда 
		Возврат Справочники.ФизическиеЛица.ПустаяСсылка();
	Иначе
		Возврат Результат[0].МОЛ;
	КонецЕсли;
	
КонецФункции
