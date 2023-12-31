﻿
#Область ПрограммныйИнтерфейс

#Область КопированиеВставкаСтрокЧерезБуферОбмена

// Процедура оповещает о копировании строк табличной части
//
// Параметры:
//  Форма            - УправляемаяФорма - форма, откуда произошло копирование строк
//
//  КоличествоСтрок  - Число - количество скопированных строк
//
Процедура ОповеститьОКопированииСтрокВБуферОбмена(Форма, КоличествоСтрок) Экспорт
	
	НавигационнаяСсылка = Форма.Окно.ПолучитьНавигационнуюСсылку();
	ПоказатьОповещениеПользователя(НСтр("ru='Копирование в буфер обмена';uk= 'Копіювання в буфер обміну'"), НавигационнаяСсылка,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Скопировано строк: %1';uk= 'Скопійовано рядків: %1'"), КоличествоСтрок));
	Оповестить("ДанныеСкопированыВБуферОбмена");

КонецПроцедуры

// Процедура оповещает о вставке строк в табличную часть
//
// Параметры:
//  Форма            - УправляемаяФорма - форма, куда была произведена вставка строк
//
//  КоличествоСтрок  - Число - количество вставленных строк
//
Процедура ОповеститьОВставкеСтрокИзБуфераОбмена(Форма, КоличествоСтрок) Экспорт

	НавигационнаяСсылка = Форма.Окно.ПолучитьНавигационнуюСсылку();
	ПоказатьОповещениеПользователя(НСтр("ru='Вставка из буфера обмена';uk= 'Вставка із буфера обміну'"), НавигационнаяСсылка,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Вставлено строк: %1';uk= 'Вставлено рядків: %1 '"), КоличествоСтрок));

КонецПроцедуры

#КонецОбласти

#КонецОбласти