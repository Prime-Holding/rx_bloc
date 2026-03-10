class InAppNotificationsRepository {
  int _nextIndex = 25;
  int _nextMonth = DateTime.now().month;
  int _nextYear = DateTime.now().year;

  static const _titles = [
    'System Update Available',
    'Weekly Report Ready',
    'Security Alert',
    'New Feature Released',
    'Maintenance Scheduled',
    'Account Activity Detected',
    'Reminder: Action Required',
    'Performance Summary',
  ];

  static const _descriptions = [
    'A new system update is available. Please review and apply at your convenience.',
    'Your weekly activity report has been generated and is ready for review.',
    'Unusual login activity was detected on your account. Please verify.',
    'We just launched a new feature! Check it out in the latest release notes.',
    'Scheduled maintenance will occur this weekend. Plan accordingly.',
    'New activity has been recorded on your account. Review the details.',
    'You have pending items that require your attention.',
    'Your performance metrics for this period are now available.',
  ];

  final List<Map<String, dynamic>> _notifications = List.generate(
    25,
    (i) => _buildNotification(i, unread: i < 5),
  );

  List<Map<String, dynamic>> getAll() => List.unmodifiable(_notifications);

  List<Map<String, dynamic>> getUnread() =>
      _notifications.where((n) => n['isUnread'] == true).toList();

  int get unreadCount =>
      _notifications.where((n) => n['isUnread'] == true).length;

  Map<String, dynamic>? getById(String id) {
    try {
      return _notifications.firstWhere((n) => n['id'] == id);
    } on StateError {
      return null;
    }
  }

  void markAsRead(String id) {
    final notification = getById(id);
    if (notification != null) {
      notification['isUnread'] = false;
    }
  }

  Map<String, dynamic> generateNotification() {
    final index = DateTime.now().millisecondsSinceEpoch % _titles.length;
    return addNotification(
      title: _titles[index],
      description: _descriptions[index],
    );
  }

  Map<String, dynamic> addNotification({
    required String title,
    required String description,
  }) {
    final notification = _buildNotification(
      _nextIndex,
      unread: true,
      titleOverride: title,
      descriptionOverride: description,
      month: _nextMonth,
      year: _nextYear,
    );
    _nextIndex++;
    _maybeAdvanceMonth();
    _notifications.insert(0, notification);
    return notification;
  }

  void _maybeAdvanceMonth() {
    if (DateTime.now().millisecondsSinceEpoch % 2 == 0) {
      _nextMonth++;
      if (_nextMonth > 12) {
        _nextMonth = 1;
        _nextYear++;
      }
    }
  }

  static Map<String, dynamic> _buildNotification(
    int index, {
    bool unread = false,
    String? titleOverride,
    String? descriptionOverride,
    int? month,
    int? year,
  }) =>
      {
        'id': '${index + 1}',
        'title': titleOverride ?? 'Notification ${index + 1}',
        'description': descriptionOverride ??
            'Description for notification ${index + 1}. '
                'This is a sample notification to demonstrate paginated loading.',
        'body': _buildQuillDelta(index + 1),
        'date': DateTime(
          year ?? DateTime.now().year,
          month ?? DateTime.now().month,
          index % 28 + 1,
        ).toIso8601String(),
        'isUnread': unread,
      };

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
          'insert':
              '. It contains rich text content rendered with a Quill editor.\n\n',
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
        {'insert': '\n'},
        {
          'insert': {
            'image':
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
          },
        },
        {'insert': '\n\n'},
        {
          'insert':
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        },
        {'insert': '\n\n'},
        {
          'insert':
              'Please review the information above and take the appropriate action.',
          'attributes': {'italic': true},
        },
        {'insert': '\n'},
      ];
}
