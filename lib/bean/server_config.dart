import 'package:json_annotation/json_annotation.dart';

part 'server_config.g.dart';

@JsonSerializable()
class ServerConfig extends Object {
  @JsonKey(name: 'host')
  String host;

  @JsonKey(name: 'socketPort')
  int socketPort;

  @JsonKey(name: 'httpPort')
  int httpPort;

  @JsonKey(name: 'token')
  String token;

  ServerConfig([
    this.host,
    this.socketPort,
    this.httpPort,
    this.token,
  ]);

  factory ServerConfig.fromJson(Map<String, dynamic> srcJson) =>
      _$ServerConfigFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ServerConfigToJson(this);
}
