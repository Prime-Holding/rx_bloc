import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/count.dart';
import 'count_data_source.dart';

// part 'rest_client.g.dart';

@RestApi(baseUrl: "http://api.primeholding.com")
abstract class CountRemoteDataSource implements CountDataSource{
  factory CountRemoteDataSource(Dio dio)=> CountRemoteDataSource(dio);
  // factory CountRemoteDataSource(Dio dio, {String baseUrl}) = _CountRemoteDataSource;

  @GET("/count")
  @override
  Future<Count> getCurrent();

  @PUT("/count/increment")
  @override
  Future<Count> increment();

  @PUT("/count/decrement")
  @override
  Future<Count> decrement();
}