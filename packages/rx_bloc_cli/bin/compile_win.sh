flutter pub run mason bundle -t dart mason_templates/bricks/rx_bloc_base
copy rx_bloc_base_bundle.dart lib\src\templates\
del rx_bloc_base_bundle.dart
#flutter pub global deactivate -s path . --overwrite
flutter pub global activate -s path . --overwrite
rx_bloc_cli create --org com.primeholding --project-name test_app --include-analytics true example/test_app
cd example/test_app
flutter pub get
copy README.md ..\
cd ../..
dartfmt -w lib