// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';
import 'authentication_controller.dart';

class PermissionsController extends ApiController {
  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/permissions',
      permissionsHandler,
    );
  }

  Response permissionsHandler(Request request) {
    try {
      controllers
          .getController<AuthenticationController>()
          ?.isAuthenticated(request);
    } catch (exception) {
      return responseBuilder.buildOK(data: {
         'DevMenuRoute': true,
        'LoginRoute': true,
        'EnterMessageRoute': false,
        'DeepLinksRoute': false,
        'DeepLinkDetailsRoute': false,
      });
    }
    return responseBuilder.buildOK(data: {
         'DevMenuRoute': true,
      'LoginRoute': false,
      'EnterMessageRoute': true,
      'DeepLinksRoute': true,
      'DeepLinkDetailsRoute': true,
    });
  }
}