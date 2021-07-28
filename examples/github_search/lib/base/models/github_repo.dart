import 'package:json_annotation/json_annotation.dart';

part 'github_repo.g.dart';

@JsonSerializable()
class GithubRepo {
  GithubRepo({
    required this.name,
    required this.description,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) =>
      _$GithubRepoFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String description;

  Map<String, dynamic> toJson() => _$GithubRepoToJson(this);
}
