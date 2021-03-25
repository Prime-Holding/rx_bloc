import 'dart:async';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:image_picker/image_picker.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import '../../../base/models/app_state.dart';
import 'actions.dart';

final repository = PuppiesRepository(ImagePicker(), ConnectivityRepository());

Stream<dynamic> fetchPuppiesEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.where((action) => action is PuppiesFetchRequestedAction).asyncMap(
        (action) => repository
            .getPuppies()
            .then<dynamic>(
                (results) => PuppiesFetchSucceededAction(puppies: results))
            .catchError((error) => PuppiesFetchFailedAction(message: error)));

Stream<dynamic> fetchExtraDetailsEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<ExtraDetailsFetchRequestedAction>()
        .map((action) => action.puppy)
        .bufferTime(const Duration(milliseconds: 100))
        .map((puppies) => puppies.whereNoExtraDetails())
        .where((puppies) => puppies.isNotEmpty)
        .asyncMap((puppies) => repository.fetchFullEntities(puppies.ids).then(
            (puppies) => ExtraDetailsFetchSucceededAction(puppies: puppies)));
