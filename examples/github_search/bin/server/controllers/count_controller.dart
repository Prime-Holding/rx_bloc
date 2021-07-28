import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';

// ignore_for_file: cascade_invocations

class CountController extends ApiController {
  var _count = 0;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/count',
      getCountHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/count/increment',
      incrementCountHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/count/decrement',
      decrementCountHandler,
    );
  }

  Response getCountHandler(Request request) =>
      responseBuilder.buildOK(data: {'value': _count});

  Response incrementCountHandler(Request request) {
    _increment();
    return responseBuilder.buildOK(data: {'value': _count});
  }

  Response decrementCountHandler(Request request) {
    _decrement();
    return responseBuilder.buildOK(data: {'value': _count});
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
