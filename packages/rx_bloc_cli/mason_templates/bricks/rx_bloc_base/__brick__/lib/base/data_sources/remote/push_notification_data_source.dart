// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'push_notification_data_source.g.dart';

@RestApi(baseUrl: 'http://0.0.0.0:8080')
abstract class PushNotificationsDataSource {
  factory PushNotificationsDataSource(Dio dio, {String baseUrl}) =
      _PushNotificationsDataSource;

  @POST('/api/user/push-notification-subscriptions')
  Future<void> subscribePushToken(@Body() String pushToken);

  @DELETE('/api/user/push-notification-subscriptions/{pushToken}')
  Future<void> unsubscribePushToken(@Path() String pushToken);
}
