// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:json_annotation/json_annotation.dart';

part 'authenticate_user_request_model.g.dart';

@JsonSerializable()
class AuthUserRequestModel {
  AuthUserRequestModel({this.username, this.password, this.refreshToken});

  final String? username;
  final String? password;
  final String? refreshToken;

  factory AuthUserRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserRequestModelToJson(this);
}
