// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubRepoModel _$GithubRepoModelFromJson(Map<String, dynamic> json) =>
    GithubRepoModel(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['html_url'] as String,
    );

Map<String, dynamic> _$GithubRepoModelToJson(GithubRepoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'html_url': instance.url,
    };
