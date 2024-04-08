﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога; 
	ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим); 
	ДиалогОткрытия.Каталог = ""; 
	ДиалогОткрытия.МножественныйВыбор = Ложь; 
	ДиалогОткрытия.Заголовок = "Оберіть каталог"; 

    Параметр = "";
    Оповещение = Новый ОписаниеОповещения("ВыборКаталогаЗавершение", ЭтотОбъект, Параметр);
    ДиалогОткрытия.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКаталогаЗавершение(Результат, ДопПараметры) Экспорт
	
    Если Результат = Неопределено Тогда
         Сообщить("Каталог не обрано");
         Возврат;
     КонецЕсли;
    Путь = Результат[0];
	
	НачатьПоискФайлов(Новый ОписаниеОповещения("ПоискФайловЗавершение", ЭтотОбъект), Путь, "*.*", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискФайловЗавершение(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если НайденныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивЗагруженных = Новый Массив;;
	МассивНеЗагруженных = Новый Массив;
	
	Для Каждого Файл Из НайденныеФайлы Цикл
		Если ПустаяСтрока(Файл.Расширение) Тогда
			МассивНеЗагруженных.Добавить(Файл.Имя);
			Продолжить;
		КонецЕсли;
		
		//Док = НайтиДокументНаСервере(СокрЛП(Файл.ИмяБезРасширения));
		
			
        ДД = Новый ДвоичныеДанные(Файл.ПолноеИмя);
		ПрикрепитьКДокументуНаСервере(ДД, Файл.ИмяБезРасширения, СтрЗаменить(Файл.Расширение, ".", ""), МассивЗагруженных, МассивНеЗагруженных);
		
	КонецЦикла;
	
	Если МассивНеЗагруженных.Количество() Тогда
		Сообщить("Не завантажено файли:");
		Для Каждого Элемент Из МассивНеЗагруженных Цикл
			
			Сообщить(Элемент);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрикрепитьКДокументуНаСервере(ДД, Знач ИмяБезРасширения, Знач РасширениеБезТочки, МассивЗагруженных, МассивНеЗагруженных)
	
	Если СтрНайти(ИмяБезРасширения, " ") = 0 Тогда
		ИмяБезРасширенияДляПоиска = ИмяБезРасширения;
	Иначе
		ИмяБезРасширенияДляПоиска = СокрЛП(Лев(ИмяБезРасширения, СтрНайти(ИмяБезРасширения, " ")));
	КонецЕсли;

	ВладелецФайлов = НайтиДокументНаСервере(СтрЗаменить(ИмяБезРасширенияДляПоиска,"_", "/"));
	Если Не ЗначениеЗаполнено(ВладелецФайлов) Тогда
		// дополнить нулями 
		ВладелецФайлов = НайтиДокументНаСервере(
			Строка(
				Формат(
					СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ИмяБезРасширенияДляПоиска)
					, "ЧЦ=11; ЧВН=; ЧГ="
				)
			)
		);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВладелецФайлов) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	РеализацияТоваровУслугПрисоединенныеФайлы.Наименование КАК Наименование,
		               |	РеализацияТоваровУслугПрисоединенныеФайлы.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная,
		               |	РеализацияТоваровУслугПрисоединенныеФайлы.ДатаСоздания КАК ДатаСоздания,
		               |	РеализацияТоваровУслугПрисоединенныеФайлы.Изменил КАК Изменил
		               |ИЗ
		               |	Справочник.РеализацияТоваровУслугПрисоединенныеФайлы КАК РеализацияТоваровУслугПрисоединенныеФайлы
		               |ГДЕ
		               |	РеализацияТоваровУслугПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
		               |	И РеализацияТоваровУслугПрисоединенныеФайлы.Наименование = &Наименование";
		Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайлов);
		Запрос.УстановитьПараметр("Наименование", ИмяБезРасширения);
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
		
			АдресВХранилище = ПоместитьВоВременноеХранилище(ДД);
			ПараметрыФайла = ПараметрыДобавленияФайла();
			ПараметрыФайла.ИмяБезРасширения = ИмяБезРасширения;
			ПараметрыФайла.РасширениеБезТочки = РасширениеБезТочки;
			ПараметрыФайла.ВладелецФайлов = ВладелецФайлов;
			СсылкаНаФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла,
				АдресВХранилище,
				"Файл загружен в документ при загрузке из Excel: "  + ТекущаяДата(),
			);
			МассивЗагруженных.Добавить(""+ ИмяБезРасширения + "." + РасширениеБезТочки);
		Иначе
			МассивНеЗагруженных.Добавить(""+ИмяБезРасширения + "." + РасширениеБезТочки);	
		КонецЕсли;
		
	Иначе
		МассивНеЗагруженных.Добавить(""+ИмяБезРасширения + "." + РасширениеБезТочки);	
	КонецЕсли;
	
КонецПроцедуры

//  ПараметрыФайла - Структура - Параметры с данными файла.
//       * Автор                        - Ссылка - Пользователь, создавший файл.
//       * ВладелецФайлов               - ОпределяемыйТип.ВладелецПрисоединенныхФайлов - Папка файлов или объект, к которому
//                                        требуется прикрепить добавляемый файл.
//       * ИмяБезРасширения             - Строка - Имя файла без расширения.
//       * РасширениеБезТочки           - Строка - Расширение файла (без точки вначале).
//       * ВремяИзмененияУниверсальное  - Дата   - Дата и время изменения файла (UTC+0:00),
//                                        если не указана, тогда используется ТекущаяУниверсальнаяДата().
//       * ГруппаФайлов                 - Ссылка - Группа справочника с файлами, в которую будет добавлен новый файл.
//       * Кодировка                    - Строка - Необязательный. Кодировка, в которой сохранен файл.
//                                        Список поддерживаемых кодировок см. в справке к методу глобального контекста
//                                        "ПолучитьДвоичныеДанныеИзСтроки".
&НаСервере
Функция ПараметрыДобавленияФайла()
	
	Возврат Новый Структура("Автор,ВладелецФайлов,ИмяБезРасширения,РасширениеБезТочки,ВремяИзмененияУниверсальное,ГруппаФайлов,Кодировка");	
	
КонецФункции

&НаСервере
Функция НайтиДокументНаСервере(Номер)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |ГДЕ
	               |	РеализацияТоваровУслуг.Дата МЕЖДУ &Дата1 И &Дата2
	               |	И РеализацияТоваровУслуг.Номер = &Номер
	               |	И НЕ РеализацияТоваровУслуг.ПометкаУдаления";
	Запрос.УстановитьПараметр("Дата1", ДобавитьМесяц(НачалоГода(ТекущаяДатаСеанса()), -2));
	Запрос.УстановитьПараметр("Дата2", ДобавитьМесяц(ТекущаяДатаСеанса(), 2));
	Запрос.УстановитьПараметр("Номер", Номер);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
	//Возврат Документы.РеализацияТоваровУслуг.НайтиПоНомеру("Номер", НачалоГода(ТекущаяДатаСеанса()));
	
КонецФункции
