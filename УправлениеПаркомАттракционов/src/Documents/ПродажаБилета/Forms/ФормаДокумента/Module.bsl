// @strict-types


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкидкаПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	Объект.БаллыКСписанию = Объект.ПозицииПродажи.Итог("Сумма") - Объект.СуммаДокумента;
КонецПроцедуры

&НаКлиенте
Процедура ЭтоЛьготныйПериодПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПозицииПродажи

&НаКлиенте
Процедура ПозицииПродажиНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПозицииПродажи.ТекущиеДанные;
	
	//@skip-check unknown-method-property
	ТекущиеДанные.Цена = ЦенаНоменклатуры(ТекущиеДанные.Номенклатура, Объект.Дата);
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПродажиКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПозицииПродажи.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ПозицииПродажиЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПозицииПродажи.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПродажиПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.ПозицииПродажи.Итог("Сумма") - Объект.БаллыКСписанию;
	Элементы.ДекорацияСкидка.Заголовок = "";
	Если Объект.ЭтоЛьготныйПериод Тогда
		СуммаСкидки = Объект.СуммаДокумента * 0.1;
		Объект.СуммаДокумента = Объект.СуммаДокумента - СуммаСкидки;
		Элементы.ДекорацияСкидка.Заголовок = Строка(СуммаСкидки);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуСтроки(ДанныеСтроки)
	
	ДанныеСтроки.Сумма = ДанныеСтроки.Цена * ДанныеСтроки.Количество;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЦенаНоменклатуры(Знач Номенклатура, Знач Период)
	
	Возврат РегистрыСведений.ЦеныНоменклатуры.ЦенаНоменклатуры(Номенклатура, Период)
	
КонецФункции

#КонецОбласти
