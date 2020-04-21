import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dc1clientflutter/bean/response.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dio/dio.dart';

typedef OnSuccess = void Function(MyResponse myResponse);
typedef OnFailed = void Function(MyResponse myResponse);

class ApiService {
  //私有构造函数
  ApiService._internal();

  //保存单例
  static ApiService _singleton = new ApiService._internal();

  //工厂构造函数
  factory ApiService() => _singleton;

  String token;
  Dio _dio;

  void init() {
    if (Global.profile?.host == null) {
      return;
    }
    _dio = Dio(
      BaseOptions(
        baseUrl: Global.profile.host +
            ":" +
            Global.profile.httpPort.toString() +
            "/",
      ),
    );
    token = null;
//    if (Global.isRelease) {
    _dio.interceptors.add(LogInterceptor());
//    }
  }

  void request<T>(String path,
      {Map<String, String> params,
      OnSuccess onSuccess,
      OnFailed onFailed,
      CancelToken cancelToken,
      bool isPost = false,
      T body}) async {
    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }

    String errorMsg = "";
    int statusCode;
    try {
      Response response;
      //组合GET请求的参数
      if (params == null) {
        params = new Map();
      }
      params["token"] = getToken();

      if (isPost) {
        response = await _dio.post(
          path,
          data: body,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      } else {
        response = await _dio.get(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      }

      statusCode = response.statusCode;

      //处理错误部分
      if (statusCode != 200) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(onFailed, errorMsg);
        return;
      }

      if (onSuccess == null) {
        return;
      }

      var myResponse = MyResponse.fromJson(jsonDecode(response.data));
      if (myResponse.code == 200) {
        onSuccess(myResponse);
      } else {
        onFailed(myResponse);
      }
    } catch (e) {
      _handError(onFailed, e.toString());
    }
  }

  //处理异常
  void _handError(OnFailed errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(MyResponse(404, errorMsg, null));
    }
    print("<net> errorMsg :" + errorMsg);
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
