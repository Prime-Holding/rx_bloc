import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';

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
    return responseBuilder.buildOK(data: {
      'item': {
        'CounterRouter': true,
        'NotificationsRoute': true,
        'LoginRoute': true,
        'SecuredPageRoute': false,
      }
    });
  }
}
