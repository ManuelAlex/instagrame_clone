import 'package:flutter/material.dart' show immutable, Image;

@immutable
class ImageWithAspecRatio {
  final Image image;
  final double aspectRatio;

  const ImageWithAspecRatio({
    required this.image,
    required this.aspectRatio,
  });
}
