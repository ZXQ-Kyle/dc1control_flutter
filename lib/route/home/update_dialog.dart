import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:ota_update/ota_update.dart';

class UpdateDialog extends StatefulWidget {
  final UpgradeInfo _upgradeInfo;

  UpdateDialog(this._upgradeInfo);

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    var upgradeInfo = widget._upgradeInfo;
    return AlertDialog(
      title: Text("版本更新"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(upgradeInfo.newFeature),
          _progress == 0 || _progress == 100
              ? Container()
              : Center(child: CircularProgressIndicator())
        ],
      ),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.pop(context), child: Text("取消")),
        FlatButton(
          onPressed: () {
            _download(upgradeInfo.apkUrl);
          },
          child: Text("更新"),
        )
      ],
    );
  }

  void _download(String url) {
    try {
      OtaUpdate().execute(url, destinationFilename: 'dc1Control.apk').listen(
        (OtaEvent event) {
          print('EVENT: ${event.status} : ${event.value}');
          if (event.status == OtaStatus.DOWNLOADING) {
            setState(() {
              _progress = 50;
            });
          } else if (event.status == OtaStatus.INSTALLING) {
            setState(() {
              _progress = 100;
            });
          }
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }
}
