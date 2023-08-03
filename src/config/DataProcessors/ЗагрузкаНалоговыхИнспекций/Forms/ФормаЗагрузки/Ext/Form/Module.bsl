﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки)

	ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание);

КонецПроцедуры

&НаСервере
Функция ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла)
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ДвоичныеДанныеФайла", ДвоичныеДанныеФайла);
	ПараметрыВыгрузки.Вставить("НеОбновлять", НеОбновлять);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ЗагрузкаНалоговыхИнспекций.ЗагрузитьДанныеГНИ(ПараметрыВыгрузки, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);		
	Иначе
		НаименованиеЗадания = НСтр("ru='Загрузка данных в справочник ""Налоговые инспекции""';uk='Завантаження даних у довідник ""Податкові інспекції""'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.ЗагрузкаНалоговыхИнспекций.ЗагрузитьДанныеГНИ", 
			ПараметрыВыгрузки, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьРезультат();
	КонецЕсли;

	Возврат Результат;
		
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ОповеститьОбИзменении(Тип("СправочникСсылка.НалоговыеИнспекции"));
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультат()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Строка")
		И ЗначениеЗаполнено(Результат) Тогда 
		ТекстСообщения = Результат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ИмяФайлаДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайла(Элемент, ПроверятьСуществование=Ложь)
		
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	ДиалогВыбораФайла.Фильтр                  = НСтр("ru='Файл данных';uk= 'Файл з даними'") + " (*.xml)|*.xml";
	ДиалогВыбораФайла.Заголовок               = НСтр("ru='Выберите файл';uk= 'Виберіть файл'");
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.Расширение              ="xml";
	ДиалогВыбораФайла.ИндексФильтра           = 0;	
	ДиалогВыбораФайла.ПолноеИмяФайла              = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Ложь;

	Если ДиалогВыбораФайла.Выбрать() Тогда
		Объект.ИмяФайлаДанных = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
		
	ЭтаФорма.ТекстСообщения = "";
	
	АдресФайла = Неопределено;
	
	ОчиститьСообщения();
	
	Если РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда	
		
		//	Вариант для установленного расширения для работы с файлами
		
		Если НЕ ЗначениеЗаполнено(Объект.ИмяФайлаДанных) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан файл данных для загрузки';uk='Не вказаний файл даних для завантаження'"));
			Возврат;
		КонецЕсли;
				
		ПомещаемыеФайлы = Новый Массив;
		ПомещенныеФайлы = Новый Массив;
		МассивВызовов 	= Новый Массив;
		
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Объект.ИмяФайлаДанных);
		
		ПомещаемыеФайлы.Добавить(ОписаниеФайла);
		
		МассивВызовов.Добавить(Новый Массив);
		
		МассивВызовов[0].Добавить("ПоместитьФайлы");
		МассивВызовов[0].Добавить(ПомещаемыеФайлы);
		МассивВызовов[0].Добавить(ПомещенныеФайлы);
		МассивВызовов[0].Добавить("");
		МассивВызовов[0].Добавить(Ложь);
		
		Если ЗапроситьРазрешениеПользователя(МассивВызовов) Тогда
			ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь);
			ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
			АдресФайла = ОписаниеФайлов.Хранение;
		КонецЕсли;
		
		ВыполнитьЗагрузкуДанных(АдресФайла);
		
	Иначе
		// Веб клиент без расширения для работы с файлами
		Попытка
			ПомещениеФайлаЗавершение = Новый ОписаниеОповещения("ПомещениеФайлаЗавершение", ЭтотОбъект);
			НачатьПомещениеФайла(ПомещениеФайлаЗавершение, АдресФайла, , Истина, УникальныйИдентификатор);
		Исключение
			ШаблонСообщения = НСтр("ru='При чтении файла возникла ошибка
|%1';uk='При читанні файлу виникла помилка
|%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ОписаниеОшибки = ИнформацияОбОшибке();
			ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки);
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлаЗавершение(Результат, АдресФайлаПомещенный, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	ВыполнитьЗагрузкуДанных(АдресФайлаПомещенный);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуДанных(АдресФайла)
	
	Если АдресФайла = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось получить данные для загрузки';uk='Не вдалося отримати дані для завантаження'"));
		Возврат;
	КонецЕсли;
	
	Результат = ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ОповеститьОбИзменении(Тип("СправочникСсылка.НалоговыеИнспекции"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Элементы.ИмяФайлаДанных.Видимость = Форма.ВозможностьВыбораФайлов;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВозможностьВыбораФайлов = РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

	
