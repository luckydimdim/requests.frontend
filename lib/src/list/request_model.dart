import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

import '../request/amount.dart';

@reflectable
/**
 * Модель заявки на проверку
 */
class RequestModel extends Object with JsonConverter, MapConverter {
  /**
   * Внутренний уникальный идентификатор
   */
  String id;

  /**
   * Идентификатор контракта, к которому принадлежит данная заявка
   */
  String contractId;

  /**
   * Дата создания
   */
  DateTime createdAt;

  /**
   * Дата последнего изменения
   */
  DateTime updatedAt;

  /**
   * Номер договора
   */
  String contractNumber;

  /**
   * Наименование подрядчика
   */
  String contractorName;

  /**
   * Название валюты
   */
  String currencyName;

  /**
   * Сумма к оплате
   */
  @Json(exclude: true)
  List<Amount> amounts = new List<Amount>();

  /**
   * Имя статуса для показа
   */
  String statusName;

  /**
   * Системное имя статуса
   */
  String statusSysName;

  /**
   * Идентификаторы выбранных (для формирования первички) работ
   */
  List<String> workIds = new List<String>();

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    for (dynamic amountJson in json['amounts']) {
      amounts.add(new Amount().fromJson(amountJson));
    }

    return this;
  }

  @override
  Map toJson() {
    var result = super.toJson();

    var amountsList = new List<Map>();

    amounts.forEach((a){
      amountsList.add(a.toJson());
    });

    result['amounts'] = amountsList;

    return result;
  }

  @override
  Map toMap() {
    return toJson();
  }
}
