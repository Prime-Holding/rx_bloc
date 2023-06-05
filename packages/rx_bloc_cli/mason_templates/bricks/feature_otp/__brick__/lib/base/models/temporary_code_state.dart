import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';

enum TemporaryCodeState {
  inactive,
  populated,
  correct,
  wrong,
  wrongTooManyRetries,
  loading,
  reset,
  disabled
}

extension TemporaryCodeTranslate on TemporaryCodeState {
  String translateToMessage(BuildContext context) {
    switch (this) {
      case TemporaryCodeState.correct:
        return context.l10n.featureOtp.codeStateCorrect;
      case TemporaryCodeState.wrong:
        return context.l10n.featureOtp.codeStateWrong;
      case TemporaryCodeState.disabled:
        return context.l10n.featureOtp.codeStateDisabled;
      default:
        return context.l10n.featureOtp.codeStateDefault;
    }
  }
}
