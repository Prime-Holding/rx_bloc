# RxBloc Plugin for IntelliJ and Android Studio

This README is summary of the sub-documentations: 

- [Getting Started](https://github.com/Prime-Holding/rx_bloc/blob/plugin-readme/extensions/intellij/GettingStarted.md) 
- [Current Functionalities](https://github.com/Prime-Holding/rx_bloc/blob/plugin-readme/extensions/intellij/CurrentFunctionalities.md)
- [Extracting Semantics From The Code](https://github.com/Prime-Holding/rx_bloc/blob/plugin-readme/extensions/intellij/ExtractingSemanticsFromTheCode.md)
- [Implelement New Actions](https://github.com/Prime-Holding/rx_bloc/blob/plugin-readme/extensions/intellij/ImplelementNewActions.md)
- [IntelliJ APIs](https://github.com/Prime-Holding/rx_bloc/blob/plugin-readme/extensions/intellij/IntelliJ_APIs.md)
- [Plugin Unit Tests](https://github.com/Prime-Holding/rx_bloc/blob/plugin-readme/extensions/intellij/PluginUnitTests.md)


![dialog](https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc/doc/asset/android_plugin.png)

## Introduction

Bloc plugin for [IntelliJ](https://www.jetbrains.com/idea/) and [Android Studio](https://developer.android.com/studio/) which provides tools for effectively creating [RxBlocs](https://pub.dev/packages/rx_bloc/) for [Flutter](https://flutter.dev/) apps.

## Installation

You can find the plugin in the official IntelliJ and Android Studio marketplace:

- [RxBloc](https://plugins.jetbrains.com/plugin/16165-rxbloc)

### How to use

Simply right click on the File Project view, go to `New -> RxBloc Class`, give it a name, select if you want to use some of the additional states, dedicated extensions file and if your version of the project supports null safety, and click on `OK` to see all the boilerplate generated.

Bicides BloC Class, you could also create:
- Rx Bloc List
- Rx Bloc Feature
- Unit Tests. 

![create_rx_bloc_items](https://user-images.githubusercontent.com/98388232/233932969-7bc8a78f-e130-4eed-b0c3-451153e1141e.png)

Depending on the selected item you could also Bootstrap
- Feature full-set of Unit Tests 
- Golden Unit Tests
- Bloc Unit Tests
- Service, Repository Unit Tests.


### Post-installation steps
Keep in mind that any futher changes on the bloc's logic would not take effect until you trigger one of the [RxBlocGenerator](https://pub.dev/packages/rx_bloc_generator) runner commands(`flutter packages pub run build_runner build` or `flutter packages pub run build_runner watch`) for generating the boilerplate code.

## Smart Bloc State auto-wrap

While editing pages or views - located in the standardised feature file/folder structure, the plugin offers smart selection and auto-population from the BloC States: 

<img width="454" alt="choosing_wrapper" src="https://user-images.githubusercontent.com/98388232/233940940-70623856-ace0-4a36-9a5a-39d5159e0c2f.png">
<img width="1013" alt="choosing_state" src="https://user-images.githubusercontent.com/98388232/233940929-95a6b233-d541-4be3-bf27-36f37b499582.png">
<img width="588" alt="after_wrap" src="https://user-images.githubusercontent.com/98388232/233940937-84cd0a5f-b2e6-443b-883e-a22a63c662d8.png">

## Deployment

Using [Plugin Repository](http://www.jetbrains.org/intellij/sdk/docs/plugin_repository/index.html)

## How to extend

1. Add new Action (item added to the Project Menu), or Intent Action (item added in the Editor) in resources/META-INF-plugins.xml 
 ![RxBlocPluginIDE](https://user-images.githubusercontent.com/98388232/233934683-c20565b6-369b-43ca-9c14-f889e21819c8.jpg)

Note: The class definition names should NOT have any spaces. Example:  
```
<className>com.primeholding.rxbloc_generator_plugin.intention_action.BlocWrapWithBlocBuilderIntentionAction</className> 
```

2. Create your actions in Java or Kotlin programming language and extend or implement the necessary IntelliJ API classes AnAction or BaseIntentionAction.

2.1 Override the appropiate hook method called before the IDE presents the actions the user - to modify if it is present.

 ```
isAvailable(@NotNull Project project, Editor editor, PsiFile file) .... // for Intent Actions
```

or

 ```
 public void update(AnActionEvent event) ... // for Project Menu Actions
```

2.2 Implement the actual logic in the invoke methids. 

 ```
    public void invoke(@NotNull Project project, Editor editor, PsiFile file) throws IncorrectOperationException { ... }
 ```

 ```
     public void actionPerformed(AnActionEvent e) { ... }
 ```

 
Sample snippets with different Plugin APIs could be found [here](https://github.com/Prime-Holding/rx_bloc/compare/feature/new_actions_example).
 
