## RxPaginatedBuilder

*RxPaginatedBuilder* package giving the user the possibility to quickly add infinity scroll and pull-to-refresh features to their project with minimal setup. It provides the flexibility and simplicity of presentation of paginated data with the use of [RxBloc](https://pub.dev/packages/rx_bloc "RxBloc")s inside the *RxBloc ecosystem*.

## Table of contents
- [Usage](#usage)
- [Setup](#setup)
- [Additional parameters](#additional-params)
- [RxPaginatedBuilder.withRefreshIndicator](#withRefreshIndicator)

<br/>
<div id="usage"/>

### Usage

Before using the actual package add it to the `pubspec.yaml` dependencies:
```yaml
dependencies:
  rx_bloc_list: latest_version
```
Also be sure to import the package:
```dart
import 'package:rx_bloc_list/rx_bloc_list.dart';
```
Now you can include the ***RxPaginatedList*** in your project like this:


```dart
class PaginatedListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: RxPaginatedBuilder<UserBlocType, User>.withRefreshIndicator(
          state: (bloc) => bloc.states.paginatedList,
          onBottomScrolled: (bloc) => bloc.events.loadPage(),
          onRefresh: (bloc) async {
            bloc.events.loadPage(reset: true);
            return bloc.states.refreshDone;
          },
          builder: (context, snapshot, bloc) => Column(
            children: [
              if (snapshot.isInitialLoading) const YourProgressIndicator(),
              if (!snapshot.isInitialLoading)
                ListView.builder(
                  itemCount: snapshot.itemCount,
                  itemBuilder: (context, index) {
                    final user = snapshot.getItem(index);

                    if (user == null) {
                      return const YourProgressIndicator();
                    }

                    return YourListTile(user: user);
                  },
                )
            ],
          ),
        ),
      );
});
```


| Initial loading of the data           | Default app state           |
|---------------------------------------|-----------------------------|
| <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/initial_load.png" alt="Initial loading"> | <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/normal.png" alt="Default state"></img> |

| Loading of the next page (infinity loading)           | Data refreshing (pull to refresh)          |
|---------------------------------------|-----------------------------|
| <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/infinity_load.png" alt="Infinity loading"> | <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/refresh.png" alt="Refreshing"> |


<div id="setup"/>

### Setup

In order to make use of the RxPaginatedBuilder, you first need to specify the following required parameters:
- `state` is the state of the BLoC that will be listened for changes. The state is a `Stream<PaginatedList<T>>` where T is the type of the data that is being paginated.
- `builder` is the method which creates the child widget. Every time the state updates, this method is executed and the widget is rebuild. Inside the builder method you have access to the `BuildContext`, `AsyncSnapshot<PaginatedList<T>>` of the data that is being paginated and the `BLoC` that contains the listened state.
- `onBottomScrolled` is a callback that is executed once the end of the list is reached. This can be, for instance, used for fetching the next page of data.

<div id="additional-params" />

### Additional parameters

*RxPaginatedBuilder* also comes with additional optional parameters that can be adjusted to you needs.

The `wrapperBuilder` method is a builder method with the intention of creating a wrapper widget around the child widget built using the main `builder` method. The wrapperBuilder method gives you access to the `BuildContext`, `BLoC` containing the state that is listened and the `Widget` that is build with the `builder` method. This method can be used for adding additional functionality or help in cases when the built child widget is needed beforehand.

You can manage the execution of the `onBottomScrolled` parameter by enabling or disabling it via the `enableOnBottomScrolledCallback`.

Additionally, you can define the minimum scroll threshold which will execute the `onBottomScrolled` callback by changing the value of `scrollThreshold`. The default value of the scroll threshold is 100 pixels.

The RxPaginatedBuilder also provides the ability to react to scrolling via the `onScrolled` callback, with a parameter telling whether the user is or has stopped scrolling.

There may be cases where you have a reference to the BLoC that is used by the RxPaginatedBuilder. By specifying the `bloc` parameter you remove the need to perform a lookup for that BLoC in the widget tree, improving the performance by a small bit.

<div id="withRefreshIndicator" />

### RxPaginatedBuilder.withRefreshIndicator

Sometimes, you may want to have a working pagination and pull-to-refresh without spending too much time on it. Using the *RxPaginatedBuilder.withRefreshIndicator* gives you access to a [Refresh Indicator](https://api.flutter.dev/flutter/material/RefreshIndicator-class.html "Refresh Indicator") straight out of the box.

Along with the required parameters of the default implementation, *RxPaginatedBuilder.withRefreshIndicator* gets rid of the `wrapperBuilder` but introduces a new required parameter `onRefresh`. The `onRefresh` callback is triggered once a pull-to-refresh has been performed. The callback, containing the BLoC as a parameter, should return a future, which once complete will make the refresh indicator disappear.
