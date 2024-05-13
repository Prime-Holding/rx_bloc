import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_divider.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/models/github_repo_model.dart';
import '../blocs/dashboard_bloc.dart';

class DashboardSearchDelegate extends SearchDelegate<GithubRepoModel> {
  final DashboardBlocType dashboardBloc;

  DashboardSearchDelegate(this.dashboardBloc);

  @override
  List<Widget> buildActions(BuildContext context) => [
        RxBlocBuilder<DashboardBlocType, bool>(
          bloc: dashboardBloc,
          state: (bloc) => bloc.states.isLoading,
          builder: (context, snapshot, bloc) => IconButton(
            icon: snapshot.data ?? true
                ? AppLoadingIndicator.textButtonValue(context)
                : const Icon(Icons.clear),
            onPressed: snapshot.data ?? true ? null : () => query = '',
          ),
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget buildResults(BuildContext context) {
    dashboardBloc.events.searchByQuery(query);

    return RxPaginatedBuilder<DashboardBlocType, GithubRepoModel>(
      bloc: dashboardBloc,
      state: (bloc) => bloc.states.searchList,
      onBottomScrolled: (bloc) => bloc.events.loadPage(),
      buildSuccess: (context, list, bloc) => ListView.separated(
        itemBuilder: (context, index) {
          final item = list.getItem(index);

          if (item == null) {
            return const Center(child: AppLoadingIndicator());
          }

          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
            onTap: () {
              // Show the search results based on the selected suggestion.
              close(context, item);
            },
          );
        },
        itemCount: list.itemCount,
        separatorBuilder: (BuildContext context, int index) =>
            const AppDivider(),
      ),
      buildLoading: (context, list, bloc) =>
          const Center(child: AppLoadingIndicator()),
      buildError: (context, list, bloc) => AppErrorWidget(
        error: list.error!,
        onTabRetry: () => bloc.events.searchByQuery(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) =>
      RxBlocBuilder<DashboardBlocType, List<GithubRepoModel>>(
        state: (bloc) => bloc.states.suggestionList,
        bloc: dashboardBloc,
        builder: (context, snapshot, bloc) => ListView.builder(
          itemCount: snapshot.list.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(snapshot.list[index].name),
            onTap: () {
              // Show the search results based on the selected suggestion.
              close(context, snapshot.list[index]);
            },
          ),
        ),
      );
}

extension _SnapshotToList on AsyncSnapshot<List<GithubRepoModel>> {
  List<GithubRepoModel> get list => data ?? [];
}
