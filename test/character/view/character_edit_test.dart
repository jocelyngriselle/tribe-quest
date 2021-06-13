// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tribe_quest/auth/auth.dart';
import 'package:tribe_quest/character/character.dart';

import '../../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  setUpAll(() async {
    GetIt.I.registerSingleton<AuthenticationService>(
      MockAuthService(),
    );
    GetIt.I.registerSingleton<CharacterService>(
      MockCharacterService(),
    );
    final character = Character();
    registerFallbackValue(CharacterEditState(character));
  });

  group('CharacterEditPage', () {
    testWidgets('renders CharacterEditView', (tester) async {
      await tester.pumpApp(CharacterEditPage());
      expect(find.byType(CharacterEditView), findsOneWidget);
    });
  });

  group('CharacterEditView', () {
    late Character character;
    const incrementAttackButtonKey = Key(
      'characterEditView_incrementAttack_floatingActionButton',
    );
    late CharacterEditCubit characterEditCubit;

    setUpAll(() async {
      character = Character(health: 1, attack: 2, defence: 3, magik: 4);
      characterEditCubit = MockCharacterEditCubit();
    });

    testWidgets('renders current character', (tester) async {
      final state = CharacterEditState(character);
      when(() => characterEditCubit.state).thenReturn(state);
      when(() => characterEditCubit.canDecreaseHealth()).thenReturn(true);
      when(() => characterEditCubit.canDecreaseAttack()).thenReturn(true);
      when(() => characterEditCubit.canDecreaseDefence()).thenReturn(true);
      when(() => characterEditCubit.canDecreaseMagik()).thenReturn(true);
      await tester.pumpApp(
        BlocProvider.value(
          value: characterEditCubit,
          child: CharacterEditView(
            character: character,
          ),
        ),
      );
      expect(find.text('${state.character.health}'), findsOneWidget);
      expect(find.text('${state.character.attack}'), findsOneWidget);
      expect(find.text('${state.character.defence}'), findsOneWidget);
      expect(find.text('${state.character.magik}'), findsOneWidget);
    });

    testWidgets('increase attack when button is tapped', (tester) async {
      final state = CharacterEditState(character);
      when(() => characterEditCubit.state).thenReturn(state);
      when(() => characterEditCubit.incrementAttack()).thenReturn(null);
      when(() => characterEditCubit.canDecreaseHealth()).thenReturn(true);
      when(() => characterEditCubit.canDecreaseAttack()).thenReturn(true);
      when(() => characterEditCubit.canDecreaseDefence()).thenReturn(true);
      when(() => characterEditCubit.canDecreaseMagik()).thenReturn(true);
      await tester.pumpApp(
        BlocProvider.value(
          value: characterEditCubit,
          child: CharacterEditView(
            character: character,
          ),
        ),
      );
      await tester.tap(find.byKey(incrementAttackButtonKey));
      verify(() => characterEditCubit.incrementAttack()).called(1);
    });
  });
}
