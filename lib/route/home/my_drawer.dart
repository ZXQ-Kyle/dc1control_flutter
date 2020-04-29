import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';

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
            onTap: () => Navigator.of(context).pushNamed(MyRoute.THEME_ROUTE),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("设置"),
            onTap: () => Navigator.of(context).pushNamed(MyRoute.SETTING_ROUTE),
          ),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("网络配置"),
            onTap: () =>
                Navigator.of(context).pushNamed(MyRoute.WIFI_CONFIG_ROUTE),
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("关于"),
            onTap: () => Navigator.of(context).pushNamed(MyRoute.ABOUT_ROUTE),
          ),
        ],
      );
    });
  }
}
