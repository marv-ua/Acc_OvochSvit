﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("АмортизацияОС", Истина);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("Документ.ЗакрытиеМесяца.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ФормаСписка_АмортизацияОС", ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
