import 'package:dc1clientflutter/common/bar_tip.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PeriodSettingRoute extends StatefulWidget {
  PeriodSettingRoute({
    Key key,
  }) : super(key: key);

  @override
  _PeriodSettingRouteState createState() => _PeriodSettingRouteState();
}

class _PeriodSettingRouteState extends State<PeriodSettingRoute> {
  var _controller = TextEditingController(text: Global.period.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('轮询周期')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "轮询周期（单位：秒）",
                hintText: "默认5秒",
                prefixIcon: Icon(Icons.timer),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '配置将在下次启动时生效',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          if (_controller.text.isEmpty) {
            BarTip.warning(context, '轮询周期不可为空');
            return;
          }
          var result = int.tryParse(_controller.text) ?? 0;
          if (result < 5) {
            BarTip.warning(context, '轮询周期不可小于5秒');
            return;
          }
          Global.period = result;
          safePop();
        },
      ),
    );
  }
}
