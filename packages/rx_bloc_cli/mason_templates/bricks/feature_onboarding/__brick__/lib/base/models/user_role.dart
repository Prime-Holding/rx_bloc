{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue('TempUser')
  tempUser,
  @JsonValue('User')
  user,
  @JsonValue('Guest')
  guest,
}
