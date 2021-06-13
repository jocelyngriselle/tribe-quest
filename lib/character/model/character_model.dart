import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'fight_model.dart';
part 'character_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Character {
  Character({
    this.health = 10,
    this.attack = 0,
    this.defence = 0,
    this.magik = 0,
    this.skillPoints = 12,
    this.name,
    this.imgUrl,
    this.id,
    this.userId,
    this.rank = 1,
    fights,
  }) : fights = fights ?? [];

  Character.clone(Character character)
      : this(
          name: character.name,
          skillPoints: character.skillPoints,
          health: character.health,
          attack: character.attack,
          magik: character.magik,
          defence: character.defence,
          userId: character.userId,
          id: character.id,
          rank: character.rank,
          fights: character.fights,
          imgUrl: character.imgUrl,
        );

  Character.fromSnapshot(
    DocumentSnapshot snapshot,
  )   : skillPoints = snapshot['skillPoints'],
        health = snapshot['health'],
        attack = snapshot['attack'],
        defence = snapshot['defence'],
        magik = snapshot['magik'],
        name = snapshot['name'],
        userId = snapshot['userId'],
        rank = snapshot['rank'],
        imgUrl = snapshot['imgUrl'],
        id = snapshot.id,
        fights = List<Fight>.from(
          snapshot['fights'].map(
            (element) => Fight.fromJson(element),
          ),
        );

  factory Character.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CharacterFromJson(
        json,
      );

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  static const defaultName = 'Unknown';
  static const defaultImgUrl = 'https://randomuser.me/api/portraits/men/1.jpg';
  String? name;
  String? imgUrl;
  int health;
  int skillPoints;
  int attack;
  int defence;
  int magik;
  String? id;
  String? userId;
  List<Fight> fights;
  int rank;

  @override
  String toString() {
    return '${name ?? defaultName} - $rank';
  }

  bool get canFight {
    if (lastLooseDate == null) return true;
    return lastLooseDate!.compareTo(
          DateTime.now().subtract(const Duration(hours: 1)),
        ) >
        0;
  }

  DateTime? get lastLooseDate => fights.firstWhereOrNull((element) => false)?.date;

  int attackOpponent(Character opponent) {
    if (attack <= 0) return 0;
    final dice = Random().nextInt(attack + 1); // max is exclusive
    var diff = dice - opponent.defence;
    if (diff <= 0) return 0;
    if (diff == magik) {
      diff += diff;
    }
    opponent.health -= diff;
    return diff;
  }

  bool canIncreaseHealth() => skillPoints > 0;
  void increaseHealth() {
    skillPoints--;
    health++;
  }

  void decreaseHealth() {
    skillPoints++;
    health--;
  }

  int skillPointDecrease(int points) => points == 0 ? 1 : (points / 5).ceil();

  bool canIncrease(int points) => skillPoints >= skillPointDecrease(points);

  void increaseAttack() {
    skillPoints -= skillPointDecrease(attack);
    attack++;
  }

  void decreaseAttack() {
    attack--;
    skillPoints += skillPointDecrease(attack);
  }

  void increaseDefence() {
    skillPoints -= skillPointDecrease(defence);
    defence++;
  }

  void decreaseDefence() {
    defence--;
    skillPoints += skillPointDecrease(defence);
  }

  void increaseMagik() {
    skillPoints -= skillPointDecrease(magik);
    magik++;
  }

  void decreaseMagik() {
    magik--;
    skillPoints += skillPointDecrease(magik);
  }
}
