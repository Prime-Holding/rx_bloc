// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../models/deep_link_model.dart';
import '../repositories/deep_link_repository.dart';

class DeepLinkService {
  DeepLinkService(
    this._deepLinkRepository,
  );

  final DeepLinkRepository _deepLinkRepository;

  Future<List<DeepLinkModel>> fetchDeepLinks() async {
    final result = await _deepLinkRepository.fetchDeepLinks();
    return result.deepLinkList;
  }

  Future<DeepLinkModel> fetchDeepLinkById({required String id}) async {
    return await _deepLinkRepository.fetchDeepLinkById(id: id);
  }
}
