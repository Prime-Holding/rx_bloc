import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../blocs/puppies_extra_details_bloc.dart';
import '../../blocs/puppy_manage_bloc.dart';
import '../blocs/puppy_details_bloc.dart';
import '../ui_components/puppy_details.dart';

part 'puppy_details_providers.dart';

class PuppyDetailsPage extends StatelessWidget {
  const PuppyDetailsPage({
    required Puppy puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  static Page page({required Puppy puppy}) => MaterialPage(
        child: RxMultiBlocProvider(
          providers: _getProviders(puppy),
          child: PuppyDetailsPage(puppy: puppy),
        ),
      );

  final Puppy _puppy;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PuppyDetails(
          puppy: _puppy,
        ),
      );
}
