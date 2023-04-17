import 'package:flutter/material.dart' show Colors, immutable;
import 'package:instagram_clone/extension/string/as_htm_color_to_colour.dart';

@immutable
class AppColor {
  const AppColor._();
  static final loginButtonColor = '#cfc9c2'.htmlColorToColor();
  static const loginButtonTextColor = Colors.black;
  static final googleColor = '#4285F4'.htmlColorToColor();
  static final facebookColor = '#3b5998'.htmlColorToColor();
}
