import 'dart:convert';

import 'package:dc1clientflutter/bean/profile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Logger logger = Logger(
  printer: PrefixPrinter(PrettyPrinter(colors: true)),
);

class Global {
  static const keyPeriod = 'period';

  static SharedPreferences _sp;

  static Profile profile;

  /// 可选的主题列表
  static List<MaterialColor> get themes {
    return _themes;
  }

  ///http轮询间隔，单位秒
  static int _period = 5;

  /// 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
    var profileStr = _sp.get("profile");
    if (profileStr != null) {
      try {
        profile = Profile.fromJson(jsonDecode(profileStr));
      } catch (e) {
        print(e);
      }
    }

    if (profile == null) {
      profile = Profile();
    }

    _period = _sp.getInt(keyPeriod);
    if (_period == null) {
      _period = 5;
    }
  }

  static int get period => _period;

  static set period(int value) {
    _period = value;
    _sp.setInt(keyPeriod, value);
  }

  static saveProfile() {
    _sp.setString("profile", jsonEncode(profile.toJson()));
  }
}
