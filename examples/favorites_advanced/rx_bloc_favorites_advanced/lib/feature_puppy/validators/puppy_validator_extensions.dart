part of 'puppy_validator.dart';

extension ValidateField<T> on Stream<T> {
  Stream<T> validateField(
    FieldValidator<T> validator,
  ) =>
      map((event) => validator(event));
}
