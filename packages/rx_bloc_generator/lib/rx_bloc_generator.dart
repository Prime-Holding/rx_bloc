library rx_bloc_generator;

import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:build/build.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart' show IterableExtension;
// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen/source_gen.dart';

part 'src/build_controller.dart';
part 'src/builders/bloc_class.dart';
part 'src/builders/bloc_type_class.dart';
part 'src/builders/builder_contract.dart';
part 'src/builders/composition_field.dart';
part 'src/builders/dispose_method.dart';
part 'src/builders/event_arguments_class.dart';
part 'src/builders/event_field.dart';
part 'src/builders/event_method.dart';
part 'src/builders/state_field.dart';
part 'src/builders/state_getter_method.dart';
part 'src/builders/state_method.dart';
part 'src/builders/static_getter_method.dart';
part 'src/rx_bloc_generator_for_annotation.dart';
part 'src/utilities/extensions.dart';
part 'src/utilities/rx_bloc_generator_exception.dart';
part 'src/utilities/utilities.dart';
