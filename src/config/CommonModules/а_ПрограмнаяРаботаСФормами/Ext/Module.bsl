﻿#Область ПрограммныйИнтерфейс

// Добавляет новую команду формы. Дополнительно можно сразу разместить кнопку на форме
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  ИмяКоманды  - Строка - имя новой команды формы
//
//  ДействиеКоманды  - Строка - имя обработчика для команды
//
//  ИмяГруппы  - Строка - имя родительского элемента, если необходимо разместить команду на форме
//			   - Неопределено - если нужно только создать новую команду
//								По умолчанию команда размещается в корне формы
//
//  ВидКнопки  - ВидКнопкиФормы   - вид кнопки формы. По умолчанию ОбычнаяКнопка или КнопкаКоманднойПанели,
//														зависит от родителя
//
//  Заголовок  - Строка  - заголовок кнопки формы. Не обязательный
//
//  ПоместитьПеред  - Строка - имя элемента, перед которым необходимо разместить кнопку формы. Не обязательный
//
//  Картинка  - Картинка - картинка кнопки формы. Не обязательный
//
//  ОтображениеКнопки  - ОтображениеКнопки - вариант отражение кнопки на форме. Учитывается только если
//												заполнен параметр Картинка. Не обязательный
//
Процедура ДобавитьРазместитьКомандуФормы(Форма, ИмяКоманды, ДействиеКоманды, ИмяГруппы = "", ВидКнопки = Неопределено,
										Заголовок = "", ПоместитьПеред = "",
										Картинка = Неопределено, ОтображениеКнопки = Неопределено,
										Доступность = Истина) Экспорт

	Команда = Форма.Команды.Добавить(ИмяКоманды);
	Команда.Действие = ДействиеКоманды;
	
	Если ЗначениеЗаполнено(Заголовок) Тогда
		Команда.Заголовок = Заголовок;
	КонецЕсли;
	
	Если Картинка <> Неопределено Тогда
	
		Команда.Картинка = Картинка;
		
		Если ОтображениеКнопки <> Неопределено Тогда
			Команда.Отображение = ОтображениеКнопки;
		КонецЕсли;
	
	КонецЕсли;
	
	Если ИмяГруппы = Неопределено Тогда
		Возврат;	
	ИначеЕсли ЗначениеЗаполнено(ИмяГруппы) Тогда
		ЭлементРодитель = Форма.Элементы[ИмяГруппы];
	Иначе
		ЭлементРодитель = Форма;
	КонецЕсли;
	
	КнопкаФормы = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), ЭлементРодитель);
	КнопкаФормы.ИмяКоманды = ИмяКоманды;
	КнопкаФормы.Доступность = Доступность;
	
	Если ВидКнопки <> Неопределено Тогда
		КнопкаФормы.Вид = ВидКнопки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоместитьПеред) Тогда
		Форма.Элементы.Переместить(КнопкаФормы, ЭлементРодитель, Форма.Элементы[ПоместитьПеред]);	
	КонецЕсли; 		

КонецПроцедуры        

// Добавляет новый реквизит формы
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  ИмяРеквизита  - Строка - имя нового реквизита формы
//
//  ТипРеквизита  - ОписаниеТипов - тип реквизита. По умолчанию строка
//
//  ЗаголовокРеквизита  - Строка - отображаемый текст реквизита. Не обязательный
//
//  Путь  - Строка  - путь к создаваемому реквизиту. Не включает имя реквизита. Не обязательный
//
//  СохраняемыеДанные  - Булево  - если реквизит содержит сохраняемые данные. По умолчанию Ложь
//
//  РодительЭлемента  - Строка - имя родителя элемента формы,
//								если дополнительно необходимо разместить на форме. Не обязательный
//
//  ИмяЭлемента  - Строка - если заполнен параметр РодительЭлемента, то дополнительно можно указать имя элемента формы.
//							По умолчанию именем будет ИмяРеквизита
//
Процедура ДобавитьРеквизитФормы(Форма, ИмяРеквизита, ТипРеквизита, ЗаголовокРеквизита = "", Путь = "",
							СохраняемыеДанные = Ложь, РодительЭлемента = "", ИмяЭлемента = "") Экспорт

	СтруктураРеквизита = Новый Структура;
	СтруктураРеквизита.Вставить("ИмяРеквизита", ИмяРеквизита);
	
	Если ЗначениеЗаполнено(ТипРеквизита) Тогда
		СтруктураРеквизита.Вставить("ТипРеквизита", ТипРеквизита);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаголовокРеквизита) Тогда
		СтруктураРеквизита.Вставить("ЗаголовокРеквизита", ЗаголовокРеквизита);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Путь) Тогда
		СтруктураРеквизита.Вставить("Путь", Путь);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СохраняемыеДанные) Тогда
		СтруктураРеквизита.Вставить("СохраняемыеДанные", СохраняемыеДанные);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РодительЭлемента) Тогда
		СтруктураРеквизита.Вставить("РодительЭлемента", РодительЭлемента);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяЭлемента) Тогда
		СтруктураРеквизита.Вставить("ИмяЭлемента", ИмяЭлемента);
	КонецЕсли;
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить(СтруктураРеквизита);
	
	ДобавитьРеквизитыФормы(Форма, МассивРеквизитов);
								
КонецПроцедуры 

// Добавляет новые реквизиты формы
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  МассивРеквизитов  - Массив структур - содержит:
//     *ИмяРеквизита  - Строка - имя нового реквизита формы
//     *ТипРеквизита  - ОписаниеТипов - тип реквизита. По умолчанию строка неограниченной длины
//     *ЗаголовокРеквизита  - Строка - отображаемый текст реквизита. Не обязательный
//     *Путь  - Строка  - путь к создаваемому реквизиту. Не включает имя реквизита. Не обязательный
//     *СохраняемыеДанные  - Булево  - если реквизит содержит сохраняемые данные. По умолчанию Ложь
//     *РодительЭлемента  - Строка - имя родителя элемента формы,
//	   *ИмяЭлемента  - Строка - если заполнен параметр РодительЭлемента, то дополнительно можно указать имя элемента формы.
//							По умолчанию именем будет ИмяРеквизита
//
Процедура ДобавитьРеквизитыФормы(Форма, МассивРеквизитов) Экспорт

	ДобавляемыеРеквизиты 	= Новый Массив;
	РеквизитыДляРазмещения 	= Новый Массив;
	
	Для каждого ОписаниеРеквизита Из МассивРеквизитов Цикл
		
		ИмяРеквизита = ОписаниеРеквизита.ИмяРеквизита;
		
		Если ОписаниеРеквизита.Свойство("ТипРеквизита") Тогда
			ТипРеквизита = ОписаниеРеквизита.ТипРеквизита;	
		Иначе
			ТипРеквизита = Новый ОписаниеТипов("Строка");
		КонецЕсли;
		
		ЗаголовокРеквизита = "";
		
		Если ОписаниеРеквизита.Свойство("ЗаголовокРеквизита") Тогда
			ЗаголовокРеквизита = ОписаниеРеквизита.ЗаголовокРеквизита;	
		КонецЕсли;
		
		Путь = "";	
		
		Если ОписаниеРеквизита.Свойство("Путь") Тогда
			Путь = ОписаниеРеквизита.Путь;	
		КонецЕсли;
		
		СохраняемыеДанные = Ложь;	
		
		Если ОписаниеРеквизита.Свойство("СохраняемыеДанные") Тогда
			СохраняемыеДанные = ОписаниеРеквизита.СохраняемыеДанные;	
		КонецЕсли;
		
		РеквизитФормы = Новый РеквизитФормы(ИмяРеквизита, ТипРеквизита, Путь, ЗаголовокРеквизита, СохраняемыеДанные);
		
		ДобавляемыеРеквизиты.Добавить(РеквизитФормы);
		
		//+ Дополнительное размещение реквизитов на форме
		Если ОписаниеРеквизита.Свойство("РодительЭлемента") Тогда
		
			СтруктураЭлемента = Новый Структура;
			СтруктураЭлемента.Вставить("ИмяГруппы", ОписаниеРеквизита.РодительЭлемента);
			
			Если ОписаниеРеквизита.Свойство("Путь") Тогда
				Шаблон = "%1.%2";
				ПутьКДанным = СтрШаблон(Шаблон, ОписаниеРеквизита.Путь, ИмяРеквизита); 	
			Иначе
				ПутьКДанным = ИмяРеквизита;
			КонецЕсли;
			
			СтруктураЭлемента.Вставить("ПутьКДанным", ПутьКДанным);
			
			ИмяЭлемента = ИмяРеквизита;
			
			Если ОписаниеРеквизита.Свойство("ИмяЭлемента") Тогда
				ИмяЭлемента = ОписаниеРеквизита.ИмяЭлемента;	
			КонецЕсли;
			
			СтруктураРеквизитов = Новый Структура;
			СтруктураРеквизитов.Вставить(ИмяЭлемента, СтруктураЭлемента);
			
			РеквизитыДляРазмещения.Добавить(СтруктураРеквизитов);
		
		КонецЕсли;
		//- Дополнительное размещение реквизитов на форме
	
	КонецЦикла;
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	РазместитьРеквизитыНаФорме(Форма, РеквизитыДляРазмещения);
								
КонецПроцедуры

// Добавляет в дерево элементов формы существующие реквизиты объекта и формы
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  МассивРеквизитов  - Массив структур - содержит:
//     * Имя  - Имя добавляемого реквизита
//     * Значение - Структура - содержит (все свойства не обязательные):
//        ** ИмяГруппы 			- Строка - имя элемента родителя
//        ** ПутьКДанным		- Строка - путь к данным. Если не указано, то будет Объект.<ИмяРеквизита>
//        ** ВидПоляФормы		- ВидПоляФормы - вид поля формы. По умолчанию ПолеВвода
//        ** Видимость 			- Булево - значение свойства Видимость
//        ** ТолькоПросмотр 	- Булево - значение свойства ТолькоПросмотр
//        ** Доступность 		- Булево - значение свойства Доступность
//        ** ПоместитьПеред		- Строка - имя элемента, перед которым необходимо разместить
//        ** ОбработкаСобытий 	- Массив структур - содержит:
//           *** Событие 	- Строка - имя события элемента
//           *** Действие 	- Строка - имя процедуры исполнителя события
//
Процедура РазместитьРеквизитыНаФорме(Форма, МассивРеквизитов) Экспорт

	Для каждого ТекРеквизит Из МассивРеквизитов Цикл
		
		ИмяРеквизита 		= ТекРеквизит.Имя;
		ПараметрыРеквизита 	= ТекРеквизит.Значение;
				
		Если ПараметрыРеквизита.Свойство("ИмяГруппы") Тогда
			ЭлементРодитель = Форма.Элементы[ПараметрыРеквизита.ИмяГруппы];	
		Иначе
			ЭлементРодитель = Форма;
		КонецЕсли;
		
		Элемент = Форма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ЭлементРодитель);
				
		Если ПараметрыРеквизита.Свойство("ПутьКДанным") Тогда
			Элемент.ПутьКДанным = ПараметрыРеквизита.ПутьКДанным;
		Иначе 
			Элемент.ПутьКДанным = "Объект." + ИмяРеквизита;
		КонецЕсли; 
		
		Если ПараметрыРеквизита.Свойство("ВидПоляФормы") Тогда		
			Элемент.Вид = ПараметрыРеквизита.ВидПоляФормы;	
		Иначе
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
		КонецЕсли;                               	
		
		Если ПараметрыРеквизита.Свойство("Видимость") Тогда
			Элемент.Видимость = ПараметрыРеквизита.Видимость;	
		КонецЕсли; 		
		
		Если ПараметрыРеквизита.Свойство("ТолькоПросмотр") Тогда
			Элемент.ТолькоПросмотр = ПараметрыРеквизита.ТолькоПросмотр;	
		КонецЕсли; 		
		
		Если ПараметрыРеквизита.Свойство("Доступность") Тогда
			Элемент.Доступность = ПараметрыРеквизита.Доступность;	
		КонецЕсли; 		
				
		Если ПараметрыРеквизита.Свойство("ПоместитьПеред") Тогда
			Форма.Элементы.Переместить(Элемент, ЭлементРодитель, Форма.Элементы[ПараметрыРеквизита.ПоместитьПеред]);	
		КонецЕсли; 		
		
		//--- обработчики событий
		Если ПараметрыРеквизита.Свойство("ОбработкаСобытий")
			И ТипЗнч(ПараметрыРеквизита.ОбработкаСобытий) = Тип("Массив") Тогда
			
			Для каждого ТекСобытие Из ПараметрыРеквизита.ОбработкаСобытий Цикл
				Элемент.УстановитьДействие(ТекСобытие.Событие, ТекСобытие.Действие);		
			КонецЦикла; 			
			
		КонецЕсли; 
		
	КонецЦикла; 	
	
КонецПроцедуры

// Добавляет в дерево элементов формы существующие реквизиты объекта и формы
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  Имя  - Имя добавляемого реквизита
//  ИмяГруппы 			- Строка - имя элемента родителя
//  ПутьКДанным		- Строка - путь к данным. Если не указано, то будет Объект.<ИмяРеквизита>
//  ВидПоляФормы		- ВидПоляФормы - вид поля формы. По умолчанию ПолеВвода
//  Видимость 			- Булево - значение свойства Видимость
//  ТолькоПросмотр 	- Булево - значение свойства ТолькоПросмотр
//  Доступность 		- Булево - значение свойства Доступность
//  ПоместитьПеред		- Строка - имя элемента, перед которым необходимо разместить
//  ОбработкаСобытий 	- Массив структур - содержит:
//   * Событие 	- Строка - имя события элемента
//   * Действие 	- Строка - имя процедуры исполнителя события 
//  ТипЭлемента     - Поле формы или например Таблица формы, по умолчанию тип поле формы
//
Процедура РазместитьРеквизитНаФорме(Форма, Имя, ИмяГруппы = "", ПутьКДанным = "", ПутьКДаннымПодвала = "", ПВидПоляФормы = неопределено, Видимость = Истина,
									ТолькоПросмотр = Ложь, Доступность = Истина, ПоместитьПеред = "", ОбработкаСобытий = неопределено, Заголовок = "") Экспорт
		
	УстановитьПривилегированныйРежим(Истина);		
	Если ЗначениеЗаполнено(ИмяГруппы) Тогда
		ЭлементРодитель = Форма.Элементы[ИмяГруппы];	
	Иначе
		ЭлементРодитель = Форма;
	КонецЕсли;
		
	Элемент = Форма.Элементы.Добавить(Имя, Тип("ПолеФормы"), ЭлементРодитель);
	
	Если ЗначениеЗаполнено(Заголовок) Тогда
		Элемент.Заголовок = Заголовок;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПутьКДанным) Тогда
		Элемент.ПутьКДанным = ПутьКДанным;
	Иначе 
		Элемент.ПутьКДанным = "Объект." + Имя;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ПутьКДаннымПодвала) Тогда
		Элемент.ПутьКДаннымПодвала = ПутьКДаннымПодвала;	
	КонецЕсли;
	
	Если ПВидПоляФормы <> неопределено Тогда		
		Элемент.Вид = ПВидПоляФормы;	
	Иначе
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
	КонецЕсли;                               	
	
	Если ЗначениеЗаполнено(Видимость) Тогда
		Элемент.Видимость = Видимость;	
	КонецЕсли; 		
	
	Если ЗначениеЗаполнено(ТолькоПросмотр) Тогда
		Элемент.ТолькоПросмотр = ТолькоПросмотр;	
	КонецЕсли; 		
	
	Если ЗначениеЗаполнено(Доступность) Тогда
		Элемент.Доступность = Доступность;	
	КонецЕсли; 		
			
	Если ЗначениеЗаполнено(ПоместитьПеред) Тогда
		Форма.Элементы.Переместить(Элемент, ЭлементРодитель, Форма.Элементы[ПоместитьПеред]);	
	КонецЕсли; 		
	
	//--- обработчики событий
	Если ОбработкаСобытий <> неопределено
		И ТипЗнч(ОбработкаСобытий) = Тип("Массив") Тогда
		
		Для каждого ТекСобытие Из ОбработкаСобытий Цикл
			Элемент.УстановитьДействие(ТекСобытие.Событие, ТекСобытие.Действие);		
		КонецЦикла; 			
		
	КонецЕсли;  	
	
КонецПроцедуры

// Устанавливает обработчик события для элемента формы
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  ИмяЭлемента  - Строка - имя элемента формы
//
//  Событие  - Строка - имя события элемента
//
//  Действие  - Строка - имя процедуры исполнителя события
//
Процедура УстановитьСобытиеЭлементаФормы(Форма, ИмяЭлемента, Событие, Действие) Экспорт

	Элемент = Форма.Элементы[ИмяЭлемента];
	Элемент.УстановитьДействие(Событие, Действие);		

КонецПроцедуры

// Добавляет в дерево элементов формы новую группу
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  ИмяГруппы  - Строка - имя новой группы
//
//  РодительГруппы  - Строка - родитель группы. Не обязательно
//
//  ВидГруппы  - ВидГруппыФормы - вид группы. По умолчанию ОбычнаяГруппа
//
//  Группировка  - ГруппировкаПодчиненныхЭлементовФормы  - вариант группировки. По умолчанию ГоризонтальнаяЕслиВозможно
//
//  ОтображатьЗаголовок  - Булево - значение свойства ОтображатьЗаголовок группы. По умолчанию Ложь
//
//  Заголовок  - Строка - заголовок группы. По умолчанию заголовок пустой
//
Процедура ДобавитьГруппуНаФорму(Форма, ИмяГруппы, РодительГруппы = "",
								ВидГруппы = Неопределено,
								Группировка = Неопределено,
								ОтображатьЗаголовок = Ложь,
								Заголовок = Неопределено,
								Объединенная = Истина,
								ПоместитьПеред = "") Экспорт

	Если НЕ ПустаяСтрока(РодительГруппы) Тогда
		ЭлементРодитель = Форма.Элементы[РодительГруппы];	
	Иначе
		ЭлементРодитель = Форма;
	КонецЕсли;
	
	ГруппаФормы = Форма.Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), ЭлементРодитель);
	
	ГруппаФормы.Вид 				= ?(ВидГруппы = Неопределено, ВидГруппыФормы.ОбычнаяГруппа, ВидГруппы);
	ГруппаФормы.Группировка 		= ?(Группировка = Неопределено,
										ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно,
										Группировка);
	ГруппаФормы.ОтображатьЗаголовок = ОтображатьЗаголовок;
	ГруппаФормы.Заголовок = Заголовок;
	Если ВидГруппы = ВидГруппыФормы.ОбычнаяГруппа Тогда
		ГруппаФормы.Объединенная = Объединенная; 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоместитьПеред) Тогда
		Форма.Элементы.Переместить(ГруппаФормы, Форма.Элементы[РодительГруппы], Форма.Элементы[ПоместитьПеред]);	
	КонецЕсли;
	
КонецПроцедуры

// Добавляет в дерево элементов формы существующие реквизиты объекта и формы
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  Имя  - Имя добавляемого реквизита
//  ИмяГруппы 			- Строка - имя элемента родителя
//  ПутьКДанным		- Строка - путь к данным. Если не указано, то будет Объект.<ИмяРеквизита>
//  ВидПоляФормы		- ВидПоляФормы - вид поля формы. По умолчанию ПолеВвода
//  Видимость 			- Булево - значение свойства Видимость
//  ТолькоПросмотр 	- Булево - значение свойства ТолькоПросмотр
//  Доступность 		- Булево - значение свойства Доступность
//  ПоместитьПеред		- Строка - имя элемента, перед которым необходимо разместить
//  ОбработкаСобытий 	- Массив структур - содержит:
//   * Событие 	- Строка - имя события элемента
//   * Действие 	- Строка - имя процедуры исполнителя события 
//  ТипЭлемента     - Поле формы или например Таблица формы, по умолчанию тип поле формы
//
Процедура РазместитьТаблицуНаФорме(Форма, Имя, ИмяГруппы = "", ПутьКДанным = "", Видимость = Истина, ТолькоПросмотр = Ложь, 
							Доступность = Истина, ПоместитьПеред = "", ОбработкаСобытий = неопределено, Подвал = Ложь) Экспорт

				
		Если ЗначениеЗаполнено(ИмяГруппы) Тогда
			ЭлементРодитель = Форма.Элементы[ИмяГруппы];	
		Иначе
			ЭлементРодитель = Форма;
		КонецЕсли;
		
		
		Элемент = Форма.Элементы.Добавить(Имя, Тип("ТаблицаФормы"), ЭлементРодитель);
				
		Если ЗначениеЗаполнено(ПутьКДанным) Тогда
			Элемент.ПутьКДанным = ПутьКДанным;
		Иначе 
			Элемент.ПутьКДанным = "Объект." + Имя;
		КонецЕсли;                               	
		
		Если ЗначениеЗаполнено(Видимость) Тогда
			Элемент.Видимость = Видимость;	
		КонецЕсли; 		
		
		Если ЗначениеЗаполнено(ТолькоПросмотр) Тогда
			Элемент.ТолькоПросмотр = ТолькоПросмотр;	
		КонецЕсли; 		
		
		Если ЗначениеЗаполнено(Доступность) Тогда
			Элемент.Доступность = Доступность;	
		КонецЕсли; 		
				
		Если ЗначениеЗаполнено(ПоместитьПеред) Тогда
			Форма.Элементы.Переместить(Элемент, ЭлементРодитель, Форма.Элементы[ПоместитьПеред]);	
		КонецЕсли; 		
		
		Элемент.Подвал = Подвал;
		
		//--- обработчики событий
		Если ОбработкаСобытий <> неопределено
			И ТипЗнч(ОбработкаСобытий) = Тип("Массив") Тогда
			
			Для каждого ТекСобытие Из ОбработкаСобытий Цикл
				Элемент.УстановитьДействие(ТекСобытие.Событие, ТекСобытие.Действие);		
			КонецЦикла; 			
			
		КонецЕсли; 
		
	//КонецЦикла; 	
	
КонецПроцедуры

Процедура СозданиеДинамическогоСписка(
	Форма,                                      //Тип форма -  Форма документа
	ИмяСписка = "Список", 						//тип строка - имя будущего списка на форме и реквизита
	ТекстЗапроса = "", 							//тип строка - запрос, если он не указан, необходимо указать таблицу
	МассивКолонок,                  			//тип массив - массив создаваемых колонок, значения тип строка. Пример: "Д,ДоговораКонтрагента" значит будет создана колонка
												//				с заголовком "Д" и колонкой списка "ДоговораКонтрагента". Если указать просто "ДоговораКонтрагента", 
												//				заголовок будет идентичен заголовку по умолчанию типа "Договор контрагента".
	СписокДействий = Неопределено,  			//типа структура - структура содержит действия (свойства) динамического списка, можно указать только те которые необходимы.
												//				пример: СписокДействий = Новый Структура("Выбор,ПриАктивизацииСтроки","СписокВыбор","СписокПриАктивизацииСтроки")
	ТаблицаСписка = "",							//тип строка - содержит имя основной таблицы, пример: "Документ.РеализацияТоваровУслуг"	
	ДобавитьВ = "",                 			//тип строка - имя элемента на который будет размещен список, если пустое, тогда добавляется на форму
	ВставитьПеред = "",             			//тип строка - имя элемента перед которым будет размещен список, если пустое, будет просто добавлен в конец
	СвояКоманднаяПанель = ЛОЖЬ,     			//тип булево - если ИСТИНА, скрывает стандартную панель и создает свою пустую для будущего наполнения ИмяСписка+"КоманднаяПанель2"
	ПараметрыЗапроса = Неопределено) Экспорт 	//тип структура - содержит перечень параметров, если они используются в запросе.
	
	//Защита от дурака
	Если ТекстЗапроса = "" И ТаблицаСписка = "" Тогда Сообщить("Ошибка формирования динамического списка, укажите запрос или таблицу"); Возврат; КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	//Создаем свою командную панель, тот случай когда я не нашел способа снять галочку "Автозаполнение"
	Если СвояКоманднаяПанель Тогда
		Если ВставитьПеред = "" Тогда
			ГруппаДинамическогоСписка  = Элементы.Добавить("Группа" + ИмяСписка + "CоСвоейКоманднойПанелью",Тип("ГруппаФормы"),?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ]));
		Иначе
			ГруппаДинамическогоСписка  = Элементы.Вставить("Группа" + ИмяСписка + "CоСвоейКоманднойПанелью",Тип("ГруппаФормы"),?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ]),Форма.Элементы[ВставитьПеред]);			
		КонецЕсли;
		ГруппаДинамическогоСписка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаДинамическогоСписка.ОтображатьЗаголовок = Ложь;
		ГруппаДинамическогоСписка.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаДинамическогоСписка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		КоманднаяПанельСписка  = Элементы.Добавить(ИмяСписка + "КоманднаяПанель2",Тип("ГруппаФормы"),ГруппаДинамическогоСписка);
		КоманднаяПанельСписка.Вид = ВидГруппыФормы.КоманднаяПанель;			
	КонецЕсли;
									
	//Создаем реквизит формы
	ТипыРеквизита = Новый Массив;                             
	ТипыРеквизита.Добавить(Тип("ДинамическийСписок"));
	ОписаниеТиповДляРеквизита = Новый ОписаниеТипов(ТипыРеквизита); 
	ДинамическийСписок = Новый РеквизитФормы(ИмяСписка, ОписаниеТиповДляРеквизита,,"",ЛОЖЬ); //Имя реквизита
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(ДинамическийСписок);        
	
	//Задаем свойства реквизиту
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);        
	РеквизитДинамическийСписок = Форма[ИмяСписка]; //Имя реквизита
	Если ТекстЗапроса = "" Тогда
		РеквизитДинамическийСписок.ПроизвольныйЗапрос = ЛОЖЬ;
		РеквизитДинамическийСписок.ОсновнаяТаблица = ТаблицаСписка;
	Иначе
		РеквизитДинамическийСписок.ПроизвольныйЗапрос = ИСТИНА;
		РеквизитДинамическийСписок.ТекстЗапроса = ТекстЗапроса;
		Если ТаблицаСписка <> "" Тогда РеквизитДинамическийСписок.ОсновнаяТаблица = ТаблицаСписка; КонецЕсли;		
	КонецЕсли;
	
	//Заполняем параметры если они были указаны
	Если ПараметрыЗапроса <> Неопределено Тогда
		Для Каждого Параметра из ПараметрыЗапроса Цикл
			РеквизитДинамическийСписок.Параметры.УстановитьЗначениеПараметра(Параметра.Ключ,Параметра.Значение);	
		КонецЦикла;		 
	КонецЕсли;
	
	//Размещаем реквизит на форме
	Если ЛОЖЬ
		ИЛИ ВставитьПеред = "" 
		ИЛИ СвояКоманднаяПанель //Если своя командная панель тогда нет логики уже в параметре ВставитьПеред
		Тогда
		ТаблицаФормы = Элементы.Добавить(ИмяСписка,Тип("ТаблицаФормы"),?(СвояКоманднаяПанель,ГруппаДинамическогоСписка,?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ])));
	Иначе
		ТаблицаФормы = Элементы.Вставить(ИмяСписка,Тип("ТаблицаФормы"),?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ]),Форма.Элементы[ВставитьПеред]);	
	КонецЕсли;		
	ТаблицаФормы.ПутьКДанным = ИмяСписка; //Имя реквизита 
	
	//Если своя панель тогда скрываем стандартную
	Если СвояКоманднаяПанель Тогда
		Элементы[ИмяСписка].ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	КонецЕсли;

	//Создание колонок на основание МассивКолонок
	Для Каждого Элемента Из МассивКолонок Цикл
		ПараметрыКолонки = СтрЗаменить(Элемента,",",Символы.ПС);
		Если СтрЧислоСтрок(ПараметрыКолонки) > 1 Тогда
			Заголовок = СтрПолучитьСтроку(ПараметрыКолонки, 1);
			ИмяКолонки = СтрПолучитьСтроку(ПараметрыКолонки, 2);
		Иначе
			Заголовок = "";
			ИмяКолонки = ПараметрыКолонки; 
		КонецЕсли;	
		НоваяКолонкаТаблицы = Элементы.Добавить(ИмяСписка + ИмяКолонки, Тип("ПолеФормы"), ТаблицаФормы);
		Если Заголовок <> "" Тогда НоваяКолонкаТаблицы.Заголовок = Заголовок; КонецЕсли;
		НоваяКолонкаТаблицы.ПутьКДанным = ИмяСписка + "." + ИмяКолонки; 	
	КонецЦикла;
	
	//Задаем действия (События) на основание СписокДействий, если он определен
	Если СписокДействий <> Неопределено Тогда 	
		ПереченьСвойств = "ПриИзменении
						|Выбор
						|ПриАктивизацииСтроки
						|ВыборЗначения
						|ПриАктивизацииПоля
						|ПриАктивизацииЯчейки
						|ПередНачаломДобавления
						|ПередНачаломИзменения
						|ПередУдалением
						|ПриНачалеРедактирования
						|ПередОкончаниемРедактирования
						|ПриОкончанииРедактирования
						|ОбработкаВыбора
						|ПередРазворачиванием
						|ПередСворачиванием
						|ПослеУдаления
						|ПриСменеТекущегоРодителя
						|ОбработкаЗаписиНового
						|ПриСохраненииПользовательскихНастроекНаСервере
						|ПередЗагрузкойПользовательскихНастроекНаСервере
						|ПриЗагрузкеПользовательскихНастроекНаСервере
						|ПриОбновленииСоставаПользовательскихНастроекНаСервере
						|ОбработкаЗапросаОбновления
						|ПриПолученииДанныхНаСервере
						|НачалоПеретаскивания
						|ПроверкаПеретаскивания
						|ОкончаниеПеретаскивания
						|Перетаскивание";
		Для Счетчик = 1 по 28 Цикл
			ИмяСвойства = СтрПолучитьСтроку(ПереченьСвойств, Счетчик);
			Элементы[ИмяСписка].УстановитьДействие(ИмяСвойства,?(СписокДействий.Свойство(ИмяСвойства),СписокДействий[ИмяСвойства],""));
		КонецЦикла;
	КонецЕсли;	

КонецПроцедуры 

// Изменяет свойства элементов формы
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - изменяемая форма
//
//  ИмяЭлемента  - Строка - имя элемента формы
//
//  ИмяСвойства  - Строка - имя свойства элемента
//
//  ЗначениеСвойства  - Произвольный - значение свойства элемента
//
Процедура ИзменитьСвойствоЭлементаФормы(Форма, ИмяЭлемента, ИмяСвойства, ЗначениеСвойства) Экспорт

	Элемент = Форма.Элементы[ИмяЭлемента];
	Элемент[ИмяСвойства] = ЗначениеСвойства;
	
КонецПроцедуры

// Функция - Создать декорацию формы надпись
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения - 
//  Родитель	 - ГруппаФормы - 
//  Заголовок	 - Строка - 
//  ИмяПоля		 - Строка - 
// 
// Возвращаемое значение:
//   - ДекорацияФормы 
//
Функция СоздатьДекорациюФормыНадпись(Форма, Родитель = Неопределено, Заголовок = "", ИмяПоля = "ИмяПоля") Экспорт 

	Если НЕ Форма.Элементы.Найти(ИмяПоля) = Неопределено Тогда
		Возврат Форма.Элементы[ИмяПоля];
	КонецЕсли;
	
	//Декорация надпись
	НовыйЭлемент = Форма.Элементы.Добавить(ИмяПоля, Тип("ДекорацияФормы"), ?(Родитель = Неопределено, Форма, Форма.Элементы[Родитель]));
	НовыйЭлемент.Вид = ВидДекорацииФормы.Надпись;
	НовыйЭлемент.Заголовок = Заголовок;	
	     
	Возврат НовыйЭлемент;
	
КонецФункции 
#КонецОбласти


Процедура СоздатьРеквизит(Форма, ПараметрыСоздания) Экспорт
	Если Не ТипЗнч(ПараметрыСоздания)	= Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	НовыйРеквизит			= Новый РеквизитФормы(ПараметрыСоздания.Имя,	ПараметрыСоздания.ОписаниеТипов); 
	
	Если ПараметрыСоздания.Свойство("ПроизвольныйЗапрос") Тогда
		// динамический список
		РеквизитФормы		= Форма[НовыйРеквизит.Имя];
		РеквизитФормы.ПроизвольныйЗапрос		= ПараметрыСоздания.ПроизвольныйЗапрос;
		
		Если ПараметрыСоздания.ПроизвольныйЗапрос Тогда
			РеквизитФормы.ТекстЗапроса			= ПараметрыСоздания.ТекстЗапроса;
		КонецЕсли;

		Если ПараметрыСоздания.Свойство("ОсновнаяТаблица") Тогда
			РеквизитФормы.ОсновнаяТаблица		= ПараметрыСоздания.ОсновнаяТаблица;
		КонецЕсли;
		
		Если ПараметрыСоздания.Свойство("ПараметрыЗапроса") Тогда
			ПараметрыЗапроса					= ПараметрыСоздания.ПараметрыЗапроса;
			Для Каждого Параметра из ПараметрыЗапроса Цикл
				РеквизитФормы.Параметры.УстановитьЗначениеПараметра(Параметра.Ключ,	Параметра.Значение);
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура СоздатьГруппу(Форма, ПараметрыСоздания, ИмяЭлементаДляРазмещения) Экспорт
	Если Не ТипЗнч(ПараметрыСоздания)	= Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаРазмещения			= Форма.Элементы[ИмяЭлементаДляРазмещения];
	ЭлементыФормы				= Форма.Элементы;
	
	Группа						= ЭлементыФормы.Добавить(ПараметрыСоздания.Имя,	Тип("ГруппаФормы"),	ГруппаРазмещения);
	Группа.Вид					= ПараметрыСоздания.Вид;
	Группа.Отображение			= ПараметрыСоздания.Отображение;
	Группа.Заголовок			= ПараметрыСоздания.Заголовок;
	Группа.Группировка			= ПараметрыСоздания.Группировка;
	Группа.ОтображатьЗаголовок	= ПараметрыСоздания.ОтображатьЗаголовок;
	
	Если ПараметрыСоздания.Свойство("Видимость") Тогда
		Группа.Видимость		= ПараметрыСоздания.Видимость;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("ЗаголовокСвернутогоОтображения") Тогда
		Группа.ЗаголовокСвернутогоОтображения	= ПараметрыСоздания.ЗаголовокСвернутогоОтображения;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("Поведение") Тогда
		Группа.Поведение		= ПараметрыСоздания.Поведение;
	КонецЕсли;
		
	Если ПараметрыСоздания.Свойство("ОтображениеУправления") Тогда
		Группа.ОтображениеУправления	= ПараметрыСоздания.ОтображениеУправления;
	КонецЕсли;
КонецПроцедуры

Процедура ПолеФормы(Форма, ПараметрыСоздания, ИмяЭлементаДляРазмещения) Экспорт
	Если Не ТипЗнч(ПараметрыСоздания)	= Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаРазмещения					= Форма.Элементы[ИмяЭлементаДляРазмещения];
	ЭлементыФормы						= Форма.Элементы;
		
	НовыйЭлемент						= ЭлементыФормы.Добавить(ПараметрыСоздания.Имя,	Тип("ПолеФормы"),	ГруппаРазмещения);
	НовыйЭлемент.Вид					= ПараметрыСоздания.Вид;
	НовыйЭлемент.ПутьКДанным			= ПараметрыСоздания.ПутьКДанным;
	НовыйЭлемент.Заголовок				= ПараметрыСоздания.Заголовок;
	НовыйЭлемент.ПоложениеЗаголовка		= ПараметрыСоздания.ПоложениеЗаголовка;
	
	Если ПараметрыСоздания.Свойство("РастягиватьПоВертикали") Тогда
		НовыйЭлемент.РастягиватьПоВертикали		= ПараметрыСоздания.РастягиватьПоВертикали;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("РастягиватьПоГоризонтали") Тогда
		НовыйЭлемент.РастягиватьПоГоризонтали	= ПараметрыСоздания.РастягиватьПоГоризонтали;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("Высота") Тогда
		НовыйЭлемент.Высота				= ПараметрыСоздания.Высота;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("Ширина") Тогда
		НовыйЭлемент.Ширина				= ПараметрыСоздания.Ширина;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("Видимость") Тогда
		НовыйЭлемент.Видимость			= ПараметрыСоздания.Видимость;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("Доступность") Тогда
		НовыйЭлемент.Доступность		= ПараметрыСоздания.Доступность;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("ТолькоПросмотр") Тогда
		НовыйЭлемент.ТолькоПросмотр		= ПараметрыСоздания.ТолькоПросмотр;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("МногострочныйРежим") Тогда
		НовыйЭлемент.МногострочныйРежим	= ПараметрыСоздания.МногострочныйРежим;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("ВидПереключателя") Тогда
		НовыйЭлемент.ВидПереключателя	= ПараметрыСоздания.ВидПереключателя;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("КоличествоКолонок") Тогда
		НовыйЭлемент.КоличествоКолонок	= ПараметрыСоздания.КоличествоКолонок;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("ОдинаковаяШиринаКолонок") Тогда
		НовыйЭлемент.ОдинаковаяШиринаКолонок	= ПараметрыСоздания.ОдинаковаяШиринаКолонок;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("СписокВыбора") Тогда
		Для Каждого эСпискаВыбора Из ПараметрыСоздания.СписокВыбора Цикл
			НовыйЭлемент.СписокВыбора.Добавить(эСпискаВыбора);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("Действие") Тогда
		НовыйЭлемент.УстановитьДействие("ПриИзменении",	ПараметрыСоздания.Действие);
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьКнопку(Форма, ПараметрыСоздания, ИмяЭлементаДляРазмещения) Экспорт
	Если Не ТипЗнч(ПараметрыСоздания)	= Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаРазмещения			= Форма.Элементы[ИмяЭлементаДляРазмещения];
	ЭлементыФормы				= Форма.Элементы;
	Команды						= Форма.Команды;
	
	НоваяКоманда    		 	= Команды.Добавить(ПараметрыСоздания.Имя);
	НоваяКоманда.Действие		= ПараметрыСоздания.Действие;
	НоваяКоманда.Отображение	= ПараметрыСоздания.Отображение;
	
	НоваяКнопка		 			= ЭлементыФормы.Добавить(ПараметрыСоздания.Имя, Тип("КнопкаФормы"), ГруппаРазмещения);
	НоваяКнопка.ИмяКоманды		= ПараметрыСоздания.Имя;
	НоваяКнопка.Отображение		= ПараметрыСоздания.Отображение;
	
	Если ПараметрыСоздания.Свойство("Заголовок") Тогда
		НоваяКнопка.Заголовок	= ПараметрыСоздания.Заголовок;
	КонецЕсли;
	
	Если ПараметрыСоздания.Свойство("Картинка") Тогда
		НоваяКнопка.Картинка	= ПараметрыСоздания.Картинка;
	КонецЕсли;
КонецПроцедуры

Процедура СоздатьТаблицуФормы(Форма, ПараметрыСоздания, ИмяЭлементаДляРазмещения) Экспорт
	Если Не ТипЗнч(ПараметрыСоздания)	= Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаРазмещения					= Форма.Элементы[ИмяЭлементаДляРазмещения];
	ЭлементыФормы						= Форма.Элементы;
	
	НовыйЭлемент						= ЭлементыФормы.Добавить(ПараметрыСоздания.Имя,	Тип("ТаблицаФормы"), ГруппаРазмещения);
	
	НовыйЭлемент.ПутьКДанным			= ПараметрыСоздания.ПутьКДанным;
	
	Если ПараметрыСоздания.Свойство("СтруктураКолонок") Тогда
		СтруктураКолонок				= ПараметрыСоздания.СтруктураКолонок;
		Для Каждого тКолонка Из СтруктураКолонок Цикл
			ИмяКолонки					= тКолонка.Ключ;
			НоваяКолонкаТаблицы			= ЭлементыФормы.Вставить(ИмяКолонки,	Тип("ПолеФормы"),	НовыйЭлемент);
			НоваяКолонкаТаблицы.Вид		= ВидПоляФормы.ПолеВвода;// ?(ЭтоДС,ВидПоляФормы.ПолеНадписи,ВидПоляФормы.ПолеВвода);
			Если Не тКолонка.Значение	= "" Тогда
				НоваяКолонкаТаблицы.Заголовок	= тКолонка.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
