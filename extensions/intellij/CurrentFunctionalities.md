# Location of Functionality for future Bug - Fixes or Improvements

<img width="629" alt="image16" src="https://user-images.githubusercontent.com/98388232/234256084-929cbfc9-f24d-4e62-abab-d789ef2ad4b2.png">

## RxBloc List

RxBloc List has an entry point at [GenerateRxListBlocAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/develop/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/action/GenerateRxListBlocAction.kt). 

It basically shows the [dialog RxBloc List.java](https://github.com/Prime-Holding/rx_bloc/blob/develop/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/action/GenerateRxListBlocDialog.java)
that is designed Java GUI form by the IntelliJ editor and after clicking OK it returns to the action.

<img width="256" alt="image7" src="https://user-images.githubusercontent.com/98388232/234256238-6aab4cf8-8273-4bcd-906d-74e66ac8267a.png">

It generates 3 files. The code in the [GenerateRxListBlocAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/develop/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/action/GenerateRxListBlocAction.kt) 
is actually very basic and just bridges the code generators result with the IntelliJ APIs for writing content.

<img width="349" alt="image5" src="https://user-images.githubusercontent.com/98388232/234256310-36c561e9-7c0c-4529-9ae6-82f9602829bd.png">

- [RxBlocListGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxBlocListGenerator.kt)
- [RxBlocListExtensionGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxBlocListExtensionGenerator.kt)
- [RxGeneratedBlocListGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxGeneratedBlocListGenerator.kt)

## RxBloc Feature

<img width="521" alt="image6" src="https://user-images.githubusercontent.com/98388232/234256472-7c9229e9-4734-4ee8-89a2-3ce1cbad9c91.png">

It has similar organization as with the RxBloc List. First a dialog:

<img width="440" alt="image2" src="https://user-images.githubusercontent.com/98388232/234256581-a8ce9640-3ce9-430d-ac78-b7c3b04e6bda.png">

And then generators:

<img width="361" alt="image12" src="https://user-images.githubusercontent.com/98388232/234256660-2c584109-29ac-43a8-b917-19b50f907cdf.png">


- [RxBlocGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxBlocGenerator.kt)
- - [RxGeneratedNullSafetyBlocGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxGeneratedNullSafetyBlocGenerator.kt)
- - [RxBlocExtensionGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxBlocExtensionGenerator.kt) or [RxBlocWithServiceGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/049f3eecd35f15f68a2ca87a8330420fe09cf0dc/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxBlocWithServiceGenerator.kt)
- [RxDependenciesGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/049f3eecd35f15f68a2ca87a8330420fe09cf0dc/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxDependenciesGenerator.kt)
- [RxPageGenerator.kt](https://github.com/Prime-Holding/rx_bloc/blob/049f3eecd35f15f68a2ca87a8330420fe09cf0dc/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxPageGenerator.kt)

There are more options so the generators are flags and routing integration dependent. 
Also, the additions required for Go Router integration are implemented inline in the [GenerateRxBlocFeatureAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/fa97c7bdeea5978458765e1abceedb6a07427a1e/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/action/GenerateRxBlocFeatureAction.kt)

## RxBloc Class

[GenerateRxBlocAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/fa97c7bdeea5978458765e1abceedb6a07427a1e/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/action/GenerateRxBlocFeatureAction.kt) 
is the first dot of the feature (without the page, the view and the routing integration)

<img width="391" alt="image15" src="https://user-images.githubusercontent.com/98388232/234256893-c525c268-4dfa-4aa9-8202-71acf2818642.png">

## Tests Bootstrapers


The Test Bootstrapping actions are in two places: 
- [BootstrapTestsAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/049f3eecd35f15f68a2ca87a8330420fe09cf0dc/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/action/BootstrapTestsAction.kt) - it’s version 1 for tests. It is generating code for full feature 
- [Bloc Test](https://github.com/Prime-Holding/rx_bloc/blob/9ff87b7a6c3d707403cfe1258c809f5950a4ed38/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components/RxTestBlocGenerator.kt) - testing each and all the bloc states changes
- Golden Test  - testing all the UI states (empty, loading, error, success)
- - Golden test Helper 1 - A Factory for the Page - wrapped in mocked bloc prodiver
- - Golden test Helper 2 - Mock of the BloC states with values passed as parameters

<img width="652" alt="image8" src="https://user-images.githubusercontent.com/98388232/234257049-a1678ba8-de83-4044-b78c-9e62decfc327.png">

It has dialog ( [ChooseBlocsDialog.java](https://github.com/Prime-Holding/rx_bloc/blob/049f3eecd35f15f68a2ca87a8330420fe09cf0dc/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/ui/ChooseBlocsDialog.java) ) with dynamically checked checkboxes - depending on the already present tests.

<img width="806" alt="image1" src="https://user-images.githubusercontent.com/98388232/234257158-55e0fda3-7c03-4181-87c7-2eed153aa248.png">

[BootstrapSingleTestAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/9ff87b7a6c3d707403cfe1258c809f5950a4ed38/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/action/BootstrapSingleTestAction.kt) - version 2 for tests
- Single Golden Test - the golden test from the feature test - extracted as a standalone generator
- Single Bloc Test - the unit test from the feature test - extracted as a standalone
- Service Test - simple public methods test generator
- Repository Test - same as Service test

<img width="674" alt="image3" src="https://user-images.githubusercontent.com/98388232/234257334-239f9b40-5c40-464c-aa7a-9c14275acae6.png">
<img width="584" alt="image10" src="https://user-images.githubusercontent.com/98388232/234257481-890801dc-8911-43d3-8347-803647035101.png">
<img width="819" alt="image14" src="https://user-images.githubusercontent.com/98388232/234257527-b295d852-81e2-4d2f-9417-4ff0298b60ea.png">

## RxBloc Wrappers / Intent Actions

All the Bloc Wrappers have a common base and little to no functionality within the actions. The only difference in the snippet type. 

- [BlocWrapWithBlocBuilderIntentionAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithBlocBuilderIntentionAction.java)
- [BlocWrapWithBlocListenerIntentionAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithBlocListenerIntentionAction.java)
- [BlocWrapWithBlocPaginatedBuilderIntentionAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithBlocPaginatedBuilderIntentionAction.java)
- [BlocWrapWithBlocResultBuilderIntentionAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithBlocResultBuilderIntentionAction.java)
- [BlocWrapWithFormFieldBuilderIntentionAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithFormFieldBuilderIntentionAction.java)
- [BlocWrapWithFormTextFieldBuilderIntentionAction.kt](https://github.com/Prime-Holding/rx_bloc/blob/66e2bbf6a38f115e5e950d8a2006dfe42f9d42a2/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithFormTextFieldBuilderIntentionAction.java)


The Actual Snippet Replacement is in two utils: 
- [Snippets.java](https://github.com/Prime-Holding/rx_bloc/blob/9ff87b7a6c3d707403cfe1258c809f5950a4ed38/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/Snippets.java)
- [SmarSnippets.java](https://github.com/Prime-Holding/rx_bloc/blob/9ff87b7a6c3d707403cfe1258c809f5950a4ed38/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/SmartSnippets.java)

The smart snippets take advantage of extraction of the BloC Data Model Structure 
- (done in generator/parser/ [Utils.extractBloc](https://github.com/Prime-Holding/rx_bloc/blob/9ff87b7a6c3d707403cfe1258c809f5950a4ed38/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/parser/Utils.kt) (blocFile) 
- to offer compilable/auto-populated view bindings 
- with the states of a BloC. 

The actual Extraction / Selection - happens in [BlocWrapWithIntentionAction.invokeSnippetAction](https://github.com/Prime-Holding/rx_bloc/blob/9ff87b7a6c3d707403cfe1258c809f5950a4ed38/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithIntentionAction.java). 

<img width="454" alt="image11" src="https://user-images.githubusercontent.com/98388232/234257695-7a238234-b573-491e-89ce-16475d49b93b.png">
<img width="588" alt="image13" src="https://user-images.githubusercontent.com/98388232/234257817-bbc21900-2102-4623-b345-aa4617647c24.png">
At the time of writing this, the functionality was more important than the code structure - so it is very coupled inside the BlocWrapWithIntentionAction.java
- Java GUI (choosing the state), 

<img width="588" alt="image13" src="https://user-images.githubusercontent.com/98388232/234257754-e429fd7f-439d-4866-a32d-8a46b37c0090.png">

- [IntelliJ APIs - reading/writing files](https://github.com/Prime-Holding/rx_bloc/blob/develop/extensions/intellij/IntelliJ_APIs.md), 
- cursor location (IDEs APIs), [BlocWrapWithIntentionAction.execute()](https://github.com/Prime-Holding/rx_bloc/blob/9ff87b7a6c3d707403cfe1258c809f5950a4ed38/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/intention_action/BlocWrapWithIntentionAction.java) // the caret positioning
- and the actual custom snippet wrapping. 

