import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../models.dart';

/// *RxPaginatedBuilder* provides the flexibility and simplicity of presentation
/// of paginated data with the use of
/// [RxBloc](https://github.com/Prime-Holding/rx_bloc "RxBloc")s inside the
/// *RxBloc ecosystem*. It was created with the intention of presenting a list
/// of data that can be loaded once that list has reached its end, or can be
/// refreshed using a pull-to-refresh feature (see *RxPaginatedBuilder.withRefreshIndicator*).
///
///
/// In order to make use of the RxPaginatedBuilder, you first need to specify the
/// following required parameters:
/// - [state] is the state of the BLoC that will be listened for changes. The
/// state is a `Stream<PaginatedList<T>>` where T is the type of the data that
/// is being paginated.
/// - [builder] is the method which creates the child widget. Every time the
/// state updates, this method is executed and the widget is rebuild. Inside the
/// builder method you have access to the `BuildContext`,
/// `AsyncSnapshot<PaginatedList<T>>` of the data that is being paginated and
/// the `BLoC` that contains the listened state.
/// - [onBottomScrolled] is a callback that is executed once the end of the list
/// is reached. This can be, for instance, used for fetching the next page of data.
///
/// *RxPaginatedBuilder* also comes with additional optional parameters that can
/// be adjusted to you needs.
///
/// The [wrapperBuilder] method is a builder method with the intention of
/// creating a wrapper widget around the child widget built using the main
/// [builder] method. The wrapperBuilder method gives you access to the
/// `BuildContext`, `BLoC` containing the state that is listened and the `Widget`
/// that is build with the `builder` method. This method can be used for adding
/// additional functionality or help in cases when the built child widget is
/// needed beforehand.
///
/// You can manage the execution of the [onBottomScrolled] parameter by enabling
/// or disabling it via the [enableOnBottomScrolledCallback].
///
/// Additionally, you can define the minimum scroll threshold which will execute
/// the [onBottomScrolled] callback by changing the value of [scrollThreshold].
/// The default value of the scroll threshold is 100 pixels.
///
/// The RxPaginatedBuilder also provides the ability to react to scrolling via
/// the [onScrolled] callback, with a parameter telling whether the user is or
/// has stopped scrolling.
///
/// There may be cases where you have a reference to the BLoC that is used by the
/// RxPaginatedBuilder. By specifying the [bloc] parameter you remove the need
/// to perform a lookup for that BLoC in the widget tree, improving the
/// performance by a small bit.
///
/// Here is an example of what a RxPaginatedBloc using a UserBloc looks like:
///
/// ```
/// RxPaginatedBuilder<UserBloc,User>(
///   state: (bloc) => bloc.states.paginatedUsers,
///   onBottomScrolled: (bloc) => bloc.events.loadNextPage(),
///   builder: (context, snapshot, bloc) => _buildPaginatedList(snapshot),
/// );
/// ```
///
/// Sometimes, you may want to have a working pagination and pull-to-refresh
/// without spending too much time on it. Using the
/// *RxPaginatedBuilder.withRefreshIndicator* gives you access to a
/// [Refresh Indicator](https://api.flutter.dev/flutter/material/RefreshIndicator-class.html "Refresh Indicator")
/// straight out of the box.
///
/// Along with the required parameters of the default implementation,
/// *RxPaginatedBuilder.withRefreshIndicator* gets rid of the [wrapperBuilder]
/// but introduces a new required parameter [onRefresh]. The [onRefresh] callback
/// is triggered once a pull-to-refresh has been performed. The callback,
/// containing the BLoC as a parameter, should return a future, which once
/// complete will make the refresh indicator disappear.
///
/// Here is an example of what a RxPaginatedBloc using a UserBloc looks like
/// using the *withRefreshIndicator* constructor :
///
/// ```
/// RxPaginatedBuilder<UserBloc,User>.withRefreshIndicator(
///   state: (bloc) => bloc.states.paginatedUsers,
///   onBottomScrolled: (bloc) => bloc.events.loadNextPage(),
///   builder: (context, snapshot, bloc) => _buildPaginatedList(snapshot),
///   onRefresh: (bloc) async => bloc.events.refreshData();
/// );
/// ```
///
class RxPaginatedBuilder<B extends RxBlocTypeBase, T> extends StatefulWidget {
  /// RxPaginatedBuilder default constructor
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

  /// RxPaginatedBuilder constructor with refresh indicator.
  /// An addition to the default constructor is the requirement for the
  /// [onRefresh] callback which will be executed once the refreshed using
  /// the pull-down to refresh feature.
  factory RxPaginatedBuilder.withRefreshIndicator({
    required Stream<PaginatedList<T>> Function(B) state,
    required Widget Function(BuildContext, AsyncSnapshot<PaginatedList<T>>, B)
        builder,
    required void Function(B) onBottomScrolled,
    required Future<void> Function(B) onRefresh,
    Function(bool)? onScrolled,
    B? bloc,
    double scrollThreshold = 100,
    bool enableOnBottomScrolledCallback = true,
  }) =>
      RxPaginatedBuilder(
        bloc: bloc,
        state: state,
        builder: builder,
        onBottomScrolled: onBottomScrolled,
        onScrolled: onScrolled,
        scrollThreshold: scrollThreshold,
        enableOnBottomScrolledCallback: enableOnBottomScrolledCallback,
        wrapperBuilder: (_, b, c) => RefreshIndicator(
          child: c,
          onRefresh: () async => await onRefresh(b),
        ),
      );

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

  /// Callback executed once the user starts scrolling the portion of the screen
  /// encapsulated with the widget built using the [builder] method.
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
