{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';{{#enable_internationalisation}}
import '../../lib_internationalisation/data_sources/language_local_data_source.dart';
import '../../lib_internationalisation/data_storages/language_picker_shared_preferences_instance.dart';
import '../../lib_internationalisation/services/language_service_example.dart';{{/enable_internationalisation}}
import '../blocs/profile_bloc.dart';
import '../views/profile_page.dart';

class ProfilePageWithDependencies extends StatelessWidget {
  const ProfilePageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [{{#enable_internationalisation}}
          ..._dataStorages,
          ..._dataSources,
          ..._services,{{/enable_internationalisation}}
          ..._blocs,
        ],
        child: const ProfilePage(),
      );
  {{#enable_internationalisation}}
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
      ];{{/enable_internationalisation}}

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<ProfileBlocType>(
          create: (context) => ProfileBloc(),
        ),
      ];
}
