// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:json_annotation/json_annotation.dart';

import '../deep_link_model.dart';

part 'deep_link_list_response_model.g.dart';

@JsonSerializable()
class DeepLinkListResponseModel {
  DeepLinkListResponseModel(
    this.deepLinkList,
  );

  final List<DeepLinkModel> deepLinkList;

  factory DeepLinkListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeepLinkListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeepLinkListResponseModelToJson(this);
}
