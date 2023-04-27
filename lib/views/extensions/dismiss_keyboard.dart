import 'package:flutter/material.dart';

extension DismissKeyboard on Widget {
  void dismisskeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
