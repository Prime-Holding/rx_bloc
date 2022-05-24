import 'package:flutter/material.dart';

extension RxBlocAsyncSnapshot<T> on AsyncSnapshot<T> {
  Widget build(Widget Function(T) builder, {Widget? fallback}) =>
      hasData ? builder(data as T) : fallback ?? Container();
}
