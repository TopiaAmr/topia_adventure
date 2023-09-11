import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  final bool isPlatform;

  /// Represents a block that can be collided with.
  ///
  /// The [position] parameter specifies the position of the block.
  /// The [size] parameter specifies the size of the block.
  /// The [isPlatform] parameter indicates whether the block is a platform.
  CollisionBlock({
    required Vector2 position,
    required Vector2 size,
    this.isPlatform = false,
  }) : super(position: position, size: size) {
    // debugMode = true;
  }
}
