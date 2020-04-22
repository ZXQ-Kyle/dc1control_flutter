import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/plan_bean.dart';
import 'package:dc1clientflutter/common/api.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/common/widget/wheel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid_enhanced/uuid.dart';

class CountDownRoute extends StatefulWidget {
  @override
  _CountDownRouteState createState() {
    myPrint("_CountDownRouteState createState");
    return _CountDownRouteState();
  }
}

class _CountDownRouteState extends State<CountDownRoute> {
  Dc1 _dc1;
  int _initHour = 0;
  int _initMinute = 10;
  String _switchName;

  @override
  Widget build(BuildContext context) {
    myPrint("_CountDownRouteState build");
    _dc1 = ModalRoute.of(context).settings.arguments;

    var select = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor);
    var unSelect = TextStyle(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey[800]);
    var lineLightGrey = Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 12),
      constraints: BoxConstraints(minWidth: double.infinity),
      color: Colors.grey[200],
    );
    var _hourController = FixedExtentScrollController(initialItem: _initHour);
    var _minuteController =
        FixedExtentScrollController(initialItem: _initMinute);
    return Scaffold(
      appBar: AppBar(
        title: Text("倒计时"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("说明"),
            Container(
              height: 1,
              constraints: BoxConstraints(minWidth: double.infinity),
              color: Colors.grey,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: WheelView(
                    itemSize: 32,
                    listHeight: 200.0,
                    selectTextStyle: select,
                    unSelectTextStyle: unSelect,
                    onValueChanged: (s) {
                      _switchName = s;
                    },
                    datas: _dc1?.nameList?.sublist(1) ?? [""],
                  ),
                ),
                Expanded(
                  child: WheelView.integer(
                    itemSize: 32,
                    listHeight: 200.0,
                    selectTextStyle: select,
                    unSelectTextStyle: unSelect,
                    onValueChanged: (s) {
                      _initHour = s;
                    },
                    minValue: 0,
                    maxValue: 23,
                    initValue: _initHour,
                    controller: _hourController,
                  ),
                ),
                Text(
                  "时",
                  style: select,
                ),
                Expanded(
                  child: WheelView.integer(
                    itemSize: 32,
                    listHeight: 200.0,
                    selectTextStyle: select,
                    unSelectTextStyle: unSelect,
                    onValueChanged: (s) {
                      _initMinute = s;
                    },
                    minValue: 0,
                    maxValue: 59,
                    initValue: _initMinute,
                    controller: _minuteController,
                  ),
                ),
                Text(
                  "分",
                  style: select,
                ),
              ],
            ),
            Container(
              height: 1,
              constraints: BoxConstraints(minWidth: double.infinity),
              color: Colors.grey,
            ),
            Container(
              child: Text(
                "常用倒计时",
                style: select,
              ),
              padding: EdgeInsets.only(top: 24, left: 12, right: 12),
            ),
            InkWell(
              onTap: () {
                _initHour = 0;
                _initMinute = 15;
                _hourController.animateToItem(0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
                _minuteController.animateToItem(15,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              },
              child: Container(
                width: double.infinity,
                child: Text("15分钟"),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            lineLightGrey,
            InkWell(
              onTap: () {
                _initHour = 0;
                _initMinute = 30;
                _hourController.jumpToItem(1);
                _hourController.animateToItem(0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
                _minuteController.animateToItem(30,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              },
              child: Container(
                width: double.infinity,
                child: Text("30分钟"),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            lineLightGrey,
            InkWell(
              onTap: () {
                _initHour = 1;
                _initMinute = 0;
                _hourController.animateToItem(1,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
                _minuteController.animateToItem(0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              },
              child: Container(
                width: double.infinity,
                child: Text("1小时"),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            lineLightGrey,
            Expanded(child: Container()),
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              onTap: () {
                _save();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withAlpha(100)
                    ])),
                child: Text(
                  "启  动",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_dc1 == null) {
      showToast("无法获取到设备id");
      return;
    }
    int switchIndex =
        _switchName == null ? 0 : _dc1.nameList.indexOf(_switchName) - 1;
    var newStatus = _dc1.status.replaceRange(switchIndex, switchIndex + 1, "1");
    Api().setDeviceStatus(_dc1.id, newStatus, (onFailed) {
      showToast("开启$_switchName失败");
    });

    var dateTime = DateTime.now();
    DateTime targetTime =
        dateTime.add(Duration(hours: _initHour, minutes: _initMinute));
    PlanBean planBean = PlanBean()
      ..id = Uuid.randomUuid().toString()
      ..enable = true
      ..triggerTime = "${targetTime.hour}:${targetTime.minute}:00"
      ..deviceName = _dc1?.nameList[0] ?? _dc1.id.substring(_dc1.id.length - 4)
      ..repeat = PlanBean.REPEAT_ONCE
      ..deviceId = _dc1?.id
      ..command = "0"
      ..switchIndex = switchIndex.toString()
      ..repeatData = "";
    myPrint(planBean);
    Api().addPlan(planBean, (onSuccess) {
      Navigator.pop(context);
    }, (onFailed) {
      showToast("添加关闭任务失败，请手动关闭开关");
    });
  }
}
