//conver 0x?????? to #?????? to color
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/extension/string/remove_all.dart';

extension AsHtmColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(
            8,
            'ff',
          ),
          radix: 16,
        ),
      );
}
