// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'controllers/authentication_controller.dart';{{#enable_feature_counter}}
import 'controllers/count_controller.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import 'controllers/deep_links_controller.dart';{{/enable_feature_deeplinks}}
import 'controllers/permissions_controller.dart';
import 'controllers/push_notifications_controller.dart';
import 'repositories/auth_token_repository.dart';
import 'services/authentication_service.dart';
import 'utils/api_controller.dart';

Future main() async {
  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final authTokenRepository = AuthTokenRepository();

  final authService = AuthenticationService(authTokenRepository);

  final routeGenerator = await _registerControllers(authService);

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(_staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(routeGenerator.generateRoutes());

  // See https://pub.dev/documentation/shelf/latest/shelf/Pipeline-class.html
  final pipeline = const Pipeline()
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      .addMiddleware(logRequests())
      .addMiddleware(_delayMiddleware())
      .addMiddleware(_securedEndpoints(authService))
      .addHandler(cascade.handler);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    pipeline,
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}

// Serve files from the file system.
final _staticHandler = shelf_static.createStaticHandler('bin/server/public',
    defaultDocument: 'index.html');

/// Registers all controllers that provide some kind of API
Future<RouteGenerator> _registerControllers(
    AuthenticationService authenticationService) async {
  final generator = RouteGenerator()
  {{#enable_feature_counter}}
    ..addController(CountController())
  {{/enable_feature_counter}}
    ..addController(AuthenticationController(authenticationService))
    ..addController(PushNotificationsController())
    ..addController(PermissionsController(authenticationService))
    {{#enable_feature_deeplinks}}
    ..addController(DeepLinksController())
    {{/enable_feature_deeplinks}}
    ;

  /// TODO: Add your controllers here

  return generator;
}

Middleware _delayMiddleware() => (innerHandler) => (request) => Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
      () => innerHandler(request),
    );


// Routes requiring authorization
List<String> securedRoutes = [
  'api/deep-links',
  'api/count',
  'api/count/increment',
  'api/count/decrement',
  'api/user/push-notification-subscriptions',
  'api/send-push-message',
];

Middleware _securedEndpoints(AuthenticationService authenticationService) =>
        (innerHandler) => (request) {
      if (securedRoutes.contains(request.url.path)) {
        if (!request.headers
            .containsKey(AuthenticationService.authHeader)) {
          return Response.unauthorized('User not authorized!');
        }
        try {
          authenticationService.isAuthenticated(request);
        } catch (exception) {
          return Response.unauthorized(exception.toString());
        }
      }

      return Future.sync(() => innerHandler(request))
          .then((response) => response);
    };