import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class PackageInfoModel extends ChangeNotifier {
  PackageInfo _packageInfo;

  PackageInfoModel() {
    PackageInfo.fromPlatform().then((value) {
      _packageInfo = value;
      notifyListeners();
    });
  }
}

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
                height: 80,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(top: 28),
                child: Consumer<PackageInfoModel>(builder: (context, model, child) {
                  return Text(model._packageInfo?.version ?? "");
                }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 32),
                child: Text(
                  "Dc1控制端",
                  style: TextStyle(fontSize: 20),
                ),
              ),
//              Ink(
//                color: Colors.white,
//                child: InkWell(
//                  onTap: () {},
//                  child: Container(
//                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                    width: double.infinity,
//                    child: Text("github地址"),
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
