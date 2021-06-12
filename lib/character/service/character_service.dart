import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/auth/auth.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

class CharacterService {
  final characterCollection = FirebaseFirestore.instance.collection(
    'characters',
  );
  final _auth = GetIt.instance.get<AuthenticationService>();
  static const _randomUserUrl = 'http://api.randomuser.me/';
  final JsonDecoder _decoder = const JsonDecoder();

  Future<String?> fetchImageUrl() async {
    final response = await http.get(Uri.parse(_randomUserUrl));
    final jsonBody = response.body;
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      return null;
    }
    final results = _decoder.convert(jsonBody)?['results'] as List;
    if (results.isEmpty) return null;
    return results.first['picture']?['large'];
  }

  Future<void> save(Character character) async {
    character.imgUrl ??= await fetchImageUrl();
    character.userId ??= _auth.currentUserId;
    if (character.id == null) {
      await characterCollection.add(character.toJson());
    } else {
      await characterCollection.doc(character.id).update(character.toJson());
    }
  }

  Future<void> delete(Character character) async {
    return characterCollection.doc(character.id).delete();
  }

  Stream<List<Character>> charactersStream() {
    return characterCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Character.fromSnapshot(doc)).toList();
    });
  }

  Future<List<Character>> characters() async {
    final userId = _auth.currentUserId;
    final snapshots = await characterCollection
        .where(
          'userId',
          isEqualTo: userId,
        )
        .orderBy(
          'rank',
          descending: true,
        )
        .get();
    return snapshots.docs
        .map((snapshot) => Character.fromSnapshot(
              snapshot,
            ))
        .toList();
  }

  Future<void> updateCharacter(Character character) {
    return characterCollection.doc(character.id).update(character.toJson());
  }

  Future<Character?> getOpponent(Character character) async {
    final now = DateTime.now();
    final snapshots = await characterCollection
        .orderBy(
          'rank',
          descending: true,
        )
        .get();
    final characters = snapshots.docs
        .map((snapshot) => Character.fromSnapshot(
              snapshot,
            ))
        .toList()
          ..sort(
            (a, b) => (character.rank - a.rank).compareTo(
              character.rank - b.rank,
            ),
          );
    final opponent = characters.firstWhereOrNull(
      // TODO reverted ?
      (element) =>
          element.id != character.id &&
          (element.fights.isEmpty ||
              element.fights.first.date.compareTo(now.subtract(
                    const Duration(hours: 1),
                  )) >
                  0),
    );
    return opponent;
  }
}
