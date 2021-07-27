import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:github_search/base/common_ui_components/app_error_widget.dart';
import 'package:github_search/base/common_ui_components/app_progress_indicator.dart';
import 'package:github_search/base/common_ui_components/search_bar.dart';
import 'package:github_search/base/models/github_repo.dart';
import 'package:github_search/feature_github_repo_list/ui_components/repo_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import '../../base/theme/design_system.dart';

import '../blocs/github_repo_list_bloc.dart';
import '../di/github_repo_list_dependencies.dart';

class GithubRepoListPage extends StatelessWidget implements AutoRouteWrapper {
  GithubRepoListPage({
    Key? key,
  }) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: GithubRepoListDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: _buildDataContainer(context),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<GithubRepoListBlocType>().events.loadPage(
                      reset: true,
                      hardReset: true,
                    ),
          ),
        ],
      );

  Widget _buildDataContainer(BuildContext context) => Container(
        color: context.designSystem.colors.backgroundColor,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    RxTextFormFieldBuilder<GithubRepoListBlocType>(
                  state: (bloc) => bloc.states.queryFilter,
                  showErrorState: (_) => const Stream.empty(),
                  builder: (fieldState) => SearchBar(
                    controller: fieldState.controller,
                  ),
                  onChanged: (bloc, text) {
                    bloc.events.filterByQuery(text);
                  },
                ),
                // _buildFilters(context),

                childCount: 1,
              ),
            ),
          ],
          body: RxPaginatedBuilder<GithubRepoListBlocType,
              GithubRepo>.withRefreshIndicator(
            state: (bloc) => bloc.states.paginatedList,
            onBottomScrolled: (bloc) => bloc.events.loadPage(),
            onRefresh: (bloc) async {
              bloc.events.loadPage(reset: true);
              return bloc.states.refreshDone;
            },
            buildSuccess: (context, list, bloc) => ListView.builder(
              itemBuilder: (context, index) {
                final item = list.getItem(index);

                if (item == null) {
                  return const AppProgressIndicator();
                }

                return RepoCardWidget(githubRepo: item);
              },
              itemCount: list.itemCount,
            ),
            buildLoading: (context, list, bloc) => const AppProgressIndicator(),
            buildError: (context, list, bloc) => AppErrorWidget(
              error: list.error!,
              onReloadPressed: () => bloc.events.loadPage(
                hardReset: true,
                reset: true,
              ),
            ),
          ),
        ),
      );
}
