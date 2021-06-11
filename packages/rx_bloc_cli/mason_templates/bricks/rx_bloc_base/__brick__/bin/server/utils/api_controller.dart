import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

import 'response_builder.dart';
import 'server_exceptions.dart';
import 'utilities.dart';

// ignore_for_file: constant_identifier_names

typedef RequestCallback = shelf.Response Function(shelf.Request);

/// Supported REST service request types
enum RequestType { GET, POST, DELETE, PUT, PATCH, HEAD, OPTIONS }

/// [ApiController] is an abstraction that enables the developers to minimise
/// the time spent on writing API routing logic.
abstract class ApiController {
  /// Response builder handle
  final _responseBuilder = ResponseBuilder();

  /// List of all registered endpoints
  final List<_APIEndpointModel> _mappedRequests = [];

  /// Returns the ResponseBuilder of the current instance
  ResponseBuilder get responseBuilder => _responseBuilder;

  /// Registers a callback that is triggered once the specified endpoint has
  /// been reached with a request of the provided request type
  void addRequest(RequestType type, String endpoint, shelf.Handler callback) {
    final _callback = buildSafeHandler(callback, responseBuilder);
    _mappedRequests.add(_APIEndpointModel(type, endpoint, _callback));
  }

  /// Controller specific request mappings should be implemented in this method.
  void registerRequests();
}

/// [RouteGenerator] is a class that automates the generation and registering of
/// API routes. You have to register your [ApiControllers] using the
/// `addController` method and then call the `generateRoutes` which will return
/// a [shelf_router](https://pub.dev/packages/shelf_router) Router that can be
/// registered inside your server.
class RouteGenerator {
  /// The default response builder
  final _responseBuilder = ResponseBuilder();

  /// List of all registered controllers
  final List<ApiController> _controllers = [];

  /// Registers a new controller
  void addController(ApiController controller) {
    _controllers.add(controller);
  }

  /// Removes a previously registered controller (if exists)
  void removeController<T>() {
    _controllers.removeWhere((controller) => controller is T);
  }

  /// Generates a router with routes mapped in all registered controllers.
  /// You can define an optional callback that accepts an object of type Request
  /// and returns a Response, which is triggered once a url was not found.
  shelf_router.Router generateRoutes({shelf.Handler? routeNotFoundHandler}) {
    final _router = _buildRouter(routeNotFoundHandler);

    for (final controller in _controllers) {
      if (controller._mappedRequests.isEmpty) controller.registerRequests();
      controller._mappedRequests.forEach((request) {
        _registerRequest(_router, request);
      });
    }

    return _router;
  }

  /// Builds a default router with an optional handler for the case when the
  /// requested url could not be found.
  shelf_router.Router _buildRouter([shelf.Handler? handler]) =>
      shelf_router.Router(
        notFoundHandler: buildSafeHandler((request) {
          if (handler != null) {
            final response = handler(request);
            return response;
          }
          throw NotFoundException('The requested URL could not be found.');
        }, _responseBuilder),
      );

  /// Registers a specific endpoint to the router
  void _registerRequest(
      shelf_router.Router _router,
      _APIEndpointModel request,
      ) {
    switch (request.requestType) {
      case RequestType.GET:
        _router.get(request.path, request.callback);
        break;
      case RequestType.POST:
        _router.post(request.path, request.callback);
        break;
      case RequestType.DELETE:
        _router.delete(request.path, request.callback);
        break;
      case RequestType.PUT:
        _router.put(request.path, request.callback);
        break;
      case RequestType.PATCH:
        _router.patch(request.path, request.callback);
        break;
      case RequestType.HEAD:
        _router.head(request.path, request.callback);
        break;
      case RequestType.OPTIONS:
        _router.options(request.path, request.callback);
        break;
      default:
        print('Unsupported request type: ${request.requestType}');
    }
  }
}

/// API Endpoint Model containing data related to the specific endpoint
class _APIEndpointModel {
  _APIEndpointModel(this.requestType, this.path, this.callback);

  /// The type of request that will access the endpoint
  final RequestType requestType;

  /// The path representing the API endpoint
  final String path;

  /// The callback triggered once the endpoint has been reached
  final Function callback;
}
