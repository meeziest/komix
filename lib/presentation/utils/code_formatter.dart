import 'dart:math';

import 'package:flutter/services.dart';

const indexNotFound = -1;

class CodeFormatter extends TextInputFormatter {
  final String _placeholder = '  -  -  -  ';
  TextEditingValue? _lastNewValue;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int indexOfLetterO = _indexOfDifference(newValue.text, oldValue.text);
    if (indexOfLetterO < newValue.text.length &&
        !RegExp('[a-n-p-zA-N-P-Z- ]').hasMatch(newValue.text[indexOfLetterO].toUpperCase())) {
      return oldValue;
    }

    if (oldValue.text.isEmpty) {
      String check = newValue.text.replaceAll('-', '').replaceAll(' ', '');
      if (check.length == 8) {
        newValue = newValue.copyWith(
          text: newValue.text.trim(),
        );
        return newValue;
      }
      oldValue = oldValue.copyWith(
        text: _placeholder,
      );
      newValue = newValue.copyWith(
        text: _fillInputToPlaceholder(newValue.text),
      );
      return newValue;
    }

    String check = newValue.text.replaceAll('-', '').replaceAll(' ', '');
    if (check.length == 8) {
      String newCode = '';
      for (int i = 0; i < 8; i = i + 2) {
        newCode = newCode + check[i].toUpperCase() + check[i + 1].toUpperCase();
        if (i < 6) {
          newCode = newCode + '-';
        }
      }
      newValue = newValue.copyWith(text: newCode);
      return newValue;
    }

    if (newValue == _lastNewValue) {
      return oldValue;
    }
    _lastNewValue = newValue;

    int offset = newValue.selection.baseOffset;

    if (offset > 11) {
      return oldValue;
    }

    if (oldValue.text == newValue.text && oldValue.text.isNotEmpty) {
      return newValue;
    }

    final String oldText = oldValue.text;
    final String newText = newValue.text;
    String? resultText;

    int index = _indexOfDifference(newText, oldText);
    if (oldText.length < newText.length) {
      String newChar = newText[index];
      if (index == 2 || index == 5 || index == 8) {
        index++;
        offset++;
      }
      resultText = oldText.replaceRange(index, index + 1, newChar.toUpperCase());
      if (offset == 2 || offset == 5 || index == 8) {
        offset++;
      }
    } else if (oldText.length > newText.length) {
      if (oldText[index] != '-') {
        resultText = oldText.replaceRange(index, index + 1, ' ');
        if (offset == 3 || offset == 6 || offset == 9) {
          offset--;
        }
      } else {
        resultText = oldText;
      }
    }

    final splashes = resultText!.replaceAll(RegExp(r'[^-]'), '');

    int count = splashes.length;
    if (resultText.length > 11 ||
        count != 3 ||
        resultText[2].toString() != '-' ||
        resultText[5].toString() != '-' ||
        resultText[8].toString() != '-') {
      return oldValue;
    }

    return oldValue.copyWith(
      text: resultText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }

  int _indexOfDifference(String? cs1, String? cs2) {
    if (cs1 == cs2) {
      return indexNotFound;
    }
    if (cs1 == null || cs2 == null) {
      return 0;
    }
    int i;
    for (i = 0; i < cs1.length && i < cs2.length; ++i) {
      if (cs1[i] != cs2[i]) {
        break;
      }
    }
    if (i < cs2.length || i < cs1.length) {
      return i;
    }
    return indexNotFound;
  }

  String _fillInputToPlaceholder(String? input) {
    if (input == null || input.isEmpty) {
      return _placeholder;
    }
    String result = _placeholder;
    final index = [0, 1, 3, 4, 6, 7, 9, 10];
    final length = min(index.length, input.length);
    for (int i = 0; i < length; i++) {
      result = result.replaceRange(index[i], index[i] + 1, input[i].toUpperCase());
    }
    return result;
  }
}
