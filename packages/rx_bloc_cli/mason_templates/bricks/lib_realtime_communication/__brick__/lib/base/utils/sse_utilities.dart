import 'dart:async';

import '../models/response_models/sse_message_model.dart';

class SseTransformer extends StreamTransformerBase<String, SseMessageModel> {
  const SseTransformer();
  @override
  Stream<SseMessageModel> bind(Stream<String> stream) {
    return Stream.eventTransformed(stream, (sink) => _SseEventSink(sink));
  }
}

class _SseEventSink implements EventSink<String> {
  _SseEventSink(this._eventSink);

  final EventSink<SseMessageModel> _eventSink;

  String? _id;
  String _event = 'message';
  String _data = '';
  int? _retry;

  @override
  void add(String event) {
    if (event.startsWith('id:')) {
      _id = event.substring(3);
      return;
    }
    if (event.startsWith('event:')) {
      _event = event.substring(6);
      return;
    }
    if (event.startsWith('data:')) {
      _data = event.substring(5);
      return;
    }
    if (event.startsWith('retry:')) {
      _retry = int.tryParse(event.substring(6));
      return;
    }
    if (event.isEmpty) {
      _eventSink.add(
        SseMessageModel(id: _id, event: _event, data: _data, retry: _retry),
      );
      _id = null;
      _event = 'message';
      _data = '';
      _retry = null;
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _eventSink.addError(error, stackTrace);
  }

  @override
  void close() {
    _eventSink.close();
  }
}
