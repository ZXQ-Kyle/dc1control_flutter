import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LogModel with ChangeNotifier {
//私有构造函数
  LogModel._internal();

//保存单例
  static LogModel _singleton = new LogModel._internal();

//工厂构造函数
  factory LogModel() => _singleton;

  List<_LogBean> logList = [];

  void add({String log, LogType type}) {
    logList.insert(
        0,
        _LogBean(
          time: DateFormat('yyyy年MM月dd日 HH:mm:ss').format(DateTime.now()),
          log: log,
          logType: type,
        ));
    if (logList.length > 40) {
      logList.removeRange(40, logList.length);
    }
    notifyListeners();
  }
}

class _LogBean {
  final String log;
  final String time;
  final LogType logType;

  _LogBean({this.log, this.time, this.logType});
}

enum LogType {
  success,
  error,
}

///日志页面，主要输出网络请求的数据
class LogRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日志'),
      ),
      body: ChangeNotifierProvider.value(
        value: LogModel(),
        child: Consumer<LogModel>(
          builder: (ctx, model, child) {
            return ListView.builder(
              itemCount: model.logList.length,
              itemBuilder: (ctx, index) {
                var bean = model.logList[index];
                return Container(
                  color: index % 2 == 0 ? Colors.white : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bean.time}',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 8)),
                      Text(
                        '${bean.log}',
                        style: TextStyle(
                          color: bean.logType == LogType.error ? Colors.red : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
