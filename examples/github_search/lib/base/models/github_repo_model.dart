import 'package:json_annotation/json_annotation.dart';

part 'github_repo_model.g.dart';

@JsonSerializable()
class GithubRepoModel {
  GithubRepoModel({
    required this.name,
    required this.description,
    required this.url,
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) =>
      _$GithubRepoModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String description;

  @JsonKey(name: 'html_url')
  final String url;

  Map<String, dynamic> toJson() => _$GithubRepoModelToJson(this);
}
