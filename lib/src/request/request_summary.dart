import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';
import 'amount.dart';

@reflectable
/**
 * Суммарная информация по заявке
 */
class RequestSummary extends Object with JsonConverter, MapConverter {
  /**
   * Общее количество работ
   */
  int worksQuantity = 0;

  /**
   * Суммарная стоимость работ
   */
  @Json(exclude: true)
  List<Amount> worksAmount = new List<Amount>();

  /**
   * Общее количество материалов
   */
  int materialsQuantity = 0;

  /**
   * Суммарная стоимость материалов
   */
  @Json(exclude: true)
  List<Amount> materialsAmount = new List<Amount>();

  /**
   * Общая сумма
   */
  @Json(exclude: true)
  List<Amount> amounts = new List<Amount>();

  /**
   * Сумма с учетом НДС
   */
  @Json(exclude: true)
  List<Amount> vats = new List<Amount>();

  /**
   * Итого к оплате
   */
  @Json(exclude: true)
  List<Amount> totals = new List<Amount>();

  /**
   * Системное имя валюты
   */
  String currencySysName;

  @override
  Map toJson() {
    var result = super.toJson();

    var amountsList = new List<Map>();

    amounts.forEach((a){
      amountsList.add(a.toJson());
    });

    result['amounts'] = amountsList;

    return result;
  }

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    for (dynamic worksAmountJson in json['worksAmount']) {
      worksAmount.add(new Amount().fromJson(worksAmountJson));
    }

    for (dynamic materialsAmountJson in json['materialsAmount']) {
      materialsAmount.add(new Amount().fromJson(materialsAmountJson));
    }

    for (dynamic amountsJson in json['amounts']) {
      amounts.add(new Amount().fromJson(amountsJson));
    }

    for (dynamic vatsJson in json['vats']) {
      vats.add(new Amount().fromJson(vatsJson));
    }

    for (dynamic totalsJson in json['totals']) {
      totals.add(new Amount().fromJson(totalsJson));
    }

    return this;
  }
}
