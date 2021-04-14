import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';

class AnimatedListItem extends StatelessWidget {
  const AnimatedListItem({
    required this.animationController,
    required this.animation,
    this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: DesignSystem.of(context).colors.brightness ==
                          Brightness.light
                      ? <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(4, 4),
                            blurRadius: 16,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: this.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
