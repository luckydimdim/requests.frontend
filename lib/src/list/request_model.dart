import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

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
  num amount;

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
}
