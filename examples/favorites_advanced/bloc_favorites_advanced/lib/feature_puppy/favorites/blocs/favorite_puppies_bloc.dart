import 'dart:async';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'favorite_puppies_event.dart';

part 'favorite_puppies_state.dart';

class FavoritePuppiesBloc
    extends Bloc<FavoritePuppiesEvent, FavoritePuppiesState> {
  FavoritePuppiesBloc(this.puppiesRepository)
      : super(const FavoritePuppiesState(favoritePuppies: []));

  PuppiesRepository puppiesRepository;
  List<Puppy> favoritePuppies = <Puppy>[];
  @override
  Stream<FavoritePuppiesState> mapEventToState(
      FavoritePuppiesEvent event,) async* {
    if (event is MarkAsFavoriteEvent) {
      var puppy = event.puppy;
      final isFavoriteNew = event.isFavorite;

      puppy = puppy.copyWith(isFavorite: isFavoriteNew);
      final updatedPuppy = await puppiesRepository
      .favoritePuppy(puppy, isFavorite: isFavoriteNew);
      if(isFavoriteNew) {
        favoritePuppies.add(updatedPuppy);
      }else{
        favoritePuppies.remove(updatedPuppy);
      }
      yield FavoritePuppiesState(favoritePuppies: favoritePuppies);
    }
  }
}















