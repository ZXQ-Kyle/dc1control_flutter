import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/route/about_route.dart';
import 'package:dc1clientflutter/route/dc1_wifi_config_route.dart';
import 'package:dc1clientflutter/route/setting_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nav_router/nav_router.dart';

import '../../main.dart';
import '../period_setting_route.dart';
import '../theme_route.dart';

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
            leading: Icon(
              Icons.color_lens,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("主题"),
            onTap: () {
              pop();
              routePush(ThemeRoute());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("网络配置"),
            onTap: () {
              pop();
              routePush(WifiConfigRoute());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.timer,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("轮询周期"),
            onTap: () {
              pop();
              routePush(PeriodSettingRoute());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("服务器设置"),
            onTap: () {
              pop();
              routePush(SettingRoute());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("关于"),
            onTap: () {
              pop();
              routePush(AboutRoute());
            },
          ),
        ],
      );
    });
  }
}
