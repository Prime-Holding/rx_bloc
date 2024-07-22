{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/auth_matrix_edit_address_bloc.dart';
import '../services/auth_matrix_edit_address_service.dart';

import '../views/auth_matrix_page.dart';

class AuthMatrixPageWithDependencies extends StatelessWidget {
  const AuthMatrixPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const AuthMatrixPage(),
      );

  List<SingleChildWidget> get _services => [
        Provider<AuthMatrixEditAddressService>(
          create: (context) => AuthMatrixEditAddressService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<AuthMatrixEditAddressBlocType>(
          create: (context) => AuthMatrixEditAddressBloc(
            context.read(),
          ),
        )
      ];
}
