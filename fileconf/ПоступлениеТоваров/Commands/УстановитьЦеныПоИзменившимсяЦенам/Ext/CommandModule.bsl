﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗначенияЗаполнения = Новый Структура;
    ЗначенияЗаполнения.Вставить("Действие", "УстановкаЦенПоИзмененнымЦенам");
	ЗначенияЗаполнения.Вставить("Ссылка",  ПараметрКоманды);
		
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ФормаДокумента",
			Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения),
			,
			Новый УникальныйИдентификатор);
	
КонецПроцедуры
