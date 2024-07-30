// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'di/server_dependencies.dart';{{#has_authentication}}
import 'services/authentication_service.dart';{{/has_authentication}}
import 'utils/utilities.dart';

Future main() async {
  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final config = await configureRoutesAndDependencies(
    ServerDependencies.registerControllers,
    ServerDependencies.registerDependencies,
  );

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(_staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(config.routeGenerator.generateRoutes().call);

  // See https://pub.dev/documentation/shelf/latest/shelf/Pipeline-class.html
  final pipeline = const Pipeline()
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      .addMiddleware(logRequests())
      .addMiddleware(_delayMiddleware()){{#has_authentication}}
      .addMiddleware(_securedEndpoints(config.di.get())){{/has_authentication}}
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


Middleware _delayMiddleware() => (innerHandler) => (request) => Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
      () => innerHandler(request),
    );{{#has_authentication}}


// Routes requiring authorization
List<String> securedRoutes = [
  'api/deep-links',
  'api/count',
  'api/count/increment',
  'api/count/decrement',
  'api/user/push-notification-subscriptions',
  'api/send-push-message',{{#enable_tfa}}
  'api/tfa/actions/<action>',
  'api/tfa/<transactionId>'{{/enable_tfa}}
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
    };{{/has_authentication}}
