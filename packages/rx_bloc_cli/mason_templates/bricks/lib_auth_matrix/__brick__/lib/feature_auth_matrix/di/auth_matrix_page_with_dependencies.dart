import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../lib_auth_matrix/bloc/auth_matrix_bloc.dart';
import '../services/auth_matrix_text_field_service.dart';
import '../views/auth_matrix_page.dart';

class AuthMatrixPageWithDependencies extends StatelessWidget {
  const AuthMatrixPageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const AuthMatrixPage(),
      );

  List<SingleChildWidget> get _services => [
        Provider<AuthMatrixTextFieldService>(
          create: (context) => AuthMatrixTextFieldService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<AuthMatrixBlocType>(
          create: (context) => AuthMatrixBloc(
            context.read(),
          ),
        )
      ];
}
