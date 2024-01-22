// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_rx_bloc/rx_form.dart';

part 'login_field_validators.dart';

/// A convenience type defining a function which takes, validates and returns a
/// value of type [T]
typedef FieldValidator<T> = T Function(T);

extension ValidateField<T> on Stream<T> {
  /// Validates a field using the provided [validator]
  Stream<T> validateField(FieldValidator<T> validator) =>
      map((event) => validator(event));
}
