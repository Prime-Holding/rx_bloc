import 'package:flutter/material.dart';
import 'package:github_search/base/models/github_repo.dart';

class RepoCardWidget extends StatelessWidget {
  const RepoCardWidget({
    required GithubRepo githubRepo,
    Key? key,
  })  : _githubRepo = githubRepo,
        super(key: key);

  final GithubRepo _githubRepo;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 3,
        child: ListTile(
          title: Text(_githubRepo.name),
          subtitle: Text(_githubRepo.description),
        ),
      );
}
