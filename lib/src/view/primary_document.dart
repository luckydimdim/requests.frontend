import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';

import 'package:converters/reflector.dart';
import 'primary_document_type.dart';

@reflectable
/**
 * Первичный документ
 */
abstract class PrimaryDocument extends Object with JsonConverter, MapConverter {
  /**
   * Уникальный внутренний идентификатор
   */
  String id = '';

  @Json(exclude: true)
  /**
   * Тип первичного документа
   */
  PrimaryDocumentType type = PrimaryDocumentType.none;
}