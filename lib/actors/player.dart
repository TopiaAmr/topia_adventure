import 'dart:async';

import 'package:flame/components.dart';
import 'package:topia_adventure/topia_adventrure.dart';

enum PlayerState {
  idle,
  running,
}

/// Represents a player in the game.
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<TopiaAdventure> {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;

  // Frame rate of the animation
  final double stepTime = 0.05;

  final String characterName;

  /// Represents a player in the game.
  Player({position, required this.characterName}) : super(position: position);

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
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
}
