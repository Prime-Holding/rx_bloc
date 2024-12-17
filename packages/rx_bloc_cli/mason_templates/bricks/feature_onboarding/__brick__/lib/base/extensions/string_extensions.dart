{{> licence.dart }}

import 'dart:convert';

import 'package:crypto/crypto.dart';

extension Sha256 on String {
  String toSha256() => sha256.convert(utf8.encode(this)).toString();
}
