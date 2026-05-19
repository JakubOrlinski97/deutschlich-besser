import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/views/learning_screen.dart';
import 'package:deutschlich_besser/views/set_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deutschlich Besser',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('de'),
      ],
      locale: Locale('de'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
      ),
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          return Scaffold(
            body: SetSelection()
          );
        },
      ),
    );
  }
}
