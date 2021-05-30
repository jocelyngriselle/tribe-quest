import 'package:bloc/bloc.dart';
import 'package:tribe_quest/character/model/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CharacterListCubit extends Cubit<List<Character>> {
  CharacterListCubit() : super([]);
}

class CharacterEditCubit extends Cubit<Character> {
  CharacterEditCubit() : super(Character());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void save({String? name}) async {
    CollectionReference characters = FirebaseFirestore.instance.collection(
      'characters',
    );
    state.name = name;
    await characters.add(state.toJson());
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
