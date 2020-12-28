part of 'puppy_edit_bloc.dart';

extension _UpdatePuppyExtension on PuppyEditBloc {
  Stream<Puppy> editPuppy() => _$updatePuppyEvent
      .switchMap((args) => _puppiesRepository
          .updatePuppy(args.oldPuppy.id, args.newPuppy)
          .asResultStream())
      .setResultStateHandler(this)
      .whereSuccess();
}

extension _ExceptionExtensions on Stream<Exception> {
  Stream<String> mapToString() =>
      map((e) => e.toString().replaceAll('Exception:', ''));
}
