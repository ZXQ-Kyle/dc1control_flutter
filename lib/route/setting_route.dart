import 'dart:convert';

import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/net/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nav_router/nav_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bean/server_config.dart';

class SettingRoute extends StatefulWidget {
  @override
  _SettingRouteState createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  TextEditingController _hostController = TextEditingController(text: Global.profile?.host ?? '');
  TextEditingController _httpPortController =
      TextEditingController(text: (Global.profile?.httpPort ?? "").toString());
  TextEditingController _tokenController = TextEditingController(text: Global.profile?.token ?? '');

  GlobalKey _formKey = GlobalKey<FormState>();

  List<ServerConfig> _historyList;

  @override
  void initState() {
    getHistory();
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
        constraints: BoxConstraints(minWidth: double.infinity, minHeight: double.infinity),
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
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  child: Text("保存"),
                  textColor: Theme.of(context).primaryTextTheme.title.color,
                  color: Theme.of(context).primaryColor,
                  onPressed: _save,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _historyList?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      var config = _historyList[index];
                      return _buildItem(config);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(ServerConfig config) {
    return InkWell(
      onTap: () {
        _hostController.text = config.host;
        _httpPortController.text = config.httpPort.toString();
        _tokenController.text = config.token;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Text('host:  ${config.host}\nhttpPort:  ${config.httpPort}'),
      ),
    );
  }

  void _save() {
    if ((_formKey.currentState as FormState).validate()) {
      var _host = _hostController.text;
      if (_host.startsWith("http")) {
        Global.profile.host = _host;
      } else {
        Global.profile.host = "http://$_host";
      }
      Global.profile.httpPort = int.tryParse(_httpPortController.text) ?? 8880;
      Global.profile.token = _tokenController.text;
      Global.saveProfile();
      http = Http();
      saveHistory();
      pop();
    } else {
      showToast("输入异常！");
    }
  }

  void getHistory() async {
    var sp = await SharedPreferences.getInstance();
    var string = sp.getString('history');
    if (string == null) {
      return;
    }
    var json = jsonDecode(string);
    if (json is List) {
      _historyList = json.map((e) => ServerConfig.fromJson(e)).toList();
      setState(() {});
    }
  }

  void saveHistory() async {
    var profile = Global.profile;
    if (_historyList == null) {
      _historyList = [];
    }
    _historyList.add(ServerConfig(profile.host, profile.socketPort, profile.httpPort, profile.token));
    if (_historyList.length > 5) {
      _historyList.removeAt(0);
    }
    var sp = await SharedPreferences.getInstance();
    sp.setString('history', jsonEncode(_historyList));
  }
}
