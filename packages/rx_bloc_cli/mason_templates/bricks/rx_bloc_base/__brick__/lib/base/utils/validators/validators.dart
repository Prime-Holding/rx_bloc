{{> licence.dart }}

import '../../../assets.dart';
import '../../models/errors/error_model.dart';

part 'login_field_validators.dart';

typedef FieldValidator<T> = T Function(T);

extension ValidateField<T> on Stream<T> {
  Stream<T> validateField(FieldValidator<T> validator) =>
      map((event) => validator(event));
}
