import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';

/**
 * Суммарная информация по заявке
 */
class RequestSummary extends Object with JsonConverter, MapConverter {
  /**
   * Общее количество работ
   */
  int worksQuantity = 0;

  /**
   * Суммарная стоимость работ
   */
  num worksAmount = 0;

  /**
   * Общее количество материалов
   */
  int materialsQuantity = 0;

  /**
   * Суммарная стоимость материалов
   */
  num materialsAmount = 0;

  /**
   * Общая сумма
   */
  num amount = 0;

  /**
   * Сумма с учетом НДС
   */
  num amountWithVat = 0;

  /**
   * Зачет аванса
   */
  num prepaidAmount = 0;

  /**
   * Удержано резерва
   */
  num reserveAmount = 0;

  /**
   * Итого к оплате
   */
  num total = 0;

  /**
   * Название валюты
   */
  String currencyName;

  /**
   * Системное имя валюты
   */
  String currencySysName;
}