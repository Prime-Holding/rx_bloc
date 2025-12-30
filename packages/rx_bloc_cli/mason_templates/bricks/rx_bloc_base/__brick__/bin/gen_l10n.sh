#!/bin/bash

# Merge ARB files from sources and generate localizations
echo "Merging ARB files..."
dart run bin/merge_arb_files.dart

echo ""
echo "Generating localizations..."
dart run intl_utils:generate

echo ""
echo "Done! Localizations generated successfully."
