{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/profile_bloc.dart';
import '../views/profile_page.dart';

class ProfilePageWithDependencies extends StatelessWidget {
  const ProfilePageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: const ProfilePage(),
      );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<ProfileBlocType>(
          create: (context) => ProfileBloc(
            context.read(),
          ),
        ),
      ];
}
