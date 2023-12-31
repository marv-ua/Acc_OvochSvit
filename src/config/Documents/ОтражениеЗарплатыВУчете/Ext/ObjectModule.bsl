﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ФорматОбмена30 Тогда 
		ПараметрыПроведения = Документы.ОтражениеЗарплатыВУчете.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		УчетЗарплаты.СформироватьДвиженияОтраженияЗарплаты(ПараметрыПроведения.ТаблицаОтраженияВУчете,
			ПараметрыПроведения.ТаблицаРеквизиты, Движения, Отказ);
	ИначеЕсли ЗарплатаОтраженаВБухучете Тогда
		ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
		
		ДанныеДляОтражения = Новый Структура;
		ДанныеДляОтражения.Вставить("ФорматОбмена30", ФорматОбмена30);
		ДанныеДляОтражения.Вставить("НачисленнаяЗарплатаИВзносы", НачисленнаяЗарплатаИВзносы.Выгрузить());
		ДанныеДляОтражения.Вставить("УдержанныйНДФЛ", УдержанныйНДФЛ.Выгрузить());
		ДанныеДляОтражения.Вставить("УдержаннаяЗарплата", УдержаннаяЗарплата.Выгрузить());
		ДанныеДляОтражения.Вставить("НачисленныеПроцентыПоЗаймам", НачисленныеПроцентыПоЗаймам.Выгрузить());
		
		ОтражениеЗарплатыВБухучетеПереопределяемый.СформироватьДвижения(ЭтотОбъект.Движения, Отказ, Организация, ПериодРегистрации, Дата, ДанныеДляОтражения);
	КонецЕсли;		

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("НачисленнаяЗарплатаИВзносы.СпособОтраженияЗарплатыВБухучете");
	
	СтруктураОтбора = Новый Структура("СпособОтраженияЗарплатыВБухучете", Справочники.СпособыОтраженияЗарплатыВРеглУчете.ПустаяСсылка());
	НайденныеСтроки = НачисленнаяЗарплатаИВзносы.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого Строка Из НайденныеСтроки Цикл
        
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.НачисленоОтпускныеРезерв 
			или Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.НачисленоЗаСчетФССДоход 
			или Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.НачисленоБольничные Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru='Не заполнена колонка ""Способ отражения"" в строке %1 списка ""Начисления и взносы""';uk='Не заповнена колонка ""Спосіб відображення"" в рядку %1 списку ""Нарахування та внески""'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "СпособОтраженияЗарплатыВБухучете"),
			,
			Отказ);
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ЗаполнитьПараметрыУдержанийОбъекта() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Удержания", УдержаннаяЗарплата.Выгрузить());
	Запрос.УстановитьПараметр("ДатаАктуальности", ПериодРегистрации); 
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка); 
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ИсполнительныеЛисты) КАК ВидОперации,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоИсполнительнымДокументам) КАК СчетУчета,
	|	ЛОЖЬ КАК АналитикаПоРаботникам,
	|	ИСТИНА КАК АналитикаПоКонтрагентам
	|ПОМЕСТИТЬ ВТСчетаПоОперациям
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ВозмещениеУщерба),
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоВозмещениюПричиненногоУщерба),
	|	ЛОЖЬ,
	|	ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ПочтовыйСбор),
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоИсполнительнымДокументам),
	|	ЛОЖЬ,
	|	ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ПрочиеУдержания),
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСДругимиКредиторамиВНациональнойВалюте),
	|	ЛОЖЬ,
	|	ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм),
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами),
	|	ИСТИНА,
	|	ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ПогашениеЗаймов),
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСРабочимиИСлужащимиПоДругимОперациям),
	|	ИСТИНА,
	|	ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ПроцентыПоЗайму),
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСРабочимиИСлужащимиПоДругимОперациям),
	|	ИСТИНА,
	|	ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	Удержания.ВидОперации КАК ВидОперации,
	|	Удержания.ФизическоеЛицо,
	|	Документы.Дата КАК Дата,
	|	Удержания.СчетУчета,
	|	Удержания.Субконто1,
	|	Удержания.Субконто2,
	|	Удержания.Субконто3,
	|	Удержания.Контрагент
	|ПОМЕСТИТЬ ВТАналитикаДругихДокументовУдержания
	|ИЗ
	|	Документ.ОтражениеЗарплатыВУчете.УдержаннаяЗарплата КАК Удержания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтражениеЗарплатыВУчете КАК Документы
	|		ПО Удержания.Ссылка = Документы.Ссылка
	|ГДЕ
	|	Удержания.Ссылка <> &ТекущийДокумент
	|	И Документы.ПериодРегистрации <= &ДатаАктуальности
	|	И Документы.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТАналитикаДругихДокументовУдержания.ВидОперации,
	|	ВТАналитикаДругихДокументовУдержания.ФизическоеЛицо,
	|	МАКСИМУМ(ВТАналитикаДругихДокументовУдержания.Дата) КАК Дата,
	|	ВТАналитикаДругихДокументовУдержания.Контрагент
	|ПОМЕСТИТЬ ВТЕдинственныеЗначенияАналитики
	|ИЗ
	|	ВТАналитикаДругихДокументовУдержания КАК ВТАналитикаДругихДокументовУдержания
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТАналитикаДругихДокументовУдержания.ФизическоеЛицо,
	|	ВТАналитикаДругихДокументовУдержания.ВидОперации,
	|	ВТАналитикаДругихДокументовУдержания.Контрагент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТАналитикаДругихДокументовУдержания.ВидОперации,
	|	ВТАналитикаДругихДокументовУдержания.ФизическоеЛицо,
	|	ВТАналитикаДругихДокументовУдержания.СчетУчета КАК СчетУчета,
	|	ВТАналитикаДругихДокументовУдержания.Субконто1 КАК Субконто1,
	|	ВТАналитикаДругихДокументовУдержания.Субконто2 КАК Субконто2,
	|	ВТАналитикаДругихДокументовУдержания.Субконто3 КАК Субконто3,
	|	ВТАналитикаДругихДокументовУдержания.Контрагент
	|ПОМЕСТИТЬ ВТЗаполненнаяАналитика
	|ИЗ
	|	ВТАналитикаДругихДокументовУдержания КАК ВТАналитикаДругихДокументовУдержания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЕдинственныеЗначенияАналитики КАК ВТЕдинственныеЗначенияАналитики
	|		ПО ВТЕдинственныеЗначенияАналитики.ВидОперации = ВТАналитикаДругихДокументовУдержания.ВидОперации
	|			И ВТЕдинственныеЗначенияАналитики.ФизическоеЛицо = ВТАналитикаДругихДокументовУдержания.ФизическоеЛицо
	|			И ВТЕдинственныеЗначенияАналитики.Дата = ВТАналитикаДругихДокументовУдержания.Дата
	|			И ВТАналитикаДругихДокументовУдержания.Контрагент = ВТЕдинственныеЗначенияАналитики.Контрагент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Удержания.ГруппаУчетаНачислений,
	|	Удержания.Сумма,
	|	Удержания.ВидОперации,
	|	Удержания.ФизическоеЛицо,
	|	Удержания.СчетУчета,
	|	Удержания.Субконто1,
	|	Удержания.Субконто2,
	|	Удержания.Субконто3,
	|	Удержания.Контрагент
	|ПОМЕСТИТЬ ВТУдержания
	|ИЗ
	|	&Удержания КАК Удержания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Удержания.ГруппаУчетаНачислений,
	|	Удержания.Сумма,
	|	Удержания.ВидОперации,
	|	Удержания.ФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА Удержания.СчетУчета <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|			ТОГДА Удержания.СчетУчета
	|		КОГДА ЗаполненнаяАналитика.СчетУчета ЕСТЬ NULL 
	|			ТОГДА ВТСчетаПоОперациям.СчетУчета
	|		ИНАЧЕ ЗаполненнаяАналитика.СчетУчета
	|	КОНЕЦ КАК СчетУчета,
	|	ВЫБОР
	|		КОГДА Удержания.СчетУчета <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|			ТОГДА Удержания.Субконто1
	|		КОГДА ЗаполненнаяАналитика.СчетУчета ЕСТЬ NULL 
	|				И ВТСчетаПоОперациям.АналитикаПоРаботникам
	|			ТОГДА Удержания.ФизическоеЛицо
	|		КОГДА ЗаполненнаяАналитика.СчетУчета ЕСТЬ NULL 
	|				И ВТСчетаПоОперациям.АналитикаПоКонтрагентам
	|			ТОГДА Удержания.Контрагент
	|		ИНАЧЕ ЗаполненнаяАналитика.Субконто1	
	|	КОНЕЦ КАК Субконто1,
	|	Удержания.Субконто2,
	|	Удержания.Субконто3,
	|	Удержания.Контрагент
	|ИЗ
	|	ВТУдержания КАК Удержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаполненнаяАналитика КАК ЗаполненнаяАналитика
	|		ПО Удержания.ВидОперации = ЗаполненнаяАналитика.ВидОперации
	|			И Удержания.ФизическоеЛицо = ЗаполненнаяАналитика.ФизическоеЛицо
	|			И Удержания.Контрагент = ЗаполненнаяАналитика.Контрагент
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСчетаПоОперациям КАК ВТСчетаПоОперациям
	|		ПО Удержания.ВидОперации = ВТСчетаПоОперациям.ВидОперации
	|;";

	УдержаннаяЗарплата.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры	

Процедура ЗаполнитьПараметрыПроцентовОбъекта() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Проценты", НачисленныеПроцентыПоЗаймам.Выгрузить());
	Запрос.УстановитьПараметр("ДатаАктуальности", ПериодРегистрации); 
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка); 
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	Удержания.ФизическоеЛицо,
	|	Документы.Дата КАК Дата,
	|	Удержания.СчетУчета,
	|	Удержания.Субконто1,
	|	Удержания.Субконто2,
	|	Удержания.Субконто3
	|ПОМЕСТИТЬ ВТАналитикаДругихДокументовПроценты
	|ИЗ
	|	Документ.ОтражениеЗарплатыВУчете.НачисленныеПроцентыПоЗаймам КАК Удержания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтражениеЗарплатыВУчете КАК Документы
	|		ПО Удержания.Ссылка = Документы.Ссылка
	|ГДЕ
	|	Удержания.Ссылка <> &ТекущийДокумент
	|	И Документы.ПериодРегистрации <= &ДатаАктуальности
	|	И Документы.Проведен

	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТАналитикаДругихДокументовПроценты.ФизическоеЛицо,
	|	МАКСИМУМ(ВТАналитикаДругихДокументовПроценты.Дата) КАК Дата
	|ПОМЕСТИТЬ ВТЕдинственныеЗначенияАналитики
	|ИЗ
	|	ВТАналитикаДругихДокументовПроценты КАК ВТАналитикаДругихДокументовПроценты
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТАналитикаДругихДокументовПроценты.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТАналитикаДругихДокументовПроценты.ФизическоеЛицо,
	|	ВТАналитикаДругихДокументовПроценты.СчетУчета КАК СчетУчета,
	|	ВТАналитикаДругихДокументовПроценты.Субконто1 КАК Субконто1,
	|	ВТАналитикаДругихДокументовПроценты.Субконто2 КАК Субконто2,
	|	ВТАналитикаДругихДокументовПроценты.Субконто3 КАК Субконто3
	|ПОМЕСТИТЬ ВТЗаполненнаяАналитика
	|ИЗ
	|	ВТАналитикаДругихДокументовПроценты КАК ВТАналитикаДругихДокументовПроценты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЕдинственныеЗначенияАналитики КАК ВТЕдинственныеЗначенияАналитики
	|		ПО ВТЕдинственныеЗначенияАналитики.ФизическоеЛицо = ВТАналитикаДругихДокументовПроценты.ФизическоеЛицо
	|			И ВТЕдинственныеЗначенияАналитики.Дата = ВТАналитикаДругихДокументовПроценты.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Проценты.ФизическоеЛицо,
	|	Проценты.Сумма,
	|	Проценты.СчетУчета,
	|	Проценты.Субконто1,
	|	Проценты.Субконто2,
	|	Проценты.Субконто3
	|ПОМЕСТИТЬ ВТНачисленныеПроцентыПоЗаймам
	|ИЗ
	|	&Проценты КАК Проценты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Проценты.ФизическоеЛицо,
	|	Проценты.Сумма,
	|	ВЫБОР
	|		КОГДА Проценты.СчетУчета <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|			ТОГДА Проценты.СчетУчета
	|		КОГДА ЗаполненнаяАналитика.СчетУчета ЕСТЬ NULL 
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПроцентыПолученные)
	|		ИНАЧЕ ЗаполненнаяАналитика.СчетУчета
	|	КОНЕЦ КАК СчетУчета,
	|	ВЫБОР
	|		КОГДА Проценты.СчетУчета <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|			ТОГДА Проценты.Субконто1
	|		КОГДА ЗаполненнаяАналитика.СчетУчета ЕСТЬ NULL 
	|			ТОГДА Неопределено
	|		ИНАЧЕ ЗаполненнаяАналитика.Субконто1	
	|	КОНЕЦ КАК Субконто1,
	|	Проценты.Субконто2,
	|	Проценты.Субконто3
	|ИЗ
	|	ВТНачисленныеПроцентыПоЗаймам КАК Проценты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаполненнаяАналитика КАК ЗаполненнаяАналитика
	|		ПО Проценты.ФизическоеЛицо = ЗаполненнаяАналитика.ФизическоеЛицо
	|";

	НачисленныеПроцентыПоЗаймам.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры	


#КонецЕсли
