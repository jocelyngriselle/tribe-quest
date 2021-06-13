import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/auth/auth.dart';
import 'package:tribe_quest/character/character.dart';

import '../mocks/mocks.dart';

void main() {
  group('CounterCubit', () {
    late Character character;

    setUpAll(() async {
      character = Character();
      GetIt.I.registerSingleton<AuthenticationService>(
        MockAuthService(),
      );
      GetIt.I.registerSingleton<CharacterService>(
        MockCharacterService(),
      );
    });

    test('initial state is the initialCharacter', () {
      expect(
        CharacterEditCubit(character: character).state,
        equals(CharacterEditState(character)),
      );
    });

    test('can increase attack on the initialCharacter', () {
      final _cubit = CharacterEditCubit(character: character);
      for (var i = 1; i < 7; i++) {
        _cubit.incrementAttack();
        expect(
          _cubit.state.character.attack,
          equals(character.attack + i),
        );
        expect(
          _cubit.state.character.skillPoints,
          equals(character.skillPoints - i),
        );
      }
      _cubit.incrementAttack();
      expect(
        _cubit.state.character.attack,
        equals(character.attack + 7),
      );
      expect(
        _cubit.state.character.skillPoints,
        equals(character.skillPoints - 8),
      );
    });

    test('can increase health on the initialCharacter', () {
      final _cubit = CharacterEditCubit(character: character);
      for (var i = 1; i < 8; i++) {
        _cubit.incrementHealth();
        expect(
          _cubit.state.character.health,
          equals(character.health + i),
        );
        expect(
          _cubit.state.character.skillPoints,
          equals(character.skillPoints - i),
        );
      }
    });

    blocTest<CharacterEditCubit, CharacterEditState>(
      'emits new character when incrementAttack is called',
      build: () => CharacterEditCubit(character: character),
      act: (cubit) => cubit.incrementAttack(),
      expect: () => [isA<CharacterEditState>()],
    );
  });
}
