import 'dart:collection';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/plan_bean.dart';
import 'package:dc1clientflutter/common/api.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:uuid_enhanced/uuid.dart';

class AddPlanRoute extends StatefulWidget {
  @override
  _AddPlanRouteState createState() => _AddPlanRouteState();
}

class _AddPlanRouteState extends State<AddPlanRoute> {
  static const int REPEAT_POSITION_ONCE = 0;
  static const int REPEAT_POSITION_EVERYDAY = 1;
  static const int REPEAT_POSITION_AT_FIXED_RATE = 2;
  static const int REPEAT_POSITION_CUSTOM = 3;

  Dc1 _dc1;
  DateTime _time;
  int _repeatPosition = REPEAT_POSITION_ONCE;
  String _switchName;
  String _command;
  Map<int, bool> _weekState;

  @override
  void initState() {
    _weekState = HashMap();
    for (int i = 0; i < 7; i++) {
      _weekState[i] = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dc1 = ModalRoute.of(context).settings.arguments;
    var labelStyle =
        TextStyle(fontSize: 16, color: Theme.of(context).primaryColor);
    return Scaffold(
      appBar: AppBar(
        title: Text("添加计划"),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _save(context),
          child: Icon(Icons.check),
        );
      }),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "触发时间",
              style: labelStyle,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                constraints: BoxConstraints(minWidth: double.infinity),
                height: 56,
                child: Text(
                    _time == null ? "未设置" : "${_time.hour}:${_time.minute}"),
              ),
              onTap: () {
                pickTime();
              },
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              color: Theme.of(context).primaryColor,
              constraints:
                  BoxConstraints(minWidth: double.infinity, maxHeight: 1),
            ),
            Text(
              "周期",
              style: labelStyle,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MyCheckBox((v) {
                    checkBoxValueChanged(v, REPEAT_POSITION_ONCE);
                  }, _repeatPosition == REPEAT_POSITION_ONCE, "一次"),
                ),
                Expanded(
                  child: MyCheckBox((v) {
                    checkBoxValueChanged(v, REPEAT_POSITION_EVERYDAY);
                  }, _repeatPosition == REPEAT_POSITION_EVERYDAY, "每次"),
                ),
                Expanded(
                  child: MyCheckBox((v) {
                    checkBoxValueChanged(v, REPEAT_POSITION_AT_FIXED_RATE);
                  }, _repeatPosition == REPEAT_POSITION_AT_FIXED_RATE, "周期"),
                ),
                Expanded(
                  child: MyCheckBox((v) {
                    checkBoxValueChanged(v, REPEAT_POSITION_CUSTOM);
                  }, _repeatPosition == REPEAT_POSITION_CUSTOM, "自定义"),
                ),
              ],
            ),

            generateCustomWidget(),

            ///周期分割线
            Container(
              margin: EdgeInsets.only(bottom: 16),
              color: Theme.of(context).primaryColor,
              constraints:
                  BoxConstraints(minWidth: double.infinity, maxHeight: 1),
            ),
            Text(
              "开关",
              style: labelStyle,
            ),
            InkWell(
              onTap: () async {
                var result = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("选择操作的开关"),
                      children: _dc1?.nameList?.sublist(1)?.map((name) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context, name);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(name ?? "未命名"),
                          ),
                        );
                      })?.toList(),
                    );
                  },
                );
                if (result != null) {
                  _switchName = result;
                  setState(() {});
                }
              },
              child: Container(
                constraints: BoxConstraints(minWidth: double.infinity),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Text(_switchName ?? "未设置"),
              ),
            ),
            Text(
              "指令",
              style: labelStyle,
            ),
            InkWell(
              onTap: () async {
                var result = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      var list = ["关闭", "开启"];
                      return SimpleDialog(
                        title: Text("选择执行操作"),
                        children: list
                            .asMap()
                            .map((index, text) {
                              return MapEntry(
                                  index,
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(
                                        context, index.toString()),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Text(text),
                                    ),
                                  ));
                            })
                            .values
                            .toList(),
                      );
                    });
                if (result != null) {
                  _command = result;
                  setState(() {});
                }
              },
              child: Container(
                constraints: BoxConstraints(minWidth: double.infinity),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Text(
                    _command == null ? "未设置" : _command == "0" ? "关闭" : "开启"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget generateCustomWidget() {
    if (_repeatPosition == 3) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Wrap(
          spacing: 24,
          runSpacing: 16,
          children: PlanBean.WEEK_DAY_CN.map((e) {
            var textStyle = TextStyle(color: Colors.white, fontSize: 14);
            return GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  color: _weekState[PlanBean.WEEK_DAY_CN.indexOf(e)]
                      ? Theme.of(context).primaryColor.withAlpha(150)
                      : Colors.grey,
                  child: Text(e, style: textStyle),
                ),
              ),
              onTap: () {
                setState(() {
                  var indexOf = PlanBean.WEEK_DAY_CN.indexOf(e);
                  _weekState.update(indexOf, (v) => !_weekState[indexOf]);
                });
              },
            );
          }).toList(),
        ),
      );
    } else {
      return Container();
    }
  }

  void checkBoxValueChanged(bool checked, int pos) {
    if (_repeatPosition != pos) {
      setState(() {
        _repeatPosition = pos;
      });
    }
  }

  pickTime() {
    DatePicker.showTimePicker(
      context,
      showSecondsColumn: false,
      locale: LocaleType.zh,
      onConfirm: (DateTime time) {
        setState(() {
          _time = time;
        });
      },
    );
  }

  _save(BuildContext context) {
    if (_time == null) {
      final snackBar =
          SnackBar(duration: Duration(seconds: 1), content: Text("请选择时间"));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }
    if (_switchName == null || _command == null) {
      final snackBar =
          SnackBar(duration: Duration(seconds: 1), content: Text("请设置开关"));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }
    if (_switchName == null || _command == null) {
      final snackBar =
          SnackBar(duration: Duration(seconds: 1), content: Text("请设置开关"));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }
    if (_repeatPosition == 3 && !_weekState.containsValue(true)) {
      final snackBar =
          SnackBar(duration: Duration(seconds: 1), content: Text("自定义数据未设置"));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }
    var repeat = _calcRepeat();

    String minute = _time.minute < 10
        ? "0" + _time.minute.toString()
        : _time.minute.toString();
    PlanBean planBean = PlanBean()
      ..id = Uuid.randomUuid().toString()
      ..enable = true
      ..triggerTime = "${_time.hour}:$minute:00"
      ..status = "0000"
      ..deviceName = _dc1?.nameList[0] ?? _dc1.id.substring(_dc1.id.length - 4)
      ..repeat = repeat
      ..deviceId = _dc1?.id
      ..command = _command ?? ""
      ..switchIndex =
          ((_dc1?.nameList?.indexOf(_switchName) ?? 0) - 1).toString()
      ..repeatData = "";

    myPrint(planBean);
    Api().addPlan(
      planBean,
      (onSuccess) => Navigator.pop(context),
      (onFailed) {
        final snackBar =
            SnackBar(duration: Duration(seconds: 5), content: Text("保存失败!"));
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
//        .setRepeatData(String.format("%d,%d", wvPeriod.getCurrentItem() + 1, wvTime.getCurrentItem() + 1));
  }

  String _calcRepeat() {
    if (_repeatPosition == REPEAT_POSITION_AT_FIXED_RATE) {
      return PlanBean.REPEAT_AT_FIXED_RATE;
    }
    if (_repeatPosition == REPEAT_POSITION_ONCE) {
      return PlanBean.REPEAT_ONCE;
    }
    if (_repeatPosition == REPEAT_POSITION_EVERYDAY) {
      return PlanBean.REPEAT_EVERYDAY;
    }
    if (_repeatPosition == REPEAT_POSITION_CUSTOM) {
      var list = List<String>();
      _weekState.forEach((index, checked) {
        if (checked) {
          list.add((index + 1).toString());
        }
      });
      String reduce = list.reduce((value, element) {
        return value + "," + element;
      });
      return reduce;
    }
    return null;
  }
}

class MyCheckBox extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool value;
  final String text;

  MyCheckBox(this.onChanged, this.value, this.text);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            value: value,
            onChanged: onChanged,
          ),
          Text(text)
        ],
      ),
    );
  }
}
