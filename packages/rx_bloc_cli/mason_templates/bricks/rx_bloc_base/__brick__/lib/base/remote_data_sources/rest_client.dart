import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/counter.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "http://primeholding.com/api")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/counter")
  Future<Counter> getCount();
}