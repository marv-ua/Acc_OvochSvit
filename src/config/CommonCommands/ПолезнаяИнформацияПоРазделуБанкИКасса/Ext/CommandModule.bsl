﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Раздел, Заголовок", "БанкИКасса", НСтр("ru='Полезная информация по разделу ""Банк и касса""';uk='Корисна інформація по розділу ""Банк і каса""'"));
	ОткрытьФорму("ОбщаяФорма.ПолезнаяИнформация", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ПолезнаяИнформацияПоРазделуБанкИКасса", ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
