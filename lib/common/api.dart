import 'dart:convert';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/response.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class Api {
  BuildContext context;
  Options _options;

  Api([this.context]) {
    _options = Options(extra: {"context": context});
  }

  static Dio dio = Dio(
    BaseOptions(
      baseUrl:
          Global.profile.host + ":" + Global.profile.httpPort.toString() + "/",
    ),
  );

  Future<List<Dc1>> queryDc1List() async {
    var token = base64Encode(utf8.encode(Global.profile.token));
    Response<dynamic> response = await dio.get<dynamic>(
      "api/queryDeviceList",
      queryParameters: {"token": "7e8d032b5bdeef54a13f8d6cf777bd99"},
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
    return null;
  }
}

class LogInterceptor extends Interceptor {
  @override
  Future onResponse(Response response) {
    myPrint(response.realUri.toString() + ":" + response.data.toString());
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    myPrint(err.response.realUri.toString() + " onError:" + err.message);
    return super.onError(err);
  }

  @override
  Future onRequest(RequestOptions options) {
    myPrint("${options.baseUrl}${options.path}");
    return super.onRequest(options);
  }
}
