import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/plan_bean.dart';
import 'package:dc1clientflutter/common/bar_tip.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:dc1clientflutter/net/api.dart';
import 'package:dc1clientflutter/route/plan/plan_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ItemPlanWidget extends StatefulWidget {
  final Dc1 dc1;
  final PlanBean item;

  ItemPlanWidget(
    this.item, {
    Key key,
    this.dc1,
  }) : super(key: key);

  @override
  _ItemPlanWidgetState createState() => _ItemPlanWidgetState();
}

class _ItemPlanWidgetState extends State<ItemPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var delete = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("删除定时"),
                actions: <Widget>[
                  FlatButton(onPressed: () => Navigator.pop(context, false), child: Text("取消")),
                  FlatButton(onPressed: () => Navigator.pop(context, true), child: Text("确定")),
                ],
              );
            });
        if (delete) {
          var httpResult = await Api().deletePlan(widget.item.id);
          if (httpResult.success) {
            Provider.of<PlanModel>(context, listen: false).data.remove(widget.item);
          } else {
            showToast("删除失败");
          }
        }
      },
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: widget.item.command == "0"
                          ? Color.fromARGB(10, 104, 180, 131)
                          : Color.fromARGB(10, 255, 100, 100)),
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  child: Text(
                    formatName(widget.dc1.nameList[int.parse(widget.item.switchIndex) + 1]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 12,
                        color: widget.item.command == "0"
                            ? Color.fromARGB(255, 104, 180, 131)
                            : Color.fromARGB(255, 255, 100, 100)),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("触发时间：${widget.item.triggerTime}"),
                      DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 12,
                            color: widget.item.command == "0"
                                ? Color.fromARGB(255, 104, 180, 131)
                                : Color.fromARGB(255, 255, 100, 100)),
                        child: Row(
                          children: <Widget>[
                            Text(widget.item.command == "0" ? "关" : "开"),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text("|"),
                            ),
                            SingleChildScrollView(
                              child: Text(
                                "周期：${getRepeatDesc(widget.item)}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                    value: widget.item.enable,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      widget.item.enable = value;
                      enablePlan(widget.item.id, value);
                    }),
              ],
            ),
            Container(
              color: Colors.grey[200],
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  String getRepeatDesc(PlanBean plan) {
    if (plan.repeat == null || plan.repeat.isEmpty || PlanBean.REPEAT_EVERYDAY == plan.repeat) {
      return "每天";
    }
    if (PlanBean.REPEAT_ONCE == plan.repeat) {
      return "一次";
    }
    if (PlanBean.REPEAT_AT_FIXED_RATE == plan.repeat) {
      var split = plan.repeatData.split(",");
      if (split.length != 2) {
        return "周期异常";
      }
      return "每${split[0]}分钟执行一次，每次${split[1]}分钟";
    }
    var split = plan.repeat.split(",");
    var reduce = split.map((e) => PlanBean.WEEK_DAY_CN[int.parse(e) - 1]).reduce((e0, e1) => e0 + "，" + e1);
    return "每" + reduce;
  }

  String formatName(String name) {
    if (name.length > 4) {
      name = name.substring(0, 4);
    } else if (name.length > 2) {
      name = name.replaceRange(2, 2, "\n");
    }
    return name;
  }

  enablePlan(String planId, bool enable) async {
    setState(() {
      widget.item.enable = enable;
    });
    var httpResult = await Api().enablePlan(planId, enable);
    if (httpResult.success) {
      BarTip.success(context, '设置成功');
    } else {
      BarTip.warning(context, '设置失败');
      setState(() {
        widget.item.enable = !enable;
      });
    }
  }
}
