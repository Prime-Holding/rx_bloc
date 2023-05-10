import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/profile_bloc.dart';

class ProfileDependencies {
  ProfileDependencies._(this.context);

  factory ProfileDependencies.from(BuildContext context) =>
      ProfileDependencies._(context);

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._repositories,
    ..._blocs,
  ];

  late final List<Provider> _repositories = [];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<ProfileBlocType>(
      create: (context) => ProfileBloc(),
    ),
  ];
}