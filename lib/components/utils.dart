import 'package:topia_adventure/components/collision_block.dart';
import 'package:topia_adventure/components/player.dart';

/// Checks if there is a collision between a player and a collision block.
///
/// Returns `true` if there is a collision, otherwise `false`.
bool checkCollision(Player player, CollisionBlock block) {
  // Get the hitbox of the player
  final hitbox = player.hitbox;

  // Calculate the position of the player
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  // Get the position and size of the collision block
  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  // Calculate the fixed position of the player based on its scale
  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;

  // Calculate the fixed position of the player based on whether the block is a platform
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  // Check if there is a collision between the player and the block
  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
