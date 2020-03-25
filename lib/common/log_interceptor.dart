import 'package:dio/dio.dart';

import 'log_util.dart';

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
