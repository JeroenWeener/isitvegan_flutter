import 'package:flutter/material.dart';

import '../features/features.dart';
import '../localizations/localizations.dart';
import '../themes/themes.dart';

/// This widget is the entry-point of the Widget-tree.
class App extends StatelessWidget {
  /// Creates a new [App].
  const App({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      /// The [themeMode] sets a default ThemeMode. The current setting
      /// [ThemeMode.system] switches between [theme] (light) and [darkTheme]
      /// depending on the users device settings, as the application has
      /// both themes available. However, setting the [themeMode]
      /// parameter to light or dark will prevent the application from
      /// switching automatically.
      // TODO: set default [ThemeMode]
      themeMode: ThemeMode.system,
      // TODO: implement themes
      theme: IsitveganLightTheme().theme,
      darkTheme: IsitveganDarkTheme().theme,
      home: const CounterPage(),
    );
  }
}
