{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../services/qr_service.dart';
import '../views/qr_scanner_page.dart';

class QrScannerPageWithDependencies extends StatelessWidget {
  const QrScannerPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: const QrScannerPage(),
      );

  List<Provider> get _services => [
        Provider<QrService>(
          create: (context) => QrService(),
        ),
      ];
}
