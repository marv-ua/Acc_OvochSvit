﻿///////////////////////////////////////////////////////////////////////////////
// РАБОТА С БАНКОВСКИМИ ДОКУМЕНТАМИ

// Форматирует сумму банковского платежного документа
//
// Параметры:
//  Сумма - число - реквизит, который надо отформатировать
//  ВыводитьСуммуБезКопеек - булево - флаг представления суммы без копеек
//
// Возвращаемое значение
//  Отформатированная строка
//
Функция ФорматироватьСуммуПлатежногоДокумента(Сумма, ВыводитьСуммуБезКопеек = Ложь) Экспорт
	
	Результат  = Сумма;
	ЦелаяЧасть = Цел(Сумма);
	
	Если Результат = ЦелаяЧасть Тогда
		Если ВыводитьСуммуБезКопеек Тогда
			Результат = Формат(Результат, "ЧДЦ=2; ЧРД='='; ЧГ=0");
			Результат = Лев(Результат, Найти(Результат, "="));
		Иначе
			Результат = Формат(Результат, "ЧДЦ=2; ЧРД=','; ЧГ=0");
		КонецЕсли;
	Иначе
		Результат = Формат(Результат, "ЧДЦ=2; ЧРД=,; ЧГ=0");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ФорматироватьСуммуПлатежногоДокумента()

// Форматирует сумму прописью банковского платежного документа
//
// Параметры:
//  Сумма - число - реквизит, который надо представить прописью 
//  Валюта - СправочникСсылка.Валюты - валюта, в которой нужно представить сумму
//  ВыводитьСуммуБезКопеек - булево - флаг представления суммы без копеек
//
// Возвращаемое значение
//  Отформатированная строка
//
Функция ФорматироватьСуммуПрописьюПлатежногоДокумента(Сумма, Валюта, ВыводитьСуммуБезКопеек = Ложь) Экспорт
	
	Результат     = Сумма;
	ЦелаяЧасть    = Цел(Сумма);
	ФорматСтрока  = "Л=uk_UK; ДП=Ложь";
	ПарамПредмета = Валюта.ПараметрыПрописиНаУкраинском;
	
	Если Результат = ЦелаяЧасть Тогда
		Если ВыводитьСуммуБезКопеек Тогда
			Результат = ЧислоПрописью(Результат, ФорматСтрока, ПарамПредмета);
			Результат = Лев(Результат, Найти(Результат, "0") - 1);
		Иначе
			Результат = ЧислоПрописью(Результат, ФорматСтрока, ПарамПредмета);
		КонецЕсли;
	Иначе
		Результат = ЧислоПрописью(Результат, ФорматСтрока, ПарамПредмета);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ФорматироватьСуммуПрописьюПлатежногоДокумента()

// Формируется текст плательщика или получателя для печатной формы платежного документа
//
// Параметры
//  ТекстНаименования  	– <строка> – значение реквизита документа, если реквизит заполнен, он и выводится на печать
//  ВладелецСчета  		– <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> – владелец банковского счета
//  БанковскийСчет		– <СправочникСсылка.БанковскиеСчета> – банковский счет плательщика или получателя
//  ПеречислениеВБюджет	– <Булево> – флаг перечисления в бюджет
//
// Возвращаемое значение:
//   <Строка>			– наименование плательщика или получателя, которое будет выводиться в печатной форме платежного документа
//
Функция СформироватьТекстНаименованияПлательщикаПолучателя(ТекстНаименования, ВладелецСчета, БанковскийСчет) Экспорт
	
	ТекстРезультат = ТекстНаименования;
	Если ПустаяСтрока(ТекстРезультат) Тогда
		ЭтоОрганизация = ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Организации");
		
		Если ЗначениеЗаполнено(ВладелецСчета) Тогда
			СвойстваВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВладелецСчета,
				"Наименование, НаименованиеПолное");
		Иначе
			СвойстваВладельца = Новый Структура("Наименование, НаименованиеПолное",
				"", "");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(БанковскийСчет) Тогда
			СвойстваБанковскогоСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БанковскийСчет,
				"Банк, НомерСчета");
		Иначе
			СвойстваБанковскогоСчета = Новый Структура("Банк, НомерСчета",
				БанковскийСчет.Банк, "", "");
		КонецЕсли;
		
		ТекстРезультат = СокрЛП(СвойстваВладельца.НаименованиеПолное);
			
		Если ПустаяСтрока(ТекстРезультат) Тогда
			ТекстРезультат = СокрЛП(СвойстваВладельца.Наименование);
		КонецЕсли;
			
		
	КонецЕсли;
	
	Возврат ТекстРезультат;
	
КонецФункции // СформироватьТекстНаименованияПлательщикаПолучателя

// Формирует значения по умолчанию реквизитов плательщика и получателя для банковских платежных документов
//
// Параметры
//  Плательщик  		– <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> – плательщик, владелец банковского счета
//  СчетПлательщика		– <СправочникСсылка.БанковскиеСчета> – банковский счет плательщика
//  Получатель  		– <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> – получатель, владелец банковского счета
//  СчетПолучателя		– <СправочникСсылка.БанковскиеСчета> – банковский счет получателя
//
// Возвращаемое значение:
//   <Структура>		– структура строковых реквизитов плательщика и получателя
//						  ключи структуры: 
//							ТекстПлательщика, КодПоЕДРПОУОрганизации, 
//							ТекстПолучателя, КодПоЕДРПОУКонтрагента
//							НаименованиеБанкаПлательщика, НомерСчетаПлательщика, МФОБанкаПлательщика, СчетБанкаПлательщика 
//							НаименованиеБанкаПолучателя, НомерСчетаПолучателя, МФОБанкаПолучателя, СчетБанкаПолучателя
//
Функция СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(Плательщик, СчетПлательщика, Получатель, СчетПолучателя) Экспорт
	
	ЗначенияРеквизитов = Новый Структура;
	
	ЗначенияРеквизитов.Вставить("ТекстПлательщика", 
		СформироватьТекстНаименованияПлательщикаПолучателя(
	    	"", 
			Плательщик, 
			СчетПлательщика));
	
	Если ЗначениеЗаполнено(Плательщик) Тогда
		СвойстваПлательщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Плательщик,
			"ЮридическоеФизическоеЛицо, КодПоЕДРПОУ");
	Иначе
		СвойстваПлательщика = Новый Структура("ЮридическоеФизическоеЛицо, КодПоЕДРПОУ",
			Плательщик.ЮридическоеФизическоеЛицо, "", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетПлательщика) Тогда
		СвойстваСчетаПлательщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетПлательщика,
			"Владелец, Банк, НомерСчета");
	Иначе
		СвойстваСчетаПлательщика = Новый Структура("Владелец, Банк, НомерСчета",
			Неопределено, СчетПлательщика.Банк, "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Получатель) Тогда
		СвойстваПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель,
			"ЮридическоеФизическоеЛицо, КодПоЕДРПОУ");
	Иначе
		СвойстваПолучателя = Новый Структура("ЮридическоеФизическоеЛицо, КодПоЕДРПОУ",
			Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, "");

	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетПолучателя) Тогда
		СвойстваСчетаПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетПолучателя,
			"Владелец, Банк, НомерСчета, ТекстНазначения");
	Иначе
		СвойстваСчетаПолучателя = Новый Структура("Владелец, Банк, НомерСчета, ТекстНазначения",
			Неопределено, СчетПолучателя.Банк, "", "");
	КонецЕсли;
	
	ИндивидуальныйПредприниматель = ТипЗнч(Плательщик) = Тип("СправочникСсылка.Организации") И
		СвойстваПлательщика.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	
	ЗначенияРеквизитов.Вставить("КодПоЕДРПОУОрганизации", СвойстваПлательщика.КодПоЕДРПОУ);
	
	ПереводНаДругойСчет = ЗначениеЗаполнено(СчетПлательщика)
		И (СвойстваСчетаПолучателя.Владелец = СвойстваСчетаПлательщика.Владелец);
	Если ПереводНаДругойСчет Тогда
		ВладелецСчетаПолучателя = Плательщик;
		СвойстваВладельцаСчетаПолучателя = СвойстваПлательщика;
	Иначе
		ВладелецСчетаПолучателя = Получатель;
		СвойстваВладельцаСчетаПолучателя = СвойстваПолучателя;
	КонецЕсли;
	
	ЗначенияРеквизитов.Вставить("ТекстПолучателя", 
		СформироватьТекстНаименованияПлательщикаПолучателя(
	    	"", 
			ВладелецСчетаПолучателя, 
			СчетПолучателя));
	
	ПолучательФизЛицо = СвойстваВладельцаСчетаПолучателя.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	
	ЗначенияРеквизитов.Вставить("КодПоЕДРПОУКонтрагента", СвойстваВладельцаСчетаПолучателя.КодПоЕДРПОУ);
		
	БанкПлательщика = СвойстваСчетаПлательщика.Банк;
	ЗначенияРеквизитов.Вставить("НаименованиеБанкаПлательщика",БанкПлательщика.Наименование); 
	ЗначенияРеквизитов.Вставить("НомерСчетаПлательщика", СвойстваСчетаПлательщика.НомерСчета); 
	ЗначенияРеквизитов.Вставить("МФОБанкаПлательщика", БанкПлательщика.Код);
	ЗначенияРеквизитов.Вставить("СчетБанкаПлательщика", БанкПлательщика.КоррСчет);
	
	БанкПолучателя = СвойстваСчетаПолучателя.Банк;
	
	Если ЗначениеЗаполнено(БанкПолучателя) Тогда
		СвойстваБанкаПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БанкПолучателя,
			"Код, Наименование, КоррСчет, Город");
	Иначе
		СвойстваБанкаПолучателя = Новый Структура("Код, Наименование, КоррСчет, Город", "", "", "", "");
	КонецЕсли;
	
	ЗначенияРеквизитов.Вставить("НаименованиеБанкаПолучателя", СокрЛП(СвойстваБанкаПолучателя.Наименование));
	ЗначенияРеквизитов.Вставить("НомерСчетаПолучателя", СвойстваСчетаПолучателя.НомерСчета);
	ЗначенияРеквизитов.Вставить("МФОБанкаПолучателя", СвойстваБанкаПолучателя.Код);
	ЗначенияРеквизитов.Вставить("СчетБанкаПолучателя", СвойстваБанкаПолучателя.КоррСчет);
	
	ЗначенияРеквизитов.Вставить("ТекстНазначенияПлатежа", СвойстваСчетаПолучателя.ТекстНазначения);
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции //СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя

// Устанавливает банковский счет по умолчанию. Возвращает состояние установлен/не установлен
//
// Параметры
//  Счет				-	Текущее значение счета
//  ВладелецСчета  		–	<СправочникСсылка.Контрагенты (.Организации)> 
//							Контрагент (организация), счет которого нужно получить
//  Валюта  			–	<СправочникСсылка.Валюты>
//							Валюта регламентированного учета
//  СовпадениеВалюты	–	<Булево>
//                          признак совпадения нужной валюты с указанной, либо исключения ее из поиска
//							По умолчанию ищем счет с указанной валютой.
//
// Возвращаемое значение:
//   <СправочникСсылка.БанковскиеСчета> – найденный счет или пустая ссылка
//
Функция УстановитьБанковскийСчет(Счет, ВладелецСчета, Валюта, СовпадениеВалюты = Истина) Экспорт
	
	Если ТипЗнч(Счет) <> Тип("СправочникСсылка.БанковскиеСчета") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НовыйСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	БанковскиеСчета.Ссылка,
	|	ВЫБОР
	|		КОГДА СправочникВладелец.Ссылка ЕСТЬ НЕ NULL 
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК СправочникВладелец
	|		ПО БанковскиеСчета.Владелец = СправочникВладелец.Ссылка
	|			И БанковскиеСчета.Ссылка = СправочникВладелец.ОсновнойБанковскийСчет
	|ГДЕ
	|	БанковскиеСчета.Владелец = &ВладелецСчета
	|	И БанковскиеСчета.ПометкаУдаления = ЛОЖЬ
	|	И (БанковскиеСчета.ВалютаДенежныхСредств = &Валюта
	|				И &СовпадениеВалюты = ИСТИНА
	|			ИЛИ (НЕ БанковскиеСчета.ВалютаДенежныхСредств = &Валюта)
	|				И &СовпадениеВалюты = ЛОЖЬ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Запрос.УстановитьПараметр("ВладелецСчета",    ВладелецСчета);
	Запрос.УстановитьПараметр("Валюта",           Валюта);
	Запрос.УстановитьПараметр("СовпадениеВалюты", СовпадениеВалюты);
	
	Если ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Контрагенты") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Организации", "Справочник.Контрагенты");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Результат    = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НайденОсновнойСчет = Выборка.Приоритет = 1;
		НайденОдинСчет     = Выборка.Количество() = 1;
		
		Если НайденОсновнойСчет ИЛИ НайденОдинСчет Тогда
			НовыйСчет = Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ПолучитьНовыйСчет = Счет <> НовыйСчет;
	Если ПолучитьНовыйСчет Тогда
		Если НЕ ЗначениеЗаполнено(Счет) Тогда
			Счет = НовыйСчет;
		Иначе
			СвойствоСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Счет, "Владелец, ВалютаДенежныхСредств");
			Если СвойствоСчета.Владелец <> ВладелецСчета
				ИЛИ СовпадениеВалюты И СвойствоСчета.ВалютаДенежныхСредств <> Валюта Тогда
				Счет = НовыйСчет;
			Иначе
				ПолучитьНовыйСчет = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПолучитьНовыйСчет;
	
КонецФункции // УстановитьБанковскийСчет

// Заполняет реквизиты платежного документа значениями по умолчанию
//
Процедура ЗаполнитьРеквизитыПлатежногоДокумента(ДокументОбъект) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();

	ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();

	Если НЕ ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
		ДокументОбъект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;

	Если ОбщегоНазначенияБП.ЕстьНезаполненныйРеквизитДокумента("СтавкаНДС", ДокументОбъект, МетаданныеДокумента) Тогда
		ДокументОбъект.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента) Тогда
		ДокументОбъект.ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ДокументОбъект.СчетОрганизации)
	   И ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
	   УстановитьБанковскийСчет(ДокументОбъект.СчетОрганизации, ДокументОбъект.Организация, ДокументОбъект.ВалютаДокумента);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ДокументОбъект.СчетКонтрагента)
	   И ЗначениеЗаполнено(ДокументОбъект.Контрагент) Тогда
	   УстановитьБанковскийСчет(ДокументОбъект.СчетКонтрагента, ДокументОбъект.Контрагент, ДокументОбъект.ВалютаДокумента);
	КонецЕсли;

КонецПроцедуры 


// Возвращает список программ типа "Клиент банка"
//
// Параметры
//  Нет
//
// Возвращаемое значение:
//   <СписокЗначений>   - список наименований программ
//
Функция СписокСовместимыхПрограммКлиентовБанка(ВернутьВМассиве = Истина) Экспорт

	Если ВернутьВМассиве Тогда
		СписокКБ = Новый Массив;
	Иначе
		СписокКБ = Новый СписокЗначений;
	КонецЕсли; 
	
	СписокКБ.Добавить(НСтр("ru='Система ""Клиент-Банк""';uk='Система ""Клієнт-Банк""'"));
	
	Возврат СписокКБ;
	
КонецФункции 
