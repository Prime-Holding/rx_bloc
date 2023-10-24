{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/i18n_models.dart';
import 'translations_data_source.dart';

part 'translations_remote_data_source.g.dart';

@RestApi()
abstract class TranslationsRemoteDataSource extends TranslationsDataSource {
  factory TranslationsRemoteDataSource(Dio dio, {String baseUrl}) =
      _TranslationsRemoteDataSource;

  @override
  @GET('/api/translations')
  Future<I18nSections?> getTranslations();
}
