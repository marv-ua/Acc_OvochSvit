﻿Функция ЗначениеНастройки(ПараметрНастройки, Период = Неопределено) Экспорт
	
	Возврат РегистрыСведений.НастройкиЗаконодательныхИзменений.ПолучитьПоследнее(Период, 
		Новый Структура("ПараметрНастройки", Перечисления.ПараметрыЗаконодательныхИзменений[ПараметрНастройки])).ЗначениеПараметра;
	
КонецФункции