part of 'event_bloc.dart';

extension _SSEMessageModelExtensions on Stream<SseMessageModel> {
  Stream<NotificationEvent?> parseSseEvent(CoordinatorBlocType coordinatorBloc) =>
    takeUntil(coordinatorBloc.states.isAuthenticated.where((isAuthenticated) => !isAuthenticated)).map(_parseSseEvent);

  static NotificationEvent? _parseSseEvent(SseMessageModel message) {
    try {
      final json = jsonDecode(message.data) as Map<String, dynamic>;
      final type = json['type'] as String;

      /// Map the SSE event type to the respective NotificationEvent type
      return switch (type) {
        'newNotification' => NotificationEvent(type: NotificationEventType.newNotification),
        _ => null,
      };
    } catch (_) {
      return null;
    }
  }
}