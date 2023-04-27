import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart ' as material show Image;
import 'package:instagram_clone/state/image_upload/extensions/get_image_aspect_ratio.dart';

extension GetImageDataAspectRaio on Uint8List {
  Future<double> getAspectRatio() async {
    final image = material.Image.memory(this);
    return image.getAspectRatio();
  }
}
