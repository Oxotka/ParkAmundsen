///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		ИзмененныеОбъекты = ВыгрузитьКолонку("Объект");
		ИзмененныеОбъекты = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ИзмененныеОбъекты);

		Если ИзмененныеОбъекты.Количество() = 0 Тогда
			Если ЗначениеЗаполнено(Отбор.Объект.Значение) Тогда
				ИзмененныеОбъекты.Добавить(Отбор.Объект.Значение);
			Иначе
				ИзмененныеОбъекты = ВсеОбъекты();
			КонецЕсли;
		КонецЕсли;
		
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		УстановитьПривилегированныйРежим(Истина);
		
		Для Каждого Ссылка Из ИзмененныеОбъекты Цикл
			ВсеЗаписи = Выгрузить();
			ЗаписиОбъекта = ВсеЗаписи.НайтиСтроки(Новый Структура("Объект", Ссылка));
			
			ИзмененныйОбъект = Ссылка.ПолучитьОбъект();
			Если ИзмененныйОбъект <> Неопределено Тогда
				ИзмененныйОбъект.ДополнительныеСвойства.Вставить("ЗаписываемыеДополнительныеСведения", ЗаписиОбъекта);
				МодульВерсионированиеОбъектов.ЗаписатьВерсиюОбъекта(ИзмененныйОбъект);
			КонецЕсли;
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВсеОбъекты()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДополнительныеСведения.Объект КАК Объект
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|СГРУППИРОВАТЬ ПО
	|	ДополнительныеСведения.Объект";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект");
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли