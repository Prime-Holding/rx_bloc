{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';{{#enable_change_language}}
import '../../lib_change_language/data_sources/language_local_data_source.dart';
import '../../lib_change_language/data_storages/language_picker_shared_preferences_instance.dart';
import '../../lib_change_language/services/language_service_example.dart';{{/enable_change_language}}
import '../blocs/profile_bloc.dart';
import '../views/profile_page.dart';

class ProfilePageWithDependencies extends StatelessWidget {
  const ProfilePageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [{{#enable_change_language}}
          ..._dataStorages,
          ..._dataSources,
          ..._services,{{/enable_change_language}}
          ..._blocs,
        ],
        child: const ProfilePage(),
      );
  {{#enable_change_language}}
  List<Provider> get _dataStorages => [
        Provider<LanguagePickerSharedPreferencesInstance>(
          create: (context) => LanguagePickerSharedPreferencesInstance(),
        ),
      ];

  List<Provider> get _dataSources => [
        Provider<LanguageLocalDataSource>(
          create: (context) => LanguageLocalDataSource(
            context.read(),
          ),
        ),
      ];

  List<Provider> get _services => [
        Provider<LanguageServiceExample>(
          create: (context) => LanguageServiceExample(
            localDataSource: context.read(),
          ),
        ),
      ];{{/enable_change_language}}

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<ProfileBlocType>(
          create: (context) => ProfileBloc(),
        ),
      ];
}
