
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';{{#enable_feature_onboarding}}
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';{{/enable_feature_onboarding}}
import 'package:{{project_name}}/base/common_services/push_notifications_service.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_profile/blocs/profile_bloc.dart';

{{#enable_feature_onboarding}}
import '../../base/common_blocs/coordinator_bloc_mock.dart';{{/enable_feature_onboarding}}
import 'profile_test.mocks.dart';

@GenerateMocks([
  {{#enable_feature_onboarding}}CoordinatorBlocType,{{/enable_feature_onboarding}}
  PushNotificationsService,
])
void main() {
  {{#enable_feature_onboarding}}
  late CoordinatorBlocType coordinatorBloc;{{/enable_feature_onboarding}}
  late PushNotificationsService notificationService;

  void defineWhen({
    bool? areNotificationsEnabled,
    Future<bool> Function(Invocation)? areNotificationsEnabledError,
  }) {
    when(notificationService.areNotificationsEnabled()).thenAnswer(
      areNotificationsEnabledError ??
          (_) => Future.value(areNotificationsEnabled),
    );
  }

  ProfileBloc profileBloc() => ProfileBloc(
        notificationService,{{#enable_feature_onboarding}}
        coordinatorBloc,{{/enable_feature_onboarding}}
      );
  setUp(() { {{#enable_feature_onboarding}}
    coordinatorBloc = coordinatorBlocMockFactory();{{/enable_feature_onboarding}}
    notificationService = MockPushNotificationsService();
  });

  group('test profile_bloc_dart state areNotificationsEnabled', () {
    rxBlocTest<ProfileBlocType, Result<bool>>(
        'test profile_bloc_dart state areNotificationsEnabled',
        build: () async {
          defineWhen(
            areNotificationsEnabled: true,
          );
          return profileBloc();
        },
        state: (bloc) => bloc.states.areNotificationsEnabled,
        expect: [
          Result.loading(),
          Result.success(true),
        ]);
  });

  group('test profile_bloc_dart state isLoading', () {
    rxBlocTest<ProfileBlocType, bool>('test profile_bloc_dart state isLoading',
        build: () async {
          defineWhen(
            areNotificationsEnabled: false,
          );
          return profileBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.isLoading,
        expect: [
          false,
        ]);
  });

  group('test profile_bloc_dart state errors', () {
    rxBlocTest<ProfileBlocType, ErrorModel>(
        'test profile_bloc_dart state errors',
        build: () async {
          defineWhen(
            areNotificationsEnabledError: (_) =>
                  Future.error(UnknownErrorModel()),
          );

          return profileBloc();
        },
        state: (bloc) => bloc.states.errors,
        expect: [
          isA<UnknownErrorModel>(),
        ]);
  });
}
