import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class MyResponse extends Object {
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'data')
  dynamic data;

  MyResponse([
    this.code,
    this.message,
    this.data,
  ]);

  factory MyResponse.fromJson(Map<String, dynamic> srcJson) =>
      _$MyResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MyResponseToJson(this);
}
