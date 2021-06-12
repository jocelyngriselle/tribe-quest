// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fight _$FightFromJson(Map<String, dynamic> json) {
  return Fight(
    opponentName: json['opponentName'] as String,
    victory: json['victory'] as bool,
  );
}

Map<String, dynamic> _$FightToJson(Fight instance) => <String, dynamic>{
      'opponentName': instance.opponentName,
      'victory': instance.victory,
    };
