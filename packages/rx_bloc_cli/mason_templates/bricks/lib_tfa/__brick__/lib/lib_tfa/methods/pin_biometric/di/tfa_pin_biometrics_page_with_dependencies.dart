{{> licence.dart }}

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../models/tfa_response.dart';
import '../services/tfa_pincode_service.dart';
import '../views/tfa_pin_biometrics_page.dart';

class TFAPinBiometricsPageWithDependencies extends StatelessWidget {
  const TFAPinBiometricsPageWithDependencies({
    required this.transactionId,
    required this.tfaResponse,
    super.key,
  });

  final TFAResponse tfaResponse;
  final String transactionId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: TFAPinBiometricsPage(
          transactionId: transactionId,
        ),
      );

  List<SingleChildStatelessWidget> get _services => [
        Provider<TFAPinCodeService>(
          create: (context) => TFAPinCodeService(
            tfaResponse: tfaResponse,
            tfaRepository: context.read(),
          ),
        ),
      ];
}
