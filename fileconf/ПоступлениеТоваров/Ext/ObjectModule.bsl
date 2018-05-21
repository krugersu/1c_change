﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ПоступлениеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСебестоимостьНоменклатуры(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияНоменклатураПоставщиков(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСебестоимостьПоставкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗакупкиСервер.ОтразитьЗаказыТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗакупкиСервер.ОтразитьЗакупкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// Климов 11.01.2017 { Проверка заполнения транспортной тары
	Если НЕ Отказ Тогда 
		Отказ = крюТранспортнаяТара.ПроверкаЗаполненияРеквизитаТранспортнаяТара(ЭтотОбъект.Ссылка);	
	КонецЕсли;	
	//} Климов 11.01.2017
	
	ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
	Если ЗначениеЗаполнено(ЗаказПоставщику) Тогда
		ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(ЗаказПоставщику);
	Иначе
		ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Справочники.СерийныеНомера.ОчиститьВДокументеНеиспользуемыеСерийныеНомера(Товары, СерийныеНомера);
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	ОбщегоНазначенияРТ.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект,Документы.ПоступлениеТоваров.ПараметрыУказанияСерий(ЭтотОбъект));
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
		ЭтотОбъект,
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС),
		"СуммаДокумента");
		
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		УстановитьСтатусЗаказаПоставщикуЗакрыт(Истина);
		Если НЕ ЗначениеЗаполнено(ЗаказПоставщику) Тогда
			
			ГрафикОплатыКонтрагента = ЭтотОбъект.Контрагент.ГрафикОплаты;
			
			ЗакупкиСервер.ДобавитьЭтапОплаты(ЭтотОбъект, ГрафикОплатыКонтрагента, Дата);
			
		КонецЕсли;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		УстановитьСтатусЗаказаПоставщикуЗакрыт(Ложь);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ИнтеграцияГИСМ_РТ.ЗаполнитьПризнакиЕстьМаркируемаяПродукцияИЕстьКиЗ(ЭтотОбъект, "Товары"));
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		ЗаказПоставщику = ДанныеЗаполнения;
		
		ЕстьПоступление = Ложь;
		ПроверитьСуществованиеПоступленийПоЗаказу(ЕстьПоступление, Истина);
		
		Если ЕстьПоступление Тогда
			
			ТекстОшибки = НСтр("ru='По документу %1 уже существуют документы поступления товаров. Ввод на основании документа невозможен'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЗаказПоставщику);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект,
			ДанныеЗаполнения, 
			"Склад, Магазин, Контрагент, УчитыватьНДС, ЦенаВключаетНДС, Организация");
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Товары, Товары);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		ТТНВходящаяЕГАИС = ДанныеЗаполнения;
		
		СтатусОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТТНВходящаяЕГАИС, "СтатусОбработки");
		Если СтатусОбработки = Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктОтказа Тогда
			ТекстОшибки = НСтр("ru='Поступление товаров для данной ТТН ЕГАИС не требуется.'");
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ЕстьПоступление = Ложь;
		ПроверитьСуществованиеПоступленийПоТТН(ЕстьПоступление, Истина);
		
		Если ЕстьПоступление Тогда
			
			ТекстОшибки = НСтр("ru='По документу %1 уже существуют документы поступления товаров. Ввод на основании документа невозможен'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ТТНВходящаяЕГАИС);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ЗаполнитьПоступлениеПоТТН();
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаказПоставщику = Документы.ЗаказПоставщику.ПустаяСсылка();
	
	ТТНВходящаяЕГАИС = Документы.ТТНВходящаяЕГАИС.ПустаяСсылка();
	
	МассивСтрокДляУдаления = Новый Массив();
	Для Каждого СтрокаТовары Из Товары Цикл
		Если Не СтрокаТовары.АлкогольнаяПродукция.Пустая() или СтрокаТовары.Номенклатура.АлкогольнаяПродукция Тогда
			МассивСтрокДляУдаления.Добавить(СтрокаТовары);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаУдаления Из МассивСтрокДляУдаления Цикл
		Товары.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Серии.Очистить();
	ЭтапыОплат.Очистить();
	СерийныеНомера.Очистить();
	ТоварыПоДаннымПоставщика.Очистить();
	
	ЕстьРасхождения = Ложь;
	
	КоличествоТоваров = Товары.Количество();
	Если НЕ КоличествоТоваров = 0 Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "КлючСвязиСерийныхНомеров");
	КонецЕсли;
	
	ПредъявленСчетФактура = Ложь;
	НомерСчетаФактуры = "";
	ДатаСчетаФактуры = Неопределено;
	ЕстьКиЗГИСМ      = Ложь;
	
	ИнициализироватьДокумент();
	
	АссортиментСервер.ПроверитьАссортиментТаблицыТоваровДокументаЗакупки(Магазин, Товары, Дата);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьСуществованиеПоступленийПоЗаказу(Отказ);
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Магазин.СкладУправляющейСистемы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ИмяТЧ","ТоварыПоДаннымПоставщика");
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.ПоступлениеТоваров.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	
	Если НЕ ПредъявленСчетФактура Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерСчетаФактуры");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаСчетаФактуры");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ВидПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДатаПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДокументВзаимозачета");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Сумма");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеТЧПриНаличииОбменаСУправлениемТорговлей(
		ЭтотОбъект,
		Отказ);
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
	МаркетинговыеАкцииСервер.ПроверитьДвиженияСерийныхНомеров(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
	Если Не ЗначениеЗаполнено(ЗаказПоставщику) Тогда
		ЗакупкиСервер.СортироватьТабличнуюЧастьЭтапыОплат(ЭтотОбъект, Отказ);
		ЗакупкиСервер.ПроверитьТабличнуюЧастьЭтапыОплат(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ПроверитьЗаполнениеСуммы(Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверяет существование документа "Поступление товаров" по заказу поставщику.
// 
// Параметры:
//  Отказ                     - флаг отказа в проведении,
//
Процедура ПроверитьСуществованиеПоступленийПоЗаказу(Отказ, ТолькоРезультат = Ложь)
	
	Если ЗначениеЗаполнено(ЗаказПоставщику) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ПоступлениеТоваров.Ссылка) КАК ПоступлениеТоваров
		|ИЗ
		|	Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
		|ГДЕ
		|	ПоступлениеТоваров.ЗаказПоставщику = &ЗаказПоставщику
		|	И ПоступлениеТоваров.Ссылка <> &ПоступлениеТоваров
		|	И ПоступлениеТоваров.Проведен");
		
		Запрос.УстановитьПараметр("ЗаказПоставщику", ЗаказПоставщику);
		Запрос.УстановитьПараметр("ПоступлениеТоваров", Ссылка);
		
		РезультатЗапросаПроверкаЗаказа = Запрос.Выполнить();
		
		Если НЕ РезультатЗапросаПроверкаЗаказа.Пустой() Тогда
			
			Если ТолькоРезультат Тогда
				
				Отказ = Истина;
				
			Иначе
				
				ТекстСообщения = НСтр("ru = 'Существуют документы поступления, оформленные по документу %ЗаказПоставщику% :'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ЗаказПоставщику%",ЗаказПоставщику);
				
				ВыборкаРезультатаПроверкаЗаказа = РезультатЗапросаПроверкаЗаказа.Выбрать();
				
				Пока ВыборкаРезультатаПроверкаЗаказа.Следующий() Цикл
					
					ТекстСообщения = ТекстСообщения + Символы.ПС + "%ПоступлениеТоваров%";
					ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ПоступлениеТоваров%",
												ВыборкаРезультатаПроверкаЗаказа.ПоступлениеТоваров);
					
				КонецЦикла;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ЗаказПоставщику",
					,
					Отказ);
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура проверяет существование документа "Поступление товаров" по входящей ТТН.
// 
Процедура ПроверитьСуществованиеПоступленийПоТТН(Отказ, ТолькоРезультат = Ложь)
	
	Если ЗначениеЗаполнено(ТТНВходящаяЕГАИС) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ПоступлениеТоваров.Ссылка) КАК ПоступлениеТоваров
		|ИЗ
		|	Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
		|ГДЕ
		|	ПоступлениеТоваров.ТТНВходящаяЕГАИС = &ТТНВходящаяЕГАИС
		|	И ПоступлениеТоваров.Ссылка <> &ПоступлениеТоваров
		|	И НЕ ПоступлениеТоваров.ПометкаУдаления");
		
		Запрос.УстановитьПараметр("ТТНВходящаяЕГАИС", ТТНВходящаяЕГАИС);
		Запрос.УстановитьПараметр("ПоступлениеТоваров", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Если ТолькоРезультат Тогда
				
				Отказ = Истина;
				
			Иначе
				
				ТекстСообщения = НСтр("ru = 'Существуют документы поступления, оформленные по документу %ТТН% :'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТТН%", ТТНВходящаяЕГАИС);
				
				Выборка = РезультатЗапроса.Выбрать();
				
				Пока Выборка.Следующий() Цикл
					
					ТекстСообщения = ТекстСообщения + Символы.ПС + "%ПоступлениеТоваров%";
					ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ПоступлениеТоваров%",
												Выборка.ПоступлениеТоваров);
					
				КонецЦикла;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ТТНВходящаяЕГАИС",
					,
					Отказ);
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет заполнение реквизита "Сумма" в табличной части "Товары"
//
// Параметры:
//  Отказ  - Булево - флаг отказа в проведении
//
Процедура ПроверитьЗаполнениеСуммы(Отказ)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки,
	|	ТаблицаТоваров.Сумма
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки,
	|	ТаблицаТоваров.Сумма
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.Сумма = 0";
	
	ТаблицаТоваров = ЭтотОбъект.Товары.Выгрузить(, "НомерСтроки,Сумма");
	
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	
	ШаблонСообщения = НСтр("ru='Не заполнена колонка ""%ПредставлениеРеквизита%"" в строке %НомерСтроки% списка ""Товары""'");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%НомерСтроки%", Выборка.НомерСтроки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеРеквизита%", ?(ЭтотОбъект.УчитыватьНДС, НСтр("ru = 'Всего'"), НСтр("ru = 'Сумма'")));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "Сумма"),
			"Объект",
			Отказ);
			
	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеСуммы()

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("Склад")
			И НЕ ЗначениеЗаполнено(Склад) Тогда
			Если ЗначениеЗаполнено(Магазин) Тогда
				Если НЕ Справочники.Склады.ПроверитьПринадлежностьСкладаМагазину(Магазин, ДанныеЗаполнения.Склад) Тогда
					ДанныеЗаполнения.Склад = Справочники.Склады.ПустаяСсылка();
				КонецЕсли;
			Иначе
				Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Склад, "Магазин");
			КонецЕсли;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Организация")
			И НЕ ЗначениеЗаполнено(Организация) Тогда
			БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения.Организация,,БанковскийСчетОрганизации);
		КонецЕсли;
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(Магазин,,Склад, Ответственный);
	Контрагент    = ЗначениеНастроекПовтИсп.ПолучитьПоставщикаПоУмолчанию(Ответственный, Контрагент);
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация,,БанковскийСчетОрганизации);
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
	
КонецПроцедуры

// Устанавливает статус "Закрыт" заказа поставщику.
//
Процедура УстановитьСтатусЗаказаПоставщикуЗакрыт(ЗначениеСтатуса)
	
	Если ЗначениеЗаполнено(ЗаказПоставщику) И НЕ ЗаказПоставщику.Закрыт = ЗначениеСтатуса Тогда
		
		ЗаказПоставщикуОбъект = ЗаказПоставщику.ПолучитьОбъект();
		ЗаказПоставщикуОбъект.Закрыт = ЗначениеСтатуса;
		Если ЗаказПоставщику.Проведен Тогда
			ЗаказПоставщикуОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			ЗаказПоставщикуОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ ЗначениеЗаполнено(ЭтотОбъект.ЗаказПоставщику) Тогда
		
		Массив.Добавить(Движения.РасчетыСПоставщиками);
		
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

// Заполняет текущий документ "Поступление товаров" по данным документа "ТТН (входящая)".
//
Процедура ЗаполнитьПоступлениеПоТТН()
	
	Запрос = Новый Запрос;
	// Емельянов_Д, ООО ТК Крюгер, 06.04.2017 {
	//
	// в типовом запросе в качестве Поставщика бралось значение из реквизита "Поставщик"
	// и если оно было пустое, то бралось значение из реквизита "Грузоотправитель"
	// После доработки в качестве Поставщика берется только Грузоотправитель
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.НомерТТН КАК НомерВходящегоДокумента,
	|	ТТНВходящаяЕГАИС.ДатаТТН КАК ДатаВходящегоДокумента,
	|	ТТНВходящаяЕГАИС.Ссылка КАК ТТНВходящаяЕГАИС,
	|	ТТНВходящаяЕГАИС.Магазин,
	|	ТТНВходящаяЕГАИС.Организация,
	|	ТТНВходящаяЕГАИС.Грузоотправитель КАК Поставщик
	|ПОМЕСТИТЬ ТаблицаВЗапросе
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВЗапросе.НомерВходящегоДокумента,
	|	ТаблицаВЗапросе.ДатаВходящегоДокумента,
	|	ТаблицаВЗапросе.ТТНВходящаяЕГАИС,
	|	ТаблицаВЗапросе.Магазин,
	|	ТаблицаВЗапросе.Организация,
	|	ВЫБОР
	|		КОГДА СоответствиеОрганизацийЕГАИС.Контрагент ЕСТЬ NULL 
	|			ТОГДА &КонтрагентЗаказа
	|		ИНАЧЕ СоответствиеОрганизацийЕГАИС.Контрагент
	|	КОНЕЦ КАК Контрагент
	|ИЗ
	|	ТаблицаВЗапросе КАК ТаблицаВЗапросе
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОрганизацийЕГАИС КАК СоответствиеОрганизацийЕГАИС
	|		ПО ТаблицаВЗапросе.Поставщик = СоответствиеОрганизацийЕГАИС.ОрганизацияЕГАИС";
	// } Емельянов_Д, ООО ТК Крюгер, 06.04.2017	
	Запрос.УстановитьПараметр("Ссылка", ТТНВходящаяЕГАИС);
	Запрос.УстановитьПараметр("ПустаяСсылкаПоставщика", Справочники.КлассификаторОрганизацийЕГАИС.ПустаяСсылка());
	Если ЗначениеЗаполнено(ЗаказПоставщику) Тогда
		Запрос.УстановитьПараметр("КонтрагентЗаказа", ЗаказПоставщику.Контрагент);
	Иначе
		Запрос.УстановитьПараметр("КонтрагентЗаказа", Справочники.Контрагенты.ПустаяСсылка());
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
	Ответственный             = Пользователи.ТекущийПользователь();
	Склад                     = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(Магазин,,, Ответственный);
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация,,);
	Контрагент                = ЗначениеНастроекПовтИсп.ПолучитьПоставщикаПоУмолчанию(Ответственный, Контрагент);
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
	
	УчитыватьНДС    = Истина;
	ЦенаВключаетНДС = Истина;
	ЗаказПоставщику = ЗаказПоставщику;
	
	ЗаполнитьТоварыПоступленияПоТТН();
	
КонецПроцедуры

Процедура ЗаполнитьТоварыПоступленияПоТТН() Экспорт
	
	ВыгрузкаТовары = Товары.Выгрузить();
	Товары.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИСТовары.АлкогольнаяПродукция,
	|	ТТНВходящаяЕГАИСТовары.Количество,
	|	ТТНВходящаяЕГАИСТовары.Количество КАК КоличествоУпаковок,
	|	ТТНВходящаяЕГАИСТовары.Сумма,
	|	ТТНВходящаяЕГАИСТовары.Цена,
	|	ТТНВходящаяЕГАИСТовары.ИдентификаторУпаковки,
	|	ТТНВходящаяЕГАИСТовары.ИдентификаторСтроки
	|ПОМЕСТИТЬ ТаблицаЕГАИС
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
	|ГДЕ
	|	ТТНВходящаяЕГАИСТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЕГАИС.АлкогольнаяПродукция,
	|	ТаблицаЕГАИС.Количество,
	|	ТаблицаЕГАИС.КоличествоУпаковок,
	|	ТаблицаЕГАИС.Сумма,
	|	ТаблицаЕГАИС.Цена,
	|	ТаблицаЕГАИС.ИдентификаторУпаковки,
	|	ТаблицаЕГАИС.ИдентификаторСтроки,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика,
	|	СоответствиеНоменклатурыЕГАИС.Упаковка,
	|	ВЫБОР
	|		КОГДА СоответствиеНоменклатурыЕГАИС.Номенклатура ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИскатьСоответствиеБезУпаковок
	|ПОМЕСТИТЬ ТаблицаСоответствий
	|ИЗ
	|	ТаблицаЕГАИС КАК ТаблицаЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ТаблицаЕГАИС.АлкогольнаяПродукция = СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция
	|			И ТаблицаЕГАИС.ИдентификаторУпаковки = СоответствиеНоменклатурыЕГАИС.ИдентификаторУпаковки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСоответствий.АлкогольнаяПродукция,
	|	ТаблицаСоответствий.Количество,
	|	ТаблицаСоответствий.КоличествоУпаковок,
	|	ТаблицаСоответствий.Сумма,
	|	ТаблицаСоответствий.Цена,
	|	ТаблицаСоответствий.ИдентификаторУпаковки,
	|	ТаблицаСоответствий.ИдентификаторСтроки,
	|	ТаблицаСоответствий.Номенклатура,
	|	ТаблицаСоответствий.Характеристика,
	|	ТаблицаСоответствий.Упаковка,
	|	ТаблицаСоответствий.ИскатьСоответствиеБезУпаковок
	|ПОМЕСТИТЬ ТаблицаПодготовкаДополнительногоПоиска
	|ИЗ
	|	ТаблицаСоответствий КАК ТаблицаСоответствий
	|ГДЕ
	|	ТаблицаСоответствий.ИскатьСоответствиеБезУпаковок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДополнительногноПоиска.АлкогольнаяПродукция,
	|	ВЫБОР
	|		КОГДА СоответствиеНоменклатурыЕГАИС.Упаковка = &УпаковкиПустоеЗначение
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ПараметрРанжирования,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Упаковка
	|ИЗ
	|	ТаблицаПодготовкаДополнительногоПоиска КАК ТаблицаДополнительногноПоиска
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ТаблицаДополнительногноПоиска.АлкогольнаяПродукция = СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПараметрРанжирования
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСоответствий.АлкогольнаяПродукция,
	|	ТаблицаСоответствий.Количество,
	|	ТаблицаСоответствий.КоличествоУпаковок,
	|	ТаблицаСоответствий.Сумма,
	|	ТаблицаСоответствий.Цена,
	|	ТаблицаСоответствий.ИдентификаторУпаковки,
	|	ТаблицаСоответствий.ИдентификаторСтроки,
	|	ТаблицаСоответствий.Номенклатура,
	|	ТаблицаСоответствий.Характеристика,
	|	ТаблицаСоответствий.Упаковка,
	|	ТаблицаСоответствий.ИскатьСоответствиеБезУпаковок
	|ИЗ
	|	ТаблицаСоответствий КАК ТаблицаСоответствий";
	
	Запрос.УстановитьПараметр("Ссылка", ТТНВходящаяЕГАИС);
	Запрос.УстановитьПараметр("УпаковкиПустоеЗначение", Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаДанныеЕГАИС = Результат[4].Выгрузить();
	ТаблицаДополнительныхДанные = Результат[3].Выгрузить();
	
	Для каждого СтрокаДанныхЕГАИС Из ТаблицаДанныеЕГАИС Цикл
		//СтрокаТаблицы = ТоварыПоДаннымПоставщика.Добавить();
		СтрокаТаблицы = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаДанныхЕГАИС);
		
		Если СтрокаДанныхЕГАИС.ИскатьСоответствиеБезУпаковок Тогда
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("АлкогольнаяПродукция", СтрокаДанныхЕГАИС.АлкогольнаяПродукция);
			
			МассивСтрок = ТаблицаДополнительныхДанные.НайтиСтроки(СтруктураПоиска);
			
			Если МассивСтрок.Количество() > 0 Тогда
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, МассивСтрок[0]);
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЦикла;
	
	Для Каждого СтрокаТовары Из ВыгрузкаТовары Цикл
		Если СтрокаТовары.АлкогольнаяПродукция.Пустая() и не СтрокаТовары.Номенклатура.АлкогольнаяПродукция Тогда
			ЗаполнитьЗначенияСвойств(Товары.Добавить(), СтрокаТовары);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",  УчитыватьНДС);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(ЭтотОбъект));
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	СтруктураТЧ = Новый Структура;
	//СтруктураТЧ.Вставить("СтрокиТЧ" , ТоварыПоДаннымПоставщика);
	СтруктураТЧ.Вставить("СтрокиТЧ" , Товары);
	ОбработкаТабличнойЧастиТоварыСервер.ПриИзмененииРеквизитовВТЧСервер(СтруктураТЧ, СтруктураДействий, Неопределено);
	
КонецПроцедуры;

#КонецОбласти

#КонецЕсли
