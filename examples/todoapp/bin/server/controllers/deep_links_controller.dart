// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/deep_link_model.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class DeepLinksController extends ApiController {
  final _deepLinkList = [
    DeepLinkModel(
      id: '1',
      name: 'Deep link 1',
      description: 'Short description for Deep link 1',
    ),
    DeepLinkModel(
      id: '2',
      name: 'Deep link 2',
      description: 'Short description for Deep link 2',
    ),
    DeepLinkModel(
      id: '3',
      name: 'Deep link 3',
      description: 'Short description for Deep link 3',
    ),
  ];

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/deep-links',
      deepLinksListHandler,
    );

    router.addRequest(
      RequestType.GET,
      '/api/deep-links/<id>',
      deepLinkByIdHandler,
    );
  }

  Response deepLinksListHandler(Request request) {
    return responseBuilder.buildOK(data: {
      'deepLinkList': _deepLinkList,
    });
  }

  Response deepLinkByIdHandler(Request request) {
    final result = _deepLinkList
        .firstWhereOrNull((deepLink) => deepLink.id == request.params['id']);
    if (result == null) {
      throw NotFoundException(
          'Deep link with id: ${request.params['id']} is not found.');
    }
    return responseBuilder.buildOK(data: result.toJson());
  }
}
