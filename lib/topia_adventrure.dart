import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:topia_adventure/levels/level.dart';

class TopiaAdventrue extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xff211f30);

  late final CameraComponent cam;
  final Level level = Level('Level-02');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 350,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, level]);
    return super.onLoad();
  }
}
