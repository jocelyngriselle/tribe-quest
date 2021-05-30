import 'package:bloc/bloc.dart';
import 'package:tribe_quest/character/model/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit() : super(CharactersInitialState());

  void getCharacters() async {
    try {
      emit(CharactersLoadingState());
      CollectionReference charactersCollection = FirebaseFirestore.instance.collection('characters');
      final snapshot = await charactersCollection.get();
      final characters = snapshot.docs.map((snapshot) => Character.fromSnapshot(snapshot)).toList();
      emit(CharactersLoadedState(characters));
    } catch (e) {
      print(e);
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

class CharacterEditCubit extends Cubit<Character> {
  CharacterEditCubit({required Character character}) : super(character);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void save({String? name}) async {
    CollectionReference charactersCollection = FirebaseFirestore.instance.collection(
      'characters',
    );
    state.name = name;
    await charactersCollection.add(state.toJson());
  }

  void incrementHealth() {
    emit(state.copyWith(health: state.health + 1));
  }

  void decreaseHealth() {
    emit(state.copyWith(health: state.health - 1));
  }

  void incrementAttack() {
    emit(state.copyWith(attack: state.attack + 1));
  }

  void decreaseAttack() {
    emit(state.copyWith(attack: state.attack - 1));
  }

  void incrementDefence() {
    emit(state.copyWith(defence: state.defence + 1));
  }

  void decreaseDefence() {
    emit(state.copyWith(defence: state.defence - 1));
  }

  void incrementMagik() {
    emit(state.copyWith(magik: state.magik + 1));
  }

  void decreaseMagik() {
    emit(state.copyWith(magik: state.magik - 1));
  }
}
