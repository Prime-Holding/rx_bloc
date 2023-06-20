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

`Step 1:`
Move `brick_name_bundle.dart` to `/rx_bloc_cli/lib/src/templates/`

`Step 2:`
In `lib/src/commands/create_command.dart` do the following:
Create a private variable that will store data from the bundle that we created 
`final _brickNameBundle = brickNameBundle;`

Create a private variable that will store string that we used in `mason_templates/bricks/rx_bloc_base/brick.yaml` to name our brick
`final _brickNameString = 'brick-name';`

`Step 3:`
In the constructors initializer list find `_generator = generator ?? MasonGenerator.fromBundle` and add an option for our brick

Adding the following code will allows us to enable or disable our brick when running the rx_bloc_cli create command
```
      ..addOption(
        _brickNameString,
        help: 'Description of what adding this brick will do',
        allowed: ['true', 'false'],
        defaultsTo: 'false',
      )
```
`Step 4:`
In `_CreateCommandArguments` class add a variable for brick_name, the name and the type of this variable can be arbitrary
`final bool enableBrickName;`

`Step 5:`
Create a function that will check the value provided when running the create command
The following code checks if the provided value in the create command is true. This function is created for the values of type bool, for different types the function will differ
```
  bool _parseEnableBrickName(ArgResults arguments) {
    final brickNameEnabled = arguments[_brickNameString];
    return brickNameEnabled.toLowerCase() == 'true';
  }
```
`Step 6:`
Locate the `_validateAndParseArguments(ArgResults arguments)` function and in the list of `_CreateCommandArguments` parameters add the the call for the function created in the previus step.
`enableBrickName: _parseEnableBrickName(arguments),`

`Step 7:`
Locate the `generator.generate()` function and to `vars` parameter pass the parameters for `brick_name`

`'brick_name': arguments.enableBrickName,`

`Step 8:`
Add `brick_name` bundle files to the main `_bundle` if the `brick_name` is used
```
    if (arguments.enableBrickName) {
      _bundle.files.addAll(_brickNameBundle.files);
    }
```
`Step 9:`
Locate `_successMessageLog()` function and add log for `brick_name` as follows:
 `_usingLog('Enable Brick name', arguments.enableBrickName);`
