---
description: Create a new mason brick for rx_bloc_cli — brick.yaml, template files, Mustache syntax conventions, compilation, and wiring into BundleGenerator
---

# Create a New Mason Brick

This skill guides authoring a new mason brick and integrating it into the `rx_bloc_cli` generation pipeline.

## Inputs Required

1. **Brick name** — snake_case (e.g., `feature_notifications`, `lib_push`)
2. **What it generates** — feature directories, lib directories, or base modifications
3. **Which flags it responds to** — both the mason variable names it uses internally and which `GeneratorArguments` field enables it
4. **Any platform requirements** — native permissions, pods, gradle dependencies

## Step 1 — Create the Brick Directory

```sh
mkdir -p mason_templates/bricks/<brick_name>/__brick__
```

Create `mason_templates/bricks/<brick_name>/brick.yaml`:

```yaml
name: <brick_name>
description: <Short description>
version: 0.1.0+1
environment:
  mason: ">=0.1.0-dev.49 <0.1.0"
vars:
  # only declare vars the brick directly uses; project-level vars are injected by the CLI
```

> Most bricks declare no vars in `brick.yaml` because all variables are injected at runtime by the CLI. Only declare vars here if the brick is used standalone.

## Step 2 — Create Template Files

Place all template files under `__brick__/`. Follow these rules:

### Directory naming
- Always-present directories: use normal names.
- Conditionally-present: use `{{#flag}}dirname{{/flag}}` as the literal directory name.

### File layout convention — mirror the generated project structure

```
__brick__/
  lib/
    <feature_or_lib_name>/
      blocs/
      di/
      services/
      views/
    l10n/
      sources/
  test/
    <feature_or_lib_name>/
```

### Mustache inside files

```dart
{{> licence.dart }}    ← always include the licence partial at the top

{{#enable_login}}
import '../../feature_login/blocs/login_bloc.dart';
{{/enable_login}}
```

### Conditional file rendering

For a file that should only exist when a flag is true, either:
- Place it in a conditionally-named directory, or
- Use `{{#flag}}` guards for the entire file content with a trivial outer `{{^flag}}{{/flag}}` to make the file empty otherwise.

## Step 3 — Compile the Brick

```sh
dart run mason_cli:mason bundle -t dart -o lib/src/templates/ mason_templates/bricks/<brick_name>
```

This produces `lib/src/templates/<brick_name>_bundle.dart`. **Never edit this file manually.**

Add the compile step to `bin/compile_bundles.sh`:

```sh
create_mason_bundle <brick_name>
```

## Step 4 — Wire Into BundleGenerator

In `lib/src/models/bundle_generator.dart`:

```dart
import '../templates/<brick_name>_bundle.dart';

// In class body:
final _myBrickBundle = myBrickBundle;

// In generate():
if (arguments.myFeatureEnabled) {
  _bundle.files.addAll(_myBrickBundle.files);
}
```

> If the brick should always be merged (like `lib_router`), call it unconditionally.

## Step 5 — Ensure the Feature Flag Exists

The brick is useless without a way to enable it. Follow the [Add a New Feature Flag](../add_feature_flag/SKILL.md) skill if the flag doesn't already exist.

## Step 6 — Test

```sh
# Recompile all bundles
bin/compile_bundles.sh

# Run unit tests
dart test

# Check generated project
bin/generate_test_project.sh all_enabled example/testapp
cd example/testapp && flutter pub get && flutter analyze lib
```

## Common Pitfalls

- **Forgetting to recompile** after editing a brick — the CLI always uses the compiled bundle, never the raw source.
- **Adding feature code to `rx_bloc_base`** — feature-specific files belong in their own brick, not the base.
- **Referencing a mason variable not in the vars dict** — if a template uses `{{#my_var}}` but `my_var` is not passed in `CreateCommand`'s vars dict, it silently evaluates to false.
- **Missing `{{> licence.dart }}`** at the top of generated Dart files.
