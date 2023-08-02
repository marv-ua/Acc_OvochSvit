﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПерваяСтрока = "
	| В обработке существует возможность перехватывать запросы в процессе отладки.
	| Для того, чтобы нужный запрос открылся со всеми параметрами и временными таблицами, необходимо в отладчике после установки всех параметров вызвать ""Вычислить выражение"" со строкой вида:";
	ВтораяСтрока = "ВнешниеОбработки.Создать(""D:\Запросник8_2.epf"",Ложь).Дамп(Запрос)";
	ТретьяСтрока = "
	| где указать путь к обработке относительно сервера 1С и отлаживаемый запрос
	| После этого в форме обработки нажать кнопку ""Загрузить дамп"" - запрос со всеми параметрами появится в новой строке дерева запросов.
	| Если необходимо произвести отладку без продолжения выполнения кода, то можно открыть еще один сеанс 1С:Предприятия, пока текущий сеанс стоит на точке останова, и загружать дамп запроса в нём.";
	
	СисИнфо = Новый СистемнаяИнформация;
	Если Лев(СисИнфо.ВерсияПриложения,3) = "8.2" Тогда
		ТекстСправки.Добавить(ПерваяСтрока+Символы.ПС);
		ТекстСправки.Добавить(ВтораяСтрока+Символы.ПС);
		ТекстСправки.Добавить(ТретьяСтрока+Символы.ПС);
	Иначе
		ТекстСправки.Добавить(ПерваяСтрока);
		ТекстСправки.Добавить(,Тип("ПереводСтрокиФорматированногоДокумента"));
		ВтораяСтрока = ТекстСправки.Добавить(ВтораяСтрока);
		ВтораяСтрока.ЦветТекста = WebЦвета.Синий;
		ТекстСправки.Добавить(,Тип("ПереводСтрокиФорматированногоДокумента"));
		ТекстСправки.Добавить(ТретьяСтрока);
	КонецЕсли;
	
	СтрокаВызоваОбработки = Параметры.ПутьОбработки;
КонецПроцедуры
