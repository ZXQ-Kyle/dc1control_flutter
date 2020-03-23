// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['host'] as String,
    json['socketPort'] as int,
    json['httpPort'] as int,
    json['token'] as String,
    json['theme'] as int,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'host': instance.host,
      'socketPort': instance.socketPort,
      'httpPort': instance.httpPort,
      'token': instance.token,
      'theme': instance.theme,
    };
