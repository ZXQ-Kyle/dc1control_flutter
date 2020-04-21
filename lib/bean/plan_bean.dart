import 'package:json_annotation/json_annotation.dart';

part 'plan_bean.g.dart';

@JsonSerializable()
class PlanBean extends Object {
  static const List<String> WEEK_DAY_CN = [
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日"
  ];

  static const String REPEAT_ONCE = "repeat_once";
  static const String REPEAT_EVERYDAY = "repeat_everyday";
  static const String REPEAT_AT_FIXED_RATE = "repeat_at_fixed_rate";
  static const String REPEAT_CUSTOM = "repeat_custom";

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

  @override
  String toString() {
    return 'PlanBean{id: $id, deviceId: $deviceId, deviceName: $deviceName, updateTime: $updateTime, status: $status, command: $command, switchIndex: $switchIndex, triggerTime: $triggerTime, repeat: $repeat, repeatData: $repeatData, enable: $enable}';
  }


}
