import 'dart:async';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/common/api.dart';
import 'package:dc1clientflutter/common/event_bus.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'item_dc1_widget.dart';

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

  void refresh() {
    Api().queryDc1List((value) {
      myPrint(value);
      _list = value;
      notifyListeners();
    });
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

class HomeRoute extends StatelessWidget {
  final DeviceListModel _deviceListModel = DeviceListModel();

  Widget build(BuildContext context) {
    myPrint("HomeRoute build");
    return ChangeNotifierProvider.value(
      value: _deviceListModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("设备列表"),
        ),
        body: Container(
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
        drawer: MyDrawer(),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            Expanded(child: _buildMenus()), // 构建抽屉菜单
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    return Image.asset(
      "img/head.jpg",
      height: 180,
      fit: BoxFit.cover,
    );
  }

  _buildMenus() {
    return Builder(builder: (context) {
      return ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text("主题"),
            onTap: () => Navigator.of(context).pushNamed(MyRoute.THEME_ROUTE),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text("设置"),
            onTap: () => Navigator.of(context).pushNamed(MyRoute.SETTING_ROUTE),
          ),
        ],
      );
    });
  }
}
