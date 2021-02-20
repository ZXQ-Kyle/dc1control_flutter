import 'dart:io';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/plan_bean.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/net/http_result.dart';
import 'package:dio/dio.dart';

import 'api_service.dart';

class Api {
  //私有构造函数
  Api._internal();

  //保存单例
  static Api _singleton = new Api._internal();

  //工厂构造函数
  factory Api() => _singleton;

  Future<List<Dc1>> queryDc1List() async {
    try {
      var response = await http.get('api/queryDeviceList');
      return response.data.map<Dc1>((e) => Dc1.fromJson(e)).toList();
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<HttpResult> setDeviceStatus(String deviceId, String status) async {
    try {
      Map<String, dynamic> map = {
        "deviceId": deviceId,
        "status": status,
      };
      await http.get('api/setDeviceStatus', queryParameters: map);
      return HttpResult.success();
    } catch (e) {
      logger.e(parseHttpError(e));
      return HttpResult.fail(message: parseHttpError(e));
    }
  }

  Future<HttpResult> updateDeviceName(String deviceId, List<String> nameList) async {
    try {
      var names;
      if (nameList?.isEmpty ?? true) {
      } else {
        names = nameList.reduce((value, element) => value + "," + element);
      }
      Map<String, String> map = {"deviceId": deviceId, "names": names};
      await http.get('api/updateNames', queryParameters: map);
      return HttpResult.success();
    } catch (e) {
      logger.e(parseHttpError(e));
      return HttpResult.fail(message: parseHttpError(e));
    }
  }

  Future<HttpResult> resetPower(String deviceId) async {
    try {
      await http.get('api/resetPower', queryParameters: {
        "deviceId": deviceId,
      });
      return HttpResult.success();
    } catch (e) {
      logger.e(parseHttpError(e));
      return HttpResult.fail(message: parseHttpError(e));
    }
  }

  Future<List<PlanBean>> queryPlanList(String deviceId) async {
    try {
      var response = await http.get('api/queryPlanList', queryParameters: {
        "deviceId": deviceId,
      });
      return response.data.map<PlanBean>((e) => PlanBean.fromJson(e)).toList();
    } catch (e) {
      logger.e(parseHttpError(e));
      return null;
    }
  }

  Future<HttpResult> enablePlan(String planId, bool enable) async {
    try {
      await http.get('api/enablePlanById', queryParameters: {
        "planId": planId,
        "enable": enable,
      });
      return HttpResult.success();
    } catch (e) {
      logger.e(parseHttpError(e));
      return HttpResult.fail(message: parseHttpError(e));
    }
  }

  Future<HttpResult> addPlan(PlanBean planBean) async {
    try {
      Options options = Options(contentType: ContentType.json.toString());
      await http.post('api/addPlan', data: planBean, options: options);
      return HttpResult.success();
    } catch (e) {
      logger.e(parseHttpError(e));
      return HttpResult.fail(message: parseHttpError(e));
    }
  }

  Future<HttpResult> deletePlan(String planId) async {
    try {
      await http.get('api/deletePlan', queryParameters: {
        "planId": planId,
      });
      return HttpResult.success();
    } catch (e) {
      logger.e(parseHttpError(e));
      return HttpResult.fail(message: parseHttpError(e));
    }
  }
}
