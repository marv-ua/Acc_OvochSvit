﻿
#Область СлужебныеПроцедурыИФункции

Функция НачатьПроверкуНаличияНовойИнформации() Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.КлючФоновогоЗадания = Строка(Новый УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.ОжидатьЗавершение   = 0;
	ПараметрыВыполненияВФоне.ЗапуститьВФоне      = Истина;
	
	РезультатЗадания = ДлительныеОперации.ВыполнитьВФоне(
		"МониторПортала1СИТС.ПроверитьНаличиеНовойИнформацииВФоне",
		Неопределено,
		ПараметрыВыполненияВФоне);
	
	Если РезультатЗадания.Статус = "Выполнено" Тогда
		
		Результат = ПолучитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
		УдалитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
		Возврат Результат;
		
	ИначеЕсли РезультатЗадания.Статус = "Выполняется" Тогда
		
		Возврат Новый Структура("ИдентификаторЗадания, АдресРезультата",
			РезультатЗадания.ИдентификаторЗадания,
			РезультатЗадания.АдресРезультата);
		
	ИначеЕсли РезультатЗадания.Статус = "Отменено" Тогда
		
		МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru='Не удалось проверить изменения информации Монитора Портала ИТС.
                |Задание отменено администратором.'
                |;uk='Не вдалося перевірити зміни інформації Монітора Порталу ІТС.
                |Завдання скасовано адміністратором.'"));
		Возврат "НетИзменений";
		
	Иначе
		
		МониторПортала1СИТС.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось проверить изменения информации Монитора Портала ИТС.
                    |Задание завершено с ошибкой.
                    |%1'
                    |;uk='Не вдалося перевірити зміни інформації Монітора Порталу ІТС.
                    |Завдання виконано з помилкою.
                    |%1'"),
				РезультатЗадания.ПодробноеПредставлениеОшибки));
		Возврат "Ошибка";
		
	КонецЕсли;
	
КонецФункции

Функция ПроверитьРезультатЗадания(Знач ОписательЗадания) Экспорт
	
	Попытка
		ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ОписательЗадания.ИдентификаторЗадания);
	Исключение
		МониторПортала1СИТС.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось проверить изменения информации Монитора Портала ИТС.
                    |Задание завершено с ошибкой.
                    |%1'
                    |;uk='Не вдалося перевірити зміни інформації Монітора Порталу ІТС.
                    |Завдання виконано з помилкою.
                    |%1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат "Ошибка";
	КонецПопытки;
	
	Если Не ЗаданиеВыполнено Тогда
		Возврат "ЗаданиеАктивно";
	КонецЕсли;
	
	Результат = ПолучитьИзВременногоХранилища(ОписательЗадания.АдресРезультата);
	УдалитьИзВременногоХранилища(ОписательЗадания.АдресРезультата);
	Возврат Результат;
	
КонецФункции

#КонецОбласти