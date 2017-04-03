import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';

import 'primary_document_type.dart';

/**
 * Первичный документ
 */
abstract class PrimaryDocument extends Object with JsonConverter, MapConverter {
  /**
   * Уникальный внутренний идентификатор
   */
  String id = '';

  /**
   * Тип первичного документа
   */
  PrimaryDocumentType type = PrimaryDocumentType.None;
}