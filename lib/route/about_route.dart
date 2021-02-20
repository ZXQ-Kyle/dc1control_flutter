import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageInfoModel extends ChangeNotifier {
  PackageInfo _packageInfo;

  PackageInfoModel() {
    PackageInfo.fromPlatform().then((value) {
      _packageInfo = value;
      notifyListeners();
    });
  }
}

// ignore: must_be_immutable
class AboutRoute extends StatelessWidget {
  PackageInfoModel _model = PackageInfoModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Scaffold(
        appBar: AppBar(
          title: Text("关于"),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 48),
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "img/icon.png",
                height: 100,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(top: 28),
                child: Consumer<PackageInfoModel>(builder: (context, model, child) {
                  return Text(
                    model._packageInfo?.version ?? "",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 32),
                child: Text(
                  "Dc1控制端",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    launch('https://github.com/ZXQ-Kyle/dc1control_flutter');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    width: double.infinity,
                    child: Text(
                      "控制端github地址：\nhttps://github.com/ZXQ-Kyle/dc1control_flutter",
                      style: TextStyle(fontSize: 14, height: 1.8),
                    ),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 8)),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    launch('https://github.com/ZXQ-Kyle/Dc1Server');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    width: double.infinity,
                    child: Text(
                      "服务端github地址：\nhttps://github.com/ZXQ-Kyle/Dc1Server",
                      style: TextStyle(fontSize: 14, height: 1.8),
                    ),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 8)),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    launch('https://github.com/ZXQ-Kyle/N1Script');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    width: double.infinity,
                    child: Text(
                      "安装脚本及说明：\nhttps://github.com/ZXQ-Kyle/N1Script",
                      style: TextStyle(fontSize: 14, height: 1.8),
                    ),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 8)),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    launch('https://hub.docker.com/r/ponyopapa/dc1_server');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    width: double.infinity,
                    child: Text(
                      "docker安装：\nhttps://hub.docker.com/r/ponyopapa/dc1_server",
                      style: TextStyle(fontSize: 14, height: 1.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
