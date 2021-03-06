﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы "Внешние обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюПечать);
	
	ДатаОбновленияСостоянияОплатыИПоступления = Константы.ДатаОбновленияСостоянияОплатыИПоступления.Получить();
	Если НачалоДня(ТекущаяДатаСеанса()) > НачалоДня(ДатаОбновленияСостоянияОплатыИПоступления) Тогда
		Элементы.ГруппаПодвал.Видимость = Истина;
	Иначе
		Элементы.ГруппаПодвал.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация   = Настройки.Получить("Организация");
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	Магазин       = Настройки.Получить("Магазин");
	Ответственный = Настройки.Получить("Ответственный");
	Контрагент    = Настройки.Получить("Контрагент");
	
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Ответственный");
	УстановитьОтборДинамическогоСписка("Контрагент");
	УстановитьОтборДинамическогоСписка("Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Магазин");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Ответственный");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Контрагент");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Организация");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеОплатыИПоступления(Команда)
	
	ОбновитьСостояниеОплатыИПоступленияСервер();
	
	ПоказатьОповещениеПользователя(
			,
			,
			НСтр("ru='Статусы просрочки оплаты успешно обновлены'"),
			БиблиотекаКартинок.Информация32);
	Элементы.ГруппаПодвал.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список, 
		ИмяРеквизита, 
		ЭтаФорма[ИмяРеквизита], 
		ЗначениеЗаполнено(ЭтаФорма[ИмяРеквизита]));
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьСостояниеОплатыИПоступленияСервер()
	ЗакупкиСервер.ОбновлениеСостоянияОплатыИПоступления();
КонецПроцедуры

#КонецОбласти
