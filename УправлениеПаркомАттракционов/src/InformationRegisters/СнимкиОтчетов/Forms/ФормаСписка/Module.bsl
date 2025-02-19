///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Пользователь", Пользователь) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр(
			"ru = 'Список доступен только из формы отчета или панели отчетов'"), , , , Отказ);
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("ИмяСправочникаВариантыОтчетов", ИмяСправочникаВариантыОтчетов);
	
	ЗаполнитьСнимкиОтчетов();
	
#Если НЕ МобильныйАвтономныйСервер Тогда
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.ПоказатьВсеСнимкиОтчетов.Видимость = Истина;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

#Если МобильныйКлиент Тогда
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
	Элементы.ГруппаКнопокМобильныйКлиент.Видимость = Истина;
	Элементы.СнимкиОтчетов.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	
	Если ОсновнойСерверДоступен() = Ложь Тогда
		Элементы.ГруппаСохранитьСнимкиОтчетов.Доступность = Ложь;
		Элементы.СнимкиОтчетовСохранитьСнимокОтчета.Доступность = Ложь;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
 
&НаКлиенте
Процедура ПоказатьВсеСнимкиОтчетовПриИзменении(Элемент)
	
	ЗаполнитьСнимкиОтчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого СтрокаОтчет Из СнимкиОтчетов Цикл
		СтрокаОтчет.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для Каждого СтрокаОтчет Из СнимкиОтчетов Цикл
		СтрокаОтчет.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСнимкиОтчетов(Команда)
	
	ИдентификаторыСтрок = Новый Массив;
	Для Каждого СтрокаОтчет Из СнимкиОтчетов Цикл
		Если СтрокаОтчет.Пометка Тогда
			ИдентификаторыСтрок.Добавить(СтрокаОтчет.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
	Если ИдентификаторыСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОбновленияСнимковОтчетов", ЭтотОбъект);
	ДлительнаяОперация = Неопределено;
	ПараметрыОжидания = Неопределено;
	
#Если МобильныйКлиент Тогда
	Выполнить("ДлительнаяОперация = ОбновитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок)");
	Выполнить("ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект)");
	Выполнить("ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания)");
#Иначе
	ДлительнаяОперация = ОбновитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
#КонецЕсли
	
КонецПроцедуры


#Если НЕ МобильныйАвтономныйСервер Тогда

&НаСервере
Функция ОбновитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок)
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Пользователь", Пользователь);
	ПараметрыЗаполнения.Вставить("ИмяСправочникаВариантыОтчетов", ИмяСправочникаВариантыОтчетов);
	
	СнимкиОтчетовПользователя = СнимкиОтчетов.Выгрузить(, "Пользователь, Отчет, Вариант, ХешПользовательскойНастройки");
	СнимкиОтчетовПользователя.Очистить();
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		СтрокаОтчет = СнимкиОтчетов.НайтиПоИдентификатору(ИдентификаторСтроки);
		НоваяСтрока = СнимкиОтчетовПользователя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОтчет);
	КонецЦикла;
	ПараметрыЗаполнения.Вставить("СнимкиОтчетов", СнимкиОтчетовПользователя);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление снимков отчетов пользователя'");
	ПараметрыВыполнения.УточнениеОшибки = НСтр("ru = 'Не удалось обновить снимки отчетов по причине:'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"РегистрыСведений.СнимкиОтчетов.ОбновитьСнимкиОтчетовПользователя",
		ПараметрыЗаполнения, ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

#КонецЕсли

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ПослеОбновленияСнимковОтчетов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
#Если МобильныйКлиент Тогда
		Выполнить("СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(Результат.ИнформацияОбОшибке)");
#Иначе
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(Результат.ИнформацияОбОшибке);
#КонецЕсли
		Возврат;
	КонецЕсли;

	ТекстОповещения = НСтр("ru = 'Снимки отчетов обновлены.'");
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление снимков завершено'"), , ТекстОповещения);
	
	ЗаполнитьСнимкиОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСнимкиОтчетов(Команда)
	
	ИдентификаторыСтрок = Новый Массив;
	Для Каждого СтрокаОтчет Из СнимкиОтчетов Цикл
		Если СтрокаОтчет.Пометка Тогда
			ИдентификаторыСтрок.Добавить(СтрокаОтчет.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;

	Если ИдентификаторыСтрок.Количество() > 0 Тогда
		УдалитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УдалитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок)
	
	Блокировка = Новый БлокировкаДанных();
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СнимкиОтчетов");
	ЭлементБлокировки.УстановитьЗначение("Пользователь", Пользователь);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
			СтрокаОтчет = СнимкиОтчетов.НайтиПоИдентификатору(ИдентификаторСтроки);

			УдаляемыеЗаписи = РегистрыСведений.СнимкиОтчетов.СоздатьНаборЗаписей();
			УдаляемыеЗаписи.Отбор.Пользователь.Установить(СтрокаОтчет.Пользователь);
			УдаляемыеЗаписи.Отбор.Отчет.Установить(СтрокаОтчет.Отчет);
			УдаляемыеЗаписи.Отбор.Вариант.Установить(СтрокаОтчет.Вариант);
			УдаляемыеЗаписи.Отбор.ХешПользовательскойНастройки.Установить(СтрокаОтчет.ХешПользовательскойНастройки);
			УдаляемыеЗаписи.Записать();
		КонецЦикла;
			
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСнимокОтчета(Команда)
	
	СтруктураЗаписи = Новый Структура("Пользователь,Отчет,Вариант,ХешПользовательскойНастройки,ДатаАктуальности");
	
	СтрокаОтчет = Элементы.СнимкиОтчетов.ТекущиеДанные;
	ЗаполнитьЗначенияСвойств(СтруктураЗаписи, СтрокаОтчет);
	
	ОткрытьФорму("РегистрСведений.СнимкиОтчетов.ФормаЗаписи",
		Новый Структура("СтруктураЗаписи", СтруктураЗаписи), ЭтотОбъект, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСнимокОтчета(Команда)
	
	ИдентификаторыСтрок = Новый Массив;
	ИдентификаторыСтрок.Добавить(Элементы.СнимкиОтчетов.ТекущаяСтрока);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОбновленияСнимковОтчетов", ЭтотОбъект);
	ДлительнаяОперация = Неопределено;
	ПараметрыОжидания = Неопределено;
	
#Если МобильныйКлиент Тогда
	Выполнить("ДлительнаяОперация = ОбновитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок)");
	Выполнить("ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект)");
	Выполнить("ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания)");
#Иначе
	ДлительнаяОперация = ОбновитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСнимкиОтчетов

&НаКлиенте
Процедура СписокСнимковОтчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаОтчет = СнимкиОтчетов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	СтрокаОтчет.Пометка = Не СтрокаОтчет.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура СнимкиОтчетовПередУдалением(Элемент, Отказ)
	
	ИдентификаторыСтрок = Новый Массив;
	ИдентификаторыСтрок.Добавить(Элементы.СнимкиОтчетов.ТекущаяСтрока);
	
	УдалитьСнимкиОтчетовНаСервере(ИдентификаторыСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СнимкиОтчетовПользователь.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоказатьВсеСнимкиОтчетов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСнимкиОтчетов()

	СнимкиОтчетов.Загрузить(РегистрыСведений.СнимкиОтчетов.СнимкиОтчетовПользователя(
		?(ПоказатьВсеСнимкиОтчетов, Неопределено, Пользователь), ИмяСправочникаВариантыОтчетов));

КонецПроцедуры

#КонецОбласти