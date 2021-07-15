![CI](https://github.com/Prime-Holding/rx_bloc/workflows/CI/badge.svg) [![codecov](https://codecov.io/gh/Prime-Holding/rx_bloc/branch/develop/graph/badge.svg)](https://codecov.io/gh/Prime-Holding/rx_bloc/branch/develop) ![style](https://img.shields.io/badge/style-effective_dart-40c4ff.svg) ![license](https://img.shields.io/badge/license-MIT-purple.svg)

## rx_bloc_list

The *[rx_bloc_list](https://pub.dev/packages/rx_bloc_list)* package facilitates implementing `infinity scroll` and `pull-to-refresh` features with minimal setup. This package is meant to be used along with *[RxBloc ecosystem](https://medium.com/prime-holding-jsc/introducing-rx-bloc-ecosystem-part-1-3cc5f4fff14e)*.

## Table of contents
- [Usage](#usage)
- [Setup](#setup)
- [Additional parameters](#additional-params)
- [RxPaginatedBuilder.withRefreshIndicator](#withRefreshIndicator)
- [Articles](#articles)

<div id="usage"/>

### Usage

Before using the actual package add it to the `pubspec.yaml` dependencies:
```yaml
dependencies:
  rx_bloc_list: any
```
Also be sure to import the package:
```dart
import 'package:rx_bloc_list/rx_bloc_list.dart';
```
Now you can include the ***RxPaginatedBuilder*** in your project like this:


```dart
class PaginatedListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: RxPaginatedBuilder<UserBlocType, User>.withRefreshIndicator(
            state: (bloc) => bloc.states.paginatedList,
            onBottomScrolled: (bloc) => bloc.events.loadPage(),
            onRefresh: (bloc) async {
              bloc.events.loadPage(reset: true);
              return bloc.states.refreshDone;
            },
            buildSuccess: (context, list, bloc) => ListView.builder(
              itemBuilder: (context, index) {
                final user = list.getItem(index);

                if (user == null) {
                  return const YourProgressIndicator();
                }

                return YourListTile(user: user);
              },
              itemCount: list.itemCount,
            ),
            buildLoading: (context, list, bloc) =>
                const YourProgressIndicator(),
            buildError: (context, list, bloc) =>
                YourErrorWidget(error: list.error!),
          ),
        ),
      );
}
```


| Initial loading of the data           | Default app state           |
|---------------------------------------|-----------------------------|
| <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/initial_load.png" alt="Initial loading"> | <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/normal.png" alt="Default state"></img> |

| Loading of the next page (infinity scroll)           | Data refreshing (pull to refresh)          |
|---------------------------------------|-----------------------------|
| <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/infinity_load.png" alt="Infinity loading"> | <img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_list/doc/assets/refresh.png" alt="Refreshing"> |


<div id="setup"/>

### Setup

In order to make use of the RxPaginatedBuilder, you first need to specify the following required parameters:
- `state` is the state of the BLoC that will be listened for changes. The state is a `Stream<PaginatedList<T>>` where T is the type of the data that is being paginated.
- `buildSuccess` is a callback which is invoked when the list is not empty or when the next page is being loaded.
- `buildError` is a callback which is invoked when the `state` is of type `Result.error`
- `buildLoading` is a callback which is invoked only on the initial loading.
- `onBottomScrolled` is a callback that is executed once the end of the list is reached. This can be, for instance, used for fetching the next page of data.

<div id="additional-params" />

### Additional parameters

*RxPaginatedBuilder* also comes with additional optional parameters that can be adjusted to you needs.

The `wrapperBuilder` method is a builder method with the intention of creating a wrapper widget around the child widget built using the `buildSuccess`, `buildError` and `buildLoading` methods. The wrapperBuilder method gives you access to the `BuildContext`, `BLoC` containing the state that is listened and the `Widget` that is build with the `builders` method. This method can be used for adding additional functionality or help in cases when the built child widget is needed beforehand.

You can manage the execution of the `onBottomScrolled` parameter by enabling or disabling it via the `enableOnBottomScrolledCallback`.

Additionally, you can define the minimum scroll threshold which will execute the `onBottomScrolled` callback by changing the value of `scrollThreshold`. The default value of the scroll threshold is 100 pixels.

The RxPaginatedBuilder also provides the ability to react to scrolling via the `onScrolled` callback, with a parameter telling whether the user is or has stopped scrolling.

There may be cases where you have a reference to the BLoC that is used by the RxPaginatedBuilder. By specifying the `bloc` parameter you remove the need to perform a lookup for that BLoC in the widget tree, improving the performance by a small bit.

<div id="withRefreshIndicator" />

### RxPaginatedBuilder.withRefreshIndicator

Sometimes, you may want to have a working pagination and pull-to-refresh without spending too much time on it. Using the *RxPaginatedBuilder.withRefreshIndicator* gives you access to a [Refresh Indicator](https://api.flutter.dev/flutter/material/RefreshIndicator-class.html "Refresh Indicator") straight out of the box.

Along with the required parameters of the default implementation, *RxPaginatedBuilder.withRefreshIndicator* gets rid of the `wrapperBuilder` but introduces a new required parameter `onRefresh`. The `onRefresh` callback is triggered once a pull-to-refresh has been performed. The callback, containing the BLoC as a parameter, should return a future, which once complete will make the refresh indicator disappear.

## Video tutorials
- [Building feature-rich lists in Flutter](https://youtu.be/Nc8OLxYhQ0w) A feature-rich ListView implementation in Flutter that demonstrates how easy it is to build common functionalities such as `pull-to-refresh` and `infinite-scroll`.

## Articles
- [Easy paginated lists in Flutter](https://medium.com/prime-holding-jsc/easy-paginated-lists-in-flutter-b1cfb82188d8) Implementing `infinity scroll` and `pull-to-refresh` in your app was never so easy.
- [Introducing rx_bloc ecosystem](https://medium.com/prime-holding-jsc/introducing-rx-bloc-ecosystem-part-1-3cc5f4fff14e) A set of Flutter packages that help implement the BloC (Business Logic Component) design pattern using the power of reactive streams.
