﻿
Процедура ОформитьКнопкиКоманднойПанелиФормы(ЭтаФорма) Экспорт
	
	Возврат; // пока не применяем
	
	СтруктураНастроек = Новый Структура();
	СтруктураНастроек.Вставить("ШрифтКнопок", 				Новый Шрифт(, ));
	СтруктураНастроек.Вставить("ШрифтКнопкиПоУмолчанию", 	Новый Шрифт(, , Истина));
	СтруктураНастроек.Вставить("ЦветФонаКнопкиПоУмолчанию", WebЦвета.ЦветМорскойВолныТемный);// Новый Цвет(90, 167, 231));//WebЦвета.НасыщенноНебесноГолубой);
	СтруктураНастроек.Вставить("ЦветФонаКнопки", 			Новый Цвет(160, 210, 155));//WebЦвета.ЦветМорскойВолныТемный);
	СтруктураНастроек.Вставить("ЦветРамки",					WebЦвета.СеребристоСерый);//Новый Цвет(178, 178, 178));
	СтруктураНастроек.Вставить("ЦветБелый",					WebЦвета.Белый);
	СтруктураНастроек.Вставить("ЦветСиний",					WebЦвета.Синий);
	
	МассивКнопок 	= Новый Массив;
	//ТипКнопки1 		= Тип("КнопкаКоманднойПанели");
	ТипКнопки 		= Тип("КнопкаФормы");
	
	//Для Каждого ТекЭлемент Из ЭтаФорма.Элементы Цикл
	//	ТипЭлемента = ТипЗнч(ТекЭлемент); 
	//	Если ТипЭлемента = ТипКнопки Тогда
	//		ОформитьКнопку(ТекЭлемент, СтруктураНастроек);
	//	КонецЕсли;
	//КонецЦикла;
	ОформитьЭлементыКоманднойПанели(ЭтаФорма.Элементы.ФормаКоманднаяПанель, СтруктураНастроек);
	Если ЭтаФорма.Элементы.Найти("ПанельФормы") <> Неопределено Тогда
		ОформитьЭлементыКоманднойПанели(ЭтаФорма.Элементы.ПанельФормы, СтруктураНастроек);
	КонецЕсли;
КонецПроцедуры

Процедура ОформитьЭлементыКоманднойПанели(ПанельИлиГруппа, СтруктураНастроек)
	
	Для Каждого ТекКнопка Из ПанельИлиГруппа.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(ТекКнопка) = Тип("ГруппаФормы") Тогда
			//ТекКнопка.Шрифт 		= СтруктураНастроек.ШрифтКнопок;
			ОформитьЭлементыКоманднойПанели(ТекКнопка, СтруктураНастроек);
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ТекКнопка) <> Тип("КнопкаФормы") Тогда
			Продолжить;
		КонецЕсли;
		
		ОформитьКнопку(ТекКнопка, СтруктураНастроек);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОформитьКнопку(ТекКнопка, СтруктураНастроек)
	
	Если ТекКнопка.КнопкаПоУмолчанию = Истина Тогда
		ТекКнопка.Шрифт 		= СтруктураНастроек.ШрифтКнопкиПоУмолчанию;
		ТекКнопка.ЦветФона 		= СтруктураНастроек.ЦветФонаКнопкиПоУмолчанию;
		ТекКнопка.ЦветТекста 	= СтруктураНастроек.ЦветБелый;//WebЦвета.ТемноГрифельноСерый; //СтруктураНастроек.ЦветБелый;
		ТекКнопка.ЦветРамки 	= СтруктураНастроек.ЦветФонаКнопкиПоУмолчанию;//WebЦвета.ЦветМорскойВолныТемный;//СветлоНебесноГолубой;
	Иначе
		ТекКнопка.Шрифт 		= СтруктураНастроек.ШрифтКнопок;
		//ТекКнопка.ЦветФона 		= СтруктураНастроек.ЦветФонаКнопки;
		//ТекКнопка.ЦветТекста 	= СтруктураНастроек.ЦветБелый;
		//ТекКнопка.ЦветТекста 	= WebЦвета.СинийСоСтальнымОттенком;//ГолубойСоСтальнымОттенком;//WebЦвета.ЦианТемный;//90, 167, 231  WebЦвета.ТемноГрифельноСерый;//СтруктураНастроек.ЦветБелый;
		//ТекКнопка.ЦветРамки 		= ТекКнопка.ЦветФона;//СтруктураНастроек.ЦветРамки;
		//ТекКнопка.ОтображениеФигуры = ОтображениеФигурыКнопки.ПриАктивности;
	КонецЕсли;
	
КонецПроцедуры      

Функция ВычислитьНаСервере(ИмяПеречисления) Экспорт
	Возврат Вычислить(ИмяПеречисления);
КонецФункции

Процедура ЗаполнитьПутиКДаннымДляРедактированияКода(ЭтаФорма) Экспорт
	
	Если ТипЗнч(ЭтаФорма.ДополнительныеСвойства) <> Тип("Структура") Тогда
		ЭтаФорма.ДополнительныеСвойства = Новый Структура();
	КонецЕсли;
	
	ЭтаФорма.ДополнительныеСвойства.Вставить("ПутьКДанным", Новый Соответствие);
	
	ПропускатьЭлементы = Новый Структура("КодЯзыка, Код, Кодировка");
	СтруктураРеквизитовКода = Новый Структура();
	
	Для Каждого ТекЭлемент Из ЭтаФорма.Элементы Цикл
		
		Если СтрНайти(ТекЭлемент.Имя, "Код") > 0 и ТипЗнч(ТекЭлемент) = Тип("ПолеФормы") и НЕ ПропускатьЭлементы.Свойство(ТекЭлемент.Имя) и (ТекЭлемент.Вид = ВидПоляФормы.ПолеВвода или ТекЭлемент.Вид = ВидПоляФормы.ПолеТекстовогоДокумента) Тогда
			
			ПутьКДанным = ЭтаФорма.Элементы[ТекЭлемент.Имя].ПутьКДанным;
			ЭтаФорма.ДополнительныеСвойства.ПутьКДанным.Вставить(ТекЭлемент.Имя, ПутьКДанным);
			
			ТекЭлемент.Шрифт 						= Новый Шрифт("Consolas", 9);
			ТекЭлемент.КнопкаОткрытия 				= Истина;
			ТекЭлемент.МногострочныйРежим 			= СтрНайти(ТекЭлемент.Имя,"НеРастягивать") = 0;
			ТекЭлемент.РасширенноеРедактирование 	= Истина;
			
			ТекЭлемент.УстановитьДействие("Открытие", "РедактироватьКод");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
