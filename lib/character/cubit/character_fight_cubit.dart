import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/character/model/character_model.dart';

abstract class CharacterFightState {}

class CharacterFightingState extends CharacterFightState {
  CharacterFightingState(this.rounds) : super();
  final List<Round> rounds;
}

class CharacterFighEndedState extends CharacterFightState {
  CharacterFighEndedState({
    required this.rounds,
    required this.winner,
  }) : super();
  final List<Round> rounds;
  final Character? winner;
}

class CharacterFightCubit extends Cubit<CharacterFightState> {
  CharacterFightCubit({required this.character, required this.opponent})
      : initialCharacter = Character.clone(character),
        initialOpponent = Character.clone(opponent),
        super(CharacterFightingState([
          Round(
            character: character,
            opponent: opponent,
            opponentHealthRemoved: 0,
            characterHealthRemoved: 0,
          )
        ]));

  Character character;
  Character opponent;
  final Character initialCharacter;
  final Character initialOpponent;
  final characterService = GetIt.instance.get<CharacterService>();

  Future<void> end(bool? victory) async {
    // No winners means nothing is saved
    if (victory == null) {
      return;
    }
    final characterFight = Fight(
      victory: victory,
      opponentName: initialOpponent.name ?? 'inconnu',
    );
    final opponentFight = Fight(
      victory: !victory,
      opponentName: initialCharacter.name ?? 'inconnu',
    );
    initialCharacter.fights.add(characterFight);
    initialOpponent.fights.add(opponentFight);
    if (victory) {
      initialCharacter.rank++;
      initialCharacter.skillPoints++;
    } else {
      initialOpponent.rank++;
      initialOpponent.skillPoints++;
    }
    await characterService.updateCharacter(initialCharacter);
    await characterService.updateCharacter(initialOpponent);
  }

  /// Recursively fight character and opponent
  void fight() async {
    final updatedOpponent = Character.clone(
      (state as CharacterFightingState).rounds.last.opponent,
    );
    final updatedCharacter = Character.clone(
      (state as CharacterFightingState).rounds.last.character,
    );

    if (updatedCharacter.attack == 0 && updatedOpponent.attack == 0) {
      emit(CharacterFighEndedState(
        rounds: (state as CharacterFightingState).rounds,
        winner: null,
      ));
      return;
    }
    final charactercCantHitOpponent = updatedCharacter.attack < updatedOpponent.defence;
    final opponentCantHitCharacter = updatedCharacter.attack < updatedOpponent.defence;
    if (charactercCantHitOpponent && opponentCantHitCharacter) {
      emit(CharacterFighEndedState(
        rounds: (state as CharacterFightingState).rounds,
        winner: null,
      ));
      return;
    }

    if (updatedCharacter.health < 0 || updatedOpponent.health < 0) {
      final winner = updatedCharacter.health < 0 ? initialOpponent : initialCharacter;
      emit(CharacterFighEndedState(
        rounds: (state as CharacterFightingState).rounds,
        winner: winner,
      ));
      await end(winner.id == updatedCharacter.id); // TODO better then this
      return;
    }
    final opponentHealthRemoved = updatedCharacter.attackOpponent(
      updatedOpponent,
    );
    final characterHealthRemoved = updatedOpponent.attackOpponent(
      updatedCharacter,
    );
    final rounds = List<Round>.from((state as CharacterFightingState).rounds)
      ..add(Round(
        character: updatedCharacter,
        opponent: updatedOpponent,
        characterHealthRemoved: characterHealthRemoved,
        opponentHealthRemoved: opponentHealthRemoved,
      ));
    emit(CharacterFightingState(rounds));
    Future.delayed(const Duration(seconds: 1), fight);
  }
}
