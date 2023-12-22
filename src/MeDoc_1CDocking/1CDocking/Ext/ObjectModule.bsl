﻿Функция СведенияОВнешнейОбработке() Экспорт 
	
	ДанныеРегистрации = Новый Структура();
	ДанныеРегистрации.Вставить("Наименование",НСтр("ru = 'Стыковка М.E.Doc';uk = 'Стикування М.E.Doc'"));  
	ДанныеРегистрации.Вставить("БезопасныйРежим", Ложь);
	ДанныеРегистрации.Вставить("Версия", "7.35");
	ДанныеРегистрации.Вставить("Информация",НСтр("ru = 'Внешняя обработка для обмена информацией между программой М.E.Doc и учетной системой BAS" + Символы.ПС + "Бухгалтерия 2.0';uk = 'Зовнішня обробка для обміну інформацією між програмою М.E.Doc та обліковою системою BAS" + Символы.ПС + "Бухгалтерія 2.0'"));  

	ДанныеРегистрации.Вставить("Вид", "ДополнительнаяОбработка"); 
	
	ТабЗнКоманды = Новый ТаблицаЗначений; ТабЗнКоманды.Колонки.Добавить("Идентификатор"); 
	ТабЗнКоманды.Колонки.Добавить("Использование");
	ТабЗнКоманды.Колонки.Добавить("Представление"); 
	
	НовСтрока = ТабЗнКоманды.Добавить();
	НовСтрока.Идентификатор = "Стиковка М.E.Doc"; 
	НовСтрока.Использование = "ОткрытиеФормы";
	НовСтрока.Представление = "Стиковка М.E.Doc";
	ДанныеРегистрации.Вставить("Команды", ТабЗнКоманды); 
	
	Возврат ДанныеРегистрации;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////
ВерсияСтыковки = "7.35.2";
ТипСтыковки = "2.0";