{{> licence.dart }}

import '../../assets.dart';
import '../models/errors/error_model.dart';
import '../repositories/push_notification_repository.dart';

class PushNotificationsService {
  final PushNotificationRepository _pushNotificationRepository;

  PushNotificationsService(this._pushNotificationRepository);

  Future<void> unsubscribe() async {
    final token = await _pushNotificationRepository.getToken();
    if (token == null) {
      throw ErrorModel();
    }
    await _pushNotificationRepository.unsubscribe(token);
    await _pushNotificationRepository.setNotificationSubscribed(false);
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

    await _pushNotificationRepository.setNotificationsEnabled(true);
    await _pushNotificationRepository.subscribe(token);
    await _pushNotificationRepository.setNotificationSubscribed(true);
  }
}