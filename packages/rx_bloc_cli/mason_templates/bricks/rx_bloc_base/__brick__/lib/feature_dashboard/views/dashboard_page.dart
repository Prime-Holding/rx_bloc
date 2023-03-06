import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../../app_extensions.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(context.designSystem.icons.reload),
              onPressed: context.read<DashboardBlocType>().events.fetchData,
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RxBlocListener<DashboardBlocType, ErrorModel>(
              state: (bloc) => bloc.states.errors.translate(context),
              listener: (context, error) => _onError,
            ),
            Center(
                child: RxResultBuilder<DashboardBlocType, String>(
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
