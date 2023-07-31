﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс	
	
// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = ОбщегоНазначенияБП.ИмяКонфигурацииИсточника();
	Настройки.ИмяКонфигурацииПриемника.Вставить("BASSmallBusiness");
	Настройки.ИмяКонфигурацииПриемника.Вставить("BASSmallBusinessБазовая");
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
	// Если свойство установлено, в рабочих местах управления настройками не будет предлагаться настроить этот вид обмена.
	// Сущесвующие обмены этого вида будут продолжать отображаться в списке настроенных обменов.
	// Получении сообщения обмена в новом формате будет инициировать переход на новый вид обмена.
	Настройки.Вставить("ИмяПланаОбменаДляПереходаНаНовыйОбмен", "СинхронизацияДанныхЧерезУниверсальныйФормат");
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт

	//ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = "Настройки обмена для УНФ-БП";
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru='Настройки обмена для BAS МБ-BAS БУ';uk='Налаштування обміну для BAS МБ-BAS БУ'");
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = КраткаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПояснениеДляНастройкиПараметровУчета = ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки);
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru='BAS Малый бизнес, ред. 1.6';uk='BAS Малий бізнес, ред. 1.6'");
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "NetHelp\BASSmallBusiness\";
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "BASSmallBusiness";
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru='BAS Малый бизнес, ред. 1.6';uk='BAS Малий бізнес, ред. 1.6'");
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена =               НСтр("ru='Настройка синхронизации с программой ""BAS Малый бизнес, ред. 1.6""';uk='Налаштування синхронізації з програмою ""BAS Малий бізнес, ред. 1.6""'");
	ОписаниеВарианта.ЗаголовокУзлаПланаОбмена =                       НСтр("ru='Синхронизация с программой ""BAS Малый бизнес, ред. 1.6""';uk='Синхронізація з програмою ""BAS Малий бізнес, ред. 1.6""'");
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента =         НСтр("ru='BAS Малый бизнес, ред. 1.6';uk='BAS Малий бізнес, ред. 1.6'");

КонецПроцедуры

// УСТАРЕЛА. Следует использовать "ПриПолученииНастроек".
// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
// 
// Параметры:
//	Настройки - Структура - Сеодержит настройки по умолчанию
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ПутьКФайлуКомплектаПравилНаПользовательскомСайте = "";
	Настройки.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "NetHelp\BASSmallBusiness\";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//Дополнение к функционалу БСП

//Возвращает режим запуска, в случае интерактивного инициирования синхронизации
//Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
//На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает сценарий работы помощника интерактивного сопостовления
//НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
//Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
//Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Возврат Результат;
	
КонецФункции

Функция ОбщиеДанныеУзлов()
	
	Возврат "ДатаНачалаВыгрузкиДокументов, Организации, РежимВыгрузкиПриНеобходимости, РучнойОбмен";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru='	Перед выполнением обмена необходимо заполнить информацию об организациях, документы по которым будут загружены
|из приложения BAS Малый бизнес, а также заполнить счета учета по умолчанию в регистрах сведений Счета учета номенклатуры и Счета расчетов с контрагентами.
|Это необходимо для корректного проведения документов.';uk='	Перед виконанням обміну необхідно заповнити інформацію про організації, документи по яких будуть завантажені
|з додатку BAS Малий бізнес, а також заповнити рахунки обліку за замовчуванням в регістрах відомостей Рахунки обліку номенклатури і Рахунки розрахунків з контрагентами.
|Це необхідно для коректного проведення документів.'"); 
	
	Возврат ПоясняющийТекст;
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru='Позволяет синхронизировать данные между приложениями ""BAS Малый бизнес"", ред. 1.6 и ""BAS Бухгалтерия"", ред. 2.1.
                            |Из приложения ""BAS Малый бизнес"" в приложение ""BAS Бухгалтерия"" переносятся справочники и все необходимые документы, а 
                            |из приложения ""BAS Бухгалтерия"" в приложение ""BAS Малый бизнес"" - справочники и документы учета денежных средств.';uk= 'Дозволяє синхронізувати дані між додатками ""BAS Малий бізнес"", ред. 1.6 і ""BAS Бухгалтерія"", ред. 2.1.
                            |З додатку ""BAS Малий бізнес"" в додаток ""BAS Бухгалтерія"" переносяться довідники і усі необхідні документи, а 
                            |з додатку ""BAS Бухгалтерія"" в додаток ""BAS Малий бізнес"" - довідники і документи обліку грошових коштів.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции // КраткаяИнформацияПоОбмену()

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("РаботаВМоделиСервиса") Тогда
		ПутьКИнформацииПоОбмену = "https://its.bas-soft.eu/db/metodbasu#content:211108:hdoc";
	Иначе
		ПутьКИнформацииПоОбмену = "ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерияBAS.Форма.ПодробнаяИнформация";
	КонецЕсли;
	
	Возврат ПутьКИнформацииПоОбмену;
	
КонецФункции

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется отправка данных.
// Игнорировать – Булево – признак отказа от выгрузки данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то отправка данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать – Булево – признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли