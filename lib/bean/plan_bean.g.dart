// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanBean _$PlanBeanFromJson(Map<String, dynamic> json) {
  return PlanBean(
    json['id'] as String,
    json['deviceId'] as String,
    json['deviceName'] as String,
    json['updateTime'] as int,
    json['status'] as String,
    json['command'] as String,
    json['switchIndex'] as String,
    json['triggerTime'] as String,
    json['repeat'] as String,
    json['repeatData'] as String,
    json['enable'] as bool,
  );
}

Map<String, dynamic> _$PlanBeanToJson(PlanBean instance) => <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'updateTime': instance.updateTime,
      'status': instance.status,
      'command': instance.command,
      'switchIndex': instance.switchIndex,
      'triggerTime': instance.triggerTime,
      'repeat': instance.repeat,
      'repeatData': instance.repeatData,
      'enable': instance.enable,
    };
