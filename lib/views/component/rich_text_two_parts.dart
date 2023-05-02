import 'package:flutter/material.dart';

class RichTextTwoPart extends StatelessWidget {
  final String rigtPart;
  final String leftPart;
  const RichTextTwoPart({
    super.key,
    required this.rigtPart,
    required this.leftPart,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            height: 1.5,
          ),
          children: [
            TextSpan(
                text: leftPart,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            TextSpan(
              text: ' $rigtPart',
            ),
          ]),
    );
  }
}
