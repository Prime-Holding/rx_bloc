# Implementing new actions

For new Actions - it is highly recommend wrapping calls to the IntelliJ APIs, Java GUIs and anything other than String/Code transformations and templates to be wrapped in Object Oriented Abstractions. 

The simplest approach would be to wrap calls to external APIs in protected methods and have them overridden for the purposes of tests.
The goal is the actual logic to be more testable and verifiable with simpler - input value String x -> expect String value y. 


Common behaviors that could be extracted are:

- Collecting information required for the action that may require calls to IntelliJ or Java IO
- Checking for file existence 
- Writing files 
- Opening new Files in The Editor

Work In Progress Samples that try to follow the guidelines is present [here](https://github.com/Prime-Holding/rx_bloc/commit/7864ccc1e31a82304eaa022be1d10c5d12acd0f8#diff-c618366b163657f94ba3a0d6cd7193f3c038c8f79067e6ac22368fd22982295a):

About anu new files you are planning to add - you could take advantage of the current templating system and reuse transformations of the classes, methods, names, parameters:

- variableCase
- snake_case
- PascalCase

The current implementations are located in [src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components](https://github.com/Prime-Holding/rx_bloc/tree/develop/extensions/intellij/intellij_generator_plugin/src/main/java/com/primeholding/rxbloc_generator_plugin/generator/components)

The important things there are: 
- Choosing from template folder (in RxBlocGeneratorBase.kt): 	
- And the file template name 

## Adding new Action

### Configuration

Add an action in plugin.xml under the <actions>...</actions> tag. You could choose from Java or Kotlin as a language.

```
<action class="com.primeholding.rxbloc_generator_plugin.action.GenerateServiceMockAction"
   description="Generate a Service Mock"
   id="GenerateServiceMockId"
   icon="/icons/rx_bloc.png"
   text="Service Mock">
   <add-to-group
       group-id="NewGroup"
       anchor="first"/>
</action>
```

## Create the Necessary class

Create the Necessary class that needs to extend IntelliJ’s “AnAction”

### Update Availability

Override the method
```
public void update(AnActionEvent event) {//..
```

You could hide the action, change the label or whatever you need through the ```event.getPresentation()``` Presentation object. 

The logic most probably will come from 

```VirtualFile[] virtualFiles = event.getDataContext().getData(DataKeys.VIRTUAL_FILE_ARRAY); // These are the selected files.```

This will make the action contextual. Rare are the cases where an action is available in absolutely every case.

## Adding new Intent Action

### Configuration

Add an Intent Action under the <extensions>...</extensions> tag. You could choose from Java or Kotlin as a language.

```
<intentionAction>
<className>com.primeholding.rxbloc_generator_plugin.intention_action.GenerateModelJsonFactoryAction</className>
   <category>JSON</category>
</intentionAction>
```

### Create the Necessary class

Create the Necessary class that needs to implement IntelliJ’s “IntentAction”/or extend BaseIntentAction. 
Additionally - there are few meta resource files needed - description.html, before template and after template.

### Update Availability

The presence of the intent action may be decided from the override of the method:

```
public boolean isAvailable(@NotNull Project project, Editor editor, PsiFile file) {
```

## Code Generator Templates

The majority of the new file code generators take advantage of the templates located under src/main/resources/templates. 
They are standard dart files that contain variable placeholders '${bloc_snake_case} - That are replaced by the template engine.

When a placeholder text contains texts with inner variable placehodlers, these are implemented (unoptimally) in the code.


