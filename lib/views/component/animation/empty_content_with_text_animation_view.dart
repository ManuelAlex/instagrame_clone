import 'package:flutter/material.dart';
import 'package:instagram_clone/views/component/animation/empty_animation_view.dart';

class EmptyContentWithTextAnimationView extends StatelessWidget {
  const EmptyContentWithTextAnimationView({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white54,
                    ),
              ),
              const EmptyContentAnimationView(),
            ],
          ),
        ),
      ),
    );
  }
}
