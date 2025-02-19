
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Переопределяет настройки печати для объекта.
//
// Параметры:
//  Настройки - см. УправлениеПечатью.НастройкиПечатиОбъекта.
//
Процедура ПриОпределенииНастроекПечати(Настройки) Экспорт
       Настройки.ПриДобавленииКомандПечати = Истина;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
    
    Команда = КомандыПечати.Добавить();	
	Команда.Идентификатор = "Ремонт";
	Команда.Представление = НСтр("ru = 'Ремонт'");
	Команда.ПроверкаПроведенияПередПечатью = Истина;
	Команда.Порядок = 10;
	 
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//	МассивОбъектов – Массив – ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати – Структура – дополнительные настройки печати;
//  КоллекцияПечатныхФорм – ТаблицаЗначений – сформированные табличные документы (выходной параметр)
//  ОбъектыПечати – СписокЗначений – значение – ссылка на объект;
//                                            представление – имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода – Структура – дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Ремонт");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьРемонта(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Ремонт'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.ГПА_РемонтыАттракционов.ПФ_MXL_Ремонт";
	КонецЕсли;	
	
КонецПроцедуры

// Обработчик перехода на новую версию
// Переносит значения из реквизитов в новую табличную часть
// 
Процедура ПеренестиНоменклатуруВТабличнуюЧасть() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродажаБилета.Ссылка
		|ИЗ
		|	Документ.ПродажаБилета КАК ПродажаБилета
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПродажаБилета.ПозицииПродажи КАК ПродажаБилетаПозицииПродажи
		|		ПО ПродажаБилетаПозицииПродажи.Ссылка = ПродажаБилета.Ссылка
		|		И ПродажаБилетаПозицииПродажи.НомерСтроки = 1
		|ГДЕ
		|	ПродажаБилета.УдалитьНоменклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	И ПродажаБилетаПозицииПродажи.Ссылка ЕСТЬ NULL";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Строка = ДокОбъект.ПозицииПродажи.Добавить();
		Строка.Номенклатура = ДокОбъект.УдалитьНоменклатура;
		Строка.Цена = ДокОбъект.УдалитьЦена;
		Строка.Количество = 1;
		Строка.Сумма = Строка.Цена;
		
		ДокОбъект.ОбменДанными.Загрузка = Истина;
		ДокОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьРемонта(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ГПА_РемонтыАттракционов.ПФ_MXL_Ремонт");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ГПА_РемонтыАттракционов.Номер,
		|	ГПА_РемонтыАттракционов.Дата,
		|	ГПА_РемонтыАттракционов.Ссылка,
		|	ГПА_РемонтыАттракционов.Аттракцион,
		|	ГПА_РемонтыАттракционов.ДатаРемонтаПланируемая,
		|	ГПА_РемонтыАттракционов.ДатаРемонтаФактическая,
		|	ГПА_РемонтыАттракционов.Техник
		|ИЗ
		|	Документ.ГПА_РемонтыАттракционов КАК ГПА_РемонтыАттракционов
		|ГДЕ
		|	ГПА_РемонтыАттракционов.Ссылка В (&Ссылка)";
		
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьОсновное = Макет.ПолучитьОбласть("Основное");
	
	ТабличныйДокумент.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ПараметрыОбласти = Новый Структура;
		ПараметрыОбласти.Вставить("Дата", Формат(Выборка.Дата, "ДЛФ=D;"));
		ПараметрыОбласти.Вставить("Номер", УдалитьЛидирующиеНули(Выборка.Номер));
		ПараметрыОбласти.Вставить("ДатаФактическая", Выборка.ДатаРемонтаФактическая);
		ОбластьОсновное.Параметры.Заполнить(ПараметрыОбласти);
		ТабличныйДокумент.Вывести(ОбластьОсновное);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
		ВставлятьРазделительСтраниц = Истина;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция УдалитьЛидирующиеНули(Номер)
	Результат = Номер;
	Пока СтрНачинаетсяС(Результат, "0") Цикл
		Результат = Сред(Результат, 2);
	КонецЦикла;
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли
