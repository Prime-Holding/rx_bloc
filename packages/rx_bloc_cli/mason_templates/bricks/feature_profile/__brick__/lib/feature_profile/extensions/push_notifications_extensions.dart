{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../app_extensions.dart';

extension NotificationsAsyncSnapshotResultValue on AsyncSnapshot<Result<bool>> {
  bool get isLoading => hasData && this is ResultLoading<bool>;

  bool get isError => hasData && data is ResultError<bool>;

  bool get value =>
      hasData &&
      data is ResultSuccess<bool> &&
      (data as ResultSuccess<bool>).data;
}

extension NotificationMessageExtension on bool {
  String translate(BuildContext context) => this
      ? context.l10n.featureProfile.notificationsTurnedOn
      : context.l10n.featureProfile.notificationsTurnedOff;
}
