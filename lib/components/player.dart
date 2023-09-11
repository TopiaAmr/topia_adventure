import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:topia_adventure/components/collision_block.dart';
import 'package:topia_adventure/components/player_hitbox.dart';
import 'package:topia_adventure/components/utils.dart';
import 'package:topia_adventure/topia_adventrure.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<TopiaAdventure>, KeyboardHandler {
  String characterName;
  Player({
    position,
    this.characterName = 'Ninja Frog',
  }) : super(position: position);

// The time interval between each step
  final double stepTime = 0.05;

// Animation for the idle state
  late final SpriteAnimation idleAnimation;

// Animation for the running state
  late final SpriteAnimation runningAnimation;

// Animation for the jumping state
  late final SpriteAnimation jumpingAnimation;

// Animation for the falling state
  late final SpriteAnimation fallingAnimation;

// Acceleration due to gravity
  final double _gravity = 9.8;

// Force applied when jumping
  final double _jumpForce = 300;

// Maximum velocity when falling
  final double _terminalVelocity = 300;

// Current horizontal movement
  double horizontalMovement = 0;

// Movement speed
  double moveSpeed = 100;

// Current velocity
  Vector2 velocity = Vector2.zero();

// Flag indicating if the player is on the ground
  bool isOnGround = false;

// Flag indicating if the player has jumped
  bool hasJumped = false;

// List of collision blocks
  List<CollisionBlock> collisionBlocks = [];

// Player hitbox
  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    // Load all animations
    _loadAllAnimations();

    // Add rectangle hitbox
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Update player state
    _updatePlayerState();

    // Update player movement
    _updatePlayerMovement(dt);

    // Check horizontal collisions
    _checkHorizontalCollisions();

    // Apply gravity
    _applyGravity(dt);

    // Check vertical collisions
    _checkVerticalCollisions();

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Reset horizontal movement
    horizontalMovement = 0;

    // Check if left or right keys are pressed
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // Update horizontal movement based on key presses
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    // Check if jump key is pressed
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    // Call the super method to handle the event
    return super.onKeyEvent(event, keysPressed);
  }

  /// Loads all the animations for the player.
  void _loadAllAnimations() {
    // Initialize idle animation with 11 frames
    idleAnimation = _spriteAnimation('Idle', 11);

    // Initialize running animation with 12 frames
    runningAnimation = _spriteAnimation('Run', 12);

    // Initialize jumping animation with 1 frame
    jumpingAnimation = _spriteAnimation('Jump', 1);

    // Initialize falling animation with 1 frame
    fallingAnimation = _spriteAnimation('Fall', 1);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
    };

    // Set current animation to idle
    current = PlayerState.idle;
  }

  /// Returns a [SpriteAnimation] based on the given [state] and [amount].
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Main Characters/$characterName/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  /// Updates the player's state based on its velocity.
  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    // Check if falling, set falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    // Check if jumping, set jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  /// Updates the player's movement based on the given delta time ([dt]).
  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    // if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  /// Makes the player jump based on the given delta time ([dt]).
  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    // Iterating through each collision block
    for (final block in collisionBlocks) {
      // Checking if the block is not a platform
      if (!block.isPlatform) {
        // Checking collision between this object and the block
        if (checkCollision(this, block)) {
          // Handling collision when moving to the right
          if (velocity.x > 0) {
            velocity.x = 0;
            // Adjusting position to the left of the block
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          // Handling collision when moving to the left
          if (velocity.x < 0) {
            velocity.x = 0;
            // Adjusting position to the right of the block
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  // Apply gravity to the object's velocity
  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  // Check for vertical collisions with blocks
  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        // Check collision with platform block
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            // Object is moving downwards, stop vertical velocity and position it on top of the platform
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        // Check collision with non-platform block
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            // Object is moving downwards, stop vertical velocity and position it on top of the block
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            // Object is moving upwards, stop vertical velocity and position it below the block
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}
