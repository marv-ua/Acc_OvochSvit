﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует движения по регистрам подсистемы
//
// Параметры:
//		Движения - коллекция движений регистратора
//		Отказ - признак отказа от заполнения движений
//		Организация
//		ПериодРегистрации
//		Начисления - таблица значений с колонками (не обязательно)
//			ФизическоеЛицо
//			Сотрудник
//			Подразделение
//			Начисление - ссылка на план видов расчета 
//			Сумма
//			ОтработаноДней - не обязательно
//			ОтработаноЧасов - не обязательно
//			ОплаченоДней - не обязательно
//			ОплаченоЧасов - не обязательно
//
//		Удержания - таблица значений с колонками
//			ФизическоеЛицо
//			Удержание - ссылка на план видов расчета 
//			Сумма
//			СуммаКорректировкиВыплаты
//
//		БазаУдержаний - таблица значений с колонками
//			ФизическоеЛицо
//			Сотрудник
//			Подразделение
//			Удержание - ссылка на план видов расчета 
//			Сумма - "вес" строки базы удержаний. В соответствии с данными 
//					весами и будет выполнено распределение удержаний 
//			
//		ПрочиеДоходы - таблица значений с колонками
//			Сотрудник
//			Подразделение
//			Начисление - ссылка на план видов расчета 
//			Сумма
//		ХарактерВыплаты - ПеречислениеСсылка.ХарактерВыплатыЗарплаты
//			Незаполненное значение - признак того, что регистрировать 
//			данные в подсистеме взаиморасчетов не требуется
//		ЗаписыватьДвижения - (необязательный), булево, по умолчанию Ложь, 
//			если Истина — наборы записей будут записаны после заполнения
//
//		Допустимо присутствие других колонок в передаваемых таблицах значений
//
Процедура ЗарегистрироватьНачисленияУдержания(Движения, Отказ, Организация, ПериодРегистрации, Начисления, Удержания, БазаУдержаний, ПрочиеДоходы, ХарактерВыплаты = НеОпределено, ЗаписыватьДвижения = Ложь) Экспорт
	
	//////////////////////НачисленияДляВзаиморасчетов = Движения.НачисленияУдержанияПоСотрудникам.ВыгрузитьКолонки("ФизическоеЛицо,Сотрудник,Подразделение,Сумма");
	//////////////////////НачисленияДляВзаиморасчетов.Колонки.Добавить("СуммаКорректировкиВыплаты",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	//////////////////////СтрокиНачислений = Новый Массив;
	//////////////////////
	//////////////////////УдержанияДляВзаиморасчетов = Движения.НачисленияУдержанияПоСотрудникам.ВыгрузитьКолонки("ФизическоеЛицо,Сотрудник,Подразделение,Сумма");
	//////////////////////УдержанияДляВзаиморасчетов.Колонки.Добавить("СуммаКорректировкиВыплаты",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	//////////////////////СтрокиУдержаний = Новый Массив;
	
	
	Если Начисления <> НеОпределено Тогда
		Для Каждого Строка Из Начисления Цикл
			
			НоваяСтрока = Движения.Начисления.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			
			НоваяСтрокаНУПС = Движения.НачисленияУдержанияПоСотрудникам.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНУПС, Строка);
			
			НоваяСтрокаНУПС.Период				= ПериодРегистрации;
			
			//////////////////////////СтрокиНачислений.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		Движения.Начисления.Записывать = Истина;
		Движения.НачисленияУдержанияПоСотрудникам.Записывать = Истина;
		
	КонецЕсли;
	
	Если Удержания <> НеОпределено Тогда
		
		Для Каждого Строка Из Удержания Цикл
			
			НоваяСтрока = Движения.Удержания.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			
			НоваяСтрокаНУПС = Движения.НачисленияУдержанияПоСотрудникам.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНУПС, Строка);
			
			НоваяСтрокаНУПС.Период				= ПериодРегистрации;
			
		КонецЦикла;
	
		Движения.Удержания.Записывать = Истина;
		Движения.НачисленияУдержанияПоСотрудникам.Записывать = Истина;
		
	КонецЕсли;
		
	Если ЗаписыватьДвижения Тогда
		Движения.Начисления.Записать();
		Движения.Начисления.Записывать = Ложь;
		Движения.Удержания.Записать();
		Движения.Удержания.Записывать = Ложь;
		Движения.НачисленияУдержанияПоСотрудникам.Записать();
		Движения.НачисленияУдержанияПоСотрудникам.Записывать = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

// Формирует движения по регистрам расчета при конвертации данных
//
Процедура ЗарегистрироватьДанныеРегистровРасчета(Регистратор, Отказ, Организация, НачисленияУдержания) Экспорт
	
	Движения = Регистратор.Движения;
	Если НачисленияУдержания <> Неопределено Тогда
		
		Для Каждого Строка Из НачисленияУдержания Цикл
			
			НоваяСтрокаНУПС = Движения.НачисленияУдержанияПоСотрудникам.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНУПС, Строка);
			НоваяСтрокаНУПС.Организация = Организация;
			
		КонецЦикла;
		
		Движения.НачисленияУдержанияПоСотрудникам.Записывать = Истина;
		Движения.НачисленияУдержанияПоСотрудникам.Записать(Ложь);
		
	КонецЕсли
	
КонецПроцедуры

// Формирует строки удержаний путем распределения исходной строки по сотрудникам и подразделениям
//
// Параметры:
//	Движения
//	ПериодРегистрации
//	ИсходнаяСтрока
//	СтрокиРаспределения
//	СтрокиУдержаний - массив строк, добавленных в движения как удержания
//	ВидУдержания - если задан конкретный вид удержания - прописывается он, если нет - берется из исходной строки
// Возвращаемое значение:
//	Истина, если удалось сформировать строки по переданные
//
Функция СформироватьСтрокиУдержаний(Движения, Организация, ПериодРегистрации, ИсходнаяСтрока, СтрокиРаспределения, СтрокиУдержаний, ВидУдержания = НеОпределено, РегистрацияВНалоговомОргане = Неопределено) Экспорт
	
	Коэффициенты = Новый Массив();
	Для Каждого Строка Из СтрокиРаспределения Цикл
		Коэффициенты.Добавить(Строка.Сумма);
	КонецЦикла;
	МассивСумм = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(ИсходнаяСтрока.Сумма, Коэффициенты);
	Если МассивСумм = НеОпределено Тогда
		Возврат Ложь;
	Конецесли;
	
	Для ИндексСтроки = 0 По СтрокиРаспределения.Количество() - 1 Цикл
		СтрокаРаспределения = СтрокиРаспределения[ИндексСтроки];
		НоваяСтрока = Движения.НачисленияУдержанияПоСотрудникам.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ИсходнаяСтрока);
		НоваяСтрока.Период			= ПериодРегистрации;
		НоваяСтрока.ПериодДействия	= ПериодРегистрации;
		НоваяСтрока.Организация		= Организация;
		НоваяСтрока.ФизическоеЛицо	= СтрокаРаспределения.ФизическоеЛицо;
		НоваяСтрока.Сотрудник		= СтрокаРаспределения.Сотрудник;
		НоваяСтрока.Подразделение	= СтрокаРаспределения.Подразделение;
		Если ВидУдержания = НеОпределено Тогда
			НоваяСтрока.НачислениеУдержание = ИсходнаяСтрока.Удержание;
		Иначе
			НоваяСтрока.НачислениеУдержание = ВидУдержания;
		КонецЕсли;
		Если РегистрацияВНалоговомОргане <> Неопределено Тогда
			НоваяСтрока.РегистрацияВНалоговомОргане = РегистрацияВНалоговомОргане;
		КонецЕсли;
		
		НоваяСтрока.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Удержано;
		НоваяСтрока.Сумма = МассивСумм[ИндексСтроки];
		СтрокиУдержаний.Добавить(НоваяСтрока);
		
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

// Отбирает строки из таблицы БазаРаспределения по условию на ФизическоеЛицо и Подразделение, если оно указано
//
Функция СтрокиРаспределенияПоБазе(ФизическоеЛицо, БазаРаспределения, Подразделение = Неопределено) Экспорт
	
	ОтборБазыРаспределения = Новый Структура;
	
	ОтборБазыРаспределения.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	Если Подразделение <> Неопределено Тогда
		ОтборБазыРаспределения.Вставить("Подразделение", Подразделение);
	КонецЕсли;
	
	Возврат БазаРаспределения.НайтиСтроки(ОтборБазыРаспределения);
	
КонецФункции

// Возвращает таблицу значений с колонками
//	ФизическоеЛицо
//	Сотрудник
//	Подразделение
//	Сумма
//
// Параметры:
//	Движения - движения регистратора, которые формируются в СформироватьДвижения
//	МассивФизическихЛиц
//	ПериодРегистрации
//	Организация
//
Функция ПолучитьБазуУдержаний(Движения, МассивФизическихЛиц, ПериодРегистрации, Организация) Экспорт
	
	// регистратор движений
	Регистратор = Движения.НачисленияУдержанияПоСотрудникам.Отбор.Регистратор.Значение;

	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 			= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.СписокФизическихЛиц 	= МассивФизическихЛиц;
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудниковОрганизаций);
	
	// получим данные о начислениях из других регистраторов
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НачисленияУдержания.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	НачисленияУдержания.Сотрудник,
	               |	НачисленияУдержания.Подразделение,
	               |	СУММА(НачисленияУдержания.Сумма) КАК Сумма
	               |ИЗ
	               |	РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержания
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиОрганизации КАК Сотрудники
	               |		ПО (Сотрудники.Сотрудник = НачисленияУдержания.Сотрудник)
	               |ГДЕ
	               |	НачисленияУдержания.Регистратор <> &Регистратор
	               |	И НачисленияУдержания.ГруппаНачисленияУдержанияВыплаты = ЗНАЧЕНИЕ(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
	               |	И НачисленияУдержания.Организация = &Организация
	               |	И НачисленияУдержания.Период = &ПериодРегистрации
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НачисленияУдержания.Сотрудник.ФизическоеЛицо,
	               |	НачисленияУдержания.Сотрудник,
	               |	НачисленияУдержания.Подразделение";
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации", ПериодРегистрации);
	
	БазаУдержаний = Запрос.Выполнить().Выгрузить();
	
	// дополним данными из текущих движений 
	Для Каждого Строка Из Движения.НачисленияУдержанияПоСотрудникам Цикл
		Если Строка.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Начислено Тогда
			Если МассивФизическихЛиц.Найти(Строка.ФизическоеЛицо) = НеОпределено Тогда
				Продолжить;
			Конецесли;
			СтрокиБазы = БазаУдержаний.НайтиСтроки(Новый Структура("Сотрудник,Подразделение", Строка.Сотрудник, Строка.Подразделение));
			Если СтрокиБазы.Количество() = 0 Тогда
				СтрокаБазы = БазаУдержаний.Добавить();
				СтрокаБазы.ФизическоеЛицо = Строка.ФизическоеЛицо;
				СтрокаБазы.Сотрудник = Строка.Сотрудник;
				СтрокаБазы.Подразделение = Строка.Подразделение;
				СтрокаБазы.Сумма = 0;
			Иначе
				СтрокаБазы = СтрокиБазы[0];
			КонецЕсли;
			СтрокаБазы.Сумма = СтрокаБазы.Сумма + Строка.Сумма;
		КонецЕсли;
				
	КонецЦикла;
	Возврат БазаУдержаний;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Формирует строки корректировок сумм к выплате путем распределения исходной строки по сотрудникам и подразделениям
//
// Параметры:
//	ИсходнаяСтрока
//	СтрокиРаспределения
//	СтрокиУдержаний - таблица значений, в которую добавляются строки корректировок
//
Функция СформироватьСтрокиКорректировки(ИсходнаяСтрока, СтрокиРаспределения, СтрокиУдержаний)
	
	Коэффициенты = Новый Массив();
	Для Каждого Строка Из СтрокиРаспределения Цикл
		Коэффициенты.Добавить(Строка.Сумма);
	КонецЦикла;
	МассивСумм = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(ИсходнаяСтрока.СуммаКорректировкиВыплаты, Коэффициенты);
	Если МассивСумм = НеОпределено Тогда
		Возврат Ложь;
	Конецесли;
	
	Для ИндексСтроки = 0 По СтрокиРаспределения.Количество() - 1 Цикл
		СтрокаРаспределения = СтрокиРаспределения[ИндексСтроки];
		НоваяСтрока = СтрокиУдержаний.Добавить();
		НоваяСтрока.ФизическоеЛицо = СтрокаРаспределения.ФизическоеЛицо;
		НоваяСтрока.Сотрудник = СтрокаРаспределения.Сотрудник;
		НоваяСтрока.Подразделение = СтрокаРаспределения.Подразделение;
		НоваяСтрока.СуммаКорректировкиВыплаты = МассивСумм[ИндексСтроки];
		
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

Процедура ЗарегистрироватьУдержанияБезРаспределения(Движения, Отказ, Организация, ПериодРегистрации, Удержания, ВидУдержания, ЗаписыватьДвижения = Ложь)
	
	Для Каждого СтрокаУдержания Из Удержания Цикл
		НоваяСтрока = Движения.НачисленияУдержанияПоСотрудникам.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаУдержания);
		НоваяСтрока.Период = ПериодРегистрации;
		НоваяСтрока.ПериодДействия = ПериодРегистрации;
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.НачислениеУдержание = ВидУдержания;
		НоваяСтрока.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Удержано;
	КонецЦикла;
	
	Движения.НачисленияУдержанияПоСотрудникам.Записывать = Истина;
	
	Если ЗаписыватьДвижения Тогда
		Движения.НачисленияУдержанияПоСотрудникам.Записать();
		Движения.НачисленияУдержанияПоСотрудникам.Записывать = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#Область ФормированиеПечатныхФорм

Функция РасчетныйЛистокПодробнее(ДокументОбъект, Модифицированность, МассивФизическихЛиц, ДатаОтчета) Экспорт
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.АвтоМасштаб = Истина;
	ДокументРезультат.ОтображатьЗаголовки = Ложь;
	ДокументРезультат.ОтображатьСетку = Ложь;
	
	Если ДокументОбъект.ПометкаУдаления Тогда
		ВызватьИсключение НСтр("ru='Документ помечен на удаление, отчет не будет сформирован';uk='Документ відмічений для вилучення, звіт не буде сформований'");
	Иначе
		
		Попытка
			
			НачатьТранзакцию();
			
			УстановитьПривилегированныйРежим(Истина);
			
			Если ТипЗнч(МассивФизическихЛиц) = Тип("Массив") Тогда
				ФизическиеЛицаОтчета = МассивФизическихЛиц;
			Иначе
				ФизическиеЛицаОтчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МассивФизическихЛиц);
			КонецЕсли;
			
			Если НЕ ДокументОбъект.Проведен ИЛИ Модифицированность Тогда
				
				ДокументОбъект.ДополнительныеСвойства.Вставить(
					"ФизическиеЛица", ФизическиеЛицаОтчета);
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				
			КонецЕсли;
			
			УстановитьПривилегированныйРежим(Ложь);
			
			НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
			
			ОтчетАнализНачисленийИУдержаний = Отчеты.АнализНачисленийИУдержаний.Создать();
			
			ОтчетАнализНачисленийИУдержаний.КомпоновщикНастроек.ЗагрузитьНастройки(
				ОтчетАнализНачисленийИУдержаний.СхемаКомпоновкиДанных.ВариантыНастроек.РасчетныйЛисток.Настройки);
			ОтчетАнализНачисленийИУдержаний.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", "РасчетныйЛисток");
	
			Отбор = ОтчетАнализНачисленийИУдержаний.КомпоновщикНастроек.Настройки.Отбор;
			Отбор.Элементы.Очистить();
			
			СтандартныйПериод = Новый СтандартныйПериод;
			СтандартныйПериод.ДатаНачала    = НачалоМесяца(ДатаОтчета);
			СтандартныйПериод.ДатаОкончания = КонецМесяца(ДатаОтчета);
			
			ОтчетАнализНачисленийИУдержаний.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Период", СтандартныйПериод);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Организация", ВидСравненияКомпоновкиДанных.Равно, ДокументОбъект.Организация);
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ФизическоеЛицо", ВидСравненияКомпоновкиДанных.ВСписке, ФизическиеЛицаОтчета);
			
			ОтчетАнализНачисленийИУдержаний.СкомпоноватьРезультат(ДокументРезультат);
			
			ОтменитьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			Если ПривилегированныйРежим() Тогда
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли; 
			
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru='Не удалось, сформировать отчет.';uk='Не вдалося, сформувати звіт.'") + " " + Инфо.Описание;

		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ДокументРезультат;
	
КонецФункции

#КонецОбласти
