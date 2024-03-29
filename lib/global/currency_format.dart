// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static String convertToDollar(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'en',
      symbol: '',
      decimalDigits: decimalDigit,
    );

    return currencyFormatter.format(number);
  }

  static String convertToTitik(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'en',
      symbol: '',
      decimalDigits: decimalDigit,
    );

    return currencyFormatter.format(number);
  }
}
