import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/plan_bean.dart';
import 'package:dc1clientflutter/common/api_service.dart';

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
    });
  }

  void setDeviceStatus(String deviceId, String status, OnFailed onFailed) {
    Map<String, String> map = {"deviceId": deviceId, "status": status};
    ApiService()
        .request("api/setDeviceStatus", params: map, onFailed: onFailed);
  }

  void updateDeviceName(String deviceId, List<String> nameList,
      OnSuccess onSuccess, OnFailed onFailed) {
    var reduce = nameList.reduce((value, element) => value + "," + element);
    Map<String, String> map = {"deviceId": deviceId, "names": reduce};
    ApiService().request("api/updateNames",
        params: map, onFailed: onFailed, onSuccess: onSuccess);
  }

  void resetPower(String deviceId, OnSuccess onSuccess, OnFailed onFailed) {
    ApiService().request("api/resetPower",
        params: {"deviceId": deviceId},
        onFailed: onFailed,
        onSuccess: onSuccess);
  }

  void queryPlanList(String deviceId, Function onSuccess) {
    ApiService().request("api/queryPlanList", params: {"deviceId": deviceId},
        onSuccess: (myResponse) {
      if (myResponse.data != null) {
        var list = (myResponse.data as List).map((e) {
          PlanBean planBean = PlanBean.fromJson(e);
          return planBean;
        }).toList();
        onSuccess(list);
      } else {
        onSuccess(null);
      }
    });
  }

  void enablePlan(String planId, bool enable, OnFailed onFailed) {
    ApiService().request("api/enablePlanById",
        params: {"planId": planId, "enable": enable.toString()},
        onFailed: onFailed);
  }
}
