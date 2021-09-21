import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../blocs/counter_bloc.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({
    Key? key,
    this.bloc,
  }) : super(key: key);

  final CounterBlocType? bloc;

  static const countKey = 'count_key';
  static const noCountKey = 'no_count_key';

  @override
  Widget build(BuildContext context) => RxBlocBuilder<CounterBlocType, int>(
        state: (bloc) => bloc.states.count.whereSuccess(),
        bloc: bloc,
        builder: (context, snapshot, bloc) => snapshot.hasData
            ? Text(
                snapshot.data.toString(),
                key: const Key(countKey),
              )
            : Container(
                key: const Key(noCountKey),
              ),
      );
}
