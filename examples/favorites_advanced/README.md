Building complex apps in Flutter through the power of reactive programming
Developing complex apps that meet user expectations while consuming a fragmented API can be a challenge these days.

Let's look at the following challenges we might face while working on real-world applications.
- Inter-feature communication
- API requests optimisation without compromising the best UX
- Building a super responsive app
- Implementing functionality that can work in various scenarios
- Building an app that can handle millions of mutable records


# Inter-feature communication
You may work on an app that has various features that need to communicate with each other. Imagine that your app needs to show a list of entities that the user can mark as favorites or mutate in any other way.

Let's see what this would look like, assuming we need to show some cute puppies…. Well because why not, right?

Users only see two lists of puppies, but we as software engineers see much more.
Let's assume the state management of our choice for this particular project is BloC (Business Logic Component).

So we need to implement BloCs such as FavoritesBloc, SearchBloc, ExtraDetailsBloc, PuppyManageBloc etc. When a puppy gets updated, both lists (search and favourites) need to be updated accordingly.

We could approach the inter-feature communication challenge by setting up dependencies between the BloCs. BloC A could have dependency to BloC B, Bloc C to BloC B etc,but we might end up with circular dependencies that are difficult to manage.

Coordinator pattern to the rescue!

We now have a central place for inter-bloc communication, so there is no need to deal with a complex dependency graph. Each BloC emits events to the CoordinatorBloc and each BloC can listen and react accordingly.


# API requests optimisation without compromising the best UX
Having an API built with microservice architecture is scalable by its nature but sometimes the endpoints become very fragmented and in the mobile app we need to handle this somehow.
Imagine that with the first API call, the app can fetch a list of puppies, but then users need to be provided with some additional details that need to be loaded later, as shown below.

- The app needs to fetch the additional details one by one when the users scroll slowly
- The app needs to collect all visible entities and get these additional details with just one API call when the user scrolls fast and then suddenly stops

Now seems like the right time to see some code, right?

puppies_extra_details.dart
```
@RxBloc()
class PuppiesExtraDetailsBloc extends $PuppiesExtraDetailsBloc {
PuppiesExtraDetailsBloc(...) {
    // This event emits when a puppy entity becomes visible on the screen.
    _$fetchExtraDetailsEvent
        // Fetch extra details collected in 100 millisecond buckets.
        .fetchExtraDetails(repository, coordinatorBloc)
        // Bind the result (List<Puppies>) to the local state
        .bind(_lastFetchedPuppies)
        // Always make sure your subscriptions are disposed of!
        .disposedBy(_compositeSubscription);
  }
....
}
```
puppies_extra_details_bloc_extensions.dart
```
extension _StreamFetchExtraDetails on Stream<Puppy> {
/// Fetch extra details collected in 100 millisecond buckets.
  Stream<List<Puppy>> fetchExtraDetails(...) =>
      // Collect puppies in 100 milliseconds buckets
      bufferTime(const Duration(milliseconds: 100))
          // Get the puppies that still have no extra details.
          .map((puppies) => puppies.whereNoExtraDetails())
          // Only execute API call if needed.
          .where((puppies) => puppies.isNotEmpty)
          // Get all extra details from the API
         .flatMap(
              (value) => repository.fetchFullEntities(value.ids).asStream())
          // Notify the coordination bloc
         .doOnData((puppies) =>
    coordinatorBloc.events.puppiesWithExtraDetailsFetched(puppies));
}
```
The UI layer can tell the business layer which items are currently on the screen using this package. Then the business logic layer collects all entities that the UI layer reports as applying a buffer of 500ms. This means that the business layer will be waiting 500 ms and collecting entities before fetching the actual extra details. With this, we provide the best UX and at the same time the API it's not flooded with too many requests.

# Building a super responsive app
Nowadays users have very high expectations. Usually, the user needs to wait while the API call is being executed (login form, fetching data, etc.) but there are multiple scenarios in which the app needs to present the intended result to the user immediately while the API call is being executed in the background. A perfect example of this is the like functionality in social networks … or marking a puppy as a favorite.
The challenge here is to handle the error case somehow, right?
**puppy_manage_bloc_extensions.dart**
```
...
markPuppyAsFavorite(...) => 
   throttleTime(const Duration(milliseconds: 200))
    .switchMap<Result<Puppy>>((args) async* {
      yield Result.loading();
      // Emit an event with the copied instance of the entity
      // so that the UI can update immediately.
      yield Result.success(
        args.puppy.copyWith(isFavorite: args.isFavorite),
      );

      yield Result.loading();
      try {
        final updatedPuppy = await puppiesRepository
            .favoritePuppy(args.puppy, isFavorite: args.isFavorite);

        yield Result.success(
          updatedPuppy.copyWith(
            displayBreedCharacteristics:
                args.puppy.displayBreedCharacteristics,
            displayName: args.puppy.displayName,
          ),
        );
      } catch (e) {
        // In case of error rollback the puppy to
        // the previous state and notify the UI layer for the error
        bloc._favoritePuppyError.sink.add(e);
        yield Result.success(args.puppy);
      }
    })
...
```
Here we can see that we emit a copied version of the entity to the UI so that users can immediately see the intended result. In case the API request fails though, we rollback the original object and display an error message.

# Implementing functionality that can work in various scenarios
Even the listing looks very simple, let's see what cases we need to cover
Presenting various loading indicators based on user actions
Having basic functionalities, such as pull-to-refresh or a list error widget, working on the regular puppy list and at the search as well
Updating a global counter based on user actions coming from different places

As I mentioned earlier, from the user perspective things are simple and they have to be that way, so we have to make an extra effort to handle all those cases, right?
Let's see how reactive programming can help us achieve our goals.
**puppy_list_bloc_extensions.dart**
```
/// Use [filterPuppies] and [reloadFavoritePuppies] as
/// a reload trigger.
Stream<_ReloadData> _reloadTrigger() => Rx.merge([
      _$filterPuppiesEvent.distinct().map((query) => _ReloadData(
            silently: false,
            query: query,
          )),
      _$reloadFavoritePuppiesEvent.map((silently) => _ReloadData(
            silently: silently,
            query: _$filterPuppiesEvent.value,
          )),
    ]);
```
As you can see, we are utilizing the merge operator so that we can combine various user actions into one trigger, then we fetch the list using the condition, and finally we present the list to users. In case something goes wrong, we still have the conditions to be able to retry the API call when the user presses the retry button.
We saw above that the coordinator pattern solves some design challenges, but let's see if it can help us update the counter.
**puppy_manage_bloc.dart**
```
@RxBloc()
class PuppyManageBloc extends $PuppyManageBloc {
  PuppyManageBloc(...) {
    _$markAsFavoriteEvent
        // Mark a puppy as soon as the UI sends an event.
        .markPuppyAsFavorite(puppiesRepository, this)
        // Notify the coordinator bloc with the updated puppy.
        .doOnData((puppy) => coordinatorBloc.events.puppyUpdated(puppy))
        ...
  }
}
```
**favorite_puppies_bloc.dart**
```
abstract class FavoritePuppiesEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: false)
  void reloadFavoritePuppies({bool silently});
}

abstract class FavoritePuppiesStates {
  @RxBlocIgnoreState()
  Stream<Result<List<Puppy>>> get favoritePuppies;

  Stream<int> get count;
}
@RxBloc()
class FavoritePuppiesBloc extends $FavoritePuppiesBloc {
  FavoritePuppiesBloc(...) {
    coordinatorBloc.states.onPuppiesUpdated
        .updateFavoritePuppies(_favoritePuppies)
        .disposedBy(_compositeSubscription);
  }
  @override
  Stream<int> _mapToCountState() => _favoritePuppies.mapToCount();
}
```
You can see that the BloC responsible for updating the puppy emits an event to the coordinator BloC, after which the BloC responsible for the favorite marking of puppies listens to this change and updates the list accordingly. Since rx_bloc supports multiple states per BloC, we can expose a state FavoritePuppiesStates.count, which tells Flutter that there is a state change and the UI needs to be updated accordingly. This is also a performance optimization, as we rebuild only a small portion of the widget tree and keep our app fast and responsive.

# Building an app that can handle millions of mutable records
As we know, Flutter is very fast, but what if we need to put that technology to the limits? What if we need to handle millions of records and still want the app to be fast and responsive? Let's see how we can achieve this.
## Option 1
We can create instances of PuppyManage BloC as the user scrolls through the list. This will ensure that the extra details are fetched only when needed and the app still meets the requirements for the API requests mentioned above.
So far so good, but here we would have one big problem that would cause huge performance issues. When the user scrolls quickly, the app has to create hundreds of instances and at the same time the UI has to create subscriptions for each BloC state separately so our app will become very slow.
## Option 2
Having only one instance of each BloC type, such as search, favorites and puppy management? Let's see what this would look like.
**favorite_puppies_bloc.dart**
```
@RxBloc()
class FavoritePuppiesBloc extends $FavoritePuppiesBloc {
  FavoritePuppiesBloc(...) {

    coordinatorBloc.states.onPuppiesUpdated
        .updateFavoritePuppies(_favoritePuppies)
        .disposedBy(_compositeSubscription);
  }

  final _favoritePuppies =
      BehaviorSubject.seeded(Result<List<Puppy>>.success([]));
  
  ...
}
```

**puppy_list_bloc.dart**
```
@RxBloc()
class PuppyListBloc extends $PuppyListBloc {
  PuppyListBloc(...) {
    coordinatorBloc.states.onPuppiesUpdated
        .updatePuppies(_puppies)
        .disposedBy(_compositeSubscription);
  }

  final _puppies = BehaviorSubject.seeded(
      Result<List<Puppy>>.success([])
  );
}
```

**puppy_manage_bloc.dart**
```
@RxBloc()
class PuppyManageBloc extends $PuppyManageBloc {
  PuppyManageBloc(...) {
    _$markAsFavoriteEvent
        .markPuppyAsFavorite(puppiesRepository, this)
        .doOnData((puppy) => coordinatorBloc.events.puppyUpdated(puppy))
....
}
```

You can see that the search and favorite list have their own state, which is updated according to the puppy updates sent from ManagePuppy bloc through the coordinator bloc. And this works not only to mark a puppy as a favorite, but also to fetch extra details. But wait a second, does this mean that given that we have millions of records, the bloc has to find the one that is being updated, replace it and then tell the UI that there is state change? And the app is still working flawlessly? As I mentioned earlier Flutter is very fast and yes, the app still works smoothly.

# Architecture: the big picture
rx_bloc makes it easy to implement the BLoC design pattern using the power of reactive streams.
Following the best practices for building robust mobile applications the architecture below can be used along with the BloC layer.
This package is built to work with flutter_rx_bloc and rx_bloc_generator

# Conclusion
Building apps with reactive programming along with a sophisticated architecture is really beneficial. The apps become more robust, scalable, and maintainable.
Investing in neat architecture before starting a new project always pays off in the long term.
