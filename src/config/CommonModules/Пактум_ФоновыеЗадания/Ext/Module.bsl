﻿Процедура ПолучитьКарточкуКонтрагента(Параметры) Экспорт
	ЗаписатьДанныеКонтрагента(Параметры);	
КонецПроцедуры

Процедура ЗаписатьДанныеКонтрагента(Параметры)
	КолЦиклов=Параметры.КолЦиклов;
	пЕДРПОУ=Параметры.ЕДРПОУ;
	Конфигурация=Параметры.Конфигурация;
	Токен=Параметры.Токен;
	
	Если КолЦиклов >18 тогда
		КолЦиклов = 0;
	КонецЕсли;
	//Индикатор1 = Индикатор1 + 1;
	
	WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
	WinHttp.Option(2,"utf-8");
	WinHttp.Open("Get","https://pactumsys.com/api/v1/cba2911c-01f9-4ca7-833a-46fb0cc079f2/contractors/"+пЕДРПОУ+"?source=bas",0);       
	WinHttp.SetRequestHeader("Accept-Language", "ru");
	WinHttp.SetRequestHeader("Accept-Charset","utf-8");
	WinHttp.setRequestHeader("Content-Language", "ru");
	WinHttp.setRequestHeader("Content-Charset", "utf-8");
	WinHttp.setRequestHeader("Authorization", "Bearer "+Токен);
	WinHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
	ПараметрыПОСТ = "";
	WinHttp.Send(ПараметрыПОСТ);
	ТекстОтвета = WinHttp.ResponseText();
	Сообщить(ТекстОтвета);
	ЧтениеJSON = Новый ЧтениеJSON; 
	ЧтениеJSON.УстановитьСтроку( ТекстОтвета);
	Контрагент = ПрочитатьJSON (ЧтениеJSON);
	
	Если Контрагент.Свойство("Status") Тогда	//Все ОК
		пСтатус1=""; пСтатус2=""; пСтатус3="";
		Для Каждого ст Из Контрагент.RegisterStates Цикл
			Если ст.RegisterId = 1 Тогда	//ЕДР
				пСтатус1 = ст.Status;
			ИначеЕсли ст.RegisterId = 2 Тогда	//ЕН
				пСтатус2 = ст.Status;
			ИначеЕсли ст.RegisterId = 3 Тогда	//НДС
				пСтатус3 = ст.Status;
			КонецЕсли;
		КонецЦикла;
		//Если Контрагент.Status ="Done" и (Контрагент.RegisterStates.Количество() >= 3) тогда
		Если пСтатус1="Done" И пСтатус2="Done" И пСтатус3="Done" Тогда
			ЗаполнитьКонтрагента(Контрагент, Параметры);
			Пактум_ЗавершениеПоиска(Параметры);
			КолЦиклов=0;
		ИначеЕсли КолЦиклов < 18  тогда
			Sleep(10);
			Параметры.КолЦиклов =КолЦиклов+1;
			ПолучитьКарточкуКонтрагента(Параметры);
		Иначе
			СтатусЕДР=пСтатус1;	//ЕДР должен ответить...
			Если СтатусЕДР = "Done" Тогда
				ЗаполнитьКонтрагента(Контрагент, Параметры);
			КонецЕсли;
			
			КодОшибки=0;
			ТекстОшибки="";
			Для Каждого ст Из Контрагент.RegisterStates Цикл
				Если ст.Status ="Done" Тогда
					Продолжить;
				КонецЕсли;
				Если ст.RegisterId = 1 Тогда		//ЕДР
					КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("КодПоЕДРПОУ", пЕДРПОУ);
					Если КонтрагентСсылка = Справочники.Контрагенты.ПустаяСсылка() Тогда
						КодОшибки=4;
					Иначе
						КодОшибки=5;
					КонецЕсли;
				ИначеЕсли ст.RegisterId = 2 Тогда	//ЕН
					Если КодОшибки=0 Тогда
						КодОшибки=1;
					Иначе
						Если КодОшибки<4 Тогда
							КодОшибки=3;
						КонецЕсли;
					КонецЕсли;
				ИначеЕсли ст.RegisterId = 3 Тогда	//НДС
					Если КодОшибки=0 Тогда
						КодОшибки=2;
					Иначе
						Если КодОшибки<4 Тогда
							КодОшибки=3;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если КодОшибки=0 Тогда
				КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("КодПоЕДРПОУ", пЕДРПОУ);
				Если КонтрагентСсылка = Справочники.Контрагенты.ПустаяСсылка() Тогда
					КодОшибки=4;
				Иначе
					КодОшибки=5;
				КонецЕсли;
			КонецЕсли;
			ТекстОшибки=ПолучитьТекстОшибкиРеестров(КодОшибки);
			Пактум_ЗавершениеПоиска(Параметры, Истина, ТекстОшибки);
			КолЦиклов = 0;
		КонецЕсли;
	Иначе
		Пактум_ЗавершениеПоиска(Параметры, Истина, Контрагент.Message);
		КолЦиклов = 0;
	КонецЕсли;
	Параметры.Вставить("КолЦиклов", КолЦиклов);
КонецПроцедуры

Процедура Sleep(сек)
	нач=ТекущаяДата();
	Пока ТекущаяДата() - нач < сек Цикл
	КонецЦикла;    
КонецПроцедуры

Процедура ЗаписатьИнформациюОЗавершении(Параметры, фОшибки=Ложь, ТекстОшибки="")
	Если Не фОшибки Тогда
		//Запишем Налогообложение
		Если Параметры.Свойство("СистемаНалогообложения") Тогда
			Если ЗначениеЗаполнено(Параметры.СистемаНалогообложения) Тогда
				КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("КодПоЕДРПОУ", Параметры.ЕДРПОУ);
				Если Параметры.Конфигурация="УНФ" Тогда
					НаборЗаписей = РегистрыСведений.СистемыНалогообложенияКонтрагентов.СоздатьНаборЗаписей();
					ИмяРекв="СистемаНалогообложения";
				ИначеЕсли Параметры.Конфигурация="БП" Тогда
					НаборЗаписей = РегистрыСведений.СхемыНалогообложенияКонтрагентов.СоздатьНаборЗаписей();  			
					ИмяРекв="СхемаНалогообложения";
				КонецЕсли;
				НаборЗаписей.Отбор.Период.Установить(Параметры.ПериодНалогообложения);
				НаборЗаписей.Отбор.Контрагент.Установить(КонтрагентСсылка);
				НаборЗаписей.Прочитать();
				Если НаборЗаписей.Количество() = 0 Тогда
					НовыйНомер = НаборЗаписей.Добавить();
					НовыйНомер.Контрагент = КонтрагентСсылка;
					НовыйНомер.Период = Параметры.ПериодНалогообложения;
					НовыйНомер[ИмяРекв] = Параметры.СистемаНалогообложения;
				ИначеЕсли НаборЗаписей.Количество() = 1 Тогда
					НовыйНомер = НаборЗаписей[0];
					НовыйНомер.Контрагент = КонтрагентСсылка;
					НовыйНомер.Период = Параметры.ПериодНалогообложения;
					НовыйНомер[ИмяРекв] = Параметры.СистемаНалогообложения;
				КонецЕсли;
				НаборЗаписей.Записать();	
			КонецЕсли;
			Если Параметры.ОчиститьИНН Тогда
				Об=КонтрагентСсылка.ПолучитьОбъект();
				Об.ИНН="";
				Об.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	пНабор=РегистрыСведений.Пактум_ФоновыеЗадания.СоздатьНаборЗаписей();
	Попытка
		НовСтр=пНабор.Добавить();
		НовСтр.УИД=Параметры.УИД;
		НовСтр.фОшибки=фОшибки;
		НовСтр.ТекстОшибки=ТекстОшибки;
		пНабор.Записать();
	Исключение
	КонецПопытки;
КонецПроцедуры

Процедура ЗаполнитьКонтрагента(Контрагент, Параметры)
	Конфигурация=Параметры.Конфигурация;
	пЕДРПОУ=Параметры.ЕДРПОУ;
	
	Налогообложение=Новый Структура;
	Налогообложение.Вставить("СистемаНалогообложения", Неопределено);
	Налогообложение.Вставить("СистемаНалогообложенияТекст", "");
	Налогообложение.Вставить("ПериодНалогообложения", Дата(1, 1, 1, 0, 0, 0));
	Налогообложение.Вставить("ОчиститьИНН", Ложь);
	Параметры.Вставить("Налогообложение", Налогообложение);
	
	Попытка
	  	КонтрагентСсылка=Параметры.КонтрагентСсылка;
		Контрагенты = КонтрагентСсылка.ПолучитьОбъект();
		Контрагенты.Наименование = Контрагент.Name;
		Контрагенты.НаименованиеПолное = Контрагент.FullName;
		Контрагенты.КодПоЕДРПОУ = СокрЛП(Контрагент.Identifier);
		Если Конфигурация = "УНФ" тогда
			Контрагенты.ИНН = СокрЛП(Контрагент.IndividualTaxNumber);
			Если ЗначениеЗаполнено(Контрагент.VatCertificate) Тогда
				Контрагенты.НомерСвидетельства = Контрагент.VatCertificate;
			КонецЕсли;
			Контрагенты.НомерТелефона = 	Контрагент.Phone;
			Контрагенты.АдресЭП = 	Контрагент.Email;
			Контрагенты.СтранаРегистрации = Справочники.СтраныМира.Украина;
			Контрагенты.ВидКонтрагента  = Перечисления.ВидыКонтрагентов.ЮридическоеЛицо;
			Если Не Контрагент.IsFop = Неопределено Тогда
				Если Контрагент.IsFop = Истина Тогда
					Контрагенты.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель;	
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Лев(Конфигурация, 2) = "БП"  тогда
			Контрагенты.инн = СокрЛП(Контрагент.IndividualTaxNumber);
			Контрагенты.ЮридическоеФизическоеЛицо  = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
			Если Не Контрагент.IsFop = Неопределено Тогда
				Если Контрагент.IsFop = Истина Тогда
					Контрагенты.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;	
				КонецЕсли;
			КонецЕсли;
		Иначе	
			Контрагенты.ИННПлательщикаНДС = СокрЛП(Контрагент.IndividualTaxNumber);
			Контрагенты.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
			Если Не Контрагент.IsFop = Неопределено Тогда
				Если Контрагент.IsFop = Истина Тогда
					Если Конфигурация = "УТ" тогда
						Контрагенты.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель;	
					Иначе
						Контрагенты.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо;	
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если ЗначениеЗаполнено(Контрагент.VatCertificate) Тогда
				Контрагенты.НомерСвидетельстваПлательщикаНДС = Контрагент.VatCertificate;
			КонецЕсли;
			Если Контрагенты.Партнер = Справочники.Партнеры.ПустаяСсылка() тогда
				Партнер = Справочники.Партнеры.СоздатьЭлемент();
				Партнер.Наименование = Контрагент.Name;
				Партнер.НаименованиеПолное = Контрагент.FullName;
				Если СтрДлина(Контрагент.Identifier) = 10 тогда
					Партнер.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо;
				Иначе
					Партнер.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.Компания;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(Партнер.ДатаРегистрации) Тогда
					Партнер.ДатаРегистрации=ТекущаяДата();
				КонецЕсли;
				Партнер.Записать();
				Контрагенты.Партнер  =  Партнер.Ссылка;
			КонецЕсли;
		КонецЕсли;
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.Адрес);
		СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
		Массив = Контрагенты.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
		Если Массив.Количество() = 0 тогда
			Стр = Контрагенты.КонтактнаяИнформация.Добавить();	
			Стр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
			Стр.Вид = Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента;
		иначе
			Стр = Массив[0];
		КонецЕсли;
		Если Контрагент.IsAddressElements=0 Тогда
			Стр.Представление = Контрагент.Address;
		Иначе
			СтруЗначенияПолей = Новый Структура;
			СтруЗначенияПолей.Вставить("Индекс", 			Контрагент.Address_zip);
			СтруЗначенияПолей.Вставить("Страна", 			Контрагент.Address_country);
			СтруЗначенияПолей.Вставить("НаселенныйПункт", 	Контрагент.Address_atu);
			СтруЗначенияПолей.Вставить("Улица", 			Контрагент.Address_street);
			СтруЗначенияПолей.Вставить("ТипДома", 			Адрес_ТипДома(Контрагент.Address_house_type));
			СтруЗначенияПолей.Вставить("Дом", 				Контрагент.Address_house);
			СтруЗначенияПолей.Вставить("ТипКорпуса", 		Адрес_ТипКорпуса(Контрагент.Address_building_type));
			СтруЗначенияПолей.Вставить("Корпус", 			Контрагент.Address_building);
			СтруЗначенияПолей.Вставить("ТипКвартиры", 		Адрес_ТипКвартиры(Контрагент.Address_num_type));
			СтруЗначенияПолей.Вставить("Квартира", 			Контрагент.Address_num);
			СтруЗначенияПолей.Вставить("Представление",		Контрагент.Address); 
			
			АдресСтрокойВJSON = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(СтруЗначенияПолей, Перечисления.ТипыКонтактнойИнформации.Адрес);
			Стр.Значение = АдресСтрокойВJSON;
			Стр.Представление = Контрагент.Address; 
			
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.Адрес);
			СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента);
			Массив = Контрагенты.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
			Если Массив.Количество() = 0 Тогда
				Стр = Контрагенты.КонтактнаяИнформация.Добавить();	
				Стр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
				Стр.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента;
				Стр.Значение = АдресСтрокойВJSON; 
				Стр.Представление = Контрагент.Address;
			КонецЕсли;
		КонецЕсли;
		
		//Пишем все телефоны в одну строку...
		Если Не Контрагент.Contacts_Phones = Неопределено Тогда
			Если Контрагент.Contacts_Phones.Количество() > 0 Тогда
				СтрокаТелефоны = "";
				Для Каждого ТелНомер Из Контрагент.Contacts_Phones Цикл
					Если ПустаяСтрока(ТелНомер) Тогда
						Продолжить;
					КонецЕсли;
					СтрокаТелефоны = СтрокаТелефоны + ?(СтрокаТелефоны="", "", ", ") + СокрЛП(ТелНомер);
				КонецЦикла;
				
				Если Не ПустаяСтрока(СтрокаТелефоны) Тогда
					СтруктураОтбора = Новый Структура;
					СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.Телефон);
					СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
					Массив = Контрагенты.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
					Если Массив.Количество() = 0 Тогда
						Стр = Контрагенты.КонтактнаяИнформация.Добавить();	
						Стр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
						Стр.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента;
					Иначе
						Стр = Массив[0];
					КонецЕсли;
					Стр.Представление = СтрокаТелефоны;
					Стр.НомерТелефона = СтрокаТелефоны;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ПустаяСтрока(Контрагент.Contacts_Fax) Тогда
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.Факс);
			СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.ФаксКонтрагенты);
			Массив = Контрагенты.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
			Если Массив.Количество() = 0 тогда
				Стр = Контрагенты.КонтактнаяИнформация.Добавить();	
				Стр.Тип = Перечисления.ТипыКонтактнойИнформации.Факс;
				Стр.Вид = Справочники.ВидыКонтактнойИнформации.ФаксКонтрагенты;
				Стр.Представление = Контрагент.Contacts_Fax;
				Стр.НомерТелефона = Контрагент.Contacts_Fax;
			Иначе
				Стр = Массив[0];
				Стр.Представление = Контрагент.Contacts_Fax;
				Стр.НомерТелефона = Контрагент.Contacts_Fax;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ПустаяСтрока(Контрагент.Contacts_Email) Тогда
			Если Лев(Конфигурация, 2) = "БП"  тогда
				СтруктураОтбора = Новый Структура;
				СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
				СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.EmailКонтрагенты);
				Массив = Контрагенты.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
				Если Массив.Количество() = 0 тогда
					Стр = Контрагенты.КонтактнаяИнформация.Добавить();	
					Стр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
					Стр.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтрагенты;
					Стр.Представление = Контрагент.Contacts_Email;
					Стр.АдресЭП 	  =	Контрагент.Contacts_Email;
					
				Иначе
					Стр = Массив[0];
					Стр.Представление = Контрагент.Contacts_Email;
					Стр.АдресЭП = 		Контрагент.Contacts_Email;
				КонецЕсли;
			Иначе
				СтруктураОтбора = Новый Структура;
				СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
				СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.EmailКонтрагента);
				Массив = Контрагенты.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
				Если Массив.Количество() = 0 Тогда
					Стр = Контрагенты.КонтактнаяИнформация.Добавить();	
					Стр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
					Стр.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтрагента;
					Стр.Представление = Контрагент.Contacts_Email;
					Стр.АдресЭП = 		Контрагент.Contacts_Email;
					
				Иначе
					Стр = Массив[0];
					Стр.Представление = Контрагент.Contacts_Email;
					Стр.АдресЭП = 		Контрагент.Contacts_Email;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Контрагенты.Записать();
		//
		//Партнеры...
		Попытка
			Партнер=Контрагенты.Партнер;
			ОбПартнер=Партнер.ПолучитьОбъект();
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.Адрес);
			СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.АдресПартнера);
			Массив = ОбПартнер.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
			Если Массив.Количество() = 0 тогда
				Стр = ОбПартнер.КонтактнаяИнформация.Добавить();	
				Стр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
				Стр.Вид = Справочники.ВидыКонтактнойИнформации.АдресПартнера;
				Стр.Представление = Контрагент.Address;
			иначе
				Стр = Массив[0];
				Стр.Представление = Контрагент.Address;	
			КонецЕсли;
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.Телефон);
			СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.ТелефонПартнера);
			Массив = ОбПартнер.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
			Если Массив.Количество() = 0 тогда
				Стр = ОбПартнер.КонтактнаяИнформация.Добавить();	
				Стр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
				Стр.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонПартнера;
				Стр.Представление = 	Контрагент.Phone;
				Стр.НомерТелефона = 	Контрагент.Phone;
			иначе
				Стр = Массив[0];
				Стр.Представление = 	Контрагент.Phone;
				Стр.НомерТелефона = 	Контрагент.Phone;
			КонецЕсли;
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("Тип",Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
			СтруктураОтбора.Вставить("Вид",Справочники.ВидыКонтактнойИнформации.EmailПартнера);
			Массив = ОбПартнер.КонтактнаяИнформация.НайтиСтроки(СтруктураОтбора);
			Если Массив.Количество() = 0 тогда
				Стр = ОбПартнер.КонтактнаяИнформация.Добавить();	
				Стр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
				Стр.Вид = Справочники.ВидыКонтактнойИнформации.EmailПартнера;
				Стр.Представление 	= 	Контрагент.Email;
				Стр.АдресЭП 	 	= 	Контрагент.Email;
			иначе
				Стр = Массив[0];
				Стр.Представление 	= 	Контрагент.Email;
				Стр.АдресЭП 		= 	Контрагент.Email;
			КонецЕсли;
			ОбПартнер.Записать();
		Исключение
		КонецПопытки;
		
		спКонтакты=ПолучитьКонтактыКонтрагента(Контрагент);
		Если спКонтакты.Количество()>0 Тогда
			Для Х=1 По спКонтакты.Количество() Цикл
				пКонтакт=спКонтакты[Х-1];
				Если Конфигурация = "УНФ" тогда
					КонтактныеЛицаКонтрагентаСсылка = Справочники.КонтактныеЛица.НайтиПоНаименованию(пКонтакт.Значение,,,Контрагенты.Ссылка);
					Если КонтактныеЛицаКонтрагентаСсылка = Справочники.КонтактныеЛица.ПустаяСсылка() тогда
						КонтактныеЛицаКонтрагента = Справочники.КонтактныеЛица.СоздатьЭлемент();
					Иначе
						КонтактныеЛицаКонтрагента = КонтактныеЛицаКонтрагентаСсылка.ПолучитьОбъект();
					КонецЕсли;				
					КонтактныеЛицаКонтрагента.Владелец =Контрагенты.Ссылка;
					КонтактныеЛицаКонтрагента.Наименование =пКонтакт.Значение; 
					КонтактныеЛицаКонтрагента.Записать();
				ИначеЕсли Лев(Конфигурация, 2)  = "БП" тогда
					Зап=Новый Запрос;
					Зап.Текст=
					"ВЫБРАТЬ
					|	КонтактныеЛица.Ссылка
					|ИЗ
					|	Справочник.КонтактныеЛица КАК КонтактныеЛица
					|ГДЕ
					|	КонтактныеЛица.Наименование = &Наименование
					|	И КонтактныеЛица.ОбъектВладелец = &ОбъектВладелец
					|	И КонтактныеЛица.ВидКонтактногоЛица = &ВидКонтактногоЛица";
					Зап.УстановитьПараметр("Наименование", пКонтакт.Значение);
					Зап.УстановитьПараметр("ОбъектВладелец", Контрагенты.Ссылка);
					Зап.УстановитьПараметр("ВидКонтактногоЛица", Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента);
					Рез=Зап.Выполнить();
					Если Рез.Пустой() Тогда
						КонтактныеЛица = Справочники.КонтактныеЛица.СоздатьЭлемент();
					 Иначе
						Выб=Рез.Выбрать();
						Выб.Следующий();
						КонтактныеЛица = Выб.Ссылка.ПолучитьОбъект(); 
					КонецЕсли;
					//КонтактныеЛицаСсылка = Справочники.КонтактныеЛица.НайтиПоНаименованию(пКонтакт.Значение);
					//Если КонтактныеЛицаСсылка = Справочники.КонтактныеЛица.ПустаяСсылка() тогда
					//	КонтактныеЛица = Справочники.КонтактныеЛица.СоздатьЭлемент();
					//Иначе
					//	КонтактныеЛица = КонтактныеЛицаСсылка.ПолучитьОбъект();
					//КонецЕсли;
				    Если Х=1 Тогда
						КонтактныеЛица.Фамилия = Контрагент.DirectorLastName;
						КонтактныеЛица.Имя = Контрагент.DirectorFirstName;
						КонтактныеЛица.Отчество = Контрагент.DirectorMiddleName;
				    КонецЕсли;
					КонтактныеЛица.ОбъектВладелец =Контрагенты.Ссылка;
					КонтактныеЛица.Наименование =пКонтакт.Значение; 
					КонтактныеЛица.ВидКонтактногоЛица=Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента;
					КонтактныеЛица.Записать();
					Если Конфигурация="БП2" Тогда
						Если Х=1 Тогда
							Попытка
								НаборЗаписей = РегистрыСведений.ОтветственныеЛицаКонтрагентов.СоздатьНаборЗаписей();
								НаборЗаписей.Отбор.Контрагент.Установить(Контрагенты.Ссылка);
								НаборЗаписей.Отбор.ОтветственноеЛицо.Установить(Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
								НаборЗаписей.Прочитать();
								фНужноДобавить=Истина;
								Если НаборЗаписей.Количество() > 0 Тогда 
									ТекЗапись=НаборЗаписей[0];
									Если ТекЗапись.КонтактноеЛицо=КонтактныеЛица.Ссылка Тогда
										фНужноДобавить=Ложь;
									КонецЕсли;
								КонецЕсли;
								Если фНужноДобавить Тогда
									ТекЗапись=НаборЗаписей.Добавить();
									ТекЗапись.Период=ТекущаяДата();
									ТекЗапись.Контрагент=Контрагенты.Ссылка;
									ТекЗапись.ОтветственноеЛицо=Перечисления.ОтветственныеЛицаОрганизаций.Руководитель;
									ТекЗапись.КонтактноеЛицо=КонтактныеЛица.Ссылка;
									ТекЗапись.Активность=Истина;
									НаборЗаписей.Записать();
								КонецЕсли;
							Исключение
							КонецПопытки;
						КонецЕсли;
					КонецЕсли;
				Иначе
					КонтактныеЛицаКонтрагентаСсылка = Справочники.КонтактныеЛицаПартнеров.НайтиПоНаименованию(пКонтакт.Значение,,,Контрагенты.Партнер);
					Если КонтактныеЛицаКонтрагентаСсылка = Справочники.КонтактныеЛицаПартнеров.ПустаяСсылка() тогда
						КонтактныеЛицаКонтрагента = Справочники.КонтактныеЛицаПартнеров.СоздатьЭлемент();
					Иначе
						КонтактныеЛицаКонтрагента = КонтактныеЛицаКонтрагентаСсылка.ПолучитьОбъект();
					КонецЕсли;				
					КонтактныеЛицаКонтрагента.Владелец =Контрагенты.Партнер;
					КонтактныеЛицаКонтрагента.Наименование =пКонтакт.Значение; 
					КонтактныеЛицаКонтрагента.Автор = ПараметрыСеанса.ТекущийПользователь; 
					КонтактныеЛицаКонтрагента.Записать();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		//Если Контрагент.VatRegisterStatus = "Done" и Контрагент.VatRegistrationDate = неопределено тогда
		//  Сообщить(НСтр("ru='В реестре по НДС не найдено информацию по контрагенту "+Контрагент.FullName+"';uk= 'В реєстрі по НДС не знайдено інформаці по контрагенту "+Контрагент.FullName+"'"));
		
		//  
		// КонецЕсли;
		
		ПолучитьНалогообложение(Контрагент, Параметры);
	Исключение
	КонецПопытки;
КонецПроцедуры

Функция ПолучитьКонтактыКонтрагента(Контрагент)
	Сп=Новый СписокЗначений;
	//Первый - директор, есть в структуре
	пФИО1="";
	Если Не Контрагент.DirectorLastName=Неопределено Тогда
		пФИО1=СокрЛП(Контрагент.DirectorLastName);
	КонецЕсли;
	пФИО2="";
	Если Не Контрагент.DirectorFirstName=Неопределено Тогда
		пФИО2=СокрЛП(Контрагент.DirectorFirstName);
	КонецЕсли;
	пФИО3="";
	Если Не Контрагент.DirectorMiddleName=Неопределено Тогда
		пФИО3=СокрЛП(Контрагент.DirectorMiddleName);
	КонецЕсли;
	Если Не пФИО1+пФИО2+пФИО3="" Тогда
		Сп.Добавить(пФИО1+" "+пФИО2+" "+пФИО3);
	Иначе
		//Для ФОП - наименование
		Если СтрДлина(Контрагент.Identifier) = 10 тогда
			Сп.Добавить(СокрЛП(Контрагент.Name));
		КонецЕсли;
	КонецЕсли;

	СтрДанные=Контрагент.DirectorInformation;
	ДлинаСтроки=СтрДлина(СтрДанные);
	фОбработаноВсе=Ложь;
	пТекНомПоз=1;
	Пока Не фОбработаноВсе Цикл
		пРабочаяСтрока=Сред(СтрДанные, пТекНомПоз, ДлинаСтроки);
		пНомПоз=Найти(пРабочаяСтрока, "; ");
		Если пНомПоз=0 Тогда
			фОбработаноВсе=Истина;
		Иначе
			пТекНомПоз=пТекНомПоз+пНомПоз+2;
			пРабочаяСтрока=Сред(пРабочаяСтрока, 1, пНомПоз);
		КонецЕсли;
		Если пРабочаяСтрока="" Тогда
			Продолжить;
		КонецЕсли;
		пНомПоз=Найти(пРабочаяСтрока, " - ");
		Если пНомПоз>0 Тогда
			пРабочаяСтрока=СокрЛП(Лев(пРабочаяСтрока, пНомПоз - 1));
		КонецЕсли;
		Если Сп.НайтиПоЗначению(пРабочаяСтрока)=Неопределено Тогда
			Сп.Добавить(пРабочаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Сп;
КонецФункции

Процедура ПолучитьНалогообложение(Контрагент, Параметры)
	Параметры.Налогообложение.Вставить("ОчиститьИНН", Ложь);
	ДатаСтарт = Контрагент.CompanyStartDate;
	Если ДатаСтарт=Неопределено Тогда
		ДатаСтарт=Дата(1, 1, 1, 0, 0, 0);
	Иначе
		ДатаСтарт=Дата(Число(Сред(ДатаСтарт,7,4)),Число(Сред(ДатаСтарт,4,2)),Число(Сред(ДатаСтарт,1,2)));
	КонецЕсли;
	ДатаРегистрацииНДС = Контрагент.VatRegistrationDate;
	Если Не ДатаРегистрацииНДС=Неопределено Тогда
		ДатаРегистрацииНДС=Дата(Число(Сред(ДатаРегистрацииНДС,7,4)),Число(Сред(ДатаРегистрацииНДС,4,2)),Число(Сред(ДатаРегистрацииНДС,1,2)));
		//ДатаРегистрацииНДС_Реал = ДатаРегистрацииНДС;
		Если ДатаРегистрацииНДС>ТекущаяДата() Тогда
			//ДатаРегистрацииНДС=ДатаСтарт;
			Параметры.Налогообложение.Вставить("ОчиститьИНН", Истина);
		КонецЕсли;
	Иначе
		ДатаРегистрацииНДС=ДатаСтарт;
		//ДатаРегистрацииНДС_Реал = ДатаРегистрацииНДС;
	КонецЕсли;
	ДатаАннуляцииНДС = Контрагент.VATCancellationDate;
	Если Не ДатаАннуляцииНДС=Неопределено Тогда
		ДатаАннуляцииНДС=Дата(Число(Сред(ДатаАннуляцииНДС,7,4)),Число(Сред(ДатаАннуляцииНДС,4,2)),Число(Сред(ДатаАннуляцииНДС,1,2)));
	Иначе
		//ДатаАннуляцииНДС=ДатаСтарт;
		ДатаАннуляцииНДС=Дата(1, 1, 1, 0, 0, 0);
	КонецЕсли;
	ДатаЕдиныйНалог = Контрагент.SingleTaxStartDate;
	Если Не ДатаЕдиныйНалог=Неопределено Тогда
		ДатаЕдиныйНалог=Дата(Число(Сред(ДатаЕдиныйНалог,7,4)),Число(Сред(ДатаЕдиныйНалог,4,2)),Число(Сред(ДатаЕдиныйНалог,1,2)));
		Если ДатаЕдиныйНалог>ТекущаяДата() Тогда
			ДатаЕдиныйНалог=ДатаСтарт;
		КонецЕсли;
	Иначе
		ДатаЕдиныйНалог=ДатаСтарт;
	КонецЕсли;
	
	Если Контрагент.TaxSystem = "Єдиний податок" тогда
		Если Контрагент.IndividualTaxNumber = неопределено тогда
			Если ДатаЕдиныйНалог<=ТекущаяДата() Тогда
				Параметры.Налогообложение.Вставить("ПериодНалогообложения", НачалоМесяца(ДатаЕдиныйНалог));
				Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "ЕдиныйНалог");
			КонецЕсли;
		ИначеЕсли ДатаРегистрацииНДС>ТекущаяДата() Тогда
			Параметры.Налогообложение.Вставить("ПериодНалогообложения", НачалоМесяца(ДатаСтарт));
			Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "ЕдиныйНалог");
		Иначе
			Если ДатаЕдиныйНалог<=ТекущаяДата() Тогда
				Если ДатаРегистрацииНДС<=ДатаАннуляцииНДС И ДатаРегистрацииНДС<=ТекущаяДата() И ДатаАннуляцииНДС<=ТекущаяДата() Тогда
					Параметры.Налогообложение.Вставить("ПериодНалогообложения", Макс(НачалоМесяца(ДатаАннуляцииНДС), НачалоМесяца(ДатаЕдиныйНалог)));
					Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "ЕдиныйНалог");
				Иначе
					Параметры.Налогообложение.Вставить("ПериодНалогообложения", Макс(НачалоМесяца(ДатаРегистрацииНДС), НачалоМесяца(ДатаЕдиныйНалог)));
					Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "ЕдиныйНалогИНДС");
				КонецЕсли;
			Иначе
				Если ДатаРегистрацииНДС<=ДатаАннуляцииНДС И ДатаРегистрацииНДС<=ТекущаяДата() И ДатаАннуляцииНДС<=ТекущаяДата() Тогда
					Параметры.Налогообложение.Вставить("ПериодНалогообложения", НачалоМесяца(ДатаАннуляцииНДС));
					Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "НалогНаПрибыль");
				Иначе
					Параметры.Налогообложение.Вставить("ПериодНалогообложения", Макс(НачалоМесяца(ДатаРегистрацииНДС), НачалоМесяца(ДатаСтарт)));
					Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "ЕдиныйНалогИНДС");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Контрагент.TaxSystem = "Податок на прибуток" тогда
		Если Контрагент.IndividualTaxNumber = неопределено тогда
			Если ДатаСтарт<=ТекущаяДата() Тогда
				Параметры.Налогообложение.Вставить("ПериодНалогообложения", НачалоМесяца(ДатаСтарт));
				Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "НалогНаПрибыль");
			КонецЕсли;
		ИначеЕсли ДатаРегистрацииНДС>ТекущаяДата() Тогда
			Параметры.Налогообложение.Вставить("ПериодНалогообложения", НачалоМесяца(ДатаСтарт));
			Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "НалогНаПрибыль");
		Иначе		
			Если ДатаРегистрацииНДС<=ДатаАннуляцииНДС И ДатаРегистрацииНДС<=ТекущаяДата() И ДатаАннуляцииНДС<=ТекущаяДата() Тогда
				Параметры.Налогообложение.Вставить("ПериодНалогообложения", НачалоМесяца(ДатаАннуляцииНДС));
				Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "НалогНаПрибыль");
			Иначе
				Параметры.Налогообложение.Вставить("ПериодНалогообложения", Макс(НачалоМесяца(ДатаРегистрацииНДС), НачалоМесяца(ДатаСтарт)));
				Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "НалогНаПрибыльИНДС");
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Контрагент.TaxSystem = "Неплатник" Тогда
		Если ДатаСтарт<=ТекущаяДата() Тогда
			Параметры.Налогообложение.Вставить("ПериодНалогообложения", НачалоМесяца(ДатаСтарт));
			Параметры.Налогообложение.Вставить("СистемаНалогообложенияТекст", "НеПлательщик");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьТекстОшибкиРеестров(КодОшибки)
	Если КодОшибки=1 Тогда
		Возврат НСтр("ru='К сожалению, на данный момент реестр единого налога работает нестабильно. 
				|Карточка контрагента сформирована без заполнения данных по налогообложению. 
				|Запустите повторно заполнение карточки через несколько минут. При повторном заполнении карточки сегодня до 23:59 Ваш баланс не уменьшится.'
				|;uk='На жаль, на даний момент реєстр єдиного податку працює нестабільно.
    			| Картка контрагента сформована без заповнення даних з оподаткування.
    			| Запустіть повторно заповнення картки через кілька хвилин. При повторному заповненні картки сьогодні до 23:59 Ваш баланс не зменшиться.'");
	ИначеЕсли КодОшибки=2 Тогда
		Возврат	НСтр("ru='К сожалению, на данный момент реестр НДС работает нестабильно. 
				|Карточка контрагента сформирована без заполнения данных по налогообложению. 
				|Запустите повторно заполнение карточки через несколько минут. При повторном заполнении карточки сегодня до 23:59 Ваш баланс не уменьшится.'
				|;uk='На жаль, на даний момент реєстр ПДВ працює нестабільно.
    			| Картка контрагента сформована без заповнення даних з оподаткування.
    			| Запустіть повторно заповнення картки через кілька хвилин. При повторному заповненні картки сьогодні до 23:59 Ваш баланс не зменшиться.'");	
	ИначеЕсли КодОшибки=3 Тогда
		Возврат	НСтр("ru='К сожалению, на данный момент реестры НДС и единого налога работают нестабильно. 
				|Карточка контрагента сформирована без заполнения данных по налогообложению. 
				|Запустите повторно заполнение карточки через несколько минут. При повторном заполнении карточки сегодня до 23:59 Ваш баланс не уменьшится.'
				|;uk='На жаль, на даний момент реєстри ПДВ і єдиного податку працюють нестабільно.
    			| Картка контрагента сформована без заповнення даних з оподаткування.
    			| Запустіть повторно заповнення картки через кілька хвилин. При повторному заповненні картки сьогодні до 23:59 Ваш баланс не зменшиться.'");	
	ИначеЕсли КодОшибки=4 Тогда
		Возврат	НСтр("ru='К сожалению, на данный момент Единый государственный реестр работает нестабильно. 
				|Карточка контрагента не заполнена. Запустите повторно заполнение карточки через несколько минут. 
				|При повторном заполнении карточки сегодня до 23:59 Ваш баланс не уменьшится.'
				|;uk='На жаль, на даний момент Єдиний державний реєстр працює нестабільно.
    			| Картка контрагента не заповнена. Запустіть повторно заповнення картки через кілька хвилин.
    			| При повторному заповненні картки сьогодні до 23:59 Ваш баланс не зменшиться.'");
	ИначеЕсли КодОшибки=5 Тогда
		Возврат	НСтр("ru='К сожалению, на данный момент Единый государственный реестр работает нестабильно. 
				|Карточка запрашиваемого контрагента не заполнена. Запустите повторно заполнение карточки через несколько минут. 
				|При повторном заполнении карточки сегодня до 23:59 Ваш баланс не уменьшится.'
				|;uk='На жаль, на даний момент Єдиний державний реєстр працює нестабільно.
    			| Картка контрагента не заповнена. Запустіть повторно заповнення картки через кілька хвилин.
    			| При повторному заповненні картки сьогодні до 23:59 Ваш баланс не зменшиться.'");
	Иначе
		Возврат "";			
	КонецЕсли;
КонецФункции

Процедура Пактум_ЗавершениеПоиска(Параметры, фОшибки=Ложь, ТекстОшибки="")
	пЕДРПОУ=Параметры.ЕДРПОУ;
	Если Не фОшибки Тогда
		//Запишем Налогообложение
		Если Параметры.Налогообложение.Свойство("СистемаНалогообложенияТекст") Тогда
			Если ЗначениеЗаполнено(Параметры.Налогообложение.СистемаНалогообложенияТекст) Тогда
				КонтрагентСсылка = Параметры.КонтрагентСсылка;
				КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("КодПоЕДРПОУ", пЕДРПОУ);
				НаборЗаписей=Неопределено;
				Если Параметры.Конфигурация="УНФ" Тогда
					Если КонтрагентСсылка=Справочники.Контрагенты.ПустаяСсылка() Тогда
						КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("ИНН", пЕДРПОУ);
					КонецЕсли;
					НаборЗаписей = РегистрыСведений.СистемыНалогообложенияКонтрагентов.СоздатьНаборЗаписей();
					ИмяРекв="СистемаНалогообложения";
					Если Параметры.Налогообложение.СистемаНалогообложенияТекст="ЕдиныйНалог" Или
							Параметры.Налогообложение.СистемаНалогообложенияТекст="ЕдиныйНалогИНДС" Тогда
						Параметры.Налогообложение.Вставить("СистемаНалогообложения", Перечисления.СистемыНалогообложения.Упрощенная);
					ИначеЕсли Параметры.Налогообложение.СистемаНалогообложенияТекст="НалогНаПрибыль" Или
							Параметры.Налогообложение.СистемаНалогообложенияТекст="НалогНаПрибыльИНДС" Или
							Параметры.Налогообложение.СистемаНалогообложенияТекст="НеПлательщик" Тогда
						Параметры.Налогообложение.Вставить("СистемаНалогообложения", Перечисления.СистемыНалогообложения.Общая);
					КонецЕсли;
				ИначеЕсли Лев(Параметры.Конфигурация, 2) = "БП" Тогда
					НаборЗаписей = РегистрыСведений.СхемыНалогообложенияКонтрагентов.СоздатьНаборЗаписей();  			
					ИмяРекв="СхемаНалогообложения";
					Если Параметры.Налогообложение.СистемаНалогообложенияТекст="ЕдиныйНалог" Тогда
						Параметры.Налогообложение.Вставить("СистемаНалогообложения", Справочники.СхемыНалогообложения.ЕдиныйНалог);
					ИначеЕсли Параметры.Налогообложение.СистемаНалогообложенияТекст="ЕдиныйНалогИНДС" Тогда
						Параметры.Налогообложение.Вставить("СистемаНалогообложения", Справочники.СхемыНалогообложения.ЕдиныйНалогИНДС);
					ИначеЕсли Параметры.Налогообложение.СистемаНалогообложенияТекст="НалогНаПрибыль" Тогда
						Параметры.Налогообложение.Вставить("СистемаНалогообложения", Справочники.СхемыНалогообложения.НалогНаПрибыль);
					ИначеЕсли Параметры.Налогообложение.СистемаНалогообложенияТекст="НалогНаПрибыльИНДС" Тогда
						Параметры.Налогообложение.Вставить("СистемаНалогообложения", Справочники.СхемыНалогообложения.НалогНаПрибыльИНДС);
					ИначеЕсли Параметры.Налогообложение.СистемаНалогообложенияТекст="НеПлательщик" Тогда
						Параметры.Налогообложение.Вставить("СистемаНалогообложения", Справочники.СхемыНалогообложения.НеПлательщик);
					КонецЕсли;
				КонецЕсли;
				Если Не НаборЗаписей=Неопределено Тогда
					НаборЗаписей.Отбор.Период.Установить(Параметры.Налогообложение.ПериодНалогообложения);
					НаборЗаписей.Отбор.Контрагент.Установить(КонтрагентСсылка);
					НаборЗаписей.Прочитать();
					Если НаборЗаписей.Количество() = 0 Тогда
						НовыйНомер = НаборЗаписей.Добавить();
						НовыйНомер.Контрагент = КонтрагентСсылка;
						НовыйНомер.Период = Параметры.Налогообложение.ПериодНалогообложения;
						НовыйНомер[ИмяРекв] = Параметры.Налогообложение.СистемаНалогообложения;
					ИначеЕсли НаборЗаписей.Количество() = 1 Тогда
						НовыйНомер = НаборЗаписей[0];
						НовыйНомер.Контрагент = КонтрагентСсылка;
						НовыйНомер.Период = Параметры.Налогообложение.ПериодНалогообложения;
						НовыйНомер[ИмяРекв] = Параметры.Налогообложение.СистемаНалогообложения;
					КонецЕсли;
					НаборЗаписей.Записать();	
				Иначе
					Попытка
						Если ЗначениеЗаполнено(КонтрагентСсылка.ИННПлательщикаНДС) И Найти(Параметры.Налогообложение.СистемаНалогообложенияТекст, "НДС")>0 Тогда
							Если Не КонтрагентСсылка.ПлательщикНДС Тогда
								Об=КонтрагентСсылка.ПолучитьОбъект();
								Об.ПлательщикНДС=Истина;
								Об.Записать();
							КонецЕсли;
						Иначе
							Если КонтрагентСсылка.ПлательщикНДС Тогда
								Об=КонтрагентСсылка.ПолучитьОбъект();
								Об.ПлательщикНДС=Ложь;
								Об.Записать();
							КонецЕсли;
						КонецЕсли;
					Исключение
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
			//Если Налогообложение.ОчиститьИНН Тогда
			Если Найти(Параметры.Налогообложение.СистемаНалогообложенияТекст, "НДС")=0 Тогда
				Попытка
					Об=КонтрагентСсылка.ПолучитьОбъект();
					Об.ИНН="";
					Об.Записать();
				Исключение
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	пНабор=РегистрыСведений.Пактум_ФоновыеЗадания.СоздатьНаборЗаписей();
	Попытка
		НовСтр=пНабор.Добавить();
		НовСтр.УИД=Параметры.УИД;
		НовСтр.фОшибки=фОшибки;
		НовСтр.ТекстОшибки=ТекстОшибки;
		пНабор.Записать();
	Исключение
	КонецПопытки;
КонецПроцедуры

Функция Адрес_ТипДома(Зн) 
	Возврат "Дом"; 
КонецФункции

Функция Адрес_ТипКорпуса(Зн)
	Возврат "Корпус";	
КонецФункции

Функция Адрес_ТипКвартиры(Зн)
	ТипПомещения = "Квартира";
	
	Если Зн="кімн." Тогда
		ТипПомещения = "Комната";
	ИначеЕсли Зн="прим." Тогда
		ТипПомещения = "Помещение";
	ИначеЕсли Зн="оф." Тогда
		ТипПомещения = "Офис";	
	КонецЕсли;
	
	Возврат ТипПомещения;
	
КонецФункции
