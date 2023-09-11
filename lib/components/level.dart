import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:topia_adventure/components/collision_block.dart';
import 'package:topia_adventure/components/player.dart';

/// Represents a level in the game world.
class Level extends World {
  final String levelName;
  final Player player;

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  /// Constructs a new Level instance.
  ///
  /// [levelName] - The name of the level.
  /// [player] - The player associated with the level.
  Level({
    required this.levelName,
    required this.player,
  });

  @override
  FutureOr<void> onLoad() async {
    // Load the level from a Tiled file
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );
    add(level);

    // Retrieve the object layer containing spawnpoints
    final spLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    // Iterate through each spawnpoint object
    if (spLayer != null) {
      for (final sp in spLayer.objects) {
        switch (sp.class_) {
          case 'Player':
            // Spawn the player at the spawnpoint
            player.position = Vector2(
              sp.x.toDouble(),
              sp.y.toDouble(),
            );
            add(player);
            break;
          default:
          // Handle other types of spawnpoints
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              isPlatform: true,
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
