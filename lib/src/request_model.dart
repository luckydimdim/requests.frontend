import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
/**
 * Модель заявки на проверку
 */
class RequestModel extends Object with JsonConverter, MapConverter {
  String id;
  String startDate;
  String updateDate;
  String contractNumber;
  String contractorName;
  num amount;
  String status;
}