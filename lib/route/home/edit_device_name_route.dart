import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/net/api.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nav_router/nav_router.dart';

class EditDeviceNameRoute extends StatefulWidget {
  @override
  _EditDeviceNameRouteState createState() => _EditDeviceNameRouteState();
}

class _EditDeviceNameRouteState extends State<EditDeviceNameRoute> {
  @override
  Widget build(BuildContext context) {
    Dc1 dc1 = ModalRoute.of(context).settings.arguments;
    TextEditingController _powerStripNameController = TextEditingController(text: dc1.nameList[0]);
    TextEditingController _masterSwitchController = TextEditingController(text: dc1.nameList[1]);
    TextEditingController _firstSwitchController = TextEditingController(text: dc1.nameList[2]);
    TextEditingController _secondSwitchController = TextEditingController(text: dc1.nameList[3]);
    TextEditingController _thirdSwitchController = TextEditingController(text: dc1.nameList[4]);
    return Scaffold(
      appBar: AppBar(
        title: Text("编辑名称"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          var nameList = [
            _powerStripNameController.text,
            _masterSwitchController.text,
            _firstSwitchController.text,
            _secondSwitchController.text,
            _thirdSwitchController.text
          ];
          var httpResult = await Api().updateDeviceName(dc1.id, nameList);
          if (httpResult.success) {
            pop();
          } else {
            showToast("保存失败:${httpResult.message}");
          }
        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        constraints: BoxConstraints(minWidth: double.infinity),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "img/pic_dc1.png",
                  height: 80,
                ),
              ),
              buildTextField(_powerStripNameController, "插排名称："),
              buildTextField(_masterSwitchController, "总开关名称："),
              buildTextField(_firstSwitchController, "2号开关名称："),
              buildTextField(_secondSwitchController, "3号开关名称："),
              buildTextField(_thirdSwitchController, "4号开关名称："),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextField(TextEditingController _controller, String label) {
    return TextField(
      controller: _controller,
      style: TextStyle(fontSize: 16, height: 2),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
