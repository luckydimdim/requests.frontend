import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Стоимость
 */
@reflectable
class Amount extends Object with JsonConverter, MapConverter {
  // Валюта
  String currencySysName;

  // значение
  num value = 0;
}