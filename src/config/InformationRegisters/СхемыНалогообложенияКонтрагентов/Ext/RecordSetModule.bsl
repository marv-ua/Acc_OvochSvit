﻿Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из ЭтотОбъект Цикл
			
		РеквизитыСхемаНалогообложения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Строка.СхемаНалогообложения, "НалогНаПрибыль,НДС,ЕдиныйНалог");
			
		Строка.ПлательщикНалогаНаПрибыль = РеквизитыСхемаНалогообложения.НалогНаПрибыль;

		Строка.ПлательщикНДС = РеквизитыСхемаНалогообложения.НДС;

		Строка.ПлательщикЕдиногоНалога = РеквизитыСхемаНалогообложения.ЕдиныйНалог;
		
		Строка.ПлательщикНДСПриостановлен = Строка.ПлательщикЕдиногоНалога И Строка.ПлательщикНДС И Строка.ГруппаПлательщикаЕдиногоНалога = Перечисления.ГруппыПлательщиковЕдиногоНалога.ТретьяГруппаОсобая;
		
	КонецЦикла;

КонецПроцедуры
