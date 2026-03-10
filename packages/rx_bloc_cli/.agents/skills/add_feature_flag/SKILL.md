---
description: Add a new boolean feature flag to the rx_bloc_cli — touches CreateCommandArguments, configurations, GeneratorArguments, BundleGenerator, CreateCommand, and optionally processors and generate_test_project.sh
---

# Add a New Feature Flag

This skill guides adding a complete new boolean feature flag to `rx_bloc_cli`, from CLI argument definition through to template generation.

## Inputs Required

1. **Flag name** — the snake_case flag identifier (e.g., `enable_my_feature`)
2. **CLI arg name** — the `--kebab-case` argument (e.g., `--enable-my-feature`)
3. **Which configuration group** — one of: `ProjectConfiguration`, `AuthConfiguration`, `FeatureConfiguration`, `ShowcaseConfiguration`
4. **Associated mason brick name** — e.g., `feature_my_feature` (or an existing brick to extend)
5. **Default value** — `true` or `false`
6. **Whether platform processors are needed** — does it require changes to AndroidManifest, plist, podfile, or gradle?

## Checklist — Touch Every File Below

### 1. `lib/src/models/command_arguments/create_command_arguments.dart`

Add an enum case to `CreateCommandArguments`:

```dart
myFeature(
  name: 'enable-my-feature',
  type: CreateCommandArgumentType.boolean,
  defaultsTo: false,
  prompt: 'Enable my feature:',
  help: 'Enables my feature for the project',
),
```

### 2. `lib/src/models/configurations/<group>_configuration.dart`

Add the field to the appropriate configuration class:

```dart
final bool myFeatureEnabled;
```

Add it to the constructor and implement in the interface.

### 3. `lib/src/models/generator_arguments.dart`

Delegate to the configuration:

```dart
/// My feature
@override
bool get myFeatureEnabled => _featureConfiguration.myFeatureEnabled;
```

### 4. `lib/src/models/generator_arguments_provider.dart`

Read and pass the new argument:

```dart
final myFeatureEnabled = _reader.read<bool>(CreateCommandArguments.myFeature);
```

Then pass it when constructing the relevant configuration object.

### 5. `lib/src/models/bundle_generator.dart`

Import and conditionally include the brick bundle:

```dart
import '../templates/feature_my_feature_bundle.dart';

// In class body:
final _myFeatureBundle = featureMyFeatureBundle;

// In generate():
if (arguments.myFeatureEnabled) {
  _bundle.files.addAll(_myFeatureBundle.files);
}
```

### 6. `lib/src/commands/create_command.dart`

Add to the vars dict:

```dart
'my_mason_variable': arguments.myFeatureEnabled,
```

Add to `_usingLog`:

```dart
_usingLog('My Feature', arguments.myFeatureEnabled);
```

### 7. Platform Processors (if needed)

If the feature requires native permission declarations or configuration:

- **Android:** `lib/src/processors/android/android_manifest_processor.dart`
- **iOS permission:** `lib/src/processors/ios/info_plist_processor.dart`
- **iOS pod:** `lib/src/processors/ios/podfile_processor.dart`

### 8. Mason Brick

Create `mason_templates/bricks/feature_my_feature/__brick__/` with all template files.
Then compile:

```sh
dart run mason_cli:mason bundle -t dart -o lib/src/templates/ mason_templates/bricks/feature_my_feature
```

Add to `bin/compile_bundles.sh`:

```sh
create_mason_bundle feature_my_feature
```

### 9. `bin/generate_test_project.sh`

Add `--enable-my-feature` to the `all_enabled` config and `--no-enable-my-feature` to the `all_disabled` config.

### 10. `mason_templates/bricks/rx_bloc_base/__brick__/.cursor/rules/project-structure.mdc`

Add a conditional entry for the new directories using mason syntax. This file describes the generated project's structure to the AI agent.

## Verification

```sh
dart test
bin/generate_test_project.sh all_enabled
bin/generate_test_project.sh all_disabled
cd example/testapp && flutter pub get && flutter analyze
```
