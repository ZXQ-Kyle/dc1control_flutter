import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dc1clientflutter/common/event_bus.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/global.dart';

import 'log_util.dart';

///推送封装
class SocketManager {
  //私有构造函数
  SocketManager._internal();

  //保存单例
  static SocketManager _singleton = new SocketManager._internal();

  //工厂构造函数
  factory SocketManager() => _singleton;

  Socket _socket;

  void init() {
    myPrint("SocketManager init:" + Global.profile.toJson().toString());
    if (Global.profile?.host == null) {
      return;
    }
    Socket.connect(
            Global.profile?.host?.replaceAll(new RegExp("(https|http)://"), ""),
            Global.profile?.socketPort)
        .then((Socket sock) {
      _socket = sock;
      var stream = _socket.asBroadcastStream();
      stream.listen(onReceiver, onError: errorHandler, cancelOnError: false);
      heartBeat();
    }).catchError((e) {
      showToast("Unable to connect: $e");
    });
  }

  void reset() {
    if (_socket != null) {
      _socket.destroy();
      _socket = null;
    }
    init();
  }

  void onReceiver(List<int> data) {
    String decode = utf8.decode(data);
    if ("deviceChanged" == decode.trim()) {
      //重新获取设备列表
      myPrint("DeviceChangedEvent fire");
      eventBus.fire(DeviceChangedEvent());
    }
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void send(String message) {
    _socket?.write(message);
    _socket?.flush();
  }

  void heartBeat() {
    var duration = Duration(seconds: 30);
    Timer.periodic(duration, (Timer timer) {
      send("-");
    });
  }
}
