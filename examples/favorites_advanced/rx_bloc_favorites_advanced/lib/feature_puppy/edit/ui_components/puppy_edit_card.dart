import 'package:flutter/material.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/color_styles.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/text_styles.dart';

class PuppyEditCard extends StatelessWidget {
  const PuppyEditCard({
    @required this.label,
    @required this.content,
    this.icon,
    Key key,
  }) : super(key: key);

  final String label;
  final Widget content;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
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
                    label,
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
}
