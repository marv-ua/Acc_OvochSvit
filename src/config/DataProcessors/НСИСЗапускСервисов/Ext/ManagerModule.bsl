﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ЗапуститьСервисы(Параметры, АдресРезультата) Экспорт
	
	ВыводитьПротокол = Ложь;
	Параметры.Свойство("ВыводитьПротокол", ВыводитьПротокол);
	Если ВыводитьПротокол = Неопределено Тогда
		ВыводитьПротокол = Ложь;	
	КонецЕсли;
	ВФоне = Ложь;
	Параметры.Свойство("ВФоне", ВФоне);
	Если ВФоне = Неопределено Тогда
		ВФоне = Ложь;	
	КонецЕсли;
	
	ЗагружатьНормативныеВеличины = Истина;
	Параметры.Свойство("ЗагружатьНормативныеВеличины", ЗагружатьНормативныеВеличины);
	Если ЗагружатьНормативныеВеличины = Неопределено Тогда
		ЗагружатьНормативныеВеличины = Истина;	
	КонецЕсли;
	
	ЗагружатьКлассификаторы = Истина;
	Параметры.Свойство("ЗагружатьКлассификаторы", ЗагружатьКлассификаторы);
	Если ЗагружатьКлассификаторы = Неопределено Тогда
		ЗагружатьКлассификаторы = Истина;	
	КонецЕсли;
	
	ЗагружатьКурсыВалют = Истина;
	Параметры.Свойство("ЗагружатьКурсыВалют", ЗагружатьКурсыВалют);
	Если ЗагружатьКурсыВалют = Неопределено Тогда
		ЗагружатьКурсыВалют = Истина;	
	КонецЕсли;
	
	ЗагружатьНовости = Истина;
	Параметры.Свойство("ЗагружатьНовости", ЗагружатьНовости);
	Если ЗагружатьНовости = Неопределено Тогда
		ЗагружатьНовости = Истина;	
	КонецЕсли;
	
	ЗагружатьКалендарь = Истина;
	Параметры.Свойство("ЗагружатьКалендарь", ЗагружатьКалендарь);
	Если ЗагружатьКалендарь = Неопределено Тогда
		ЗагружатьКалендарь = Истина;	
	КонецЕсли;
	
	ЗагружатьСписокФайлов = Ложь;
	Параметры.Свойство("ЗагружатьСписокФайлов", ЗагружатьСписокФайлов);
	Если ЗагружатьСписокФайлов = Неопределено Тогда
		ЗагружатьСписокФайлов = Ложь;	
	КонецЕсли;
	
	МесяцКалендаря = Дата(1,1,1);
	Параметры.Свойство("МесяцКалендаря", МесяцКалендаря);
	
	СписокФайлов = Неопределено;
	Параметры.Свойство("СписокФайлов", СписокФайлов);
	
	Если ЗагружатьНормативныеВеличины Тогда
		НСИССервер.ВыполнитьОбновлениеРегистров(ВыводитьПротокол, ВФоне);
	КонецЕсли;
	Если ЗагружатьКурсыВалют Тогда
		НСИССервер.ВыполнитьОбновлениеКурсовВалют(,,,ВыводитьПротокол, ВФоне);
	КонецЕсли;
	Если ЗагружатьКлассификаторы Тогда
		НСИССервер.ВыполнитьОбновлениеКлассификаторов(ВыводитьПротокол, ВФоне, СписокФайлов);
	КонецЕсли;
	Если ЗагружатьНовости Тогда
		НСИССервер.ВыполнитьОбновлениеНовостей(ВыводитьПротокол, ВФоне);
	КонецЕсли;
	Если ЗагружатьКалендарь Тогда
		Если ЗначениеЗаполнено(МесяцКалендаря) Тогда
			НСИССервер.ВыполнитьОбновлениеКалендаря(МесяцКалендаря, МесяцКалендаря,ВыводитьПротокол, ВФоне);
		Иначе	
			НСИССервер.ВыполнитьОбновлениеКалендаря(,,ВыводитьПротокол, ВФоне);
		КонецЕсли;	
	КонецЕсли;
	Если ЗагружатьСписокФайлов Тогда
		НСИССервер.ПолучитьСписокДополнительныхФайлов(ВыводитьПротокол, ВФоне);
	КонецЕсли;
	
КонецПроцедуры


Процедура ПроверитьДоступ(Параметры) Экспорт
	
	ВыводитьПротокол = Ложь;
	Параметры.Свойство("ВыводитьПротокол", ВыводитьПротокол);
	Если ВыводитьПротокол = Неопределено Тогда
		ВыводитьПротокол = Ложь;	
	КонецЕсли;
	ВФоне = Ложь;
	Параметры.Свойство("ВФоне", ВФоне);
	Если ВФоне = Неопределено Тогда
		ВФоне = Ложь;	
	КонецЕсли;
	
	НСИССервер.ПроверитьДоступ(ВыводитьПротокол, ВФоне);
	
КонецПроцедуры	

#КонецЕсли