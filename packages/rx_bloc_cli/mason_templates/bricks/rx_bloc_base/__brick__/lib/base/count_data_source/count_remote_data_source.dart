// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/count.dart';
import 'count_data_source.dart';

part 'count_remote_data_source.g.dart';

/// Used as a contractor for remote data source.
/// To make it work, should provide a real API and rerun build_runner
@RestApi(baseUrl: 'https://api.primeholding.com')
abstract class CountRemoteDataSource implements CountDataSource{
  factory CountRemoteDataSource(Dio dio,
      {String baseUrl}) = _CountRemoteDataSource;

  @GET('/count')
  @override
  Future<Count> getCurrent();

  @PUT('/count/increment')
  @override
  Future<Count> increment();

  @PUT('/count/decrement')
  @override
  Future<Count> decrement();
}