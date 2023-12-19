import 'package:flutter/animation.dart';

import 'package:flutter/material.dart';

class ColorManager {
  // on boarding screen background colors
  static List onboardingBackgroundColors = [
    HexColor.fromHex('#DAD3C8'),
    HexColor.fromHex('#FFE5DE'),
    HexColor.fromHex('#DCF6E6'),
  ];
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "0xFF$hexColorString";
    } else if (hexColorString.length == 8) {
      hexColorString = "0x$hexColorString";
    }
    return Color(int.parse(hexColorString));
  }
}
