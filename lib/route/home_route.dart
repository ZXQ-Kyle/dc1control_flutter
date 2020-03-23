import 'package:dc1clientflutter/common/socket.dart';
import 'package:dc1clientflutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  void initState() {
    SocketManager().init();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => SocketManager().send("fab_press"),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
            onTap: ()=>Navigator.of(context).pushNamed(MyRoute.SETTING_ROUTE),
          ),
        ],
      );
    });
  }
}
