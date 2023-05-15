class SseMessageModel {
  const SseMessageModel({
    this.id,
    required this.event,
    required this.data,
    this.retry,
  });

  final String? id;
  final String event;
  final String data;
  final int? retry;
}
