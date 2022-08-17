import 'package:flutter/material.dart';
import 'package:rx_bloc/rx_bloc.dart';

/// AsyncSnapshot extensions used by the RxBloc widgets
extension AsyncSnapshotToException<T> on AsyncSnapshot<Result<T>> {
  /// Converts an AsyncSnapshot with an error to an exception. If snapshot has
  /// no errors, it will return null.
  Exception? asException() {
    if (!hasError) return null;

    if (error is Exception) {
      return error as Exception?;
    }

    return Exception(error.toString());
  }
}
