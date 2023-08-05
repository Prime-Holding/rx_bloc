/// Object extensions providing convenience methods for various operations
extension ConvenienceObjectExtensions on Object {
  /// Convenience method for casting a value to specific type
  T cast<T extends Object>() => this as T;
}
