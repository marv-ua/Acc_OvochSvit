﻿

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
    
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    ВыгрузитьФайл(ВыбраннаяСтрока);
    
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
    
    Отказ = Истина;
    
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    
    Отказ = Истина;
    Если Копирование Тогда 
        Возврат;
    КонецЕсли; 
    Оповещение = Новый ОписаниеОповещения("ОбработкаПомещенияФайла", ЭтотОбъект);
    НачатьПомещениеФайла(Оповещение);    
    
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
    
    Отказ = Истина;
    ВыбраннаяСтрока = Элементы.Список.ТекущаяСтрока;
    Если ЗначениеЗаполнено(ВыбраннаяСтрока) Тогда
        Оповещение = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросУдаленияФайла", ЭтотОбъект, ВыбраннаяСтрока);
        ИмяФайла = Элементы.Список.ТекущиеДанные.Имя;
        ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Удалить файл %1?';uk='Вилучити файл %1?'"), ИмяФайла); 
        ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);  
    КонецЕсли; 
    
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОтветаНаВопросУдаленияФайла(КодВозврата, ВыбраннаяСтрока) Экспорт
	
    Если КодВозврата = КодВозвратаДиалога.Да Тогда
        УдалитьНаСервере(ВыбраннаяСтрока);
        Элементы.Список.Обновить();
    КонецЕсли; 
	
КонецПроцедуры
 
&НаКлиенте
Процедура ВыгрузитьФайл(ВыбраннаяСтрока)
	
    ДополнительныеПараметры = Новый Структура("ОписаниеПередаваемогоФайла", ОписаниеПередаваемогоФайла(ВыбраннаяСтрока));
    Оповещение = Новый ОписаниеОповещения("ВыгрузитьФайлЗавершение", ЭтотОбъект, ДополнительныеПараметры);
     
    НачатьПодключениеРасширенияРаботыСФайлами(Оповещение); 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьФайлЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
    
    ОписаниеПередаваемогоФайла = ДополнительныеПараметры.ОписаниеПередаваемогоФайла;
    
    Если РасширениеПодключено Тогда
        Оповещение = Новый ОписаниеОповещения("НачатьПолучениеФайловЗавершение", ЭтотОбъект);
        ПолучаемыеФайлы = Новый Массив;
        ПолучаемыеФайлы.Добавить(ОписаниеПередаваемогоФайла);
        ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
        ДиалогВыбораФайла.МножественныйВыбор = Ложь;
        ДиалогВыбораФайла.Фильтр = НСтр("ru='Все файлы (*.*)|*.*';uk='Всі файли (*.*)|*.*'"); 
        НачатьПолучениеФайлов(Оповещение, ПолучаемыеФайлы, ДиалогВыбораФайла);
    Иначе
        ПолучитьФайл(ОписаниеПередаваемогоФайла.Хранение, ОписаниеПередаваемогоФайла.Имя);
    КонецЕсли;

КонецПроцедуры
 
&НаСервереБезКонтекста
Процедура УдалитьНаСервере(ВыбраннаяСтрока)
    
    ФайлыОбластейДанных.УдалитьФайл(ВыбраннаяСтрока.Идентификатор);
    
КонецПроцедуры

&НаСервере
Функция ОписаниеПередаваемогоФайла(ВыбраннаяСтрока)
    
    Возврат ФайлыОбластейДанных.ОписаниеПередаваемогоФайла(
        ВыбраннаяСтрока.Идентификатор, УникальныйИдентификатор);
    
КонецФункции

&НаКлиенте 
Процедура НачатьПолучениеФайловЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
    
    Если ЗначениеЗаполнено(ПолученныеФайлы) Тогда
        Оповещение = Новый ОписаниеОповещения("ПриНажатииОповещенияПолученияФайла", ЭтотОбъект, ПолученныеФайлы[0].Имя);
        ПоказатьОповещениеПользователя(НСтр("ru='Файл сохранен';uk='Файл збережено'"), Оповещение, ПолученныеФайлы[0].Имя, БиблиотекаКартинок.Информация32);     
    КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПомещенияФайла(ВыборВыполнен, АдресХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
    Если ВыборВыполнен Тогда
        ЗагрузитьФайл(АдресХранилища, ТолькоИмяФайла(ВыбранноеИмяФайла));
        Элементы.Список.Обновить();
    КонецЕсли; 	
    
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьФайл(АдресХранилища, ИмяФайла)
    
    Данные = ПолучитьИзВременногоХранилища(АдресХранилища);
	ФайлыОбластейДанных.ЗагрузитьФайл(ИмяФайла, Данные); 
	
КонецПроцедуры
 
&НаКлиенте
Функция ТолькоИмяФайла(ВыбранноеИмяФайла)
	
	// Использовать критично на клиенте, т.к. ПолучитьРазделительПути() на сервере может быть другим.
	МассивПодстрок = СтрРазделить(ВыбранноеИмяФайла, ПолучитьРазделительПути(), Ложь);
	Возврат МассивПодстрок.Получить(МассивПодстрок.ВГраница());
	
КонецФункции

&НаКлиенте
Функция ПриНажатииОповещенияПолученияФайла(ПолноеИмяФайла) Экспорт
    
    ПустоеОповещение = Новый ОписаниеОповещения("ПустоеОповещение", ЭтотОбъект);
    НачатьЗапускПриложения(ПустоеОповещение, ПолноеИмяФайла,, Ложь);
	
КонецФункции

&НаКлиенте
Процедура ПустоеОповещение(КодВозврата, ДополнительныеПараметры) Экспорт
    
    Возврат;	
    
КонецПроцедуры
 
#КонецОбласти
