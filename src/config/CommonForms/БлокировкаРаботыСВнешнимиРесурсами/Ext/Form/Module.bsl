﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	СохраненныеПараметры = Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Получить().Получить();
	ПараметрыБлокировки = РегламентныеЗаданияСлужебный.ПараметрыБлокировкиРаботыСВнешнимиРесурсами();
	ЗаполнитьЗначенияСвойств(ПараметрыБлокировки, СохраненныеПараметры);
	
	Если Параметры.ПринятиеРешенияОБлокировке Тогда
		
		ТекстСнятияБлокировки = РегламентныеЗаданияСлужебный.ЗначениеНастройки("РасположениеКомандыСнятияБлокировки");
		РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
		ИзменилосьРазделение = ПараметрыБлокировки.РазделениеВключено <> РазделениеВключено;
		
		Если Не РазделениеВключено И Не ИзменилосьРазделение Тогда
			СохраненнаяСтрокаСоединения = ПараметрыБлокировки.СтрокаСоединения;
			ПараметрыСохраненнойСтрокиСоединения = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СохраненнаяСтрокаСоединения);
			Если ПараметрыСохраненнойСтрокиСоединения.Свойство("File") Тогда
				СохраненнаяСтрокаСоединения = ПараметрыСохраненнойСтрокиСоединения.File;
			КонецЕсли;
			ТекущаяСтрокаСоединения = СтрокаСоединения;
			ПараметрыТекущейСтрокиСоединения = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(ТекущаяСтрокаСоединения);
			Если ПараметрыТекущейСтрокиСоединения.Свойство("File") Тогда
				ТекущаяСтрокаСоединения = ПараметрыТекущейСтрокиСоединения.File;
			КонецЕсли;
			ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Размещение информационной базы изменилось с
                    |<b>%1</b>
                    |на 
                    |<b>%2</b>
                    |
                    |<a href = ""ЖурналРегистрации"">Техническая информация о причине блокировки</a>
                    |
                    |• Если информационная база будет использоваться для ведения учета, нажмите <b>Информационная база перемещена</b>.
                    |• При выборе варианта <b>Это копия информационной базы</b> работа со всеми внешними ресурсами
                    |  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
                    |  будет заблокирована для предотвращения конфликтов с основой информационной базой.
                    |
                    |%3'
                    |;uk='Розміщення інформаційної бази змінилося з
                    |<b>%1</b>
                    |на 
                    |<b>%2</b>
                    |
                    |<a href = ""ЖурналРегистрации"">Технічна інформація про причини блокування</a>
                    |
                    |• Якщо інформаційна база буде використовуватися для ведення обліку, натисніть <b>Інформаційна база переміщена</b>.
                    |• При виборі варіанта <b>Це копія інформаційної бази</b> робота зі всіма зовнішніми ресурсами
                    |(синхронізація даних, відправка пошти тощо), що виконується за розкладом,
                    |буде заблокована для запобігання конфліктів з основою інформаційною базою.
                    |
                    |%3'"), СохраненнаяСтрокаСоединения, ТекущаяСтрокаСоединения, ТекстСнятияБлокировки);
		ИначеЕсли Не РазделениеВключено И ИзменилосьРазделение Тогда
			ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Информационная база была загружена из приложения в Интернете
                    |
                    |• Если информационная база будет использоваться для ведения учета, нажмите <b>Информационная база перемещена</b>.
                    |• При выборе варианта <b>Это копия информационной базы</b> работа со всеми внешними ресурсами
                    |  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
                    |  будет заблокирована для предотвращения конфликтов с приложением в Интернете.
                    |
                    |%1'
                    |;uk='Інформаційна база була завантажена з додатку в Інтернеті
                    |
                    |• Якщо інформаційна база буде використовуватися для ведення обліку, натисніть <b>Інформаційна база переміщена</b>.
                    |• При виборі варіанту <b>Це копія інформаційної бази</b> робота зі всіма зовнішніми ресурсами
                    |(синхронізація даних, відправка пошти тощо), що виконується за розкладом,
                    |буде заблокована для запобігання конфліктів з додатком в Інтернеті.
                    |
                    |%1'"), ТекстСнятияБлокировки);
		ИначеЕсли РазделениеВключено И Не ИзменилосьРазделение Тогда
			ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Приложение было перемещено
                    |
                    |• Если приложение будет использоваться для ведения учета, нажмите <b>Приложение перемещено</b>.
                    |• При выборе варианта <b>Это копия приложения</b> работа со всеми внешними ресурсами
                    |  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
                    |  будет заблокирована для предотвращения конфликтов с приложением в Интернете.
                    |
                    |%1'
                    |;uk='Прикладну програму був переміщений
                    |
                    |• Якщо прикладна програма буде використовуватися для ведення обліку, натисніть <b>Прикладну програму переміщено</b>.
                    |• При виборі варіанта <b>Це копія прикладної програми</b> робота зі всіма зовнішніми ресурсами
                    |(синхронізація даних, відправка пошти тощо), що виконується за розкладом,
                    |буде заблокована для запобігання конфліктів з прикладою програмою в Інтернеті.
                    |
                    |%1'"), ТекстСнятияБлокировки);
			Элементы.ИнформационнаяБазаПеремещена.Заголовок = НСтр("ru='Приложение перемещено';uk='Прикладну програму переміщено'");
			Элементы.ЭтоКопияИнформационнойБазы.Заголовок = НСтр("ru='Это копия приложения';uk='Це копія прикладної програми'");
			Заголовок = НСтр("ru='Приложение было перемещено или восстановлено из резервной копии';uk='Прикладну програму було переміщено або відновлено з резервної копії'");
		Иначе // Если РазделениеВключено И ИзменилосьРазделение
			ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Приложение было загружено из локальной версии
                    |
                    |• Если приложение будет использоваться для ведения учета, нажмите <b>Приложение перемещено</b>.
                    |• При выборе варианта <b>Это копия приложения</b> работа со всеми внешними ресурсами
                    |  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
                    |  будет заблокирована для предотвращения конфликтов с локальной версией.
                    |
                    |%1'
                    |;uk='Прикладна програма була завантажена з локальної версії
                    |
                    |• Якщо прикладна програма буде використовуватися для ведення обліку, натисніть <b>Прикладна програма переміщена</b>.
                    |• При виборі варіанта <b>Це копія прикладної програми</b> робота зі всіма зовнішніми ресурсами
                    |(синхронізація даних, відправка пошти тощо), що виконується за розкладом,
                    |буде заблокована для запобігання конфліктів з локальною версією.
                    |
                    |%1'"), ТекстСнятияБлокировки);
			Элементы.ИнформационнаяБазаПеремещена.Заголовок = НСтр("ru='Приложение перемещено';uk='Прикладну програму переміщено'");
			Элементы.ЭтоКопияИнформационнойБазы.Заголовок = НСтр("ru='Это копия приложения';uk='Це копія прикладної програми'");
			Заголовок = НСтр("ru='Приложение было перемещено или восстановлено из резервной копии';uk='Прикладну програму було переміщено або відновлено з резервної копії'");
		КонецЕсли;
		
		Элементы.НадписьПредупреждение.Заголовок = СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(ЗаголовокНадписи);
		
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединения) Тогда
			Элементы.ФормаГруппаЕще.Видимость = Ложь;
		Иначе
			Элементы.ФормаПроверятьИмяСервера.Пометка = ПараметрыБлокировки.ПроверятьИмяСервера;
			Элементы.ФормаСправка.Видимость = Ложь;
		КонецЕсли;
		
	Иначе
		Элементы.ГруппаПараметрыФормы.ТекущаяСтраница = Элементы.ГруппаПараметрыБлокировки;
		Элементы.НадписьПредупреждение.Видимость = Ложь;
		Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = Истина;
		ПроверятьИмяСервера = ПараметрыБлокировки.ПроверятьИмяСервера;
		Заголовок = НСтр("ru='Параметры блокировки работы с внешними ресурсами';uk='Параметри блокування роботи із зовнішніми ресурсами'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьПредупреждениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СобытиеЖурналаРегистрации",
		НСтр("ru='Работа с внешними ресурсами заблокирована';uk='Робота з зовнішніми ресурсами заблокована'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИнформационнаяБазаПеремещена(Команда)
	ИнформационнаяБазаПеремещенаНаСервере();
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
	ОбновитьИнтерфейс();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЭтоКопияИнформационнойБазы(Команда)
	ЭтоКопияИнформационнойБазыНаСервере();
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
	ОбновитьИнтерфейс();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьИмяСервера(Команда)
	ПараметрыБлокировки.ПроверятьИмяСервера = Не ПараметрыБлокировки.ПроверятьИмяСервера;
	Элементы.ФормаПроверятьИмяСервера.Пометка = ПараметрыБлокировки.ПроверятьИмяСервера;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьИЗакрытьНаСервере();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнформационнаяБазаПеремещенаНаСервере()
	
	РегламентныеЗаданияСлужебный.РазрешитьРаботуСВнешнимиРесурсами(ПараметрыБлокировки);
	
КонецПроцедуры

&НаСервере
Процедура ЭтоКопияИнформационнойБазыНаСервере()
	
	ЗависимостиЗаданий = РегламентныеЗаданияСлужебный.РегламентныеЗаданияЗависимыеОтФункциональныхОпций();
	НайденныеСтроки = ЗависимостиЗаданий.НайтиСтроки(Новый Структура("РаботаетСВнешнимиРесурсами", Истина));
	ОбработанныеЗадания = Новый Соответствие;
	
	Для Каждого СтрокаЗадания Из НайденныеСтроки Цикл
		Если ОбработанныеЗадания.Получить(СтрокаЗадания.РегламентноеЗадание) <> Неопределено Тогда
			Продолжить; // Задание уже было отключено.
		КонецЕсли;
		ОбработанныеЗадания.Вставить(СтрокаЗадания.РегламентноеЗадание);
		
		Отбор = Новый Структура;
		Отбор.Вставить("Использование", Истина);
		Отбор.Вставить("Метаданные", СтрокаЗадания.РегламентноеЗадание);
		Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
		
		ПараметрыЗадания = Новый Структура("Использование", Ложь);
		Для Каждого Задание Из Задания Цикл
			РегламентныеЗаданияСервер.ИзменитьЗадание(Задание.УникальныйИдентификатор, ПараметрыЗадания);
			ПараметрыБлокировки.ОтключенныеЗадания.Добавить(Задание.УникальныйИдентификатор);
		КонецЦикла;
		
	КонецЦикла;
	ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Истина;
	ХранилищеЗначения = Новый ХранилищеЗначения(ПараметрыБлокировки);
	Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Установить(ХранилищеЗначения);
	
	// Если это копия информационной базы, то необходимо обновить идентификатор.
	ИдентификаторИнформационнойБазы = Новый УникальныйИдентификатор();
	Константы.ИдентификаторИнформационнойБазы.Установить(Строка(ИдентификаторИнформационнойБазы));
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	ПараметрыБлокировки.ПроверятьИмяСервера = ПроверятьИмяСервера;
	ХранилищеЗначения = Новый ХранилищеЗначения(ПараметрыБлокировки);
	Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Установить(ХранилищеЗначения);
	
КонецПроцедуры

#КонецОбласти
