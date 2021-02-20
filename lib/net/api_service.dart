import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/route/log_route.dart';
import 'package:dc1clientflutter/state/change_notifier.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

Http http = Http();

class Http extends DioForNative {
  Http() {
    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    init();
  }

  void init() {
    interceptors..add(ApiInterceptor())..add(LogInterceptor());
    options
      ..contentType = Headers.formUrlEncodedContentType
      ..baseUrl =
          (Global.profile?.host?.replaceAll(' ', '') ?? '') + ":" + Global.profile?.httpPort?.toString() + "/"
      ..sendTimeout = 20000
      ..receiveTimeout = 20000
      ..sendTimeout = 20000;
  }

  var token;

  String getToken() {
    if (token == null) {
      var content = new Utf8Encoder().convert(Global.profile.token);
      var digest = md5.convert(content);
      token = hex.encode(digest.bytes);
    }
    return token;
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    try {
      logger.d('--api-request-->url-->${DateTime.now()}--> ${options.baseUrl}${options.path}' +
          ' ->data:${(options.data as FormData)?.fields?.map<String>((e) => "${e.key}:${e.value}")?.toList()}');
    } catch (e) {}
    var queryParameters = options.queryParameters;
    if (queryParameters == null) {
      options.queryParameters = {'token': http.getToken()};
    } else {
      queryParameters['token'] = http.getToken();
    }
    return options;
  }

  @override
  onResponse(Response response) {
    logger.d('--api-response-->resp-->${DateTime.now()}-->${response.data}');
    ResponseData respData = ResponseData.fromJson(jsonDecode(response.data));
    if (respData.success) {
      response.data = respData.data;
      LogModel().add(type: LogType.success, log: 'http请求：${response.request.uri}\n服务端回复：${response.data}');
      return http.resolve(response);
    } else {
      throw NotSuccessException.fromRespData(respData);
    }
  }

  @override
  Future onError(DioError err) {
    LogModel().add(type: LogType.error, log: err.toString());

    ///拦截未验证异常，退出到登录页
    if (err.type == DioErrorType.RESPONSE && err.response.data is Map && err.response.data['code'] == 401) {}
    return super.onError(err);
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}

/// 子类需要重写
abstract class BaseResponseData {
  int code = 0;
  String message;
  dynamic data;

  bool get success;

  BaseResponseData({this.code, this.message, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $message, data: $data}';
  }
}

/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  String message;

  NotSuccessException.fromRespData(BaseResponseData respData) {
    message = respData.message;
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

String parseHttpError(dynamic e) {
  if (e is DioError) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.SEND_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT ||
        e.type == DioErrorType.RESPONSE ||
        e.type == DioErrorType.CANCEL) {
      // timeout
      try {
        var response = e.response;
        return response.data['message'];
      } catch (e) {
        return e.toString();
      }
    } else {
      // dio将原error重新套了一层
      try {
        String message = e?.error?.message?.toString();
        if (message?.isEmpty ?? true) {
          message = e?.error?.toString();
        }
        return message;
      } catch (e) {}
    }
  }
  return e.toString();
}
