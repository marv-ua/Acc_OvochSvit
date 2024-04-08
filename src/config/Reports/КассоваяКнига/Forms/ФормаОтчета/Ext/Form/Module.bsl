﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ДатаНач",                 			   Отчет.ДатаНач);
	ПараметрыОтчета.Вставить("ДатаКон",                 			   Отчет.ДатаКон);
	ПараметрыОтчета.Вставить("Организация",              			   Отчет.Организация);
	ПараметрыОтчета.Вставить("ПоОбособленномуПодразделению",   		   Отчет.ПоОбособленномуПодразделению);
	ПараметрыОтчета.Вставить("ОбособленноеПодразделениеОрганизации",   Отчет.ОбособленноеПодразделениеОрганизации);
	ПараметрыОтчета.Вставить("ЕстьУчетПоОбособленнымПодразделениям",   ЕстьУчетПоОбособленнымПодразделениям);
	ПараметрыОтчета.Вставить("ВидОтчета",               			   Отчет.ВидОтчета);
	ПараметрыОтчета.Вставить("ПоОбособленномуПодразделению", 		   Отчет.ПоОбособленномуПодразделению);
	ПараметрыОтчета.Вставить("СписокСформированныхЛистов", 			   СписокЛистов);
	ПараметрыОтчета.Вставить("ТабличныйДокумент",      				   Неопределено);
	ПараметрыОтчета.Вставить("СформироватьОбложку",   			  	   Отчет.ВыводитьТитульныйЛист);
	ПараметрыОтчета.Вставить("ВидЛистаКассовойКниги",              	   ПоследнийЛист);
	ПараметрыОтчета.Вставить("РежимРасшифровки",        			   Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВалютаРегламентированногоУчета", 		   ВалютаРегламентированногоУчета);
	ПараметрыОтчета.Вставить("Валюта", 								   Отчет.Валюта);
	ПараметрыОтчета.Вставить("НесколькоЛистовВДень", 				   Отчет.НесколькоЛистовВДень);
	ПараметрыОтчета.Вставить("НачальныйНомерЛиста", 				   Отчет.НачальныйНомерЛиста);
	ПараметрыОтчета.Вставить("ГлавныйБухгалтер",       			       ГлавныйБухгалтер);
	ПараметрыОтчета.Вставить("Кассир",                 				   Кассир);
	ПараметрыОтчета.Вставить("ВыводитьКаждыйДокументВОтдельнойСтроке", Отчет.ВыводитьКаждыйДокументВОтдельнойСтроке);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере(Знач ГраницыПересчетаЛистов = Неопределено)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	Если ГраницыПересчетаЛистов <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Отчет, ГраницыПересчетаЛистов);
		ОбновитьТекстЗаголовка(ЭтотОбъект);
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.КассоваяКнига.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Отчеты.КассоваяКнига.СформироватьОтчет",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтотОбъект));
		
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	ВозвращаемыеПараметры = ПолучитьИзВременногоХранилища(АдресХранилища);
	СписокЛистов = ВозвращаемыеПараметры.СписокСформированныхЛистов;
	
	Если СписокЛистов.Количество() > 0 Тогда
		СписокВыбораЛиста = СписокЛистов.Получить(0).Значение;
		Элементы.КнопкаПерейтиКЛисту.Видимость = Истина;
	КонецЕсли;
	
	ПоказатьТабличныйДокумент(ВозвращаемыеПараметры.ТабличныйДокумент);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьТабличныйДокумент(ТабДокумент)
	
	Результат.Очистить();
	Результат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КассоваяКнига";
	
	Результат.Вывести(ТабДокумент);
	Результат.ФиксацияСверху = 0;
	Результат.ОриентацияСтраницы = ТабДокумент.ОриентацияСтраницы;
	
	Результат.ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораОбособленногоПодразделения()
	
	ПараметрыВыбора = Новый Массив();
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ОбособленноеПодразделениеОрганизации", Истина));
	
	Элементы.ОбособленноеПодразделениеОрганизации.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьЕстьУчетПоОбособленнымПодразделениям()
	
	ЕстьУчетПоОбособленнымПодразделениям = УчетнаяПолитика.УчетПоОбособленнымПодразделениям(Отчет.Организация, НачалоМесяца(Отчет.ДатаНач));
	
КонецПроцедуры
	
&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИндексСформированногоЛиста(ИмяЛиста, СписокСформированныхЛистов)
	
	Если ИмяЛиста = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для каждого Лист Из СписокСформированныхЛистов Цикл
		Если Лист.Значение = ИмяЛиста Тогда
			Возврат СписокСформированныхЛистов.Индекс(Лист);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииПериода(Форма)
	
	Отчет = Форма.Отчет;
	Если КонецДня(Отчет.ДатаКон) = КонецГода(Отчет.ДатаКон) Тогда
		ПоследнийЛист       = "Конец года";
		Отчет.ВыводитьТитульныйЛист = Истина;
	ИначеЕсли КонецДня(Отчет.ДатаКон) = КонецМесяца(Отчет.ДатаКон) Тогда
		ПоследнийЛист       = "Конец месяца";
		Отчет.ВыводитьТитульныйЛист = Ложь;
	Иначе
		ПоследнийЛист       = "Обычный";
		Отчет.ВыводитьТитульныйЛист = Ложь;
	КонецЕсли;
	
	ИзменениеРеквизитаШапкиОтчета(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменениеРеквизитаШапкиОтчета(Форма)
	
	Отчет = Форма.Отчет;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ДатаНач",           		 Отчет.ДатаНач);
	ПараметрыОтчета.Вставить("ДатаКон",            		 Отчет.ДатаКон);
	ПараметрыОтчета.Вставить("Организация",              Отчет.Организация);
	ПараметрыОтчета.Вставить("ЕстьУчетПоОбособленнымПодразделениям", Форма.ЕстьУчетПоОбособленнымПодразделениям);
	ПараметрыОтчета.Вставить("ОбособленноеПодразделениеОрганизации", Отчет.ОбособленноеПодразделениеОрганизации);
	
	УправлениеФормой(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Кассовая книга%1';uk='Касова книга%1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.ДатаНач, Отчет.ДатаКон));
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 %2';uk='%1 %2'"),
			ЗаголовокОтчета,
			БухгалтерскиеОтчетыВызовСервераПовтИсп.ПолучитьТекстОрганизация(Отчет.Организация));
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНачальныйНомерЛиста()

	Если НЕ Отчет.ВидОтчета = "Кассовая книга" Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Отчет.Организация);

	Отчет.НесколькоЛистовВДень = Истина;
	Отчет.НачальныйНомерЛиста = 1;
		
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Отчет.Организация);
	
	НастройкиПечатиКассовойКниги = РегистрыСведений.НастройкиПечатиКассовойКниги.СрезПоследних(НачалоГода(Отчет.ДатаНач), Отбор);
	Если НастройкиПечатиКассовойКниги.Количество() > 0 Тогда 
		Отчет.НесколькоЛистовВДень = НастройкиПечатиКассовойКниги[0].НесколькоЛистовВДень;
		Отчет.НачальныйНомерЛиста  = НастройкиПечатиКассовойКниги[0].НомерПервогоЛиста;
	КонецЕсли;
	
	НадписьНачальныйНомерЛиста = НСтр("ru='Номер первого листа - ';uk='Номер першого аркуша - '") + Строка(Отчет.НачальныйНомерЛиста);
	НадписьНачальныйНомерЛиста = НадписьНачальныйНомерЛиста + ?(Отчет.НесколькоЛистовВДень, НСтр("ru=', несколько листов в день';uk=', декілька аркушів у день'") , НСтр("ru=', один лист на день';uk=', один аркуш на день'"));
	ЭтаФорма.Элементы.НадписьНачальныйНомерЛиста.Заголовок = НадписьНачальныйНомерЛиста; 
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Результат.Области.Найти("ОповеститьОПроблеме") <> Неопределено Тогда
		Если Область.Верх = Результат.Области.ОповеститьОПроблеме.Верх Тогда
			СтандартнаяОбработка = Ложь;
			
			ОчиститьСообщения();
			ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
			
			ПересчитатьНомераЛистов = Истина;
			РезультатВыполнения = СформироватьОтчетНаСервере(Область.Расшифровка);
			Если НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
				ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
				ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
			Иначе
				ПоказатьОповещениеПользователя(НСтр("ru='Произведен пересчет';uk='Проведений перерахунок'"),, НСтр("ru='номеров листов Кассовой книги';uk='номерів аркушів Касової книги'"),
					БиблиотекаКартинок.ИнформацияБСП);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВопросИзменитьДату(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отчет.ДатаНач = НачалоГода(Отчет.ДатаНач);
		Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	Если НеЗаполненныНомера() Тогда
		
		ТекстВопроса = НСтр("ru='За указанный период нет сформированных номеров листов кассовой книги.Рекомендуется сформировать кассовую книгу с начала года, иначе сформированные номера будут не корректны. Установить начало периода началом года?';uk='За зазначений період немає сформованих номерів аркушів касової книги.Рекомендується сформувати касову книгу з початку року, інакше сформовані номери будуть не коректні. Установити початок періоду початком року?'");
		Оповещение = Новый ОписаниеОповещения("ВопросИзменитьДату", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
	ПолучитьНачальныйНомерЛиста();
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКЛисту(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПерейтиКЛистуЗавершение", ЭтотОбъект);
	
	ТекущийЛист = Неопределено;
	Если НЕ ПустаяСтрока(СписокВыбораЛиста) Тогда
		ТекущийЛист = СписокЛистов.НайтиПоЗначению(СписокВыбораЛиста);
	КонецЕсли;
	
	СписокЛистов.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru='Перейти к листу кассовой книги';uk='Перейти до аркуша касової книги'"), ТекущийЛист);
	
КонецПроцедуры

&НаСервере
Функция НеЗаполненныНомера() Экспорт
	
	Если НачалоДня(Отчет.ДатаНач) = НачалоГода(Отчет.ДатаНач) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗапросКоличествоСформированныхСтраниц = Новый Запрос;
	ЗапросКоличествоСформированныхСтраниц.УстановитьПараметр("ДатаНач", НачалоГода(Отчет.ДатаНач));
	ЗапросКоличествоСформированныхСтраниц.УстановитьПараметр("ДатаКон", НачалоДня(Отчет.ДатаНач)-1);
	
	Если Отчет.ОбособленноеПодразделениеОрганизации.Пустая() Тогда
		ЗапросКоличествоСформированныхСтраниц.УстановитьПараметр("СтруктурнаяЕдиница", Отчет.Организация);
	Иначе
		ЗапросКоличествоСформированныхСтраниц.УстановитьПараметр("СтруктурнаяЕдиница", Отчет.ОбособленноеПодразделениеОрганизации);
	КонецЕсли;
	
	ЗапросКоличествоСформированныхСтраниц.УстановитьПараметр("Валюта", Отчет.Валюта);
	
	ЗапросКоличествоСформированныхСтраниц.Текст=
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПоследниеНомераЛистовКассовойКниги.Период) КАК КвоПериод
	|ИЗ
	|	РегистрСведений.ПоследниеНомераЛистовКассовойКниги КАК ПоследниеНомераЛистовКассовойКниги
	|ГДЕ
	|	ПоследниеНомераЛистовКассовойКниги.Период >= &ДатаНач
	|	И ПоследниеНомераЛистовКассовойКниги.Период <= &ДатаКон
	|	И ПоследниеНомераЛистовКассовойКниги.Валюта = &Валюта
	|	И ПоследниеНомераЛистовКассовойКниги.СтруктурнаяЕдиница = &СтруктурнаяЕдиница";
	ВыборкаКоличествоСформированныхСтраниц = ЗапросКоличествоСформированныхСтраниц.Выполнить().Выбрать();
	КоличествоСформированныхСтраниц = 0;
	Если ВыборкаКоличествоСформированныхСтраниц.Следующий() Тогда
		КоличествоСформированныхСтраниц = ВыборкаКоличествоСформированныхСтраниц.КвоПериод;
	КонецЕсли;
	
	ЗапросКоличествоДнейЗаПериод = Новый Запрос; 
	ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("ДатаНач",НачалоГода(Отчет.ДатаНач));
	ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("ДатаКон",НачалоДня(Отчет.ДатаНач)-1);
	ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("Организация",Отчет.Организация);
	
	Если Отчет.Валюта = ВалютаРегламентированногоУчета Тогда
		ВалютнаяКасса = Ложь;
		ТекстФильтр = "";
		ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("Счет", ПланыСчетов.Хозрасчетный.КассаВНациональнойВалюте);
	Иначе
		ВалютнаяКасса = Истина;
		ТекстФильтр = "ГДЕ
					   | ХозрасчетныйОбороты.Валюта = &Валюта
					   |";
		ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("Валюта",Отчет.Валюта);
		ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("Счет",ПланыСчетов.Хозрасчетный.КассаВИностраннойВалюте);
	КонецЕсли;
	
	Если НЕ ЕстьУчетПоОбособленнымПодразделениям Тогда
		ТекстСубконто = "";
	Иначе
		ТекстСубконто = "&Субконто";
		Если ПустаяСтрока(ТекстФильтр) Тогда
			ТекстФильтр = "ГДЕ
						   |  ХозрасчетныйОбороты.Субконто1 = &ОбособленноеПодразделениеОрганизации
						   |";
		Иначе
			ТекстФильтр = ТекстФильтр + " И
						   |  ХозрасчетныйОбороты.Субконто1 = &ОбособленноеПодразделениеОрганизации
						   |";
		КонецЕсли; 
		ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("Субконто", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбособленныеПодразделенияБезОбразованияЮрЛица);
		ЗапросКоличествоДнейЗаПериод.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", Отчет.ОбособленноеПодразделениеОрганизации);
	КонецЕсли;
	
	ЗапросКоличествоДнейЗаПериод.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ХозрасчетныйОбороты.Период) КАК КвоПериод
	|ИЗ
	| РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, День, Счет = &Счет,"+ТекстСубконто+", Организация = &Организация) КАК ХозрасчетныйОбороты
	|"+ ТекстФильтр+"
	|";
				 
	ВыборкКоличествоДнейЗаПериода = ЗапросКоличествоДнейЗаПериод.Выполнить().Выбрать();
	
	КоличествоСтраниц = 0;
	Если ВыборкКоличествоДнейЗаПериода.Следующий() Тогда
		КоличествоСтраниц = ВыборкКоличествоДнейЗаПериода.КвоПериод;
	КонецЕсли;
	
	Если (КоличествоСтраниц > 0) И (КоличествоСтраниц > КоличествоСформированныхСтраниц) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ПЕРИОД

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора    = Новый Структура("НачалоПериода, КонецПериода", Отчет.ДатаНач, Отчет.ДатаКон);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ПриИзмененииПериода(ЭтотОбъект);
	
	УстановитьЕстьУчетПоОбособленнымПодразделениям();
	
	ПолучитьНачальныйНомерЛиста();
	
	УправлениеФормой(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ПриИзмененииПериода(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьЕстьУчетПоОбособленнымПодразделениям();

	ИзменениеРеквизитаШапкиОтчета(ЭтотОбъект);
	
	ПолучитьНачальныйНомерЛиста();
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоследнийЛистПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОтчетаПриИзменении(Элемент)
	
	ПолучитьНачальныйНомерЛиста();
	
	УправлениеФормой(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоОбособленномуПодразделениюПриИзменении(Элемент)
	
	Если НЕ Отчет.ПоОбособленномуПодразделению Тогда
		Отчет.ОбособленноеПодразделениеОрганизации = Неопределено;
	КонецЕсли;
	
	ИзменениеРеквизитаШапкиОтчета(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбособленноеПодразделениеОрганизацииПриИзменении(Элемент)
	
	ИзменениеРеквизитаШапкиОтчета(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
 	Если НЕ ЗначениеЗаполнено(Отчет.ДатаНач) Тогда
		Отчет.ДатаНач = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.ДатаКон) Тогда
		Отчет.ДатаКон  = КонецДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.ВидОтчета) Тогда
		Отчет.ВидОтчета  = "Кассовая книга";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПоследнийЛист) Тогда
		ПоследнийЛист  = "Обычный";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.Валюта) Тогда
		Отчет.Валюта  = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) Тогда
		Отчет.Организация   = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	УстановитьЕстьУчетПоОбособленнымПодразделениям();
	ПриИзмененииПериода(ЭтотОбъект);
	
	УстановитьПараметрыВыбораОбособленногоПодразделения();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Отчет;
	
	Элементы.ПоОбособленномуПодразделению.Видимость 		= Форма.ЕстьУчетПоОбособленнымПодразделениям;
	Элементы.ОбособленноеПодразделениеОрганизации.Видимость = Форма.ЕстьУчетПоОбособленнымПодразделениям И Объект.ПоОбособленномуПодразделению;
	
	ЭтоКассоваяКнига = Объект.ВидОтчета = "Кассовая книга";
	Элементы.НадписьНачальныйНомерЛиста.Видимость 				 = ЭтоКассоваяКнига;
	Элементы.НадписьПоследниеНомераЛистовКассовойКниги.Видимость = ЭтоКассоваяКнига;
	Элементы.ПоследнийЛист.Видимость 			= ЭтоКассоваяКнига;
	Элементы.ГруппаОтветственныеЛица.Видимость 	= ЭтоКассоваяКнига;
	
	ЭтоКнигаПринятыхВыданных = Объект.ВидОтчета = "Книга учета принятых и выданных денег"; 
	Элементы.ГруппаНастройкиФормированияЛистов.Видимость = НЕ ЭтоКнигаПринятыхВыданных;
	
	ЭтоЖурналРегистрацииПриходныхИРасходных = Объект.ВидОтчета = "Журнал регистрации приходных и расходных ордеров";
	Элементы.ВыводитьКаждыйДокументВОтдельнойСтроке.Видимость = ЭтоЖурналРегистрацииПриходныхИРасходных;	
	
	ОбновитьТекстЗаголовка(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	ДатаНачДоВосстановленияПользовательскихНастроек = Отчет.ДатаНач;
	ОрганизацияДоВосстановленияПользовательскихНастроек = Отчет.Организация;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки, Истина);
	
	Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) И Отчет.Организация <> Параметры.Организация Тогда
		Отчет.Организация = Параметры.Организация;	
	КонецЕсли;
	
	Если Отчет.Организация <> ОрганизацияДоВосстановленияПользовательскихНастроек
		Или НачалоМесяца(Отчет.ДатаНач) <> НачалоМесяца(ДатаНачДоВосстановленияПользовательскихНастроек) Тогда
		УстановитьЕстьУчетПоОбособленнымПодразделениям();	
	КонецЕсли;
	
	ПриИзмененииПериода(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	УправлениеФормой(ЭтотОбъект);
	ПолучитьНачальныйНомерЛиста();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Отчет.РежимРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДКЛЮЧАЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отчет.ДатаНач = РезультатВыбора.НачалоПериода;
	Отчет.ДатаКон = РезультатВыбора.КонецПериода;
	
	ПриИзмененииПериода(ЭтотОбъект);
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКЛистуЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыбораЛиста = ВыбранныйЭлемент.Значение;
	ИндексСформированногоЛиста = ПолучитьИндексСформированногоЛиста(СписокВыбораЛиста, СписокЛистов); // Отчет.СписокСформированныхЛистов);
	Если ИндексСформированногоЛиста <> Неопределено Тогда
		СформированныйЛист = Сред(СписокЛистов.Получить(ИндексСформированногоЛиста).Значение, 2);
		
		ПолеТабличногоДокумента    = Элементы["Результат"];
		ТабличныйДокумент          = ЭтотОбъект["Результат"];
		ОбластьВыбранногоДокумента = ТабличныйДокумент.Области.Найти(СформированныйЛист);
		
		ПолеТабличногоДокумента.ТекущаяОбласть = ТабличныйДокумент.Область("R1C1"); // переход к началу
		
		Если ОбластьВыбранногоДокумента <> Неопределено Тогда
			ПолеТабличногоДокумента.ТекущаяОбласть = ТабличныйДокумент.Область(
				ОбластьВыбранногоДокумента.Верх,, ОбластьВыбранногоДокумента.Низ,);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНачальныйНомерЛистаНажатие(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("Организация", Отчет.Организация);
	
	ОткрытьФорму("РегистрСведений.НастройкиПечатиКассовойКниги.Форма.ФормаСписка", Новый Структура("Отбор", ПараметрыОтбор));
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоследниеНомераЛистовКассовойКнигиНажатие(Элемент)
	
	ПараметрыОтбор = Новый Структура;
	Если ЗначениеЗаполнено(Отчет.ОбособленноеПодразделениеОрганизации) Тогда
		ПараметрыОтбор.Вставить("СтруктурнаяЕдиница", Отчет.ОбособленноеПодразделениеОрганизации);
	Иначе
		ПараметрыОтбор.Вставить("СтруктурнаяЕдиница", Отчет.Организация);
	КонецЕсли;
	
	ПараметрыОтбор.Вставить("Валюта", Отчет.Валюта);
	
	ОткрытьФорму("РегистрСведений.ПоследниеНомераЛистовКассовойКниги.Форма.ФормаСписка", Новый Структура("Отбор", ПараметрыОтбор));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеНачальныйНомерЛиста" Тогда
		
		ПолучитьНачальныйНомерЛиста();
		
	КонецЕсли;
			
КонецПроцедуры



