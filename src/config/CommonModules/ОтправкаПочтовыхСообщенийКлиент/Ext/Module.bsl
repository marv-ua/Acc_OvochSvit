﻿#Область ПрограммныйИнтерфейс

// Отправляет по электронной почте печатные формы документов.
//
// Параметры:
//  КомандаОтправки  - Массив - строковый идентификатор команды отправки.
//  АдресКомандОтправки - Строка - адрес описания команд отправки во временном хранилище.
//  ОбъектыОтправки - Массив - ссылки на отправляемые документы.
//  ЕстьОшибки - Булево - признак возникновения ошибки при формировании электронного письма.
//  ДополнительныеПараметры - Структура - дополнительные параметры для сохранения печатных форм:
//   * УпаковатьВАрхив - Булево - упаковать печатные формы в архив.
//   * ФорматыСохранения - Массив - содержит формат сохранения файлов см. ТипФайлаТабличногоДокумента.
//
Процедура ОтправитьПоЭлектроннойПочте(КомандыОтправки, АдресКомандОтправки, ОбъектыОтправки, ЕстьОшибки,
			ДополнительныеПараметры = Неопределено) Экспорт
	
	ОписаниеКоманд = Новый Массив;
	ПечатныеФормы = Новый Массив;
	
	Для Каждого Команда Из КомандыОтправки Цикл
		
		ОписаниеКоманды = ОтправкаПочтовыхСообщенийВызовСервера.ОписаниеКомандыОтправки(Команда, АдресКомандОтправки);
		
		ОписаниеКоманды.Вставить("ОбъектыОтправки", ОбъектыОтправки);
		
		Если ОписаниеКоманды.МенеджерПечати = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки" Тогда
			
			Для Каждого КлючИЗначение Из ОписаниеКоманды.ДополнительныеПараметры Цикл
				ОписаниеКоманды.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЦикла;
			
			ОписаниеКоманды.Вставить("ЭтоОтчет", Ложь);
			ОписаниеКоманды.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма"));
			
			ПараметрыИсточника = Новый Структура;
			ПараметрыИсточника.Вставить("ИдентификаторКоманды", ОписаниеКоманды.Идентификатор);
			ПараметрыИсточника.Вставить("ОбъектыНазначения"   , ОбъектыОтправки);
			ОписаниеКоманды.Вставить("ПараметрыИсточника", ПараметрыИсточника);
			
		КонецЕсли;
		
		ОписаниеКоманды.ДополнительныеПараметры.Вставить("ФормироватьСтандартноеОписаниеПисьма", Ложь);
		ОписаниеКоманд.Добавить(ОписаниеКоманды);
		
	КонецЦикла;
	
	Если ОписаниеКоманд.Количество() > 0 Тогда
		ПараметрыПисьма = ОтправкаПочтовыхСообщенийВызовСервера.ПараметрыЭлектронногоПисьма(ОписаниеКоманд,
			ЕстьОшибки, ДополнительныеПараметры);
		Если ЗначениеЗаполнено(ПараметрыПисьма.Вложения) И НЕ ЕстьОшибки Тогда
			КлючеваяОперация = "БыстраяОтправкаДокументаПоЭлектроннойПочте";
			ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
			РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Отправляет по электронной почте результат выполнения отчета.
//
// Параметры:
//  Отчет - УправляемаяФорма - форма отправляемого отчета.
//  ДополнительныеПараметры - Структура - дополнительные параметры для формирования письма:
//   * Вложения - Соответствие - описание дополнительных вложений для передачи по почте:
//     ** Ключ - Строка - адрес двоичных данных во временном хранилище.
//     ** Значение - Строка - имя файла.
//
Процедура ОтправитьОтчет(Отчет, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ТабличныйДокумент", Отчет.Результат);
	ПараметрыОтчета.Вставить("Заголовок"        , Отчет.Заголовок);
	
	КлючеваяОперация = "ОтправкаОтчетаПоЭлектроннойПочте";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	ПараметрыПисьма = ОтправкаПочтовыхСообщенийВызовСервера.ПараметрыЭлектронногоПисьмаДляОтчетов(ПараметрыОтчета,
		ДополнительныеПараметры);
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма);
	
КонецПроцедуры

#КонецОбласти
