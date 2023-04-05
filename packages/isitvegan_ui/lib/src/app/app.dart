import 'package:flutter/material.dart';

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
      themeMode: ThemeMode.system,
      theme: IsitveganLightTheme().theme,
      darkTheme: IsitveganDarkTheme().theme,
      home: const Text('Placeholder'),
    );
  }
}
