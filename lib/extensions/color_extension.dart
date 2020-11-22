import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get appBarColor => const Color.fromARGB(255, 76, 175, 80);

  Color get ligTitleBackGroundColor => const Color.fromARGB(255, 124, 179, 66);

  Color get info => const Color(0xFF17a2b8);

  Color get warning => const Color(0xFFffc107);

  Color get danger => const Color(0xFFdc3545);

  Color get lila => HexColor("#C8A2C8");

  ///Custom Container Colors:
  Color get customBrown => HexColor("#8d6641");

  Color get customBlue => HexColor("#719df1");

  Color get customRed=> HexColor("#ff1744");

  Color get customGreen=> HexColor("#43a047");

  Color get customDarkPurple => HexColor("#42376e");

  Color get customOrange => HexColor("#ff8f00");

  List<Color> get allFolderColor {
    final List<Color> allFolderColor = [
      customBrown,
      customRed,
      customGreen,
      customDarkPurple,
      customOrange,
    ];

    return allFolderColor;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
