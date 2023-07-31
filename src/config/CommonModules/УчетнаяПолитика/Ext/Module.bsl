﻿
Функция Существует(Организация, Период, ВыводитьСообщениеОбОтсутствииУчетнойПолитики = Ложь, ДокументСсылка = Неопределено) Экспорт

	СпособОценкиТоваровВРознице = ПолучитьФункциональнуюОпцию("СпособОценкиТоваровВРознице", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	УчетнаяПолитикаСуществует = НЕ (СпособОценкиТоваровВРознице = Ложь);

	Если НЕ УчетнаяПолитикаСуществует
		И ВыводитьСообщениеОбОтсутствииУчетнойПолитики = Истина Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Для организации %1 на %2 не заполнена учетная политика.';uk='Для організації %1 на %2 не заповнена облікова політика.'"),
			Организация,
			Формат(НачалоМесяца(Период), "ДФ='MMMM yyyy'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументСсылка, , "Объект");
	КонецЕсли;

	Возврат УчетнаяПолитикаСуществует;

КонецФункции

Функция СхемаНалогообложения(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СхемаНалогообложения", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Справочники.СхемыНалогообложения.НеПлательщик;
	КонецЕсли;

	Возврат Результат;

КонецФункции 


// Параметры учетной политики по налогу на прибыль

Функция ПлательщикНалогаНаПрибыль(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикНалогаНаПрибыль", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция ПлательщикНалогаНаПрибыльДо2015(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикНалогаНаПрибыль", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период))) И Период < '2015 01 01';

	Возврат Результат;

КонецФункции 

Функция ПлательщикНалогаНаПрибыльС2015(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикНалогаНаПрибыль", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период))) И Период >= '2015 01 01';

	Возврат Результат;

КонецФункции 

Функция НалогНаПрибыльБезКорректировокФинансовогоРезультата(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("НалогНаПрибыльБезКорректировокФинансовогоРезультата", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 


// Параметры учетной политики по НДС

Функция ПлательщикНДС(Организация, Период) Экспорт

    Возврат ЗначениеУчетнойПолитики("ПлательщикНДС", Организация, Период);

КонецФункции 

Функция ПлательщикНДСПриостановлен(Организация, Период) Экспорт

    Возврат ЗначениеУчетнойПолитики("ПлательщикНДСПриостановлен", Организация, Период);

КонецФункции 

// Параметры учетной политики по Единому налогу

Функция ПлательщикЕдиногоНалога(Организация, Период) Экспорт

    Возврат ЗначениеУчетнойПолитики("ПлательщикЕдиногоНалога", Организация, Период);

КонецФункции 

Функция ГруппаПлательщикаЕдиногоНалога(Организация, Период) Экспорт
	
    Возврат ЗначениеУчетнойПолитики("ГруппаПлательщикаЕдиногоНалога", Организация, Период);

КонецФункции 


// Параметры учетной политики по затратам на производство

Функция ЗначениеУчетнойПолитики(ИмяРесурса, Организация, Период)
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация", Организация);
	Параметры.Вставить("Период",      НачалоДня(Период));
	
	Возврат ПолучитьФункциональнуюОпцию(ИмяРесурса, Параметры);
	
КонецФункции	

Функция ВедетсяПроизводственнаяДеятельность(Организация, Период) Экспорт

    Возврат ЗначениеУчетнойПолитики("ВедетсяПроизводственнаяДеятельность", Организация, Период);
	
КонецФункции 


Функция СпособРасчетаСебестоимостиПроизводства(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("СпособРасчетаСебестоимостиПроизводства", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ПорядокРаспределенияРасходовНаОказаниеВнутреннихУслуг(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ПорядокРаспределенияРасходовНаОказаниеВнутреннихУслуг", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ПорядокРаспределенияРасходовНаОказаниеУслуг(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ПорядокРаспределенияРасходовНаОказаниеУслуг", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

// Прочие параметры учетной политики

Функция СпособОценкиМПЗ(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СпособОценкиМПЗ", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Перечисления.СпособыОценки.ПоСредней;
	КонецЕсли;

	Возврат Результат;

КонецФункции 

Функция СпособОценкиТоваровВРознице(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СпособОценкиТоваровВРознице", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Перечисления.СпособыОценкиТоваровВРознице.ПоСтоимостиПриобретения;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ИспользуемыеКлассыСчетовРасходов(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ИспользуемыеКлассыСчетовРасходов", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Перечисления.КлассыСчетовРасходов.Класс8;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ", Организация, Период);
	
КонецФункции

Функция ВключатьСуммуДооценокОСВСоставНП(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("ВключатьСуммуДооценокОСВСоставНП", Организация, Период);
	
КонецФункции

Функция НеРаспределятьОПЗнаСебестоимостьПродукции(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("НеРаспределятьОПЗнаСебестоимостьПродукции", Организация, Период);
	
КонецФункции

Функция НалоговоеНазначениеНераспределенныхПостоянныхОПЗ(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("НалоговоеНазначениеНераспределенныхПостоянныхОПЗ", Организация, Период);
	
КонецФункции

Функция УчетПоОбособленнымПодразделениям(Организация, Период) Экспорт
	
	ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениям");
	Возврат ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениям И ЗначениеУчетнойПолитики("ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениямОрганизация", Организация, Период);
	
КонецФункции
