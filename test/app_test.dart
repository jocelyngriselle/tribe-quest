// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/app/app.dart';
import 'package:tribe_quest/auth/auth.dart';
import 'package:tribe_quest/character/character.dart';

import 'character/mocks/mocks.dart';

void main() {
  setUpAll(() async {
    GetIt.I.registerSingleton<AuthenticationService>(
      MockAuthService(),
    );
    GetIt.I.registerSingleton<CharacterService>(
      MockCharacterService(),
    );
  });
  group('App', () {
    testWidgets('renders LoginPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
