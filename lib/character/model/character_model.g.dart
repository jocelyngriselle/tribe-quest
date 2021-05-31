// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) {
  return Character(
    health: json['health'] as int,
    attack: json['attack'] as int,
    defence: json['defence'] as int,
    magik: json['magik'] as int,
    name: json['name'] as String?,
    skillPoints: json['skillPoints'] as int,
  );
}

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'name': instance.name,
      'health': instance.health,
      'skillPoints': instance.skillPoints,
      'attack': instance.attack,
      'defence': instance.defence,
      'magik': instance.magik,
    };
