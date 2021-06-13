import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/character/model/character_model.dart';

class CharacterDetailState extends Equatable {
  const CharacterDetailState(
    this.character,
  ) : super();

  final Character character;

  @override
  List<Object> get props => [
        character,
      ];

  CharacterDetailState copyWith({required Character character}) {
    return CharacterDetailState(
      Character.clone(character),
    );
  }
}

class CharacterDetailCubit extends Cubit<CharacterEditState> {
  CharacterDetailCubit({required character}) : super(CharacterEditState(character));

  final characterService = GetIt.instance.get<CharacterService>();

  Future<Character?> getOpponent(Character character) async {
    return characterService.getOpponent(character);
  }
}
