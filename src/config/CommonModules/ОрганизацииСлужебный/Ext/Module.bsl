﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Организации".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Заполняет состав видов доступа, используемых при ограничении прав объектов метаданных.
// Если состав видов доступа не заполнен, отчет "Права доступа" покажет некорректные сведения.
//
// Обязательно требуется заполнить только виды доступа, используемые
// в шаблонах ограничения доступа явно, а виды доступа, используемые
// в наборах значений доступа могут быть получены из текущего состояния
// регистра сведений НаборыЗначенийДоступа.
//
//  Для автоматической подготовки содержимого процедуры следует
// воспользоваться инструментами разработчика для подсистемы
// Управление доступом.
//
// Параметры:
//  Описание     - Строка, многострочная строка формата <Таблица>.<Право>.<ВидДоступа>[.Таблица объекта]
//                 Например, Документ.ПриходнаяНакладная.Чтение.Организации
//                           Документ.ПриходнаяНакладная.Чтение.Контрагенты
//                           Документ.ПриходнаяНакладная.Изменение.Организации
//                           Документ.ПриходнаяНакладная.Изменение.Контрагенты
//                           Документ.ЭлектронныеПисьма.Чтение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Изменение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.Файлы.Чтение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Чтение.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Изменение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Изменение.Объект.Документ.ЭлектронноеПисьмо
//                 Вид доступа Объект предопределен, как литерал, его нет в предопределенных элементах
//                 ПланыВидовХарактеристик.ВидыДоступа. Этот вид доступа используется в шаблонах ограничений доступа,
//                 как "ссылка" на другой объект, по которому ограничивается таблица.
//                 Когда вид доступа "Объект" задан, также требуется задать типы таблиц, которые используются
//                 для этого вида доступа. Т.е. перечислить типы, которые соответствующие полю,
//                 использованному в шаблоне ограничения доступа в паре с видом доступа "Объект".
//                 При перечислении типов по виду доступа "Объект" нужно перечислить только те типы поля,
//                 которые есть у поля РегистрыСведений.НаборыЗначенийДоступа.Объект, остальные типы лишние.
// 
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	
	
КонецПроцедуры

// Заполняет виды доступа, используемые в ограничениях прав доступа.
// Виды доступа Пользователи и ВнешниеПользователи уже заполнены.
// Их можно удалить, если они не требуются для ограничения прав доступа.
//
// Параметры:
//  ВидыДоступа - ТаблицаЗначений с полями:
//  - Имя                    - Строка - имя используемое в описании поставляемых
//                             профилей групп доступа и текстах ОДД.
//  - Представление          - Строка - представляет вид доступа в профилях и группах доступа.
//  - ТипЗначений            - Тип - тип ссылки значений доступа.       Например, Тип("СправочникСсылка.Номенклатура").
//  - ТипГруппЗначений       - Тип - тип ссылки групп значений доступа. Например, Тип("СправочникСсылка.ГруппыДоступаНоменклатуры").
//  - НесколькоГруппЗначений - Булево - Истина указывает, что для значения доступа (Номенклатуры),
//                             можно выбрать несколько групп значений (Групп доступа номенклатуры).
//
Процедура ПриЗаполненииВидовДоступа(ВидыДоступа) Экспорт
	
	ВидДоступа = ВидыДоступа.Добавить();
	ВидДоступа.Имя = "Организации";
	ВидДоступа.Представление = НСтр("ru='Организации';uk='Організації'");
	ВидДоступа.ТипЗначений   = Тип("СправочникСсылка.Организации");
	
КонецПроцедуры

// Вызывается при переходе на версию конфигурации 2.1.3.16
//
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформацииОрганизаций() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроверкиАдреса = Новый Структура;
	ПараметрыПроверкиАдреса.Вставить("ТолькоНациональныйАдрес", 	 Истина);
	ПараметрыПроверкиАдреса.Вставить("ПроверятьКорректность",        Ложь);
	ПараметрыПроверкиАдреса.Вставить("СкрыватьНеактуальныеАдреса",   Ложь);
	ПараметрыПроверкиАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	
	ЯзыкЗаполнения = Локализация.КодЯзыкаИнформационнойБазы();
		
	ПараметрыГруппы = Новый Структура("Вид, Наименование", Справочники.ВидыКонтактнойИнформации.СправочникОрганизации, 
		НСтр("ru='Контактная информация справочника ""Организации""';uk='Контактна інформація довідника ""Організації""'", ЯзыкЗаполнения));
	УправлениеКонтактнойИнформацией.УстановитьСвойстваГруппыВидаКонтактнойИнформации(ПараметрыГруппы);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Юридический адрес';uk='Юридична адреса'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Истина;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Истина;
	ЗаполнитьЗначенияСвойств(ПараметрыВида.НастройкиПроверки, ПараметрыПроверкиАдреса);
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Фактический адрес';uk='Фактична адреса'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Истина;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Истина;
	ЗаполнитьЗначенияСвойств(ПараметрыВида.НастройкиПроверки, ПараметрыПроверкиАдреса);
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Почтовый адрес';uk='Поштова адреса'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Истина;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 3;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Телефон';uk='Телефон'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 4;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Факс);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ФаксОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Факс';uk='Факс'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 5;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.EmailОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Email';uk='Email'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 6;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ТелефонПоЮридическомуАдресуОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Телефон по юридическому адресу';uk='Телефон за юридичною адресою'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 7;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Истина;
	ПараметрыВида.Используется                      = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Другое);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияОрганизации;
	ПараметрыВида.Наименование	 					= НСтр("ru='Другое (любая другая контактная информация)';uk='Інше (будь-яка інша контактна інформація)'", ЯзыкЗаполнения);
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 8;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);	
	
КонецПроцедуры

// Обработчик подписки на событие ПроверитьЗначениеОпцииИспользоватьНесколькоОрганизаций.
// Вызывается при записи элемента справочника "Организации".
//
Процедура ПроверитьЗначениеОпцииИспользоватьНесколькоОрганизацийПриЗаписи(Источник, Отказ) Экспорт
	
	Если НЕ Источник.ЭтоГруппа
		И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций")
		И Справочники.Организации.КоличествоОрганизаций() > 1 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Константы.ИспользоватьНесколькоОрганизаций.Установить(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
