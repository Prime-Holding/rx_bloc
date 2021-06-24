// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_rx_bloc/rx_form.dart';

part 'login_field_validators.dart';

typedef FieldValidator<T> = T Function(T);

extension ValidateField<T> on Stream<T> {
  Stream<T> validateField(FieldValidator<T> validator) =>
      map((event) => validator(event));
}
