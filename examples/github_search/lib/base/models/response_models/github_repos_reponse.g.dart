// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repos_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubReposResponse _$GithubReposResponseFromJson(Map<String, dynamic> json) =>
    GithubReposResponse(
      totalCount: json['total_count'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => GithubRepo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GithubReposResponseToJson(
        GithubReposResponse instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'items': instance.items,
    };
