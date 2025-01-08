import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../../app_extensions.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
        body: Column(
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
                buildSuccess: (ctx, state, bloc) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ctx.designSystem.spacing.m,
                    horizontal: ctx.designSystem.spacing.l,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard_outlined,
                        size: context.designSystem.spacing.xxxxl3,
                      ),
                      SizedBox(height: context.designSystem.spacing.s),
                      Text(
                        context.l10n.dashboard,
                        style: context.designSystem.typography.h1Med32,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.designSystem.spacing.xs),
                      Text(
                        state,
                        textAlign: TextAlign.center,
                        style: context.designSystem.typography.h2Reg16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
