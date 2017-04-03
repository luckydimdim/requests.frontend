import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
/**
 * Модель заявки на проверку
 */
class WriteRequestModel extends Object with JsonConverter, MapConverter {
  /**
   * Внутренний уникальный идентификатор
   */
  String id = '';

  /**
   * Идентификатор договора, к которому относится данная заявка
   */
  String contractId = '';

  /**
   * Идентификаторы выбранных (для формирования первички) работ
   */
  List<String> workIds = new List<String>();
}