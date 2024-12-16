{{> licence.dart }}

import 'package:flutter/services.dart';

/// A [TextInputFormatter] that formats phone numbers based on a given format.
class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter({
    this.format = 'xx xxx xxxx',
    this.disallowUpdatesOnFullNumber = true,
  });

  /// The format string for the phone number.
  ///
  /// The digits in the format are represented by any non-whitespace characters
  /// separated by whitespace.
  ///
  ///
  ///
  /// Example:
  ///
  /// Format: xx xxx xxxx
  /// Output: 12 345 6789
  ///
  /// Format: abcd efg hij
  /// Output: 1234 567 890
  final String format;

  /// Flag disallowing any updates to the text if the character limit of
  /// the format has been reached.
  final bool disallowUpdatesOnFullNumber;

  /// Helper buffer to hold the formatted text
  final _formattedText = StringBuffer();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (disallowUpdatesOnFullNumber &&
        oldValue.text.length == format.length &&
        newValue.text.length >= oldValue.text.length) {
      return oldValue;
    }

    // Remove any non-digit characters from the new input text
    String rawText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Initialize an empty string buffer to hold the formatted characters
    _formattedText.clear();
    int rawTextIndex = 0;

    // Iterate through each character in the format string
    for (int i = 0; i < format.length; i++) {
      // Only add characters from the format string when there are digits available
      if (format[i] != ' ' && rawTextIndex < rawText.length) {
        _formattedText.write(rawText[rawTextIndex]);
        rawTextIndex++;
      } else if (format[i] == ' ' && rawTextIndex > 0) {
        // Add spaces only after at least one digit is entered
        _formattedText.write(' ');
      }
    }

    final trimmedText = _formattedText.toString().trim();

    // Calculate the new cursor position
    int newCursorPosition = _calculateCaretPosition(
      oldValue,
      newValue,
      trimmedText,
    );

    // Return the updated TextEditingValue with the formatted text and preserved cursor position
    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  // Helper function to calculate the new caret position after formatting
  int _calculateCaretPosition(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    String formattedText,
  ) {
    final formattedTextWithoutSpaces = formattedText.replaceAll(' ', '');
    final oldFormattedTextWithoutSpaces = oldValue.text.replaceAll(' ', '');
    final oldPosition = oldValue.selection.baseOffset;

    // By default, place the caret at the end of the formatted text
    int newCaretPosition = formattedText.length;

    // If the cursor was at the end of the string previously, keep it at the end
    if (oldPosition == oldValue.text.length) {
      newCaretPosition = formattedText.length;
    } else {
      // If a character was removed
      if (oldFormattedTextWithoutSpaces.length >
          formattedTextWithoutSpaces.length) {
        newCaretPosition = oldPosition - 1;
      }
      // If a character was added
      else if (oldFormattedTextWithoutSpaces.length <
          formattedTextWithoutSpaces.length) {
        newCaretPosition = oldPosition + 1;
      }
    }

    // Return the new position (ignoring the spaces)
    // The new position is based on the formatted text without spaces.
    return newCaretPosition;
  }
}
