{{> licence.dart }}

import 'package:widget_toolkit_qr/widget_toolkit_qr.dart';

class QrService extends QrValidationService<String> {
  @override
  Future<String> validateQrCode(String qrCode) async {
    await Future.delayed(const Duration(seconds: 3));
    return qrCode;
  }
}
