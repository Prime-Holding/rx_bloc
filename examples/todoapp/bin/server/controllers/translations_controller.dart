// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';

import '../repositories/translations_repository.dart';
import '../utils/api_controller.dart';

class TranslationsController extends ApiController {
  TranslationsController(TranslationsRepository translationsRepository)
      : _translationsRepository = translationsRepository;

  final TranslationsRepository _translationsRepository;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/translations',
      _getTranslations,
    );
  }

  Response _getTranslations(Request request) => responseBuilder.buildOK(data: {
        'translations': _translationsRepository.getTranslations(),
      });
}
