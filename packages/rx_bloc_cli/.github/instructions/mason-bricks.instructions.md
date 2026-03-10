---
applyTo: "mason_templates/**"
---

# Mason Brick Authoring — Quick Reference

## After any brick edit

```sh
bin/compile_bundles.sh
```

The `lib/src/templates/` directory is **auto-generated**. Never edit files there.

## Mustache variable names

All variables come from the vars dict in `lib/src/commands/create_command.dart`. Check that file before using any `{{variable}}` in a template.

## Conditional syntax

```mustache
{{#enable_login}}only when login is enabled{{/enable_login}}
{{^enable_login}}only when login is disabled{{/enable_login}}
{{#enable_login}}conditional_dirname{{/enable_login}}   ← directory name
```

## Partials

```dart
{{> licence.dart }}   ← licence header, use at top of every .dart file
```

## Adding a new brick to the pipeline

1. Create `mason_templates/bricks/<name>/__brick__/`
2. Run `dart run mason_cli:mason bundle -t dart -o lib/src/templates/ mason_templates/bricks/<name>`
3. Add `create_mason_bundle <name>` to `bin/compile_bundles.sh`
4. Import and wire in `lib/src/models/bundle_generator.dart`
