import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/rose_bloc.dart';

class RosePage extends StatelessWidget {
  const RosePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: context.read<RoseBlocType>().events.fetchData,
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RxBlocListener<RoseBlocType, String>(
              state: (bloc) => bloc.states.errors,
              listener: (context, error) => _onError,
            ),
            Center(
                child: RxResultBuilder<RoseBlocType, String>(
              state: (bloc) => bloc.states.data,
              buildLoading: (ctx, bloc) => const CircularProgressIndicator(),
              buildError: (ctx, error, bloc) => Text(error.toString()),
              buildSuccess: (ctx, state, bloc) => Text(state),
            )),
          ],
        ),
      );

  void _onError(BuildContext context, String errorMessage) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
