///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список справочников, доступных для загрузки с помощью подсистемы "Загрузка данных из файла".
// Если справочник нужно исключить из списка загружаемых, то его следует удалить из таблицы.
//
// Параметры:
//  ЗагружаемыеСправочники - ТаблицаЗначений - список справочников, в которые возможна загрузка данных:
//      * ПолноеИмя          - Строка - полное имя справочника (как в метаданных).
//      * Представление      - Строка - представление справочника в списке выбора.
//      * ПрикладнаяЗагрузка - Булево - если Истина, значит справочник использует собственный алгоритм загрузки и
//                                      в модуле менеджера справочника определены функции.
//
// Пример:
// 
//  // Собственный алгоритм загрузки в справочник Номенклатуры.
//	Сведения = ЗагружаемыеСправочники.Добавить();
//	Сведения.ПолноеИмя          = Метаданные.Справочники.Номенклатура.ПолноеИмя();
//	Сведения.Представление      = Метаданные.Справочники.Номенклатура.Представление();
//	Сведения.ПрикладнаяЗагрузка = Истина;
//	
//  //Загрузка в классификатор валюты запрещена.
//  СтрокаТаблицы = ЗагружаемыеСправочники.Найти(Метаданные.Справочники.Валюты.ПолноеИмя(), "ПолноеИмя");
//  Если СтрокаТаблицы <> Неопределено Тогда 
//    ЗагружаемыеСправочники.Удалить(СтрокаТаблицы);
//  КонецЕсли;
//
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти