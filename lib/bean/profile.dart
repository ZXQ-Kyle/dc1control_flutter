import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile extends Object {
  ///http://192.168........
  ///https://www......
  @JsonKey(name: 'host')
  String host;

  @JsonKey(name: 'socketPort')
  int socketPort;

  @JsonKey(name: 'httpPort')
  int httpPort;

  @JsonKey(name: 'token')
  String token;

  @JsonKey(name: 'theme')
  int theme;

  Profile([
    this.host,
    this.socketPort,
    this.httpPort,
    this.token,
    this.theme,
  ]);

  factory Profile.fromJson(Map<String, dynamic> srcJson) =>
      _$ProfileFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
