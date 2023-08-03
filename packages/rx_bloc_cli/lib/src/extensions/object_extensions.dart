part of '../commands/create_command.dart';

extension _CastObject on Object {
  T cast<T extends Object>() => this as T;
}
