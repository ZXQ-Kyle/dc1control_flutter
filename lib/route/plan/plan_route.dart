import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/plan_bean.dart';
import 'package:dc1clientflutter/common/api.dart';
import 'package:dc1clientflutter/common/log_util.dart';
import 'package:dc1clientflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PlanModel extends ChangeNotifier {
  List<PlanBean> _data;

  Dc1 _dc1;

  PlanModel(this._dc1);

  int get count {
    return _data?.length ?? 0;
  }

  List<PlanBean> get data {
    return _data ?? List();
  }

  set data(List<PlanBean> list) {
    _data = list;
  }

  Future<void> refresh() {
    Api().queryPlanList(_dc1?.id, (onSuccess) {
      _data = onSuccess;
      notifyListeners();
    });
    return null;
  }

  enablePlan(String planId, bool enable) {
    Api().enablePlan(planId, enable, (onFailed) => refresh());
    notifyListeners();
  }
}

class PlanRoute extends StatefulWidget {
  @override
  _PlanRouteState createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  PlanModel _planModel;
  Dc1 _dc1;

  @override
  Widget build(BuildContext context) {
    _dc1 = ModalRoute.of(context).settings.arguments;
    _planModel = PlanModel(_dc1)..refresh();
    return ChangeNotifierProvider.value(
      value: _planModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("计划列表"),
        ),
        body: RefreshIndicator(
            child: Consumer<PlanModel>(builder: (context, planModel, child) {
              return ListView.builder(
                  itemCount: planModel.count,
                  itemBuilder: (context, index) {
                    return planWidget(index);
                  });
            }),
            onRefresh: () => _planModel.refresh()),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () =>
              Navigator.of(context).pushNamed(MyRoute.ADD_PLAN_ROUTE),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget planWidget(int index) {
    var plan = _planModel._data[index];
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: plan.command == "0"
                        ? Color.fromARGB(10, 104, 180, 131)
                        : Color.fromARGB(10, 255, 100, 100)),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                alignment: Alignment.center,
                width: 40,
                height: 40,
                child: Text(
                  formatName(_dc1.nameList[int.parse(plan.switchIndex)]),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 12,
                      color: plan.command == "0"
                          ? Color.fromARGB(255, 104, 180, 131)
                          : Color.fromARGB(255, 255, 100, 100)),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("触发时间：${plan.triggerTime}"),
                    DefaultTextStyle(
                      style: TextStyle(
                          fontSize: 12,
                          color: plan.command == "0"
                              ? Color.fromARGB(255, 104, 180, 131)
                              : Color.fromARGB(255, 255, 100, 100)),
                      child: Row(
                        children: <Widget>[
                          Text(plan.command == "0" ? "关" : "开"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text("|"),
                          ),
                          Text("周期：${getRepeatDesc(plan)}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                  value: plan.enable,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    plan.enable = value;
                    _planModel.enablePlan(plan.id + "55", value);
                  }),
            ],
          ),
          Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ],
      ),
    );
  }

  String formatName(String name) {
    if (name.length > 4) {
      name = name.substring(0, 4);
    } else if (name.length > 2) {
      name = name.replaceRange(2, 2, "\n");
    }
    myPrint(name);
    return name;
  }

  String getRepeatDesc(PlanBean plan) {
    if (plan.repeat == null ||
        plan.repeat.isEmpty ||
        PlanBean.REPEAT_EVERYDAY == plan.repeat) {
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
    var reduce = split
        .map((e) => PlanBean.WEEK_DAY_CN[int.parse(e) - 1])
        .reduce((e0, e1) => e0 + "，" + e1);
    return "每" + reduce;
  }
}
