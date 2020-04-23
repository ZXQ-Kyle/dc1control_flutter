import 'dart:io';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WifiConfigRoute extends StatefulWidget {
  @override
  _WifiConfigRouteState createState() => _WifiConfigRouteState();
}

class _WifiConfigRouteState extends State<WifiConfigRoute> {
  var _nameController = TextEditingController();
  var _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dc1网络配置"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  """1. 长按DC1电源键\n2. 连接wifi:PHI_PLUG1_xxxx\n3. 输入wifi名称和密码\n4. 点击配置按钮\n5. 收到配网成功的消息后插排会自动重启"""),
              Text(
                "注意：不支持5g网络",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.all(12),
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "wifi名称",
                  prefixIcon: Icon(Icons.wifi),
                ),
                style: TextStyle(fontSize: 18),
                controller: _nameController,
              ),
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "wifi密码",
                  prefixIcon: Icon(Icons.lock),
                ),
                style: TextStyle(fontSize: 18),
                controller: _pwdController,
              ),
              Container(
                padding: EdgeInsets.all(24),
              ),
              InkWell(
                splashColor: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                onTap: () {
                  _send(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withAlpha(100)
                      ])),
                  child: Text(
                    "配  置",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    String message =
        "{\"header\":\"phi-plug-0001\",\"uuid\":\"00010\",\"action\":\"wifi=\",\"auth\":\"\",\"params\":{\"ssid\":\"${_nameController.text}\",\"password\":\"${_pwdController.text}\"}}\n";

    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      socket.listen((event) {
        myPrint(event);
        if (event == RawSocketEvent.read) {
          var receive = socket.receive();
          if (receive?.data != null) {
            var receiveMessage = new String.fromCharCodes(receive?.data);
            if (receiveMessage != null && receiveMessage.isNotEmpty) {
              showToast("网络配置成功");
              socket.close();
              Navigator.pop(context);
            }
          }
        }
      }, onError: (e) {
        showToast("udp连接异常！${e.toString()}");
      }, onDone: () {}, cancelOnError: true);
      socket.timeout(Duration(seconds: 3));
      socket.send(message.codeUnits, InternetAddress("192.168.4.1"), 7550);
    });
  }
}
