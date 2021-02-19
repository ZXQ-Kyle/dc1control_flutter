import 'dart:async';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/common/bar_tip.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/net/api.dart';
import 'package:dc1clientflutter/common/event_bus.dart';
import 'package:dc1clientflutter/common/funs.dart';

import 'package:dc1clientflutter/route/home/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'item_dc1_widget.dart';
import 'my_drawer.dart';

class DeviceListModel extends ChangeNotifier {
  List<Dc1> list;

  DeviceListModel() {
    refresh();
  }

  Future<void> refresh() async {
    list = await Api().queryDc1List();
    notifyListeners();
  }

  void setDeviceStatus(String id, String status) async {
    var httpResult = await Api().setDeviceStatus(id, status);
    if (httpResult.success) {
      showToast('设置成功');
    } else {
      showToast('切换失败：${httpResult.message}');
    }
  }
}

class HomeRoute extends StatefulWidget {
  @override
  HomeRouteState createState() {
    return HomeRouteState();
  }
}

class HomeRouteState extends State<HomeRoute> {
  final DeviceListModel _deviceListModel = DeviceListModel();
  Timer _timer;

  @override
  void initState() {
    checkUpdate(context);
    _timer = Timer.periodic(Duration(seconds: Global.period), (timer) {
      _deviceListModel.refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _deviceListModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("设备列表"),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withAlpha(150)],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => _deviceListModel.refresh(),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Consumer<DeviceListModel>(
              builder: (context, deviceListModel, child) {
                return ListView.builder(
                  itemCount: deviceListModel.list?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Dc1ItemWidget(deviceListModel.list[index]);
                  },
                );
              },
            ),
          ),
        ),
        drawer: MyDrawer(),
      ),
    );
  }

  void checkUpdate(BuildContext context) {
    FlutterBugly.getUpgradeInfo().then((value) async {
      if (value == null) {
        value = await FlutterBugly.checkUpgrade(isSilence: true, useCache: false);
        if (value == null) {
          return;
        }
      }

      var packageInfo = await PackageInfo.fromPlatform();
      if (value.versionCode > int.parse(packageInfo.buildNumber)) {
        bool isGranted = await Permission.storage.request().isGranted;
        if (isGranted) {
          showDialog(
              context: context,
              builder: (context) {
                return UpdateDialog(value);
              });
        }
      }
    });
  }
}
