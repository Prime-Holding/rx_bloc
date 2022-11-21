/// This operation should be in the reminders list
enum CounterOperation {
  /// The operation, which just increments the incomplete counter
  create,

  /// The operation, which decrements the incomplete counter
  deleteIncomplete,

  /// The operation, which decrements the complete counter
  deleteComplete,

  /// The operation, which decrements incomplete and increments complete counter
  setComplete,

  /// The operation, which increments incomplete and decrements complete counter
  unsetComplete,

  /// The operation, which does not change counters
  none
}
