///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события при изменении номера объекта.
// Обработчик предназначен для вычисления базового номера объекта в случае,
// когда стандартным способом получить базовый номер без потери информации нельзя.
// Обработчик вызывается только для случая, когда обрабатываемые номера и коды объектов
// были сформированы нестандартным образом, не в формате номеров и кодов БСП.
//
// Параметры:
//  Объект - ДокументОбъект
//         - БизнесПроцессОбъект
//         - ЗадачаОбъект - объект данных,
//           для которого необходимо определить базовый номер.
//  Номер - Строка - номер текущего объекта, из которого необходимо извлечь базовый номер.
//  БазовыйНомер - Строка - базовый номер объекта. 
//           Под базовым номером объекта подразумевается номер объекта
//           за вычетом всех префиксов (префикса ИБ, префикса организации,
//           префикса подразделения, пользовательского префикса и пр).
//  СтандартнаяОбработка - Булево - флаг стандартной обработки. Значения по умолчанию Истина.
//           Если в обработчике установить данному параметру значение Ложь,
//           то стандартная обработка выполнена не будет.
//           Стандартная обработка получает базовый код справа до первого нечислового символа.
//           Например, для кода "АА00005/12/368" стандартная обработка вернет "368".
//           Однако базовый код для объекта будет равен "5/12/368".
//
Процедура ПриИзмененииНомера(Объект, Знач Номер, БазовыйНомер, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Обработчик события при изменении кода объекта.
// Обработчик предназначен для вычисления базового кода объекта в случае,
// когда стандартным способом получить базовый код без потери информации нельзя.
// Обработчик вызывается только для случая, когда обрабатываемые номера и коды объектов
// были сформированы нестандартным образом, не в формате номеров и кодов БСП.
//
// Параметры:
//  Объект - СправочникОбъект
//         - ПланВидовХарактеристикОбъект - объект данных,
//           для которого необходимо определить базовый код.
//  Код - Строка - код текущего объекта, из которого необходимо извлечь базовый код.
//  БазовыйКод - Строка - базовый код объекта. Под базовым кодом объекта подразумевается код объекта
//           за вычетом всех префиксов (префикса ИБ, префикса организации,
//           префикса подразделения, пользовательского префикса и пр).
//  СтандартнаяОбработка - Булево - флаг стандартной обработки. Значения по умолчанию Истина.
//           Если в обработчике установить данному параметру значение Ложь,
//           то стандартная обработка выполнена не будет.
//           Стандартная обработка получает базовый код справа до первого нечислового символа.
//           Например, для кода "АА00005/12/368" стандартная обработка вернет "368".
//           Однако базовый код для объекта будет равен "5/12/368".
//
Процедура ПриИзмененииКода(Объект, Знач Код, БазовыйКод, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// В процедуре необходимо заполнить параметр "Объекты" для тех объектов метаданных,
// для которых ссылка на организацию располагается в реквизите с именем отличным от стандартного имени "Организация".
//
// Параметры:
//  Объекты - ТаблицаЗначений:
//     * Объект - ОбъектМетаданных - объект метаданных, для которого указывается реквизит,
//                содержащий ссылку на организацию.
//     * Реквизит - Строка - имя реквизита, который содержит ссылку на организацию.
//
Процедура ПолучитьПрефиксообразующиеРеквизиты(Объекты) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
