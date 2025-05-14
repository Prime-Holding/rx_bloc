{{> licence.dart }}


import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../base/models/pin_code/create_pin_model.dart';
import '../services/create_pin_code_service.dart';
import '../views/set_pin_page.dart';

class ConfirmPinPageWithDependencies extends StatelessWidget {
  const ConfirmPinPageWithDependencies({
    required this.createPinModel,
    super.key,
  });

  final CreatePinModel createPinModel;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [..._services],
        child: SetPinPage(pinModel: createPinModel),
      );

  List<SingleChildStatelessWidget> get _services => [
        Provider<CreatePinCodeService>(
          create: (context) => CreatePinCodeService(
            context.read(),
            createPinModel,
          ),
        ),
      ];
}
