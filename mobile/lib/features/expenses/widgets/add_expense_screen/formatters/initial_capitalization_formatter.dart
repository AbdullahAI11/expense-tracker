import 'package:flutter/services.dart';

class InitialCapitalizationFormatter extends TextInputFormatter {
  bool _hasCapitalizedOnce = false;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_hasCapitalizedOnce || newValue.text.isEmpty) {
      return newValue;
    }

    final firstCharacter = newValue.text[0];

    final uppercaseCharacter = firstCharacter.toUpperCase();
    final lowercaseCharacter = firstCharacter.toLowerCase();

    final isLetter = uppercaseCharacter != lowercaseCharacter;

    if (!isLetter) {
      return newValue;
    }

    _hasCapitalizedOnce = true;

    final updatedText = uppercaseCharacter + newValue.text.substring(1);

    return newValue.copyWith(
      text: updatedText,
      selection: newValue.selection,
    );
  }
}
