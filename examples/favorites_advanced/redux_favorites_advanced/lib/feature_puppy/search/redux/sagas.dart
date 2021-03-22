import 'package:image_picker/image_picker.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'actions.dart';

final repository = PuppiesRepository(ImagePicker());

fetchPuppies({dynamic action}) sync* {
  yield Try(() sync* {
    //final puppies = PuppiesRepository(ImagePicker()).getPuppies();
    final puppies = Result();
    yield Call(repository.getPuppies, result: puppies);
    yield Put(PuppiesFetchSucceededAction(puppies: puppies.value));
    //print(puppies.value);
  }, Catch: (e, s) sync* {
    print(e.message);
    yield Put(PuppiesFetchFailedAction(message: e.message));
  });
}

puppiesSaga() sync* {
  yield TakeLatest(fetchPuppies, pattern: PuppiesFetchRequestedAction);
}

fetchExtraDetails({dynamic action}) sync* {
  yield Try(() sync* {
    final puppy = Result();
    yield Call(() => repository.fetchFullEntities([action.puppy.id]),
        result: puppy);
    print(puppy);
    yield Put(ExtraDetailsFetchSucceededAction(puppy: puppy.value));
  }, Catch: (e, s) sync* {
    // print(e.message);
    // yield Put(ExtraDetailsFetchFailedAction(message: e.message));
  });
}

extraDetailsSaga() sync* {
  yield TakeEvery(fetchExtraDetails, pattern: ExtraDetailsFetchRequestedAction);
}
