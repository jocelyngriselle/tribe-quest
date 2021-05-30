import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character_model.g.dart';

@JsonSerializable()
class Character {
  Character({
    this.health = 10,
    this.attack = 0,
    this.defence = 0,
    this.magik = 0,
    this.name,
  });

  Character.fromSnapshot(
    DocumentSnapshot snapshot,
  )   : health = snapshot['health'],
        attack = snapshot['attack'],
        defence = snapshot['defence'],
        magik = snapshot['magik'],
        name = snapshot['name'];

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  static const skillPoints = 12;
  String? name;
  int health;
  int attack;
  int defence;
  int magik;

  Character copyWith({
    int? health,
    int? attack,
    int? defence,
    int? magik,
  }) =>
      Character(
        health: health ?? this.health,
        attack: attack ?? this.attack,
        defence: defence ?? this.defence,
        magik: magik ?? this.magik,
      );
}
