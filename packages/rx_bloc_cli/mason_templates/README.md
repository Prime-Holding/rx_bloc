## Installing Mason Package

Open your terminal or command prompt.
Run the following command to install the Mason package:
`dart pub global activate mason`

Following command installs mason_cli:
`dart pub global activate mason_cli`

## Creating a Mason Brick

### Initializing mason

To initialize mason in the current directory run command
`mason init`
this step is not needed in `rx_bloc_cli/mason_templates/bricks`

### Creating a new brick

`mason new brick_name`
When you execute the command `mason new brick_name`, it will generate a subdirectory within the current directory, and the name of this subdirectory will be exactly the same as the 'brick_name' you provide as an argument. This subdirectory will be automatically created to organize and store the files related to the brick you are making.
All bricks should be created in `rx_bloc_cli/mason_templates/bricks` directory

## Working with brick

Provide short description of what the brick does inside `/brick_name/brick.yaml` file.
Remove all `vars:` within the `/brick_name/brick.yaml` file.
In `/mason_templates/bricks/rx_bloc_base/brick.yaml` under vars add variable representing newly created brick, this value will later be used when integrating the brick with rx_bloc_cli
Example: `brick_name`

### Adding files to the brick

When using the brick all files within the `__brick__` directory will be added to the base project.
The files in brick should be created with the path that we want the file to be located within the project.
Example:
We want for our brick to be created in lib directory

├── lib
│   └──feature_name

In order to do this, in our brick we should create `feature_name` directory with the path `/lib/feature_name/`, so the full path should look like `../brick_name/__brick__/lib/feature_name/`

### Conditional logic

If there is a need to conditionally generate code based on if the brick is used or not, we can do the following:

Wrapping the code block in the following syntax WILL generate the code if the brick is used
```
{{#brick_name}}
publish_to: none
{{/brick_name}}
```

Wrapping the code block in the following syntax WILL NOT generate the code if the brick is used

```
{{^brick_name}}
publish_to: none
{{/brick_name}}
```

The same syntax can be used to conditionally generate files:
`{{#brick_name}}CHANGELOG.md{{/brick_name}}`

For more info follow the [official mason documentation](https://docs.brickhub.dev/brick-syntax#-conditionals)


### License 

The license should be added at the start of each document inside brick
The following line provides licensing info
`{{> licence.dart }}`

The license text should be added to the `LICENSE` file located in newly created brick


## Generating Code from the Template

Generates a mason bundle as a dart file from the provided brick files
`mason bundle -t dart .`
Running this command will generate a new file in the `brick_name` directory with the name:
`brick_name_bundle.dart`

## Integrating new brick into rx_bloc_cli create command

#### Step 1
Move `brick_name_bundle.dart` to `/rx_bloc_cli/lib/src/templates/`

#### Step 2
If your command requires a new argument, add it to the `CommandArguments` enum.

```dart
enum CommandArguments { 
  // ...
  awesomeFeature(
    name: 'enable-awesome-feature',
    type: ArgumentType.boolean,
    defaultsTo: true,
    prompt: 'Enable awesome feature:',
    help: 'Enables a new awesome feature for the project',
  ),  
  // ...
}
```

Also define a corresponding variable in the `brick.yaml` file if needed. 
```yaml
environment:
  mason: ">=0.1.0-dev <0.1.0"
vars:
  - project_name
  - organization_name
  # ...
  - awesome_feature
  # ...
```

Update `generate_test_project.sh`, `compile_bundles.sh` and `compile_win.bat` with the newly included argument.

The supported argument types are listed in the `ArgumentType` enum. 

You can add new types if needed. In the cases where a new type is introduced, you also need to 
include it into the `addCommandArguments` extension method of `ArgParser` 
(located in `arg_parser_extensions.dart`) and provide option to read it from `ArgResults` in 
the `arg_results_extensions.dart`.

#### Step 3 (only for new argument types)
Now that the argument is defined, we need to be able to read it from the user's input. That's 
where the readers come into the picture. 
The `CommandArgumentsReader` and `BaseCommandArgumentsReader` provide the basic infrastructure for 
reading the provided values for each argument. There are concrete classes for *interactive* and 
*non-interactive* input that define the specifics on **how** each argument type is read. 
See the files in `models/readers` directory for better overview.

If you haven't introduced a new argument type, you probably won't need to modify the readers.

#### Step 4
For better readability and scalability, arguments are divided into logically related groups. 
You can check them out in the `configurations` directory. The configurations contain all the 
arguments from the user input along with computed arguments. Computed values are useful for 
modules that depend on each other (like login / pin / otp features depend on authentication). 

```dart
class FeatureConfiguration {
  // ...
  final bool awesomeFeatureEnabled;
}
```

Also populate the corresponding implementation in `GeneratorArguments`. 

```dart
class GeneratorArguments implements ProjectConfiguration, AuthConfiguration, FeatureConfiguration {
  // ...
  @override
  bool get awesomeFeatureEnabled => _featureConfiguration.awesomeFeatureEnabled;
}
```

#### Step 5
Read the argument in `GeneratorArgumentsProvider` and implement any additional logic around it. 
This is the place where you can enable / disable features based on the provided input and inform 
the user of any changes, using the logger instance inside.

```dart
class GeneratorArgumentsProvider {
  // ...
 FeatureConfiguration _readFeatureConfiguration() {
    // ...
    final awesomeFeatureEnabled = _reader.read<bool>(CommandArguments.awesomeFeature);
    // ...

    return FeatureConfiguration(
      awesomeFeatureEnabled: awesomeFeatureEnabled,
      // ...
    );
  }
}
```

### Step 6
The last step is to use the `GeneratorArguments` to populate the generated project. 

This is done by adding the correct template in the `BundleGenerator`. You can also specify  
additional logic related to files inclusion / exclusion and dependencies between them.

```dart
class BundleGenerator {
  // ...
  final _awesomeFeatureBundle = awesomeFeatureBundle;

  /// Generates a bundles based on the specified arguments
  MasonBundle generate(GeneratorArguments arguments) {
    // ...
    if (arguments.awesomeFeatureEnabled) {
      _bundle.files.addAll(_awesomeFeatureBundle.files);
    }
  }
}
```

Also pass the new arguments from `GeneratorArguments` to the project vars in `create_command.dart`.

```dart
Future<void> _generateViaMasonBundle(GeneratorArguments arguments) async {
  // ...
  var generatedFiles = await generator.generate(
    DirectoryGeneratorTarget(arguments.outputDirectory),
    vars: {
      // ...
      'awesome_feature': arguments.awesomeFeatureEnabled,
    },
  );
}
```

#### Step 7
Locate `_successMessageLog()` function and add log for your new brick as follows:
```dart
void _successMessageLog(int fileCount, GeneratorArguments arguments) {
  // ...
  _usingLog('Enable Awesome Feature', arguments.awesomeFeatureEnabled);
}
```

#### Step 8
Add unit tests if necessary
