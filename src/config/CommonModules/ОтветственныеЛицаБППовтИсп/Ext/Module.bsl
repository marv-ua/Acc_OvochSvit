﻿////////////////////////////////////////////////////////////////////////////////
// Ответственные лица: процедуры и функции для работы с ответственным лицами.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция возвращает структуру со сведениями об ответственных лицах.
//
// Параметры:
//  Организация - организация, для которой нужно определить ответственных лиц.
//	ДатаСреза - дата со временем, на которые необходимо определить сведения.
//	Подразделение - подразделение, для которого необходимо определить ответственных лиц.
//
// Возвращаемое значение:
//	Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида
//		"Руководитель" - СправочникСсылка.ФизическиеЛица
//		"РуководительФИО" - структура (Фамилия, Имя, Отчество, Представление)
//		"РуководительПредставление" - строка, Фамилия И.О.
//		"РуководительДолжность" - СправочникСсылка.Должности
//		"РуководительДолжностьПредставление" - строка, название должности
//
Функция ОтветственныеЛица(Организация, ДатаСреза, Подразделение = Неопределено) Экспорт

	Возврат ОтветственныеЛицаБППереопределяемый.ОтветственныеЛица(Организация, ДатаСреза, Подразделение);

КонецФункции

// Функция возвращает массив дат измения ответственных лиц.
//
Функция ДатыИзмененияОтветственныхЛицОрганизаций(Организация) Экспорт

	Возврат ОтветственныеЛицаБППереопределяемый.ДатыИзмененияОтветственныхЛицОрганизаций(Организация);

КонецФункции

// Функция возвращает структуру со сведениями об ответственных лицах.
//
// Параметры:
//  Организация - организация, для которой нужно определить ответственных лиц.
//	ДатаСреза - дата со временем, на которые необходимо определить сведения.
//	Подразделение - подразделение, для которого необходимо определить ответственных лиц.
//
// Возвращаемое значение:
//	Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида
//		"Руководитель" - СправочникСсылка.ФизическиеЛица
//		"РуководительФИО" - структура (Фамилия, Имя, Отчество, Представление)
//		"РуководительПредставление" - строка, Фамилия И.О.
//		"РуководительДолжность" - СправочникСсылка.Должности
//		"РуководительДолжностьПредставление" - строка, название должности
//
Функция ОтветственныеЛицаКонтрагента(Организация, ДатаСреза) Экспорт

	Возврат ОтветственныеЛицаБППереопределяемый.ОтветственныеЛицаКонтрагента(Организация, ДатаСреза);

КонецФункции

// Функция возвращает структуру со сведениями об ответственных лицах.
//
// Параметры:
//  Организация - организация, для которой нужно определить ответственных лиц.
//	ДатаСреза - дата со временем, на которые необходимо определить сведения.
//	Подразделение - подразделение, для которого необходимо определить ответственных лиц.
//
// Возвращаемое значение:
//	Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида
//		"Руководитель" - СправочникСсылка.ФизическиеЛица
//		"РуководительФИО" - структура (Фамилия, Имя, Отчество, Представление)
//		"РуководительПредставление" - строка, Фамилия И.О.
//		"РуководительДолжность" - СправочникСсылка.Должности
//		"РуководительДолжностьПредставление" - строка, название должности
//
Функция ОтветственныеЛицаОбособленногоПодразделения(ОбособленноеПодразделениеОрганизации, ДатаСреза) Экспорт

	Возврат ОтветственныеЛицаБППереопределяемый.ОтветственныеЛицаОбособленногоПодразделения(ОбособленноеПодразделениеОрганизации, ДатаСреза);

КонецФункции

// Функция возвращает массив дат измения ответственных лиц контрагентов.
//
Функция ДатыИзмененияОтветственныхЛицКонтрагента(Контрагент) Экспорт

	Возврат ОтветственныеЛицаБППереопределяемый.ДатыИзмененияОтветственныхЛицКонтрагента(Контрагент);

КонецФункции

// Функция возвращает структуру со сведениями об ответственных лицах.
//
// Параметры:
//  Организация - организация, для которой нужно определить ответственных лиц.
//	ДатаСреза - дата со временем, на которые необходимо определить сведения.
//	Подразделение - подразделение, для которого необходимо определить ответственных лиц.
//
// Возвращаемое значение:
//	Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида
//		"Руководитель" - СправочникСсылка.ФизическиеЛица
//		"РуководительФИО" - структура (Фамилия, Имя, Отчество, Представление)
//		"РуководительПредставление" - строка, Фамилия И.О.
//		"РуководительДолжность" - СправочникСсылка.Должности
//		"РуководительДолжностьПредставление" - строка, название должности
//
Функция ДатыИзмененияОтветственныхЛицОбособленногоПодразделения(ОбособленноеПодразделениеОрганизации) Экспорт

	Возврат ОтветственныеЛицаБППереопределяемый.ДатыИзмененияОтветственныхЛицОбособленногоПодразделения(ОбособленноеПодразделениеОрганизации);

КонецФункции
