﻿
///////////////////////////////////////////////////////////////////////////////
// ИМПОРТ СУЩНОСТЕЙ

#Область ИмпортСущностей

// Импорт справочника "Единицы измерения" из CarWashCloud
//
// Параметры:
//  Соединение		 - HTTPСоединение - Соединение с сервером
//  ТекстСообщения	 - Неопределено, Строка - Текст ошибки
// 
// Возвращаемое значение:
//  Булево - Истина, если импорт успешно завершен
//
Функция Импорт_ЕдиницыИзмерения(Соединение, ТекстСообщения = Неопределено) Экспорт
	
	Результат = Ложь;
	
	HttpЗапрос = Новый HTTPЗапрос("api/catalogs/units");
	
	ОтветСервера = Соединение.Получить(HttpЗапрос);
	Если ОтветСервера.КодСостояния = 200 Тогда	
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.ОткрытьПоток(ОтветСервера.ПолучитьТелоКакПоток());
		ЕдиницыИзмеренияCloud = ПрочитатьJSON(ЧтениеJSON);
		
		Если ЕдиницыИзмеренияCloud.Количество() > 0 Тогда
			// Получение данных информационной базы
			Запрос = Новый Запрос();
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ЕдиницыИзмерения.CloudID КАК CloudID,
				|	ЕдиницыИзмерения.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения";
			ЭлементыИБ = Запрос.Выполнить().Выгрузить();
			ЭлементыИБ.Индексы.Добавить("CloudID");
			
			НачатьТранзакцию();
			Попытка			
				Для Каждого ЭлементКоллекции Из ЕдиницыИзмеренияCloud Цикл
					Найденное = ЭлементыИБ.Найти(Формат(ЭлементКоллекции.Id, "ЧГ=0"), "CloudID");
					
					ЕдиницаИзмеренияОбъект = Неопределено;
					Если Найденное = Неопределено Тогда
						ЕдиницаИзмеренияОбъект = Справочники.ЕдиницыИзмерения.СоздатьЭлемент();
						ЕдиницаИзмеренияОбъект.CloudID = ЭлементКоллекции.Id;
						ЕдиницаИзмеренияОбъект.Код = ЭлементКоллекции.code;
					Иначе
						ЕдиницаИзмеренияОбъект = Найденное.Ссылка.ПолучитьОбъект();
					КонецЕсли;
										
					ЕдиницаИзмеренияОбъект.Наименование = ЭлементКоллекции.name;
					ЕдиницаИзмеренияОбъект.Комментарий = ЭлементКоллекции.comment;
					ЕдиницаИзмеренияОбъект.Записать();					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
				Результат = Истина;
			Исключение
				ТекстСообщения = НСтр("ru = 'Единицы измерения: ошибка обработки данных '") + ОписаниеОшибки();
				ОтменитьТранзакцию();				
			КонецПопытки;
		КонецЕсли;
				
		ЧтениеJSON.Закрыть();
	Иначе
		ТекстСообщения = НСтр("ru = 'Единицы измерения: ошибка получения данных'");
	КонецЕсли;
	
	Возврат Результат;
			
КонецФункции

// Импорт справочника "Города" из CarWashCloud
//
// Параметры:
//  Соединение		 - HTTPСоединение - Соединение с сервером
//  ТекстСообщения	 - Неопределено, Строка - Текст ошибки
// 
// Возвращаемое значение:
//  Булево - Истина, если импорт успешно завершен
//
Функция Импорт_Города(Соединение, ТекстСообщения = Неопределено) Экспорт
	
	Результат = Ложь;
	//http://146.66.14.82:8081/api/catalogs/cities
	
	HttpЗапрос = Новый HTTPЗапрос("api/catalogs/cities");
	
	ОтветСервера = Соединение.Получить(HttpЗапрос);
	Если ОтветСервера.КодСостояния = 200 Тогда	
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.ОткрытьПоток(ОтветСервера.ПолучитьТелоКакПоток());
		ГородаCloud = ПрочитатьJSON(ЧтениеJSON);
		
		Если ГородаCloud.Количество() > 0 Тогда
			// Получение данных информационной базы
			Запрос = Новый Запрос();
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	Города.CloudID КАК CloudID,
				|	Города.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.Города КАК Города";
			ЭлементыИБ = Запрос.Выполнить().Выгрузить();
			ЭлементыИБ.Индексы.Добавить("CloudID");
			
			НачатьТранзакцию();
			Попытка			
				Для Каждого ЭлементКоллекции Из ГородаCloud Цикл
					Найденное = ЭлементыИБ.Найти(Формат(ЭлементКоллекции.Id, "ЧГ=0"), "CloudID");
					
					ГородаОбъект = Неопределено;
					Если Найденное = Неопределено Тогда
						ГородаОбъект = Справочники.Города.СоздатьЭлемент();
						ГородаОбъект.CloudID = ЭлементКоллекции.Id;
						ГородаОбъект.УстановитьНовыйКод();
					Иначе
						ГородаОбъект = Найденное.Ссылка.ПолучитьОбъект();
					КонецЕсли;
										
					ГородаОбъект.Наименование = ЭлементКоллекции.name;
					ГородаОбъект.Комментарий = ЭлементКоллекции.comment;
					ГородаОбъект.Записать();					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
				Результат = Истина;
			Исключение
				ТекстСообщения = НСтр("ru = 'Города: ошибка обработки данных '") + ОписаниеОшибки();
				ОтменитьТранзакцию();				
			КонецПопытки;
		КонецЕсли;
				
		ЧтениеJSON.Закрыть();
	Иначе
		ТекстСообщения = НСтр("ru = 'Города: ошибка получения данных'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Импорт справочника "Группы контрагентов" из CarWashCloud
//
// Параметры:
//  Соединение		 - HTTPСоединение - Соединение с сервером
//  ТекстСообщения	 - Неопределено, Строка - Текст ошибки
// 
// Возвращаемое значение:
//  Булево - Истина, если импорт успешно завершен
//
Функция Импорт_ГруппыКонтрагентов(Соединение, ТекстСообщения = Неопределено) Экспорт
	
	Результат = Ложь;
	//http://146.66.14.82:8081/api/catalogs/groupscontractor
	
	HttpЗапрос = Новый HTTPЗапрос("api/catalogs/groupscontractor");
	
	ОтветСервера = Соединение.Получить(HttpЗапрос);
	Если ОтветСервера.КодСостояния = 200 Тогда	
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.ОткрытьПоток(ОтветСервера.ПолучитьТелоКакПоток());
		ГруппыКонтрагентовCloud = ПрочитатьJSON(ЧтениеJSON);
		
		Если ГруппыКонтрагентовCloud.Количество() > 0 Тогда
			// Получение данных информационной базы
			Запрос = Новый Запрос();
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ГруппыКонтрагентов.CloudID КАК CloudID,
				|	ГруппыКонтрагентов.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.ГруппыКонтрагентов КАК ГруппыКонтрагентов";
			ЭлементыИБ = Запрос.Выполнить().Выгрузить();
			ЭлементыИБ.Индексы.Добавить("CloudID");
			
			НачатьТранзакцию();
			Попытка			
				Для Каждого ЭлементКоллекции Из ГруппыКонтрагентовCloud Цикл
					Найденное = ЭлементыИБ.Найти(Формат(ЭлементКоллекции.Id, "ЧГ=0"), "CloudID");
					
					ГруппаКонтрагентовОбъект = Неопределено;
					Если Найденное = Неопределено Тогда
						ГруппаКонтрагентовОбъект = Справочники.ГруппыКонтрагентов.СоздатьЭлемент();
						ГруппаКонтрагентовОбъект.CloudID = ЭлементКоллекции.Id;
						ГруппаКонтрагентовОбъект.УстановитьНовыйКод();
					Иначе
						ГруппаКонтрагентовОбъект = Найденное.Ссылка.ПолучитьОбъект();
					КонецЕсли;
										
					ГруппаКонтрагентовОбъект.Наименование = ЭлементКоллекции.name;
					ГруппаКонтрагентовОбъект.Комментарий = ЭлементКоллекции.comment;
					ГруппаКонтрагентовОбъект.Записать();					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
				Результат = Истина;
			Исключение
				ТекстСообщения = НСтр("ru = 'Группы контрагентов: ошибка обработки данных '") + ОписаниеОшибки();
				ОтменитьТранзакцию();				
			КонецПопытки;
		КонецЕсли;
				
		ЧтениеJSON.Закрыть();
	Иначе
		ТекстСообщения = НСтр("ru = 'Группы контрагентов: ошибка получения данных'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Импорт справочника "Номенклатура" из CarWashCloud
//
// Параметры:
//  Соединение		 - HTTPСоединение - Соединение с сервером
//  ТекстСообщения	 - Неопределено, Строка - Текст ошибки
// 
// Возвращаемое значение:
//  Булево - Истина, если импорт успешно завершен
//
Функция Импорт_Номенклатура(Соединение, ТекстСообщения = Неопределено) Экспорт
	
	Результат = Ложь;
	//http://146.66.14.82:8081/api/catalogs/nomenclatures
	
	HttpЗапрос = Новый HTTPЗапрос("api/catalogs/nomenclatures");
	
	ОтветСервера = Соединение.Получить(HttpЗапрос);
	Если ОтветСервера.КодСостояния = 200 Тогда	
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.ОткрытьПоток(ОтветСервера.ПолучитьТелоКакПоток());
		НоменклатураCloud = ПрочитатьJSON(ЧтениеJSON);
		
		Если НоменклатураCloud.Количество() > 0 Тогда
			// Получение данных информационной базы
			Запрос = Новый Запрос();
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	Номенклатура.CloudID КАК CloudID,
				|	Номенклатура.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.Номенклатура КАК Номенклатура";
			ЭлементыИБ = Запрос.Выполнить().Выгрузить();
			ЭлементыИБ.Индексы.Добавить("CloudID");
			
			НачатьТранзакцию();
			Попытка			
				Для Каждого ЭлементКоллекции Из НоменклатураCloud Цикл
					Найденное = ЭлементыИБ.Найти(Формат(ЭлементКоллекции.Id, "ЧГ=0"), "CloudID");
					
					НоменклатураОбъект = Неопределено;
					Если Найденное = Неопределено Тогда
						НоменклатураОбъект = Справочники.Номенклатура.СоздатьЭлемент();
						НоменклатураОбъект.CloudID = ЭлементКоллекции.Id;
						НоменклатураОбъект.УстановитьНовыйКод();
					Иначе
						НоменклатураОбъект = Найденное.Ссылка.ПолучитьОбъект();
					КонецЕсли;
										
					НоменклатураОбъект.Наименование = ЭлементКоллекции.name;
					НоменклатураОбъект.Комментарий = ЭлементКоллекции.comment;
					НоменклатураОбъект.ЦенаПоУмолчанию = ЭлементКоллекции.price;
					НоменклатураОбъект.Артикул = ЭлементКоллекции.article;
					Если ТипЗнч(ЭлементКоллекции.unit) = Тип("Структура") Тогда
						НоменклатураОбъект.ЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.НайтиПоРеквизиту(
							"CloudID", Формат(ЭлементКоллекции.unit.id, "ЧГ=0"));
						Если ЗначениеЗаполнено(ЭлементКоллекции.unit.id) 
							И НЕ ЗначениеЗаполнено(НоменклатураОбъект.ЕдиницаИзмерения) Тогда
							ВызватьИсключение НСтр("ru = 'Не найдена единица измерения'");
						КонецЕсли;
					КонецЕсли;
					НоменклатураОбъект.Вид = 
						Перечисления.ВидыНоменклатуры.ПоПредставлениюCloud(ЭлементКоллекции.type);
												
					НоменклатураОбъект.Записать();					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
				Результат = Истина;
			Исключение
				ТекстСообщения = НСтр("ru = 'Номенклатура: ошибка обработки данных '") + ОписаниеОшибки();
				ОтменитьТранзакцию();				
			КонецПопытки;
		КонецЕсли;
				
		ЧтениеJSON.Закрыть();
	Иначе
		ТекстСообщения = НСтр("ru = 'Номенклатура: ошибка получения данных'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Импорт справочника "Комплекты" из CarWashCloud
//
// Параметры:
//  Соединение		 - HTTPСоединение - Соединение с сервером
//  ТекстСообщения	 - Неопределено, Строка - Текст ошибки
// 
// Возвращаемое значение:
//  Булево - Истина, если импорт успешно завершен
//
Функция Импорт_Комплекты(Соединение, ТекстСообщения = Неопределено) Экспорт
	
	Результат = Ложь;
	//http://146.66.14.82:8081/api/catalogs/kits
	
	HttpЗапрос = Новый HTTPЗапрос("api/catalogs/kits");
	
	ОтветСервера = Соединение.Получить(HttpЗапрос);
	Если ОтветСервера.КодСостояния = 200 Тогда	
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.ОткрытьПоток(ОтветСервера.ПолучитьТелоКакПоток());
		КомплектыCloud = ПрочитатьJSON(ЧтениеJSON);
		
		Если КомплектыCloud.Количество() > 0 Тогда
			// Получение данных информационной базы
			Запрос = Новый Запрос();
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	Комплекты.CloudID КАК CloudID,
				|	Комплекты.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.Комплекты КАК Комплекты";
			ЭлементыИБ = Запрос.Выполнить().Выгрузить();
			ЭлементыИБ.Индексы.Добавить("CloudID");
			
			НачатьТранзакцию();
			Попытка			
				Для Каждого ЭлементКоллекции Из КомплектыCloud Цикл
					Найденное = ЭлементыИБ.Найти(Формат(ЭлементКоллекции.Id, "ЧГ=0"), "CloudID");
					
					КомплектОбъект = Неопределено;
					Если Найденное = Неопределено Тогда
						КомплектОбъект = Справочники.Комплекты.СоздатьЭлемент();
						КомплектОбъект.CloudID = ЭлементКоллекции.Id;
						КомплектОбъект.УстановитьНовыйКод();
					Иначе
						КомплектОбъект = Найденное.Ссылка.ПолучитьОбъект();
					КонецЕсли;
										
					КомплектОбъект.Наименование = ЭлементКоллекции.name;
					КомплектОбъект.Комментарий = ЭлементКоллекции.comment;
					
					// Детальное получение
					HttpЗапрос = Новый HTTPЗапрос("api/catalogs/kits/" + КомплектОбъект.CloudID);
					ОтветСервера = Соединение.Получить(HttpЗапрос);
					Если ОтветСервера.КодСостояния = 200 Тогда
						ЧтениеJSON.ОткрытьПоток(ОтветСервера.ПолучитьТелоКакПоток());
						КомплектCloud = ПрочитатьJSON(ЧтениеJSON);
						
						Если ТипЗнч(КомплектCloud.main) = Тип("Структура") Тогда
							КомплектОбъект.ОсновнойМатериал = Справочники.Номенклатура.НайтиПоCloudId(
								Формат(КомплектCloud.main.id, "ЧГ=0"));
						КонецЕсли;
						
						КомплектОбъект.Состав.Очистить();
						Для Каждого МатериалCloud Из КомплектCloud.materials Цикл
							НоваяСтрока = КомплектОбъект.Состав.Добавить();
							НоваяСтрока.Номенклатура = Справочники.Номенклатура.НайтиПоCloudId(
								Формат(МатериалCloud.id, "ЧГ=0"));
						КонецЦикла;							
					КонецЕсли;
										
					КомплектОбъект.Записать();					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
				Результат = Истина;
			Исключение
				ТекстСообщения = НСтр("ru = 'Комплекты: ошибка обработки данных '") + ОписаниеОшибки();
				ОтменитьТранзакцию();				
			КонецПопытки;
		КонецЕсли;
				
		ЧтениеJSON.Закрыть();
	Иначе
		ТекстСообщения = НСтр("ru = 'Комплекты: ошибка получения данных'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти