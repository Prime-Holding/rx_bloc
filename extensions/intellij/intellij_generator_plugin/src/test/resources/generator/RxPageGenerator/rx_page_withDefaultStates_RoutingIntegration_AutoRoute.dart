import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/extensions/error_model_field_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/profile_bloc.dart';
import '../di/profile_dependencies.dart';

class ProfilePage extends StatelessWidget implements AutoRouteWrapper {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: ProfileDependencies.from(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: context.read<ProfileBlocType>().events.fetchData,
              ),
            ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             RxBlocListener<ProfileBlocType, ErrorModel>(
              state: (bloc) => bloc.states.errors.translate(context),
              listener: (context, error) => _onError,
            ),
            Center(
                child: RxResultBuilder<ProfileBlocType, String>(
              state: (bloc) => bloc.states.data,
              buildLoading: (context, bloc) => const CircularProgressIndicator(),
              buildError: (context, error, bloc) => Text(error.toString()),
              buildSuccess: (context, state, bloc) => Text(state),
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