﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ОбработатьНаименованиеДляПоиска(Строка)
	
	// возможны разные написания Звит <-> Звіт
	НомерПозиции = Макс(Найти(Врег(Строка), """1"), Найти(Врег(Строка), """F"));
	Если НомерПозиции > 0 Тогда
	
		Возврат Лев(Строка, НомерПозиции);
	
	КонецЕсли;
		
	Возврат Строка;
	
КонецФункции
	
Функция ПоискЭлементаПоРеквизитам(Наименование1, Наименование2, Источник = "", ЭтоГруппа = Ложь, Родитель = Неопределено)

	РегламОтчеты = Справочники.РегламентированныеОтчеты;

	Если ЭтоГруппа Тогда

		НаименованиеДляПоиска = ОбработатьНаименованиеДляПоиска(Наименование1);
		НайденнаяГруппа = РегламОтчеты.НайтиПоНаименованию(НаименованиеДляПоиска, ?(Наименование1 = НаименованиеДляПоиска, Истина, Ложь), Родитель);

		Если ЗначениеЗаполнено(НайденнаяГруппа)  Тогда

			Возврат НайденнаяГруппа;

		КонецЕсли;

		НаименованиеДляПоиска = ОбработатьНаименованиеДляПоиска(Наименование2);
		НайденнаяГруппа = РегламОтчеты.НайтиПоНаименованию(НаименованиеДляПоиска, ?(Наименование2 = НаименованиеДляПоиска, Истина, Ложь), Родитель);

		Если ЗначениеЗаполнено(НайденнаяГруппа)  Тогда

			Возврат НайденнаяГруппа;

		КонецЕсли;
		
	Иначе

		НайденныйЭлемент = Неопределено;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Источник", Источник);
		Запрос.УстановитьПараметр("Родитель", Родитель);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РегламентированныеОтчеты.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА РегламентированныеОтчеты.Родитель = &Родитель
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПравильныйРодитель,
		|	РегламентированныеОтчеты.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
		|ГДЕ
		|	НЕ РегламентированныеОтчеты.ЭтоГруппа
		|	И РегламентированныеОтчеты.ИсточникОтчета = &Источник
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПравильныйРодитель УБЫВ,
		|	ПометкаУдаления";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			НайденныйЭлемент = Выборка.Ссылка;
		КонецЕсли;
		
		Пока Выборка.Следующий() Цикл
			Если Не Выборка.ПометкаУдаления Тогда
				СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
				СправочникОбъект.УстановитьПометкуУдаления(Истина);
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(НайденныйЭлемент) Тогда
			Возврат НайденныйЭлемент;
		КонецЕсли;

	КонецЕсли;

	Возврат Неопределено;

КонецФункции

Функция РазложитьСтрокуПериодов(Периоды)
	
	ПериодыПредставления = Новый Соответствие;
	
	Для НомСтр = 1 По СтрЧислоСтрок(Периоды) Цикл
	
		ТекСтр = СтрПолучитьСтроку(Периоды, НомСтр);
		Если ПустаяСтрока(ТекСтр) Тогда
			Продолжить;
		КонецЕсли;
		
		ВхождениеРазделителяНачалаДействия = Найти(ТекСтр, "#");
		СтрПустаяДатаНачалаДействия = "00010101000000";
		Если ВхождениеРазделителяНачалаДействия = 0 Тогда
			СтрДатаНачалаДействия = СтрПустаяДатаНачалаДействия;
		Иначе
			СтрДатаНачалаДействия = СокрЛП(Лев(ТекСтр, ВхождениеРазделителяНачалаДействия - 1));
			ДлинаПредставленияДатыНачала = СтрДлина(СтрДатаНачалаДействия);
			Для Инд = ДлинаПредставленияДатыНачала + 1 По СтрДлина(СтрПустаяДатаНачалаДействия) Цикл
				СтрДатаНачалаДействия = СтрДатаНачалаДействия + Сред(СтрПустаяДатаНачалаДействия, Инд, 1);
			КонецЦикла;
		КонецЕсли;
		ДатаНачалаДействия = Дата(СтрДатаНачалаДействия);
		
		ТекСтр = СокрЛП(Сред(ТекСтр, ВхождениеРазделителяНачалаДействия + 1));
		
		МассивСлов = Новый Массив;
		ПредыдущийРазделитель = 0;
		
		Для Сч = 1 По СтрДлина(ТекСтр) Цикл
			
			Если Сред(ТекСтр, Сч, 1) = ";" Тогда
				Слово = СокрЛП(Сред(ТекСтр, ПредыдущийРазделитель + 1, Сч - ПредыдущийРазделитель - 1));
				Если ПустаяСтрока(Слово) Тогда
					Продолжить;
				КонецЕсли;
				МассивСлов.Добавить(Слово);
				ПредыдущийРазделитель = Сч;
			КонецЕсли;
			
		КонецЦикла;
		
		Слово = СокрЛП(Сред(ТекСтр, ПредыдущийРазделитель + 1));
		Если НЕ ПустаяСтрока(Слово) Тогда
			МассивСлов.Добавить(Слово);
		КонецЕсли;
		
		СтруктураТекущегоПериода = Новый Структура;
		Для Каждого Слово Из МассивСлов Цикл
			
			ВхождениеДвоеточия = Найти(Слово, ":");
			Если ВхождениеДвоеточия = 0 Тогда
				Продолжить;
			КонецЕсли;
			Ключ = СокрЛП(Лев(Слово, ВхождениеДвоеточия - 1));
			Значение = СокрЛП(Сред(Слово, ВхождениеДвоеточия + 1));
			
			МассивИнтервалов = Новый Массив;
			ПредыдущийРазделитель = 0;
			Для Сч = 1 По СтрДлина(Значение) Цикл
				
				Если Сред(Значение, Сч, 1) = "," Тогда
					МассивИнтервалов.Добавить(Число(СокрЛП(Сред(Значение, ПредыдущийРазделитель + 1, Сч - ПредыдущийРазделитель - 1))));
					ПредыдущийРазделитель = Сч;
				КонецЕсли;
			
			КонецЦикла;
			
			Интервал = СокрЛП(Сред(Значение, ПредыдущийРазделитель + 1));
			Если НЕ ПустаяСтрока(Интервал) Тогда
				МассивИнтервалов.Добавить(Число(Интервал));
			КонецЕсли;
			
			СтруктураТекущегоПериода.Вставить(Ключ, МассивИнтервалов);
				
		КонецЦикла;
		
		ПериодыПредставления.Вставить(ДатаНачалаДействия, СтруктураТекущегоПериода);
		
	КонецЦикла;
	
	Возврат ПериодыПредставления;
	
КонецФункции

Процедура ПредупредитьПользователя(ТекстПредупреждения)
    	
	#Если ВнешнееСоединение Тогда
		ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Ошибка,,, ТекстПредупреждения);
	#КонецЕсли
	#Если НаСервер Тогда
		РегламентированнаяОтчетностьКлиентСервер.СообщитьОбОшибке(ТекстПредупреждения);
	#КонецЕсли

КонецПроцедуры

Функция ПолучитьСписокОтчетов() Экспорт

	Перем ДеревоОтчетов;

	// определим язык заполнения списка отчетов
	КодЛокализацииИБ = КодЛокализацииИнформационнойБазы();
	КодЯзыкаЛокализации =  ?((КодЛокализацииИБ = "uk_UA") или (КодЛокализацииИБ = "uk"),"uk","ru");
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000));

	ОписаниеТиповЧисло  = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1));

	МассивБулево = Новый Массив;
	МассивБулево.Добавить(Тип("Булево"));
	ОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

	// Дерево значений содержит иерархию элементов справочника РегламентированныеОтчеты.
	// В колонках дерева значений отображается следующая информация:
	//   - наименование отчета;
	//   - описание отчета;
	//   - место нахождения отчета;
	//   - метка выбора отчета.
	ДеревоОтчетов = Новый ДеревоЗначений;
	ДеревоОтчетов.Колонки.Добавить( "Наименование", ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "Наименование2", ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "Описание",     ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "Источник",     ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "ЭтоГруппа",    ОписаниеТиповБулево );
	ДеревоОтчетов.Колонки.Добавить( "МеткаВыбора",  ОписаниеТиповЧисло  );
	ДеревоОтчетов.Колонки.Добавить( "Периоды",  	ОписаниеТиповСтрока );

	// Шаблон списка отчетов в макете имеет следующую структуру:
	//   Каждая именованная область макета содержит элементы одной группы.
	//   При отсутствии имени группы в первой колонке первой строки области
	//   элементы, содержащиеся в этой области, принимаются за элементы корневого
	//   уровня (0-уровня). Элементы создаются в том же порядке, в котором они
	//   перечислены в макете.
	
	// Получим макет со списком отчетов.
	МакетСписокОтчетов = ЭтотОбъект.ПолучитьМакет("СписокОтчетов");

	Для Инд = 0 По МакетСписокОтчетов.Области.Количество() - 1 Цикл

		ТекОбласть = МакетСписокОтчетов.Области[Инд];
		ИмяОбласти = ТекОбласть.Имя;

		// наименование группы определяется по первой колонке макета
		ИмяГруппы = СокрЛП(МакетСписокОтчетов.Область(ТекОбласть.Верх, 1).Текст);
		ОписаниеГруппы = СокрЛП(МакетСписокОтчетов.Область(ТекОбласть.Верх, 1).Текст);

		// альтернативные имена и описания группы
		ИмяГруппы2 		= СокрЛП(МакетСписокОтчетов.Область(ТекОбласть.Верх, 6).Текст);
		ОписаниеГруппы2 = СокрЛП(МакетСписокОтчетов.Область(ТекОбласть.Верх, 6).Текст);
		
		Если КодЯзыкаЛокализации = "uk" Тогда
			// поменяем местами основной и альтернативный вариант названий/описаний
			ТМП = ИмяГруппы;
			ИмяГруппы = ИмяГруппы2;
			ИмяГруппы2 = ТМП;
			
			ОписаниеГруппы = ОписаниеГруппы2;
		КонецЕсли;
		
		Если Не ПустаяСтрока(ИмяГруппы) Тогда

			СтрокаУровня1 = ДеревоОтчетов.Строки.Добавить();
			СтрокаУровня1.Наименование  = ИмяГруппы;
			СтрокаУровня1.Наименование2 = ИмяГруппы2;
			СтрокаУровня1.ЭтоГруппа    = Истина;
			СтрокаУровня1.Описание     = ОписаниеГруппы;
			СтрокаУровня1.МеткаВыбора  = 1;

			Для Ном = ТекОбласть.Верх По ТекОбласть.Низ Цикл
				// перебираем элементы второго уровня

				// наименование отчета определяется по второй колонке макета
				Наименование  = СокрЛП(МакетСписокОтчетов.Область(Ном, 2).Текст);
				Наименование2 = СокрЛП(МакетСписокОтчетов.Область(Ном, 7).Текст);
				Если ПустаяСтрока(Наименование) Тогда
					// пустые строки пропускаем
					Продолжить;
				КонецЕсли;

				// описание отчета  определяется по третьей колонке макета
				Описание     = СокрЛП(МакетСписокОтчетов.Область(Ном, 3).Текст);
				// альтернативные имена и описания группы
				Описание2 = СокрЛП(МакетСписокОтчетов.Область(Ном, 8).Текст);
				Если КодЯзыкаЛокализации = "uk" Тогда
					// поменяем местами основной и альтернативный вариант названий/описаний
					ТМП = Наименование;
					Наименование = Наименование2;
					Наименование2 = ТМП;
					
					Описание = Описание2;
				КонецЕсли;
				
				// место нахождения отчета  определяется по четвертой колонке макета
				Источник     = СокрЛП(МакетСписокОтчетов.Область(Ном, 4).Текст);
				
				Периоды		 = СокрЛП(МакетСписокОтчетов.Область(Ном, 5).Текст);

				СтрокаУровня2 = СтрокаУровня1.Строки.Добавить();
				СтрокаУровня2.Наименование  = Наименование;
				СтрокаУровня2.Наименование2 = Наименование2;
				СтрокаУровня2.Описание     = Описание;
				СтрокаУровня2.Источник     = Источник;
				СтрокаУровня2.ЭтоГруппа    = Ложь;
				СтрокаУровня2.МеткаВыбора  = 1;
				СтрокаУровня2.Периоды	   = Периоды;

			КонецЦикла;
			
			Если СтрокаУровня1.Строки.Количество() = 0 Тогда
				ДеревоОтчетов.Строки.Удалить(СтрокаУровня1);
			КонецЕсли;
			
		Иначе
			// для элемента корневого (0-уровня)
			Для Ном = ТекОбласть.Верх По ТекОбласть.Низ Цикл
				// перебираем элементы второго уровня

				// наименование отчета определяется по второй колонке макета
				Наименование  = СокрЛП(МакетСписокОтчетов.Область(Ном, 2).Текст);
				Наименование2 = СокрЛП(МакетСписокОтчетов.Область(Ном, 7).Текст);

				Если ПустаяСтрока(Наименование) Тогда
					// пустые строки пропускаем
					Продолжить;
				КонецЕсли;

				// описание отчета  определяется по третьей колонке макета
				Описание      = СокрЛП(МакетСписокОтчетов.Область(Ном, 3).Текст);
				// альтернативные имена и описания группы
				Описание2 = СокрЛП(МакетСписокОтчетов.Область(Ном, 8).Текст);
				Если КодЯзыкаЛокализации = "uk" Тогда
					// поменяем местами основной и альтернативный вариант названий/описаний
					ТМП = Наименование;
					Наименование = Наименование2;
					Наименование2 = ТМП;
					
					Описание = Описание2;
				КонецЕсли;
				
				// место нахождения отчета  определяется по четвертой колонке макета
				Источник      = СокрЛП(МакетСписокОтчетов.Область(Ном, 4).Текст);

				Периоды		 = СокрЛП(МакетСписокОтчетов.Область(Ном, 5).Текст);
				
				СтрокаУровня1 = ДеревоОтчетов.Строки.Добавить();
				СтрокаУровня1.Наименование  = Наименование;
				СтрокаУровня1.Наименование2 = Наименование2;
				СтрокаУровня1.Описание     = Описание;
				СтрокаУровня1.Источник     = Источник;
				СтрокаУровня1.ЭтоГруппа    = Ложь;
				СтрокаУровня1.МеткаВыбора  = 1;
				СтрокаУровня1.Периоды	   = Периоды;

			КонецЦикла;
			
		КонецЕсли;

	КонецЦикла;
	
	Возврат ДеревоОтчетов;
	
КонецФункции

Процедура ЗаполнитьСписокОтчетов(ДеревоОтчетов, ПервоеЗаполнение = Ложь) Экспорт

	Перем НайденнаяГруппа;
	Перем НайденныйЭлемент;

	РегламОтчеты = Справочники.РегламентированныеОтчеты;

	// Открываем транзакцию
	НачатьТранзакцию();

	Для Каждого СтрокаУровня1 Из ДеревоОтчетов.Строки Цикл
	
		ИмяОтчета  = СокрЛП(СтрокаУровня1.Наименование);
		ИмяОтчета2 = СокрЛП(СтрокаУровня1.Наименование2);
		Описание  = СокрЛП(СтрокаУровня1.Описание);
		Источник  = СокрЛП(СтрокаУровня1.Источник);
		ЭтоГруппа = СтрокаУровня1.ЭтоГруппа;
		Метка     = СтрокаУровня1.МеткаВыбора;
		Периоды   = СокрЛП(СтрокаУровня1.Периоды);

		Если Метка = 0 Тогда
			// пропускаем не помеченные отчеты
			Продолжить;
		КонецЕсли;

		Если ЭтоГруппа Тогда

			// При НЕ первом заполнении списка отчетов новая группа создается только
			// в том случае, если не найдена уже существующая группа, а при первом 
			// заполнении новая группа создается всегда, так как справочник - пустой.
			// Признаком необходимости создания группы служит неопределенное значение 
			// переменной НайденнаяГруппа, которая при НЕ первом заполнении может 
			// принимать и конкретное значение.

			Если Не ПервоеЗаполнение Тогда 
				// для группы отчетов
				НайденнаяГруппа = ПоискЭлементаПоРеквизитам(ИмяОтчета, ИмяОтчета2, "", Истина);
				
				// обновляем реквизиты найденного элемента
				Если НЕ НайденнаяГруппа = Неопределено Тогда
				
					ТекЭлемент = НайденнаяГруппа.ПолучитьОбъект();
					ТекЭлемент.Наименование = ИмяОтчета;
					ТекЭлемент.Описание     = Описание;

					Попытка
						ТекЭлемент.Записать();
					Исключение
						ПредупредитьПользователя("Не удалось записать элемент справочника:
						|" + ОписаниеОшибки());

						ОтменитьТранзакцию();
						Возврат;
					КонецПопытки;
				
				КонецЕсли;
				
				Родитель        = НайденнаяГруппа;
			КонецЕсли;

			Если НайденнаяГруппа = Неопределено Тогда

				// новая группа элементов справочника
				НоваяГруппа              = РегламОтчеты.СоздатьГруппу();
				НоваяГруппа.Наименование = ИмяОтчета;
				//НоваяГруппа.УстановитьНовыйКод();
				//НоваяГруппа.ГенерироватьНовыйКод();

				Попытка
					НоваяГруппа.Записать();
				Исключение
					ПредупредитьПользователя("Не удалось записать элемент справочника:
					|" + ОписаниеОшибки());

					ОтменитьТранзакцию();
					Возврат;
				КонецПопытки;

				Родитель = НоваяГруппа.Ссылка;
				
			Иначе
				
				ГруппаОбъект = НайденнаяГруппа.ПолучитьОбъект();
				ГруппаОбъект.Описание = Описание;
				ГруппаОбъект.ПометкаУдаления = Ложь;
				Попытка
					ГруппаОбъект.Записать();
				Исключение
					ПредупредитьПользователя("Не удалось записать элемент справочника:
					|" + ОписаниеОшибки());

					ОтменитьТранзакцию();
					Возврат;
				КонецПопытки;
				
			КонецЕсли;

			Если СтрокаУровня1.Строки.Количество() > 0 Тогда
				Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл

					ИмяОтчета  = СокрЛП(СтрокаУровня2.Наименование);
                    ИмяОтчета2 = СокрЛП(СтрокаУровня2.Наименование2);
					Описание  = СокрЛП(СтрокаУровня2.Описание);
					Источник  = СокрЛП(СтрокаУровня2.Источник);
					ЭтоГруппа = СтрокаУровня2.ЭтоГруппа;
					Метка     = СтрокаУровня2.МеткаВыбора;
					Периоды   = СокрЛП(СтрокаУровня2.Периоды);
					
					Если Метка = 0 Тогда
						// пропускаем не помеченные отчеты
						Продолжить;
					КонецЕсли;

					// При НЕ первом заполнении списка отчетов новый элемент создается 
					// только в том случае, если не найден уже существующий элемент, а при
					// первом заполнении новый элемент создается всегда, так как справочник - 
					// пустой. Признаком необходимости создания элемента служит неопределенное
					// значение переменной НайденныйЭлемент, которая при НЕ первом заполнении
					// может принимать и конкретное значение.

					Если Не ПервоеЗаполнение Тогда 
						НайденныйЭлемент = ПоискЭлементаПоРеквизитам(ИмяОтчета, ИмяОтчета2, Источник, , Родитель);
					КонецЕсли;

					Если НайденныйЭлемент = Неопределено Тогда

						// создаем новый элемент справочника
						НовыйЭлемент                        = РегламОтчеты.СоздатьЭлемент();
						НовыйЭлемент.Родитель               = Родитель;
						НовыйЭлемент.Наименование           = ИмяОтчета;
						НовыйЭлемент.Описание               = Описание;
						НовыйЭлемент.ИсточникОтчета         = Источник;
						НовыйЭлемент.Периоды				= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));
						//НовыйЭлемент.УстановитьНовыйКод(Лев(Родитель.Код, 3));
						//НовыйЭлемент.ГенерироватьНовыйКод();

						Попытка
							НовыйЭлемент.Записать();
						Исключение
							ПредупредитьПользователя("Не удалось записать элемент справочника:
							|" + ОписаниеОшибки());

							ОтменитьТранзакцию();
							Возврат;
						КонецПопытки;

					Иначе

						// обновляем реквизиты найденного элемента
						ТекЭлемент = НайденныйЭлемент.ПолучитьОбъект();
						ТекЭлемент.Наименование = ИмяОтчета;
						ТекЭлемент.Описание     = Описание;
						ТекЭлемент.Родитель     = Родитель;
						ТекЭлемент.ПометкаУдаления = Ложь;
						ТекЭлемент.Периоды		= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));

						Попытка
							ТекЭлемент.Записать();
						Исключение
							ПредупредитьПользователя("Не удалось записать элемент справочника:
							|" + ОписаниеОшибки());

							ОтменитьТранзакцию();
							Возврат;
						КонецПопытки;

					КонецЕсли;

				КонецЦикла;
			КонецЕсли;

		Иначе

			Если Не ПервоеЗаполнение Тогда 
				НайденныйЭлемент = ПоискЭлементаПоРеквизитам(ИмяОтчета, ИмяОтчета2, Источник,,РегламОтчеты.ПустаяСсылка());
			КонецЕсли;

			Если НайденныйЭлемент = Неопределено Тогда

				// создаем новый элемент справочника
				НовыйЭлемент                        = РегламОтчеты.СоздатьЭлемент();
				НовыйЭлемент.Наименование           = ИмяОтчета;
				НовыйЭлемент.Описание               = Описание;
				НовыйЭлемент.ИсточникОтчета         = Источник;
				НовыйЭлемент.Периоды				= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));
				//НовыйЭлемент.УстановитьНовыйКод(Лев(Родитель.Код, 3));
				//НовыйЭлемент.ГенерироватьНовыйКод();

				Попытка
					НовыйЭлемент.Записать();
				Исключение
					ПредупредитьПользователя("Не удалось записать элемент справочника:
					|" + ОписаниеОшибки());

					ОтменитьТранзакцию();
					Возврат;
				КонецПопытки;

			Иначе

				// обновляем реквизиты найденного элемента
				ТекЭлемент = НайденныйЭлемент.ПолучитьОбъект();
				ТекЭлемент.Наименование = ИмяОтчета;
				ТекЭлемент.Описание     = Описание;
				ТекЭлемент.Родитель     = РегламОтчеты.ПустаяСсылка();
				ТекЭлемент.ПометкаУдаления = Ложь;
				ТекЭлемент.Периоды		= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));

				Попытка
					ТекЭлемент.Записать();
				Исключение
					ПредупредитьПользователя("Не удалось записать элемент справочника:
					|" + ОписаниеОшибки());

					ОтменитьТранзакцию();
					Возврат;
				КонецПопытки;

			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

	// Завершаем транзакцию
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура УстановитьСнятьПометкуНаУдаление(ДеревоОтчетов) Экспорт

	РеглОтчеты = Справочники.РегламентированныеОтчеты.Выбрать();
		
	Пока РеглОтчеты.Следующий() Цикл
		
		Если РеглОтчеты.ЭтоГруппа Тогда
			
			РезультатПоиска = ДеревоОтчетов.Строки.Найти(РеглОтчеты.Наименование, "Наименование", Истина);
			
			Если РезультатПоиска = Неопределено	ИЛИ НЕ ЗначениеЗаполнено(РеглОтчеты.Наименование) Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("ПометкаУдаления", Истина);
				
				ИзменитьРеквизитыОтчета(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			КонецЕсли;
			
		Иначе	
			
			РезультатПоиска = ДеревоОтчетов.Строки.Найти(РеглОтчеты.ИсточникОтчета, "Источник", Истина);
												
			Если РезультатПоиска = Неопределено	ИЛИ НЕ ЗначениеЗаполнено(РеглОтчеты.ИсточникОтчета) Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("ПометкаУдаления", Истина);

				
				ИзменитьРеквизитыОтчета(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			КонецЕсли;
		
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры

Процедура СкрытьВосстановитьОтчеты(ДеревоОтчетов) Экспорт
			
	РеглОтчеты = Справочники.РегламентированныеОтчеты.Выбрать();
		
	Пока РеглОтчеты.Следующий() Цикл
		
		Если НЕ РеглОтчеты.ЭтоГруппа Тогда
			
			РезультатПоиска = ДеревоОтчетов.Строки.Найти(РеглОтчеты.ИсточникОтчета, "Источник", Истина);
			
			СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
			СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет = РеглОтчеты.Ссылка;
			СкрытыеРегламентированныеОтчеты.Прочитать();
			
			Если РезультатПоиска = Неопределено	ИЛИ НЕ ЗначениеЗаполнено(РеглОтчеты.ИсточникОтчета) 
				ИЛИ (РеглОтчеты.ПометкаУдаления И НЕ СкрытыеРегламентированныеОтчеты.Выбран()) Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("СкрытьРеглОтчет", Истина);
				
				ИзменитьСкрытыеРегламентированныеОтчеты(РеглОтчеты.Ссылка, Реквизиты);
				
			ИначеЕсли НЕ РеглОтчеты.ПометкаУдаления И СкрытыеРегламентированныеОтчеты.Выбран() Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("СкрытьРеглОтчет", Ложь);
				
				ИзменитьСкрытыеРегламентированныеОтчеты(РеглОтчеты.Ссылка, Реквизиты);
				
			КонецЕсли;
			
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры

Процедура ИзменитьРеквизитыОтчета(Отчет, Реквизиты)
	
	// Открываем транзакцию.
	НачатьТранзакцию();
			
	Отчет.ПометкаУдаления     = Реквизиты.ПометкаУдаления;
	
	Попытка
		Отчет.Записать();
	Исключение
		ПредупредитьПользователя("Не удалось записать элемент справочника:
		|" + ОписаниеОшибки());
		
		ОтменитьТранзакцию();
		Возврат;
	КонецПопытки;
	
	// Завершаем транзакцию.
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ИзменитьСкрытыеРегламентированныеОтчеты(Отчет, Реквизиты)
	
	// Открываем транзакцию.
	НачатьТранзакцию();
	
	СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
	СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет = Отчет.Ссылка;
	
	Попытка
		
		Если Реквизиты.СкрытьРеглОтчет Тогда
			СкрытыеРегламентированныеОтчеты.Записать();
		Иначе
			СкрытыеРегламентированныеОтчеты.Удалить();
		КонецЕсли;
				
	Исключение
		
		ПредупредитьПользователя("Не удалось записать запись регистра сведений:
		|" + ОписаниеОшибки());
		
		ОтменитьТранзакцию();
		
		Возврат;
		
	КонецПопытки;
	
	// Завершаем транзакцию.
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецЕсли 