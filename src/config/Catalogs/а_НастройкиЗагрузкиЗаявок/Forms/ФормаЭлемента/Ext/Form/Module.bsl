﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДоступностьЭлементовФормыНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		Объект.Наименование = СокрЛП(Объект.Контрагент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КолонкаПунктРазгрузкиПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормыНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементовФормыНаКлиенте()
	//Элементы.КолонкаКоличество.Доступность = (Объект.КолонкаПунктРазгрузки = 0) И (Объект.СтрокаПунктРазгрузки = 0);
КонецПроцедуры


