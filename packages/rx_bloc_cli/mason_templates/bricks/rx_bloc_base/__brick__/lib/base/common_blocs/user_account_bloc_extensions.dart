{{> licence.dart }}

part of 'user_account_bloc.dart';

extension _LogingOutExtensions on Stream<void> {
  Stream<Result<bool>> logoutUser(
      UserAccountService service,
      PermissionsService permissionsService,
      ) =>
      throttleTime(const Duration(seconds: 1)).exhaustMap((value) =>
          _logoutUserAndRefreshPermissions(service, permissionsService)
              .asResultStream());

  Future<bool> _logoutUserAndRefreshPermissions(
      UserAccountService service,
      PermissionsService permissionsService,
      ) async {
    final result = await service.logout();

    await permissionsService.load();

    return result;
  }
}
