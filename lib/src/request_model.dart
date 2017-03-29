/**
 * Модель заявки на проверку
 */
class RequestModel {
  String id;
  String startDate;
  String updateDate;
  String contractNumber;
  String contractorName;
  String amount;
  String status;

  RequestModel();

  // TODO: реализовать
  factory RequestModel.fromJson(String json) {
    return new RequestModel();
  }

  // TODO: реализовать
  String toJsonString() {
    return '';
  }

  // TODO: реализовать
  Map<String, String> toMap() {
    return new Map<String, String>();
  }
}