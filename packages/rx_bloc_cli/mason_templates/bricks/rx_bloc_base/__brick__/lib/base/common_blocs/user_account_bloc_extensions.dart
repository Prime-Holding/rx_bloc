{{> licence.dart }}

part of 'user_account_bloc.dart';

extension _LogingOutExtensions on Stream<void> {
  Stream<Result<bool>> logoutUser(LogoutUseCase useCase) =>
      throttleTime(const Duration(seconds: 1))
          .switchMap((value) => useCase.execute().asResultStream());
}
