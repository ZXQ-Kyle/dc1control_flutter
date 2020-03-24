import 'package:json_annotation/json_annotation.dart';

part 'plan_bean.g.dart';

@JsonSerializable()
class PlanBean extends Object {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'deviceId')
  String deviceId;

  @JsonKey(name: 'deviceName')
  String deviceName;

  @JsonKey(name: 'updateTime')
  int updateTime;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'command')
  String command;

  @JsonKey(name: 'switchIndex')
  String switchIndex;

  @JsonKey(name: 'triggerTime')
  String triggerTime;

  @JsonKey(name: 'repeat')
  String repeat;

  @JsonKey(name: 'repeatData')
  String repeatData;

  @JsonKey(name: 'enable')
  bool enable;

  PlanBean([
    this.id,
    this.deviceId,
    this.deviceName,
    this.updateTime,
    this.status,
    this.command,
    this.switchIndex,
    this.triggerTime,
    this.repeat,
    this.repeatData,
    this.enable,
  ]);

  factory PlanBean.fromJson(Map<String, dynamic> srcJson) =>
      _$PlanBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PlanBeanToJson(this);
}
