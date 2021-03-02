# RxBloc Plugin for IntelliJ and Android Studio

![dialog](https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc/doc/asset/android_plugin.png)

## Introduction

Bloc plugin for [IntelliJ](https://www.jetbrains.com/idea/) and [Android Studio](https://developer.android.com/studio/) which provides tools for effectively creating [RxBlocs](https://pub.dev/packages/rx_bloc/) for [Flutter](https://flutter.dev/) apps.

## Installation

You can find the plugin in the official IntelliJ and Android Studio marketplace:

- [RxBloc](https://plugins.jetbrains.com/plugin/16165-rxbloc)

### How to use

Simply right click on the File Project view, go to `New -> RxBloc Class`, give it a name, select if you want to use some of the additional states and/or extensions, and click on `OK` to see all the boilerplate generated.


### Post-installation steps
Keep in mind that any futher changes on the bloc's logic would not take effect until you trigger one of the [RxBlocGenerator](https://pub.dev/packages/rx_bloc_generator) runner commands(`flutter packages pub run build_runner build` or `flutter packages pub run build_runner watch`) for generating the boilerplate code.

## Deployment

Using [Plugin Repository](http://www.jetbrains.org/intellij/sdk/docs/plugin_repository/index.html)
