﻿Функция ТекстЗапросаВТПериодыГПХ() Экспорт
	
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПоступлениеТоваровУслуг.Контрагент КАК ФизическоеЛицо,
	|	ПоступлениеТоваровУслуг.ДоговорКонтрагента.Дата КАК ДатаНачала,
	|	ПоступлениеТоваровУслуг.ДоговорКонтрагента.а_ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТПериодыГПХ
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&ДатаНач, &ДатаКон, Регистратор, , , СчетКт.Код = ""651"", , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|		ПО ХозрасчетныйОборотыДтКт.Регистратор = ПоступлениеТоваровУслуг.Ссылка
	|ГДЕ
	|	ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|
	|";
	
КонецФункции 

Функция ТектДополненияЗапросаЕСВГПХ() Экспорт
	Возврат "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслуг.Контрагент,
	|	ПоступлениеТоваровУслуг.Контрагент.КодПоЕДРПОУ,
	|	0,  
	|	НАЧАЛОПЕРИОДА(&ДатаНач, МЕСЯЦ),
	|	26,
	|	1,	
	|	ГПХФИО.Фамилия, 
	|	ГПХФИО.Имя,	
	|	ГПХФИО.Отчество,	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыЕСВ.ПоДоговорамГПХ) КАК ВидЕСВ, 
	|	СУММА(ВЫРАЗИТЬ(ПоступлениеТоваровУслуг.СуммаДокумента * 0.22 КАК ЧИСЛО(15,2))) КАК НалогФОТ, 
	|	0, 
	|	СУММА(ПоступлениеТоваровУслуг.СуммаДокумента), 
	|	СУММА(ПоступлениеТоваровУслуг.СуммаДокумента), 
	|	0, 
	|	0, 
	|	0, 
	|	NULL, 
	|	NULL, 
	|	0, 
	|	0,  
	|	0, 
	|	NULL, 
	|	0, 
//	|   ДлительностьТО.ПоДоговоруДни,
		|	ВЫБОР
		|		КОГДА ПериодыТО.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1)
		|				ИЛИ ПериодыТО.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ВЫБОР
		|					КОГДА ПериодыТО.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
		|						ТОГДА &ДнейВМесяце
		|					КОГДА ПериодыТО.ДатаОкончания > КОНЕЦПЕРИОДА(&ДатаНач, МЕСЯЦ)
		|						ТОГДА &ДнейВМесяце
		|				ИНАЧЕ ДЕНЬ(ПериодыТО.ДатаОкончания)
		|				КОНЕЦ - ВЫБОР
		|					КОГДА ПериодыТО.ДатаНачала = ДАТАВРЕМЯ(1, 1, 1) ИЛИ ПериодыТО.ДатаНачала < &ДатаНач 
		|						ТОГДА 1
		|					ИНАЧЕ ДЕНЬ(ПериодыТО.ДатаНачала)
		|				КОНЕЦ + 1
		|		ИНАЧЕ &ДнейВМесяце
		|	КОНЕЦ,
//
	|   0,
	|   0
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&ДатаНач, &ДатаКон, Регистратор, , , СчетКт.Код = ""651"", , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТГПХФИО КАК ГПХФИО
	|			ПО ГПХФИО.ФизическоеЛицо = ПоступлениеТоваровУслуг.Контрагент
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыГПХ КАК ПериодыТО
	|			ПО ПоступлениеТоваровУслуг.Контрагент = ПериодыТО.ФизическоеЛицо
	|		ПО ХозрасчетныйОборотыДтКт.Регистратор = ПоступлениеТоваровУслуг.Ссылка
	|ГДЕ
	|	ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровУслуг.Контрагент,
	|	ПоступлениеТоваровУслуг.Контрагент.КодПоЕДРПОУ,
	|  	ГПХФИО.Фамилия,
	|	ГПХФИО.Имя,
	|	ГПХФИО.Отчество,
	|	ВЫБОР
	|		КОГДА ПериодыТО.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1)
	|				ИЛИ ПериодыТО.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ВЫБОР
	|					КОГДА ПериодыТО.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА &ДнейВМесяце
	|					КОГДА ПериодыТО.ДатаОкончания > КОНЕЦПЕРИОДА(&ДатаНач, МЕСЯЦ)
	|						ТОГДА &ДнейВМесяце
	|				ИНАЧЕ ДЕНЬ(ПериодыТО.ДатаОкончания)
	|				КОНЕЦ - ВЫБОР
	|					КОГДА ПериодыТО.ДатаНачала = ДАТАВРЕМЯ(1, 1, 1) ИЛИ ПериодыТО.ДатаНачала < &ДатаНач 
	|						ТОГДА 1
	|					ИНАЧЕ ДЕНЬ(ПериодыТО.ДатаНачала)
	|				КОНЕЦ + 1
	|		ИНАЧЕ &ДнейВМесяце
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО";
КонецФункции

Функция ТекстДополненияЗапросаТаблица5() Экспорт
	
	Возврат "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслуг.Контрагент,
	|	1,
	|	0,//ГПХПоОснМестуРаботы
	|	3,
	|	ПоступлениеТоваровУслуг.Контрагент.КодПоЕДРПОУ,
	|	ГПХФИО.Фамилия, 
	|	ГПХФИО.Имя,	
	|	ГПХФИО.Отчество,
	|   ВЫБОР 
	|   	КОГДА ГПХФИО.ДатаНачала МЕЖДУ &ДатаНач И &ДатаКон
	|			ТОГДА ГПХФИО.ДатаНачала
	|       ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|   КОНЕЦ КАК ДатаНачала,
	|   ВЫБОР 
	|   	КОГДА ГПХФИО.ДатаОкончания МЕЖДУ &ДатаНач И &ДатаКон
	|			ТОГДА ГПХФИО.ДатаОкончания
	|       ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|   КОНЕЦ КАК ДатаОкончания,
	|   ВЫБОР 
	|   	КОГДА ГПХФИО.ДатаНачала = ДАТАВРЕМЯ(1,1,1)
	|   	 ТОГДА ГПХФИО.ДатаОкончания
	|   	 ИНАЧЕ ГПХФИО.ДатаНачала
	|   КОНЕЦ КАК ДатаСортировки,
	|	0,
	|	0,
	|	"""",
	|	"""",
	|	"""",//Должность
	|	ПоступлениеТоваровУслуг.ДоговорКонтрагента.Номер,//НомерПриказа
	|	ГПХФИО.ДатаНачала,//ДатаПриказа    
	|	ВЫБОР КОГДА ГПХФИО.ДатаОкончания > &ДатаКон ТОГДА """" ИНАЧЕ ""ст.846 ЦКУ"" КОНЕЦ,//СтатьяЗакона
	|	ДАТАВРЕМЯ(1,1,1)//ДатаСозданияРабочегоМеста	
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&ДатаНач, &ДатаКон, Регистратор, , , СчетКт.Код = ""651"", , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТГПХФИО КАК ГПХФИО
	|			ПО ГПХФИО.ФизическоеЛицо = ПоступлениеТоваровУслуг.Контрагент
	|		ПО ХозрасчетныйОборотыДтКт.Регистратор = ПоступлениеТоваровУслуг.Ссылка
	|ГДЕ
	|	ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|	И (ГПХФИО.ДатаОкончания МЕЖДУ &ДатаНач И &ДатаКон ИЛИ ГПХФИО.ДатаНачала МЕЖДУ &ДатаНач И &ДатаКон)
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровУслуг.Контрагент,
	|	ПоступлениеТоваровУслуг.Контрагент.КодПоЕДРПОУ,
	|	ГПХФИО.Фамилия, 
	|	ГПХФИО.Имя,	
	|	ГПХФИО.Отчество,
	|   ВЫБОР 
	|   	КОГДА ГПХФИО.ДатаНачала МЕЖДУ &ДатаНач И &ДатаКон
	|			ТОГДА ГПХФИО.ДатаНачала
	|       ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|   КОНЕЦ,
	|   ВЫБОР 
	|   	КОГДА ГПХФИО.ДатаОкончания МЕЖДУ &ДатаНач И &ДатаКон
	|			ТОГДА ГПХФИО.ДатаОкончания
	|       ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|   КОНЕЦ,
	|   ВЫБОР 
	|   	КОГДА ГПХФИО.ДатаНачала = ДАТАВРЕМЯ(1,1,1)
	|   	 ТОГДА ГПХФИО.ДатаОкончания
	|   	 ИНАЧЕ ГПХФИО.ДатаНачала
	|   КОНЕЦ,
	|	ПоступлениеТоваровУслуг.ДоговорКонтрагента.Номер,
	|	ГПХФИО.ДатаНачала,
	|	ВЫБОР КОГДА ГПХФИО.ДатаОкончания > &ДатаКон ТОГДА """" ИНАЧЕ ""ст.846 ЦКУ"" КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО";  
		
КонецФункции

Процедура СоздатьВТГПХФИО(Запрос) Экспорт
	
	тз = Новый ТаблицаЗначений;
	Если Запрос.МенеджерВременныхТаблиц.Таблицы.Найти("ВТПериодыГПХ") = Неопределено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	ПоступлениеТоваровУслуг.Контрагент КАК ФизическоеЛицо,
		               |	ПоступлениеТоваровУслуг.ДоговорКонтрагента.Дата КАК ДатаНачала,
		               |	ПоступлениеТоваровУслуг.ДоговорКонтрагента.а_ДатаОкончания КАК ДатаОкончания
		               |ИЗ
		               |	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&ДатаНач, &ДатаКон, Регистратор, , , СчетКт.Код = ""651"", , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		               |		ПО ХозрасчетныйОборотыДтКт.Регистратор = ПоступлениеТоваровУслуг.Ссылка
		               |ГДЕ
		               |	ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг";
		тз = Запрос.Выполнить().Выгрузить();
	Иначе
		тз = Запрос.МенеджерВременныхТаблиц.Таблицы["ВТПериодыГПХ"].ПолучитьДанные().Выгрузить();
	КонецЕсли;
	
	Если тз.Колонки.Найти("ФизическоеЛицо") = Неопределено Тогда
		тз.Колонки.Добавить("ФизическоеЛицо", ПолучитьОписаниеТипа(Тип("СправочникСсылка.Контрагенты")));
	КонецЕсли;
	
	тз.Колонки.Добавить("Фамилия", ПолучитьОписаниеТипа(Тип("Строка"), Новый КвалификаторыСтроки(100)));
	тз.Колонки.Добавить("Имя", ПолучитьОписаниеТипа(Тип("Строка"), Новый КвалификаторыСтроки(100)));
	тз.Колонки.Добавить("Отчество", ПолучитьОписаниеТипа(Тип("Строка"), Новый КвалификаторыСтроки(100)));
	Для Каждого СтрТз Из тз Цикл
		Если Не ЗначениеЗаполнено(СтрТз.ФизическоеЛицо) Тогда
			Продолжить;
		КонецЕсли;
		
		ФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(СтрТз.ФизическоеЛицо.НаименованиеПолное);
		ЗаполнитьЗначенияСвойств(СтрТз, ФИО);
	КонецЦикла;
	
	Запрос.Текст = "ВЫБРАТЬ * 
	|ПОМЕСТИТЬ ВТГПХФИО
	|ИЗ &Таб КАК Т";
	Запрос.УстановитьПараметр("Таб", тз);
	
	Запрос.Выполнить();

КонецПроцедуры

Функция ПолучитьОписаниеТипа(Тип, Квалификатор = Неопределено)
	
	Если ТипЗнч(Тип) = Тип("Массив") Тогда
		МассивТипов = Тип;
	ИначеЕсли ТипЗнч(Тип) = Тип("Структура") Тогда
		МассивТипов = Новый Массив;
		Для Каждого КиЗ Из Тип Цикл
			МассивТипов.Добавить(КиЗ.Значение);
		КонецЦикла;
	Иначе
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип);
	КонецЕсли;
	
	Возврат Новый ОписаниеТипов(МассивТипов,,, Квалификатор);
	
КонецФункции