﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураДополнительныхПараметров = Новый Структура("ЗаголовокФормы", НСтр("ru='Предварительный просмотр печатной формы Счет на оплату.';uk='Попередній перегляд друкованої форми Рахунок на оплату.'"));
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.СчетНаОплатуПокупателю", "ПредварительныйПросмотрПечатнойФормыСчетНаОплату", ПараметрКоманды, ПараметрыВыполненияКоманды, Неопределено);
	
КонецПроцедуры
