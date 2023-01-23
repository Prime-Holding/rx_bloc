{{> licence.dart }}

part of 'user_account_bloc.dart';

extension _LogingOutExtensions on Stream<void> {
  Stream<Result<bool>> logoutUser(UserAccountService service) =>
      throttleTime(const Duration(seconds: 1))
          .switchMap((value) => service.logout().asResultStream());
}
