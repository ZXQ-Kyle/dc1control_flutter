import 'dart:io';

import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/route/about_route.dart';
import 'package:dc1clientflutter/route/dc1_wifi_config_route.dart';
import 'package:dc1clientflutter/route/home/edit_device_name_route.dart';
import 'package:dc1clientflutter/route/home/home_route.dart';
import 'package:dc1clientflutter/route/plan/add_plan_route.dart';
import 'package:dc1clientflutter/route/plan/count_down_route.dart';
import 'package:dc1clientflutter/route/plan/plan_route.dart';
import 'package:dc1clientflutter/route/setting_route.dart';
import 'package:dc1clientflutter/route/theme_route.dart';
import 'package:dc1clientflutter/state/change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'common/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBugly.postCatchedException(
      () => Global.init().then((value) => runApp(MyApp())));
  FlutterBugly.init(
    androidAppId: "2c489a8155",
    autoDownloadOnWifi: true,
  );

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

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: HostModel()),
      ],
      child: Consumer2<ThemeModel, HostModel>(builder: (BuildContext context,
          ThemeModel themeModel, HostModel hostModel, Widget child) {
        return MaterialApp(
          title: "dc1控制端",
          theme: ThemeData(primaryColor: themeModel.currentTheme),
          home: AboutRoute(),
          routes: {
            MyRoute.THEME_ROUTE: (context) => ThemeRoute(),
            MyRoute.SETTING_ROUTE: (context) => SettingRoute(),
            MyRoute.EDIT_DEVICE_NAME_ROUTE: (context) => EditDeviceNameRoute(),
            MyRoute.PLAN_ROUTE: (context) => PlanRoute(),
            MyRoute.ADD_PLAN_ROUTE: (context) => AddPlanRoute(),
            MyRoute.COUNT_DOWN_ROUTE: (context) => CountDownRoute(),
            MyRoute.WIFI_CONFIG_ROUTE: (context) => WifiConfigRoute(),
            MyRoute.ABOUT_ROUTE: (context) => AboutRoute(),
          },
        );
      }),
    );
  }
}

class MyRoute {
  static const String THEME_ROUTE = "ThemeRoute";
  static const String SETTING_ROUTE = "SettingRoute";
  static const String EDIT_DEVICE_NAME_ROUTE = "EditDeviceNameRoute";
  static const String PLAN_ROUTE = "PlanRoute";
  static const String ADD_PLAN_ROUTE = "AddPlanRoute";
  static const String COUNT_DOWN_ROUTE = "CountDownRoute";
  static const String WIFI_CONFIG_ROUTE = "WifiConfigRoute";
  static const String ABOUT_ROUTE = "AboutRoute";
}
