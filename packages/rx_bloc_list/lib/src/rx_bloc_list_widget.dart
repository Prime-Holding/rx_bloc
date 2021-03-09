import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rx_bloc_list/src/bloc/pagination_bloc.dart';

class RxBlocList<T> extends StatefulWidget {
  RxBlocList({
    required this.dataRepository,
    required this.builder,
    this.onRefresh,
    this.count = 10,
    Key? key,
  }) : super(key: key);

  // TODO: Item count should be automatically calculated. Remove it from parameter list
  final int count;

  /// The repository from which the data should be pulled
  final DataRepositoryInterface<T> dataRepository;

  /// TODO: Provide the item alongside with its index and buildContext
  /// The builder method for constructing items inside the list
  final Widget Function(BuildContext, int) builder;

  /// Callback triggered once the data was successfully refreshed.
  final Function()? onRefresh;

  @override
  _RxBlocListState<T> createState() => _RxBlocListState<T>();
}

class _RxBlocListState<T> extends State<RxBlocList<T>> {
  late PaginationBloc<T> _paginationBloc;

  /// region Lifecycle events

  @override
  void initState() {
    _paginationBloc = PaginationBloc<T>(widget.dataRepository);
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
        onRefresh: () async {
          _paginationBloc.events.refreshData();

          await _paginationBloc.states.refreshDone.waitToLoad();

          /// TODO: Consider the case where this above fails.
          /// The refresh indicator is stuck forever, in that case.

          // Execute the onRefresh callback (if any) after the refreshing is done
          widget.onRefresh?.call();
          return Future.value(null);
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                widget.builder,
                childCount: widget.count,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// endregion
}

extension _StreamBoolExtensions on Stream<bool> {
  Future<void> waitToLoad() async {
    await this.firstWhere((e) => !e);
    await this.firstWhere((e) => e);
  }
}
