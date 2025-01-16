{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/country_code_model.dart';

part 'country_codes_remote_data_source.g.dart';

/// Used as a contractor for remote data source.
/// To make it work, should provide a real API and rerun build_runner
@RestApi()
abstract class CountryCodesRemoteDataSource {
  factory CountryCodesRemoteDataSource(Dio dio, {String baseUrl}) =
      _CountryCodesRemoteDataSource;

  @GET('/api/country-codes')
  Future<Map<String, List<CountryCodeModel>>> getCountryCodes();
}
