{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/tfa_edit_address_bloc.dart';
import '../services/tfa_edit_address_service.dart';

import '../views/tfa_page.dart';

class TFAPageWithDependencies extends StatelessWidget {
  const TFAPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const TFAPage(),
      );

  List<SingleChildWidget> get _services => [
        Provider<TFAEditAddressService>(
          create: (context) => TFAEditAddressService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<TFAEditAddressBlocType>(
          create: (context) => TFAEditAddressBloc(
            context.read(),
          ),
        )
      ];
}
