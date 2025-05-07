import 'package:flutter/material.dart';

import 'menu_screen_controller.dart';

@immutable
class MenuModel {
  final MenuItemEnum menuItemEnum;
  final String title;
  final bool showSwitch;
  final bool switchValue;
  final String stringValue;

  const MenuModel({
    required this.menuItemEnum,
    required this.title,
    required this.showSwitch,
    this.switchValue = false,
    this.stringValue = "",
  });
}
