﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

Процедура УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, ИмяРеквизита, ЗначениеПоУмолчанию)

	Если НЕ ДанныеЗаполнения.Свойство(ИмяРеквизита, ЗаписьРегистра[ИмяРеквизита]) Тогда
		ЗаписьРегистра[ИмяРеквизита] = ЗначениеПоУмолчанию;
	КонецЕсли;

КонецПроцедуры

Процедура УстановкаНастройкиНумерацииНалоговыхНакладныхПоУмолчанию(ЗаписьРегистра, ДанныеЗаполнения) Экспорт

	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "Организация", БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "Период", НачалоГода(ТекущаяДатаСеанса()));
	
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "ВестиМесячнуюНумерациюНалоговыхДокументов", 							Ложь);
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "ВестиНумерациюНалоговыхДокументовБезУчетаОбособленныхПодразделений", Истина);
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "ВестиРаздельнуюНумерациюНалоговыхДокументов", 						Ложь);
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "ВестиРаздельнуюНумерациюНалоговыхДокументовПоНеНДСОперациям", 		Ложь);
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "ВестиРаздельнуюНумерациюНалоговыхДокументовПоСпецРежимам", 			Истина);
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "ВестиРаздельнуюНумерациюНалоговыхНакладныхПоОбычнымЦенам", 			Ложь);
	
КонецПроцедуры

#КонецЕсли
