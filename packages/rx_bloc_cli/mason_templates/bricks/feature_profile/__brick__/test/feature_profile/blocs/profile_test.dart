{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_services/push_notifications_service.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_profile/blocs/profile_bloc.dart';

import 'profile_test.mocks.dart';

@GenerateMocks([
  PushNotificationsService,
])
void main() {
  late PushNotificationsService notificationService;

  void defineWhen({
    bool? areNotificationsEnabled,
    Future<void> Function(Invocation)? syncNotificationSettings,
  }) {
    when(notificationService.areNotificationsEnabled())
        .thenAnswer((_) => Future.value(areNotificationsEnabled));
    when(notificationService.syncNotificationSettings())
        .thenAnswer(syncNotificationSettings ?? (_) => Future.value());
  }

  ProfileBloc profileBloc() => ProfileBloc(
        notificationService,
      );
  setUp(() {
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
          defineWhen();
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
              syncNotificationSettings: (_) =>
                  Future.error(UnknownErrorModel()));

          return profileBloc();
        },
        state: (bloc) => bloc.states.errors,
        expect: [
          isA<UnknownErrorModel>(),
        ]);
  });
}
