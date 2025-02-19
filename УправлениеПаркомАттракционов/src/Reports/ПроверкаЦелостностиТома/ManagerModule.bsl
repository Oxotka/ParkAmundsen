///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = НСтр("ru = 'Проверка целостности тома.'");
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.ОпределитьОбъектыСКомандамиОтчетов.
Процедура ПриОпределенииОбъектовСКомандамиОтчетов(Объекты) Экспорт
	
	Объекты.Добавить(Метаданные.Справочники.ТомаХраненияФайлов);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подготавливает таблицу проверки наличия файлов тома.
// 
// Параметры:
//  Том - СправочникСсылка.ТомаХраненияФайлов - том
// 
// Возвращаемое значение:
//   см. РаботаСФайламиВТомахСлужебный.ЛишниеФайлыНаДиске
// 
Функция ФайлыНаДиске(Том) Экспорт
	ТаблицаФайловНаДиске = РаботаСФайламиВТомахСлужебный.ЛишниеФайлыНаДиске();
		
	ПутьКТому = РаботаСФайламиВТомахСлужебный.ПолныйПутьТома(Том);
	
	ПроверяемыеФайлы = НайтиФайлы(ПутьКТому, "*", Истина);
	Для Каждого Файл Из ПроверяемыеФайлы Цикл
		Если Не Файл.ЭтоФайл() Тогда 
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаФайловНаДиске.Добавить();
		НоваяСтрока.Имя = Файл.Имя;
		НоваяСтрока.ИмяБезРасширения = Файл.ИмяБезРасширения;
		НоваяСтрока.ПолноеИмя = Файл.ПолноеИмя;
		НоваяСтрока.Путь = Файл.Путь;
		НоваяСтрока.Расширение = Файл.Расширение;
		НоваяСтрока.СтатусПроверки = "ЛишнийФайлВТоме";
		НоваяСтрока.Количество = 1;
		НоваяСтрока.Том = Том;
	КонецЦикла;
	
	РаботаСФайламиВТомахСлужебный.ЗаполнитьЛишниеФайлы(ТаблицаФайловНаДиске, Том);
	Возврат ТаблицаФайловНаДиске;
КонецФункции

// Восстанавливает связи файлов в томе.
// 
// Параметры:
//  Том - СправочникСсылка.ТомаХраненияФайлов
// 
// Возвращаемое значение:
//  Структура:
//   * Обработано - Число
//   * Всего - Число
//
Функция ВосстановитьФайлы(Том) Экспорт
	ТаблицаФайловНаДиске = ФайлыНаДиске(Том);
	
	ПутьКТому = РаботаСФайламиВТомахСлужебный.ПолныйПутьТома(Том);
	
	Отбор = Новый Структура("СтатусПроверки", "ВозможноИсправление");
	ФайлыДляВосстановления = ТаблицаФайловНаДиске.Скопировать(Отбор, "Файл,ПолноеИмя");
	Возврат РаботаСФайламиВТомахСлужебный.УстановитьПутиХраненияФайлов(ФайлыДляВосстановления, ПутьКТому);
КонецФункции

#КонецОбласти

#КонецЕсли