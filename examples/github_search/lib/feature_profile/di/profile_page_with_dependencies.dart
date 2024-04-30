// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/profile_bloc.dart';
import '../views/profile_page.dart';

class ProfilePageWithDependencies extends StatelessWidget {
  const ProfilePageWithDependencies({super.key});

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
