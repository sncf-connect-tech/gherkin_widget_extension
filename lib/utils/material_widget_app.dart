import 'package:flutter/material.dart';

class MaterialTestWidget extends StatelessWidget {
  final Widget child;
  final TargetPlatform? platform;
  final ThemeMode? themeMode;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const MaterialTestWidget(
      {super.key,
      required this.child,
      this.platform,
      this.themeMode = ThemeMode.dark,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.localizationsDelegates,
      this.lightTheme,
      this.darkTheme});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Test Widget',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        // l'encapsulation dans RepaintBoundary permet la génération des screenshots
        home: RepaintBoundary(child: child),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
      );
}
