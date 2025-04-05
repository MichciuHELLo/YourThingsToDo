import 'package:flutter/material.dart';

class LanguageInheritedWidget extends InheritedWidget {
  final int languageIndex;
  final String appColor;
  final Function(int) updateLanguage;
  final Function(String) updateAppColor;

  const LanguageInheritedWidget({
    super.key,
    required this.languageIndex,
    required this.updateLanguage,
    required this.appColor,
    required this.updateAppColor,
    required super.child,
  });

  @override
  bool updateShouldNotify(LanguageInheritedWidget oldWidget) {
    print("A co to za gowno?");
    return oldWidget.languageIndex != languageIndex;
  }

  static LanguageInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageInheritedWidget>();
  }
}