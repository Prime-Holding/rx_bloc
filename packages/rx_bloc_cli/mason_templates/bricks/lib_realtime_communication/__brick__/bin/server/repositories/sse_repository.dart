import 'dart:async';
import 'dart:convert';

class SseRepository {
  final List<StreamController<List<int>>> _clients = [];
  late final _heartbeat = _Heartbeat(_removeDisconnectedClients);

  static final _heartbeatBytes = utf8.encode(':keepalive\n');
  void Function()? onFirstClientConnected;
  void Function()? onLastClientDisconnected;

  int get clientCount => _clients.length;

  Stream<List<int>> connectClient({Map<String, dynamic>? initialEvent}) {
    final controller = StreamController<List<int>>();
    _clients.add(controller);
    print('[SSE] Client connected (${_clients.length} active)');

    if (_clients.length == 1) {
      _heartbeat.startHeartbeat();
      onFirstClientConnected?.call();
    }

    controller.onCancel = () {
      _clients.remove(controller);
      print('[SSE] Client disconnected (${_clients.length} active)');
      if (_clients.isEmpty) {
        _heartbeat.stopHeartbeat();
        onLastClientDisconnected?.call();
      }
    };

    if (initialEvent != null) {
      _sendEvent(controller, initialEvent);
    }

    return controller.stream;
  }

  void broadcastEvent(Map<String, dynamic> event) {
    for (final client in List.of(_clients)) {
      _sendEvent(client, event);
    }
  }

  void _sendEvent(
    StreamController<List<int>> controller,
    Map<String, dynamic> event,
  ) {
    if (controller.isClosed) return;
    final data = 'data:${jsonEncode(event)}\n\n';
    controller.add(utf8.encode(data));
  }

  void _removeDisconnectedClients() {
    for (final client in List.of(_clients)) {
      try {
        if (!client.isClosed) {
          // Try to send some bytes to the client to test if the connection is still alive.
          client.add(_heartbeatBytes);
        }
      } on StateError {
        // Controller was closed between the check and the add; safe to ignore.
      }
    }
  }
}

/// Helper class to manage the heartbeat timer for SSE clients.
class _Heartbeat {
  _Heartbeat(
    this.onTick, {
    // ignore: unused_element_parameter
    this.heartbeatInterval = const Duration(seconds: 1),
  });

  void Function() onTick;
  final Duration heartbeatInterval;
  Timer? _heartbeatTimer;

  /// Start the heartbeat timer and check periodically if the client is still connected.
  /// If the client stream is closed, remove the client from the list of active clients.
  void startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) => onTick.call());
  }

  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }
}
