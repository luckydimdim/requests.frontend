import 'primary_document.dart';
import 'primary_document_type.dart';

/**
 * Табель учета рабочего времени
 */
class TimeSheet extends PrimaryDocument {
  @override
  PrimaryDocumentType type = PrimaryDocumentType.TimeSheet;
}