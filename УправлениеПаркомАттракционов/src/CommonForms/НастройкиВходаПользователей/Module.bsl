///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаСервере
Перем ТекущиеНастройкиПоЭлементам, ТекущиеЭлементыПоНастройкам;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказатьНастройкиВнешнихПользователей = Параметры.ПоказатьНастройкиВнешнихПользователей;
	ИспользоватьВнешнихПользователей = ВнешниеПользователи.ИспользоватьВнешнихПользователей();
	
	ПредлагаемыеЗначенияНастроек = Новый Структура;
	ПредлагаемыеЗначенияНастроек.Вставить("ПарольДолженОтвечатьТребованиямСложности", Null);
	ПредлагаемыеЗначенияНастроек.Вставить("МинимальнаяДлинаПароля", 8);
	ПредлагаемыеЗначенияНастроек.Вставить("ПарольДолженОтсутствоватьВСпискеЗапрещенных", Null);
	ПредлагаемыеЗначенияНастроек.Вставить("ДействиеПриВходеЕслиТребованиеНеВыполнено", "ПредложитьСменуПароля");
	ПредлагаемыеЗначенияНастроек.Вставить("МаксимальныйСрокДействияПароля", 30);
	ПредлагаемыеЗначенияНастроек.Вставить("МинимальныйСрокДействияПароля", 1);
	ПредлагаемыеЗначенияНастроек.Вставить("ЗапретитьПовторениеПароляСредиПоследних", 10);
	ПредлагаемыеЗначенияНастроек.Вставить("ПредупреждатьОбОкончанииСрокаДействияПароля", 5);
	ПредлагаемыеЗначенияНастроек.Вставить("ПросрочкаРаботыВПрограммеДоЗапрещенияВхода", 45);
	
	ПредлагаемыеЗначенияОбщихНастроек = Новый Структура;
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ОтдельныеНастройкиДляВнешнихПользователей", Null);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ПредупреждатьОбОкончанииСрокаРаботыВПрограмме", 7);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("СохранениеПароляПриВходе", "РазрешеноИОтключено");
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ВремяСохраненияПароля",
		ПредлагаемоеЗначение(600, Истина, "СохранениеПароляПриВходе", Истина));
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("СрокБездействияДоЗавершенияСеанса", 960);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ПредупреждатьОЗавершенииСеансаПриБездействии", 5);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("КоличествоПопытокВводаПароляДоБлокировки", 3);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ДлительностьБлокировкиВводаПароля",
		ПредлагаемоеЗначение(5, Истина, "КоличествоПопытокВводаПароляДоБлокировки", Истина));
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ПоказыватьВСпискеВыбора", Null);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ИспользоватьСтандартныйСписокЗапрещенныхПаролей", Null);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ИспользоватьДополнительныйСписокЗапрещенныхПаролей", Null);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ИспользоватьСервисЗапрещенныхПаролей", Null);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("АдресСервисаЗапрещенныхПаролей", Null);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("МаксимальноеВремяОжиданияСервисаЗапрещенныхПаролей", Null);
	ПредлагаемыеЗначенияОбщихНастроек.Вставить("ПропускатьПроверкуЕслиСервисЗапрещенныхПаролейНеГотов", Null);
	
	НастройкиВхода = ПользователиСлужебный.НастройкиВхода();
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаПредупреждатьОбОкончанииСрокаДействияПароля.Видимость = Ложь;
		Элементы.ГруппаПредупреждатьОбОкончанииСрокаДействияПароля2.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьСоответствиеИменЭлементовИНастроек();
	
	ЗаполнитьНастройкиВФорме(НастройкиВхода.Общие, ПредлагаемыеЗначенияОбщихНастроек);
	ЗаполнитьНастройкиВФорме(НастройкиВхода.Пользователи, ПредлагаемыеЗначенияНастроек);
	ЗаполнитьНастройкиВФорме(НастройкиВхода.ВнешниеПользователи, ПредлагаемыеЗначенияНастроек, Истина);
	
	Если ИспользоватьВнешнихПользователей Тогда
		ОбновитьДоступностьНастроекВнешнихПользователей(ЭтотОбъект);
		Если ПоказатьНастройкиВнешнихПользователей Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.ДляВнешнихПользователей;
		КонецЕсли;
	Иначе
		Элементы.ОтдельныеНастройкиДляВнешнихПользователей.Видимость = Ложь;
		ОтдельныеНастройкиДляВнешнихПользователей = Ложь;
		ОбновитьДоступностьНастроекВнешнихПользователей(ЭтотОбъект);
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ПредупреждениеНастройкаВСервисе.Видимость = Истина;
		Элементы.ФормаЗаписатьИЗакрыть.Доступность = Ложь;
		Элементы.Страницы.ТолькоПросмотр = Истина;
		Элементы.ПояснениеПоказыватьВСпискеВыбораРазделениеВключено.Видимость = Истина;
		Элементы.ПоказыватьВСпискеВыбора.Доступность = Ложь;
		Элементы.ПоказатьСписокЗапрещенныхПаролей.Доступность = Ложь;
		Элементы.ОчиститьСписокЗапрещенныхПаролей.Доступность = Ложь;
		Элементы.УстановитьСписокЗапрещенныхПаролей.Доступность = Ложь;
		
	ИначеЕсли ИспользоватьВнешнихПользователей Тогда
		Элементы.ПояснениеПоказыватьВСпискеВыбораВнешниеПользователи.Видимость = Истина;
		Элементы.ПоказыватьВСпискеВыбора.Доступность = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Элементы.ГруппаКоличествоПопытокВводаПароляДоБлокировки.Видимость = Ложь;
		Элементы.ГруппаДлительностьБлокировкиВводаПароля.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПользователиСлужебный.ДоступныНастройки8_3_26() Тогда
		Элементы.ПарольДолженОтсутствоватьВСпискеЗапрещенных.Видимость = Ложь;
		Элементы.ДействиеПриВходеЕслиТребованиеНеВыполненоВключить.Видимость = Ложь;
		Элементы.ГруппаДействиеПриВходеЕслиТребованиеНеВыполнено.Видимость = Ложь;
		Элементы.ПарольДолженОтсутствоватьВСпискеЗапрещенных2.Видимость = Ложь;
		Элементы.ДействиеПриВходеЕслиТребованиеНеВыполнено2Включить.Видимость = Ложь;
		Элементы.ГруппаДействиеПриВходеЕслиТребованиеНеВыполнено2.Видимость = Ложь;
		Элементы.ГруппаСрокБездействияДоЗавершенияСеанса.Видимость = Ложь;
		Элементы.ГруппаПредупреждатьОЗавершенииСеансаПриБездействии.Видимость = Ложь;
		Элементы.ГруппаСохранениеПароляПриВходе.Видимость = Ложь;
		Элементы.ГруппаВремяСохраненияПароля.Видимость = Ложь;
		Элементы.ЗапрещенныеПароли.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.УстановитьСписокЗапрещенныхПаролейРасширеннаяПодсказка.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Установить список паролей из текстового файла (%1 со спецификацией [c %2]). Каждый пароль должен быть указан на одной строке.
			           |Вместо паролей можно указать сохраняемые значения паролей (хеши паролей по алгоритму %3 в формате %4).'"),
			"UTF-8", "BOM", "sha1", "base64");
	
	ОбновитьДоступностьНастроекСервисаЗапрещенныхПаролей(ЭтотОбъект);
	ОбновитьКоличествоЗапрещенныхПаролейВДополнительномСписке();
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользоватьСервисЗапрещенныхПаролей
	   И Не ЗначениеЗаполнено(АдресСервисаЗапрещенныхПаролей) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Адрес сервиса не заполнен'"),, "АдресСервисаЗапрещенныхПаролей",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтдельныеНастройкиДляВнешнихПользователейПриИзменении(Элемент)
	
	ОбновитьДоступностьНастроекВнешнихПользователей(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольДолженОтвечатьТребованиямСложностиПриИзменении(Элемент)
	
	Если МинимальнаяДлинаПароля < 7 Тогда
		МинимальнаяДлинаПароля = 7;
	КонецЕсли;
	Если МинимальнаяДлинаПароля2 < 7 Тогда
		МинимальнаяДлинаПароля2 = 7;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МинимальнаяДлинаПароляПриИзменении(Элемент)
	
	Если МинимальнаяДлинаПароля < 7
	  И ПарольДолженОтвечатьТребованиямСложности Тогда
		
		МинимальнаяДлинаПароля = 7;
	КонецЕсли;
	
	Если МинимальнаяДлинаПароля2 < 7
	  И ПарольДолженОтвечатьТребованиямСложности2 Тогда
		
		МинимальнаяДлинаПароля2 = 7;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВключитьПриИзменении(Элемент)
	
	Имена = НастройкиПоЭлементам.Получить(Элемент.Имя);
	
	Если ЭтотОбъект[Элемент.Имя] = Ложь Тогда
		ПредлагаемоеЗначение = ПредлагаемоеЗначение(ПредлагаемыеЗначенияНастроек[Имена.ИмяНастройки]);
		ЭтотОбъект[Имена.ИмяНастройкиВФорме] = ПредлагаемоеЗначение.Значение;
	КонецЕсли;
	
	Элементы[Имена.ИмяЭлемента].Доступность = ЭтотОбъект[Элемент.Имя];
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщаяНастройкаВключитьПриИзменении(Элемент, ВключитьСинхронно = Истина)
	
	Имена = НастройкиПоЭлементам.Получить(Элемент.Имя);
	
	Если ЭтотОбъект[Элемент.Имя] = Ложь Тогда
		ПредлагаемоеЗначение = ПредлагаемоеЗначение(ПредлагаемыеЗначенияОбщихНастроек[Имена.ИмяНастройки]);
		ЭтотОбъект[Имена.ИмяНастройкиВФорме] = ПредлагаемоеЗначение.Значение;
	КонецЕсли;
	
	Элементы[Имена.ИмяЭлемента].Доступность = ЭтотОбъект[Элемент.Имя];
	
	Если Не ВключитьСинхронно Тогда
		Возврат;
	КонецЕсли;
	
	ВключитьСинхронно(Элемент,
		Элементы.СрокБездействияДоЗавершенияСеансаВключить.Имя,
		Элементы.ПредупреждатьОЗавершенииСеансаПриБездействииВключить.Имя);
	
	ВключитьСинхронно(Элемент,
		Элементы.КоличествоПопытокВводаПароляДоБлокировкиВключить.Имя,
		Элементы.ДлительностьБлокировкиВводаПароляВключить.Имя);
	
	ВключитьСинхронно(Элемент,
		Элементы.СохранениеПароляПриВходеВключить.Имя,
		Элементы.ВремяСохраненияПароляВключить.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеНастройкиПриИзменении(Элемент, Значение = 1)
	
	Если ЭтотОбъект[Элемент.Имя] < Значение Тогда
		ЭтотОбъект[Элемент.Имя] = Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокБездействияДоЗавершенияСеансаПриИзменении(Элемент)
	
	ЗначениеНастройкиПриИзменении(Элемент, 2);
	
	Если ПредупреждатьОЗавершенииСеансаПриБездействии > СрокБездействияДоЗавершенияСеанса - 1 Тогда
		ПредупреждатьОЗавершенииСеансаПриБездействии = СрокБездействияДоЗавершенияСеанса - 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупреждатьОЗавершенииСеансаПриБездействииПриИзменении(Элемент)
	
	ЗначениеНастройкиПриИзменении(Элемент);
	
	Если СрокБездействияДоЗавершенияСеанса < ПредупреждатьОЗавершенииСеансаПриБездействии + 1 Тогда
		СрокБездействияДоЗавершенияСеанса = ПредупреждатьОЗавершенииСеансаПриБездействии + 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВСпискеВыбораОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВСпискеВыбораОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ПоказыватьВСпискеВыбора = ВыбранноеЗначение
	 Или ВыбранноеЗначение = "ВключеноДляНовыхПользователей"
	 Или ВыбранноеЗначение = "ВыключеноДляНовыхПользователей" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПоказыватьВСпискеВыбораОбработкаВыбораЗавершение",
		ЭтотОбъект, ВыбранноеЗначение);
	
	Если ВыбранноеЗначение = "СкрытоИВключеноДляВсехПользователей" Тогда
		ТекстВопроса =
			НСтр("ru = 'При входе в приложение список выбора пользователей станет полным
			           |(реквизит ""Показывать в списке выбора"" в карточках всех
			           | пользователей будет включен и скрыт).'");
	Иначе
		ТекстВопроса =
			НСтр("ru = 'При входе в приложение список выбора пользователей станет пустым
			           |(реквизит ""Показывать в списке выбора"" в карточках всех
			           | пользователей будет очищен и скрыт).'");
	КонецЕсли;
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСервисЗапрещенныхПаролейПриИзменении(Элемент)
	
	ОбновитьДоступностьНастроекСервисаЗапрещенныхПаролей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьНаСервере();
	Оповестить("Запись_НаборКонстант", Новый Структура, "НастройкиВходаПользователей");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСписокЗапрещенныхПаролей(Команда)
	
	Если ЗначениеЗаполнено(АдресНовогоСпискаПаролейВоВременномХранилище) Тогда
		Текст = ЗагруженныйСписокЗапрещенныхПаролей(АдресНовогоСпискаПаролейВоВременномХранилище);
		Если НовыйСписокСодержитПароли Тогда
			ЗаголовокДокумента = НСтр("ru = 'Запрещенные пароли (загружены для установки)'");
		Иначе
			ЗаголовокДокумента = НСтр("ru = 'Хеши запрещенных паролей (загружены для установки)'");
		КонецЕсли;
	Иначе
		Текст = ТекущийСписокХешейЗапрещенныхПаролей();
		ЗаголовокДокумента = НСтр("ru = 'Хеши запрещенных паролей'");
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(Текст);
	ТекстовыйДокумент.Показать(ЗаголовокДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокЗапрещенныхПаролей(Команда)
	
	ОбновитьКоличествоЗапрещенныхПаролейВДополнительномСписке(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСписокЗапрещенныхПаролей(Команда)
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Текстовый документ (%1 со спецификацией [c %2])'"), "UTF-8", "BOM") + "|*.txt";
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗагрузкиФайла", ЭтотОбъект);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСоответствиеИменЭлементовИНастроек()
	
	ТекущиеНастройкиПоЭлементам = Новый Соответствие;
	ТекущиеЭлементыПоНастройкам = Новый Соответствие;
	
	ДобавитьИмена(Элементы.ПарольДолженОтвечатьТребованиямСложности2.Имя,
		Элементы.ПарольДолженОтвечатьТребованиямСложности2.Имя,
		"ПарольДолженОтвечатьТребованиямСложности",
		"ПарольДолженОтвечатьТребованиямСложности2");
	
	ДобавитьИмена(Элементы.МинимальнаяДлинаПароляВключить.Имя,
		Элементы.МинимальнаяДлинаПароля.Имя,
		"МинимальнаяДлинаПароля");
	
	ДобавитьИмена(Элементы.МинимальнаяДлинаПароля2Включить.Имя,
		Элементы.МинимальнаяДлинаПароля2.Имя,
		"МинимальнаяДлинаПароля",
		"МинимальнаяДлинаПароля2");
	
	ДобавитьИмена(Элементы.ДействиеПриВходеЕслиТребованиеНеВыполненоВключить.Имя,
		Элементы.ДействиеПриВходеЕслиТребованиеНеВыполнено.Имя,
		"ДействиеПриВходеЕслиТребованиеНеВыполнено");
	
	ДобавитьИмена(Элементы.ДействиеПриВходеЕслиТребованиеНеВыполнено2Включить.Имя,
		Элементы.ДействиеПриВходеЕслиТребованиеНеВыполнено2.Имя,
		"ДействиеПриВходеЕслиТребованиеНеВыполнено",
		"ДействиеПриВходеЕслиТребованиеНеВыполнено2");
	
	ДобавитьИмена(Элементы.МаксимальныйСрокДействияПароляВключить.Имя,
		Элементы.МаксимальныйСрокДействияПароля.Имя,
		"МаксимальныйСрокДействияПароля");
	
	ДобавитьИмена(Элементы.МаксимальныйСрокДействияПароля2Включить.Имя,
		Элементы.МаксимальныйСрокДействияПароля2.Имя,
		"МаксимальныйСрокДействияПароля",
		"МаксимальныйСрокДействияПароля2");
	
	ДобавитьИмена(Элементы.МинимальныйСрокДействияПароляВключить.Имя,
		Элементы.МинимальныйСрокДействияПароля.Имя,
		"МинимальныйСрокДействияПароля");
	
	ДобавитьИмена(Элементы.МинимальныйСрокДействияПароля2Включить.Имя,
		Элементы.МинимальныйСрокДействияПароля2.Имя,
		"МинимальныйСрокДействияПароля",
		"МинимальныйСрокДействияПароля2");
	
	ДобавитьИмена(Элементы.ЗапретитьПовторениеПароляСредиПоследнихВключить.Имя,
		Элементы.ЗапретитьПовторениеПароляСредиПоследних.Имя,
		"ЗапретитьПовторениеПароляСредиПоследних");
	
	ДобавитьИмена(Элементы.ЗапретитьПовторениеПароляСредиПоследних2Включить.Имя,
		Элементы.ЗапретитьПовторениеПароляСредиПоследних2.Имя,
		"ЗапретитьПовторениеПароляСредиПоследних",
		"ЗапретитьПовторениеПароляСредиПоследних2");
	
	ДобавитьИмена(Элементы.ПредупреждатьОбОкончанииСрокаДействияПароляВключить.Имя,
		Элементы.ПредупреждатьОбОкончанииСрокаДействияПароля.Имя,
		"ПредупреждатьОбОкончанииСрокаДействияПароля");
	
	ДобавитьИмена(Элементы.ПредупреждатьОбОкончанииСрокаДействияПароля2Включить.Имя,
		Элементы.ПредупреждатьОбОкончанииСрокаДействияПароля2.Имя,
		"ПредупреждатьОбОкончанииСрокаДействияПароля",
		"ПредупреждатьОбОкончанииСрокаДействияПароля2");
	
	ДобавитьИмена(Элементы.ПросрочкаРаботыВПрограммеДоЗапрещенияВходаВключить.Имя,
		Элементы.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода.Имя,
		"ПросрочкаРаботыВПрограммеДоЗапрещенияВхода");
	
	ДобавитьИмена(Элементы.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода2Включить.Имя,
		Элементы.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода2.Имя,
		"ПросрочкаРаботыВПрограммеДоЗапрещенияВхода",
		"ПросрочкаРаботыВПрограммеДоЗапрещенияВхода2");
	
	ДобавитьИмена(Элементы.ПредупреждатьОбОкончанииСрокаРаботыВПрограммеВключить.Имя,
		Элементы.ПредупреждатьОбОкончанииСрокаРаботыВПрограмме.Имя,
		"ПредупреждатьОбОкончанииСрокаРаботыВПрограмме");
	
	ДобавитьИмена(Элементы.СрокБездействияДоЗавершенияСеансаВключить.Имя,
		Элементы.СрокБездействияДоЗавершенияСеанса.Имя,
		"СрокБездействияДоЗавершенияСеанса");
	
	ДобавитьИмена(Элементы.ПредупреждатьОЗавершенииСеансаПриБездействииВключить.Имя,
		Элементы.ПредупреждатьОЗавершенииСеансаПриБездействии.Имя,
		"ПредупреждатьОЗавершенииСеансаПриБездействии");
	
	ДобавитьИмена(Элементы.КоличествоПопытокВводаПароляДоБлокировкиВключить.Имя,
		Элементы.КоличествоПопытокВводаПароляДоБлокировки.Имя,
		"КоличествоПопытокВводаПароляДоБлокировки");
	
	ДобавитьИмена(Элементы.ДлительностьБлокировкиВводаПароляВключить.Имя,
		Элементы.ДлительностьБлокировкиВводаПароля.Имя,
		"ДлительностьБлокировкиВводаПароля");
	
	ДобавитьИмена(Элементы.СохранениеПароляПриВходеВключить.Имя,
		Элементы.СохранениеПароляПриВходе.Имя,
		"СохранениеПароляПриВходе");
	
	ДобавитьИмена(Элементы.ВремяСохраненияПароляВключить.Имя,
		Элементы.ВремяСохраненияПароля.Имя,
		"ВремяСохраненияПароля");
	
	НастройкиПоЭлементам = Новый ФиксированноеСоответствие(ТекущиеНастройкиПоЭлементам);
	ЭлементыПоНастройкам = Новый ФиксированноеСоответствие(ТекущиеЭлементыПоНастройкам);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИмена(ИмяЭлементаВключить, ИмяЭлемента, ИмяНастройки, ИмяНастройкиВФорме = Неопределено)
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИмяЭлемента", ИмяЭлемента);
	Свойства.Вставить("ИмяНастройки", ИмяНастройки);
	Свойства.Вставить("ИмяНастройкиВФорме", ИмяНастройкиВФорме);
	
	Если ИмяНастройкиВФорме = Неопределено Тогда
		Свойства.ИмяНастройкиВФорме = ИмяНастройки;
	КонецЕсли;
	
	ТекущиеНастройкиПоЭлементам.Вставить(ИмяЭлементаВключить, Новый ФиксированнаяСтруктура(Свойства));
	
	КлючИмен = ?(ИмяНастройкиВФорме = Неопределено, ИмяНастройки, ИмяНастройки + "2");
	Свойства.Удалить("ИмяНастройки");
	Свойства.Вставить("ИмяЭлементаВключить", ИмяЭлементаВключить);
	
	ТекущиеЭлементыПоНастройкам.Вставить(КлючИмен, Новый ФиксированнаяСтруктура(Свойства));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредлагаемоеЗначение(Значение, Включить = Истина, Зависимость = "", ПустоеЗапрещено = Ложь)
	
	Если ТипЗнч(Значение) = Тип("Структура") Тогда
		Возврат Значение;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", Значение);
	Результат.Вставить("Включить", Включить);
	Результат.Вставить("Зависимость", Зависимость);
	Результат.Вставить("ПустоеЗапрещено", ПустоеЗапрещено);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВключитьСинхронно(Элемент, Имя1, Имя2)
	
	Если Элемент.Имя = Имя1 Тогда
		ЭтотОбъект[Имя2] = ЭтотОбъект[Имя1];
		ОбщаяНастройкаВключитьПриИзменении(Элементы[Имя2], Ложь);
		
	ИначеЕсли Элемент.Имя = Имя2 Тогда
		ЭтотОбъект[Имя1] = ЭтотОбъект[Имя2];
		ОбщаяНастройкаВключитьПриИзменении(Элементы[Имя1], Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьНастроекВнешнихПользователей(Форма, ПриИзменении = Ложь)
	
	Если Форма.ОтдельныеНастройкиДляВнешнихПользователей Тогда
		Форма.Элементы.ДляПользователей.Заголовок = НСтр("ru = 'Для пользователей'");
		Форма.Элементы.ДляВнешнихПользователей.Видимость = Истина;
		Если ПриИзменении Тогда
			Форма.Элементы.Страницы.ТекущаяСтраница =
				Форма.Элементы.ДляВнешнихПользователей;
		КонецЕсли;
	Иначе
		Форма.Элементы.ДляПользователей.Заголовок = НСтр("ru = 'Основные'");
		Форма.Элементы.ДляВнешнихПользователей.Видимость = Ложь;
		Форма.Элементы.Страницы.ТекущаяСтраница =
			Форма.Элементы.ДляПользователей;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьНастроекСервисаЗапрещенныхПаролей(Форма)
	
	Форма.Элементы.АдресСервисаЗапрещенныхПаролей.Доступность =
		Форма.ИспользоватьСервисЗапрещенныхПаролей;
	
	Форма.Элементы.АдресСервисаЗапрещенныхПаролей.АвтоОтметкаНезаполненного =
		?(Форма.ИспользоватьСервисЗапрещенныхПаролей, Истина, Неопределено);
	
	Форма.Элементы.МаксимальноеВремяОжиданияСервисаЗапрещенныхПаролей.Доступность =
		Форма.ИспользоватьСервисЗапрещенныхПаролей;
	
	Форма.Элементы.ПропускатьПроверкуЕслиСервисЗапрещенныхПаролейНеГотов.Доступность =
		Форма.ИспользоватьСервисЗапрещенныхПаролей;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличествоЗапрещенныхПаролейВДополнительномСписке(Знач Очистить = Ложь, Знач Количество = -1)
	
	Если ПользователиСлужебный.ДоступныНастройки8_3_26() Тогда
		Если Очистить Тогда
			Количество = 0;
			АдресНовогоСпискаПаролейВоВременномХранилище =
				ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор);
		ИначеЕсли Количество = -1 Тогда
			УстановитьПривилегированныйРежим(Истина);
			МенеджерСписка = ДополнительныеНастройкиАутентификации.СписокПроверкиРаскрытияПароля;
			Количество = МенеджерСписка.ПолучитьКоличествоСохраняемыхЗначенийПаролей();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
	Иначе
		Количество = 0;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Количество) Тогда
		СписокДоступен = Не ОбщегоНазначения.РазделениеВключено();
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительный список (%1)'"), Строка(Количество));
	Иначе
		СписокДоступен = Ложь;
		ТекстЗаголовка = НСтр("ru = 'Дополнительный список'");
	КонецЕсли;
	
	Элементы.ПоказатьСписокЗапрещенныхПаролей.Доступность = СписокДоступен;
	Элементы.ОчиститьСписокЗапрещенныхПаролей.Доступность = СписокДоступен;
	Элементы.ИспользоватьДополнительныйСписокЗапрещенныхПаролей.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиВФорме(Настройки, ПредлагаемыеЗначенияНастроек, ДляВнешнихПользователей = Ложь)
	
	Для Каждого КлючИЗначение Из ПредлагаемыеЗначенияНастроек Цикл
		КлючИмен = КлючИЗначение.Ключ + ?(ДляВнешнихПользователей, "2", "");
		Имена = ЭлементыПоНастройкам.Получить(КлючИмен);
		Если Имена = Неопределено Тогда
			Имена = Новый Структура("ИмяНастройкиВФорме, ИмяЭлемента",
				КлючИЗначение.Ключ, КлючИЗначение.Ключ);
		КонецЕсли;
		Если КлючИЗначение.Значение = Null Тогда
			ЭтотОбъект[Имена.ИмяНастройкиВФорме] = Настройки[КлючИЗначение.Ключ];
			Продолжить;
		КонецЕсли;
		ПредлагаемоеЗначение = ПредлагаемоеЗначение(КлючИЗначение.Значение,, КлючИЗначение.Ключ);
		Если ЗначениеЗаполнено(Настройки[КлючИЗначение.Ключ]) Тогда
			ЭтотОбъект[Имена.ИмяНастройкиВФорме] = Настройки[КлючИЗначение.Ключ];
			Если ПредлагаемоеЗначение.Включить Тогда
				ЭтотОбъект[Имена.ИмяЭлементаВключить] = Истина;
			КонецЕсли;
		Иначе
			ЭтотОбъект[Имена.ИмяНастройкиВФорме] = ПредлагаемоеЗначение.Значение;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Настройки[ПредлагаемоеЗначение.Зависимость]) Тогда
			Элементы[Имена.ИмяЭлемента].Доступность = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	НачатьТранзакцию();
	Попытка
		УстановитьНовыйДополнительныйСписокЗапрещенныхПаролей();
		Общие = Пользователи.НовоеОписаниеОбщихНастроекВхода();
		Если ПодтвержденоМассовоеИзменениеСвойстваПоказыватьВСпискеВыбора
		   И Общие.ПоказыватьВСпискеВыбора <> ПоказыватьВСпискеВыбора
		   И (    ПоказыватьВСпискеВыбора = "СкрытоИВключеноДляВсехПользователей"
		      Или ПоказыватьВСпискеВыбора = "СкрытоИВыключеноДляВсехПользователей") Тогда
			ПользователиСлужебный.УстановитьРеквизитПоказыватьВСпискеВыбораУВсехПользователейИБ(
				ПоказыватьВСпискеВыбора = "СкрытоИВключеноДляВсехПользователей");
		КонецЕсли;
		ЗаполнитьНастройкиИзФормы(Общие, ПредлагаемыеЗначенияОбщихНастроек);
		Пользователи.УстановитьОбщиеНастройкиВхода(Общие);
		
		НастройкиПользователей = Пользователи.НовоеОписаниеНастроекВхода();
		ЗаполнитьНастройкиИзФормы(НастройкиПользователей, ПредлагаемыеЗначенияНастроек);
		Пользователи.УстановитьНастройкиВхода(НастройкиПользователей);
		
		НастройкиВнешнихПользователей = Пользователи.НовоеОписаниеНастроекВхода();
		ЗаполнитьНастройкиИзФормы(НастройкиВнешнихПользователей, ПредлагаемыеЗначенияНастроек, Истина);
		Пользователи.УстановитьНастройкиВхода(НастройкиВнешнихПользователей, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	АдресНовогоСпискаПаролейВоВременномХранилище = "";
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНовыйДополнительныйСписокЗапрещенныхПаролей()
	
	Если Не ЗначениеЗаполнено(АдресНовогоСпискаПаролейВоВременномХранилище)
	 Или Не ПользователиСлужебный.ДоступныНастройки8_3_26() Тогда
		Возврат;
	КонецЕсли;
	
	Строки = ПолучитьИзВременногоХранилища(АдресНовогоСпискаПаролейВоВременномХранилище);
	МенеджерСписка = ДополнительныеНастройкиАутентификации.СписокПроверкиРаскрытияПароля;
	
	Если НовыйСписокСодержитПароли Тогда
		МенеджерСписка.УстановитьСписокИзПаролей(Строки);
	Иначе
		МенеджерСписка.УстановитьСписокИзСохраняемыхЗначенийПаролей(Строки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиИзФормы(Настройки, ПредлагаемыеЗначенияНастроек, ДляВнешнихПользователей = Ложь)
	
	Для Каждого КлючИЗначение Из ПредлагаемыеЗначенияНастроек Цикл
		КлючИмен = КлючИЗначение.Ключ + ?(ДляВнешнихПользователей, "2", "");
		Имена = ЭлементыПоНастройкам.Получить(КлючИмен);
		Если Имена = Неопределено Тогда
			Имена = Новый Структура("ИмяНастройкиВФорме, ИмяЭлемента",
				КлючИЗначение.Ключ, КлючИЗначение.Ключ);
		КонецЕсли;
		Если КлючИЗначение.Значение = Null Тогда
			Настройки[КлючИЗначение.Ключ] = ЭтотОбъект[Имена.ИмяНастройкиВФорме];
			Продолжить;
		КонецЕсли;
		ПредлагаемоеЗначение = ПредлагаемоеЗначение(КлючИЗначение.Значение);
		
		Если ПредлагаемоеЗначение.Включить И ЭтотОбъект[Имена.ИмяЭлементаВключить] Тогда
			Настройки[КлючИЗначение.Ключ] = ЭтотОбъект[Имена.ИмяНастройкиВФорме];
		ИначеЕсли ПредлагаемоеЗначение.ПустоеЗапрещено Тогда
			Настройки[КлючИЗначение.Ключ] = ПредлагаемоеЗначение.Значение;
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("Число") Тогда
			Настройки[КлючИЗначение.Ключ] = 0;
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("Строка") Тогда
			Настройки[КлючИЗначение.Ключ] = "";
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("Булево") Тогда
			Настройки[КлючИЗначение.Ключ] = Ложь;
		Иначе
			Настройки[КлючИЗначение.Ключ] = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекущийСписокХешейЗапрещенныхПаролей()
	
	Если Не ПользователиСлужебный.ДоступныНастройки8_3_26() Тогда
		Возврат "";
	КонецЕсли;
	
	МенеджерСписка = ДополнительныеНастройкиАутентификации.СписокПроверкиРаскрытияПароля;
	Строки = МенеджерСписка.ПолучитьСписокСохраняемыхЗначенийПаролей();
	
	Если ТипЗнч(Строки) = Тип("Массив") Тогда
		Возврат СтрСоединить(Строки, Символы.ПС);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗагруженныйСписокЗапрещенныхПаролей(Адрес)
	
	Строки = ПолучитьИзВременногоХранилища(Адрес);
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

&НаКлиенте
Процедура ПоказыватьВСпискеВыбораОбработкаВыбораЗавершение(Ответ, ВыбранноеЗначение) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоказыватьВСпискеВыбора = ВыбранноеЗначение;
		ПодтвержденоМассовоеИзменениеСвойстваПоказыватьВСпискеВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗагрузкиФайла(ПомещенныйФайл, Контекст) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПредварительныйРезультатПодготовкиСписка(ПомещенныйФайл.Хранение);
	Если ТипЗнч(Результат) <> Тип("Массив") Тогда
		ПоказатьПредупреждение(, Результат);
		Возврат;
	КонецЕсли;
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Пароли", НСтр("ru = 'Это пароли'"));
	Кнопки.Добавить("ХешиПаролей", НСтр("ru = 'Это хеши паролей'"));
	Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Строки в выбранном файле:
		           |
		           |%1
		           |
		           |Это пароли
		           |или хеши паролей (по алгоритму %2 в формате %3)?'"),
		СтрСоединить(Результат, Символы.ПС), "sha1", "base64");
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораФорматаФайла", ЭтотОбъект, ПомещенныйФайл.Хранение);
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФорматаФайла(Ответ, АдресПомещенногоФайла) Экспорт
	
	Если Ответ <> "Пароли" И Ответ <> "ХешиПаролей" Тогда
		Возврат;
	КонецЕсли;
	
	Текст = РезультатПодготовкиСписка(АдресПомещенногоФайла, Ответ);
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредварительныйРезультатПодготовкиСписка(Знач Адрес)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	Если ТипЗнч(ДвоичныеДанные) <> Тип("ДвоичныеДанные") Тогда
		Возврат НСтр("ru = 'Не удалось получить данные файла'");
	КонецЕсли;
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'В начале файла не найдена спецификация %1 (%2)'"), "UTF-8", "BOM");
	
	Если ДвоичныеДанные.Размер() < 3 Тогда
		Возврат ТекстОшибки;
	КонецЕсли;
	
	ЧтениеДанных = Новый ЧтениеДанных(ДвоичныеДанные);
	БуферДвоичныхДанных = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(3);
	
	Если БуферДвоичныхДанных[0] <> ЧислоИзШестнадцатеричнойСтроки("0xEF")
	 Или БуферДвоичныхДанных[1] <> ЧислоИзШестнадцатеричнойСтроки("0xBB")
	 Или БуферДвоичныхДанных[2] <> ЧислоИзШестнадцатеричнойСтроки("0xBF") Тогда
		
		Возврат ТекстОшибки;
	КонецЕсли;
	
	Текст = ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанные, КодировкаТекста.UTF8);
	Строки = СтрРазделить(Текст, Символы.ПС + Символы.ВК, Ложь);
	ВсеСтроки = Новый Массив;
	ПервыеСтроки = Новый Массив;
	
	Для Каждого Строка Из Строки Цикл
		Если Не ЗначениеЗаполнено(Строка) Тогда
			Продолжить;
		КонецЕсли;
		Строка = СокрЛП(Строка);
		ВсеСтроки.Добавить(Строка);
		Если ПервыеСтроки.Количество() < 5 Тогда
			ПервыеСтроки.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ВсеСтроки) Тогда
		Возврат НСтр("ru = 'Пустой файл'");
	КонецЕсли;
	
	Если ВсеСтроки.Количество() > 5 Тогда
		ПервыеСтроки.Добавить("...");
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ВсеСтроки, Адрес);
	
	Возврат ПервыеСтроки;
	
КонецФункции

&НаСервере
Функция РезультатПодготовкиСписка(Знач Адрес, Знач Формат)
	
	Строки = ПолучитьИзВременногоХранилища(Адрес);
	
	Если Формат = "ХешиПаролей" Тогда
		НомерСтроки = 0;
		Для Каждого Строка Из Строки Цикл
			НомерСтроки = НомерСтроки + 1;
			Если Не ЗначениеЗаполнено(Строка) Тогда
				Продолжить;
			КонецЕсли;
			Попытка
				Хеш = Base64Значение(Строка);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Текст ""%1"" в строке %2 не в формате %3 по причине:
					|%4'"),
					Строка,
					Формат(НомерСтроки, "ЧГ="),
					"base64",
					ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			КонецПопытки;
			Если Хеш.Размер() = 0 Тогда
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Текст ""%1"" в строке %2 не в формате %3.'"),
					Строка,
					Формат(НомерСтроки, "ЧГ="),
					"base64");
			КонецЕсли;
			Если Хеш.Размер() <> 20 Тогда
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Текст ""%1"" в строке %2 содержит двоичные данные длиной %3, а не 20 байт'"),
					Строка,
					Формат(НомерСтроки, "ЧГ="),
					Формат(Хеш.Размер(), "ЧГ="));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	АдресНовогоСпискаПаролейВоВременномХранилище =
		ПоместитьВоВременноеХранилище(Строки, УникальныйИдентификатор);
	НовыйСписокСодержитПароли = Формат <> "ХешиПаролей";
	
	ОбновитьКоличествоЗапрещенныхПаролейВДополнительномСписке(Ложь, Строки.Количество());
	
	Если Формат = "ХешиПаролей" Тогда
		Возврат НСтр("ru = 'Хеши паролей загружены'");
	КонецЕсли;
	
	Возврат НСтр("ru = 'Пароли загружены'");
	
КонецФункции

#КонецОбласти
