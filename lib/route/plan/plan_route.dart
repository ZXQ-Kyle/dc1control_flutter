import 'dart:async';

import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/bean/plan_bean.dart';
import 'package:dc1clientflutter/common/global.dart';
import 'package:dc1clientflutter/net/api.dart';
import 'package:dc1clientflutter/common/funs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'item_plan_widget.dart';

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

  Future refresh() async {
    _data = await Api().queryPlanList(_dc1?.id);
    notifyListeners();
  }

  void delete(int index) {
    _data.removeAt(index);
    notifyListeners();
  }
}

class PlanRoute extends StatefulWidget {
  final Dc1 dc1;
  PlanRoute(this.dc1);

  @override
  _PlanRouteState createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  PlanModel _planModel;
  Timer _timer;

  @override
  void initState() {
    _planModel = PlanModel(widget.dc1)..refresh();
    _timer = Timer.periodic(Duration(seconds: Global.period), (timer) {
      _planModel.refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _planModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("计划列表"),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          child: Consumer<PlanModel>(builder: (context, planModel, child) {
            return ListView.builder(
                itemCount: planModel.count,
                itemBuilder: (context, index) {
                  return ItemPlanWidget(
                    planModel.data[index],
                    dc1: widget.dc1,
                  );
                });
          }),
          onRefresh: () => _planModel.refresh(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () =>
              Navigator.of(context).pushNamed(MyRoute.ADD_PLAN_ROUTE, arguments: _planModel._dc1),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
