import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'character_model.dart';

part 'fight_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Fight {
  Fight({
    required this.opponentName,
    required this.victory,
  })  : date = DateTime.now(),
        super();

  Fight.fromSnapshot(
    DocumentSnapshot snapshot,
  )   : opponentName = snapshot['opponentName'],
        victory = snapshot['victory'],
        date = snapshot['date'];

  factory Fight.fromJson(Map<String, dynamic> json) => _$FightFromJson(json);

  Map<String, dynamic> toJson() => _$FightToJson(this);

  String opponentName;
  bool victory;
  final DateTime date;
}

class Round {
  const Round({
    required this.character,
    required this.opponent,
    required this.opponentHealthRemoved,
    required this.characterHealthRemoved,
  });
  final Character character;
  final Character opponent;
  final int opponentHealthRemoved;
  final int characterHealthRemoved;

  @override
  String toString() {
    return '${character.health} - ${opponent.health}';
  }
}
