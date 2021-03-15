import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../models.dart';

/// TODO: Update the documentation

/// RxPaginatedBuilder documentation - To Be Added
class RxPaginatedBuilder<B extends RxBlocTypeBase, T> extends StatefulWidget {
  RxPaginatedBuilder({
    required this.state,
    required this.builder,
    required this.onBottomScrolled,
    this.wrapperBuilder,
    this.onScrolled,
    this.scrollThreshold = 100.0,
    this.enableOnBottomScrolledCallback = true,
    this.bloc,
  });

  /// Builder method which is triggered each time when new data has been fetched,
  /// and should return a widget as result.
  ///
  /// The [builder] method providers a [BuildContext], the [AsyncSnapshot] data
  /// containing a [PaginatedList] of items and the [BLoC].
  final Widget Function(BuildContext, AsyncSnapshot<PaginatedList<T>>, B)
      builder;

  /// The state of the [BloC] to listen to for changes in data. The state is
  /// represented as a [Stream] of [PaginatedList], which contains individual items.
  final Stream<PaginatedList<T>> Function(B) state;

  /// Callback triggered once the user gets to the bottom of the list while
  /// scrolling when a threshold has been passed. This callback is triggered only
  /// if the [enableOnBottomScrolledCallback] is set to true.
  final void Function(B) onBottomScrolled;

  /// Optional builder method that is intended for creation of a wrapper widget
  /// on top of the widget built using the [builder] method. This can be handy
  /// when implementing onRefresh or any other features requiring the widget
  /// beforehand (for example for building a [RefreshIndicator] around the widget).
  ///
  /// The [wrapperBuilder] method provides a [BuildContext], the [BLoC] and the
  /// build [childWidget].
  final Widget Function(BuildContext, B, Widget)? wrapperBuilder;

  /// When set to true [onBottomScrolled] is executed once the user scrolls at the
  /// bottom of the list.
  final bool enableOnBottomScrolledCallback;

  /// Minimum threshold (defaults to 100 pixels) that needs to be passed in order
  /// for the [onBottomScrolled] to be triggered.
  final double scrollThreshold;

  /// Optional callback triggered while the user is scrolling the list.
  final Function(bool)? onScrolled;

  /// The [BLoC] (Business Logic of Component) that is used. If none is specified
  /// a lookup is performed in the widget tree to find the nearest ancestor.
  final B? bloc;

  @override
  _RxPaginatedBuilderState<B, T> createState() =>
      _RxPaginatedBuilderState<B, T>();
}

class _RxPaginatedBuilderState<B extends RxBlocTypeBase, T>
    extends State<RxPaginatedBuilder<B, T>> {
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    final bloc = RxBlocProvider.of<B>(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) =>
          _onScrollNotification(scrollInfo, bloc),
      child: RxBlocBuilder<B, PaginatedList<T>>(
          bloc: bloc,
          state: widget.state,
          builder: (context, snapshot, bloc) {
            final builtWidget = widget.builder(context, snapshot, bloc);
            if (widget.wrapperBuilder != null)
              return widget.wrapperBuilder!.call(context, bloc, builtWidget);
            return builtWidget;
          }),
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
