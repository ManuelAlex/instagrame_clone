import 'dart:async';

import 'package:flutter/material.dart';

import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/loading/loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    String text = Strings.loading,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    }
    _controller = showOverLay(
      context: context,
      text: text,
    );
  }

  void hide() {
    _controller?.close();
    _controller == null;
  }

  LoadingScreenController? showOverLay({
    required BuildContext context,
    required String text,
  }) {
    final state = Overlay.of(context);
    if (!state.mounted) {
      return null;
    }

    final textController = StreamController<String>();
    textController.add(text);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.8,
              maxHeight: size.height * 0.8,
              minWidth: size.width * 0.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    StreamBuilder<String>(
                        stream: textController.stream,
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            return Text(
                              snapShot.requireData,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                  ),
                            );
                          }
                          return const SizedBox();
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    state.insert(overlay);
    return LoadingScreenController(close: () {
      textController.close();
      overlay.remove();
      return true;
    }, update: (text) {
      textController.add(text);
      return true;
    });
  }
}
