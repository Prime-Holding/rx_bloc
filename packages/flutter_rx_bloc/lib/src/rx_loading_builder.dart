import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../flutter_rx_bloc.dart';

class RxLoadingBuilder<B extends RxBlocTypeBase> extends StatelessWidget {
  RxLoadingBuilder({
    required this.state,
    required this.builder,
    this.bloc,
  });

  final Stream<LoadingWithTag> Function(B) state;
  final B? bloc;
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
