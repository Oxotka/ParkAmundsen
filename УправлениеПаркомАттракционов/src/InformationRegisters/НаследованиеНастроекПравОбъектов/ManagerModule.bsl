///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет иерархию владельцев настроек прав объектов.
// Например, иерархию элементов справочника ПапкиФайлов.
//
// Параметры:
//  ВладельцыНастроекПрав - ОпределяемыйТип.ВладелецНастроекПрав - например, СправочникСсылка.ПапкиФайлов
//                          или другой тип, по которому права настраиваются непосредственно.
//                        - Массив - массив значений указанных выше типов.
//                        - Неопределено - без отбора для всех типов.
//                        - ОпределяемыйТип.ВладелецНастроекПравОбъект - например, СправочникОбъект.ПапкиФайлов,
//                          при передаче объекта обновление будет если только объект в состоянии перед записью и
//                          родитель изменен.
//
//  ЕстьИзменения         - Булево - (возвращаемое значение) - если производилась запись,
//                          устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(Знач ВладельцыНастроекПрав = Неопределено, ЕстьИзменения = Неопределено) Экспорт
	
	Если ВладельцыНастроекПрав = Неопределено Тогда
		ВозможныеПрава = УправлениеДоступомСлужебный.ВозможныеПраваДляНастройкиПравОбъектов();
		
		Запрос = Новый Запрос;
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТекущаяТаблица.Ссылка
		|ИЗ
		|	&ТекущаяТаблица КАК ТекущаяТаблица";
		
		Для каждого КлючИЗначение Из ВозможныеПрава.ПоПолнымИменам Цикл
			
			Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&ТекущаяТаблица", КлючИЗначение.Ключ);
			// @skip-check query-in-loop - Малый цикл из одной или двух итераций
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				// @skip-check query-in-loop - Обход иерархии элементов с обновлением порциями
				ОбновитьРодителейВладельца(Выборка.Ссылка, ЕстьИзменения);
			КонецЦикла;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ВладельцыНастроекПрав) = Тип("Массив") Тогда
		
		Для каждого ВладелецНастроекПрав Из ВладельцыНастроекПрав Цикл
			// @skip-check query-in-loop - Обход иерархии элементов с обновлением порциями
			ОбновитьРодителейВладельца(ВладелецНастроекПрав, ЕстьИзменения);
		КонецЦикла;
	Иначе
		ОбновитьРодителейВладельца(ВладельцыНастроекПрав, ЕстьИзменения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет родителей владельца настроек прав объектов.
// Например, справочник ПапкиФайлов.
// 
// Параметры:
//  ВладелецНастроекПрав - ОпределяемыйТип.ВладелецНастроекПрав - например, СправочникСсылка.ПапкиФайлов
//                          или другого типа, по которым права настраиваются непосредственно.
//                       - ОпределяемыйТип.ВладелецНастроекПравОбъект - например, СправочникОбъект.ПапкиФайлов,
//                         при передаче объекта обновление будет если только объект в состоянии перед записью и
//                         родитель изменен.
//
//  ЕстьИзменения        - Булево - (возвращаемое значение) - если производилась запись,
//                         устанавливается Истина, иначе не изменяется.
//
//  ОбновитьИерархию     - Булево - принудительно обновляет нижестоящую иерархию,
//                         независимо от изменения родителей владельца.
//
//  ОбъектыСИзменениями  - Массив - только для внутреннего использования.
//
Процедура ОбновитьРодителейВладельца(ВладелецНастроекПрав, ЕстьИзменения = Ложь, ОбновитьИерархию = Ложь, ОбъектыСИзменениями = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВозможныеПрава = УправлениеДоступомСлужебный.ВозможныеПраваДляНастройкиПравОбъектов();
	ТипВладельца = ТипЗнч(ВладелецНастроекПрав);
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка при обновлении иерархии владельцев прав по значениям доступа.'")
		+ Символы.ПС
		+ Символы.ПС;
	
	Если ВозможныеПрава.ПоТипам.Получить(ТипВладельца) = Неопределено Тогда
		ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для типа ""%1""
			           |не настроено использование настроек прав объектов.'"),
			Строка(ТипВладельца));
	КонецЕсли;
	
	Если ВозможныеПрава.ПоТипамСсылок.Получить(ТипВладельца) = Неопределено Тогда
		Ссылка = ПользователиСлужебный.СсылкаОбъекта(ВладелецНастроекПрав);
		Объект = ВладелецНастроекПрав;
	Иначе
		Ссылка = ВладелецНастроекПрав;
		Объект = Неопределено;
	КонецЕсли;
	
	Иерархический = ВозможныеПрава.ИерархическиеТаблицы.Получить(ТипВладельца) <> Неопределено;
	ТребуетсяОбновление = Ложь;
	
	Если Иерархический Тогда
		СвойстваРодителяОбъекта = СвойстваРодителя(Ссылка);
		
		Если Объект <> Неопределено Тогда
			// Проверка изменения объекта.
			Если СвойстваРодителяОбъекта.Ссылка <> Объект.Родитель Тогда
				ТребуетсяОбновление = Истина;
			КонецЕсли;
			СвойстваРодителяОбъекта.Ссылка      = Объект.Родитель;
			СвойстваРодителяОбъекта.Наследовать = НаследованиеНастроек(Объект.Родитель);
		Иначе
			ТребуетсяОбновление = Истина;
		КонецЕсли;
	Иначе
		Если Объект = Неопределено Тогда
			ТребуетсяОбновление = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ТребуетсяОбновление Тогда
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("РегистрСведений.НаследованиеНастроекПравОбъектов");
	
	Если Объект = Неопределено Тогда
		ДополнительныеСвойства = Неопределено;
	Иначе
		ДополнительныеСвойства = Новый Структура("ВедущийОбъектПередЗаписью", Объект);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Ссылка);
		
		// Подготовка родителей объекта.
		Если Иерархический Тогда
			НовыеЗаписи = РодителиОбъекта(Ссылка, Ссылка, СвойстваРодителяОбъекта);
		Иначе
			НовыеЗаписи = УправлениеДоступомСлужебныйПовтИсп.ТаблицаПустогоНабораЗаписей(
				Метаданные.РегистрыСведений.НаследованиеНастроекПравОбъектов.ПолноеИмя()).Получить(); // ТаблицаЗначений
			
			НоваяСтрока = НовыеЗаписи.Добавить();
			НоваяСтрока.Объект   = Ссылка;
			НоваяСтрока.Родитель = Ссылка;
		КонецЕсли;
		
		Данные = Новый Структура;
		Данные.Вставить("НаборЗаписей",           НаборЗаписей);
		Данные.Вставить("НовыеЗаписи",            НовыеЗаписи);
		Данные.Вставить("ДополнительныеСвойства", ДополнительныеСвойства);
		
		ЕстьТекущиеИзменения = Ложь;
		УправлениеДоступомСлужебный.ОбновитьНаборЗаписей(Данные, ЕстьТекущиеИзменения);
		
		Если ЕстьТекущиеИзменения Тогда
			ЕстьИзменения = Истина;
			
			Если ОбъектыСИзменениями <> Неопределено Тогда
				ОбъектыСИзменениями.Добавить(Ссылка);
			КонецЕсли;
		КонецЕсли;
		
		Если Иерархический И (ЕстьТекущиеИзменения ИЛИ ОбновитьИерархию) Тогда
			ОбновитьИерархиюВладельца(Ссылка, ЕстьИзменения, ОбъектыСИзменениями);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ОбъектыСИзменениями <> Неопределено Тогда
		ОбъектыСИзменениями = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ОбъектыСИзменениями);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет НаборЗаписей родителями объекта, включая себя, как родителя.
//
// Параметры:
//  Ссылка                  - ОпределяемыйТип.ВладелецНастроекПрав - ссылка в иерархии СсылкаОбъекта или СсылкаОбъекта.
//  СсылкаОбъекта           - ОпределяемыйТип.ВладелецНастроекПрав
//                          - Неопределено - ссылка на исходный объект.
//  СвойстваРодителяОбъекта - Структура:
//                            * Ссылка      - ОпределяемыйТип.ВладелецНастроекПрав - ссылка на родителя исходного объекта,
//                                            который может отличаться от родителя,
//                                            записанного в базе данных.
//                            * Наследовать - Булево - наследование настроек родителем.
//  ПолучатьНаследование    - Булево
//
// Возвращаемое значение:
//  РегистрСведенийНаборЗаписей.НаследованиеНастроекПравОбъектов
//
Функция РодителиОбъекта(Ссылка, СсылкаОбъекта = Неопределено, СвойстваРодителяОбъекта = "", ПолучатьНаследование = Истина) Экспорт
	
	НовыеЗаписи = УправлениеДоступомСлужебныйПовтИсп.ТаблицаПустогоНабораЗаписей(
		Метаданные.РегистрыСведений.НаследованиеНастроекПравОбъектов.ПолноеИмя()).Получить(); // ТаблицаЗначений
	
	// Получение флажка наследования настроек прав родителей для ссылки.
	Если ПолучатьНаследование Тогда
		Наследовать = НаследованиеНастроек(Ссылка);
	Иначе
		Наследовать = Истина;
		НовыеЗаписи.Колонки.Добавить("Уровень", Новый ОписаниеТипов("Число"));
	КонецЕсли;
	
	Строка = НовыеЗаписи.Добавить();
	Строка.Объект      = Ссылка;
	Строка.Родитель    = Ссылка;
	Строка.Наследовать = Наследовать;
	
	Если Не Наследовать Тогда
		Возврат НовыеЗаписи;
	КонецЕсли;
	
	Если Ссылка = СсылкаОбъекта Тогда
		СвойстваТекущегоРодителя = СвойстваРодителяОбъекта;
	Иначе
		СвойстваТекущегоРодителя = СвойстваРодителя(Ссылка);
	КонецЕсли;
	
	Пока ЗначениеЗаполнено(СвойстваТекущегоРодителя.Ссылка) Цикл
	
		Строка = НовыеЗаписи.Добавить();
		Строка.Объект   = Ссылка;
		Строка.Родитель = СвойстваТекущегоРодителя.Ссылка;
		Строка.УровеньИспользования = 1;
		
		Если НЕ ПолучатьНаследование Тогда
			Строка.Уровень = Строка.Родитель.Уровень();
		КонецЕсли;
		
		Если Не СвойстваТекущегоРодителя.Наследовать Тогда
			Прервать;
		КонецЕсли;
		
		// @skip-check query-in-loop - Обход иерархии элементов с обновлением порциями
		СвойстваТекущегоРодителя = СвойстваРодителя(СвойстваТекущегоРодителя.Ссылка);
	КонецЦикла;
	
	Возврат НовыеЗаписи;
	
КонецФункции

Функция НаследованиеНастроек(Ссылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаследованиеНастроек.Наследовать
	|ИЗ
	|	РегистрСведений.НаследованиеНастроекПравОбъектов КАК НаследованиеНастроек
	|ГДЕ
	|	НаследованиеНастроек.Объект = &Ссылка
	|	И НаследованиеНастроек.Родитель = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Наследовать, Истина);
	
КонецФункции

// Для процедуры ОбновитьРодителейВладельца.
Процедура ОбновитьИерархиюВладельца(Ссылка, ЕстьИзменения, ОбъектыСИзменениями)
	
	// Обновление состава родителей элементов в иерархии текущего значения.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаСИерархией.Ссылка КАК ПодчиненнаяСсылка
	|ИЗ
	|	&ТаблицаСИерархией КАК ТаблицаСИерархией
	|ГДЕ
	|	ТаблицаСИерархией.Ссылка В ИЕРАРХИИ(&Ссылка)
	|	И ТаблицаСИерархией.Ссылка <> &Ссылка";
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст, "&ТаблицаСИерархией", Ссылка.Метаданные().ПолноеИмя() );
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		// @skip-check query-in-loop - Обход иерархии элементов с обновлением порциями
		НовыеЗаписи = РодителиОбъекта(Выборка.ПодчиненнаяСсылка, Ссылка);
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Выборка.ПодчиненнаяСсылка);
		
		Данные = Новый Структура;
		Данные.Вставить("НаборЗаписей", НаборЗаписей);
		Данные.Вставить("НовыеЗаписи",  НовыеЗаписи);
		
		ЕстьТекущиеИзменения = Ложь;
		УправлениеДоступомСлужебный.ОбновитьНаборЗаписей(Данные, ЕстьТекущиеИзменения);
		
		Если ЕстьТекущиеИзменения Тогда
			ЕстьИзменения = Истина;
			
			Если ОбъектыСИзменениями <> Неопределено Тогда
				ОбъектыСИзменениями.Добавить(Ссылка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Для процедур ОбновитьРодителейВладельца, РодителиОбъекта.
Функция СвойстваРодителя(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Родитель
	|ПОМЕСТИТЬ РодительСсылки
	|ИЗ
	|	ТаблицаОбъектов КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РодительСсылки.Родитель
	|ИЗ
	|	РодительСсылки КАК РодительСсылки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Родители.Наследовать КАК Наследовать
	|ИЗ
	|	РегистрСведений.НаследованиеНастроекПравОбъектов КАК Родители
	|ГДЕ
	|	Родители.Объект = Родители.Родитель
	|	И Родители.Объект В
	|			(ВЫБРАТЬ
	|				РодительСсылки.Родитель
	|			ИЗ
	|				РодительСсылки КАК РодительСсылки)";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТаблицаОбъектов", Ссылка.Метаданные().ПолноеИмя());
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет(); // Массив из РезультатЗапроса 
	
	Выборка = РезультатыЗапроса[1].Выбрать();
	Родитель = ?(Выборка.Следующий(), Выборка.Родитель, Неопределено);
	
	Выборка = РезультатыЗапроса[2].Выбрать();
	Наследовать = ?(Выборка.Следующий(), Выборка.Наследовать, Истина);
	
	Возврат Новый Структура("Ссылка, Наследовать", Родитель, Наследовать);
	
КонецФункции

#КонецОбласти

#КонецЕсли
