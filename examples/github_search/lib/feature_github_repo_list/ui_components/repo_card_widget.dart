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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: 3,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_githubRepo.name),
            ),
            subtitle: Text(_githubRepo.description),
          ),
        ),
      );
}
