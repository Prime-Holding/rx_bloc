import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'rx_bloc_provider.dart';

class RxBlocBuilder<B extends RxBlocTypeBase, T> extends StatelessWidget {
  const RxBlocBuilder({
    @required this.state,
    @required this.builder,
    this.bloc,
    Key key,
  }) : super(key: key);

  final Stream<T> Function(B) state;
  final B bloc;
  final Widget Function(BuildContext, AsyncSnapshot<T>, B) builder;

  @override
  Widget build(BuildContext context) {
    final block = bloc ?? RxBlocProvider.of<B>(context);

    return StreamBuilder<T>(
      stream: state(block),
      builder: (buildContext, snapshot) =>
          builder(buildContext, snapshot, block),
    );
  }
}
