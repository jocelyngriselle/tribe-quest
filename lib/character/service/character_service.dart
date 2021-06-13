import 'dart:async';
import 'dart:convert';
import 'dart:math';
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
    final userId = _auth.currentUserId;
    return characterCollection
        .where(
          'userId',
          isEqualTo: userId,
        )
        .orderBy(
          'rank',
          descending: true,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Character.fromSnapshot(doc)).toList();
    });
  }

  Future<void> updateCharacter(Character character) {
    return characterCollection.doc(character.id).update(character.toJson());
  }

  Future<List<Character>> getCharacters() async {
    final snapshots = await characterCollection
        .orderBy(
          'rank',
          descending: false,
        )
        .get();
    return snapshots.docs
        .map((snapshot) => Character.fromSnapshot(
              snapshot,
            ))
        .toList();
  }

  Future<Character?> getOpponent(Character character) async {
    final now = DateTime.now();
    final characters = await getCharacters();
    // Remove same character
    final charactersWithoutSame = characters.where(
      (element) => element.id != character.id,
    );
    // Filter characters who don't have a lost fight in the last hour
    final charactersAvailable = charactersWithoutSame
        .where((element) =>
            element.fights.isEmpty ||
            element.fights.first.date.compareTo(now.subtract(
                  const Duration(hours: 1),
                )) <
                0)
        .toList()
          // Sort characters by the diff of rank with the requested character
          ..sort(
            (a, b) => (character.rank - b.rank).compareTo(
              character.rank - a.rank,
            ),
          );
    if (charactersAvailable.isEmpty) {
      return null;
    }
    final minRank = charactersAvailable.first.rank;

    // Select all candidates who have the lowest rank diff
    final candidatesWithSameRank = charactersAvailable
        .where(
          (element) => element.rank == minRank,
        )
        .toList();
    if (candidatesWithSameRank.length == 1) {
      return candidatesWithSameRank.first;
    }

    // Take the character with minimum fights
    candidatesWithSameRank.sort(
      (a, b) => a.fights.length.compareTo(b.fights.length),
    );
    final minFightNumber = candidatesWithSameRank.first.fights.length;

    // Select all candidates who have the lowest rank diff
    final candidatesWithSameFightNumber = characters
        .where(
          (element) => element.fights.length == minFightNumber,
        )
        .toList();
    if (candidatesWithSameFightNumber.length == 1) {
      return candidatesWithSameFightNumber.first;
    }

    // Select a random candidate
    final _random = Random();
    final opponent = candidatesWithSameFightNumber[_random.nextInt(
      candidatesWithSameFightNumber.length,
    )];
    return opponent;
  }
}
