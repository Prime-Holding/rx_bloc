{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data_sources/language_local_data_source.dart';
import '../data_storages/language_picker_shared_preferences_instance.dart';
import '../services/language_service_example.dart';

class ChangeLanguageWithDependencies extends StatelessWidget {
  const ChangeLanguageWithDependencies({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._dataStorage,
          ..._dataSource,
          ..._services,
        ],
        child: child,
      );

  List<Provider> get _dataStorage => [
        Provider<LanguagePickerSharedPreferencesInstance>(
          create: (context) => LanguagePickerSharedPreferencesInstance(),
        ),
      ];

  List<Provider> get _dataSource => [
        Provider<LanguageLocalDataSource>(
          create: (context) => LanguageLocalDataSource(
              context.read<LanguagePickerSharedPreferencesInstance>()),
        ),
      ];

  List<Provider> get _services => [
        Provider<LanguageServiceExample>(
          create: (context) => LanguageServiceExample(
              localDataSource: context.read<LanguageLocalDataSource>()),
        ),
      ];
}
