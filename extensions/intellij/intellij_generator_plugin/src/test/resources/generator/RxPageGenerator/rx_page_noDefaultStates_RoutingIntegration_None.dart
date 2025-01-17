import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/profile_bloc.dart';
import '../di/profile_page_with_dependencies.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: Center(child: _buildDataContainer()),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: context.read<ProfileBlocType>().events.fetchData,
          ),
        ],
      );

  Widget _buildDataContainer() => RxResultBuilder<ProfileBlocType, String>(
        state: (bloc) => bloc.states.data,
        buildLoading: (context, bloc) => const CircularProgressIndicator(),
        buildError: (context, error, bloc) => Text(error.toString()),
        buildSuccess: (context, state, bloc) => Text(state),
      );
}