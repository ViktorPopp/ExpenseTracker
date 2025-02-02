import 'package:intl/intl.dart';

double convertStringToDouble(String source) {
  double? value = double.tryParse(source);
  return value ?? 0.0;
}

String formatAmount(double amount) {
  final format = NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 2);
  return format.format(amount);
}
