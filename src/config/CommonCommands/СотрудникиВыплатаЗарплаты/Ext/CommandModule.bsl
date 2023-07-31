﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВладелецФормы = ПараметрыВыполненияКоманды.Источник;
	
	Если НЕ ВладелецФормы.Окно = ПараметрыВыполненияКоманды.Окно Тогда
		ТекстПредупреждения = НСтр("ru='Данные о выплате зарплаты не редактируются в отдельном окне';uk='Дані про виплату зарплати не редагуються в окремому вікні'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
	КонецЕсли; 
	
	ПараметрыОткрытия = Новый Структура("ТекущаяОрганизация,ТекущееПодразделение");
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ВладелецФормы);
	
	ПараметрыОткрытия.Вставить("СотрудникСсылка", ПараметрКоманды);

	ОткрытьФорму("Справочник.Сотрудники.Форма.ВыплатаЗарплаты", 
		ПараметрыОткрытия, 
		ВладелецФормы, 
		, 
		ВладелецФормы.Окно);
		
КонецПроцедуры
