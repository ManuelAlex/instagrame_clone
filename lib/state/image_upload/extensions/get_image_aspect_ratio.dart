import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

extension GetImageAspectRatio on material.Image {
  Future<double> getAspectRatio() async {
    final completer = Completer<double>();
    image
        .resolve(
      const material.ImageConfiguration(),
    )
        .addListener(
      ImageStreamListener(
        (imageInfo, synchronousCall) {
          final aspectRatio = imageInfo.image.width / imageInfo.image.height;
          imageInfo.image.dispose();
          completer.complete(aspectRatio);
        },
      ),
    );
    return completer.future;
  }
}
