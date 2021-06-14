// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../data_sources/remote/push_notification_data_source.dart';

class PushNotificationSubscriptionRepository {
  PushNotificationSubscriptionRepository(this._pushDataSource);

  final PushNotificationsDataSource _pushDataSource;

  Future<void> subscribePush(String pushToken) =>
      _pushDataSource.subscribePushToken(pushToken);

  Future<void> unsubscribePush(String pushToken) =>
      _pushDataSource.unsubscribePushToken(pushToken);
}
