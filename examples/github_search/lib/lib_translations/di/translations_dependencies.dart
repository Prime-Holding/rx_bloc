// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/translations_data_source.dart';
import '../data_sources/translations_remote_data_source.dart';
import '../repositories/translations_repository.dart';
import '../services/translations_service.dart';

class TranslationsDependencies {
  TranslationsDependencies({required this.baseUrl});

  factory TranslationsDependencies.from({
    required String baseUrl,
  }) =>
      TranslationsDependencies(baseUrl: baseUrl);

  final String baseUrl;

  late List<SingleChildWidget> providers = [
    ..._dataSources,
    ..._repositories,
    ..._services,
  ];

  List<SingleChildWidget> get _dataSources => [
        Provider<TranslationsDataSource>(
            create: (context) => TranslationsRemoteDataSource(
                  context.read<ApiHttpClient>(),
                  baseUrl: baseUrl,
                ))
      ];

  List<SingleChildWidget> get _repositories => [
        Provider<TranslationsRepository>(
            create: (context) => TranslationsRepository(
                  context.read(),
                  context.read(),
                ))
      ];

  List<SingleChildWidget> get _services => [
        Provider<TranslationsService>(
            create: (context) => TranslationsService(context.read()))
      ];
}
