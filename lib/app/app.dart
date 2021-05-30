// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/l10n/l10n.dart';
import 'package:firebase_core/firebase_core.dart';

// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application
/// re-enter loading state, which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget.
  /// We should not call `initializeApp` directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            color: Colors.red,
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData(
              accentColor: const Color(0xFF13B9FF),
              appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const CharacterListPage(),
          );
        }

        // Otherwise, show something whilst waiting
        //for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
