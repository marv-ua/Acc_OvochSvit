﻿#Область ОбработкаЗапросов

#Область ХранилищеИИдентификатор

Функция ХранилищеИИдентификаторGETЗапрос(Запрос)
	
	Возврат ХранилищеИИдентификаторGETОтвет(Запрос);
	
КонецФункции

Функция ХранилищеИИдентификаторPOSTЗапрос(Запрос)
	
	Возврат ХранилищеИИдентификаторPOSTОтвет(Запрос);
	
КонецФункции

#КонецОбласти

#Область ТомИПутьКФайлу

Функция ТомИПутьКФайлуGETЗапрос(Запрос)
	
	Возврат ТомИПутьКФайлуGETОтвет(Запрос);
	
КонецФункции

Функция ТомИПутьКФайлуPOSTЗапрос(Запрос)
	
	Возврат ТомИПутьКФайлуPOSTОтвет(Запрос);
	
КонецФункции

#КонецОбласти

#Область Получить

Функция ПолучитьGETЗапрос(Запрос)
	
	Возврат ПолучитьGETОтвет(Запрос);
	
КонецФункции

#КонецОбласти

#Область Отправить

Функция ОтправитьPUTЗапрос(Запрос)
	
	Возврат ОтправитьPUTОтвет(Запрос);

КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПолучениеОтветов

Функция ХранилищеИИдентификаторGETОтвет(Запрос)
	
	Перем Ответ;
	
	// Получение из запроса необходимых методу параметров.
	ПараметрыЗапроса = ПараметрыМетодаИзЗапроса(ХранилищеИИдентификаторGET(), Запрос);
	
	// Получение менеджера логического хранилища по имени хранилища.
	МенеджерХранилища = МенеджерЛогическогоХранилища(ПараметрыЗапроса.Storage, Ответ);
	
	// Проверка существования данных с указанным идентификатором в логическом хранилище.
	ОписаниеДанныхЛогическогоХранилища(МенеджерХранилища, ПараметрыЗапроса.Storage, ПараметрыЗапроса.ID, Ответ);
	
	Если Ответ = Неопределено Тогда
		
		ИдентификаторЗапроса = РегистрыСведений.ВременныеИдентификаторыЗапросов.ЗарегистрироватьЗапрос(Запрос, ХранилищеИИдентификаторGET().ПолноеИмя());
		Location = Запрос.БазовыйURL + "/download/" + ИдентификаторЗапроса;
		
		Ответ = Новый HTTPСервисОтвет(302);
		Ответ.Заголовки.Вставить("Location", Location);
		Ответ.Заголовки.Вставить("Accept-Ranges", "bytes");
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ХранилищеИИдентификаторPOSTОтвет(Запрос)
	
	Перем Ответ;
	
	// Получение из запроса необходимых методу параметров.
	ПараметрыЗапроса = ПараметрыМетодаИзЗапроса(ХранилищеИИдентификаторPOST(), Запрос);
	
	// Получение менеджера логического хранилища по имени хранилища.
	МенеджерЛогическогоХранилища(ПараметрыЗапроса.Storage, Ответ);
	
	Если Ответ = Неопределено Тогда
		
		ИдентификаторЗапроса = РегистрыСведений.ВременныеИдентификаторыЗапросов.ЗарегистрироватьЗапрос(Запрос, ХранилищеИИдентификаторPOST().ПолноеИмя());
		Location = Запрос.БазовыйURL + "/upload/" + ИдентификаторЗапроса;
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Location", Location);
		Ответ.Заголовки.Вставить("Accept-Ranges", "bytes");
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ТомИПутьКФайлуGETОтвет(Запрос)
	
	Перем Ответ;
	
	// Получение из запроса необходимых методу параметров.
	ПараметрыЗапроса = ПараметрыМетодаИзЗапроса(ТомИПутьКФайлуGET(), Запрос);
	
	// Получение менеджера физического хранилища по идентификатору хранилища.
	МенеджерХранилища = МенеджерФизическогоХранилища(ПараметрыЗапроса.VolumeID, Ответ);
	
	// Проверка существования данных с указанным идентификатором в физическом хранилище.
	ОписаниеДанныхФизическогоХранилища(МенеджерХранилища, ПараметрыЗапроса.VolumeID, ПараметрыЗапроса.PathAndFileName, Ответ);
	
	Если Ответ = Неопределено Тогда
		
		ИдентификаторЗапроса = РегистрыСведений.ВременныеИдентификаторыЗапросов.ЗарегистрироватьЗапрос(Запрос, ТомИПутьКФайлуGET().ПолноеИмя());
		Location = Запрос.БазовыйURL + "/download/" + ИдентификаторЗапроса;
		
		Ответ = Новый HTTPСервисОтвет(302);
		Ответ.Заголовки.Вставить("Location", Location);
		Ответ.Заголовки.Вставить("Accept-Ranges", "bytes");
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ТомИПутьКФайлуPOSTОтвет(Запрос)
	
	Перем Ответ;
	
	// Получение из запроса необходимых методу параметров.
	ПараметрыЗапроса = ПараметрыМетодаИзЗапроса(ТомИПутьКФайлуPOST(), Запрос);
	
	// Получение менеджера физического хранилища по идентификатору хранилища.
	МенеджерФизическогоХранилища(ПараметрыЗапроса.VolumeID, Ответ);
	
	Если Ответ = Неопределено Тогда
		
		ИдентификаторЗапроса = РегистрыСведений.ВременныеИдентификаторыЗапросов.ЗарегистрироватьЗапрос(Запрос, ТомИПутьКФайлуPOST().ПолноеИмя());
		Location = Запрос.БазовыйURL + "/upload/" + ИдентификаторЗапроса;
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Location", Location);
		Ответ.Заголовки.Вставить("Accept-Ranges", "bytes");
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ПолучитьGETОтвет(Запрос)
	
	Перем Ответ;
	
	ПараметрыЗапроса = ПараметрыМетодаИзЗапроса(ПолучитьGET(), Запрос);
	
	ИсходныйЗапрос = РегистрыСведений.ВременныеИдентификаторыЗапросов.ЗапросПоИдентификатору(ПараметрыЗапроса.ID);
	
	Если ИсходныйЗапрос = Неопределено Тогда
		
		Ответ = Новый HTTPСервисОтвет(404);
		
	КонецЕсли;
	
	Если Ответ = Неопределено Тогда
		
		ТипИсходногоЗапроса = Метаданные.НайтиПоПолномуИмени(ИсходныйЗапрос["ТипЗапроса"]);
		ПараметрыИсходногоЗапроса = ПараметрыМетодаИзЗапроса(ТипИсходногоЗапроса, ИсходныйЗапрос);
		
		Если ТипИсходногоЗапроса = ХранилищеИИдентификаторGET() Тогда
			
			МенеджерХранилища = МенеджерЛогическогоХранилища(ПараметрыИсходногоЗапроса.Storage, Ответ);
			ОписаниеДанных = ОписаниеДанныхЛогическогоХранилища(МенеджерХранилища, ПараметрыИсходногоЗапроса.Storage, ПараметрыИсходногоЗапроса.ID, Ответ);
			
		ИначеЕсли ТипИсходногоЗапроса = ТомИПутьКФайлуGET() Тогда
			
			МенеджерХранилища = МенеджерФизическогоХранилища(ПараметрыИсходногоЗапроса.VolumeID, Ответ);
			ОписаниеДанных = ОписаниеДанныхФизическогоХранилища(МенеджерХранилища, ПараметрыИсходногоЗапроса.VolumeID, ПараметрыИсходногоЗапроса.PathAndFileName, Ответ);
			
		КонецЕсли;
		
		Диапазон = ЗапрошенныйДиапазон(ПараметрыЗапроса.Range, Ответ);
		
		Если ОписаниеДанных = Неопределено Тогда
			
			Ответ = Новый HTTPСервисОтвет(404);
			
		ИначеЕсли Диапазон = Неопределено Тогда
			
			Ответ = Новый HTTPСервисОтвет(200);
			Ответ.Заголовки.Вставить("Content-Disposition", СтрШаблон("attachment; filename=""%1""", ОписаниеДанных.ИмяФайла));
			Ответ.Заголовки.Вставить("Content-Type", "application/octet-stream");
			
			Данные = МенеджерХранилища.Данные(ОписаниеДанных);
			
			Если ТипЗнч(Данные) = Тип("Строка") Тогда
				
				Ответ.УстановитьИмяФайлаТела(Данные);
				
			ИначеЕсли ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
				
				Ответ.УстановитьТелоИзДвоичныхДанных(Данные);
				
			КонецЕсли;
			
		Иначе
			
			Ответ = Новый HTTPСервисОтвет(206);
			Ответ.Заголовки.Вставить("Content-Disposition", СтрШаблон("attachment; filename=""%1""", ОписаниеДанных.ИмяФайла));
			Ответ.Заголовки.Вставить("Content-Type", "application/octet-stream");
			
			ЧтениеДанных = Новый ЧтениеДанных(МенеджерХранилища.Данные(ОписаниеДанных));
			ЧтениеДанных.Пропустить(Диапазон.Начало);
			РезультатЧтенияДанных = ЧтениеДанных.Прочитать(Диапазон.Конец - Диапазон.Начало + 1);
			
			Ответ.УстановитьТелоИзДвоичныхДанных(РезультатЧтенияДанных.ПолучитьДвоичныеДанные());
			Ответ.Заголовки.Вставить("Content-Range", СтрШаблон("bytes %1-%2/%3", Формат(Диапазон.Начало, "ЧН=0; ЧГ=0"), Формат(Диапазон.Начало + РезультатЧтенияДанных.Размер - 1, "ЧН=0; ЧГ=0"), Формат(ОписаниеДанных.Размер, "ЧН=0; ЧГ=0")));
			
			ЧтениеДанных.Закрыть();
			
			РегистрыСведений.ВременныеИдентификаторыЗапросов.ПродлитьДействиеВременногоИдентификатора(ПараметрыЗапроса.ID);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ОтправитьPUTОтвет(Запрос)
	
	Перем Ответ;
	
	ПараметрыЗапроса = ПараметрыМетодаИзЗапроса(ОтправитьPUT(), Запрос);
	
	ИсходныйЗапрос = РегистрыСведений.ВременныеИдентификаторыЗапросов.ЗапросПоИдентификатору(ПараметрыЗапроса.ID);
	
	Если ИсходныйЗапрос = Неопределено Тогда
		
		Ответ = Новый HTTPСервисОтвет(404);
		
	КонецЕсли;
	
	Если Ответ = Неопределено Тогда
		
		ТипИсходногоЗапроса = Метаданные.НайтиПоПолномуИмени(ИсходныйЗапрос["ТипЗапроса"]);
		ПараметрыИсходногоЗапроса = ПараметрыМетодаИзЗапроса(ТипИсходногоЗапроса, ИсходныйЗапрос);
		
		Если ТипИсходногоЗапроса = ХранилищеИИдентификаторPOST() Тогда
			
			МенеджерХранилища = МенеджерЛогическогоХранилища(ПараметрыИсходногоЗапроса.Storage, Ответ);
			ИмяФайла = ПараметрыИсходногоЗапроса.ID;
			
		ИначеЕсли ТипИсходногоЗапроса = ТомИПутьКФайлуPOST() Тогда
			
			МенеджерХранилища = МенеджерФизическогоХранилища(ПараметрыИсходногоЗапроса.VolumeID, Ответ);
			ИмяФайла = ПараметрыИсходногоЗапроса.PathAndFileName;
			
		КонецЕсли;
		
		ПолученныйДиапазон = ПередачаДанныхСлужебный.ПолученныйДиапазон(Запрос.Заголовки.Получить("Content-Range"));
		
		ПотокЗаписи = ФайловыеПотоки.Открыть(ИсходныйЗапрос["ИмяВременногоФайла"], РежимОткрытияФайла.Дописать, ДоступКФайлу.Запись);
		
		ПотокДанных = Запрос.ПолучитьТелоКакПоток();
		ПотокДанных.КопироватьВ(ПотокЗаписи);
		
		ПотокЗаписи.Закрыть();
		ПотокДанных.Закрыть();
		
		Если ЗначениеЗаполнено(ПолученныйДиапазон) И ПолученныйДиапазон.Конец < ПолученныйДиапазон.Размер - 1 Тогда
			
			Ответ = Новый HTTPСервисОтвет(202);
			РегистрыСведений.ВременныеИдентификаторыЗапросов.ПродлитьДействиеВременногоИдентификатора(ПараметрыЗапроса.ID);
			
		Иначе
			
			Ответ = Новый HTTPСервисОтвет(201);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=UTF-8");
			
			ОписаниеДанных = Новый Структура("ИмяФайла, Данные, УдалитьФайлДанных", ИмяФайла, ИсходныйЗапрос["ИмяВременногоФайла"], Истина);
			
			Результат = МенеджерХранилища.Загрузить(ОписаниеДанных);
			
			Если ТипЗнч(Результат) = Тип("Строка") Тогда
			
				ДанныеОтвета = Новый Структура("id", Строка(Результат));
				
			Иначе
				
				ДанныеОтвета = Результат;
				
			КонецЕсли;
			
		    ЗаписьJSON = Новый ЗаписьJSON;
		    ЗаписьJSON.УстановитьСтроку();
		    ЗаписатьJSON(ЗаписьJSON, ДанныеОтвета);
		    Ответ.УстановитьТелоИзСтроки(ЗаписьJSON.Закрыть());
			
			Если ОписаниеДанных.УдалитьФайлДанных Тогда
				
				Попытка
					
					УдалитьФайлы(ИсходныйЗапрос["ИмяВременногоФайла"]);
					
				Исключение
					
					ЗаписьЖурналаРегистрации(НСтр("ru='ПередачаДанных';uk='ПередачаДанных'",Метаданные.ОсновнойЯзык.КодЯзыка), УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область Служебные

Функция ПараметрыМетодаИзЗапроса(Метод, Запрос)
	
	ПараметрыМетода = Новый Структура;
	
	Если Метод = ХранилищеИИдентификаторGET() Тогда
		
		ПараметрыМетода.Вставить("Storage", Запрос["ПараметрыURL"].Получить("Storage"));
		ПараметрыМетода.Вставить("ID", Запрос["ПараметрыURL"].Получить("ID"));
		
	ИначеЕсли Метод = ХранилищеИИдентификаторPOST() Тогда
		
		ПараметрыМетода.Вставить("Storage", Запрос["ПараметрыURL"].Получить("Storage"));
		ПараметрыМетода.Вставить("ID", Запрос["ПараметрыURL"].Получить("ID"));
		
	ИначеЕсли Метод = ТомИПутьКФайлуGET() Тогда
		
		ПараметрыМетода.Вставить("VolumeID", Запрос["ПараметрыURL"].Получить("VolumeID"));
		ПараметрыМетода.Вставить("PathAndFileName", Запрос["ПараметрыURL"].Получить("*"));
		
	ИначеЕсли Метод = ТомИПутьКФайлуPOST() Тогда
		
		ПараметрыМетода.Вставить("VolumeID", Запрос["ПараметрыURL"].Получить("VolumeID"));
		ПараметрыМетода.Вставить("PathAndFileName", Запрос["ПараметрыURL"].Получить("*"));
		
	ИначеЕсли Метод = ПолучитьGET() Тогда
		
		ПараметрыМетода.Вставить("ID", Запрос["ПараметрыURL"].Получить("ID"));
		ПараметрыМетода.Вставить("Range", Запрос["Заголовки"].Получить("Range"));
		
	ИначеЕсли Метод = ОтправитьPUT() Тогда
		
		ПараметрыМетода.Вставить("ID", Запрос["ПараметрыURL"].Получить("ID"));
		ПараметрыМетода.Вставить("Range", Запрос["Заголовки"].Получить("Range"));
		
	КонецЕсли;
	
	Возврат ПараметрыМетода;
	
КонецФункции

Функция ХранилищеИИдентификаторGET()
	
	Возврат Метаданные.HTTPСервисы.ПередачаДанных.ШаблоныURL.ХранилищеИИдентификатор.Методы.GET;
	
КонецФункции

Функция ХранилищеИИдентификаторPOST()
	
	Возврат Метаданные.HTTPСервисы.ПередачаДанных.ШаблоныURL.ХранилищеИИдентификатор.Методы.POST;
	
КонецФункции

Функция ТомИПутьКФайлуGET()
	
	Возврат Метаданные.HTTPСервисы.ПередачаДанных.ШаблоныURL.ТомИПутьКФайлу.Методы.GET;
	
КонецФункции

Функция ТомИПутьКФайлуPOST()
	
	Возврат Метаданные.HTTPСервисы.ПередачаДанных.ШаблоныURL.ТомИПутьКФайлу.Методы.POST;
	
КонецФункции

Функция ПолучитьGET()
	
	Возврат Метаданные.HTTPСервисы.ПередачаДанных.ШаблоныURL.Получить.Методы.GET;
	
КонецФункции

Функция ОтправитьPUT()
	
	Возврат Метаданные.HTTPСервисы.ПередачаДанных.ШаблоныURL.Отправить.Методы.PUT;
	
КонецФункции

Функция МенеджерЛогическогоХранилища(Знач Storage, Ответ)
	
	Если Ответ <> Неопределено Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	МенеджерХранилища = ПередачаДанныхСервер.ВсеМенеджерыЛогическихХранилищ()[Storage];
	
	Если МенеджерХранилища = Неопределено Тогда
		
		Ответ = Новый HTTPСервисОтвет(415);
			
	КонецЕсли;
	
	Возврат МенеджерХранилища;
	
КонецФункции

Функция МенеджерФизическогоХранилища(Знач VolumeID, Ответ)
	
	Если Ответ <> Неопределено Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	МенеджерХранилища = ПередачаДанныхСервер.ВсеМенеджерыФизическихХранилищ()[VolumeID];
	
	Если МенеджерХранилища = Неопределено Тогда
		
		Ответ = Новый HTTPСервисОтвет(415);
			
	КонецЕсли;
	
	Возврат МенеджерХранилища;
	
КонецФункции

Функция ОписаниеДанныхЛогическогоХранилища(МенеджерХранилища, Знач Storage, Знач ID, Ответ)
	
	Если Ответ <> Неопределено Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Попытка
		
		Описание = МенеджерХранилища.Описание(Storage, ID);
		
	Исключение
		
		Описание = Неопределено;
		
	КонецПопытки;
	
	Если Описание = Неопределено Тогда
		
		Ответ = Новый HTTPСервисОтвет(404);
		
	КонецЕсли;
	
	Возврат Описание;
	
КонецФункции

Функция ОписаниеДанныхФизическогоХранилища(МенеджерХранилища, Знач VolumeID, Знач PathAndFileName, Ответ)
	
	Если Ответ <> Неопределено Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Попытка
	
		Описание = МенеджерХранилища.Описание(VolumeID, PathAndFileName);
	
	Исключение
		
		Описание = Неопределено;
		
	КонецПопытки;
	
	Если Описание = Неопределено Тогда
		
		Ответ = Новый HTTPСервисОтвет(404);
		
	КонецЕсли;
	
	Возврат Описание;
	
КонецФункции

Функция ЗапрошенныйДиапазон(Знач Range, Ответ)
	
	Диапазон = Неопределено;
	Range = СокрЛП(Range);
	
	Если НЕ ПустаяСтрока(Range) И СтрНачинаетсяС(Range, "bytes=") Тогда
		
		Range = Прав(Range, СтрДлина(Range) - СтрДлина("bytes="));
		МассивПодстрок = СтрРазделить(Range, "-");
		
		Попытка
			
			Начало = Число(МассивПодстрок[0]);
			Конец = Число(МассивПодстрок[1]);
			
			Диапазон = Новый Структура("Начало, Конец", Начало, Конец);
			
		Исключение
			
			Ответ = Новый HTTPСервисОтвет(416);
			
		КонецПопытки;
		
	КонецЕсли;
		
	Возврат Диапазон;
	
КонецФункции

#КонецОбласти