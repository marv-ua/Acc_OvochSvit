﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Устанавливает/снимает признак активности движений документа в зависимости от пометки удаления.
// Следует вызывать перед записью измененной пометки удаления.
// Помеченный на удаление документ не должен иметь активных движений.
// Не помеченный на удаление документ может иметь неактивные движения.
Процедура СинхронизироватьАктивностьДвиженийСПометкойУдаления()
	
	Если НЕ ПометкаУдаления 
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") = ПометкаУдаления Тогда
		// Не помеченный на удаление документ может иметь неактивные движения.
		// Однако, при снятии пометки удаления все движения становятся активными.
		Возврат;
	КонецЕсли;
	
	Активность = НЕ ПометкаУдаления;
	
	Для Каждого Движение Из Движения Цикл
		
		Если Движение.Записывать = Ложь Тогда // При работе формы набор может быть уже "потроган" (прочитан, модифицирован)
			// Набор никто не трогал
			Движение.Прочитать();
		КонецЕсли;
		
		Для Каждого Строка Из Движение Цикл
			
			Если Строка.Активность = Активность Тогда
				Продолжить;
			КонецЕсли;
			
			Строка.Активность   = Активность;
			Движение.Записывать = Истина; // На случай, если набор был прочитан выше
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СинхронизироватьАктивностьДвиженийСПометкойУдаления();
	
КонецПроцедуры // ПередЗаписью()
#КонецЕсли

