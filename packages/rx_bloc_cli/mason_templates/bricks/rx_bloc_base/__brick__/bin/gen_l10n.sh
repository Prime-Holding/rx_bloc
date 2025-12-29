#!/bin/bash

# Merge ARB files from sources and generate localizations
echo "Merging ARB files..."
dart run bin/merge_arb_files.dart

echo ""
echo "Generating localizations..."
flutter gen-l10n

echo ""
echo "Generating remote translations wrapper..."
dart run bin/generate_remote_wrapper.dart

echo ""
echo "Done! Localizations generated successfully."
