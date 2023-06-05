import 'enums.dart';

/// Convert the time into a presentable format
String convertRemainingTime(
    int time, CountdownTimeFormat timeFormat, bool preferDoubleDigitsForTime) {
  String output = '';

  switch (timeFormat) {
    case CountdownTimeFormat.minutes:
      final mins = time ~/ 60;
      final secs = time - mins * 60;

      final minOut =
          preferDoubleDigitsForTime ? _formatToDoubleDigitValue(mins) : mins;
      output = '$minOut:${_formatToDoubleDigitValue(secs)}';
      break;
    case CountdownTimeFormat.hours:
      final hours = time ~/ 3600;
      final mins = (time - hours * 3600) ~/ 60;
      final secs = (time - hours * 3600) % 60;

      final hoursOut =
          preferDoubleDigitsForTime ? _formatToDoubleDigitValue(hours) : hours;
      output = '$hoursOut'
          ':${_formatToDoubleDigitValue(mins)}'
          ':${_formatToDoubleDigitValue(secs)}';
      break;
    case CountdownTimeFormat.seconds:
    default:
      output = time.toString();
  }
  return output;
}

/// Convenience method for converting an integer into double digits number
/// mostly used for hours and minutes presentation.
String _formatToDoubleDigitValue(int val) {
  if (val < 10) return '0$val';
  return val.toString();
}
