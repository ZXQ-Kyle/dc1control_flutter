import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarTip {
  BarTip.warning(
    BuildContext context,
    String message, {
    String title,
    Duration duration = const Duration(seconds: 4),
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      icon: Icon(
        Icons.warning,
        color: Colors.redAccent,
      ),
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
  }

  BarTip.notice(
    BuildContext context,
    String message, {
    String title,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      icon: Icon(
        Icons.notifications_none,
        color: Colors.orangeAccent,
      ),
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
  }

  BarTip.success(
    BuildContext context,
    String message, {
    String title,
    Duration duration = const Duration(seconds: 2),
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      icon: Icon(
        Icons.check,
        color: Colors.green,
      ),
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
  }
}
