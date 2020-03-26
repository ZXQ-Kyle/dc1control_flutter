import 'dart:io';

import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/route/home/edit_device_name_route.dart';
import 'package:dc1clientflutter/route/home/home_route.dart';
import 'package:dc1clientflutter/route/setting_route.dart';
import 'package:dc1clientflutter/route/theme_route.dart';
import 'package:dc1clientflutter/state/change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'common/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));

  /// Android状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    myPrint("MyApp build");
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
      ],
      child: Consumer<ThemeModel>(
          builder: (BuildContext context, ThemeModel themeModel, Widget child) {
        return MaterialApp(
          title: "dc1控制端",
          theme: ThemeData(primaryColor: themeModel.currentTheme),
          home: HomeRoute(),
          routes: {
            MyRoute.THEME_ROUTE: (context) => ThemeRoute(),
            MyRoute.SETTING_ROUTE: (context) => SettingRoute(),
            MyRoute.EDIT_DEVICE_NAME_ROUTE: (context) => EditDeviceNameRoute(),
          },
        );
      }),
    );
  }
}

class MyRoute {
  static const String THEME_ROUTE = "ThemeRoute";
  static const String SETTING_ROUTE = "SettingRoute";
  static const String EDIT_DEVICE_NAME_ROUTE = "EDIT_DEVICE_NAME_ROUTE";
}
