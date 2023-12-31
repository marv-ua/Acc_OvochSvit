﻿
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ЗаполнитьДанныеФормы();
    
КонецПроцедуры
 
#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаданиеПриИзменении(Элемент)
	
	ЗаданиеПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаданиеПриИзмененииНаСервере()
	
    УстановитьИдентификаторЗаданияЗаписи();
    ЗаполнитьДанныеФормы();
	
КонецПроцедуры
 
&НаСервере
Процедура УстановитьИдентификаторЗаданияЗаписи()
	
    Запись.ИдентификаторЗадания = Запись.Задание.УникальныйИдентификатор();	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормы()
	
    ИдентификаторЗадания = Запись.ИдентификаторЗадания;
    ИдентификаторРезультата = Запись.ИдентификаторРезультата;
    ИдентификаторСообщенияОбОшибке = Запись.ИдентификаторСообщенияОбОшибке;
    
    Если ЗначениеЗаполнено(Запись.ИдентификаторРезультата) Тогда
      	ДанныеРезультата = ФайлыОбластейДанных.ДвоичныеДанныеФайла(Запись.ИдентификаторРезультата);
        Результат = ПолучитьСтрокуИзДвоичныхДанных(ДанныеРезультата);
    КонецЕсли; 
    Если ЗначениеЗаполнено(Запись.ИдентификаторСообщенияОбОшибке) Тогда
      	ДанныеСообщенияОбОшибке = ФайлыОбластейДанных.ДвоичныеДанныеФайла(Запись.ИдентификаторСообщенияОбОшибке);
        СообщениеОбОшибке = ПолучитьСтрокуИзДвоичныхДанных(ДанныеСообщенияОбОшибке);
    КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 
