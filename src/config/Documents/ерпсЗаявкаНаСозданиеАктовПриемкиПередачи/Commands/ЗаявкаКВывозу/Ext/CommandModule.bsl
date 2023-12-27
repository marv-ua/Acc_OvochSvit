﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Кво = 1;
	Для Каждого Эл Из ПараметрКоманды Цикл
		Состояние(Эл, 100*(Кво/ПараметрКоманды.Количество()),);
		УстановитьСнятьПРизнакНаСервере(Эл);
		Кво = Кво + 1;
	КонецЦикла;
	Попытка
		ПараметрыВыполненияКоманды.Источник.Элементы.Список.Обновить();
	Исключение
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура УстановитьСнятьПРизнакНаСервере(Эл)
	
	Набор = РегистрыСведений.а_ЗаявкиКВывозу.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Эл);
	Набор.Прочитать();
	
	Если Набор.Количество() Тогда
		Набор.Очистить();
	Иначе
		Запись = Набор.Добавить();
		Запись.Объект = Эл;
	КонецЕсли;
	
	Попытка
		Набор.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры