{{> licence.dart }}


import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/update_pin_model.dart';
import '../services/update_pin_code_service.dart';
import '../views/update_pin_page.dart';

class UpdatePinPageWithDependencies extends StatelessWidget {
  const UpdatePinPageWithDependencies({
    required this.updatePinModel,
    super.key,
  });

  final UpdatePinModel updatePinModel;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<UpdatePinCodeService>(
            create: (_) => UpdatePinCodeService(
              context.read(),
              updatePinModel,
            ),
          )
        ],
        child: UpdatePinPage(pinModel: updatePinModel),
      );
}
