import 'dart:io';

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
import 'package:nav_router/nav_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'common/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBugly.postCatchedException(() => Global.init().then((value) => runApp(MyApp())));
  FlutterBugly.init(
    androidAppId: "2c489a8155",
    autoDownloadOnWifi: true,
  );

  /// Android状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
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
      child: Consumer2<ThemeModel, HostModel>(
          builder: (BuildContext context, ThemeModel themeModel, HostModel hostModel, Widget child) {
        return MaterialApp(
          title: "dc1控制端",
          theme: ThemeData(primaryColor: themeModel.currentTheme),
          navigatorKey: navGK,
          home: HomeRoute(),
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus.unfocus();
                }
              },
              child: child,
            );
          },
          routes: {
            MyRoute.EDIT_DEVICE_NAME_ROUTE: (context) => EditDeviceNameRoute(),
            MyRoute.ADD_PLAN_ROUTE: (context) => AddPlanRoute(),
            MyRoute.COUNT_DOWN_ROUTE: (context) => CountDownRoute(),
          },
        );
      }),
    );
  }
}

class MyRoute {
  static const String EDIT_DEVICE_NAME_ROUTE = "EditDeviceNameRoute";
  static const String ADD_PLAN_ROUTE = "AddPlanRoute";
  static const String COUNT_DOWN_ROUTE = "CountDownRoute";
}
