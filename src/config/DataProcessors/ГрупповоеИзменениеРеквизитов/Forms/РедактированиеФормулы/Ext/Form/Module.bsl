﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Формула         = Параметры.Формула;
	ИсходнаяФормула = Параметры.Формула;
	
	Параметры.Свойство("ИспользуетсяДеревоОперандов", ИспользуетсяДеревоОперандов);
	
	Элементы.ГруппаОперандыСтраницы.ТекущаяСтраница = Элементы.СтраницаЧисловыхОперандов;
	Операнды.Загрузить(ПолучитьИзВременногоХранилища(Параметры.Операнды));
	Для Каждого ТекСтрока Из Операнды Цикл
		Если ТекСтрока.ПометкаУдаления Тогда
			ТекСтрока.ИндексКартинки = 3;
		Иначе
			ТекСтрока.ИндексКартинки = 2;
		КонецЕсли;
	КонецЦикла;
	
	ДеревоОператоров = ПолучитьСтандартноеДеревоОператоров();
	ЗначениеВРеквизитФормы(ДеревоОператоров, "Операторы");
	
	Если Параметры.Свойство("ОперандыЗаголовок") Тогда
		Элементы.ГруппаОперанды.Заголовок = Параметры.ОперандыЗаголовок;
		Элементы.ГруппаОперанды.Подсказка = Параметры.ОперандыЗаголовок;
	КонецЕсли;
	
	УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Операнды",
			"ИзменятьСоставСтрок",
			Ложь);
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не Модифицированность Или Не ЗначениеЗаполнено(ИсходнаяФормула) Или ИсходнаяФормула = Формула Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если ПроверитьФормулу(Формула, Операнды()) Тогда
			Модифицированность = Ложь;
			Закрыть(Формула);
		КонецЕсли;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиВыборДоступныеПоляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекстСтроки = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).Поле);
	Операнд = ОбработатьТекстОперанда(ТекстСтроки);
	ВставитьТекстВФормулу(Операнд);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекстЭлемента = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроек.ТекущаяСтрока).Поле);
	ПараметрыПеретаскивания.Значение = ОбработатьТекстОперанда(ТекстЭлемента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперанды

&НаКлиенте
Процедура ОперандыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ОперандыЗначение" Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ПометкаУдаления Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОперандыВыборЗавершение", ЭтотОбъект), 
			НСтр("ru='Выбранный элемент помечен на удаление. 
                |Продолжить?'
                |;uk='Обраний елемент позначений на вилучення. 
                |Продовжити?'"), 
			РежимДиалогаВопрос.ДаНет);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВставитьОперандВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыВыборЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВставитьОперандВФормулу();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОперандыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ПараметрыПеретаскивания.Значение = ПолучитьТекстОперандаДляВставки(Элемент.ТекущиеДанные.Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.ПометкаУдаления Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОперандыОкончаниеПеретаскиванияЗавершение", ЭтотОбъект), НСтр("ru='Выбранный элемент помечен на удаление';uk='Вибраний елемент позначений на вилучення'") + Символы.ПС + НСтр("ru='Продолжить?';uk='Продовжити?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыОкончаниеПеретаскиванияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		
		НачалоСтроки  = 0;
		НачалоКолонки = 0;
		КонецСтроки   = 0;
		КонецКолонки  = 0;
		
		Элементы.Формула.ПолучитьГраницыВыделения(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки);
		Элементы.Формула.ВыделенныйТекст = "";
		Элементы.Формула.УстановитьГраницыВыделения(НачалоСтроки, НачалоКолонки, НачалоСтроки, НачалоКолонки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперандовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоОперандов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаРодитель = ТекущиеДанные.ПолучитьРодителя();
	Если СтрокаРодитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВставитьТекстВФормулу(ПолучитьТекстОперандаДляВставки(
		СтрокаРодитель.Идентификатор + "." + ТекущиеДанные.Идентификатор));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОперандов

&НаКлиенте
Процедура ДеревоОперандовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ПараметрыПеретаскивания.Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаДерева = ДеревоОперандов.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	СтрокаРодитель = СтрокаДерева.ПолучитьРодителя();
	Если СтрокаРодитель = Неопределено Тогда
		Выполнение = Ложь;
		Возврат;
	Иначе
		ПараметрыПеретаскивания.Значение = 
		   ПолучитьТекстОперандаДляВставки(СтрокаРодитель.Идентификатор +"." + СтрокаДерева.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОператоры

&НаКлиенте
Процедура ОператорыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВставитьОператорВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Оператор) Тогда
		ПараметрыПеретаскивания.Значение = Элемент.ТекущиеДанные.Оператор;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.Оператор = "Формат(,)" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ФорматСтроки.Показать(Новый ОписаниеОповещения("ОператорыОкончаниеПеретаскиванияЗавершение", ЭтотОбъект, Новый Структура("ФорматСтроки", ФорматСтроки)));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскиванияЗавершение(Текст, ДополнительныеПараметры) Экспорт
	
	ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
	
	
	Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
		ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
		Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьФормулу(Формула, Операнды()) Тогда
		Закрыть(Формула);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ОчиститьСообщения();
	ПроверитьФормулуИнтерактивно(Формула, Операнды());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВставитьТекстВФормулу(ТекстДляВставки, Сдвиг = 0)
	
	СтрокаНач = 0;
	СтрокаКон = 0;
	КолонкаНач = 0;
	КолонкаКон = 0;
	
	Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
	
	Если (КолонкаКон = КолонкаНач) И (КолонкаКон + СтрДлина(ТекстДляВставки)) > Элементы.Формула.Ширина / 8 Тогда
		Элементы.Формула.ВыделенныйТекст = "";
	КонецЕсли;
		
	Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	
	Если Не Сдвиг = 0 Тогда
		Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
		Элементы.Формула.УстановитьГраницыВыделения(СтрокаНач, КолонкаНач - Сдвиг, СтрокаКон, КолонкаКон - Сдвиг);
	КонецЕсли;
		
	ТекущийЭлемент = Элементы.Формула;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОперандВФормулу()
	
	ВставитьТекстВФормулу(ПолучитьТекстОперандаДляВставки(Элементы.Операнды.ТекущиеДанные.Идентификатор));
	
КонецПроцедуры

&НаКлиенте
Функция Операнды()
	
	Результат = Новый Массив();
	Для Каждого Операнд Из Операнды Цикл
		Результат.Добавить(Операнд.Идентификатор);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВставитьОператорВФормулу()
	
	Если Элементы.Операторы.ТекущиеДанные.Наименование = "Формат" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ФорматСтроки.Показать(Новый ОписаниеОповещения("ВставитьОператорВФормулуЗавершение", ЭтотОбъект, Новый Структура("ФорматСтроки", ФорматСтроки)));
		Возврат;
	Иначе	
		ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.Оператор, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулуЗавершение(Текст, ДополнительныеПараметры) Экспорт
	
	ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
	
	Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
		ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
		ВставитьТекстВФормулу(ТекстДляВставки, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	Иначе	
		ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.Оператор, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОбработатьТекстОперанда(ТекстОперанда)
	
	ТекстСтроки = ТекстОперанда;
	ТекстСтроки = СтрЗаменить(ТекстСтроки, "[", "");
	ТекстСтроки = СтрЗаменить(ТекстСтроки, "]", "");
	Операнд = "[" + СтрЗаменить(ТекстСтроки, 
		?(НаборСвойств.НаборСвойствНоменклатуры, "Номенклатура.", 
			?(НЕ НаборСвойств.Свойство("НаборСвойствХарактеристик") ИЛИ НаборСвойств.НаборСвойствХарактеристик, "ХарактеристикаНоменклатуры.", "СерияНоменклатуры.")), "") + "]";
	
	Возврат Операнд
	
КонецФункции

&НаКлиенте
Процедура ФормулаПриИзменении(Элемент)
	
	Если Расширенный Тогда
		Представление = "";
	КонецЕсли;
	
	Если ВключитьЗначение Тогда
		УстановитьПредставлениеВычисленияПоФормуле(Формула, Операнды, Вычисление);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()

	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыИдентификатор",
		"Видимость",
		Не Расширенный);
	
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыПредставление",
		"Видимость",
		Расширенный);
	
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыЗначение",
		"Видимость",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Вычисление",
		"Видимость",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияАвтоСумма",
		"Видимость",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Операнды",
		"Шапка",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Операторы",
		"Шапка",
		ВключитьЗначение);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеВычисленияПоФормуле(Знач РасчетнаяФормула, Операнды, Представление)
	
	Если Не ЗначениеЗаполнено(РасчетнаяФормула) Тогда
		Представление = "";
		Возврат;
	КонецЕсли;
	
	РасчетнаяФормула = УдалениеНезначимыхСимволов(РасчетнаяФормула);
	ВыводитьПромежуточныеВычисления = Ложь;
	
	МассивОперандов = ОперандыТекстовойФормулы(РасчетнаяФормула);
	
	Для каждого Операнд Из МассивОперандов Цикл
		НайденныйСтроки = Операнды.НайтиСтроки(Новый Структура("Идентификатор", Операнд));
		Если НайденныйСтроки.Количество() = 1 Тогда
			Если НЕ ВыводитьПромежуточныеВычисления Тогда
				ВыводитьПромежуточныеВычисления = НЕ ПустаяСтрока(УдалениеНезначимыхСимволов(СтрЗаменить(РасчетнаяФормула, "["+Операнд+"]", "")));
			КонецЕсли;
			РасчетнаяФормула = СтрЗаменить(РасчетнаяФормула, "["+Операнд+"]", Формат(НайденныйСтроки[0].Значение, "ЧРД=.; ЧН=0; ЧГ=0"));
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		РезультатВычисления = Формат(Вычислить(РасчетнаяФормула),"ЧЦ=15; ЧДЦ=3; ЧН=0");
	Исключение
		Возврат;
	КонецПопытки;
	
	Представление = ?(ВыводитьПромежуточныеВычисления, РасчетнаяФормула, "") + ?(ЗначениеЗаполнено(РасчетнаяФормула), " = ", "") + РезультатВычисления;
	
	Представление = УдалениеНезначимыхСимволов(Представление);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УдалениеНезначимыхСимволов(Знач ВходящаяСтрока)
	
	ВходящаяСтрока = СокрЛП(ВходящаяСтрока);
	ДлинаСтроки = СтрДлина(ВходящаяСтрока);
	КонечнаяСтрока = Строка("");
	
	Пока ДлинаСтроки > 0 Цикл 
		
		ПервыйСимвол = Лев(ВходящаяСтрока, 1);
		
		Если Не ПустаяСтрока(ПервыйСимвол) Тогда
			КонечнаяСтрока = КонечнаяСтрока + ПервыйСимвол;
			ДлинаСтроки = ДлинаСтроки - 1;
			Отступ = 2;
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + " ";
			ВходящаяСтрока = СокрЛ(ВходящаяСтрока);
			ДлинаСтроки = СтрДлина(ВходящаяСтрока);
			Отступ = 1;
		КонецЕсли;
		
		Если ДлинаСтроки > 1 Тогда
			ВходящаяСтрока = Сред(ВходящаяСтрока, Отступ, ДлинаСтроки);
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + Сред(ВходящаяСтрока, Отступ, 1);
			ДлинаСтроки = 0; 
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КонечнаяСтрока;
	
КонецФункции

&НаСервере
Функция ПолучитьПустоеДеревоОператоров()
	
	Дерево = Новый ДеревоЗначений();
	Дерево.Колонки.Добавить("Наименование");
	Дерево.Колонки.Добавить("Оператор");
	Дерево.Колонки.Добавить("Сдвиг", Новый ОписаниеТипов("Число"));
	
	Возврат Дерево;
	
КонецФункции

&НаСервере
Функция ДобавитьГруппуОператоров(Дерево, Наименование)
	
	НоваяГруппа = Дерево.Строки.Добавить();
	НоваяГруппа.Наименование = Наименование;
	
	Возврат НоваяГруппа;
	
КонецФункции

&НаСервере
Функция ДобавитьОператор(Дерево, Родитель, Наименование, Оператор = Неопределено, Сдвиг = 0)
	
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Оператор = ?(ЗначениеЗаполнено(Оператор), Оператор, Наименование);
	НоваяСтрока.Сдвиг = Сдвиг;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Функция ПолучитьСтандартноеДеревоОператоров()
	
	Дерево = ПолучитьПустоеДеревоОператоров();
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Разделители';uk='Роздільники'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, "/", " + ""/"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "\", " + ""\"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "|", " + ""|"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "_", " + ""_"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ",", " + "", "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ".", " + "". "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Пробел';uk='Пробіл'"), " + "" "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "(", " + "" ("" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ")", " + "") "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, """", " + """""""" + ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Операторы';uk='Оператори'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Логические операторы и константы';uk='Логічні оператори і константи'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, "<", " < ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ">", " > ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "<=", " <= ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ">=", " >= ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "=", " = ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "<>", " <> ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='И';uk='И'"),      " " + НСтр("ru='И';uk='И'")      + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Или';uk='Або'"),    " " + НСтр("ru='Или';uk='Або'")    + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Не';uk=' не '"),     " " + НСтр("ru='Не';uk=' не '")     + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ИСТИНА';uk='ІСТИНА'"), " " + НСтр("ru='ИСТИНА';uk='ІСТИНА'") + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ЛОЖЬ';uk='ХИБНІСТЬ'"),   " " + НСтр("ru='ЛОЖЬ';uk='ХИБНІСТЬ'")   + " ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Числовые функции';uk='Числові функції'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Максимум';uk='Максимум'"),    НСтр("ru='Макс(,)';uk='Макс(,)'"), 2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Минимум';uk='Мінімум'"),     НСтр("ru='Мин(,)';uk='Мин(,)'"),  2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Округление';uk='Округлення'"),  НСтр("ru='Окр(,)';uk='Окр(,)'"),  2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Целая часть';uk='Ціла частина'"), НСтр("ru='Цел()';uk='Цел()'"),   1);
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Строковые функции';uk='Строкові функції'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Строка';uk='Рядок'"), НСтр("ru='Строка()';uk='Рядок()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ВРег';uk='ВРег'"), НСтр("ru='ВРег()';uk='ВРег()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Лев';uk='Лев'"), НСтр("ru='Лев()';uk='Лев()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='НРег';uk='НРег'"), НСтр("ru='НРег()';uk='НРег()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Прав';uk='Прав'"), НСтр("ru='Прав()';uk='Прав()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СокрЛ';uk='СокрЛ'"), НСтр("ru='СокрЛ()';uk='СокрЛ()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СокрЛП';uk='СокрЛП'"), НСтр("ru='СокрЛП()';uk='СокрЛП()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СокрП';uk='СокрП'"), НСтр("ru='СокрП()';uk='СокрП()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ТРег';uk='ТРег'"), НСтр("ru='ТРег()';uk='ТРег()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СтрЗаменить';uk='СтрЗаменить'"), НСтр("ru='СтрЗаменить(,,)';uk='СтрЗаменить(,,)'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СтрДлина';uk='СтрДлина'"), НСтр("ru='СтрДлина()';uk='СтрДлина()'"));
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Прочие функции';uk='Інші функції'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Условие';uk='Умова'"), "?(,,)", 3);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Предопределенное значение';uk='Напередвизначене значення'"), НСтр("ru='ПредопределенноеЗначение()';uk='ПредопределенноеЗначение()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Значение заполнено';uk='Значення заповнено'"), НСтр("ru='ЗначениеЗаполнено()';uk='ЗначениеЗаполнено()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Формат';uk='Формат'"), НСтр("ru='Формат(,)';uk='Формат(,)'"));
	
	Возврат Дерево;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТекстОперандаДляВставки(Операнд)
	
	Возврат "[" + Операнд + "]";
	
КонецФункции

&НаКлиенте
Функция ПроверитьФормулу(Формула, Операнды)
	
	Если Не ЗначениеЗаполнено(Формула) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЗначениеЗамены = """1""";
	
	ТекстРасчета = Формула;
	Для Каждого Операнд Из Операнды Цикл
		ТекстРасчета = СтрЗаменить(ТекстРасчета, ПолучитьТекстОперандаДляВставки(Операнд), ЗначениеЗамены);
	КонецЦикла;
	
	Если СтрНачинаетсяС(СокрЛ(ТекстРасчета), "=") Тогда
		ТекстРасчета = Сред(СокрЛ(ТекстРасчета), 2);
	КонецЕсли;
	
	Попытка
		РезультатРасчета = Вычислить(ТекстРасчета);
	Исключение
		ТекстОшибки = НСтр("ru='В формуле обнаружены ошибки. Проверьте формулу.
            |Формулы должны составляться по правилам написания выражений на встроенном языке.'
            |;uk='У формулі виявлені помилки. Перевірте формулу.
            |Формули повинні складатися за правилами написання виразів на вбудованій мові.'");
		СообщитьПользователю(ТекстОшибки, , "Формула");
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ОперандыТекстовойФормулы(Формула)
	
	МассивОперандов = Новый Массив();
	
	ТекстФормулы = СокрЛП(Формула);
	Если СтрЧислоВхождений(ТекстФормулы, "[") <> СтрЧислоВхождений(ТекстФормулы, "]") Тогда
		ЕстьОперанды = Ложь;
	Иначе
		ЕстьОперанды = Истина;
	КонецЕсли;
	
	Пока ЕстьОперанды = Истина Цикл
		НачалоОперанда = СтрНайти(ТекстФормулы, "[");
		КонецОперанда = СтрНайти(ТекстФормулы, "]");
		
		Если НачалоОперанда = 0
			Или КонецОперанда = 0
			Или НачалоОперанда > КонецОперанда Тогда
			ЕстьОперанды = Ложь;
			Прервать;
			
		КонецЕсли;
		
		ИмяОперанда = Сред(ТекстФормулы, НачалоОперанда + 1, КонецОперанда - НачалоОперанда - 1);
		МассивОперандов.Добавить(ИмяОперанда);
		ТекстФормулы = СтрЗаменить(ТекстФормулы, "[" + ИмяОперанда + "]", "");
		
	КонецЦикла;
	
	Возврат МассивОперандов
	
КонецФункции

&НаКлиенте
Процедура ПроверитьФормулуИнтерактивно(Формула, Операнды)
	
	Если ЗначениеЗаполнено(Формула) Тогда
		Если ПроверитьФормулу(Формула, Операнды) Тогда
			ПоказатьОповещениеПользователя(
				НСтр("ru='В формуле ошибок не обнаружено';uk='У формулі помилок не виявлено'"),
				,
				,
				КартинкаИнформация32());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КартинкаИнформация32()
	Если ВерсияБСПСоответствуетТребованиям() Тогда
		Возврат БиблиотекаКартинок["Информация32"];
	Иначе
		Возврат Новый Картинка;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ВерсияБСПСоответствуетТребованиям()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.ВерсияБСПСоответствуетТребованиям();
КонецФункции

&НаСервере
Процедура УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение)
	
	ЭлементФормы = ЭлементыФормы.Найти(ИмяЭлемента);
	Если ЭлементФормы <> Неопределено И ЭлементФормы[ИмяСвойства] <> Значение Тогда
		ЭлементФормы[ИмяСвойства] = Значение;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, Знач Поле = "", Знач ПутьКДанным = "")
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
КонецПроцедуры

#КонецОбласти
