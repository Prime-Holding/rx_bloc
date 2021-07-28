import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import '../../../base/models/app_state.dart';
import 'actions.dart';

Epic<AppState> fetchPuppiesEpic(PuppiesRepository repository) => (actions,
        store) =>
    actions.whereType<PuppiesFetchRequestedAction>().switchMap((action) async* {
      try {
        final puppies = await repository.getPuppies(query: action.query ?? '');
        yield PuppiesFetchSucceededAction(puppies: puppies);
      } catch (_) {
        yield PuppiesFetchFailedAction();
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

Epic<AppState> searchQueryEpic(PuppiesRepository repository) =>
    (actions, store) => actions
            .whereType<SearchAction>()
            .debounceTime(const Duration(milliseconds: 500))
            .switchMap((action) async* {
          yield PuppiesFetchLoadingAction();
          yield SaveSearchQueryAction(query: action.query);
          yield PuppiesFetchRequestedAction(query: action.query);
        });
