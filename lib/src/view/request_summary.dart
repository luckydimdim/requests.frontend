import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';

/**
 * Суммарная информация по заявке
 */
class RequestSummary extends Object with JsonConverter, MapConverter {
  int worksQuantity = 0;
  num worksAmount = 0;

  int materialsQuantity = 0;
  num materialsAmount = 0;

  num amount = 0;
  num amountWithVat = 0;
  num prepaidAmount = 0;
  num reserveAmount = 0;
  num total = 0;
}