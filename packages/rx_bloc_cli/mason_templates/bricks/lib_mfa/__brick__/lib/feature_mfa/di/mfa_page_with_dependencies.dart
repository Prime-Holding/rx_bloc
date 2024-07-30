{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/mfa_edit_address_bloc.dart';
import '../services/mfa_edit_address_service.dart';

import '../views/mfa_page.dart';

class MFAPageWithDependencies extends StatelessWidget {
  const MFAPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const MFAPage(),
      );

  List<SingleChildWidget> get _services => [
        Provider<MFAEditAddressService>(
          create: (context) => MFAEditAddressService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<MFAEditAddressBlocType>(
          create: (context) => MFAEditAddressBloc(
            context.read(),
          ),
        )
      ];
}
