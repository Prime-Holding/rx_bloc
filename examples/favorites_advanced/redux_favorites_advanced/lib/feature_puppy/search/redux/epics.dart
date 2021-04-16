import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import '../../../base/models/app_state.dart';
import '../../../base/redux/actions.dart';
import '../../favorites/redux/actions.dart';
import 'actions.dart';

Epic<AppState> fetchPuppiesEpic(PuppiesRepository repository) =>
    (actions, store) => actions
            //.where((action) => action is PuppiesFetchRequestedAction)
            .whereType<PuppiesFetchRequestedAction>()
            .switchMap((action) async* {
          try {
            final puppies = await repository.getPuppies();
            yield PuppiesFetchSucceededAction(puppies: puppies);
          } catch (_) {
            yield PuppiesFetchFailedAction();
            //yield ErrorAction(error: error.toString());
          }
        });

Epic<AppState> fetchExtraDetailsEpic(PuppiesRepository repository) =>
    (actions, store) => actions
        .whereType<ExtraDetailsFetchRequestedAction>()
        .map((action) => action.puppy)
        .bufferTime(const Duration(milliseconds: 100))
        .map((puppies) => puppies.whereNoExtraDetails())
        .where((puppies) => puppies.isNotEmpty)
        .switchMap(
            (puppies) => repository.fetchFullEntities(puppies.ids).asStream())
        .map((puppies) => ExtraDetailsFetchSucceededAction(puppies: puppies));

Epic<AppState> puppyFavoriteEpic(PuppiesRepository repository) => (actions,
        store) =>
    actions.whereType<PuppyToggleFavoriteAction>().switchMap((action) async* {
      try {
        yield PuppyFavoriteSucceededAction(
          puppy: action.puppy.copyWith(isFavorite: action.isFavorite),
        );
        final puppy = await repository.favoritePuppy(action.puppy,
            isFavorite: action.isFavorite);
        final detailsPuppy = puppy.copyWith(
          breedCharacteristics: action.puppy.breedCharacteristics,
          displayCharacteristics: action.puppy.displayCharacteristics,
          displayName: action.puppy.displayName,
        );
        yield PuppyFavoriteSucceededAction(
          puppy: detailsPuppy,
        );
        yield action.isFavorite
            ? FavoriteCountIncrementAction()
            : FavoriteCountDecrementAction();
        yield AddPuppyToFavoritesListAction(puppy: detailsPuppy);
      } catch (error) {
        yield PuppyFavoriteSucceededAction(puppy: action.puppy);
        yield ErrorAction(error: error.toString());
      }
    });
