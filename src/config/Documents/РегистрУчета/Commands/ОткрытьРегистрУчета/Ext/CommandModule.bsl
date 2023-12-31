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
	
	ПрисоединенныеФайлыКлиент.ОткрытьФайл(СвойстваПрисоединенногоФайла.ДанныеФайла, Истина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСвойстваПрисоединенногоФайла(ДокументРегистр)
	
	СвойстваПрисоединногоФайла   = Документы.РегистрУчета.ПолучитьСвойстваПрисоединенногоФайлаРегистра(ДокументРегистр);
	СвойстваПрисоединногоФайла.Вставить("ФайлРегистраУчетаПрисоединен", СвойстваПрисоединногоФайла.ПрисоединенныйФайл <> Справочники.РегистрУчетаПрисоединенныеФайлы.ПустаяСсылка());
	СвойстваПрисоединногоФайла.Вставить("ДанныеФайла", ПрисоединенныеФайлы.ПолучитьДанныеФайла(СвойстваПрисоединногоФайла.ПрисоединенныйФайл, Новый УникальныйИдентификатор));
	
	Возврат СвойстваПрисоединногоФайла;
	
КонецФункции



