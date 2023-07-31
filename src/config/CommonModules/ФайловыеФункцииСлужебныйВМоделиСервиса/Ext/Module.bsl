﻿#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Извлечение текста

// Добавляет и удаляет записи в регистр сведений ОчередьИзвлеченияТекста при изменении
// состояние извлечения текста версий файлов.
//
// Параметры:
//	ИсточникТекста - СправочникСсылка.ВерсииФайлов, СправочникСсылка.*ПрисоединенныеФайлы,
//		файл, у которого изменилось состояние извлечения текста.
//	СостояниеИзвлеченияТекста - ПеречислениеСсылка.СтатусыИзвлеченияТекстаФайлов, новый
//		статус извлечения текста у файла.
//
Процедура ОбновитьСостояниеОчередиИзвлеченияТекста(ИсточникТекста, СостояниеИзвлеченияТекста) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ОчередьИзвлеченияТекста.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	НаборЗаписей.Отбор.ИсточникТекста.Установить(ИсточникТекста);
	
	Если СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен
			ИЛИ СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.ПустаяСсылка() Тогда
			
		Запись = НаборЗаписей.Добавить();
		Запись.ОбластьДанныхВспомогательныеДанные = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		Запись.ИсточникТекста = ИсточникТекста.Ссылка;
			
	КонецЕсли;
		
	НаборЗаписей.Записать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("РаботаСФайламиСлужебный.ИзвлечьТекстИзФайлов");
	СоответствиеИменПсевдонимам.Вставить("РаботаСФайламиСлужебный.ОчиститьНенужныеФайлы");
	СоответствиеИменПсевдонимам.Вставить("РаботаСФайламиСлужебный.РегламентнаяСинхронизацияФайловWebdav");
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииИспользованияРегламентныхЗаданий.
Процедура ПриОпределенииИспользованияРегламентныхЗаданий(ТаблицаИспользования) Экспорт
	
	НоваяСтрока = ТаблицаИспользования.Добавить();
	НоваяСтрока.РегламентноеЗадание = "ПланированиеИзвлеченияТекстаВМоделиСервиса";
	НоваяСтрока.Использование       = ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоиск");
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов.
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	ШаблоныЗаданий.Добавить("ОчисткаНенужныхФайлов");
	ШаблоныЗаданий.Добавить("СинхронизацияФайлов");
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ОчередьИзвлеченияТекста);
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.2.4";
	Обработчик.Процедура = "ФайловыеФункцииСлужебныйВМоделиСервиса.ЗаполнитьОчередьИзвлеченияТекста";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.19";
	Обработчик.Процедура = "ФайловыеФункцииСлужебныйВМоделиСервиса.ПеренестиОчередьИзвлеченияТекстаВоВспомогательныеДанные";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.4.3.89";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "ФайловыеФункцииСлужебныйВМоделиСервиса.ОчиститьРегистрСведенийУдалитьОчередьИзвлеченияТекста";
	Обработчик.РежимВыполнения = "Оперативно";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Извлечение текста

// Определяет перечень областей данных, в которых требуется извлечение текста и планирует
// для них его выполнение с использованием очереди заданий.
//
Процедура ОбработатьОчередьИзвлеченияТекста() Экспорт
	
	Если НЕ РаботаВМоделиСервиса.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ПланированиеИзвлеченияТекстаВМоделиСервиса);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяРазделенногоМетода = "РаботаСФайламиСлужебный.ИзвлечьТекстИзФайлов";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
	|	ВЫБОР
	|		КОГДА ЧасовыеПояса.Значение = """"
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЕСТЬNULL(ЧасовыеПояса.Значение, НЕОПРЕДЕЛЕНО)
	|	КОНЕЦ КАК ЧасовойПояс
	|ИЗ
	|	РегистрСведений.ОчередьИзвлеченияТекста КАК ОчередьИзвлеченияТекста
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ЧасовойПоясОбластиДанных КАК ЧасовыеПояса
	|		ПО ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные = ЧасовыеПояса.ОбластьДанныхВспомогательныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|		ПО ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные = ОбластиДанных.ОбластьДанныхВспомогательныеДанные
	|ГДЕ
	|	НЕ ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные В (&ОбрабатываемыеОбластиДанных)
	|	И ОбластиДанных.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбластейДанных.Используется)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОбрабатываемыеОбластиДанных", ОчередьЗаданий.ПолучитьЗадания(
		Новый Структура("ИмяМетода", ИмяРазделенногоМетода)));
	
	Выборка = РаботаВМоделиСервиса.ВыполнитьЗапросВнеТранзакции(Запрос).Выбрать();
	Пока Выборка.Следующий() Цикл
		// Проверка блокировки области.
		Если РаботаВМоделиСервиса.ОбластьДанныхЗаблокирована(Выборка.ОбластьДанных) Тогда
			// Область заблокирована, перейти к следующей записи.
			Продолжить;
		КонецЕсли;
		
		НовоеЗадание = Новый Структура();
		НовоеЗадание.Вставить("ОбластьДанных", Выборка.ОбластьДанных);
		НовоеЗадание.Вставить("ЗапланированныйМоментЗапуска", МестноеВремя(ТекущаяУниверсальнаяДата(), Выборка.ЧасовойПояс));
		НовоеЗадание.Вставить("ИмяМетода", ИмяРазделенногоМетода);
		ОчередьЗаданий.ДобавитьЗадание(НовоеЗадание);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Заполняет очередь извлечения текста для текущей области данных. Используется для начального заполнения при
// обновлении.
Процедура ЗаполнитьОчередьИзвлеченияТекста() Экспорт
	
	Если Не РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = РаботаСФайламиСлужебный.ТекстЗапросаДляИзвлеченияТекста(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьСостояниеОчередиИзвлеченияТекста(Выборка.Ссылка,
			Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен);
	КонецЦикла;
	
КонецПроцедуры

// Переносит флаг необходимости выполнения извлечения текста в областях
// данных из РС УдалитьОчередьИзвлеченияТекста в РС ОчередьИзвлеченияТекста.
//
Процедура ПеренестиОчередьИзвлеченияТекстаВоВспомогательныеДанные() Экспорт
	
	Если Не РаботаВМоделиСервиса.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		БлокировкаРегистра = Блокировка.Добавить("РегистрСведений.ОчередьИзвлеченияТекста");
		Блокировка.Заблокировать();
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные, УдалитьОчередьИзвлеченияТекста.ОбластьДанных) КАК ОбластьДанныхВспомогательныеДанные,
		|	ЕСТЬNULL(ОчередьИзвлеченияТекста.ИсточникТекста, УдалитьОчередьИзвлеченияТекста.ИсточникТекста) КАК ИсточникТекста
		|ИЗ
		|	РегистрСведений.УдалитьОчередьИзвлеченияТекста КАК УдалитьОчередьИзвлеченияТекста
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьИзвлеченияТекста КАК ОчередьИзвлеченияТекста
		|		ПО УдалитьОчередьИзвлеченияТекста.ОбластьДанных = ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные
		|			И УдалитьОчередьИзвлеченияТекста.ИсточникТекста = ОчередьИзвлеченияТекста.ИсточникТекста";
		Запрос = Новый Запрос(ТекстЗапроса);
		
		Набор = РегистрыСведений.ОчередьИзвлеченияТекста.СоздатьНаборЗаписей();
		Набор.Загрузить(Запрос.Выполнить().Выгрузить());
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Удаляет записи из регистра сведений УдалитьОчередьИзвлеченияТекста, если они там есть.
//
Процедура ОчиститьРегистрСведенийУдалитьОчередьИзвлеченияТекста() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УдалитьОчередьИзвлеченияТекста.ОбластьДанных
		|ИЗ
		|	РегистрСведений.УдалитьОчередьИзвлеченияТекста КАК УдалитьОчередьИзвлеченияТекста";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.УдалитьОчередьИзвлеченияТекста.СоздатьНаборЗаписей();
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
