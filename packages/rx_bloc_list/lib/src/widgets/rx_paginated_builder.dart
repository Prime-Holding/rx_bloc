import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../models.dart';

/// TODO: Update the documentation
///
/// Use PaginatedContainer to gain scroll notifications functionality
///
/// The parameter [scrollThreshold] is the distance from the end of the scroll when [onBottomScrolled] will be called.
/// The parameter [enableOnBottomScrolledCallback] is used for enable/disable the callback in order to stop receiving many callback while data is loaded
///
/// There is two available callbacks:
/// #1 [onBottomScrolled] is called when the user reaches the bottom of the scroll in respect with the given [scrollThreshold]
/// #2 [onScrolled] is called when the user is no longer at the top of the scroll
///
/// UI LAYER SAMPLE IMPLEMENTATION (Or you can refer to 'lib/src/sample/sample_feature/widgets/body.dart')
///
/// #1 Widget sample
///
/// return PaginatedContainer(
///       enableOnBottomScrolledCallback: !viewState.isLoading,
///       onScrolled: (bool isScrolled) {
///         setState(() {
///            isScrolled = isScrolled;
///         });
///       },
///       onBottomScrolled: () {
///         bloc.dispatchAction(_GetData());
///       },
///       child: CBSliverScaffold(
///         floatingActionButton: viewState.showFilterButton
///             ? _FilterButton(visible: viewState.showFilterButton)
///             : null,
///         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
///         appBar: _buildAppBar(context, viewState),
///       ),
///     );
///
/// #2 Item builder sample
///
/// return SliverChildBuilderDelegate(
///   (BuildContext context, int index) => !viewState.showDepositAccounts
///       ? viewState.loading.isPage && index == viewState.data.length
///           ? LoadingListItem()
///           : _ActivityChequeListItem(
///               key: viewState.data[index].key,
///               cheque: viewState.data[index],
///               isFirst: index == 0,
///               isLast: index == (viewState.data.length - 1),
///             )
///       : _ActivityDepositListItem.withCard(
///           deposit: viewState.depositAccounts[index],
///           isFirst: index == 0,
///           isLast: index == (viewState.depositAccounts.length - 1),
///           listIndex: index,
///         ),
///   childCount: viewState.showDepositAccounts
///       ? viewState.depositAccounts.length
///       : viewState.data.length + (viewState.loading.isPage ? 1 : 0),
/// );
///
/// BLOC SAMPLE IMPLEMENTATION (Or you can refer to 'lib/src/sample/sample_feature/bloc/sample_bloc.dart')
///
/// void _getData(_GetDataAction action) async {
///     final int currentCount = viewState.data.length;
///     //Check if we need to make a call to the BE
///     if (currentCount < viewState.totalCount || action.refresh) {
///       /// show progress
///       dispatchViewState(
///         viewState.copyWith(
///           isLoading: true,
///         ),
///       );
///
///       try {
///         /// fetch data
///         final data = await sampleUseCase.execute(
///           _SampleUseCaseParam(
///             count: currentCount,
///             refresh: action.refresh,
///           ),
///         );
///         .......

typedef BuilderMethod<B, T> = Widget Function(
    BuildContext, AsyncSnapshot<PaginatedList<T>>, B);

class RxPaginatedBuilder<B extends RxBlocTypeBase, T> extends StatefulWidget {
  RxPaginatedBuilder({
    required this.state,
    required this.builder,
    required this.onBottomScrolled,
    this.onScrolled,
    this.onRefresh,
    this.scrollThreshold = 100.0,
    this.enableOnBottomScrolledCallback = true,
    this.bloc,
  });

  final Stream<PaginatedList<T>> Function(B) state;
  final B? bloc;
  final BuilderMethod<B, T> builder;

  final void Function(B) onBottomScrolled;
  final Function(bool)? onScrolled;
  final Future<void> Function(B)? onRefresh;
  final double scrollThreshold;
  final bool enableOnBottomScrolledCallback;

  @override
  _RxPaginatedBuilderState<B, T> createState() =>
      _RxPaginatedBuilderState<B, T>();
}

class _RxPaginatedBuilderState<B extends RxBlocTypeBase, T>
    extends State<RxPaginatedBuilder<B, T>> {
  bool _isScrolled = false;

  /// Returns the appropriate builder depending on whether we have specified
  /// the onRefresh callback or not, resulting in the onRefresh feature being
  /// absent if there is no callback set.
  BuilderMethod<B, T> get _childBuilder => widget.onRefresh != null
      ? (c, s, b) => RefreshIndicator(
            child: widget.builder(c, s, b),
            onRefresh: () => widget.onRefresh!.call(b),
          )
      : widget.builder;

  @override
  Widget build(BuildContext context) {
    final bloc = RxBlocProvider.of<B>(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) =>
          _onScrollNotification(scrollInfo, bloc),
      child: RxBlocBuilder<B, PaginatedList<T>>(
        bloc: bloc,
        state: widget.state,
        builder: _childBuilder,
      ),
    );
  }

  bool _onScrollNotification(ScrollNotification scrollInfo, B bloc) {
    //handle onScrolled event
    if (widget.onScrolled != null) {
      if (scrollInfo.metrics.axis == Axis.vertical && scrollInfo.depth == 0) {
        final bool isScrolled = scrollInfo.metrics.pixels > 0;
        if (isScrolled != _isScrolled && widget.onScrolled != null) {
          _isScrolled = isScrolled;
          widget.onScrolled!(isScrolled);
        }
      }
    }

    //handle bottomScrolled event
    if (widget.enableOnBottomScrolledCallback &&
        scrollInfo.metrics.axis == Axis.vertical &&
        scrollInfo.metrics.maxScrollExtent - scrollInfo.metrics.pixels <=
            widget.scrollThreshold) {
      widget.onBottomScrolled(bloc);
    }

    return true;
  }
}
