///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УпрощенныйИнтерфейс() Тогда
		КлючВарианта = "ПраваПользователейНаТаблицы";
		
		Отбор = Новый Структура;
		Отбор.Вставить("ГруппаДоступа", ПараметрКоманды);
		Отбор.Вставить("ВходВПрограммуРазрешен", Истина);
		
		ПараметрыОтчета = Новый Структура;
		ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыОтчета.Вставить("Отбор", Отбор);
		ПараметрыОтчета.Вставить("КлючВарианта", КлючВарианта);
		ПараметрыОтчета.Вставить("КлючНазначенияИспользования", КлючВарианта);
		
		ОткрытьФорму("Отчет.АнализПравДоступа.Форма", ПараметрыОтчета, ЭтотОбъект);
		
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Профиль", ПараметрКоманды);
		ОткрытьФорму("Справочник.ГруппыДоступа.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УпрощенныйИнтерфейс()
	
	Возврат УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	
КонецФункции

#КонецОбласти
