﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА

#Область ОбработчикиСобытийОбъекта

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.БалансОбъектовСтроительства.Записывать = Истина;
	
	Движение = Движения.БалансОбъектовСтроительства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Объект = Объект;
	Движение.Контрагент = Контрагент;
	Движение.ТипПлатежа = ТипПлатежа;
	Движение.СтатьяДоходовРасходов = СтатьяРасходов;
	Движение.Количество = Сумма;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Объекты") Тогда
		Объект = ДанныеЗаполнения.Ссылка;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Сумма = 0;
	Для Каждого Строка Из Состав Цикл
		Сумма = Сумма + Строка.Стоимость;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти