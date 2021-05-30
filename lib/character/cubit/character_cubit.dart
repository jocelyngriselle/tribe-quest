import 'package:bloc/bloc.dart';
import 'package:tribe_quest/character/model/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CharacterListCubit extends Cubit<List<Character>> {
  CharacterListCubit() : super([]);
}

class CharacterEditCubit extends Cubit<Character> {
  CharacterEditCubit() : super(Character()) {
    print("created");
    print(state);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void save() async {
    CollectionReference characters = FirebaseFirestore.instance.collection(
      'characters',
    );
    await characters
        .add({
          'health': state.health,
          'attack': state.attack,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    emit(state);
  }

  void incrementHealth() {
    emit(state.copyWith(health: state.health + 1));
  }

  void decreaseHealth() {
    emit(state.copyWith(health: state.health - 1));
  }
}
