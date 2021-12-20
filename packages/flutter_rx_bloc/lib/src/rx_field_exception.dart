/// [RxFieldException] handles updating reactive forms with an exception
/// without loosing the field value
///
/// See also:
///   * [Exception], which handles general Exceptions
class RxFieldException<T> implements Exception {
  ///the default constructor, all members are required
  const RxFieldException({
    required this.error,
    required this.fieldValue,
  });

  ///The value the form should be updated with in case of error
  ///used in order to NOT lose what has already been filled in
  final T fieldValue;

  ///The error string which the form should show
  final String error;

  @override
  bool operator ==(Object other) {
    if (other is RxFieldException<T>) {
      return fieldValue == other.fieldValue && error == other.error;
    }

    return false;
  }

  @override
  int get hashCode => fieldValue.hashCode ^ error.hashCode;
}
