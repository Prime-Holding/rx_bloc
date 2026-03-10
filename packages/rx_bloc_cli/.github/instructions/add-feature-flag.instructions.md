---
applyTo: "lib/src/**/*.dart"
---

# Adding a Feature Flag — Step-by-Step

When asked to add a new feature flag to rx_bloc_cli, follow this exact sequence. Do not skip steps or reorder them.

## Required files to touch (in order)

1. **`lib/src/models/command_arguments/create_command_arguments.dart`**
   Add an enum case with `name`, `type` (`CreateCommandArgumentType.boolean`), `defaultsTo`, `prompt`, and `help`.

2. **`lib/src/models/configurations/<group>_configuration.dart`**
   Add the `bool` field. Choose `FeatureConfiguration` for UI features, `AuthConfiguration` for auth, `ShowcaseConfiguration` for showcase demos, `ProjectConfiguration` for project-level settings.

3. **`lib/src/models/generator_arguments.dart`**
   Add a getter that delegates to the configuration: `bool get myFeatureEnabled => _featureConfiguration.myFeatureEnabled;`

4. **`lib/src/models/generator_arguments_provider.dart`**
   Read the argument and pass it to the configuration constructor.

5. **`lib/src/models/bundle_generator.dart`**
   Import the new bundle and conditionally add its files inside `generate()`.

6. **`lib/src/commands/create_command.dart`**
   Add the mason variable to the vars dict and add a `_usingLog(...)` call.

7. **Processors** (`lib/src/processors/android/`, `ios/`, `cicd/`, `ide/`)
   Only if the feature requires changes to native platform files.

8. **`bin/compile_bundles.sh`**
   Add: `create_mason_bundle <brick_name>`

9. **`bin/generate_test_project.sh`**
   Add `--enable-my-feature` to `all_enabled`, `--no-enable-my-feature` to `all_disabled`.

10. **`mason_templates/bricks/rx_bloc_base/__brick__/.cursor/rules/project-structure.mdc`**
    Add conditional entries for new directories using mason syntax `{{#flag}}...{{/flag}}`.

## Never do

- Edit any file under `lib/src/templates/` — they are auto-generated.
- Add feature-specific files directly to the `rx_bloc_base` brick — use a dedicated feature brick.
- Use a mason variable in a template that isn't present in the vars dict in `create_command.dart`.
