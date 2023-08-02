﻿#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Справочники.БанковскиеСчета);
	СписокОбъектов.Добавить(Справочники.ДоговорыКонтрагентов);
	СписокОбъектов.Добавить(Справочники.Контрагенты);
	СписокОбъектов.Добавить(Справочники.КонтактныеЛица);
	СписокОбъектов.Добавить(Справочники.НематериальныеАктивы);
	СписокОбъектов.Добавить(Справочники.Номенклатура);
	СписокОбъектов.Добавить(Справочники.НоменклатурныеГруппы);
	СписокОбъектов.Добавить(Справочники.ОбъектыСтроительства);
	СписокОбъектов.Добавить(Справочники.Организации);
	СписокОбъектов.Добавить(Справочники.ОсновныеСредства);
	СписокОбъектов.Добавить(Справочники.ПодразделенияОрганизаций);
	СписокОбъектов.Добавить(Справочники.Склады);
	СписокОбъектов.Добавить(Справочники.СтатьиЗатрат);
	СписокОбъектов.Добавить(Справочники.Субконто);
	СписокОбъектов.Добавить(Справочники.ТиповыеОперации);
	СписокОбъектов.Добавить(Документы.АвансовыйОтчет);
	СписокОбъектов.Добавить(Документы.АктОбОказанииПроизводственныхУслуг);
	СписокОбъектов.Добавить(Документы.АктСверкиВзаиморасчетов);
	СписокОбъектов.Добавить(Документы.ВводВЭксплуатациюОС);
	СписокОбъектов.Добавить(Документы.ВводНачальныхОстатков);
//++ БУ ЗИК	
	СписокОбъектов.Добавить(Документы.ВводСведенийОбИндексированномДоходе);
//-- БУ ЗИК	
	СписокОбъектов.Добавить(Документы.ВозвратТоваровОтПокупателя);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровПоставщику);
	СписокОбъектов.Добавить(Документы.ВыработкаНМА);
	СписокОбъектов.Добавить(Документы.ВыработкаОС);
	СписокОбъектов.Добавить(Документы.ГТДИмпорт);
	СписокОбъектов.Добавить(Документы.Доверенность);
	СписокОбъектов.Добавить(Документы.ДокументРасчетовСКонтрагентом);
	СписокОбъектов.Добавить(Документы.ЗакрытиеМесяца);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаПокупкуПродажуВалюты);
	СписокОбъектов.Добавить(Документы.ИзменениеГрафиковАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИзменениеНалоговогоНазначенияЗапасов);
	СписокОбъектов.Добавить(Документы.ИзменениеНалоговогоНазначенияОС);
	СписокОбъектов.Добавить(Документы.ИзменениеНалоговогоНазначенияТЗР);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНачисленияАмортизацииНМА);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНачисленияАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСостоянияОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииНМА);
	СписокОбъектов.Добавить(Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНЗП);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНМА);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияРасчетовСКонтрагентами);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияТоваровНаСкладе);
	СписокОбъектов.Добавить(Документы.ИндексацияОС);
	СписокОбъектов.Добавить(Документы.КомплектацияНоменклатуры);
	СписокОбъектов.Добавить(Документы.КорректировкаДолга);
	СписокОбъектов.Добавить(Документы.КорректировкаОжидаемогоИПодтвержденногоНДС);
	СписокОбъектов.Добавить(Документы.МодернизацияНМА);
	СписокОбъектов.Добавить(Документы.МодернизацияОС);
	СписокОбъектов.Добавить(Документы.НалоговаяНакладная);
	СписокОбъектов.Добавить(Документы.НормированиеРасходовПоНалогуНаПрибыль);
	СписокОбъектов.Добавить(Документы.ОперацияБух);
	СписокОбъектов.Добавить(Документы.ОпределениеФинансовыхРезультатов);
	СписокОбъектов.Добавить(Документы.ОприходованиеТоваров);
//++ БУ ЗИК	
	СписокОбъектов.Добавить(Документы.ОтражениеЗарплатыВУчете);
//-- БУ ЗИК	
	СписокОбъектов.Добавить(Документы.ОтчетКомиссионераОПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетКомитентуОПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетОРозничныхПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетПроизводстваЗаСмену);
	СписокОбъектов.Добавить(Документы.Партия);
	СписокОбъектов.Добавить(Документы.ПартияМалоценныхАктивовВЭксплуатации);
	СписокОбъектов.Добавить(Документы.ПередачаМалоценныхАктивовВЭксплуатацию);
	СписокОбъектов.Добавить(Документы.ПередачаНМА);
	СписокОбъектов.Добавить(Документы.ПередачаОборудованияВМонтаж);
	СписокОбъектов.Добавить(Документы.ПередачаОС);
	СписокОбъектов.Добавить(Документы.ПередачаТоваров);
	СписокОбъектов.Добавить(Документы.ПеремещениеМалоценныхАктивовВЭксплуатации);
	СписокОбъектов.Добавить(Документы.ПеремещениеНМА);
	СписокОбъектов.Добавить(Документы.ПеремещениеОС);
	СписокОбъектов.Добавить(Документы.ПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ПереоценкаОС);
	СписокОбъектов.Добавить(Документы.ПереоценкаТоваровВРознице);
	СписокОбъектов.Добавить(Документы.ПерерасчетПропорциональногоНДСпоТоварамИОС);
	СписокОбъектов.Добавить(Документы.ПлатежноеПоручение);
	СписокОбъектов.Добавить(Документы.ПодготовкаКПередачеОС);
	СписокОбъектов.Добавить(Документы.ПокупкаПродажаВалюты);
	СписокОбъектов.Добавить(Документы.ПоступлениеДопРасходов);
	СписокОбъектов.Добавить(Документы.ПоступлениеИзПереработки);
	СписокОбъектов.Добавить(Документы.ПоступлениеНаРасчетныйСчет);
	СписокОбъектов.Добавить(Документы.ПоступлениеНМА);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваровУслуг);
	СписокОбъектов.Добавить(Документы.Приложение1КНалоговойНакладной);
	СписокОбъектов.Добавить(Документы.Приложение2КНалоговойНакладной);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуНМА);
	СписокОбъектов.Добавить(Документы.ПриходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РасходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РасчетыПоНалогуНаПрибыль);
	СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг);
	СписокОбъектов.Добавить(Документы.РеализацияУслугПоПереработке);
	СписокОбъектов.Добавить(Документы.РегистрацияАвансовВНалоговомУчете);
	СписокОбъектов.Добавить(Документы.РегистрацияВходящегоНалоговогоДокумента);
	СписокОбъектов.Добавить(Документы.РегистрацияСтоимостиПриобретенияОСПропорциональноОблагаемыхНДС);
	СписокОбъектов.Добавить(Документы.СписаниеМалоценныхАктивовИзЭксплуатации);
	СписокОбъектов.Добавить(Документы.СписаниеНМА);
	СписокОбъектов.Добавить(Документы.СписаниеОС);
	СписокОбъектов.Добавить(Документы.СписаниеСРасчетногоСчета);
	СписокОбъектов.Добавить(Документы.СписаниеТоваров);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПокупателю);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПоставщика);
	СписокОбъектов.Добавить(Документы.ТребованиеНакладная);
	СписокОбъектов.Добавить(Документы.УстановкаГарантийныхСроковНалоговыйУчет);
	СписокОбъектов.Добавить(Документы.УстановкаКоэффициентаПропорциональногоОтнесенияНДСНаКредит);
	СписокОбъектов.Добавить(Документы.УстановкаПорядкаЗакрытияПодразделений);
	СписокОбъектов.Добавить(Документы.УстановкаЦенНоменклатуры);
	
	//ерпс_Головченко Вадим
	СписокОбъектов.Добавить(Документы.ерпсАктПриемкиПередачиТоваров);
	//...ерпс_Головченко Вадим
	//ек++
	СписокОбъектов.Добавить(Документы.ерпсЗаявкаНаСозданиеАктовПриемкиПередачи);
	//
	
	СписокОбъектов.Добавить(ЖурналыДокументов.Деньги);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоМалоценнымАктивам);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоНМА);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоОС);
	СписокОбъектов.Добавить(ЖурналыДокументов.ЖурналОпераций);
	СписокОбъектов.Добавить(ЖурналыДокументов.ПроизводственныеДокументы);
	СписокОбъектов.Добавить(ЖурналыДокументов.СкладскиеДокументы); 
	
	//++ БУ ЗИК
	//~СписокОбъектов.Добавить(Документы.ДепонированиеЗарплаты);
	//-- БУ ЗИК	
	
	ЗарплатаКадры.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);	
	
КонецПроцедуры

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Используется в случае, когда необходимо сократить список форматов сохранения, предлагаемый пользователю
// перед сохранением печатной формы в файл, либо перед отправкой по почте.
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений - коллекция форматов сохранения:
//   * ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента - значение в платформе, соответствующее формату;
//   * Ссылка        - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//   * Представление - Строка - представление типа файла (заполняется из перечисления);
//   * Расширение    - Строка - тип файла для операционной системы;
//   * Картинка      - Картинка - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию: Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	Если НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.Деньги	
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоМалоценнымАктивам
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоНМА
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоОС
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ЖурналОпераций
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ПроизводственныеДокументы
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.СкладскиеДокументы Тогда
		НастройкиСписка.АвтоматическоеЗаполнение = Ложь;
	КонецЕсли;
	
//++ БУ ЗИК	
	ЗарплатаКадры.ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка);
//-- БУ ЗИК	
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// Может использоваться для постобработки всех печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
	ОтправкаПочтовыхСообщений.ЗаполнитьТемуПолучателяПисьма(ОбъектыПечати, ПечатныеФормы, ПараметрыОтправки, , ПараметрыВывода);
	
КонецПроцедуры

#КонецОбласти
