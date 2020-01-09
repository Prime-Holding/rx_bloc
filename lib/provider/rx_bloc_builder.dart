import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'rx_bloc_provider.dart';

class RxBlocBuilder<B extends RxBlocTypeBase, T> extends StatelessWidget {
  final Stream<T> Function(B) state;

  final Widget Function(BuildContext, AsyncSnapshot<T>, B) builder;

  const RxBlocBuilder({
    @required this.state,
    @required this.builder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final block = RxBlocProvider.of<B>(context);

    return StreamBuilder<T>(
      stream: state(block),
      builder: (builContext, snapshot) => builder(builContext, snapshot, block),
    );
  }
}
