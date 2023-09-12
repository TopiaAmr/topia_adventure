import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:topia_adventure/components/player.dart';
import 'package:topia_adventure/components/level.dart';

/// The main game class for Topia Adventure.
/// Extends the FlameGame class.
class TopiaAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xff211f30);

  /// Camera component for the game.
  late final CameraComponent cam;

  /// The player instance.
  Player player = Player(characterName: "Mask Dude");

  /// This class represents a joystick component.
  late JoystickComponent joystickComponent;

  /// A flag to determine whether to show the joystick.
  bool showJoyStick = !kIsWeb;
  @override
  FutureOr<void> onLoad() async {
    // Load all the required images.
    await images.loadAllImages();

    // Create a new Level instance.
    final Level level = Level(
      levelName: 'Level-02',
      player: player,
    );

    // Initialize the camera component with a fixed resolution.
    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 350,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    // Add the camera and level components to the game.
    await addAll([cam, level]);

    // Adding JoyStick
    if (showJoyStick) {
      await addJoyStick();
    }
    // Call the parent onLoad method.
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoyStick) {
      updateJoystick();
    }
    super.update(dt);
  }

  /// Adds a joystick to the screen.
  ///
  /// The joystick consists of a knob and a background sprite.
  /// The knob sprite represents the movable part of the joystick,
  /// while the background sprite represents the stationary part.
  ///
  /// The joystick is positioned at the bottom left corner of the screen,
  /// with a margin of 32 pixels from the bottom and left edges.
  ///
  /// This method is asynchronous and returns a Future<void>.
  FutureOr<void> addJoyStick() async {
    // Create the knob sprite component
    joystickComponent = JoystickComponent(
      knob: SpriteComponent(
        // Load the knob sprite from the cache
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        // Load the background sprite from the cache
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      // Set the margin of the joystick
      margin: const EdgeInsets.only(
        bottom: 32,
        left: 32,
      ),
    );

    // Add the joystick component to the screen
    await add(joystickComponent);
  }

  /// Updates the player's direction based on the joystick component's direction.
  void updateJoystick() {
    switch (joystickComponent.direction) {
      // If the joystick is pointing right or any diagonal direction that includes right,
      // set the player's direction to right.
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;

      // If the joystick is pointing left or any diagonal direction that includes left,
      // set the player's direction to left.
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;

      // If the joystick is not pointing in any specific direction,
      // set the player's direction to none.
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
