// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:shelf/shelf.dart';

import '../repositories/in_app_notifications_repository.dart';
import '../repositories/sse_repository.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class InAppNotificationsController extends ApiController {
  InAppNotificationsController(this._repository, this._sseRepository) {
    _sseRepository
      ..onFirstClientConnected = _startPeriodicNotifications
      ..onLastClientDisconnected = _stopPeriodicNotifications;
  }

  final InAppNotificationsRepository _repository;
  final SseRepository _sseRepository;
  Timer? _notificationTimer;

  static const _notificationInterval = Duration(seconds: 30);
  static const _newNotificationEvent = 'newNotification';

  void _startPeriodicNotifications() {
    if (_notificationTimer != null) return;
    _notificationTimer = Timer.periodic(
      _notificationInterval,
      (_) => _generateNotification(),
    );
    print(
        '[Notifications] Periodic generation started (every ${_notificationInterval.inSeconds} seconds)');
  }

  void _stopPeriodicNotifications() {
    _notificationTimer?.cancel();
    _notificationTimer = null;
    print('[Notifications] Periodic generation stopped (no clients)');
  }

  void _generateNotification() {
    final notification = _repository.generateNotification();

    _sseRepository.broadcastEvent({
      'type': _newNotificationEvent,
    });

    print('[Notifications] Auto-generated: ${notification['title']}');
  }

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/in-app-notifications',
      _notificationsHandler,
    );

    router.addRequestWithParam(
      RequestType.GET,
      '/api/in-app-notifications/<id>',
      _getNotificationByIdHandler,
    );

    router.addRequestWithParam(
      RequestType.PATCH,
      '/api/in-app-notifications/<id>/read',
      _markAsReadHandler,
    );

    router.addRequest(
      RequestType.GET,
      '/api/sse',
      _sseHandler,
    );
  }

  Response _notificationsHandler(Request request) {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '0') ?? 0;
    final pageSize =
        int.tryParse(request.url.queryParameters['pageSize'] ?? '10') ?? 10;
    final unreadOnly =
        request.url.queryParameters['unreadOnly']?.toLowerCase() == 'true';

    final filtered =
        unreadOnly ? _repository.getUnread() : _repository.getAll();

    final totalUnreadCount = _repository.unreadCount;

    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length);

    final items = start < filtered.length
        ? filtered.sublist(start, end)
        : <Map<String, dynamic>>[];

    return responseBuilder.buildOK(
      data: {
        'notifications': items,
        'totalCount': filtered.length,
        'unreadCount': totalUnreadCount,
      },
    );
  }

  Response _getNotificationByIdHandler(Request request, String id) {
    final notification = _repository.getById(id);
    if (notification == null) {
      throw NotFoundException('Notification with id: $id is not found.');
    }

    return responseBuilder.buildOK(data: notification);
  }

  Response _markAsReadHandler(Request request, String id) {
    final notification = _repository.getById(id);
    if (notification == null) {
      throw NotFoundException('Notification with id: $id is not found.');
    }

    _repository.markAsRead(id);

    return responseBuilder.buildOK(data: notification);
  }

  Response _sseHandler(Request request) {
    final stream = _sseRepository.connectClient(
      initialEvent: {
        'type': 'connected',
      },
    );

    return Response.ok(
      stream,
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
      },
    );
  }
}
