﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() > 0 Тогда
		Если НЕ ЭтотОбъект.ДополнительныеСвойства.Свойство("ЗаписьОсновногоРабочегоМеста") Тогда
			ЗаполнитьРеквизитОсновноеМесто();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьРеквизитОсновноеМесто()
	
	ТаблицаТекущегоНабора = ЭтотОбъект.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТекущийНабор", ТаблицаТекущегоНабора);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущийНабор.Сотрудник КАК Сотрудник,
	|	ТекущийНабор.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ТекущийНабор.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ТекущийНабор.ТекущаяОрганизация КАК ТекущаяОрганизация,
	|	ТекущийНабор.ТекущееПодразделение КАК ТекущееПодразделение,
	|	ТекущийНабор.ТекущаяДолжность КАК ТекущаяДолжность,
	|	ТекущийНабор.ДатаПриема КАК ДатаПриема,
	|	ТекущийНабор.ДатаУвольнения КАК ДатаУвольнения,
	|	ТекущийНабор.ОсновноеРабочееМестоВОрганизации КАК ОсновноеРабочееМестоВОрганизации,
	|	ТекущийНабор.ТекущийВидЗанятости КАК ТекущийВидЗанятости
	|ПОМЕСТИТЬ ВТТекущийНабор
	|ИЗ
	|	&ТекущийНабор КАК ТекущийНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеКадровыеДанныеСотрудников.Сотрудник,
	|	ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо,
	|	ТекущиеКадровыеДанныеСотрудников.ГоловнаяОрганизация,
	|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация,
	|	ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение,
	|	ТекущиеКадровыеДанныеСотрудников.ТекущаяДолжность,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаПриема,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения,
	|	ТекущиеКадровыеДанныеСотрудников.ОсновноеРабочееМестоВОрганизации,
	|	ТекущиеКадровыеДанныеСотрудников.ТекущийВидЗанятости КАК ТекущийВидЗанятости
	|ПОМЕСТИТЬ ВТДругиеЗаписи
	|ИЗ
	|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТекущийНабор КАК ТекущийНабор
	|		ПО ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = ТекущийНабор.ФизическоеЛицо
	|			И ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = ТекущийНабор.ТекущаяОрганизация
	|			И ТекущиеКадровыеДанныеСотрудников.Сотрудник <> ТекущийНабор.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущийНабор.Сотрудник,
	|	ТекущийНабор.ФизическоеЛицо,
	|	ТекущийНабор.ГоловнаяОрганизация,
	|	ТекущийНабор.ТекущаяОрганизация,
	|	ТекущийНабор.ТекущееПодразделение,
	|	ТекущийНабор.ТекущаяДолжность,
	|	ТекущийНабор.ДатаПриема,
	|	ТекущийНабор.ДатаУвольнения,
	|	ТекущийНабор.ОсновноеРабочееМестоВОрганизации,
	|	ТекущийНабор.ТекущийВидЗанятости
	|ПОМЕСТИТЬ ВТВсеЗаписиНабора
	|ИЗ
	|	ВТТекущийНабор КАК ТекущийНабор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДругиеЗаписи.Сотрудник,
	|	ДругиеЗаписи.ФизическоеЛицо,
	|	ДругиеЗаписи.ГоловнаяОрганизация,
	|	ДругиеЗаписи.ТекущаяОрганизация,
	|	ДругиеЗаписи.ТекущееПодразделение,
	|	ДругиеЗаписи.ТекущаяДолжность,
	|	ДругиеЗаписи.ДатаПриема,
	|	ДругиеЗаписи.ДатаУвольнения,
	|	ДругиеЗаписи.ОсновноеРабочееМестоВОрганизации,
	|	ДругиеЗаписи.ТекущийВидЗанятости
	|ИЗ
	|	ВТДругиеЗаписи КАК ДругиеЗаписи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЗаписиНабора.Сотрудник,
	|	ВсеЗаписиНабора.ФизическоеЛицо,
	|	ВсеЗаписиНабора.ГоловнаяОрганизация,
	|	ВсеЗаписиНабора.ТекущаяОрганизация,
	|	ВсеЗаписиНабора.ТекущееПодразделение,
	|	ВсеЗаписиНабора.ТекущаяДолжность,
	|	ВсеЗаписиНабора.ДатаПриема,
	|	ВсеЗаписиНабора.ДатаУвольнения,
	|	ВсеЗаписиНабора.ОсновноеРабочееМестоВОрганизации,
	|	ВсеЗаписиНабора.ТекущийВидЗанятости
	|ПОМЕСТИТЬ ВТВсеЗаписиРаботающих
	|ИЗ
	|	ВТВсеЗаписиНабора КАК ВсеЗаписиНабора
	|ГДЕ
	|	ВсеЗаписиНабора.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	|	И ВсеЗаписиНабора.ДатаПриема <> ДАТАВРЕМЯ(1, 1, 1)
	|	И ВсеЗаписиНабора.ТекущаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЗаписиНабора.Сотрудник,
	|	ВсеЗаписиНабора.ФизическоеЛицо,
	|	ВсеЗаписиНабора.ГоловнаяОрганизация,
	|	ВсеЗаписиНабора.ТекущаяОрганизация,
	|	ВсеЗаписиНабора.ТекущееПодразделение,
	|	ВсеЗаписиНабора.ТекущаяДолжность,
	|	ВсеЗаписиНабора.ДатаПриема,
	|	ВсеЗаписиНабора.ДатаУвольнения КАК ДатаУвольнения,
	|	ВсеЗаписиНабора.ОсновноеРабочееМестоВОрганизации,
	|	ВсеЗаписиНабора.ТекущийВидЗанятости
	|ПОМЕСТИТЬ ВТЗаписиСовсемУволенных
	|ИЗ
	|	ВТВсеЗаписиНабора КАК ВсеЗаписиНабора
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВсеЗаписиРаботающих КАК ВсеЗаписиРаботающих
	|		ПО ВсеЗаписиНабора.ГоловнаяОрганизация = ВсеЗаписиРаботающих.ГоловнаяОрганизация
	|			И ВсеЗаписиНабора.ФизическоеЛицо = ВсеЗаписиРаботающих.ФизическоеЛицо
	|ГДЕ
	|	ВсеЗаписиРаботающих.Сотрудник ЕСТЬ NULL 
	|	И ВсеЗаписиНабора.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)
	|	И ВсеЗаписиНабора.ДатаПриема <> ДАТАВРЕМЯ(1, 1, 1)
	|	И ВсеЗаписиНабора.ТекущаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиСовсемУволенных.ФизическоеЛицо,
	|	ЗаписиСовсемУволенных.ГоловнаяОрганизация,
	|	МАКСИМУМ(ЗаписиСовсемУволенных.ДатаУвольнения) КАК ДатаУвольнения
	|ПОМЕСТИТЬ ВТЗаписиСовсемУволенныеСМаксимальнойДатойУвольнения
	|ИЗ
	|	ВТЗаписиСовсемУволенных КАК ЗаписиСовсемУволенных
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиСовсемУволенных.ФизическоеЛицо,
	|	ЗаписиСовсемУволенных.ГоловнаяОрганизация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиСовсемУволенных.ФизическоеЛицо,
	|	ЗаписиСовсемУволенных.ГоловнаяОрганизация,
	|	ЗаписиСовсемУволенных.ДатаУвольнения,
	|	МИНИМУМ(ЗаписиСовсемУволенных.ТекущийВидЗанятости.Порядок) КАК ТекущийВидЗанятостиПорядок
	|ПОМЕСТИТЬ ВТСовсемУволенныеСПриоритетом
	|ИЗ
	|	ВТЗаписиСовсемУволенных КАК ЗаписиСовсемУволенных
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаписиСовсемУволенныеСМаксимальнойДатойУвольнения КАК ЗаписиСовсемУволенныеСМаксимальнойДатойУвольнения
	|		ПО ЗаписиСовсемУволенных.ФизическоеЛицо = ЗаписиСовсемУволенныеСМаксимальнойДатойУвольнения.ФизическоеЛицо
	|			И ЗаписиСовсемУволенных.ГоловнаяОрганизация = ЗаписиСовсемУволенныеСМаксимальнойДатойУвольнения.ГоловнаяОрганизация
	|			И ЗаписиСовсемУволенных.ДатаУвольнения = ЗаписиСовсемУволенныеСМаксимальнойДатойУвольнения.ДатаУвольнения
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиСовсемУволенных.ФизическоеЛицо,
	|	ЗаписиСовсемУволенных.ГоловнаяОрганизация,
	|	ЗаписиСовсемУволенных.ДатаУвольнения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЗаписиРаботающих.Сотрудник,
	|	ВсеЗаписиРаботающих.ФизическоеЛицо,
	|	ВсеЗаписиРаботающих.ГоловнаяОрганизация,
	|	ВсеЗаписиРаботающих.ТекущаяОрганизация,
	|	ВсеЗаписиРаботающих.ТекущееПодразделение,
	|	ВсеЗаписиРаботающих.ТекущаяДолжность,
	|	ВсеЗаписиРаботающих.ДатаПриема,
	|	ВсеЗаписиРаботающих.ДатаУвольнения,
	|	ВсеЗаписиРаботающих.ОсновноеРабочееМестоВОрганизации,
	|	ВсеЗаписиРаботающих.ТекущийВидЗанятости
	|ПОМЕСТИТЬ ВТЗаписиКОбработке
	|ИЗ
	|	ВТВсеЗаписиРаботающих КАК ВсеЗаписиРаботающих
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаписиСовсемУволенных.Сотрудник,
	|	ЗаписиСовсемУволенных.ФизическоеЛицо,
	|	ЗаписиСовсемУволенных.ГоловнаяОрганизация,
	|	ЗаписиСовсемУволенных.ТекущаяОрганизация,
	|	ЗаписиСовсемУволенных.ТекущееПодразделение,
	|	ЗаписиСовсемУволенных.ТекущаяДолжность,
	|	ЗаписиСовсемУволенных.ДатаПриема,
	|	ЗаписиСовсемУволенных.ДатаУвольнения,
	|	ЗаписиСовсемУволенных.ОсновноеРабочееМестоВОрганизации,
	|	ЗаписиСовсемУволенных.ТекущийВидЗанятости
	|ИЗ
	|	ВТЗаписиСовсемУволенных КАК ЗаписиСовсемУволенных
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСовсемУволенныеСПриоритетом КАК СовсемУволенныеСПриоритетом
	|		ПО ЗаписиСовсемУволенных.ФизическоеЛицо = СовсемУволенныеСПриоритетом.ФизическоеЛицо
	|			И ЗаписиСовсемУволенных.ГоловнаяОрганизация = СовсемУволенныеСПриоритетом.ГоловнаяОрганизация
	|			И ЗаписиСовсемУволенных.ТекущийВидЗанятости.Порядок = СовсемУволенныеСПриоритетом.ТекущийВидЗанятостиПорядок
	|			И ЗаписиСовсемУволенных.ДатаУвольнения = СовсемУволенныеСПриоритетом.ДатаУвольнения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущаяТарифнаяСтавкаСотрудников.Сотрудник,
	|	ТекущаяТарифнаяСтавкаСотрудников.ФизическоеЛицо,
	|	ТекущаяТарифнаяСтавкаСотрудников.ГоловнаяОрганизация,
	|	ТекущаяТарифнаяСтавкаСотрудников.ТекущаяТарифнаяСтавка
	|ПОМЕСТИТЬ ВТТекущиеТарифныеСтавкиСотрудников
	|ИЗ
	|	РегистрСведений.ТекущаяТарифнаяСтавкаСотрудников КАК ТекущаяТарифнаяСтавкаСотрудников
	|ГДЕ
	|	ТекущаяТарифнаяСтавкаСотрудников.Сотрудник В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				ВсеЗаписиНабора.Сотрудник
	|			ИЗ
	|				ВТВсеЗаписиНабора КАК ВсеЗаписиНабора)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ВсеЗаписиНабора.Сотрудник КАК Справочник.Сотрудники) КАК Сотрудник,
	|	ВсеЗаписиНабора.ФизическоеЛицо,
	|	ВсеЗаписиНабора.ГоловнаяОрганизация,
	|	ВсеЗаписиНабора.ТекущаяОрганизация,
	|	ВсеЗаписиНабора.ТекущееПодразделение,
	|	ВсеЗаписиНабора.ТекущаяДолжность,
	|	ВсеЗаписиНабора.ДатаПриема,
	|	ВсеЗаписиНабора.ДатаУвольнения,
	|	ВсеЗаписиНабора.ОсновноеРабочееМестоВОрганизации,
	|	ВЫРАЗИТЬ(ВсеЗаписиНабора.ТекущийВидЗанятости КАК Перечисление.ВидыЗанятости) КАК ТекущийВидЗанятости,
	|	ЕСТЬNULL(ТекущиеТарифныеСтавкиСотрудников.ТекущаяТарифнаяСтавка, 0) КАК ТекущаяТарифнаяСтавка
	|ПОМЕСТИТЬ ВТВсеЗаписиНабораСТарифнойСтавкой
	|ИЗ
	|	ВТЗаписиКОбработке КАК ВсеЗаписиНабора
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТекущиеТарифныеСтавкиСотрудников КАК ТекущиеТарифныеСтавкиСотрудников
	|		ПО ВсеЗаписиНабора.Сотрудник = ТекущиеТарифныеСтавкиСотрудников.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЗаписиНабораСТарифнойСтавкой.ФизическоеЛицо,
	|	ВсеЗаписиНабораСТарифнойСтавкой.ГоловнаяОрганизация,
	|	МИНИМУМ(ВсеЗаписиНабораСТарифнойСтавкой.ТекущийВидЗанятости.Порядок) КАК СотрудникВидЗанятостиПорядок
	|ПОМЕСТИТЬ ВТЗаписиСПриоритетомВидаЗанятости
	|ИЗ
	|	ВТВсеЗаписиНабораСТарифнойСтавкой КАК ВсеЗаписиНабораСТарифнойСтавкой
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеЗаписиНабораСТарифнойСтавкой.ФизическоеЛицо,
	|	ВсеЗаписиНабораСТарифнойСтавкой.ГоловнаяОрганизация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиСПриоритетомВидаЗанятости.ФизическоеЛицо,
	|	ЗаписиСПриоритетомВидаЗанятости.ГоловнаяОрганизация,
	|	ЗаписиСПриоритетомВидаЗанятости.СотрудникВидЗанятостиПорядок,
	|	МАКСИМУМ(ВсеЗаписиНабораСТарифнойСтавкой.ТекущаяТарифнаяСтавка) КАК ТекущаяТарифнаяСтавка
	|ПОМЕСТИТЬ ВТЗаписиСПриоритетомТарифнойСтавки
	|ИЗ
	|	ВТЗаписиСПриоритетомВидаЗанятости КАК ЗаписиСПриоритетомВидаЗанятости
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВсеЗаписиНабораСТарифнойСтавкой КАК ВсеЗаписиНабораСТарифнойСтавкой
	|		ПО ЗаписиСПриоритетомВидаЗанятости.ФизическоеЛицо = ВсеЗаписиНабораСТарифнойСтавкой.ФизическоеЛицо
	|			И ЗаписиСПриоритетомВидаЗанятости.ГоловнаяОрганизация = ВсеЗаписиНабораСТарифнойСтавкой.ГоловнаяОрганизация
	|			И ЗаписиСПриоритетомВидаЗанятости.СотрудникВидЗанятостиПорядок = ВсеЗаписиНабораСТарифнойСтавкой.ТекущийВидЗанятости.Порядок
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиСПриоритетомВидаЗанятости.ФизическоеЛицо,
	|	ЗаписиСПриоритетомВидаЗанятости.ГоловнаяОрганизация,
	|	ЗаписиСПриоритетомВидаЗанятости.СотрудникВидЗанятостиПорядок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиСПриоритетомТарифнойСтавки.ФизическоеЛицо,
	|	ЗаписиСПриоритетомТарифнойСтавки.ГоловнаяОрганизация,
	|	ЗаписиСПриоритетомТарифнойСтавки.СотрудникВидЗанятостиПорядок,
	|	ЗаписиСПриоритетомТарифнойСтавки.ТекущаяТарифнаяСтавка,
	|	МИНИМУМ(ВсеЗаписиНабораСТарифнойСтавкой.ДатаПриема) КАК ДатаПриема
	|ПОМЕСТИТЬ ВТЗаписиСПриоритетомДатыПриема
	|ИЗ
	|	ВТЗаписиСПриоритетомТарифнойСтавки КАК ЗаписиСПриоритетомТарифнойСтавки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВсеЗаписиНабораСТарифнойСтавкой КАК ВсеЗаписиНабораСТарифнойСтавкой
	|		ПО ЗаписиСПриоритетомТарифнойСтавки.ФизическоеЛицо = ВсеЗаписиНабораСТарифнойСтавкой.ФизическоеЛицо
	|			И ЗаписиСПриоритетомТарифнойСтавки.ГоловнаяОрганизация = ВсеЗаписиНабораСТарифнойСтавкой.ГоловнаяОрганизация
	|			И ЗаписиСПриоритетомТарифнойСтавки.СотрудникВидЗанятостиПорядок = ВсеЗаписиНабораСТарифнойСтавкой.ТекущийВидЗанятости.Порядок
	|			И ЗаписиСПриоритетомТарифнойСтавки.ТекущаяТарифнаяСтавка = ВсеЗаписиНабораСТарифнойСтавкой.ТекущаяТарифнаяСтавка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиСПриоритетомТарифнойСтавки.ФизическоеЛицо,
	|	ЗаписиСПриоритетомТарифнойСтавки.ГоловнаяОрганизация,
	|	ЗаписиСПриоритетомТарифнойСтавки.СотрудникВидЗанятостиПорядок,
	|	ЗаписиСПриоритетомТарифнойСтавки.ТекущаяТарифнаяСтавка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ВсеЗаписиНабораСТарифнойСтавкой.Сотрудник) КАК Сотрудник,
	|	ВсеЗаписиНабораСТарифнойСтавкой.ФизическоеЛицо,
	|	ВсеЗаписиНабораСТарифнойСтавкой.ГоловнаяОрганизация
	|ПОМЕСТИТЬ ВТОсновноеМестоРаботы
	|ИЗ
	|	ВТВсеЗаписиНабораСТарифнойСтавкой КАК ВсеЗаписиНабораСТарифнойСтавкой
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаписиСПриоритетомДатыПриема КАК ЗаписиСПриоритетомДатыПриема
	|		ПО ВсеЗаписиНабораСТарифнойСтавкой.ФизическоеЛицо = ЗаписиСПриоритетомДатыПриема.ФизическоеЛицо
	|			И ВсеЗаписиНабораСТарифнойСтавкой.ГоловнаяОрганизация = ЗаписиСПриоритетомДатыПриема.ГоловнаяОрганизация
	|			И ВсеЗаписиНабораСТарифнойСтавкой.ТекущийВидЗанятости.Порядок = ЗаписиСПриоритетомДатыПриема.СотрудникВидЗанятостиПорядок
	|			И ВсеЗаписиНабораСТарифнойСтавкой.ДатаПриема = ЗаписиСПриоритетомДатыПриема.ДатаПриема
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеЗаписиНабораСТарифнойСтавкой.ГоловнаяОрганизация,
	|	ВсеЗаписиНабораСТарифнойСтавкой.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЗаписиНабора.Сотрудник,
	|	ВсеЗаписиНабора.ФизическоеЛицо,
	|	ВсеЗаписиНабора.ГоловнаяОрганизация,
	|	ВсеЗаписиНабора.ТекущаяОрганизация,
	|	ВсеЗаписиНабора.ТекущееПодразделение,
	|	ВсеЗаписиНабора.ТекущаяДолжность,
	|	ВсеЗаписиНабора.ДатаПриема,
	|	ВсеЗаписиНабора.ДатаУвольнения,
	|	ВсеЗаписиНабора.ТекущийВидЗанятости,
	|	ВЫБОР
	|		КОГДА ОсновноеМестоРаботы.Сотрудник ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОсновноеРабочееМестоВОрганизации
	|ИЗ
	|	ВТВсеЗаписиНабора КАК ВсеЗаписиНабора
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОсновноеМестоРаботы КАК ОсновноеМестоРаботы
	|		ПО ВсеЗаписиНабора.Сотрудник = ОсновноеМестоРаботы.Сотрудник
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ОсновноеМестоРаботы.Сотрудник ЕСТЬ NULL 
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ <> ВсеЗаписиНабора.ОсновноеРабочееМестоВОрганизации";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаСотрудника = ТаблицаТекущегоНабора.Найти(Выборка.Сотрудник, "Сотрудник");
		
		Если СтрокаСотрудника = Неопределено Тогда
			
			Набор = РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.СоздатьНаборЗаписей();
			Набор.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			Набор.ДополнительныеСвойства.Вставить("ЗаписьОсновногоРабочегоМеста", Истина);
			Набор.Записать();
			
		Иначе
			
			СтрокаСотрудника.ОсновноеРабочееМестоВОрганизации = Выборка.ОсновноеРабочееМестоВОрганизации;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЭтотОбъект.Загрузить(ТаблицаТекущегоНабора);
	
КонецПроцедуры

#КонецЕсли
