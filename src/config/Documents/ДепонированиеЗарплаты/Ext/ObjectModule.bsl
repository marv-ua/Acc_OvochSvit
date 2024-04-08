﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция МожноЗаполнитьАвтоматически() Экспорт
	
	ПравилаПроверки = Новый Структура;
	
	ПравилаПроверки.Вставить("Организация",	НСтр("ru='Не выбрана организация!';uk='Не обрана організація!'"));
	ПравилаПроверки.Вставить("Ведомость",	НСтр("ru='Не указана ведомость!';uk='Не вказана відомість!'"));
	
	МожноЗаполнитьАвтоматически = 
		ЗарплатаКадрыКлиентСервер.СвойстваЗаполнены(ЭтотОбъект, ПравилаПроверки, Истина);
		
	МожноЗаполнитьАвтоматически = МожноЗаполнитьАвтоматически И МожноЗаполнитьПоВедомости();		
		
	Возврат МожноЗаполнитьАвтоматически 
	
КонецФункции

Процедура ЗаполнитьАвтоматически() Экспорт
	
	ЗаполнитьПоВедомости();
	
КонецПроцедуры	

// Подсистема "Управление доступом"

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Депоненты.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом"

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) И ЭтотОбъект.Метаданные().Реквизиты.Ведомость.Тип.СодержитТип(ТипЗнч(ДанныеЗаполнения)) Тогда
		ЗаполнитьПоОснованию(ДанныеЗаполнения);
	КонецЕсли
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Отказ = НЕ МожноЗаполнитьАвтоматически();
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Ведомость");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровВоВнешнейПрограмме") Тогда
		УчетДепонированнойЗарплаты.ДепонированиеЗарплатыОбработкаПроведения(ЭтотОбъект, Отказ);
	Иначе	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ведомость", Ведомость);
		Запрос.УстановитьПараметр("РаботникиЗадепонировано", Депоненты.ВыгрузитьКолонку("ФизическоеЛицо"));
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Оплаты.Физлицо,
		|	Оплаты.Сумма,
		|	Оплаты.ГруппаУчетаНачислений
		|ПОМЕСТИТЬ ВТОплаты
		|ИЗ Документ.ВедомостьНаВыплатуЗарплаты.ПараметрыОплаты КАК Оплаты
		|ГДЕ
		|  Оплаты.Ссылка = &Ведомость
		|;
		|
		|ВЫБРАТЬ
		|	Оплаты.Физлицо КАК ФизическоеЛицо,
		|	Оплаты.Сумма,
		|	ГруппыУчетаНачисленийИУдержаний.СчетУчета,
		|   ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.Депонирование) КАК ВидОперации
		|ИЗ ВТОплаты КАК Оплаты
		|   ЛЕВОЕ СОЕДИНЕНИЕ
		|	Справочник.ГруппыУчетаНачисленийИУдержаний КАК ГруппыУчетаНачисленийИУдержаний
		|   ПО ГруппыУчетаНачисленийИУдержаний.Ссылка = Оплаты.ГруппаУчетаНачислений
		|ГДЕ
		|   Оплаты.Физлицо В (&РаботникиЗадепонировано)
		|";
		
		РезультатДепоненты = Запрос.Выполнить().Выгрузить();
		
		ДанныеДляОтражения = Новый Структура;
		ДанныеДляОтражения.Вставить("Депоненты", РезультатДепоненты);
		УчетЗарплаты.СформироватьДвиженияПоОтражениюЗарплатыВРегламентированномУчете(Движения, Отказ, Организация, Дата, Дата, ДанныеДляОтражения);
		
	КонецЕсли;	

	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоОснованию(ДокументОснование)
	
	ОрганизацияВедомости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Организация");	
	
	Организация = ОрганизацияВедомости;
	Ведомость = ДокументОснование;
	
	ПолучитьСообщенияПользователю(Истина);
	
	Если МожноЗаполнитьПоВедомости() Тогда
		ЗаполнитьПоВедомости();
	КонецЕсли;	
	
	Сообщения = ПолучитьСообщенияПользователю(Истина); 
	Если Сообщения.Количество() > 0 Тогда 
		СообщениеОбОшибке = "";
		Для Каждого Сообщение Из Сообщения Цикл
			СообщениеОбОшибке = СообщениеОбОшибке + Сообщение.Текст + Символы.ПС
		КонецЦикла;	
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;	
	
КонецПроцедуры

Функция МожноЗаполнитьПоВедомости()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ведомость);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ведомость.Ссылка.Проведен КАК Проведен,
	|	Ведомость.Ссылка.Организация КАК Организация,
	|	КОЛИЧЕСТВО(*) КАК ЧислоСтрок
	|ИЗ
	|	#ВедомостьЗарплата КАК Ведомость
	|ГДЕ
	|	Ведомость.Ссылка = &Ссылка
	|   И Ведомость.Ссылка.ФорматОбмена30
	|
	|СГРУППИРОВАТЬ ПО
	|	Ведомость.Ссылка.Проведен,
	|	Ведомость.Ссылка.Организация";
//++ БУ ЗИК	
	Если ТипЗнч(Ведомость) = Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплаты") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВедомостьЗарплата", Метаданные.НайтиПоТипу(ТипЗнч(Ведомость)).ПолноеИмя()+".РаботникиОрганизации");
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВедомостьЗарплата", Метаданные.НайтиПоТипу(ТипЗнч(Ведомость)).ПолноеИмя()+".Зарплата");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Ведомость.Ссылка.ФорматОбмена30", "ИСТИНА");
	КонецЕсли;
//~	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВедомостьЗарплата", Метаданные.НайтиПоТипу(ТипЗнч(Ведомость)).ПолноеИмя()+".Зарплата");
//~	Запрос.Текст = СтрЗаменить(Запрос.Текст, "Ведомость.Ссылка.ФорматОбмена30", "ИСТИНА");
//-- БУ ЗИК	
		
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	ДанныеВедомости = РезультатЗапроса.Выгрузить()[0];
	
	МожноЗаполнитьПоВедомости = Истина;
	
	Если ДанныеВедомости.Организация <> Организация Тогда
		МожноЗаполнитьПоВедомости = Ложь;
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 относится к другой организации (%2)!';uk='%1 відноситься до іншої організації (%2)!'"), 
			Ведомость, 
			ДанныеВедомости.Организация);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ЭтотОбъект, "Ведомость");
	КонецЕсли;	
	
	Если НЕ ДанныеВедомости.Проведен Тогда
		МожноЗаполнитьПоВедомости = Ложь;
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ведомость не проведена!';uk='Відомість не проведена!'"), 
			Ведомость);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ЭтотОбъект, "Ведомость");
	КонецЕсли;	
	
	Если ДанныеВедомости.ЧислоСтрок = 0 Тогда
		МожноЗаполнитьПоВедомости = Ложь;
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ведомость пуста!';uk='Відомість порожня!'"), 
			Ведомость);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ЭтотОбъект, "Ведомость");
	КонецЕсли;	
	
	Возврат МожноЗаполнитьПоВедомости 
	
КонецФункции

Процедура ЗаполнитьПоВедомости()
	
	// Очищаем текущие строки документа
	Депоненты.Очистить();
	
	Если ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровВоВнешнейПрограмме") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ведомость", Ведомость);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВедомостьНаВыплатуЗарплатыРаботникиОрганизации.Ссылка КАК Ссылка,
		               |	ВедомостьНаВыплатуЗарплатыРаботникиОрганизации.Физлицо КАК ФизическоеЛицо,
		               |	ВедомостьНаВыплатуЗарплатыРаботникиОрганизации.Сумма КАК СуммаКВыплате
		               |ИЗ
		               |	Документ.ВедомостьНаВыплатуЗарплаты.РаботникиОрганизации КАК ВедомостьНаВыплатуЗарплатыРаботникиОрганизации
					   |ГДЕ
					   |	ВедомостьНаВыплатуЗарплатыРаботникиОрганизации.Ссылка = &Ведомость
					   |	И ВедомостьНаВыплатуЗарплатыРаботникиОрганизации.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Задепонировано)";
		
		ДанныеВедомости = Запрос.Выполнить().Выгрузить();
	Иначе
		// Получаем невыданные строки ведомости
		ДанныеВедомости = ВзаиморасчетыССотрудниками.ДанныеВедомостейДляОплатыДокументом(Ссылка, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ведомость),, Ложь);
	КонецЕсли;	
	
	Если ДанныеВедомости.Количество() = 0 Тогда 
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Зарплата по ведомости полностью выдана (депонирована)!';uk='Зарплата за відомістю повністю видана (депонована)!'"), 
			Ведомость);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ЭтотОбъект, "Ведомость");
		Возврат
	КонецЕсли;

	ДанныеВедомости.Свернуть("ФизическоеЛицо", "СуммаКВыплате");

	// Заполняем по неполученным строкам ведомости
	Для Каждого СтрокаЗарплаты Из ДанныеВедомости Цикл
		Если СтрокаЗарплаты.СуммаКВыплате > 0 Тогда
			СтрокаТЧ = Депоненты.Добавить();
			СтрокаТЧ.ФизическоеЛицо =  СтрокаЗарплаты.ФизическоеЛицо;
		КонецЕсли	
	КонецЦикла
	
КонецПроцедуры	

#КонецЕсли
