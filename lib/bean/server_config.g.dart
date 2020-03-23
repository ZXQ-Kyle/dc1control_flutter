// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfig _$ServerConfigFromJson(Map<String, dynamic> json) {
  return ServerConfig(
    json['host'] as String,
    json['socketPort'] as int,
    json['httpPort'] as int,
    json['token'] as String,
  );
}

Map<String, dynamic> _$ServerConfigToJson(ServerConfig instance) =>
    <String, dynamic>{
      'host': instance.host,
      'socketPort': instance.socketPort,
      'httpPort': instance.httpPort,
      'token': instance.token,
    };
