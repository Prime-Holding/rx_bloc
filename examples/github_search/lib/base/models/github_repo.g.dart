// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubRepo _$GithubRepoFromJson(Map<String, dynamic> json) => GithubRepo(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$GithubRepoToJson(GithubRepo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
