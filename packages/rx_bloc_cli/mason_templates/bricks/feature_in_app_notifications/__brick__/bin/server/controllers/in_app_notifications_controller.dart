import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class InAppNotificationsController extends ApiController {
  final _notifications = List.generate(
    25,
    (i) => {
      'id': '${i + 1}',
      'title': 'Notification ${i + 1}',
      'description': 'Description for notification ${i + 1}. '
          'This is a sample notification to demonstrate paginated loading.',
      'body': _buildQuillDelta(i + 1),
      'date': DateTime(DateTime.now().year, DateTime.now().month, i % 28 + 1).toIso8601String(),
      'isUnread': i < 5,
    },
  );

  static List<Map<String, dynamic>> _buildQuillDelta(int index) => [
        {
          'insert': 'Notification $index',
          'attributes': {'bold': true},
        },
        {
          'insert': '\n',
          'attributes': {'header': 1},
        },
        {'insert': '\nThis is a detailed description for '},
        {
          'insert': 'notification $index',
          'attributes': {'bold': true},
        },
        {
          'insert': '. It contains rich text content rendered with a Quill editor.\n\n',
        },
        {
          'insert': 'Key Details',
          'attributes': {'bold': true},
        },
        {
          'insert': '\n',
          'attributes': {'header': 3},
        },
        {'insert': 'Created on January ${index % 28 + 1}, 2025'},
        {
          'insert': '\n',
          'attributes': {'list': 'bullet'},
        },
        {'insert': 'Priority: ${index <= 5 ? "High" : "Normal"}'},
        {
          'insert': '\n',
          'attributes': {'list': 'bullet'},
        },
        {'insert': 'Type: ${index <= 5 ? "Warning" : "Information"}'},
        {
          'insert': '\n',
          'attributes': {'list': 'bullet'},
        },
        { 'insert': '\n' },
        {
          'insert': {
            'image':
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
          },
        },
        {'insert': '\n\n'},
        {'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
        {'insert': '\n\n'},
        {
          'insert':
              'Please review the information above and take the appropriate action.',
          'attributes': {'italic': true},
        },
        {'insert': '\n'},
      ];

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
  }

  Response _notificationsHandler(Request request) {
    final page = int.tryParse(
          request.url.queryParameters['page'] ?? '0',
        ) ??
        0;
    final pageSize = int.tryParse(
          request.url.queryParameters['pageSize'] ?? '10',
        ) ??
        10;
    final unreadOnly =
        request.url.queryParameters['unreadOnly']?.toLowerCase() == 'true';

    final filtered = unreadOnly
        ? _notifications.where((n) => n['isUnread'] == true).toList()
        : _notifications;

    final totalUnreadCount =
        _notifications.where((n) => n['isUnread'] == true).length;

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
    final notification = _notifications.firstWhere(
      (n) => n['id'] == id,
      orElse: () => throw NotFoundException(
        'Notification with id: $id is not found.',
      ),
    );

    return responseBuilder.buildOK(data: notification);
  }

  Response _markAsReadHandler(Request request, String id) {
    final notification = _notifications.firstWhere(
      (n) => n['id'] == id,
      orElse: () => throw NotFoundException(
        'Notification with id: $id is not found.',
      ),
    );

    notification['isUnread'] = false;

    return responseBuilder.buildOK(data: notification);
  }
}
