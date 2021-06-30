// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/request_models/push_message_request_model.dart';
import '../../models/request_models/push_notification_data_request_model.dart';

part 'push_notification_data_source.g.dart';

@RestApi(baseUrl: 'http://0.0.0.0:8080')
abstract class PushNotificationsDataSource {
  factory PushNotificationsDataSource(Dio dio, {String baseUrl}) =
      _PushNotificationsDataSource;

  @POST('/api/user/push-notification-subscriptions')
  Future<void> subscribePushToken(
      @Body() PushNotificationDataRequestModel pushToken);

  @DELETE('/api/user/push-notification-subscriptions')
  Future<void> unsubscribePushToken(
    @Body() PushNotificationDataRequestModel pushToken,
  );

  @POST('/api/send-push-message')
  Future<void> sendPushMessage(@Body() PushMessageRequestModel message);
}
