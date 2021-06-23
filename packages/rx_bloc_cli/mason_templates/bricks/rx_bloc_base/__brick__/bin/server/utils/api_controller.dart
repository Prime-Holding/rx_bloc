import 'dart:convert';

import 'package:collection/collection.dart';
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

  /// Controller list handle
  late final ControllerList _controllerList;

  /// Returns the ResponseBuilder of the current instance
  ResponseBuilder get responseBuilder => _responseBuilder;

  /// Returns a list of registered controllers
  ControllerList get controllers => _controllerList;

  /// Controller specific request mappings should be implemented in this method.
  void registerRequests(WrappedRouter router);

  /// Throws an exception if the provided parameter is not valid
  void throwIfEmpty(String? param, Exception exception) {
    if (param?.isEmpty ?? true) throw exception;
  }
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
  final ControllerList _controllers = ControllerList();

  /// Registers a new controller
  void addController<T extends ApiController>(T controller) {
    _controllers._addController(controller);
  }

  /// Removes a previously registered controller (if exists)
  void removeController<T extends ApiController>() {
    _controllers._removeController<T>();
  }

  /// Generates a router with routes mapped in all registered controllers.
  /// You can define an optional callback that accepts an object of type Request
  /// and returns a Response, which is triggered once a url was not found.
  shelf_router.Router generateRoutes({shelf.Handler? routeNotFoundHandler}) {
    final _router = _buildRouter(routeNotFoundHandler);
    final _wrapperRouter = WrappedRouter(_router, _responseBuilder);

    for (final controller in _controllers._controllers) {
      controller.registerRequests(_wrapperRouter);
    }

    return _router;
  }

  /// Builds a default router with an optional handler for the case when the
  /// requested url could not be found.
  shelf_router.Router _buildRouter([shelf.Handler? handler]) =>
      shelf_router.Router(
        notFoundHandler: buildSafeHandler((request) async {
          if (handler != null) {
            final response = await handler(request);
            return response;
          }
          throw NotFoundException('The requested URL could not be found.');
        }, _responseBuilder),
      );
}

/// A wrapper representing a list of registered controllers. It provides access
/// to any of the registered controllers within the controllers itself. Useful
/// when communication between different parts of the system are required.
class ControllerList {
  /// The internal list of all registered controllers
  final _controllers = <ApiController>[];

  /// Registers a new controller
  void _addController<T extends ApiController>(T controller) {
    controller._controllerList = this;
    _controllers.add(controller);
  }

  /// Removes a previously registered controller (if it exists)
  void _removeController<T extends ApiController>() {
    _controllers.removeWhere((controller) => controller is T);
  }

  /// Returns a previously registered controller of provided type
  T? getController<T extends ApiController>() {
    final val = _controllers.firstWhereOrNull((controller) => controller is T);
    return val != null ? val as T : null;
  }
}

/// Wrapper around the Router class that lets you register requests in a safe
/// manner, so that once an error occurs, it is captured and an appropriate
/// response is returned back.
class WrappedRouter {
  WrappedRouter(this._router, this._responseBuilder);

  /// The router to which the requests will be mapped to
  final shelf_router.Router _router;

  /// Response builder that will catch and build error responses in case when
  /// an exception is thrown
  final ResponseBuilder _responseBuilder;

  /// Adds a new request to the router
  void addRequest(
    RequestType type,
    String path,
    Function(shelf.Request) callback,
  ) {
    final _callback = buildSafeHandler(callback, _responseBuilder);
    _registerCallback(type, path, _callback);
  }

  /// Adds a new request to the router that contains a parameter as part of the
  /// path. That parameter in the path should be placed between < and > . Also,
  /// the provided callback should be able to accept that parameter as String.
  ///
  /// Example:
  ///
  /// /api/users/<userId>/profile
  ///
  void addRequestWithParam(
    RequestType type,
    String path,
    Function(shelf.Request, String) callback,
  ) {
    final _callback = _buildSafeHandlerParam(callback, _responseBuilder);
    _registerCallback(type, path, _callback);
  }

  /// Builds a wrapper around the callback with a parameter which helps easily
  /// detect and respond to different kinds of errors/exceptions.
  Function _buildSafeHandlerParam(
          Function callback, ResponseBuilder responseBuilder) =>
      (request, param) async {
        try {
          final response = await callback(request, param);
          return response;
        } on ResponseException catch (e) {
          return responseBuilder.buildErrorResponse(e, request: request);
        } on Exception catch (e) {
          return responseBuilder.buildUnprocessableEntity(e, request: request);
        }
      };

  /// Registers the request of supported types
  void _registerCallback(RequestType type, String path, Function callback) {
    switch (type) {
      case RequestType.GET:
        _router.get(path, callback);
        break;
      case RequestType.POST:
        _router.post(path, callback);
        _router.options(path, (_) => _responseBuilder.buildOK());
        break;
      case RequestType.DELETE:
        _router.delete(path, callback);
        break;
      case RequestType.PUT:
        _router.put(path, callback);
        _router.options(path, (_) => _responseBuilder.buildOK());
        break;
      case RequestType.PATCH:
        _router.patch(path, callback);
        _router.options(path, (_) => _responseBuilder.buildOK());
        break;
      case RequestType.HEAD:
        _router.head(path, callback);
        break;
      case RequestType.OPTIONS:
        _router.options(path, callback);
        break;
    }
  }
}

/// Extensions
extension RequestBodyExtensions on shelf.Request {
  static const _formContentDescriptor = 'Content-Disposition: form-data; ';
  static const _formDashSeparator = '----------------------------';

  /// Parses the contents of the body and return it as a Map of values
  Future<Map<String, dynamic>> bodyFromFormData() async {
    final bodyAsString = await readAsString();

    // If the body does contains at least one 'form-data' substring, the
    // request body is formatted as form data.
    if (bodyAsString.contains('form-data')) {
      return _fromFormData(bodyAsString);
    } else if (bodyAsString.startsWith('{') && bodyAsString.endsWith('}')) {
      // The data is a json string, so parse it
      return json.decode(bodyAsString);
    }

    // Else the format is not recognized, so return an empty map
    return {};
  }

  Map<String, String> _fromFormData(String body) {
    String? key, value;
    final data = <String, String>{};

    body
        .split('\n')
        .where(
            (ln) => ln.trim().isNotEmpty && !ln.startsWith(_formDashSeparator))
        .map((ln) => ln.replaceAll(_formContentDescriptor, ''))
        .toList()
        .forEach((line) {
      final ln = line.trim();
      print(ln);
      if (ln.startsWith('name="') && ln.endsWith('"')) {
        key = ln.replaceAll('name=', '').replaceAll('"', '');
        value = null;
      } else {
        value = ln;
      }

      if (key != null && value != null) {
        data.addAll({key!: value!});
        key = null;
      }
    });

    return data;
  }
}
