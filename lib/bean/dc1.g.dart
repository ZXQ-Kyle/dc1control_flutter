// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dc1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dc1 _$Dc1FromJson(Map<String, dynamic> json) {
  return Dc1(
    json['id'] as String,
    json['status'] as String,
    json['I'] as int,
    json['V'] as int,
    json['P'] as int,
    json['updateTime'] as int,
    json['online'] as bool,
    json['powerStartTime'] as int,
    json['totalPower'] as int,
    (json['names'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$Dc1ToJson(Dc1 instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'I': instance.i,
      'V': instance.v,
      'P': instance.p,
      'updateTime': instance.updateTime,
      'online': instance.online,
      'powerStartTime': instance.powerStartTime,
      'totalPower': instance.totalPower,
      'names': instance.names,
    };
