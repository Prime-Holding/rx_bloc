/// Object extensions providing convenience methods for various operations
extension ConvenienceObjectExtensions on Object {
  /// Convenience method for casting a value to specific type
  /// Allows to skip null checks when casting optional values
  /// and rely on optional chaining instead
  T cast<T extends Object>() => this as T;
}
