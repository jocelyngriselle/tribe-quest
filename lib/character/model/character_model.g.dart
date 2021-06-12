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
    skillPoints: json['skillPoints'] as int,
    name: json['name'] as String?,
    imgUrl: json['imgUrl'] as String?,
    id: json['id'] as String?,
    userId: json['userId'] as String?,
    rank: json['rank'] as int,
    fights: json['fights'],
  );
}

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'health': instance.health,
      'skillPoints': instance.skillPoints,
      'attack': instance.attack,
      'defence': instance.defence,
      'magik': instance.magik,
      'id': instance.id,
      'userId': instance.userId,
      'fights': instance.fights.map((e) => e.toJson()).toList(),
      'rank': instance.rank,
    };
