{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../data_sources/language_local_data_source.dart';
import '../repositories/language_repository.dart';
import '../services/custom_language_service.dart';

class ChangeLanguageWithDependencies extends StatelessWidget {
  const ChangeLanguageWithDependencies({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._dataSources,
          ..._repositories,
          ..._services,
        ],
        child: child,
      );

  List<Provider> get _dataSources => [
        Provider<LanguageLocalDataSource>(
          create: (context) => LanguageLocalDataSource(
              context.read<SharedPreferencesInstance>()),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<LanguageRepository>(
          create: (context) => LanguageRepository(
            languageLocalDataSource: context.read<LanguageLocalDataSource>(),
          ),
        ),
      ];

  List<Provider> get _services => [
        Provider<CustomLanguageService>(
          create: (context) => CustomLanguageService(
              languageRepository: context.read<LanguageRepository>()),
        ),
      ];
}
