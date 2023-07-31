﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

// Процедуры и функции данного модуля позволяют выгружать и загружать
// границы последовательностей.

#Область ПрограммныйИнтерфейс

// Вызывается при регистрации произвольных обработчиков выгрузки данных.
//
// Параметры: ТаблицаОбработчиков - ТаблицаЗначений, в данной процедуре требуется
//  дополнить эту таблицу значений информацией о регистрируемых произвольных
//  обработчиках выгрузки данных. Колонки:
//    ОбъектМетаданных - ОбъектМетаданных, при выгрузке данных которого должен
//      вызываться регистрируемый обработчик,
//    Обработчик - ОбщийМодуль, общий модуль, в котором реализован произвольный
//      обработчик выгрузки данных. Набор экспортных процедур, которые должны
//      быть реализованы в обработчике, зависит от установки значений следующих
//      колонок таблицы значений,
//    Версия - Строка - номер версии интерфейса обработчиков выгрузки / загрузки данных,
//      поддерживаемого обработчиком,
//    ПередВыгрузкойТипа - Булево, флаг необходимости вызова обработчика перед
//      выгрузкой всех объектов информационной базы, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередВыгрузкойТипа(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        Сериализатор - СериализаторXDTO, инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПередВыгрузкойТипа() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        ОбъектМетаданных - ОбъектМетаданных, перед выгрузкой данных которого
//          был вызван обработчик,
//        Отказ - Булево. Если в процедуре ПередВыгрузкойТипа() установить значение
//          данного параметра равным Истина - выгрузка объектов, соответствующих
//          текущему объекту метаданных, выполняться не будет.
//    ПередВыгрузкойОбъекта - Булево, флаг необходимости вызова обработчика перед
//      выгрузкой конкретного объекта информационной базы. Если присвоено значение
//      Истина - в общем модуле обработчика должна быть реализована экспортируемая процедура
//      ПередВыгрузкойОбъекта(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        МенеджерВыгрузкиОбъекта - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы -
//          менеджер выгрузки текущего объекта. Подробнее см. комментарий к программному интерфейсу обработки
//          ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы. Параметр передается только при вызове
//          процедур обработчиков, для которых при регистрации указана версия не ниже 1.0.0.1,
//        Сериализатор - СериализаторXDTO, инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПередВыгрузкойОбъекта() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        Объект - КонстантаМенеджерЗначения.*, СправочникОбъект.*, ДокументОбъект.*,
//          БизнесПроцессОбъект.*, ЗадачаОбъект.*, ПланСчетовОбъект.*, ПланОбменаОбъект.*,
//          ПланВидовХарактеристикОбъект.*, ПланВидовРасчетаОбъект.*, РегистрСведенийНаборЗаписей.*,
//          РегистрНакопленияНаборЗаписей.*, РегистрБухгалтерииНаборЗаписей.*,
//          РегистрРасчетаНаборЗаписей.*, ПоследовательностьНаборЗаписей.*, ПерерасчетНаборЗаписей.* -
//          объект данных информационной базы, перед выгрузкой которого был вызван обработчик.
//          Значение, переданное в процедуру ПередВыгрузкойОбъекта() в качестве значения параметра
//          Объект может быть модифицировано внутри обработчика ПередВыгрузкойОбъекта(), при
//          этом внесенные изменения будут отражены в сериализации объекта в файлах выгрузки, но
//          не будут зафиксированы в информационной базе
//        Артефакты - Массив(ОбъектXDTO) - набор дополнительной информации, логически неразрывно
//          связанной с объектом, но не являющейся его частью (артефакты объекта). Артефакты должны
//          сформированы внутри обработчика ПередВыгрузкойОбъекта() и добавлены в массив, переданный
//          в качестве значения параметра Артефакты. Каждый артефакт должен являться XDTO-объектом,
//          для типа которого в качестве базового типа используется абстрактный XDTO-тип
//          {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//          помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных. В дальнейшем
//          артефакты, сформированные в процедуре ПередВыгрузкойОбъекта(), будут доступны в процедурах
//          обработчиков загрузки данных (см. комментарий к процедуре ПриРегистрацииОбработчиковЗагрузкиДанных().
//        Отказ - Булево. Если в процедуре ПередВыгрузкойОбъекта() установить значение
//           данного параметра равным Истина - выгрузка объекта, для которого был вызван обработчик,
//           выполняться не будет.
//    ПослеВыгрузкиТипа() - Булево, флаг необходимости вызова обработчика после выгрузки всех
//      объектов информационной базы, относящихся к данному объекту метаданных. Если присвоено значение
//      Истина - в общем модуле обработчика должна быть реализована экспортируемая процедура
//      ПослеВыгрузкиТипа(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        Сериализатор - СериализаторXDTO, инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПослеВыгрузкиТипа() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        ОбъектМетаданных - ОбъектМетаданных, после выгрузки данных которого
//          был вызван обработчик.
//
Процедура ПриРегистрацииОбработчиковВыгрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	Для Каждого Последовательность Из Метаданные.Последовательности Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = Последовательность;
		НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаДанныхГраницПоследовательностей;
		НовыйОбработчик.ПередВыгрузкойТипа = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
	
КонецПроцедуры

// См. описание к процедуре ПриДобавленииСлужебныхСобытий() общего модуля ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.
//
Процедура ПередВыгрузкойТипа(Контейнер, Сериализатор, ОбъектМетаданных, Отказ) Экспорт
	
	Если ОбщегоНазначенияБТС.ЭтоНаборЗаписейПоследовательности(ОбъектМетаданных) Тогда
		
		Отбор     = Новый Массив;
		Состояние = Неопределено;
		
		Пока Истина Цикл 
			
			МассивТаблиц = ТехнологияСервисаСлужебныйЗапросы.ПолучитьПорциюДанныхНезависимогоНабораЗаписей(ОбъектМетаданных, Отбор, 10000, Ложь, Состояние, ".Границы");
			Если МассивТаблиц.Количество() <> 0 Тогда
				
				ПерваяТаблица = МассивТаблиц.Получить(0);
				
				КоличествоЗаписей = ПерваяТаблица.Количество();
				
				ИмяФайла = Контейнер.СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.SequenceBoundary(), ОбъектМетаданных.ПолноеИмя());
				ВыгрузкаЗагрузкаДанныхСлужебный.ЗаписатьОбъектВФайл(ПерваяТаблица, ИмяФайла);
				Контейнер.УстановитьКоличествоОбъектов(ИмяФайла, КоличествоЗаписей);
				
				Продолжить;
				
			КонецЕсли;
			
			Прервать;
		
		КонецЦикла;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru='Объект метаданных %1 не может быть обработан обработчиком ВыгрузкаЗагрузкаДанныхГраницПоследовательностей.ПередВыгрузкойОбъекта()!';uk='Об''єкт метаданих %1 не може бути оброблений обробником ВыгрузкаЗагрузкаДанныхГраницПоследовательностей.ПередВыгрузкойОбъекта()!'"),
			ОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при регистрации произвольных обработчиков загрузки данных.
//
// Параметры: ТаблицаОбработчиков - ТаблицаЗначений, в данной процедуре требуется
//  дополнить эту таблицу значений информацией о регистрируемых произвольных
//  обработчиках загрузки данных. Колонки:
//    ОбъектМетаданных - ОбъектМетаданных, при загрузке данных которого должен
//      вызываться регистрируемый обработчик,
//    Обработчик - ОбщийМодуль, общий модуль, в котором реализован произвольный
//      обработчик загрузки данных. Набор экспортных процедур, которые должны
//      быть реализованы в обработчике, зависит от установки значений следующих
//      колонок таблицы значений,
//    Версия - Строка - номер версии интерфейса обработчиков выгрузки / загрузки данных,
//      поддерживаемого обработчиком,
//    ПередСопоставлениемСсылок - Булево, флаг необходимости вызова обработчика перед
//      сопоставлением ссылок (в исходной ИБ и в текущей), относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередСопоставлениемСсылок(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        ОбъектМетаданных - ОбъектМетаданных, перед сопоставлением ссылок которого
//          был вызван обработчик,
//        СтандартнаяОбработка - Булево. Если процедуре ПередСопоставлениемСсылок()
//          установить значение данного параметра равным Ложь, вместо стандартного
//          сопоставления ссылок (поиск объектов в текущей ИБ с теми же значениями
//          естественного ключа, которые были выгружены из ИБ-источника) будет
//          вызвана функция СопоставитьСсылки() общего модуля, в процедуре
//          ПередСопоставлениемСсылок() которого значение параметра СтандартнаяОбработка
//          было установлено равным Ложь.
//          Параметры функции СопоставитьСсылки():
//            Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//              контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//              к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//            ТаблицаИсходныхСсылок - ТаблицаЗначений, содержащая информацию о ссылках,
//              выгруженных из исходной ИБ. Колонки:
//                ИсходнаяСсылка - ЛюбаяСсылка, ссылка объекта исходной ИБ, которую требуется
//                  сопоставить c ссылкой в текущей ИБ,
//                Остальные колонки равным полям естественного ключа объекта, которые в
//                  процессе выгрузки данных были переданы в функцию
//                  Обработка.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы.ТребуетсяСопоставитьСсылкуПриЗагрузке()
//          Возвращаемое значение функции СопоставитьСсылки() - ТаблицаЗначений, колонки:
//            ИсходнаяСсылка - ЛюбаяСсылка, ссылка объекта, выгруженная из исходной ИБ,
//            Ссылка - ЛюбаяСсылка, сопоставленная исходной ссылка в текущей ИБ.
//        Отказ - Булево. Если в процедуре ПередСопоставлениемСсылок() установить значение
//          данного параметра равным Истина - сопоставление ссылок, соответствующих
//          текущему объекту метаданных, выполняться не будет.
//    ПередЗагрузкойТипа - Булево, флаг необходимости вызова обработчика перед
//      загрузкой всех объектов данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередЗагрузкойТипа(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        ОбъектМетаданных - ОбъектМетаданных, перед загрузкой всех данных которого
//          был вызван обработчик,
//        Отказ - Булево. Если в процедуре ПередЗагрузкойТипа() установить значение данного
//          параметра равным Истина - загрузка всех объектов данных соответствующих текущему
//          объекту метаданных выполняться не будет.
//    ПередЗагрузкойОбъекта - Булево, флаг необходимости вызова обработчика перед
//      загрузкой объекта данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередЗагрузкойОбъекта(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        Объект - КонстантаМенеджерЗначения.*, СправочникОбъект.*, ДокументОбъект.*,
//          БизнесПроцессОбъект.*, ЗадачаОбъект.*, ПланСчетовОбъект.*, ПланОбменаОбъект.*,
//          ПланВидовХарактеристикОбъект.*, ПланВидовРасчетаОбъект.*, РегистрСведенийНаборЗаписей.*,
//          РегистрНакопленияНаборЗаписей.*, РегистрБухгалтерииНаборЗаписей.*,
//          РегистрРасчетаНаборЗаписей.*, ПоследовательностьНаборЗаписей.*, ПерерасчетНаборЗаписей.* -
//          объект данных информационной базы, перед загрузкой которого был вызван обработчик.
//          Значение, переданное в процедуру ПередЗагрузкойОбъекта() в качестве значения параметра
//          Объект может быть модифицировано внутри процедуры обработчика ПередЗагрузкойОбъекта().
//        Артефакты - Массив(ОбъектXDTO) - дополнительные данные, логически неразрывно связанные
//          с объектом данных, но не являющиеся его частью. Сформированы в экспортируемых процедурах
//          ПередВыгрузкойОбъекта() обработчиков выгрузки данных (см. комментарий к процедуре
//          ПриРегистрацииОбработчиковВыгрузкиДанных(). Каждый артефакт должен являться XDTO-объектом,
//          для типа которого в качестве базового типа используется абстрактный XDTO-тип
//          {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//          помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных.
//        Отказ - Булево. Если в процедуре ПередЗагрузкойОбъекта() установить значение данного
//          параметра равным Истина - загрузка объекта данных выполняться не будет.
//    ПослеЗагрузкиОбъекта - Булево, флаг необходимости вызова обработчика после
//      загрузки объекта данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПослеЗагрузкиОбъекта(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        Объект - КонстантаМенеджерЗначения.*, СправочникОбъект.*, ДокументОбъект.*,
//          БизнесПроцессОбъект.*, ЗадачаОбъект.*, ПланСчетовОбъект.*, ПланОбменаОбъект.*,
//          ПланВидовХарактеристикОбъект.*, ПланВидовРасчетаОбъект.*, РегистрСведенийНаборЗаписей.*,
//          РегистрНакопленияНаборЗаписей.*, РегистрБухгалтерииНаборЗаписей.*,
//          РегистрРасчетаНаборЗаписей.*, ПоследовательностьНаборЗаписей.*, ПерерасчетНаборЗаписей.* -
//          объект данных информационной базы, после загрузки которого был вызван обработчик.
//        Артефакты - Массив(ОбъектXDTO) - дополнительные данные, логически неразрывно связанные
//          с объектом данных, но не являющиеся его частью. Сформированы в экспортируемых процедурах
//          ПередВыгрузкойОбъекта() обработчиков выгрузки данных (см. комментарий к процедуре
//          ПриРегистрацииОбработчиковВыгрузкиДанных(). Каждый артефакт должен являться XDTO-объектом,
//          для типа которого в качестве базового типа используется абстрактный XDTO-тип
//          {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//          помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных.
//    ПослеЗагрузкиТипа - Булево, флаг необходимости вызова обработчика после
//      загрузки всех объектов данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПослеЗагрузкиТипа(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        ОбъектМетаданных - ОбъектМетаданных, после загрузки всех объектов которого
//          был вызван обработчик.
//
Процедура ПриРегистрацииОбработчиковЗагрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	Для Каждого Последовательность Из Метаданные.Последовательности Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = Последовательность;
		НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаДанныхГраницПоследовательностей;
		НовыйОбработчик.ПослеЗагрузкиТипа = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
	
КонецПроцедуры

// См. описание к процедуре ПриДобавленииСлужебныхСобытий() общего модуля ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.
//
Процедура ПослеЗагрузкиТипа(Контейнер, ОбъектМетаданных) Экспорт
	
	Если ОбщегоНазначенияБТС.ЭтоНаборЗаписейПоследовательности(ОбъектМетаданных) Тогда
		
		МенеджерПоследовательности = ТехнологияСервисаИнтеграцияСБСП.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		
		ФайлыГраниц = Контейнер.ПолучитьФайлыИзКаталога(ВыгрузкаЗагрузкаДанныхСлужебный.SequenceBoundary(), ОбъектМетаданных.ПолноеИмя());
		
		Для Каждого ФайлГраниц Из ФайлыГраниц Цикл
			
			ТаблицаГраниц = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектИзФайла(ФайлГраниц);
			
			Для Каждого СтрокаТаблицы Из ТаблицаГраниц Цикл 
				
				КлючПоследовательности = ПолучитьКлючПоследовательности(ОбъектМетаданных, СтрокаТаблицы);
				
				МоментВремени = Новый МоментВремени(СтрокаТаблицы.Период, СтрокаТаблицы.Регистратор);
				МенеджерПоследовательности.УстановитьГраницу(МоментВремени, КлючПоследовательности);
				
			КонецЦикла;
			
		КонецЦикла;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru='Объект метаданных %1 не может быть обработан обработчиком ВыгрузкаЗагрузкаДанныхГраницПоследовательностей.ПередВыгрузкойОбъекта()!';uk='Об''єкт метаданих %1 не може бути оброблений обробником ВыгрузкаЗагрузкаДанныхГраницПоследовательностей.ПередВыгрузкойОбъекта()!'"),
			ОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует ключ для последовательности, который состоит из состава ее измерений.
//
// Параметры:
//	ОбъектМетаданных - ОбъектМетаданных - объект метаданных последовательности.
//	СтрокаТаблицы - СтрокаТаблицыЗначений - строка в которой хранятся записи границ последовательностей.
//
// Возвращаемое значение:
//	Структура - ключ последовательности: Ключ - имя измерения, Значение - значение измерения.
//
Функция ПолучитьКлючПоследовательности(Знач ОбъектМетаданных, Знач СтрокаТаблицы)
	
	КлючПоследовательности = Новый Структура;
	
	Для Каждого Поле Из ОбъектМетаданных.Измерения Цикл
		КлючПоследовательности.Вставить(Поле.Имя, СтрокаТаблицы[Поле.Имя]);
	КонецЦикла;
	
	Возврат КлючПоследовательности;
	
КонецФункции

#КонецОбласти