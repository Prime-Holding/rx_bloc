import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../flutter_rx_bloc.dart';

/// [RxLoadingBuilder] handles building a widget in response
/// to new [LoadingWithTag] states
///
/// Example:
/// ```
/// RxLoadingBuilder<CounterBlocType>(
///         state: (bloc) => bloc.states.isLoading, //Stream of type LoadingWithTag
///         builder: (context, isLoading, tag, bloc) => Row(
///           children: [
///             ActionButton(
///               tooltip: 'Increment',
///               iconData: Icons.add,
///               onPressed: bloc.events.increment,
///               disabled: isLoading,
///               loading: isLoading && tag == CounterBloc.tagIncrement,
///             ),
///             const SizedBox(width: 16),
///             ActionButton(
///               tooltip: 'Decrement',
///               iconData: Icons.remove,
///               onPressed: bloc.events.decrement,
///               disabled: isLoading,
///               loading: isLoading && tag == CounterBloc.tagDecrement,
///             ),
///           ],
///         ),
///       );
/// ```
///
/// See also:
///   * [RxBlocBuilder], which handles building the widget in response
///     to new states
///
///   * [StreamBuilder], which delegates to an [AsyncWidgetBuilder] to build
///     itself based on a snapshot from interacting with a [Stream].
class RxLoadingBuilder<B extends RxBlocTypeBase> extends StatelessWidget {
  /// The default constructor
  const RxLoadingBuilder({
    required this.state,
    required this.builder,
    this.bloc,
    Key? key,
  }) : super(key: key);

  /// The bloc state the widget is listening to
  final Stream<LoadingWithTag> Function(B) state;

  /// An optional bloc instance.
  ///
  /// If not supplied the RxLoadingBuilder will do an automatic lookup to find
  /// an instance of the specified bloc.
  final B? bloc;

  /// A callback that will be invoked in response to state change.
  final Widget Function(BuildContext, bool isLoading, String tag, B) builder;

  @override
  Widget build(BuildContext context) {
    final block = bloc ?? RxBlocProvider.of<B>(context);

    return StreamBuilder<LoadingWithTag>(
      stream: state(block),
      builder: (buildContext, snapshot) {
        if (!snapshot.hasData) {
          return builder(buildContext, true, '', block);
        }

        return builder(
          buildContext,
          snapshot.data!.loading,
          snapshot.data!.tag,
          block,
        );
      },
    );
  }
}
