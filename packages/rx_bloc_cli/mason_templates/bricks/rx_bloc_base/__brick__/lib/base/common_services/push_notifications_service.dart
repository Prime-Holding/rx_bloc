{{> licence.dart }}

import 'package:permission_handler/permission_handler.dart';

import '../../assets.dart';
import '../models/errors/error_model.dart';
import '../repositories/push_notification_repository.dart';

class PushNotificationsService {
  final PushNotificationRepository _pushNotificationRepository;

  PushNotificationsService(
    this._pushNotificationRepository,
  );

  Future<void> unsubscribe([bool setNotifications = false]) async {
    final token = await _pushNotificationRepository.getToken();
    if (token == null) {
      throw ErrorModel();
    }
    await _pushNotificationRepository.unsubscribe(token);
    await _pushNotificationRepository
        .setNotificationSubscribed(setNotifications);
  }

  Future<bool> areNotificationsEnabled() async {
    final permissionStatus = await Permission.notification.status;
    final shouldSubscribe =
        await _pushNotificationRepository.notificationsSubscribed();
    if (permissionStatus == PermissionStatus.granted && shouldSubscribe) {
      await subscribe();
      return true;
    } else if (permissionStatus != PermissionStatus.granted &&
        shouldSubscribe) {
      await unsubscribe(true);
      return false;
    } else {
      await unsubscribe();
      return false;
    }
  }

  Future<bool> requestNotificationPermissions() =>
      _pushNotificationRepository.requestNotificationPermissions();

  Future<bool> isSubscribed() =>
      _pushNotificationRepository.notificationsSubscribed();

  Future<void> subscribe() async {
    if (!(await _pushNotificationRepository.requestNotificationPermissions())) {
      throw GenericErrorModel(I18nErrorKeys.notificationsDisabledMessage);
    }

    final token = await _pushNotificationRepository.getToken();

    if (token == null) {
      throw GenericErrorModel(I18nErrorKeys.accessDenied);
    }
    await _pushNotificationRepository.subscribe(token);
    await _pushNotificationRepository.setNotificationSubscribed(true);
  }
}