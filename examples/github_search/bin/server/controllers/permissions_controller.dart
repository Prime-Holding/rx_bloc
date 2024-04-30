// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';

class PermissionsController extends ApiController {
  PermissionsController();

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/permissions',
      permissionsHandler,
    );
  }

  Response permissionsHandler(Request request) {
    return responseBuilder.buildOK(data: {
      'DashboardRoute': true,
      'ProfileRoute': true,
      'SplashRoute': true,
      'NotificationsRoute': true,
    });
  }
}
