import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/rose_bloc.dart';
import '../services/rose_service.dart';
import '../views/rose_page.dart';

class RosePageWithDependencies extends StatelessWidget {
  const RosePageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const RosePage(),
      );

  List<Provider> get _services => [
        Provider<RoseService>(
          create: (context) => RoseService(
              //context.read(),
              ),
        ),
      ];
  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<RoseBlocType>(
          create: (context) => RoseBloc(context.read()),
        ),
      ];
}
