import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tribe_quest/character/model/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit() : super(CharactersInitialState());

  void getCharacters() async {
    try {
      emit(CharactersLoadingState());
      final charactersCollection = FirebaseFirestore.instance.collection(
        'characters',
      );
      final snapshot = await charactersCollection.get();
      final characters = snapshot.docs
          .map((snapshot) => Character.fromSnapshot(
                snapshot,
              ))
          .toList();
      emit(CharactersLoadedState(characters));
    } catch (e) {
      emit(CharactersErrorState());
    }
  }
}

abstract class CharactersState {}

class CharactersInitialState extends CharactersState {}

class CharactersLoadingState extends CharactersState {}

class CharactersErrorState extends CharactersState {}

class CharactersLoadedState extends CharactersState {
  CharactersLoadedState(this.characters);

  final List<Character> characters;
}

abstract class CharacterEditState {
  CharacterEditState(this.characterStream);
  final BehaviorSubject<Character> characterStream;
}

class CharacterInitialState extends CharacterEditState {
  CharacterInitialState(
    BehaviorSubject<Character> characterStream,
  ) : super(characterStream);
}

class CharacterEditingState extends CharacterEditState {
  CharacterEditingState(
    BehaviorSubject<Character> characterStream,
  ) : super(characterStream);
}

class CharacterEditingSuccessState extends CharacterEditState {
  CharacterEditingSuccessState(
    BehaviorSubject<Character> characterStream,
  ) : super(characterStream);
}

class CharacterEditCubit extends Cubit<CharacterEditState> {
  CharacterEditCubit({required this.character})
      : initialCharacter = Character.clone(character),
        super(CharacterInitialState(
          BehaviorSubject.seeded(character),
        ));

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Character character;
  final Character initialCharacter;

  Future<void> save({String? name}) async {
    final charactersCollection = FirebaseFirestore.instance.collection(
      'characters',
    );
    character.name = name;
    await charactersCollection.add(character.toJson());
  }

  void reset() {
    character = Character.clone(initialCharacter);
    state.characterStream.add(character);
  }

  void incrementHealth() {
    character.increaseHealth();
    state.characterStream.add(character);
  }

  void incrementAttack() {
    character.increaseAttack();
    state.characterStream.add(character);
  }

  void incrementDefence() {
    character.increaseDefence();
    state.characterStream.add(character);
  }

  void incrementMagik() {
    character.increaseMagik();
    state.characterStream.add(character);
  }

  @override
  void dispose() {
    // TODO s.close();
  }
}
