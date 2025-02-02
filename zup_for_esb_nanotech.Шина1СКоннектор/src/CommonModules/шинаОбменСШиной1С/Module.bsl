#Область СлужебныйПрограммныйИнтерфейс

Процедура шинаОбменСШиной1С() Экспорт
	
	СервисыИнтеграции.ВыполнитьОбработку();

КонецПроцедуры

Процедура шинаОбменСШиной1ССправочникПриЗаписиПриЗаписи(Источник, Отказ) Экспорт
	
	ОтправитьСообщениеВКаналШины1С(Источник.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтправитьСообщениеВКаналШины1С(СсылкаДляВыгрузки)

	Сообщение = СервисыИнтеграции.шинаСервисИнтеграции.СоздатьСообщение();
	Сообщение.Параметры.Вставить("Type", "SomeMessageType");
	Поток = Сообщение.ПолучитьТелоКакПоток();    
	
	Буфер = ПолучитьБуферДвоичныхДанныхИзСтроки(СериализоватьОбъектВEnterpriseData(СсылкаДляВыгрузки)); 
	Поток.Записать(Буфер, 0, Буфер.Размер);
	Поток.СброситьБуферы();
	Поток.Закрыть();
	
	СервисыИнтеграции.шинаСервисИнтеграции.Основной_ОдинИсточник_ДваПриемника_ИзЗУП.ОтправитьСообщение(Сообщение);
	
КонецПроцедуры

Функция СериализоватьОбъектВEnterpriseData(СсылкаДляВыгрузки)
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Отправка");	
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = Ложь;
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными();
	КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
	КомпонентыОбмена.ВерсияФорматаОбмена = "1.16";
	КомпонентыОбмена.XMLСхема = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/" + КомпонентыОбмена.ВерсияФорматаОбмена;
	КомпонентыОбмена.МенеджерОбмена = ОбщегоНазначения.ОбщийМодуль("МенеджерОбменаЧерезУниверсальныйФормат");
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	ОбменДаннымиXDTOСервер.ОткрытьФайлВыгрузки(КомпонентыОбмена);  	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		Возврат КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	Попытка
		КомпонентыОбмена.МенеджерОбмена.ПередКонвертацией(КомпонентыОбмена);
	Исключение
		Возврат КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	КонецПопытки;
	
	ОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, СсылкаДляВыгрузки);
	
	Попытка
		КомпонентыОбмена.МенеджерОбмена.ПослеКонвертации(КомпонентыОбмена);
	Исключение
		Возврат КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	КонецПопытки;
	
	КомпонентыОбмена.ФайлОбмена.ЗаписатьКонецЭлемента(); // Body
	КомпонентыОбмена.ФайлОбмена.ЗаписатьКонецЭлемента(); // Message
	
	Если КомпонентыОбмена.СостояниеОбменаДанными.РезультатВыполненияОбмена = Неопределено Тогда
		КомпонентыОбмена.СостояниеОбменаДанными.РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.Выполнено;
	КонецЕсли;
	
	Возврат КомпонентыОбмена.ФайлОбмена.Закрыть();

КонецФункции

#КонецОбласти