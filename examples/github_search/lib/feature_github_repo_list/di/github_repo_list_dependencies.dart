import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/github_repo_list_bloc.dart';

class GithubRepoListDependencies {
  GithubRepoListDependencies._(this.context);

  factory GithubRepoListDependencies.of(BuildContext context) =>
      _instance != null
          ? _instance!
          : _instance = GithubRepoListDependencies._(context);

  static GithubRepoListDependencies? _instance;

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._repositories,
    ..._blocs,
  ];

  late final List<Provider> _repositories = [];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<GithubRepoListBlocType>(
      create: (context) => GithubRepoListBloc(
        repository: context.read(),
      ),
    ),
  ];
}
