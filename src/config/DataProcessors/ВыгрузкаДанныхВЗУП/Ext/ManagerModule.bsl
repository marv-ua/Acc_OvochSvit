﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ВыгрузитьДанные(ПараметрыВыгрузки, АдресХранилища) Экспорт
	
	ТекстПравил = Обработки.ВыгрузкаДанныхВЗУП.ПолучитьМакет("ПравилаОбмена");
	
	УниверсальнаяВыгрузкаДанных = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	УниверсальнаяВыгрузкаДанных.ЗагрузитьПравилаОбмена(ТекстПравил.ПолучитьТекст(), "Строка"); 
	УниверсальнаяВыгрузкаДанных.ВыполнитьОбменДаннымиВОптимизированномФормате = Истина;
	
	ИмяФайлаДанных = ПолучитьИмяВременногоФайла("xml");
	
	УниверсальнаяВыгрузкаДанных.ИмяФайлаПравилОбмена = ИмяФайлаДанных;
	УниверсальнаяВыгрузкаДанных.ИмяФайлаОбмена = ИмяФайлаДанных;
	
	ТаблицаПравилВыгрузкиКлиент = ПараметрыВыгрузки.ТаблицаПравилВыгрузки;
	ТаблицаПравилВыгрузкиСервер = УниверсальнаяВыгрузкаДанных.ТаблицаПравилВыгрузки;
	
	УстановитьЗначениеСтрокиДерева(ТаблицаПравилВыгрузкиКлиент.Строки, ТаблицаПравилВыгрузкиСервер);
	
	УниверсальнаяВыгрузкаДанных.РежимОбмена = "Выгрузка";
	////////УниверсальнаяВыгрузкаДанных.ФлагРежимОтладкиОбработчиков = Истина;
	////////УниверсальнаяВыгрузкаДанных.ФлагРежимОтладки = Истина;
	////////УниверсальнаяВыгрузкаДанных.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = "ОбработчикиВыгрузкиВЗУП25";
		
	УниверсальнаяВыгрузкаДанных.ВыполнитьВыгрузку();
	
	Если УниверсальнаяВыгрузкаДанных.ФлагОшибки Тогда		
		ТекстСообщения = НСтр("ru='При выгрузке данных произошла ошибка.';uk='При вивантаженні даних сталася помилка.'");		
	Иначе		
		ТекстСообщения =  НСтр("ru='Выгрузка данных завершена.';uk='Вивантаження даних завершено.'");	
	КонецЕсли;
		
	ФайлДанных = Новый ДвоичныеДанные(ИмяФайлаДанных);
	
	Результат = Новый Структура("Сообщение, ДвоичныеДанные", ТекстСообщения, ФайлДанных);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура УстановитьЗначениеСтрокиДерева(СтрокиДерева, ТаблицаПравилВыгрузки, Включить = Неопределено) Экспорт
	
	Для Каждого СтрокаДерева ИЗ СтрокиДерева Цикл
		ИмяПравила = СтрокаДерева.Имя;	
		Если ЗначениеЗаполнено(ИмяПравила) Тогда
			ПараметрыОтбора = Новый Структура("Имя", ИмяПравила);
			РедактируемыеСтроки = ТаблицаПравилВыгрузки.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
			Для Каждого РедактируемаяСтрока ИЗ РедактируемыеСтроки Цикл
				Если РедактируемаяСтрока <> Неопределено Тогда
					РедактируемаяСтрока.Включить = ?(Включить = Неопределено, СтрокаДерева.Включить, Включить);
				КонецЕсли;		
			КонецЦикла;
		КонецЕсли;		
		Если СтрокаДерева.Строки.Количество() <> 0 Тогда
			УстановитьЗначениеСтрокиДерева(СтрокаДерева.Строки, ТаблицаПравилВыгрузки, Включить);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли