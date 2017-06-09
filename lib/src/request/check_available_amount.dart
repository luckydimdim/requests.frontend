import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';
import 'package:converters/reflector.dart';

@reflectable
class CheckAvailableAmount extends Object with JsonConverter, MapConverter{

  double amount;

  String currencySysName;
}