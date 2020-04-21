// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyResponse _$MyResponseFromJson(Map<String, dynamic> json) {
  return MyResponse(
    int.parse(json['code'].toString()),
    json['message'] as String,
    json['data'],
  );
}

Map<String, dynamic> _$MyResponseToJson(MyResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
