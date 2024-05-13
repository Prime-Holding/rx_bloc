// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/repositories/push_notification_repository.dart';

class NotificationService {
  NotificationService(this._repository);

  final PushNotificationRepository _repository;

  Future<void> sendPushMessage({
    required String message,
    String? title,
    int? delay,
    Map<String, Object?>? data,
  }) =>
      _repository.sendPushMessage(
        message: message,
        title: title,
        delay: delay,
        data: data,
      );

  Future<bool> requestNotificationPermissions() =>
      _repository.requestNotificationPermissions();
}
