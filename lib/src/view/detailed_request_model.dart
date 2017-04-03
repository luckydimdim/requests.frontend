import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

import 'primary_document.dart';
import 'request_summary.dart';
import 'time_sheet.dart';

@reflectable
/**
 * Модель заявки на проверку
 */
class DetailedRequestModel extends Object with JsonConverter, MapConverter {
  /**
   * Внутренний уникальный идентификатор заявки
   */
  String id = '';

  /**
   * Идентификатор контракта, к которому принадлежит данная заявка
   */
  String contractId = '';

  /**
   * Суммарная информация по заявке
   */
  RequestSummary summary = null;

  /**
   * Перечень первичных документов
   */
  List<PrimaryDocument> documents = new List<PrimaryDocument>();

  @override
  dynamic fromJson(dynamic json) {
    DetailedRequestModel model = super.fromJson(json);

    var summary = new RequestSummary();
    model.summary = summary.fromJson(json['summary']);

    List<dynamic> documentsJson = json['documents'];
    if (documents != null) {
      for (dynamic documentJson in documentsJson) {
        PrimaryDocument document = _resolveDocument(documentJson);

        documents.add(document);
      }
    }
  }

  /**
   * Получение модели первичного документа из json
   */
  PrimaryDocument _resolveDocument(dynamic documentJson) {
    PrimaryDocument result = null;

    switch (documentJson['type'].toString().toUpperCase()) {
      case 'TIMESHEET':
        result = new TimeSheet();
    }

    return result.fromJson(documentJson);
  }
}