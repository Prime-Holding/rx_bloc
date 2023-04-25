# Getting started

To get started - download the latest version of the source code from here: 
[https://github.com/Prime-Holding/rx_bloc/tree/develop/extensions/intellij](https://github.com/Prime-Holding/rx_bloc/tree/develop/extensions/intellij)
IDE.

The plugin is written in a mix of Java and Kotlin code, so you need an IDE that supports both. IntelliJ Community Edition was currently used, 
but probably Eclipse or Visual Studio Code, or some other could also be used. 

## Build 

Building is executed with the Gradle Build System. To create a zip package that could be installed on Android Studio - execute:
[gradle] ``` clean assemble ``` - with working directory the …/extensions/intellij/intellij_generator_plugin 

##Configuration 

Actions in IntelliJ are plugged in by defining them in resources/META-INF/plugins.xml

Any class definition must not have spaces: 
```
<className>com.primeholding.rxbloc_generator_plugin.intention_action.BlocWrapWithBlocBuilderIntentionAction</className>
```

## Current IntelliJ Actions

The two types of extensions added to the IDE with the Rx BloC plugin are:
- Actions - commands available from the project menu
- Create Feature
- Create BloC 
- Create BloC List 
- Bootstrap Feature Tests
- Bootstrap BloC Test
- Bootstrap Service Test
- Bootstrap Repository Test
- Create Golden Test 

and Intent Actions - commands available in the code editor
- Wrap UI Widget with 
- RxBlocBuilder,
- RxResultBuilder,
- RxPaginatedBuilder,
- RxBlocListener,
- RxFormFieldBuilder,
- RxTextFormFieldBuilder

Before getting into the actual actual logic - all actions have a pre-action hook the could influence the presence of the action:
- ``` Update(e: AnActionEvent?) ``` - for Actions 
- ``` IsAvailable(Project, Editor, PsiElement) ``` - for Intent Actions

Such hooks are currently in use to make some of the actions “Contextual”. 

- When you click on lib, project,test dir - the plugin will make available the action - to the dialog choosing a feature to create test from
- When you right-click on a feature - generate feature will just try to generate a test for it.
- When right-clicking on service, repository - it will make the action “Create Service/Repository Test” - available. 
- So on.

