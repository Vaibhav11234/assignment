import 'dart:math';

import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static Color white = Colors.white;
  static Color grey = Colors.grey.shade800;
  static Color primary = Colors.indigo.shade700;

  static final List<Color> _colorList = [
    Colors.indigo.shade700,
    Colors.red.shade700,
    Colors.lightGreen.shade700,
    Colors.amber.shade700,
  ];

  static Color get randomColor => _colorList[Random().nextInt(_colorList.length)];
}
