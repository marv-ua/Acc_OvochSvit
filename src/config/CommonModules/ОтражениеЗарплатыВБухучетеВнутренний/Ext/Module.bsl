﻿////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в бухучете
// Переопределяемое в пределах библиотеки поведение
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура СоздатьВТБухучетНачислений(Организация, ПериодРегистрации, МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеБазовый.СоздатьВТБухучетНачислений(Организация, ПериодРегистрации, МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура СоздатьВТБухучетВзносов(Организация, ПериодРегистрации, МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеБазовый.СоздатьВТБухучетВзносов(Организация, ПериодРегистрации, МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура СоздатьВТБухучетЕСВ(Организация, ПериодРегистрации, МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеБазовый.СоздатьВТБухучетЕСВ(Организация, ПериодРегистрации, МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура СоздатьВТБухучетНДФЛ(Организация, ПериодРегистрации, МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеБазовый.СоздатьВТБухучетНДФЛ(Организация, ПериодРегистрации, МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц);

КонецПроцедуры
