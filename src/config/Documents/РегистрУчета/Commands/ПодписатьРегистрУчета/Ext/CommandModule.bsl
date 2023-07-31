﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СвойстваПрисоединенногоФайла = ПолучитьСвойстваПрисоединенногоФайла(ПараметрКоманды);
	Если НЕ СвойстваПрисоединенногоФайла.ФайлРегистраУчетаПрисоединен = Истина Тогда
		
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1 не содержит присоединенного файла!';uk='%1 не містить приєднаного файлу!'"), 
				 СвойстваПрисоединенногоФайла.РегистрУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваПрисоединенногоФайла.РегистрУчета);
		Возврат;
		
	КонецЕсли;
	
	Если СвойстваПрисоединенногоФайла.ИспользоватьЭП <> Истина Тогда
		СообщениеОбОшибке = НСтр("ru='Для подписи регистра включите использование ЭП в настройках программы!';uk='Для підпису регістра увімкніть використання ЕП у настройках програми!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваПрисоединенногоФайла.РегистрУчета);
		Возврат;
	КонецЕсли;
	
	Если СвойстваПрисоединенногоФайла.ПодписанЭП = Истина Тогда
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1 уже подписан ЭП!';uk='%1 вже підписаний ЕП!'"), 
				 СвойстваПрисоединенногоФайла.РегистрУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваПрисоединенногоФайла.РегистрУчета);
		Возврат;
	КонецЕсли;
	
	ДанныеПодписи = Неопределено;
	
	ПрисоединенныеФайлыКлиент.ПодписатьФайл(СвойстваПрисоединенногоФайла.ПрисоединенныйФайл, Новый УникальныйИдентификатор);	
		
КонецПроцедуры

&НаСервере
Функция ПолучитьСвойстваПрисоединенногоФайла(ДокументРегистр)
	
	СвойстваПрисоединенногоФайла   = Документы.РегистрУчета.ПолучитьСвойстваПрисоединенногоФайлаРегистра(ДокументРегистр);
	СвойстваПрисоединенногоФайла.Вставить("РегистрУчета", ДокументРегистр);
	СвойстваПрисоединенногоФайла.Вставить("ФайлРегистраУчетаПрисоединен", СвойстваПрисоединенногоФайла.ПрисоединенныйФайл <> Справочники.РегистрУчетаПрисоединенныеФайлы.ПустаяСсылка());
	СвойстваПрисоединенногоФайла.Вставить("ДанныеФайла", ПрисоединенныеФайлы.ПолучитьДанныеФайла(СвойстваПрисоединенногоФайла.ПрисоединенныйФайл, Новый УникальныйИдентификатор));
	СвойстваПрисоединенногоФайла.Вставить("ИспользоватьЭП", ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи"));
	Возврат СвойстваПрисоединенногоФайла;
	
КонецФункции


