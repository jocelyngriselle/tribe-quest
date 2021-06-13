// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/app/app.dart';
import 'package:tribe_quest/app/app_bloc_observer.dart';
import 'package:tribe_quest/auth/auth.dart';
import 'package:tribe_quest/character/service/character_service.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.I.registerSingleton<AuthenticationService>(
    AuthenticationService(),
  );
  GetIt.I.registerSingleton<CharacterService>(
    CharacterService(),
  );
  runZonedGuarded(
    () => runApp(const App()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
