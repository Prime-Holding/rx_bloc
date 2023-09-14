import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonText extends StatelessWidget {
  const SkeletonText({
    required this.text,
    required this.height,
    this.skeletons = 1,
    this.style,
    Key? key,
  }) : super(key: key);

  final String? text;
  final double height;
  final TextStyle? style;
  final int skeletons;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _buildChild(),
      );

  Widget _buildChild() {
    return text == null
        ? Column(
            children: List.generate(
              skeletons,
              (index) => Container(
                padding: skeletons > 1 ? EdgeInsets.only(bottom: 8) : null,
                child: _buildSkeleton(),
              ),
            ),
          )
        : Align(
            child: Text(
              text ?? "",
              textAlign: TextAlign.left,
              style: style,
            ),
            alignment: Alignment.centerLeft,
          );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[400]!,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
