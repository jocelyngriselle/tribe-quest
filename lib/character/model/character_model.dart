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
    this.skillPoints = 12,
  });

  String? name;
  int health;
  int skillPoints;
  int attack;
  int defence;
  int magik;

  bool canIncreaseHealth() => skillPoints > 0;
  void increaseHealth() {
    skillPoints--;
    health++;
  }

  int skillPointDecrease(int points) => points == 0 ? 1 : (points / 5).ceil();

  bool canIncrease(int points) => skillPoints > (points / 5).ceil();

  void increaseAttack() {
    skillPoints -= skillPointDecrease(attack);
    attack++;
  }

  void increaseDefence() {
    skillPoints -= skillPointDecrease(defence);
    defence++;
  }

  void increaseMagik() {
    skillPoints -= skillPointDecrease(magik);
    magik++;
  }

  Character.clone(Character character)
      : this(
          name: character.name,
          skillPoints: character.skillPoints,
          health: character.health,
          attack: character.attack,
          magik: character.magik,
          defence: character.defence,
        );

  Character.fromSnapshot(
    // TODO factory
    DocumentSnapshot snapshot,
  )   : skillPoints = snapshot['skillPoints'],
        health = snapshot['health'],
        attack = snapshot['attack'],
        defence = snapshot['defence'],
        magik = snapshot['magik'],
        name = snapshot['name'];

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
