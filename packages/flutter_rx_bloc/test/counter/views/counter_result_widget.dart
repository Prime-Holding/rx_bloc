import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../blocs/counter_bloc.dart';

class CounterResultWidget extends StatelessWidget {
  const CounterResultWidget({
    Key? key,
    this.bloc,
  }) : super(key: key);

  final CounterBlocType? bloc;

  static const countKey = 'count_result_key';
  static const errorKey = 'error_result_count_key';
  static const loadingKey = 'loading_result_count_key';

  @override
  Widget build(BuildContext context) => RxResultBuilder<CounterBlocType, int>(
        state: (bloc) => bloc.states.count,
        bloc: bloc,
        buildSuccess: (ctx, count, bloc) => Text(
          count.toString(),
          key: const Key(countKey),
        ),
        buildError: (ctx, error, bloc) => Text(
          error.toString(),
          key: const Key(errorKey),
        ),
        buildLoading: (ctx, bloc) => Container(
          key: const Key(loadingKey),
        ),
      );
}
