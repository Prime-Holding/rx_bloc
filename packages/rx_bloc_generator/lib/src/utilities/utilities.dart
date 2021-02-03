part of rx_bloc_generator;

/// The global logJet symbol.
const Symbol logKey = #buildLog;

/// Fallback logger used in case there isn't any in the current zone
final _default = Logger('build.fallback');

/// The log instance for the currently running BuildStep.
///
/// Will be `null` when not running within a build.
Logger get log => Zone.current[logKey] as Logger ?? _default;

/// Logs message as a `severe` error displayed in red color for easier noticing.
logError(String str) {
  final exceptionStr = 'Exception: ';
  var msg = str;
  if (msg.contains(exceptionStr))
    msg = msg.substring(msg.indexOf(exceptionStr) + exceptionStr.length);
  msg = '[ERROR] $msg';
  log.severe('\n${msg.toRedString()}\n');
}
