import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonText extends StatelessWidget {
  const SkeletonText({
    @required this.text,
    @required this.height,
    Key key,
  }) : super(key: key);

  final String text;
  final double height;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _buildChild(),
      );

  Widget _buildChild() {
    return text == null
        ? SkeletonAnimation(
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[300],
              ),
            ),
          )
        : Align(
            child: Text(text ?? "", textAlign: TextAlign.left),
            alignment: Alignment.centerLeft,
          );
  }
}
