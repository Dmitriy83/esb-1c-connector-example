#Область СлужебныйПрограммныйИнтерфейс

Процедура шинаОбменСШиной1С() Экспорт
	
	СервисыИнтеграции.ВыполнитьОбработку();

КонецПроцедуры

Функция ПолучитьСтрокуИзПотока(ВходящийПоток) Экспорт

	РазмерБуфераПоУмолчанию = 1024;
	БуферДвоичныхДанных  = Новый БуферДвоичныхДанных(0);
	Позиция = 0;
	Пока Истина Цикл
		ВременныйБуфер = Новый БуферДвоичныхДанных(РазмерБуфераПоУмолчанию);
	
		БайтБылоПрочитано = ВходящийПоток.Прочитать(ВременныйБуфер, 0, РазмерБуфераПоУмолчанию);
		Позиция = Позиция + БайтБылоПрочитано;
		Если БайтБылоПрочитано > 0 Тогда
			БуферДвоичныхДанных = БуферДвоичныхДанных.Соединить(ВременныйБуфер);
		КонецЕсли;
		Если БайтБылоПрочитано < РазмерБуфераПоУмолчанию Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;;
	
	Return СокрЛП(ПолучитьСтрокуИзБуфераДвоичныхДанных(БуферДвоичныхДанных, КодировкаТекста.UTF8));
	
КонецФункции 

Функция ИмяСобытияЖР() Экспорт
	Возврат "Шина 1С";
КонецФункции

Процедура УдалитьСкрытыеСимволыВКонцеСообщения(СообщениеСтрока) Экспорт

	ЗакрывающийТэг = "</Message>";
	ПозицияКонцаСообщения = Найти(СообщениеСтрока, ЗакрывающийТэг);
	Если ПозицияКонцаСообщения > 0 Тогда
		СообщениеСтрока = Лев(СообщениеСтрока, ПозицияКонцаСообщения + СтрДлина(ЗакрывающийТэг) - 1);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти