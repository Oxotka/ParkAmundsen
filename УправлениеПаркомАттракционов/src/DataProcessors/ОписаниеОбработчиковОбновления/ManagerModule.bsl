///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Рассчитывает и заполняет номера очереди для разрабатываемых подсистем,
// а также заполняет переопределенные номера очереди у библиотечных обработчиков.
//
// Параметры:
//  ИтерацииОбновления - Массив из см. ОбновлениеИнформационнойБазыСлужебный.ИтерацияОбновления
//
Процедура ЗаполнитьНомерОчереди(ИтерацииОбновления) Экспорт
	
	ОписаниеОбработчиков = Обработки.ОписаниеОбработчиковОбновления.Создать();
	ОписаниеОбработчиков.ЗаполнитьНомерОчереди(ИтерацииОбновления);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли