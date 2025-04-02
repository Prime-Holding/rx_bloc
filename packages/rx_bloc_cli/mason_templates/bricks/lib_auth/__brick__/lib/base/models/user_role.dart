// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:json_annotation/json_annotation.dart';

/// User account role
enum UserRole {
  /// Temporary user account. This role indicates that the user started the
  /// registration process but did not fully complete it yet.
  @JsonValue('TempUser')
  tempUser,

  /// Verified user account. This role indicates that the user has completed the
  /// registration process and has verified their any required credentials.
  @JsonValue('User')
  user,

  /// Guest account. This role describes a user account which is not recognized
  /// by the system or has not been created yet.
  @JsonValue('Guest')
  guest,
}
