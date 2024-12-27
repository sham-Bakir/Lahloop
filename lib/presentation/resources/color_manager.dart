import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = const Color(0xFFFCB825);
  static Color primary1 = const Color(0xFF148F7B);
  static Color darkGrey = const Color(0xFF525252);
  static Color grey = const Color(0xFF737477);
  static Color lightGrey = const Color(0xFF9E9E9E);
  // we make all of them static so we don't have to create an instance to call them

  static Color darkPrimary = const Color.fromARGB(255, 16, 111, 95);
  static Color lightPrimary =
      const Color(0xCCD17D11); // orange with 80% capacity
  static Color grey1 = const Color(0xFF707070);
  static Color grey2 = const Color(0xFF797979);
  static Color white = const Color(0xFFFFFFFF);
  static Color error = const Color(0xFFE61F34);
}
