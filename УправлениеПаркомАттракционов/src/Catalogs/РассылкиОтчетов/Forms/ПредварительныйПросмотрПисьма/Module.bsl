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

	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
		"ru = 'Предварительный просмотр: %1'"), Параметры.НаименованиеРассылки);

	Если Параметры.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML Тогда
		Элементы.СтраницыТекстПисьма.ТекущаяСтраница = Элементы.СтраницаТекстПисьмаHTML;
	Иначе
		Элементы.СтраницыТекстПисьма.ТекущаяСтраница = Элементы.СтраницаТекстПисьмаОбычныйТекст;
	КонецЕсли;

	Текст = Параметры.Текст;

	Если ЭтоАдресВременногоХранилища(Параметры.АдресКартинокДляHTML) 
		И Параметры.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML Тогда
		КартинкиДляHTML = ПолучитьИзВременногоХранилища(Параметры.АдресКартинокДляHTML);
		Текст = ЗаменитьИдентификаторыКартинокНаПутьКФайлам(Текст, КартинкиДляHTML);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заменяет в тексте HTML ИД картинок вложений на путь к файлам и создает объект документ HTML.
//
// Параметры:
//  ТекстHTML     - Строка - обрабатываемый текст HTML.
//  ТаблицаФайлов - ТаблицаЗначений 
//
// Возвращаемое значение:
//  ДокументHTML   - созданный документ HTML.
//
&НаСервереБезКонтекста
Функция ЗаменитьИдентификаторыКартинокНаПутьКФайлам(ТекстHTML, ТаблицаФайлов)

	ДокументHTML = ОбъектДокументHTMLИзТекстаHTML(ТекстHTML);

	Для каждого ПрисоединенныйФайл Из ТаблицаФайлов Цикл

		Для каждого Картинка Из ДокументHTML.Картинки Цикл

			АтрибутИсточникКартинки = Картинка.Атрибуты.ПолучитьИменованныйЭлемент("src");
			Если АтрибутИсточникКартинки = Неопределено Тогда
				Продолжить;
			КонецЕсли;

			Если СтрЧислоВхождений(АтрибутИсточникКартинки.Значение, ПрисоединенныйФайл.Идентификатор) > 0 Тогда
				
				НовыйАтрибутКартинки = АтрибутИсточникКартинки.КлонироватьУзел(Ложь);
					Если ЭтоАдресВременногоХранилища(ПрисоединенныйФайл.АдресВоВременномХранилище) Тогда
						ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПрисоединенныйФайл.АдресВоВременномХранилище);
						ТекстовоеСодержимое = Base64Строка(ДвоичныеДанные);
						ТекстовоеСодержимое = "data:image/" + Сред(ПрисоединенныйФайл.Расширение, 2) + ";base64,"
						+ Символы.ПС + ТекстовоеСодержимое;
					Иначе
						ТекстовоеСодержимое = "";
					КонецЕсли;

				НовыйАтрибутКартинки.ТекстовоеСодержимое = ТекстовоеСодержимое;
				Картинка.Атрибуты.УстановитьИменованныйЭлемент(НовыйАтрибутКартинки);

				Прервать;

			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	Возврат ТекстHTMLИзОбъектаДокументHTML(ДокументHTML);

КонецФункции

// Получает объект ДокументHTML из текста HTML.
//
// Параметры:
//  ТекстHTML - Строка
//
// Возвращаемое значение:
//   ДокументHTML - созданный документ HTML.
//
&НаСервереБезКонтекста
Функция ОбъектДокументHTMLИзТекстаHTML(ТекстHTML)

	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;

	НовыйТекстHTML = ТекстHTML;
	ПозицияОткрытиеXML = СтрНайти(НовыйТекстHTML,"<?xml");

	Если ПозицияОткрытиеXML > 0 Тогда

		ПозицияЗакрытиеXML = СтрНайти(НовыйТекстHTML,"?>");
		Если ПозицияЗакрытиеXML > 0 Тогда

			НовыйТекстHTML = ЛЕВ(НовыйТекстHTML,ПозицияОткрытиеXML - 1) + ПРАВ(НовыйТекстHTML,СтрДлина(НовыйТекстHTML) - ПозицияЗакрытиеXML -1);

		КонецЕсли;

	КонецЕсли;

	ЧтениеHTML.УстановитьСтроку(ТекстHTML);

	Возврат Построитель.Прочитать(ЧтениеHTML);

КонецФункции

// Получает текст HTML из объекта ДокументHTML.
//
// Параметры:
//  ДокументHTML - ДокументHTML - документ, из которого будет извлекаться текст.
//
// Возвращаемое значение:
//   Строка - текст HTML
//
&НаСервереБезКонтекста
Функция ТекстHTMLИзОбъектаДокументHTML(ДокументHTML)
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML,ЗаписьHTML);
	Возврат ЗаписьHTML.Закрыть();
	
КонецФункции

#КонецОбласти