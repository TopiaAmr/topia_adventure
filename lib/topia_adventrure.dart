import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:topia_adventure/levels/level.dart';

/// The main game class for Topia Adventure.
/// Extends the FlameGame class.
class TopiaAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xff211f30);

  /// Camera component for the game.
  late final CameraComponent cam;

  /// Level object for the game.
  final Level level = Level('Level-02');

  @override
  FutureOr<void> onLoad() async {
    // Load all the required images.
    await images.loadAllImages();

    // Initialize the camera component with a fixed resolution.
    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 350,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    // Add the camera and level components to the game.
    addAll([cam, level]);

    // Call the parent onLoad method.
    return super.onLoad();
  }
}
