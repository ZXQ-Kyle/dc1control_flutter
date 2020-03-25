import 'dart:convert';

import 'package:dc1clientflutter/bean/profile.dart';
import 'package:dc1clientflutter/common/api.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/common/socket.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

const _themes = <MaterialColor>[
  Colors.teal,
  Colors.green,
  Colors.blue,
  Colors.cyan,
  Colors.yellow,
  Colors.amber,
  Colors.deepOrange,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.grey,
];

class Global {
  static SharedPreferences _sp;

  static Profile profile;

  /// 可选的主题列表
  static List<MaterialColor> get themes {
    return _themes;
  }

  /// 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static init() async {
    _sp = await SharedPreferences.getInstance();
    var profileStr = _sp.get("profile");
    if (profileStr != null) {
      try {
        profile = Profile.fromJson(jsonDecode(profileStr));
        myPrint(profile.toJson().toString());
      } catch (e) {
        print(e);
      }
    } else {
      profile = Profile();
    }
    SocketManager().init();
    ApiService().init();
  }

  static saveProfile() {
    _sp.setString("profile", jsonEncode(profile.toJson()));
  }
}
