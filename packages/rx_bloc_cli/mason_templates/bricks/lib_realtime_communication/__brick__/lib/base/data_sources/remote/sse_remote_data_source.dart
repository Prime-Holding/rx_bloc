import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../models/errors/error_model.dart';
import '../../models/response_models/sse_message_model.dart';
import '../../utils/sse_utilities.dart';

class SseRemoteDataSource {
  SseRemoteDataSource(this._dio, this._baseUrl);

  final String _baseUrl;
  final Dio _dio;

  Stream<SseMessageModel> getEventStream() async* {
    final response = await _dio.get<ResponseBody>(
      '$_baseUrl/api/sse',
      options: Options(
        headers: {
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
        },
        responseType: ResponseType.stream,
      ),
    );

    if (response.data != null) {
      yield* response.data!.stream
          .transform<List<int>>(
            StreamTransformer.fromHandlers(
              handleData: (data, sink) => sink.add(List<int>.from(data)),
            ),
          )
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .transform(const SseTransformer());
    }

    // Throw an error instead of silently failing to deliver a response stream.
    throw NetworkErrorModel();
  }
}
