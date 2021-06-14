import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import 'package:favorites_advanced_base/repositories.dart';

import '../../../base/models/app_state.dart';
import '../../details/redux/actions.dart';
import '../../favorites/redux/actions.dart';
import '../../search/redux/actions.dart';
import 'actions.dart';

Epic<AppState> pickImageEpic(PuppiesRepository repository) =>
    (actions, store) =>
        actions.whereType<ImagePickAction>().switchMap((action) async* {
          try {
            final pickedImage = await repository.pickPuppyImage(action.source);
            if (pickedImage?.path != null) {
              yield ImagePathAction(imagePath: pickedImage!.path);
            }
          } catch (_) {
            yield UpdateErrorAction(
              error: 'Error: Please grant camera permissions.',
            );
          }
        });

Epic<AppState> updatePuppyEpic(PuppiesRepository repository) =>
    (actions, store) =>
        actions.whereType<UpdatePuppyAction>().switchMap((action) async* {
          try {
            yield ValidateNameAction(name: action.puppy.name);
            yield ValidateCharacteristicsAction(
                characteristics: action.puppy.breedCharacteristics);
            if (store.state.editState.nameError == '' &&
                store.state.editState.characteristicsError == '') {
              yield EditLoadingAction();
              final updatedPuppy =
                  await repository.updatePuppy(action.puppy.id, action.puppy);
              yield UpdateSucceededAction();
              yield ModifyDetailsPuppy(puppy: updatedPuppy);
              yield UpdateSearchStatePuppyAction(puppy: updatedPuppy);
              yield UpdateFavoritesStatePuppyAction(puppy: updatedPuppy);
            }
          } catch (error) {
            yield UpdateErrorAction(error: error.toString());
          }
        });
