/// Represents the hitbox of a player character.
class PlayerHitbox {
  /// The horizontal offset of the hitbox from the player's position.
  final double offsetX;

  /// The vertical offset of the hitbox from the player's position.
  final double offsetY;

  /// The width of the hitbox.
  final double width;

  /// The height of the hitbox.
  final double height;

  /// Constructs a new [PlayerHitbox] instance.
  ///
  /// The [offsetX] and [offsetY] parameters specify the offset of the hitbox
  /// from the player's position. The [width] and [height] parameters specify
  /// the size of the hitbox.
  PlayerHitbox({
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });
}
