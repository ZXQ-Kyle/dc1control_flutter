import 'dart:async';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/common/api.dart';
import 'package:dc1clientflutter/common/event_bus.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/main.dart';
import 'package:dc1clientflutter/route/item_dc1_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  List<Dc1> _data;
  StreamSubscription<DeviceChangedEvent> _listener;

  @override
  void initState() {
    _listener = eventBus.on<DeviceChangedEvent>().listen((event) {
      initData();
      myPrint("DeviceChangedEvent _listener");
    });
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  void initData() {
    Api(context).queryDc1List().then((dc1List) {
      myPrint(dc1List.toString());
      if (dc1List != null) {
        setState(() {
          _data = dc1List;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: ListView.builder(
          itemCount: _data == null ? 0 : _data.length,
          itemBuilder: (BuildContext context, int index) {
            return Dc1ItemWidget(_data[index]);
          },
        ),
      ),
      drawer: MyDrawer(),
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
