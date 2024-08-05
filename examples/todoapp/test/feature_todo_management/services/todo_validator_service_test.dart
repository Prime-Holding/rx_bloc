import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/feature_todo_management/services/todo_validator_service.dart';

import '../../stubs.dart';

void main() {
  TodoValidatorService todoValidatorService() => TodoValidatorService();

  group('test todo_management_bloc_dart validateTitle', () {
    test('test todo_validator_service_dart validateTitle short title error',
        () async {
      final service = todoValidatorService();

      expect(() => service.validateTitle(Stubs.shortTitle),
          throwsA(isA<FieldErrorModel>()));
    });

    test('test todo_validator_service_dart validateTitle long title error',
        () async {
      final service = todoValidatorService();

      expect(() => service.validateTitle(Stubs.longTitle),
          throwsA(isA<FieldErrorModel>()));
    });

    test('test todo_validator_service_dart validateTitle empty title error',
        () async {
      final service = todoValidatorService();

      expect(() => service.validateTitle('  '),
          throwsA(isA<FieldRequiredErrorModel>()));
    });

    test('test todo_validator_service_dart validateTitle valid title',
        () async {
      final service = todoValidatorService();

      expect(service.validateTitle(Stubs.validTitle), Stubs.validTitle);
    });
  });
}
