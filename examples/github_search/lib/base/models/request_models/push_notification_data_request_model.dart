// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:json_annotation/json_annotation.dart';

part 'push_notification_data_request_model.g.dart';

@JsonSerializable()
class PushNotificationDataRequestModel {
  PushNotificationDataRequestModel(this.pushToken);

  final String pushToken;

  factory PushNotificationDataRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$PushNotificationDataRequestModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$PushNotificationDataRequestModelToJson(this);
}
