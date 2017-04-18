import 'package:angular2/angular2.dart';

@Pipe(name: 'cmFormatCurrency')
/**
 * Пайпа для преобразования числовых значений к денежному формату
 */
class CmFormatCurrencyPipe extends PipeTransform {
  String transform(String value, String currency) => parseCurrency(value, currency);

  String parseCurrency(String value, String currency) {
    String result = '';

    switch (value.toUpperCase()) {
      case 'RUB':
      case 'RUR':
        result = '$value руб';
        break;

      case 'USD':
        result = '\$ $value';
        break;

      case 'EUR':
        result = '€ $value';
        break;

      case 'JPY':
        result = '¥ $value';
        break;
    }

    return result;
  }
}
