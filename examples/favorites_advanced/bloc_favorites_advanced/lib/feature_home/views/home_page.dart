
import 'package:bloc_sample/base/ui_components/puppies_app_bar.dart';
import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PuppiesAppBar(),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildBody(),
            _buildNavBar(),
          ],
        ),
      );

  Widget _buildBody() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
      );

  BlocBuilder<NavigationBarBloc, NavigationBarState> _buildNavBar() =>
      BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) => CurvedNavigationBar(
            index: state.items.toCurrentIndex(),
            color: Colors.blueAccent,
            backgroundColor: Colors.transparent,
            items: state.items
                .map((item) => Padding(
                      child: item.asWidget(),
                      padding: const EdgeInsets.all(8),
                    ))
                .toList(),
            onTap: (index) => context.read<NavigationBarBloc>().add(
                  NavigationBarEvent(
                    index == 0
                        ? NavigationItemType.search
                        : NavigationItemType.favorites,
                  ),
                )),
      );
}

extension NavigationItemToWitget on NavigationItem {
  Widget asWidget() =>
      type == NavigationItemType.favorites ? type.asIcon() : type.asIcon();
}
