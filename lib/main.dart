import 'dart:ffi';

import 'package:deutschlich_besser/app.dart';
import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/models/exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppState.Empty()),
        ],
        child: const App(),
      )
  );
}

