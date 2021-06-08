import 'package:shelf/shelf.dart';

import '../utils/response_builder.dart';

class CountController {
  var _count = 0;

  final _responseBuilder = ResponseBuilder();

  Response getCountHandler(Request request) =>
      _responseBuilder.buildOK({'count': _count});

  Response incrementCountHandler(Request request) {
    try {
      _increment();
      return _responseBuilder.buildOK({'count': _count});
    } on Exception catch (e) {
      return _responseBuilder.buildUnprocessableEntity(e);
    }
  }

  Response decrementCountHandler(Request request) {
    try {
      _decrement();
      return _responseBuilder.buildOK({'count': _count});
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
