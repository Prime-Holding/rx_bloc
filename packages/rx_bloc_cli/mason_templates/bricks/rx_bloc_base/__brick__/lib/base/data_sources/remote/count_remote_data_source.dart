{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/count.dart';

part 'count_remote_data_source.g.dart';

/// Used as a contractor for remote data source.
/// To make it work, should provide a real API and rerun build_runner
@RestApi(baseUrl: 'http://0.0.0.0:8080/api')
abstract class CountRemoteDataSource {
  factory CountRemoteDataSource(Dio dio, {String baseUrl}) =
      _CountRemoteDataSource;

  @GET('/count')
  Future<Count> getCurrent();

  @POST('/count/increment')
  Future<Count> increment();

  @POST('/count/decrement')
  Future<Count> decrement();
}
