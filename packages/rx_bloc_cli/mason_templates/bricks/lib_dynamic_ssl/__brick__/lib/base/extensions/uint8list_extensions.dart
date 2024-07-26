import 'dart:typed_data';
import 'package:crypto/crypto.dart';

extension SHA on Uint8List {
  String toSHA256String() => sha256
      .convert(this)
      .bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join(':');
}
