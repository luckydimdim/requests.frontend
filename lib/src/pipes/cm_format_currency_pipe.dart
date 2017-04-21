import 'package:angular2/angular2.dart';

@Pipe(name: 'cmFormatCurrency')
/**
 * Пайпа для преобразования кодов валют
 */
class CmFormatCurrencyPipe extends PipeTransform {
  String transform(String value, String currency) => parseCurrency(value, currency);

  String parseCurrency(String value, String currency) {
    String result = value;

    if (currency == null || currency.trim() == '')
      return result;

    switch (currency.toUpperCase()) {
      case 'RUB':
      case 'RUR':
        result += ' руб';
        break;

      case 'USD':
        result = '\$ '+ result;
        break;

      case 'EUR':
        result = '€ '+ result;
        break;

      case 'JPY':
        result = '¥ '+ result;
        break;
    }

    return result;
  }
}