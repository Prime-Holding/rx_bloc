/// Utility methods for operations on strings
extension StringExtensions on String {
  /// Check if string matches a provided regex
  bool matches({required String regex}) {
    final regExp = RegExp(regex);
    final match = regExp.matchAsPrefix(this);
    return match != null && match.end == length;
  }

  /// Converts the string to boolean value
  bool toBool() => bool.parse(this, caseSensitive: false);
}
