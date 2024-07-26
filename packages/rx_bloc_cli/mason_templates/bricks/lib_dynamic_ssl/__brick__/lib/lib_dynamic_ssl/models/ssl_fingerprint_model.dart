// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ssl_fingerprint_model.g.dart';

@JsonSerializable()
class SSLFingerprintModel with EquatableMixin {
  SSLFingerprintModel({
    required this.sslFingerprint,
  });

  final String sslFingerprint;

  factory SSLFingerprintModel.fromJson(Map<String, dynamic> json) =>
      _$SSLFingerprintModelFromJson(json);

  Map<String, dynamic> toJson() => _$SSLFingerprintModelToJson(this);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [sslFingerprint];
}
