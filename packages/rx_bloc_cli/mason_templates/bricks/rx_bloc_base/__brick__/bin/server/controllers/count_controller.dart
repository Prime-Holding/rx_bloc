import 'package:shelf/shelf.dart';

import '../utils/response_builder.dart';

class CountController {
  var _count = 0;

  final _responseBuilder = ResponseBuilder();

  Future<Response> getCountHandler(Request request) async => Future.delayed(
        const Duration(milliseconds: 300),
        () => _responseBuilder.buildOK({'value': _count}),
      );

  Future<Response> incrementCountHandler(Request request) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      _increment();
      return _responseBuilder.buildOK({'value': _count});
    } on Exception catch (e) {
      return _responseBuilder.buildUnprocessableEntity(e);
    }
  }

  Future<Response> decrementCountHandler(Request request) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      _decrement();
      return _responseBuilder.buildOK({'value': _count});
    } on Exception catch (e) {
      return _responseBuilder.buildUnprocessableEntity(e);
    }
  }

  void _increment() {
    if (_count >= 5) {
      throw Exception('You have reached the maximum count');
    }

    ++_count;
  }

  void _decrement() {
    if (_count <= 0) {
      throw Exception('You have reached the minimum count');
    }

    --_count;
  }
}
