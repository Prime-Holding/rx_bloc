import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/color_styles.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/text_styles.dart';
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
    final pup = widget._puppy;
    _nameTextFieldController = TextEditingController(text: pup.name);
    _characteristicsTextFieldController =
        TextEditingController(text: pup.breedCharacteristics);
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
              RxBlocProvider.of<PuppyEditBlocType>(ctx)
                  .events
                  .setEditingPuppy(foundPuppy);
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
        child: RxBlocBuilder<PuppyEditBlocType, bool>(
          state: (bloc) => bloc.states.isSaveEnabled,
          builder: (context, saveEnabled, editBloc) => Scaffold(
            appBar: PuppyEditAppBar(
              enabled: saveEnabled?.data ?? false,
              onSavePressed: () => editBloc.events.updatePuppy(),
            ),
            body: SafeArea(
              key: const ValueKey('PuppyEditPage'),
              child: SingleChildScrollView(child: _buildBody(puppy)),
            ),
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
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildAvatar(puppy),
                const SizedBox(height: 20),
                _buildRow(
                  'Name',
                  _buildNameInputField(),
                  icon: Icons.account_box,
                ),
                _buildRow(
                  'Breed',
                  _buildBreedSelection(),
                  icon: Icons.pets,
                ),
                _buildRow(
                  'Gender',
                  _buildGenderSelection(),
                  icon: Icons.wc,
                ),
                _buildRow(
                  'Characteristics',
                  _buildCharacteristicsInputField(),
                  icon: Icons.article,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildAvatar(Puppy puppy) => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Hero(
            tag: '$PuppyCardAnimationTag ${puppy.id}',
            child: RxBlocBuilder<PuppyEditBlocType, String>(
              bloc: RxBlocProvider.of(context),
              state: (bloc) => bloc.states.pickedImagePath,
              builder: (_, imagePath, __) => Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: PuppyAvatar(
                        asset: imagePath?.data ?? widget._puppy.asset,
                        radius: 128,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 1,
            bottom: 1,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    ),
                    onTap: () {
                      PhotoPickerActionSelectionBottomSheet
                          .presentPhotosBottomSheet(
                        context,
                        (source) =>
                            RxBlocProvider.of<PuppyEditBlocType>(context)
                                .events
                                .pickImage(source),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildRow(String rowName, Widget content, {IconData icon}) => Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      size: 18,
                      color: ColorStyles.textColor,
                    ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    rowName,
                    style: TextStyles.title2TextStyleBlack,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              const Divider(
                thickness: 1,
                height: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              if (content != null) content,
            ],
          ),
        ),
      );

  // Column(
  //   children: [
  //     if (inline)
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(rowName),
  //           if (content != null) content,
  //         ],
  //       ),
  //     if (!inline) ...[
  //       Text(rowName),
  //       if (content != null) content,
  //     ],
  //     const SizedBox(height: 15),
  //   ],
  // );

  Widget _buildNameInputField() => RxBlocBuilder<PuppyEditBlocType, String>(
        state: (bloc) => bloc.states.nameError,
        builder: (_, nameErrorState, __) => TextField(
          key: const ValueKey('PuppyNameInputField'),
          style: TextStyles.editableTextStyle,
          maxLines: 1,
          maxLengthEnforced: true,
          controller: _nameTextFieldController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            enabledBorder: _defaultInputFieldBorder,
            border: _defaultInputFieldBorder,
            errorText: nameErrorState?.data,
          ),
          onChanged:
              RxBlocProvider.of<PuppyEditBlocType>(context).events.updateName,
        ),
      );

  Widget _buildBreedSelection() => Center(
        child: RxBlocBuilder<PuppyEditBlocType, BreedTypes>(
          state: (bloc) => bloc.states.selectedBreed,
          builder: (context, breedState, editBloc) =>
              DropdownButton<BreedTypes>(
            key: const ValueKey('PuppyBreedTypeDropDown'),
            value: breedState?.data ?? widget._puppy.breedType,
            onChanged: editBloc.events.updateBreed,
            items: BreedTypes.values
                .map(
                  (breedType) => DropdownMenuItem<BreedTypes>(
                    value: breedType,
                    child: Text(
                      PuppyDataConversion.getBreedTypeString(breedType),
                      style: TextStyles.editableTextStyle,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );

  Widget _buildGenderSelection() => RxBlocBuilder<PuppyEditBlocType, Gender>(
        state: (bloc) => bloc.states.selectedGender,
        builder: (_, genderState, editBloc) {
          final selectedGender = genderState?.data ?? widget._puppy.gender;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Text(
                    'Male',
                    style: TextStyles.editableTextStyle,
                  ),
                  Radio<Gender>(
                    key: const ValueKey('PuppyGenderMaleRadio'),
                    value: Gender.Male,
                    groupValue: selectedGender,
                    onChanged: editBloc.events.updateGender,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Female',
                    style: TextStyles.editableTextStyle,
                  ),
                  Radio<Gender>(
                    key: const ValueKey('PuppyGenderFemaleRadio'),
                    value: Gender.Female,
                    groupValue: selectedGender,
                    onChanged: editBloc.events.updateGender,
                  ),
                ],
              ),
            ],
          );
        },
      );

  Widget _buildCharacteristicsInputField() => Container(
        height: 220,
        child: RxBlocBuilder<PuppyEditBlocType, String>(
          state: (bloc) => bloc.states.characteristicsError,
          builder: (_, detailsErrorState, __) => TextField(
            key: const ValueKey('PuppyCharacteristicsInputField'),
            style: TextStyles.editableTextStyle,
            textInputAction: TextInputAction.done,
            maxLines: 8,
            controller: _characteristicsTextFieldController,
            decoration: InputDecoration(
              enabledBorder: _defaultInputFieldBorder,
              border: _defaultInputFieldBorder,
              errorText: detailsErrorState?.data,
            ),
            onChanged: RxBlocProvider.of<PuppyEditBlocType>(context)
                .events
                .updateCharacteristics,
          ),
        ),
      );

  /// endregion
}
