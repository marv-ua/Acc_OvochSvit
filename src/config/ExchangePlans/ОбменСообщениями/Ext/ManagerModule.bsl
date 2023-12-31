﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
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
	
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Ложь;
	
	ИспользуемыеТранспортыСообщенийОбмена = Новый Массив;
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, необходимые для совместимости с БСП2.4.1-2.4.3.

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//	Настройки - Структура - Содержит настройки по умолчанию.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = "";
	
КонецПроцедуры

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Возвращаемое значение:
//	Строка - имя файла по умолчанию для выгрузки настроек обмена данными.
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для
//									разного состава настроек на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки узла. Возможно, например, использование
//						различных форм для разных версий корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//	СтруктураНастроек - Структура - структура отборов на узле плана обмена.
// 
Функция НастройкаОтборовНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает структуру значений по умолчанию для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для разного
//									состава значений по умолчанию на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки значений по умолчанию.
//						Возможно, например, использование различных форм для разных версий корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена.
// 
Функция ЗначенияПоУмолчаниюНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//	НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//										 полученная при помощи функции НастройкаОтборовНаУзле().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//	Строка - Строка описания ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания значений по умолчанию для пользователя;
// Прикладной разработчик на основе установленных значений по умолчанию на узле должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//	ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена,
//											полученная при помощи функции ЗначенияПоУмолчаниюНаУзле().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания значений по умолчанию в зависимости от версии корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//  Строка - строка описания для пользователя значений по умолчанию.
//
Функция ОписаниеЗначенийПоУмолчанию(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

// Устанавливает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//	Строка - представление команды, выводимое в пользовательском интерфейсе.
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат "";
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Определяет использование механизма регистрации объектов.
//
// Возвращаемое значение:
//	Булево - Истина - если механизм регистрации объектов необходимо использовать для текущего плана обмена.
//			 Ложь - если механизм регистрации объектов использовать не требуется.
//
Функция ИспользоватьМеханизмРегистрацииОбъектов() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
// Для планов обмена не РИБ функция возвращает пустую строку.
//
// Возвращаемое значение:
//  Строка - имя используемой формы.
//
// Пример:
//	Возврат "ПланОбмена.ОбменВРаспределеннойИнформационнойБазе.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена.
//
// Возвращаемое значение:
//	Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена.
//
// Пример:
//	1. Если план обмена поддерживает только два транспорта сообщений FILE и FTP,
//	то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
//	2. Если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
//	то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
	
	Возврат Результат;
	
КонецФункции

// Устанавливает признак использования плана обмена для организации обмена в модели сервиса.
// Если признак установлен, то в сервисе можно включить обмен данными
// с использованием этого плана обмена.
// Если признак не установлен, то план обмена будет использоваться только
// для обмена в локальном режиме работы конфигурации.
//
// Возвращаемое значение:
//	Булево - признак использования плана обмена в модели сервиса.
//
Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
// Возвращаемое значение:
//	Булево - признак возможности настройки обмена с корреспондентов в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает имена реквизитов и табличных частей плана обмена, перечисленных через запятую,
// которые являются общими для пары обменивающихся конфигураций.
//
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для разного
//									состава общих данных узлов в зависимости от версии корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки значений по умолчанию.
//						Возможно, например, использование различных форм для разных версий корреспондента.
//
// Возвращаемое значение:
//	Строка - Список имен реквизитов.
//
Функция ОбщиеДанныеУзлов(ВерсияКорреспондента, ИмяФормы) Экспорт
	
	Возврат "";
КонецФункции

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для
//									разного состава настроек на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки узла. Возможно, например, использование
//						различных форм для разных версий корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента.
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
КонецФункции

// Возвращает структуру значений по умолчанию для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для разного
//									состава значений по умолчанию на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки значений по умолчанию.
//						Возможно, например, использование различных форм для разных версий корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента.
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку
// описания ограничений  удобную для восприятия пользователем.
// 
// Параметры:
//	НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//	Строка - строка описания ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать
// строку описания
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания значений по умолчанию в зависимости от версии корреспондента.
//	ИдентификаторНастройки - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//  Строка - строка описания для пользователя значений по умолчанию.
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
КонецФункции

// Определяет текст пояснения для настройки параметров учета базы-корреспондента.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									пояснения для настройки параметров учета в зависимости от версии корреспондента.
// 
// Возвращаемое значение:
//  Строка - строка описания пояснения для настройки параметров учета базы-корреспондента.
//
Функция ПояснениеДляНастройкиПараметровУчетаБазыКорреспондента(ВерсияКорреспондента) Экспорт
	
	Возврат "";
КонецФункции

// Процедура предназначена для получения дополнительных данных, используемых при настройке обмена в базе-корреспонденте.
//
// Параметры:
//	ДополнительныеДанные - Структура - Дополнительные данные, которые будут использованы
//                        в базе-корреспонденте при настройке обмена.
//                        В качестве значений структуры применимы только значения, поддерживающие XDTO-сериализацию.
//
Процедура ПолучитьДополнительныеДанныеДляКорреспондента(ДополнительныеДанные) Экспорт
	
КонецПроцедуры

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
//  Параметры:
//     ВерсияКорреспондента - Строка - (только чтение) версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
//  Параметры:
// Отправитель - ПланОбменаОбъект - узел плана обмена, от имени которого выполняется отправка данных.
// Игнорировать - Булево - признак отказа от выгрузки данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то отправка данных узла выполнена не будет. Значение по умолчанию - Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель - ПланОбменаОбъект - узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать - Булево - признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию - Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Определяет текст пояснения для настройки параметров учета.
// 
// Возвращаемое значение:
//	Строка - строка описания пояснения для настройки параметров учета.
//
Функция ПояснениеДляНастройкиПараметровУчета() Экспорт
	
	Возврат "";
	
КонецФункции

// Проверяет корректность настройки параметров учета.
//
// Параметры:
//	Отказ - Булево - Признак невозможности продолжения настройки обмена из-за некорректно настроенных параметров учета.
//	Получатель - ПланОбменаСсылка - Узел обмена, для которого выполняется проверка параметров учета.
//	Сообщение - Строка - Содержит текст сообщения о некорректных параметрах учета.
//
Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли