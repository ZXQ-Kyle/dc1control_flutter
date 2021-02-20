import 'package:dc1clientflutter/common/global.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dc1.g.dart';

@JsonSerializable()
class Dc1 extends Object {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'I')
  int i;

  @JsonKey(name: 'V')
  int v;

  @JsonKey(name: 'P')
  int p;

  @JsonKey(name: 'updateTime')
  int updateTime;

  @JsonKey(name: 'online')
  bool online;

  @JsonKey(name: 'powerStartTime')
  int powerStartTime;

  @JsonKey(name: 'totalPower')
  int totalPower;

  @JsonKey(name: 'names')
  List<String> names;

  List<String> get nameList {
    if (names == null) {
      var idName;
      try {
        idName = id.substring(id.length - 8, id.length);
      } catch (e) {
        logger.e(e);
        idName = '未命名';
      }
      names = ['$idName', '开关1', '开关2', '开关3', '开关4'];
    }
    return names;
  }

  Dc1([
    this.id,
    this.status,
    this.i,
    this.v,
    this.p,
    this.updateTime,
    this.online,
    this.powerStartTime,
    this.totalPower,
    this.names,
  ]);

  factory Dc1.fromJson(Map<String, dynamic> srcJson) => _$Dc1FromJson(srcJson);

  Map<String, dynamic> toJson() => _$Dc1ToJson(this);

  @override
  String toString() {
    return 'Dc1{id: $id, status: $status, i: $i, v: $v, p: $p, updateTime: $updateTime, online: $online, powerStartTime: $powerStartTime, totalPower: $totalPower, names: $names}';
  }
}
