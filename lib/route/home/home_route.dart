import 'dart:async';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/common/api.dart';
import 'package:dc1clientflutter/common/event_bus.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/log_util.dart';
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
  List<Dc1> _list;
  StreamSubscription<DeviceChangedEvent> _listener;

  DeviceListModel() {
    _listener = eventBus.on<DeviceChangedEvent>().listen((value) {
      myPrint("home_route.dart 21:DeviceListModel()");
      refresh();
    });
    myPrint("home_route.dart 24:DeviceListModel()");
    refresh();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  Future<void> refresh() {
    Api().queryDc1List((value) {
      _list = value;
      notifyListeners();
    });
    return null;
  }

  void setDeviceStatus(String id, String status) {
    Api().setDeviceStatus(id, status, (value) {
      showToast("状态切换失败");
      myPrint("home_route.dart 45:setDeviceStatus()");
      refresh();
    });
  }

  get data {
    return _list;
  }

  get count {
    return _list == null ? 0 : _list.length;
  }
}

class HomeRoute extends StatefulWidget {
  final DeviceListModel _deviceListModel = DeviceListModel();

  @override
  HomeRouteState createState() {
    return HomeRouteState();
  }
}

class HomeRouteState extends State<HomeRoute> {
  bool _unchecked = true;

  @override
  Widget build(BuildContext context) {
    checkUpdate(context);
    myPrint("HomeRouteState build");
    return ChangeNotifierProvider.value(
      value: widget._deviceListModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("设备列表"),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withAlpha(150)
            ])),
          ),
        ),
        body: RefreshIndicator(
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Consumer<DeviceListModel>(
              builder: (context, deviceListModel, child) {
                return ListView.builder(
                  itemCount: deviceListModel.count,
                  itemBuilder: (BuildContext context, int index) {
                    return Dc1ItemWidget(deviceListModel.data[index]);
                  },
                );
              },
            ),
          ),
          onRefresh: () async => widget._deviceListModel.refresh(),
        ),
        drawer: MyDrawer(),
      ),
    );
  }

  void checkUpdate(BuildContext context) {
    if (_unchecked) {
      _unchecked = false;
      FlutterBugly.getUpgradeInfo().then((value) async {
        if (value == null) {
          myPrint("------FlutterBugly.getUpgradeInfo() == null-------");
          value =
              await FlutterBugly.checkUpgrade(isSilence: true, useCache: false);
          if (value == null) {
            myPrint("------FlutterBugly.checkUpgrade() == null-------");
            return;
          }
        }

        var packageInfo = await PackageInfo.fromPlatform();
        myPrint(packageInfo.buildNumber);
        if (value.versionCode > int.parse(packageInfo.buildNumber)) {
          bool isGranted = await Permission.storage.request().isGranted;
          myPrint(packageInfo.buildNumber);
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
}
