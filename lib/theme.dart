import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4281363010),
      surfaceTint: Color(4281363010),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289982911),
      onPrimaryContainer: Color(4278198540),
      secondary: Color(4281428546),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4289982910),
      onSecondaryContainer: Color(4278198540),
      tertiary: Color(4278216820),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288606205),
      onTertiaryContainer: Color(4278198052),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294376435),
      onBackground: Color(4279770392),
      surface: Color(4294310651),
      onSurface: Color(4279704862),
      surfaceVariant: Color(4292601062),
      onSurfaceVariant: Color(4282337354),
      outline: Color(4285495674),
      outlineVariant: Color(4290758858),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inverseOnSurface: Color(4293718771),
      inversePrimary: Color(4288206244),
      primaryFixed: Color(4289982911),
      onPrimaryFixed: Color(4278198540),
      primaryFixedDim: Color(4288206244),
      onPrimaryFixedVariant: Color(4279587116),
      secondaryFixed: Color(4289982910),
      onSecondaryFixed: Color(4278198540),
      secondaryFixedDim: Color(4288206244),
      onSecondaryFixedVariant: Color(4279652652),
      tertiaryFixed: Color(4288606205),
      onTertiaryFixed: Color(4278198052),
      tertiaryFixedDim: Color(4286764000),
      onTertiaryFixedVariant: Color(4278210392),
      surfaceDim: Color(4292205532),
      surfaceBright: Color(4294310651),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916150),
      surfaceContainer: Color(4293521392),
      surfaceContainerHigh: Color(4293126634),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4279258408),
      surfaceTint: Color(4281363010),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282875991),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279323944),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282875990),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278209107),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280647820),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294376435),
      onBackground: Color(4279770392),
      surface: Color(4294310651),
      onSurface: Color(4279704862),
      surfaceVariant: Color(4292601062),
      onSurfaceVariant: Color(4282074182),
      outline: Color(4283916642),
      outlineVariant: Color(4285758590),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inverseOnSurface: Color(4293718771),
      inversePrimary: Color(4288206244),
      primaryFixed: Color(4282875991),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281231168),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282875990),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281231168),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280647820),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278216305),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205532),
      surfaceBright: Color(4294310651),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916150),
      surfaceContainer: Color(4293521392),
      surfaceContainerHigh: Color(4293126634),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278200593),
      surfaceTint: Color(4281363010),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4279258408),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278200592),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4279323944),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200108),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4278209107),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294376435),
      onBackground: Color(4279770392),
      surface: Color(4294310651),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292601062),
      onSurfaceVariant: Color(4280034599),
      outline: Color(4282074182),
      outlineVariant: Color(4282074182),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4290575304),
      primaryFixed: Color(4279258408),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278203671),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4279323944),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278203671),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4278209107),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278202936),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205532),
      surfaceBright: Color(4294310651),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916150),
      surfaceContainer: Color(4293521392),
      surfaceContainerHigh: Color(4293126634),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4288206244),
      surfaceTint: Color(4288206244),
      onPrimary: Color(4278204698),
      primaryContainer: Color(4279587116),
      onPrimaryContainer: Color(4289982911),
      secondary: Color(4288206244),
      onSecondary: Color(4278204697),
      secondaryContainer: Color(4279652652),
      onSecondaryContainer: Color(4289982910),
      tertiary: Color(4286764000),
      onTertiary: Color(4278203965),
      tertiaryContainer: Color(4278210392),
      onTertiaryContainer: Color(4288606205),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279244048),
      onBackground: Color(4292863196),
      surface: Color(4279112725),
      onSurface: Color(4292797413),
      surfaceVariant: Color(4282337354),
      onSurfaceVariant: Color(4290758858),
      outline: Color(4287206036),
      outlineVariant: Color(4282337354),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inverseOnSurface: Color(4281020723),
      inversePrimary: Color(4281363010),
      primaryFixed: Color(4289982911),
      onPrimaryFixed: Color(4278198540),
      primaryFixedDim: Color(4288206244),
      onPrimaryFixedVariant: Color(4279587116),
      secondaryFixed: Color(4289982910),
      onSecondaryFixed: Color(4278198540),
      secondaryFixedDim: Color(4288206244),
      onSecondaryFixedVariant: Color(4279652652),
      tertiaryFixed: Color(4288606205),
      onTertiaryFixed: Color(4278198052),
      tertiaryFixedDim: Color(4286764000),
      onTertiaryFixedVariant: Color(4278210392),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612859),
      surfaceContainerLowest: Color(4278783760),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625964),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4288469416),
      surfaceTint: Color(4288206244),
      onPrimary: Color(4278197001),
      primaryContainer: Color(4284718449),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4288469416),
      onSecondary: Color(4278197001),
      secondaryContainer: Color(4284718449),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4287027173),
      onTertiary: Color(4278196765),
      tertiaryContainer: Color(4283014313),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279244048),
      onBackground: Color(4292863196),
      surface: Color(4279112725),
      onSurface: Color(4294376701),
      surfaceVariant: Color(4282337354),
      onSurfaceVariant: Color(4291022030),
      outline: Color(4288390566),
      outlineVariant: Color(4286285191),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inverseOnSurface: Color(4280625964),
      inversePrimary: Color(4279718445),
      primaryFixed: Color(4289982911),
      onPrimaryFixed: Color(4278195462),
      primaryFixedDim: Color(4288206244),
      onPrimaryFixedVariant: Color(4278206237),
      secondaryFixed: Color(4289982910),
      onSecondaryFixed: Color(4278195462),
      secondaryFixedDim: Color(4288206244),
      onSecondaryFixedVariant: Color(4278206237),
      tertiaryFixed: Color(4288606205),
      onTertiaryFixed: Color(4278195223),
      tertiaryFixedDim: Color(4286764000),
      onTertiaryFixedVariant: Color(4278205508),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612859),
      surfaceContainerLowest: Color(4278783760),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625964),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4293918702),
      surfaceTint: Color(4288206244),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4288469416),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293918702),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4288469416),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294049279),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4287027173),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279244048),
      onBackground: Color(4292863196),
      surface: Color(4279112725),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282337354),
      onSurfaceVariant: Color(4294180094),
      outline: Color(4291022030),
      outlineVariant: Color(4291022030),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4278202902),
      primaryFixed: Color(4290246339),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4288469416),
      onPrimaryFixedVariant: Color(4278197001),
      secondaryFixed: Color(4290246083),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4288469416),
      onSecondaryFixedVariant: Color(4278197001),
      tertiaryFixed: Color(4289393663),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4287027173),
      onTertiaryFixedVariant: Color(4278196765),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612859),
      surfaceContainerLowest: Color(4278783760),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625964),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary, 
    required this.surfaceTint, 
    required this.onPrimary, 
    required this.primaryContainer, 
    required this.onPrimaryContainer, 
    required this.secondary, 
    required this.onSecondary, 
    required this.secondaryContainer, 
    required this.onSecondaryContainer, 
    required this.tertiary, 
    required this.onTertiary, 
    required this.tertiaryContainer, 
    required this.onTertiaryContainer, 
    required this.error, 
    required this.onError, 
    required this.errorContainer, 
    required this.onErrorContainer, 
    required this.background, 
    required this.onBackground, 
    required this.surface, 
    required this.onSurface, 
    required this.surfaceVariant, 
    required this.onSurfaceVariant, 
    required this.outline, 
    required this.outlineVariant, 
    required this.shadow, 
    required this.scrim, 
    required this.inverseSurface, 
    required this.inverseOnSurface, 
    required this.inversePrimary, 
    required this.primaryFixed, 
    required this.onPrimaryFixed, 
    required this.primaryFixedDim, 
    required this.onPrimaryFixedVariant, 
    required this.secondaryFixed, 
    required this.onSecondaryFixed, 
    required this.secondaryFixedDim, 
    required this.onSecondaryFixedVariant, 
    required this.tertiaryFixed, 
    required this.onTertiaryFixed, 
    required this.tertiaryFixedDim, 
    required this.onTertiaryFixedVariant, 
    required this.surfaceDim, 
    required this.surfaceBright, 
    required this.surfaceContainerLowest, 
    required this.surfaceContainerLow, 
    required this.surfaceContainer, 
    required this.surfaceContainerHigh, 
    required this.surfaceContainerHighest, 
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
