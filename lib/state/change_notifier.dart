import 'package:dc1clientflutter/common/global.dart';
import 'package:flutter/material.dart';

class ProfileChangeNotifier extends ChangeNotifier {

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

class ThemeModel extends ProfileChangeNotifier {
  ColorSwatch get currentTheme =>
      Global.themes.firstWhere((e) => e.value == Global.profile?.theme,
          orElse: () => Global.themes[0]);

  set theme(ColorSwatch color) {
    if (color != currentTheme) {
      Global.profile.theme = color[500].value;
      notifyListeners();
    }
  }
}
