import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/character/model/character_model.dart';

class CharacterEditState extends Equatable {
  const CharacterEditState(
    this.character,
  ) : super();

  final Character character;

  @override
  List<Object> get props => [
        character,
      ];

  CharacterEditState copyWith({required Character character}) {
    return CharacterEditState(
      Character.clone(character),
    );
  }
}

class CharacterEditCubit extends Cubit<CharacterEditState> {
  CharacterEditCubit({required character})
      : initialCharacter = Character.clone(character),
        super(CharacterEditState(character));

  Character initialCharacter;
  final characterService = GetIt.instance.get<CharacterService>();

  void nameChanged(String name) {
    emit(state.copyWith(
      character: state.character..name = name,
    ));
  }

  Future<void> save() async {
    final updatedCharacter = Character.clone(
      state.character,
    );
    await characterService.save(updatedCharacter);
    initialCharacter = updatedCharacter;
    emit(state.copyWith(character: updatedCharacter));
  }

  void reset() {
    emit(CharacterEditState(initialCharacter));
  }

  // HEALTH
  void incrementHealth() {
    final updatedCharacter = Character.clone(
      state.character,
    )..increaseHealth();
    emit(CharacterEditState(updatedCharacter));
  }

  void decrementHealth() {
    final updatedCharacter = Character.clone(
      state.character,
    )..decreaseHealth();
    emit(CharacterEditState(updatedCharacter));
  }

  bool canDecreaseHealth() => initialCharacter.health < state.character.health;

  // ATTACK
  void incrementAttack() {
    final updatedCharacter = Character.clone(
      state.character,
    )..increaseAttack();
    emit(CharacterEditState(updatedCharacter));
  }

  void decreaseAttack() {
    final updatedCharacter = Character.clone(
      state.character,
    )..decreaseAttack();
    emit(CharacterEditState(updatedCharacter));
  }

  bool canDecreaseAttack() => initialCharacter.attack < state.character.attack;

  // DEFENCE
  void incrementDefence() {
    final updatedCharacter = Character.clone(
      state.character,
    )..increaseDefence();
    emit(CharacterEditState(updatedCharacter));
  }

  void decreaseDefence() {
    final updatedCharacter = Character.clone(
      state.character,
    )..decreaseDefence();
    emit(CharacterEditState(updatedCharacter));
  }

  bool canDecreaseDefence() => initialCharacter.defence < state.character.defence;

  // MAGIK
  void incrementMagik() {
    final updatedCharacter = Character.clone(
      state.character,
    )..increaseMagik();
    emit(CharacterEditState(updatedCharacter));
  }

  void decreaseMagik() {
    final updatedCharacter = Character.clone(
      state.character,
    )..decreaseMagik();
    emit(CharacterEditState(updatedCharacter));
  }

  bool canDecreaseMagik() => initialCharacter.magik < state.character.magik;
}
