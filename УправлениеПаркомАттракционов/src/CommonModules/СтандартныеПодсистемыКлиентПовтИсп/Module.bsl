///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	ПроверитьЗапускПрограммыЗавершен(Истина);
	
	ПараметрыПриЗапускеПрограммы = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПриЗапускеПрограммы"];
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПолученныеПараметрыКлиента", Неопределено);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
		И ТипЗнч(ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.Вставить("ПолученныеПараметрыКлиента", ОбщегоНазначенияКлиент.СкопироватьРекурсивно(
			ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента));
	КонецЕсли;
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
		Параметры.Вставить("ПропуститьОчисткуСкрытияРабочегоСтола");
	КонецЕсли;
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ОпцииИнтерфейса")
	   И ТипЗнч(Параметры.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.ПолученныеПараметрыКлиента.Вставить("ОпцииИнтерфейса");
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыРаботыКлиентаНаСервере(Параметры);
	
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
		И ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента <> Неопределено
		И Не ПараметрыПриЗапускеПрограммы.Свойство("ОпцииИнтерфейса") Тогда
		
		ПараметрыПриЗапускеПрограммы.Вставить("ОпцииИнтерфейса", ПараметрыКлиента.ОпцииИнтерфейса);
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыКлиента(ПараметрыКлиента);
	
	// Обновление состояния скрытия рабочего стола на клиенте по состоянию на сервере.
	СтандартныеПодсистемыКлиент.СкрытьРабочийСтолПриНачалеРаботыСистемы(
		Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы, Истина);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().
Функция ПараметрыРаботыКлиента() Экспорт
	
	ПроверитьЗапускПрограммыЗавершен();
	
	СвойстваКлиента = Новый Структура;
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыРаботыКлиентаНаСервере(СвойстваКлиента);
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента(СвойстваКлиента);
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыКлиента(ПараметрыКлиента);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

// См. СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

Процедура ПроверитьЗапускПрограммыЗавершен(ТолькоПередНачаломРаботыСистемы = Ложь)
	
	ИмяПараметра = "СтандартныеПодсистемы.ЗапускПрограммыЗавершен";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Возникла непредвиденная ситуация при запуске приложения.
			           |
			           |Техническая информация о проблеме:
			           |Недопустимый вызов %1 при запуске приложения.
			           |Первой процедурой, которая вызывается из обработчика события %2, должна быть процедура %3.'"),
			"СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента",
			"ПередНачаломРаботыСистемы", 
			"СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ТолькоПередНачаломРаботыСистемы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СтандартныеПодсистемыКлиент.ЗапускПрограммыЗавершен() Тогда
		Если СтандартныеПодсистемыКлиент.ОтключенаЛогикаНачалаРаботыСистемы() Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Действие недоступно при запуске с параметром %1.'"),
				"ОтключитьЛогикуНачалаРаботыСистемы");
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Возникла непредвиденная ситуация при запуске приложения.
			           |
			           |Техническая информация о проблеме:
			           |Недопустимый вызов %1 при запуске приложения. Следует вызывать %2, пока процедура %3 еще не завершена.
			           |Вызванные процедуры (в обратном порядке):
			           |%4'"),
				"СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента", 
				"СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске",
				"СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы",
				СтандартныеПодсистемыКлиент.ВызванныеПроцедурыПередНачаломРаботыСистемы());
		КонецЕсли;
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для справочника ИдентификаторыОбъектовМетаданных.

// См. Справочники.ИдентификаторыОбъектовМетаданных.ПредставлениеИдентификатора
Функция ПредставлениеИдентификатораОбъектаМетаданных(Ссылка) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.ПредставлениеИдентификатораОбъектаМетаданных(Ссылка);
	
КонецФункции

#КонецОбласти
