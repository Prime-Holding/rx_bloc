import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rx_bloc_list/src/bloc/pagination_bloc.dart';

class RxBlocList<T> extends StatefulWidget {
  RxBlocList({
    required this.dataRepository,
    required this.builder,
    this.onRefresh,
    this.dataFilter,
    Key? key,
  }) : super(key: key);

  /// The repository from which the data should be pulled
  final DataRepositoryInterface<T> dataRepository;

  /// The builder method for constructing items inside the list
  final Widget Function(BuildContext, int, T) builder;

  /// Callback triggered once the data was successfully refreshed.
  final Function()? onRefresh;

  /// Callback triggered before the data is forwarded to the RxBlocList.
  /// User can define it's custom data filtering, before it is propagated elsewhere.
  final List<T> Function(List<T>)? dataFilter;

  @override
  _RxBlocListState<T> createState() => _RxBlocListState<T>();
}

class _RxBlocListState<T> extends State<RxBlocList<T>> {
  late PaginationBloc<T> _paginationBloc;

  /// region Lifecycle events

  @override
  void initState() {
    _paginationBloc = PaginationBloc<T>(
      widget.dataRepository,
    );
    super.initState();
  }

  @override
  void dispose() {
    _paginationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RxBlocProvider<PaginationBloc<T>>.value(
      value: _paginationBloc,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: RxBlocBuilder<PaginationBloc<T>, List<dynamic>>(
          state: (bloc) => bloc.states.paginatedList,
          builder: (context, listState, _) {
            final items = listState.data ?? [];
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _itemBuilder(context, index, items as List<T>),
                    childCount: items.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// endregion

  /// region Methods

  Future _onRefresh() async {
    // onRefresh is called once the RefreshIndicator's animation reaches
    // its main spinning part. In order to stop that animation, we need to
    // return a future, after we're done with refreshing the data

    _paginationBloc.events.loadPage(reset: true);
    await _paginationBloc.states.refreshDone.waitToLoad();

    /// TODO: Consider the case where this above fails.
    /// The refresh indicator is stuck forever, in that case.

    // Execute the onRefresh callback (if any) after the refreshing is done
    widget.onRefresh?.call();

    return Future.value(null);
  }

  Widget _itemBuilder(BuildContext context, int index, List<T> data) {
    final item = data[index];
    return widget.builder(context, index, item);
  }

  /// endregion
}

extension _StreamBoolExtensions on Stream<bool> {
  Future<void> waitToLoad() async {
    await this.firstWhere((e) => !e);
    await this.firstWhere((e) => e);
  }
}
