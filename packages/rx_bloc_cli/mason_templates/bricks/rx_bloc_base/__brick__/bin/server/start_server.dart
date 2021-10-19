// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'controllers/authentication_controller.dart';
import 'controllers/count_controller.dart';
import 'controllers/push_notifications_controller.dart';
import 'utils/api_controller.dart';

Future main() async {
  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final _routeGenerator = await _registerControllers();

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(_staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(_routeGenerator.generateRoutes());

  // See https://pub.dev/documentation/shelf/latest/shelf/Pipeline-class.html
  final pipeline = const Pipeline()
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      .addMiddleware(logRequests())
      .addMiddleware(_delayMiddleware())
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
Future<RouteGenerator> _registerControllers() async {
  final generator = RouteGenerator()
    ..addController(CountController())
    ..addController(AuthenticationController())
    ..addController(PushNotificationsController());

  /// TODO: Add your controllers here

  return generator;
}

Middleware _delayMiddleware() => (innerHandler) => (request) => Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
      () => innerHandler(request),
    );
