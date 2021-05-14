part of 'puppy_mark_as_favorite_bloc_.dart';

@immutable
class PuppyManageState extends Equatable {
  const PuppyManageState({
    this.imagePath,
    this.name,
    this.breed,
    this.gender,
    this.characteristics,
    this.showErrors,
    this.isSaveEnabled,
    this.puppy,
    this.error,
    this.updateComplete,
  });

  final String? imagePath;
  final String? name;
  final String? breed;
  final Gender? gender;
  final String? characteristics;
  final bool? showErrors;
  final bool? isSaveEnabled;
  final Puppy? puppy;
  final String? error;
  final bool? updateComplete;

  PuppyManageState copyWith({
    Puppy? puppy,
    String? error,
  }) =>
      PuppyManageState(
        puppy: puppy,
        error: error,
      );

  @override
  List<Object?> get props => [puppy, error];
}
