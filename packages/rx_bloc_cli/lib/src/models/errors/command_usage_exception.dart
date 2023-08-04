/// Generic exception for RxBlocCLI commands usage
class CommandUsageException implements Exception {
  /// Constructor with message
  CommandUsageException(this.message);

  /// Message property
  final String message;
}
