{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';
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
          ..._repositories,
          ..._services,
        ],
        child: child,
      );

  List<Provider> get _repositories => [
        Provider<LanguageRepository>(
          create: (context) =>
              LanguageRepository(context.read<SharedPreferencesInstance>()),
        ),
      ];

  List<Provider> get _services => [
        Provider<CustomLanguageService>(
          create: (context) => CustomLanguageService(
              languageRepository: context.read<LanguageRepository>()),
        ),
      ];
}
