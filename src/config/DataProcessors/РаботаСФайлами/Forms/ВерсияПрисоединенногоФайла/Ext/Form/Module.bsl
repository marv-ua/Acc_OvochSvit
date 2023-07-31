﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбъектЗначение = Параметры.Ключ.ПолучитьОбъект();
	ОбъектЗначение.Заполнить(Неопределено);

	ИмяСправочника = ОбъектЗначение.Метаданные().Имя;
	
	ЗаголовокОшибки = НСтр("ru='Ошибка при настройке формы элемента присоединенных файлов.';uk='Помилка при настройці форми елемента приєднаних файлів.'");
	ОкончаниеОшибки = НСтр("ru='В этом случае настройка формы элемента невозможна.';uk='У цьому випадку настройка форми елемента неможлива.'");
	
	ИмяСправочникаХранилищаВерсийФайлов = РаботаСФайламиСлужебный.ИмяСправочникаХраненияВерсийФайлов(
		ТипЗнч(ОбъектЗначение.Владелец.ВладелецФайла), "", ЗаголовокОшибки, ОкончаниеОшибки);
	
	НастроитьОбъектФормы(ОбъектЗначение);

	Если ТипЗнч(ЭтотОбъект.Объект.Владелец) = Тип("СправочникСсылка.Файлы") Тогда
		Элементы.ПолноеНаименование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.Автор0.ТолькоПросмотр = Ложь;
		Элементы.ДатаСоздания0.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ГруппаХранение.Видимость = Ложь;
	КонецЕсли;
	
	ТомПолныйПуть = РаботаСФайламиСлужебный.ПолныйПутьТома(ЭтотОбъект.Объект.Том);
	
	ОбщиеНастройки = РаботаСФайламиСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами();
	
	РасширениеФайлаВСписке = РаботаСФайламиСлужебныйКлиентСервер.РасширениеФайлаВСписке(
		ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, ЭтотОбъект.Объект.Расширение);
	
	Если РасширениеФайлаВСписке Тогда
		Если ЗначениеЗаполнено(ЭтотОбъект.Объект.Ссылка) Тогда
			
			КодировкаЗначение = РаботаСФайламиСлужебныйВызовСервера.ПолучитьКодировкуВерсииФайла(ЭтотОбъект.Объект.Ссылка);
			
			СписокКодировок = РаботаСФайламиСлужебный.Кодировки();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаЗначение);
			Если ЭлементСписка = Неопределено Тогда
				Кодировка = КодировкаЗначение;
			Иначе	
				Кодировка = ЭлементСписка.Представление;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Кодировка) Тогда
			Кодировка = НСтр("ru='По умолчанию';uk='По умовчанню'");
		КонецЕсли;
	Иначе
		Элементы.Кодировка.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтандартнаяЗаписатьИЗакрыть", "Отображение", ОтображениеКнопки.Картинка);
		
		Если Элементы.Найти("Комментарий") <> Неопределено Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Комментарий", "МаксимальнаяВысота", 2);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Комментарий", "АвтоМаксимальнаяВысота", Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Комментарий", "РастягиватьПоВертикали", Ложь);
			
		КонецЕсли;
		
		Если Элементы.Найти("Комментарий0") <> Неопределено Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Комментарий0", "МаксимальнаяВысота", 2);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Комментарий0", "АвтоМаксимальнаяВысота", Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Комментарий0", "РастягиватьПоВертикали", Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьВыполнить()
	
	ВерсияСсылка = ЭтотОбъект.Объект.Ссылка;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ЭтотОбъект.Объект.Владелец, ВерсияСсылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	ЭтотОбъект.Объект.Наименование = ЭтотОбъект.Объект.ПолноеНаименование;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ВерсияСсылка = ЭтотОбъект.Объект.Ссылка;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(ЭтотОбъект.Объект.Владелец, ВерсияСсылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяЗаписать(Команда)
	ОбработатьКомандуЗаписиВерсииФайла();
КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяЗаписатьИЗакрыть(Команда)
	
	Если ОбработатьКомандуЗаписиВерсииФайла() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяПеречитать(Команда)
	
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Модифицированность Тогда
		ПеречитатьДанныеССервера();
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='Данные изменены. Перечитать данные?';uk='Дані змінені. Перечитати дані?'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СтандартнаяПеречитатьОтветПолучен", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьОбъектФормы(Знач НовыйОбъект)
	
	ТипНовогоОбъекта = Новый Массив;
	ТипНовогоОбъекта.Добавить(ТипЗнч(НовыйОбъект));
	НовыйРеквизит = Новый РеквизитФормы("Объект", Новый ОписаниеТипов(ТипНовогоОбъекта));
	НовыйРеквизит.СохраняемыеДанные = Истина;
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
	Для каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы")
			И СтрНачинаетсяС(Элемент.ПутьКДанным, "ОбъектПрототип[0].")
			И СтрЗаканчиваетсяНа(Элемент.Имя, "0") Тогда
			
			ИмяЭлемента = Лев(Элемент.Имя, СтрДлина(Элемент.Имя) -1);
			
			Если Элементы.Найти(ИмяЭлемента) <> Неопределено  Тогда
				Продолжить;
			КонецЕсли;
			
			НовыйЭлемент = Элементы.Вставить(ИмяЭлемента, ТипЗнч(Элемент), Элемент.Родитель, Элемент);
			НовыйЭлемент.ПутьКДанным = "Объект." + Сред(Элемент.ПутьКДанным, СтрДлина("ОбъектПрототип[0].") + 1);
			
			Если Элемент.Вид = ВидПоляФормы.ПолеФлажка Или Элемент.Вид = ВидПоляФормы.ПолеКартинки Тогда
				ИсключаемыеСвойства = "Имя, ПутьКДанным";
			Иначе
				ИсключаемыеСвойства = "Имя, ПутьКДанным, ВыделенныйТекст, СвязьПоТипу";
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент, , ИсключаемыеСвойства);
			Элемент.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если Не НовыйОбъект.ЭтоНовый() Тогда
		ЭтотОбъект.НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(НовыйОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ОбработатьКомандуЗаписиВерсииФайла()
	
	Если ПустаяСтрока(ЭтотОбъект.Объект.ПолноеНаименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Для продолжения укажите имя версии файла.';uk='Для продовження вкажіть ім''я версії файлу.'"), , "Наименование", "Объект");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		РаботаСФайламиСлужебныйКлиент.КорректноеИмяФайла(ЭтотОбъект.Объект.ПолноеНаименование);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,"Наименование", "Объект");
		Возврат Ложь;
	КонецПопытки;
	
	Если НЕ ЗаписатьВерсиюФайла() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Модифицированность = Ложь;
	ОтобразитьИзменениеДанных(ЭтотОбъект.Объект.Ссылка, ВидИзмененияДанных.Изменение);
	ОповеститьОбИзменении(ЭтотОбъект.Объект.Ссылка);
	Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), ЭтотОбъект.Объект.Владелец);
	Оповестить("Запись_ВерсияФайла",
	           Новый Структура("ЭтоНовый", Ложь),
	           ЭтотОбъект.Объект.Ссылка);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЗаписатьВерсиюФайла(Знач ПараметрОбъект = Неопределено)
	
	Если ПараметрОбъект = Неопределено Тогда
		ЗаписываемыйОбъект = РеквизитФормыВЗначение("Объект");
	Иначе
		ЗаписываемыйОбъект = ПараметрОбъект;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		ЗаписываемыйОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru='Файлы.Ошибка записи версии присоединенного файла';uk='Файли.Помилка запису версії приєднаного файлу'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	Если ПараметрОбъект = Неопределено Тогда
		ЗначениеВРеквизитФормы(ЗаписываемыйОбъект, "Объект");
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ПеречитатьДанныеССервера()
	
	ФайлОбъект = ЭтотОбъект.Объект.Ссылка.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ФайлОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяПеречитатьОтветПолучен(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеречитатьДанныеССервера();
		Модифицированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоНовый()
	
	Возврат ЭтотОбъект.Объект.Ссылка.Пустая();
	
КонецФункции

#КонецОбласти