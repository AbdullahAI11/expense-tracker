import 'package:flutter/services.dart';

class MoneyInputFormatter extends TextInputFormatter {
  static final _moneyPattern = RegExp(r'^\d*\.?\d{0,2}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_moneyPattern.hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}
