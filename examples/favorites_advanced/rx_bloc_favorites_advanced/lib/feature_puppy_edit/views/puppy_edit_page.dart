import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/blocs/puppy_manage_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy_edit/blocs/puppy_edit_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy_edit/ui_components/puppy_edit_app_bar.dart';

part 'puppy_edit_providers.dart';

class PuppyEditPage extends StatefulWidget with AutoRouteWrapper {
  const PuppyEditPage({
    @required Puppy puppy,
    Key key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy _puppy;

  @override
  Widget wrappedRoute(BuildContext context) => RxMultiBlocProvider(
        providers: _getProviders(),
        child: this,
      );

  @override
  _PuppyEditPageState createState() => _PuppyEditPageState();
}

class _PuppyEditPageState extends State<PuppyEditPage> {
  final _characteristicsMaxLength = 250;

  Puppy _editedPuppy;
  TextEditingController _nameTextFieldController;
  TextEditingController _characteristicsTextFieldController;

  InputBorder get _defaultInputFieldBorder => const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
        ),
      );

  /// region Lifecycle events

  @override
  void initState() {
    super.initState();
    _editedPuppy = widget._puppy;
    _nameTextFieldController = TextEditingController(text: _editedPuppy.name);
    _characteristicsTextFieldController =
        TextEditingController(text: _editedPuppy.breedCharacteristics);
  }

  @override
  Widget build(BuildContext context) => RxBlocBuilder<PuppyEditBlocType, bool>(
        state: (bloc) => bloc.states.processingUpdate,
        builder: (context, isProcessingUpdate, _) => WillPopScope(
          onWillPop: () => Future.value(!(isProcessingUpdate?.data ?? false)),
          child: RxResultBuilder<PuppyListBlocType, List<Puppy>>(
            state: (bloc) => bloc.states.searchedPuppies,
            buildLoading: (ctx, bloc) => _buildScaffoldBody(ctx, widget._puppy),
            buildError: (ctx, error, bloc) {
              Future.delayed(
                  const Duration(microseconds: 10),
                  () => RxBlocProvider.of<PuppyListBlocType>(ctx)
                      .events
                      .reloadFavoritePuppies(silently: false));
              return _buildScaffoldBody(context, widget._puppy);
            },
            buildSuccess: (ctx, puppyList, _) {
              final foundPuppy = ((puppyList?.isNotEmpty ?? false)
                      ? puppyList?.firstWhere(
                          (element) => element.id == widget._puppy.id)
                      : null) ??
                  widget._puppy;
              return _buildScaffoldBody(context, foundPuppy);
            },
          ),
        ),
      );

  /// endregion

  /// region Builders

  Widget _buildScaffoldBody(BuildContext context, Puppy puppy) =>
      GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: PuppyEditAppBar(
            enabled: widget._puppy != _editedPuppy,
            onSavePressed: () => RxBlocProvider.of<PuppyEditBlocType>(context)
                .events
                .updatePuppy(_editedPuppy, widget._puppy),
          ),
          body: SafeArea(
            key: const ValueKey('PuppyEditPage'),
            child: SingleChildScrollView(child: _buildBody(puppy)),
          ),
        ),
      );

  Widget _buildBody(Puppy puppy) => RxBlocListener<PuppyEditBlocType, String>(
        state: (bloc) => bloc.states.updateError,
        listener: (context, errorMessage) {
          if (errorMessage == null) return;
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
        },
        child: RxBlocListener<PuppyEditBlocType, bool>(
          state: (bloc) => bloc.states.successfulUpdate,
          listener: (context, successfulUpdate) {
            if (successfulUpdate) ExtendedNavigator.root.pop(true);
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 27, right: 27),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: '$PuppyCardAnimationTag ${puppy.id}',
                      child: CircleAvatar(
                        backgroundImage: AssetImage(puppy.asset),
                        radius: 48,
                      ),
                    ),
                    const SizedBox(width: 20),
                    OutlineButton(
                      onPressed: () {
                        /// TODO: Change picture of puppy
                        debugPrint('"Change puppy picture" button pressed');
                      },
                      child: const Text('Change picture'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildRow('Name', _buildNameInputField()),
                _buildRow('Breed', _buildBreedSelection()),
                _buildRow('Gender', _buildGenderSelection()),
                _buildRow('Characteristics', _buildCharacteristicsInputField(),
                    false),
              ],
            ),
          ),
        ),
      );

  Widget _buildRow(String rowName, Widget content, [bool inline = true]) =>
      Column(
        children: [
          if (inline)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(rowName),
                if (content != null) content,
              ],
            ),
          if (!inline) ...[
            Text(rowName),
            if (content != null) content,
          ],
          const SizedBox(height: 15),
        ],
      );

  Widget _buildNameInputField() => Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextField(
            key: const ValueKey('PuppyNameInputField'),
            maxLines: 1,
            maxLength: 50,
            maxLengthEnforced: true,
            controller: _nameTextFieldController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: _defaultInputFieldBorder,
              border: _defaultInputFieldBorder,
            ),
            onChanged: _onNameChanged,
          ),
        ),
      );

  Widget _buildBreedSelection() => DropdownButton<BreedTypes>(
        key: const ValueKey('PuppyBreedTypeDropDown'),
        value: _editedPuppy.breedType,
        onChanged: _onBreedChanged,
        items: BreedTypes.values
            .map((breedType) => DropdownMenuItem<BreedTypes>(
                  value: breedType,
                  child:
                      Text(PuppyDataConversion.getBreedTypeString(breedType)),
                ))
            .toList(),
      );

  Widget _buildGenderSelection() => Row(
        children: [
          const Text('Male'),
          Radio<Gender>(
            key: const ValueKey('PuppyGenderMaleRadio'),
            value: Gender.Male,
            groupValue: _editedPuppy.gender,
            onChanged: _onGenderChanged,
          ),
          const Text('Female'),
          Radio<Gender>(
            key: const ValueKey('PuppyGenderFemaleRadio'),
            value: Gender.Female,
            groupValue: _editedPuppy.gender,
            onChanged: _onGenderChanged,
          ),
        ],
      );

  Widget _buildCharacteristicsInputField() => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          height: 220,
          child: TextField(
            key: const ValueKey('PuppyCharacteristicsInputField'),
            textInputAction: TextInputAction.done,
            maxLines: 8,
            maxLength: _characteristicsMaxLength,
            controller: _characteristicsTextFieldController,
            decoration: InputDecoration(
              enabledBorder: _defaultInputFieldBorder,
              border: _defaultInputFieldBorder,
            ),
            onChanged: _onCharacteristicsChanged,
          ),
        ),
      );

  /// endregion

  /// region Methods

  void _onNameChanged(String newName) {
    setState(() {
      _editedPuppy = _editedPuppy.copyWith(name: newName);
    });
  }

  void _onBreedChanged(BreedTypes newBreedType) {
    setState(() {
      _editedPuppy = _editedPuppy.copyWith(breedType: newBreedType);
    });
  }

  void _onGenderChanged(Gender newGender) {
    setState(() {
      _editedPuppy = _editedPuppy.copyWith(gender: newGender);
    });
  }

  void _onCharacteristicsChanged(String newCharacteristics) {
    setState(() {
      _editedPuppy =
          _editedPuppy.copyWith(breedCharacteristics: newCharacteristics);
    });
  }

  /// endregion
}
