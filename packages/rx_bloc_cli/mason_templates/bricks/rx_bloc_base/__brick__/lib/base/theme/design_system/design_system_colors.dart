{{> licence.dart }}

import 'package:flutter/material.dart';
// Material Design System: https://m2.material.io/design/color/the-color-system.html

@immutable
class DesignSystemColors {
  const DesignSystemColors.light()
      : brightness = Brightness.light,
        colorScheme = const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFFEAE2E),
          surfaceTint: Color(0xFFFEAE2E),
          onPrimary: Color(0xFF0C0917),
          primaryContainer: Color(0xFFDAD8E3),
          onPrimaryContainer: Color(0xFF302936),
          secondary: Color(0xFF958CBE),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFDAD8E3),
          onSecondaryContainer: Color(0xFF302936),
          tertiary: Color(0xFF59586E),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFF2F3F9),
          onTertiaryContainer: Color(0xFF302936),
          error: Color(0xFFBA1A1A),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
          surface: Color(0xFFF8FAFF),
          onSurface: Color(0xFF0C0917),
          onSurfaceVariant: Color(0xFF606C83),
          outline: Color(0xFF59586E),
          outlineVariant: Color(0xFFDAD8E3),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0C0917),
          inversePrimary: Color(0xFFFEAE2E),
          primaryFixed: Color(0xFFFFE3B4),
          onPrimaryFixed: Color(0xFF0C0917),
          primaryFixedDim: Color(0xFFFEAE2E),
          onPrimaryFixedVariant: Color(0xFF302936),
          secondaryFixed: Color(0xFFDAD8E3),
          onSecondaryFixed: Color(0xFF302936),
          secondaryFixedDim: Color(0xFF958CBE),
          onSecondaryFixedVariant: Color(0xFF302936),
          tertiaryFixed: Color(0xFFF2F3F9),
          onTertiaryFixed: Color(0xFF302936),
          tertiaryFixedDim: Color(0xFFDAD8E3),
          onTertiaryFixedVariant: Color(0xFF59586E),
          surfaceDim: Color(0xFFF2F3F9),
          surfaceBright: Color(0xFFFFFFFF),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF8FAFF),
          surfaceContainer: Color(0xFFF2F3F9),
          surfaceContainerHigh: Color(0xFFDAD8E3),
          surfaceContainerHighest: Color(0xFFDAD8E3),
        ),
        appleBackground = const Color(0xFF000000),
        googleBackground = const Color(0xFFFFFFFF),
        facebookBackground = const Color(0xFF1877F2);

  const DesignSystemColors.dark()
      : brightness = Brightness.dark,
        colorScheme = const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFEAE2E),
          surfaceTint: Color(0xFFFEAE2E),
          onPrimary: Color(0xFF0C0917),
          primaryContainer: Color(0xFF302936),
          onPrimaryContainer: Color(0xFFDAD8E3),
          secondary: Color(0xFF958CBE),
          onSecondary: Color(0xFF0C0917),
          secondaryContainer: Color(0xFF59586E),
          onSecondaryContainer: Color(0xFFF8FAFF),
          tertiary: Color(0xFFDAD8E3),
          onTertiary: Color(0xFF302936),
          tertiaryContainer: Color(0xFF59586E),
          onTertiaryContainer: Color(0xFFF8FAFF),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          errorContainer: Color(0xFF93000A),
          onErrorContainer: Color(0xFFFFDAD6),
          surface: Color(0xFF0C0917),
          onSurface: Color(0xFFF8FAFF),
          onSurfaceVariant: Color(0xFFDAD8E3),
          outline: Color(0xFF958CBE),
          outlineVariant: Color(0xFF59586E),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFF8FAFF),
          inversePrimary: Color(0xFF302936),
          primaryFixed: Color(0xFFFFE3B4),
          onPrimaryFixed: Color(0xFF0C0917),
          primaryFixedDim: Color(0xFFFEAE2E),
          onPrimaryFixedVariant: Color(0xFF302936),
          secondaryFixed: Color(0xFFDAD8E3),
          onSecondaryFixed: Color(0xFF302936),
          secondaryFixedDim: Color(0xFF958CBE),
          onSecondaryFixedVariant: Color(0xFF302936),
          tertiaryFixed: Color(0xFFDAD8E3),
          onTertiaryFixed: Color(0xFF302936),
          tertiaryFixedDim: Color(0xFF59586E),
          onTertiaryFixedVariant: Color(0xFFF2F3F9),
          surfaceDim: Color(0xFF0C0917),
          surfaceBright: Color(0xFF302936),
          surfaceContainerLowest: Color(0xFF0C0917),
          surfaceContainerLow: Color(0xFF201A2B),
          surfaceContainer: Color(0xFF302936),
          surfaceContainerHigh: Color(0xFF444159),
          surfaceContainerHighest: Color(0xFF59586E),
        ),
        appleBackground = const Color(0xFFFFFFFF),
        googleBackground = const Color(0xFF0C0917),
        facebookBackground = const Color(0xFF1877F2);

  final Brightness brightness;
  final ColorScheme colorScheme;

  final Color appleBackground;
  final Color googleBackground;
  final Color facebookBackground;
  final Color anchorBlue = const Color(0xFF0C0917);
  final Color assertionYellow = const Color(0xFFFEAE2E);
}
