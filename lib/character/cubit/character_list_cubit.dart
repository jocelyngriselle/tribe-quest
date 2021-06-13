import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/character/model/character_model.dart';

abstract class CharactersState {}

class CharactersInitialState extends CharactersState {}

class CharactersLoadingState extends CharactersState {}

class CharactersErrorState extends CharactersState {}

class CharactersLoadedState extends CharactersState {
  CharactersLoadedState(this.characters);

  final List<Character> characters;
}

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit() : super(CharactersInitialState());

  final characterService = GetIt.instance.get<CharacterService>();

  void getCharacters() async {
    try {
      emit(CharactersLoadingState());
      characterService.charactersStream().listen(
            (characters) => emit(CharactersLoadedState(characters)),
          );
    } catch (e) {
      emit(CharactersErrorState());
    }
  }

  Future<void> remove(Character character) async {
    try {
      emit(CharactersLoadingState());
      await characterService.delete(character);
    } catch (e) {
      emit(CharactersErrorState());
    }
  }
}
