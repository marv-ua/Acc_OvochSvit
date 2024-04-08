﻿#Область ПрограммныйИнтерфейс

// Управляет видимостью команды вызова онлайн поддержки на форме
//
// Параметры:
//  ИмяСобытия - Строка - идентификатор сообщения;
//  Элемент - КнопкаФормы - команда вызова онлайн поддержки на форме.
//
Процедура ОбработкаОповещения(ИмяСобытия, Элемент) Экспорт
	
	Если ИмяСобытия = "СохранениеНастроекВызовОнлайнПоддержки" Тогда
		НастройкиПользователя = ВызовОнлайнПоддержкиВызовСервера.НастройкиУчетнойЗаписиПользователя();
		Элемент.Видимость = НастройкиПользователя.ВидимостьКнопкиВызовОнлайнПоддержки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Возвращает уникальный идентификатор клиента платформы (приложение).
Функция ИдентификаторКлиента() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ИдентификаторКлиента;
	
КонецФункции

// Возвращает путь файла приложения в реестре Windows.
// 
Функция ПутьКИсполняемомуФайлуИзРеестраWindows() Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Возврат "";
	КонецЕсли;
	
#Если ВебКлиент Тогда
	Возврат "";
#Иначе
	
	Значение = "";
	
	RegProv = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv");
	RegProv.GetStringValue("2147483649","Software\Buhphone","ProgramPath", Значение);
	
	Если Значение = "" Или  Значение = NULL Тогда
		ЗначениеИзРеестра = "";
	Иначе
		ЗначениеИзРеестра = Значение;
	КонецЕсли;
	
	Возврат ЗначениеИзРеестра;
	
#КонецЕсли
	
КонецФункции

// Диалоговое окно для выбора файла.
//
// Возвращаемое значение:
//		Строка  - Путь к исполняемому файлу.
Процедура ВыбратьФайлВызовОнлайнПоддержки(ОповещениеОЗакрытии, ПутьКФайлу = "") Экспорт
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеОЗакрытии);
	ДополнительныеПараметры.Вставить("ПутьКФайлу", ПутьКФайлу);
	
	ТекстПредложения = НСтр("ru='Для выбора приложения необходимо установить расширение работы с файлами.';uk='Для вибору програми необхідно встановити розширення роботи з файлами.'");
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайлВызовОнлайнПоддержкиПослеУстановкиРасширения", ЭтотОбъект, ДополнительныеПараметры);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВыбратьФайлВызовОнлайнПоддержкиПослеУстановкиРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Не Подключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, "");
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru='Выберите исполняемый файл приложения';uk='Виберіть виконуваний файл програми'");
	Диалог.ПолноеИмяФайла = ДополнительныеПараметры.ПутьКФайлу;
	Каталог = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ДополнительныеПараметры.ПутьКФайлу);
	Диалог.Каталог = Каталог.Путь;
	Фильтр = НСтр("ru='Файл приложения (*.exe)|*.exe';uk='Файл прикладної програми (*.exe)|*.exe'");
	Диалог.Фильтр = Фильтр;
	Диалог.МножественныйВыбор = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайлВызовОнлайнПоддержкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВыбратьФайлВызовОнлайнПоддержкиЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, ВыбранныеФайлы[0]);
	Иначе
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, "");
	КонецЕсли;
КонецПроцедуры

// Проверяет наличие исполняемого файла по указанному пути.
//
// Возвращаемое значение:
// 		Булево  - При значении Истина файл запустится по указанному пути.
//
Процедура НаличиеФайлаВызовОнлайнПоддержки(ОповещениеОЗакрытии, Путь)
	Оповещение = Новый ОписаниеОповещения("НаличиеФайлаВызовОнлайнПоддержкиПослеИнициализацииФайла", ЭтотОбъект, ОповещениеОЗакрытии);
	ПроверяемыйФайл = Новый Файл();
	ПроверяемыйФайл.НачатьИнициализацию(Оповещение, Путь);
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура НаличиеФайлаВызовОнлайнПоддержкиПослеИнициализацииФайла(Файл, ОповещениеОЗакрытии) Экспорт
	Оповещение = Новый ОписаниеОповещения("НаличиеФайлаВызовОнлайнПоддержкиПослеПроверкиСуществования", ЭтотОбъект, ОповещениеОЗакрытии);
	Если НРег(Файл.Расширение) <> ".exe" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Ложь);
	Иначе
		Файл.НачатьПроверкуСуществования(Оповещение);
	КонецЕсли;
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура НаличиеФайлаВызовОнлайнПоддержкиПослеПроверкиСуществования(Существует, ОповещениеОЗакрытии) Экспорт
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Существует);
КонецПроцедуры

// Процедура запускает исполняемый файл приложения.
// При отсутствии файла приложения - открывает форму поиска пути к исполняемому файлу.
//
Процедура ВызватьОнлайнПоддержку() Экспорт
	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		ПоказатьПредупреждение(,НСтр("ru='Для работы с приложением необходима операционная система Microsoft Windows.';uk='Для роботи з програмою необхідна операційна система Microsoft Windows.'"));
		Возврат
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВызватьОнлайнПоддержкуПослеУстановкиРасширения", ЭтотОбъект);
	ТекстСообщения = НСтр("ru='Для запуска приложения необходимо установить расширение работы с файлами.';uk='Для запуску програми необхідно встановити розширення роботи з файлами.'");
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстСообщения, Ложь);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВызватьОнлайнПоддержкуПослеУстановкиРасширения(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ РасширениеПодключено Тогда
		Возврат;
	КонецЕсли;
	
	// Определение параметров запуска.
	ИдентификаторКлиента = ИдентификаторКлиента();
	ПутьИзРеестра = ПутьКИсполняемомуФайлуИзРеестраWindows();
	ПутьИзХранилища = ВызовОнлайнПоддержкиВызовСервера.РасположениеИсполняемогоФайла(ИдентификаторКлиента);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПутьИзРеестра", ПутьИзРеестра);
	ДополнительныеПараметры.Вставить("ПутьИзХранилища", ПутьИзХранилища);
	
	Оповещение = Новый ОписаниеОповещения("ВызватьОнлайнПоддержкуПослеПроверкиПутиИзРеестра", ЭтотОбъект, ДополнительныеПараметры);
	НаличиеФайлаВызовОнлайнПоддержки(Оповещение, ПутьИзРеестра);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВызватьОнлайнПоддержкуПослеПроверкиПутиИзРеестра(ПутьИзРеестраВерен, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("ПутьИзРеестраВерен", ПутьИзРеестраВерен);
	Оповещение = Новый ОписаниеОповещения("ВызватьОнлайнПоддержкуПослеПроверкиПутиИзХранилища", ЭтотОбъект, ДополнительныеПараметры);
	НаличиеФайлаВызовОнлайнПоддержки(Оповещение, ДополнительныеПараметры.ПутьИзХранилища);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВызватьОнлайнПоддержкуПослеПроверкиПутиИзХранилища(ПутьИзХранилищаВерен, Контекст) Экспорт
	
	УчетнаяЗапись = ВызовОнлайнПоддержкиВызовСервера.НастройкиУчетнойЗаписиПользователя();
	ПараметрыЗапускаВызовОнлайнПоддержки = Новый Массив;
	ПараметрыЗапускаВызовОнлайнПоддержки.Добавить("/StartedFrom1CConf");
	
	Если УчетнаяЗапись.ИспользоватьЛП Тогда
		
		Если Не ПустаяСтрока(УчетнаяЗапись.Логин) И Не ПустаяСтрока(УчетнаяЗапись.Пароль) Тогда
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить("/login:");
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить(УчетнаяЗапись.Логин);
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить("/password:");
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить(УчетнаяЗапись.Пароль);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПутьИзХранилищаВерен Тогда
		КомандаЗапуска = Новый Массив;
		КомандаЗапуска.Добавить(Контекст.ПутьИзХранилища);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КомандаЗапуска, ПараметрыЗапускаВызовОнлайнПоддержки);
		ОбщегоНазначенияКлиент.ЗапуститьПрограмму(КомандаЗапуска);
		Возврат;
	КонецЕсли;
	
	Если Контекст.ПутьИзРеестраВерен Тогда
		КомандаЗапуска = Новый Массив;
		КомандаЗапуска.Добавить(Контекст.ПутьИзРеестра);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КомандаЗапуска, ПараметрыЗапускаВызовОнлайнПоддержки);
		ОбщегоНазначенияКлиент.ЗапуститьПрограмму(КомандаЗапуска);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ПоискИсполняемогоФайлаОнлайнПоддержки");
	
КонецПроцедуры

#КонецОбласти





 