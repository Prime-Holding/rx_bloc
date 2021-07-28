import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import 'package:favorites_advanced_base/repositories.dart';

import '../../base/models/app_state.dart';
import '../../base/redux/actions.dart';
import '../details/redux/actions.dart';
import '../favorites/redux/actions.dart';
import '../search/redux/actions.dart';

Epic<AppState> puppyFavoriteEpic(PuppiesRepository repository) => (actions,
        store) =>
    actions.whereType<PuppyToggleFavoriteAction>().switchMap((action) async* {
      try {
        yield PuppyFavoriteSucceededAction(
          puppy: action.puppy.copyWith(isFavorite: action.isFavorite),
        );
        yield ModifyDetailsPuppy(
            puppy: action.puppy.copyWith(isFavorite: action.isFavorite));
        yield PuppyToFavoritesListAction(
          puppy: action.puppy.copyWith(isFavorite: false),
        );
        yield action.isFavorite
            ? FavoriteCountIncrementAction()
            : FavoriteCountDecrementAction();
        final puppy = await repository.favoritePuppy(action.puppy,
            isFavorite: action.isFavorite);
        final detailsPuppy = puppy.copyWith(
          breedCharacteristics: action.puppy.breedCharacteristics,
          displayCharacteristics: action.puppy.displayCharacteristics,
          displayName: action.puppy.displayName,
        );
        yield PuppyFavoriteSucceededAction(puppy: detailsPuppy);
        yield PuppyToFavoritesListAction(puppy: detailsPuppy);
      } catch (error) {
        yield PuppyFavoriteSucceededAction(puppy: action.puppy);
        yield ModifyDetailsPuppy(puppy: action.puppy);
        yield PuppyToFavoritesListAction(puppy: action.puppy);
        yield action.isFavorite
            ? FavoriteCountDecrementAction()
            : FavoriteCountIncrementAction();
        yield ErrorAction(error: error.toString());
      }
    });
