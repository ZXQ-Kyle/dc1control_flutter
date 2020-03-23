import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/state/change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ThemeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主题"),
      ),
      body: ListView(
        children: Global.themes.map<Widget>((color) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: 12, left: 12, right: 12),
              color: color,
              height: 40,
            ),
            onTap: () {
              print(color);
              Provider.of<ThemeModel>(context,listen: false).theme = color;
            },
          );
        }).toList(),
      ),
    );
  }
}
