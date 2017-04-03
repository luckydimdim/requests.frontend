import 'primary_document.dart';
import 'primary_document_type.dart';

/**
 * Табель учета рабочего времени
 */
class TimeSheet extends PrimaryDocument {
  @override
  PrimaryDocumentType type = PrimaryDocumentType.TimeSheet;

  /**
   * ФИО
   */
  String assignee = '';

  /**
   * Наименование работ
   */
  String name = '';

  /**
   * Должность
   */
  String position = '';

  /**
   * Стоимость
   */
  num amount = 0;

  /**
   * Название валюты
   */
  String currencyName = '';

  /**
   * Системное имя валюты
   */
  String currencySysName = '';

  /**
   * Название статуса
   */
  String statusName = '';

  /**
   * Системное имя статуса
   */
  String statusSysName = '';
}