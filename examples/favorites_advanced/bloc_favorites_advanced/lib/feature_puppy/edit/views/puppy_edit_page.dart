import 'package:bloc_sample/feature_puppy/blocs/puppy_mark_as_favorite_bloc.dart';
import 'package:bloc_sample/feature_puppy/edit/bloc/puppy_edit_form_bloc.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_app_bar.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_form.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

part 'puppy_edit_providers.dart';

class PuppyEditPage extends StatefulWidget {
  const PuppyEditPage({
    required Puppy puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  static Page page({required Puppy puppy}) => MaterialPage(
          child: MultiBlocProvider(
        providers: _getProviders(puppy),
        child: PuppyEditPage(puppy: puppy),
      ));

  final Puppy _puppy;

  @override
  _PuppyEditPageState createState() => _PuppyEditPageState();
}

class _PuppyEditPageState extends State<PuppyEditPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => PuppyEditFormBloc(
          coordinatorBloc: context.read(),
            repository: context.read(),
            puppy: widget._puppy),
        // child: BlocListener<PuppyEditFormBloc, FormBlocState>(
        child: FormBlocListener<PuppyEditFormBloc, String, String>(
          onSuccess: (context, state){
              ScaffoldMessenger.of(context)
                  .showSnackBar( SnackBar(content:
              Text(state.successResponse!)));
          },
          child: Builder(
            builder: (context) {
              final puppyEditFormBloc =
                  BlocProvider.of<PuppyEditFormBloc>(context);
              // print(puppyEditFormBloc.name);
              // return BlocBuilder<PuppyEditFormBloc, FormBlocState>(
              //     builder: (context, state) {
              //   print('puppy_edit_page state: ${state.runtimeType}');
                return StreamBuilder<bool>(
                  stream: puppyEditFormBloc.isFormValid$,
                  builder: (context, snapshot) => WillPopScope(
                      onWillPop: () =>
                      // snapshot.data == false ?
                      // state is FormBlocLoading
                      //      Future.value(false)
                           Future.value(true),
                      child: Scaffold(
                        appBar: PuppyEditAppBar(
                          // enabled:state is FormUpdatingFields ? true: false,
                          // enabled: state is FormBlocUpdatingFields ?
                          // true : false,
                          enabled: snapshot.data == true ? true : false,
                          // enabled: true,

                          // enabled: false,
                          // onSavePressed: () =>
                          //   puppyEditFormBloc.submit
                          // ,
                          puppyEditFormBloc: puppyEditFormBloc,
                          // onSavePressed: () => {},
                        ),
                        body: PuppyEditForm(
                          puppy: widget._puppy,
                          puppyEditFormBloc: puppyEditFormBloc,
                        ),
                      ),
                    )
                );
              // });
            },
          ),
        ),
      );
}
