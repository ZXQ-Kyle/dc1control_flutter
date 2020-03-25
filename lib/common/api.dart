import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/response.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class Api {
  BuildContext context;
  Options _options;

  Api([this.context]) {
    _options = Options(extra: {"context": context});
  }

  static String token;
  static Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: Global.profile.host +
            ":" +
            Global.profile.httpPort.toString() +
            "/",
      ),
    );
    token = null;
    dio.interceptors.add(LogInterceptor());
  }

  Future<List<Dc1>> queryDc1List() async {
    try {
      Response<dynamic> response = await dio.get<dynamic>(
        "api/queryDeviceList",
        queryParameters: {"token": getToken()},
        options: _options,
      );
      var myResponse = MyResponse.fromJson(jsonDecode(response.data));
      if (myResponse.code == 200) {
        var list = (myResponse.data as List).map((e) {
          var dc1 = Dc1.fromJson(e);
          return dc1;
        }).toList();
        return list;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  String getToken() {
    if (token == null) {
      var content = new Utf8Encoder().convert(Global.profile.token);
      var digest = md5.convert(content);
      // 这里其实就是 digest.toString()
      token = hex.encode(digest.bytes);
    }
    return token;
  }
}
