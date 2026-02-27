import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class UnreadFilterButton extends StatelessWidget {
  const UnreadFilterButton({
    required this.unreadCount,
    required this.isActive,
    required this.onPressed,
    super.key,
  });

  final int unreadCount;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.designSystem.colors;
    final spacing = context.designSystem.spacing;

    if (unreadCount == 0 && !isActive) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.m,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? colors.filterButtonActiveColor : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.l),
          border: Border.all(
            color: isActive
                ? colors.filterButtonActiveColor
                : colors.filterButtonBorderColor,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: spacing.m,
              color: isActive
                  ? colors.filterButtonActiveTextColor
                  : colors.filterButtonTextColor,
            ),
            SizedBox(width: spacing.xs),
            Text(
              unreadCount.toString(),
              style: context.designSystem.typography.h3Med14.copyWith(
                color: isActive
                    ? colors.filterButtonActiveTextColor
                    : colors.filterButtonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
