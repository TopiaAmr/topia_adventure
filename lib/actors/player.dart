import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:topia_adventure/topia_adventrure.dart';

enum PlayerState {
  idle,
  running,
}

enum PlayerDirection {
  left,
  right,
  none,
}

/// Represents a player in the game.
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<TopiaAdventure>, KeyboardHandler {
  /// Represents the idle animation of a sprite.
  late final SpriteAnimation idleAnimation;

  /// Represents the running animation of a sprite.
  late final SpriteAnimation runAnimation;

  /// Frame rate of the animation
  final double stepTime = 0.05;

  //. Define a variable to store the direction of the player.
  PlayerDirection playerDirection = PlayerDirection.none;

  /// Define a variable to store the speed of the player.
  double playerSpeed = 100;

  /// Define a variable to store the velocity of the player.
  Vector2 velocity = Vector2.zero();

  /// Whether player is facing right or not.
  bool isFacingRight = true;

  final String characterName;

  /// Represents a player in the game.
  Player({position, required this.characterName}) : super(position: position);

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Check if the left key or the 'A' key is pressed
    final bool isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);

    // Check if the right key or the 'D' key is pressed
    final bool isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isLeftKeyPressed && isRightKeyPressed) {
      // If both left and right keys are pressed, set the player direction to none
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      // If only the left key is pressed, set the player direction to left
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      // If only the right key is pressed, set the player direction to right
      playerDirection = PlayerDirection.right;
    } else {
      // If no key is pressed, set the player direction to none
      playerDirection = PlayerDirection.none;
    }

    // Call the super method to handle the event
    return super.onKeyEvent(event, keysPressed);
  }

  /// Loads all the animations for the Ninja Frog character.
  void _loadAllAnimations() {
    // Load the idle animation
    idleAnimation = _spriteAnimation('idle', 11);
    runAnimation = _spriteAnimation('run', 12);

    // Define the animations map
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
    };

    // Set the current animation state to idle
    current = PlayerState.idle;
  }

  /// Creates a sprite animation based on the given state and amount.
  ///
  /// The [state] parameter represents the state of the animation (e.g. idle, running, jumping).
  /// The [amount] parameter specifies the number of frames in the animation.
  ///
  /// Returns a `SpriteAnimation` object representing the created animation.
  SpriteAnimation _spriteAnimation(
    String state,
    int amount,
  ) {
    return SpriteAnimation.fromFrameData(
      // Load the image for the idle animation
      game.images.fromCache(
        'Main Characters/$characterName/'
        '${state.replaceFirst(state[0], state[0].toUpperCase())}'
        ' (32x32).png',
      ),
      // Create a sequenced animation with [amount] frames
      SpriteAnimationData.sequenced(
        amount: amount,
        // Set the time between each frame
        stepTime: stepTime,
        // Set the size of each frame
        textureSize: Vector2.all(32),
      ),
    );
  }

  /// Update the player's movement based on the playerDirection.
  ///
  /// The player's movement is updated by modifying the position of the player
  /// based on the playerDirection and the playerSpeed.
  ///
  /// Parameters:
  ///   - dt: The time difference between the current and previous frame.
  void _updatePlayerMovement(double dt) {
    double dx = 0.0;

    // Update the player's movement based on the playerDirection.
    switch (playerDirection) {
      case PlayerDirection.left:
        // If the player is currently facing right, flip horizontally around the center and update the facing direction.
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        dx -= playerSpeed;
        current = PlayerState.running;
        break;
      case PlayerDirection.right:
        // If the player is not currently facing right, flip horizontally around the center and update the facing direction.
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        dx += playerSpeed;
        current = PlayerState.running;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }

    // Update the velocity of the player based on the calculated dx.
    velocity = Vector2(dx, 0);

    // Update the position of the player based on the velocity and dt.
    position += velocity * dt;
  }
}
