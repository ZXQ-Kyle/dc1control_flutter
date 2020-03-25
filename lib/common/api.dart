import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/common/api_service.dart';
import 'package:dc1clientflutter/common/log_util.dart';

class Api {
  //私有构造函数
  Api._internal();

  //保存单例
  static Api _singleton = new Api._internal();

  //工厂构造函数
  factory Api() => _singleton;

  void queryDc1List(Function onSuccess) {
    ApiService().request("api/queryDeviceList", onSuccess: (myResponse) {
      if (myResponse.data != null) {
        var list = (myResponse.data as List).map((e) {
          var dc1 = Dc1.fromJson(e);
          return dc1;
        }).toList();
        onSuccess(list);
      } else {
        onSuccess(null);
      }
    }, onFailed: null);
  }
}
