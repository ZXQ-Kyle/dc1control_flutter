import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/common/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingRoute extends StatefulWidget {
  @override
  _SettingRouteState createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  TextEditingController _hostController =
      TextEditingController(text: Global.profile.host);
  TextEditingController _socketPortController =
      TextEditingController(text: Global.profile.socketPort.toString());
  TextEditingController _httpPortController =
      TextEditingController(text: Global.profile.httpPort.toString());
  TextEditingController _tokenController =
      TextEditingController(text: Global.profile.token);

  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        constraints: BoxConstraints(
            minWidth: double.infinity, minHeight: double.infinity),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _hostController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "服务器地址",
                  hintText: "例如:192.168.1.1",
                  prefixIcon: Icon(Icons.desktop_mac),
                ),
                validator: (value) {
                  return value.length > 0 ? null : "请输入服务器地址";
                },
              ),
              TextFormField(
                controller: _socketPortController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "推送端口",
                  hintText: "默认8800",
                  prefixIcon: Icon(Icons.pages),
                ),
                validator: (value) {
                  return value.length > 0 ? null : "请输入推送端口";
                },
              ),
              TextFormField(
                controller: _httpPortController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Http端口",
                  hintText: "默认8880",
                  prefixIcon: Icon(Icons.send),
                ),
                validator: (value) {
                  return value.length > 0 ? null : "请输入Http端口";
                },
              ),
              TextFormField(
                controller: _tokenController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "token",
                  hintText: "默认dc1server",
                  prefixIcon: Icon(Icons.strikethrough_s),
                ),
                validator: (value) {
                  return value.length > 0 ? null : "请输入token";
                },
              ),
              RaisedButton(
                child: Text("保存"),
                textColor: Theme.of(context).primaryTextTheme.title.color,
                color: Theme.of(context).primaryColor,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if ((_formKey.currentState as FormState).validate()) {
      if (!_hostController.text.startsWith("http://") ||
          !_hostController.text.startsWith("https://")) {
        Global.profile.host = "http://${_hostController.text}";
      } else {
        Global.profile.host = _hostController.text;
      }
      Global.profile.socketPort = int.parse(_socketPortController.text);
      Global.profile.httpPort = int.parse(_httpPortController.text);
      Global.profile.token = _tokenController.text;
      Global.saveProfile();
      myPrint(Global.profile.toJson().toString());
      SocketManager().reset();
      Navigator.of(context).pop();
    } else {
      showToast("输入异常！");
    }
  }
}
