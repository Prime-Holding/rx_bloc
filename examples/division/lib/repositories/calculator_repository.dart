class CalculatorRepository {
  const CalculatorRepository();

  Future<String> calculate(String a, String b) async {
    // Any thrown exception will be captured by the errorState
    if (a.isNullOrEmpty || !a.isNumeric)
      throw Exception('Invalid first number.');
    if (b.isNullOrEmpty || !b.isNumeric)
      throw Exception('Invalid second number.');

    final numA = double.parse(a);
    final numB = double.parse(b);

    if (numB == 0) {
      throw Exception('Cannot divide by zero.');
    }

    // Simulate a small calculation delay (so the loading progress is visible)
    await Future.delayed(Duration(milliseconds: 300));
    return '$numA / $numB = ${numA / numB}';
  }
}

extension _StringExtensions on String {
  bool get isNullOrEmpty {
    return this.trim().isEmpty;
  }

  bool get isNumeric {
    final _digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    return this.split('').every((char) => _digits.contains(char));
  }
}
