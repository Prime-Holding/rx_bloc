import 'package:flutter/material.dart';
import 'package:rx_bloc/rx_bloc.dart';

/// AsyncSnapshot extensions
extension AsyncSnapshotToException<T> on AsyncSnapshot<Result<T>> {
  /// Converts an AsyncSnapshot to an exception
  Exception? asException() {
    if (!hasError) return null;

    if (error is Exception) {
      return error as Exception?;
    }

    return Exception(error.toString());
  }
}
