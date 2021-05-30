import 'package:equatable/equatable.dart';

class Character extends Equatable {
  Character({
    this.health = 10,
    this.attack = 0,
    this.defence = 0,
    this.magik = 0,
    this.name,
  });

  static const skillPoints = 12;
  String? name;
  int health;
  int attack;
  int defence;
  int magik;

  Character copyWith({int? health}) => Character(
        health: health ?? this.health,
      );

  @override
  List<Object> get props => [
        health,
        attack,
        defence,
        magik,
      ]; // TODO name ?

  @override
  bool get stringify => true;
}
