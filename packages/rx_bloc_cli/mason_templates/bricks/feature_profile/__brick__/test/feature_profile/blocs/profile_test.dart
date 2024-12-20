{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_services/push_notifications_service.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart'; 
import 'package:{{project_name}}/feature_profile/blocs/profile_bloc.dart'; {{#enable_pin_code}}
import 'package:testapp/feature_profile/services/biometrics_auth_service.dart'; {{/enable_pin_code}}

import 'profile_test.mocks.dart';

@GenerateMocks([
  PushNotificationsService, {{#enable_pin_code}}
  BiometricsAuthService, {{/enable_pin_code}}
])
void main() {
  late PushNotificationsService _notificationService; {{#enable_pin_code}}
  late BiometricsAuthService biometricsService; {{/enable_pin_code}}

  void defineWhen({
    bool? areNotificationsEnabled,
    Future<void> Function(Invocation)? syncNotificationSettings,
  }) {
    when(_notificationService.areNotificationsEnabled())
        .thenAnswer((_) => Future.value(areNotificationsEnabled));
    when(_notificationService.syncNotificationSettings())
        .thenAnswer(syncNotificationSettings ?? (_) => Future.value()); {{#enable_pin_code}}
    when(biometricsService.canCheckBiometrics())
        .thenAnswer((_) => Future.value(true)); {{/enable_pin_code}}
  }

  ProfileBloc profileBloc() => ProfileBloc(
        _notificationService, {{#enable_pin_code}}
        biometricsService,  {{/enable_pin_code}}
      );
  setUp(() {
    _notificationService = MockPushNotificationsService(); {{#enable_pin_code}}
    biometricsService = MockBiometricsAuthService(); {{/enable_pin_code}}
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
        act: (bloc) async {
          bloc.events.loadNotificationsSettings();
        },
        state: (bloc) => bloc.states.areNotificationsEnabled,
        expect: [
          Result.loading(),
          Result.success(true),
        ]);
  });

  group('test profile_bloc_dart state syncNotificationsStatus', () {
    rxBlocTest<ProfileBlocType, Result<bool>>(
        'test profile_bloc_dart state syncNotificationsStatus',
        build: () async {
          defineWhen();
          return profileBloc();
        },
        act: (bloc) async {
          bloc.events.setNotifications(true);
        },
        state: (bloc) => bloc.states.syncNotificationsStatus,
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
          true,
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
        act: (bloc) async {
          bloc.events.loadNotificationsSettings();
        },
        state: (bloc) => bloc.states.errors,
        expect: [
          isA<UnknownErrorModel>(),
        ]);
  }); {{#enable_pin_code}}

   group(
    'test profile_bloc_dart canCheckBiometricsState',
    () {
      rxBlocTest<ProfileBlocType, bool>(
        'test profile_bloc_dart canCheckBiometricsState',
        build: () async {
          defineWhen();
          return profileBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.canCheckBiometrics,
        expect: [
          true,
        ],
      );
    },
  ); {{/enable_pin_code}}
}
