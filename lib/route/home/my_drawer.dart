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
