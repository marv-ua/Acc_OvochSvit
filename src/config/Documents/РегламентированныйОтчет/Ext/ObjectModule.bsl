﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Период = СокрЛП(Формат(ДатаОкончания, "ДФ=yyyyMMdd") + Формат('39991231' - ДатаНачала, "ДФ=yyyyMMdd"));
	ПредставлениеПериода = ПредставлениеПериода(ДатаНачала, КонецДня(ДатаОкончания), "ФП = Истина");
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|   ВыгрузкаРегламентированныхОтчетов.Ссылка
	|ИЗ
	|	Документ.ВыгрузкаРегламентированныхОтчетов КАК ВыгрузкаРегламентированныхОтчетов
	|ГДЕ
	|	ВыгрузкаРегламентированныхОтчетов.Основание = &Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	ДокументыВыгрузки = Запрос.Выполнить().Выгрузить();
	
	Если ДокументыВыгрузки.Количество() > 0 Тогда
		
		НачатьТранзакцию();
		
		Для Каждого ДокВыгрузки Из ДокументыВыгрузки Цикл
			
			ДокВыгрузки = ДокВыгрузки.Ссылка.ПолучитьОбъект();
			
			ДокВыгрузки.Заблокировать();
			
			Если ЭтотОбъект.ПометкаУдаления Тогда
				
				
				ДокВыгрузки.УстановитьПометкуУдаления(Истина);
					
			Иначе	
				
				ДокВыгрузки.УстановитьПометкуУдаления(Ложь);
				
				ДокВыгрузки.Записать(РежимЗаписиДокумента.Запись);
				
			КонецЕсли;
									
			ДокВыгрузки.Разблокировать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	КонецЕсли;
		
КонецПроцедуры

#КонецЕсли
